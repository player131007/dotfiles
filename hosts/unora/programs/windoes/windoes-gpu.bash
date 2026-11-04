plug_gpu() {
    echo "plugging your gpu"
    run0 vfio-helper unbind "$gpu" "$aud"
}

if nvidia-smi -i "$gpu" --query --xml-format | xq -e ".nvidia_smi_log.gpu.processes" >/dev/null; then
    echo "uh oh your gpu is in use"
    nvidia-smi -i "$gpu" --query --display=PIDS
    exit 1
fi

echo "unplugging your gpu"
run0 vfio-helper "bind" "$gpu" "$aud"
trap plug_gpu EXIT

windoes -display none -device vfio-pci,host="$gpu" -device vfio-pci,host="$aud" "$@"
