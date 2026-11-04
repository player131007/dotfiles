pci_vd() {
    pci_addr="$1"
    printf "%s" "$(</sys/bus/pci/devices/"$pci_addr"/vendor) $(</sys/bus/pci/devices/"$pci_addr"/device)"
}

vfio_bind() {
    modprobe vfio-pci
    for dev in "$@"; do
        [ -e /sys/bus/pci/devices/"$dev"/driver ] \
            && printf "%s" "$dev" > /sys/bus/pci/devices/"$dev"/driver/unbind
        pci_vd "$dev" > /sys/bus/pci/drivers/vfio-pci/new_id
    done
}

vfio_unbind() {
    for dev in "$@"; do
        pci_vd "$dev" > /sys/bus/pci/drivers/vfio-pci/remove_id
        echo 1 > /sys/bus/pci/devices/"$dev"/remove
    done
    echo 1 > /sys/bus/pci/rescan
}

if [ $# -lt 2 ]; then
    echo "Usage: $0 bind/unbind [pci-address...]" >&2
    exit 1
fi

vfio_"$@"
