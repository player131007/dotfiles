vm_name="windoes"
memory_size="8G"
data_dir="${XDG_DATA_HOME:-${HOME}/.local/share}/${vm_name}"
runtime_dir="${XDG_RUNTIME_DIR}/${vm_name}"

mkdir -p "$data_dir" "$runtime_dir"

if [ -e "${runtime_dir}/windoes.pid" ]; then
    echo "windoes already running"
    exit 1
fi
echo $$ > "${runtime_dir}/windoes.pid"
trap 'rm "${runtime_dir}"/{*.sock,windoes.pid}' EXIT

disk="${data_dir}/disk.qcow2"
if [ ! -f "$disk" ]; then
    echo "no disk found. you should create one at $disk or something"
    exit 1
fi

uefi_vars="${data_dir}/vars.fd"
if [ ! -f "$uefi_vars" ]; then
    cp --no-preserve=all --verbose -- "${QEMU}/share/qemu/edk2-i386-vars.fd" "$uefi_vars"
fi

virtiofs0_socket="${runtime_dir}/virtiofs0.sock"
unshare -r --map-auto -- virtiofsd --socket-path="$virtiofs0_socket" --shared-dir /d/windows --sandbox chroot 2>"${runtime_dir}/virtiofs0.log" &

spice_socket="${runtime_dir}/spice.sock"
# shellcheck disable=SC2054 # qemu uses commas, not me
qemu_flags=(
    # misc stuff
    -name "$vm_name"
    -machine pc-q35-11.1 # maybe bump when reinstall
    -accel kvm
    -monitor stdio
    -rtc base=localtime
    -display gtk,show-cursor=on

    # cpu
    -cpu host,topoext,hv_relaxed,hv_vapic,hv_spinlocks=0xfff,hv_vpindex,hv_runtime,hv_time,hv_synic,hv_stimer,hv_tlbflush,hv_ipi,hv_frequencies,hv_stimer_direct,hv_xmm_input,hv_tlbflush_ext
    -smp cores=3,threads=2

    # memory
    -m "$memory_size"

    # virtiofsd
    -object memory-backend-memfd,id=mem,size="$memory_size",share=on
    -numa node,memdev=mem
    -chardev socket,id=virtiofs0,path="$virtiofs0_socket"
    -device vhost-user-fs-pci,chardev=virtiofs0,tag=d

    # spice
    -spice unix=on,addr="$spice_socket",disable-ticketing=on
    -device virtio-serial-pci
    -device virtserialport,chardev=spice0,name=com.redhat.spice.0
    -chardev spicevmc,id=spice0,name=vdagent
    -vga qxl

    # audio
    -device ich9-intel-hda
    -device hda-output,audiodev=audio0
    -audiodev spice,id=audio0

    # self-explanatory
    -device virtio-keyboard-pci
    -device virtio-mouse-pci
    -nic passt,model=virtio-net-pci

    # main disk
    -device virtio-scsi-pci,id=scsi0,num_queues=6
    -device scsi-hd,drive=hda
    -drive id=hda,if=none,file="${disk}"

    # uefi stuff
    -drive if=pflash,format=raw,readonly=on,file="${QEMU}"/share/qemu/edk2-x86_64-code.fd
    -drive if=pflash,format=raw,file="${uefi_vars}"

    -device ivshmem-plain,id=shmem0,memdev=looking-glass
    -object memory-backend-file,id=looking-glass,mem-path=/dev/kvmfr0,size="$kvmfr_size"M,share=yes
)

qemu-system-x86_64 "${qemu_flags[@]}" "$@"

wait -f
