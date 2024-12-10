# i forgor :skull:

## Preparation

- [ ] Get a windows 10 iso [here](https://massgrave.dev/genuine-installation-media)
- [ ] Get a virtio-win iso [here](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio)
- [ ] Get winfsp
- [ ] Get virtual display driver (needed for looking glass) [here](https://github.com/VirtualDisplay/Virtual-Display-Driver)
- [ ] Get looking-glass b7-rc1
- [ ] Get the winutil script [here](https://christitus.com/win)
- [ ] Remove the chocolatey installation part
- [ ] Create a disk image at `/windows/win10.qcow2`:
```sh
qemu-img create -f qcow2 -o compression_type=zstd,nocow=on /windows/win10.qcow2 69G
```

## Installing

- [ ] Do not add internet
- [ ] Boot with the windows iso
- [ ] Add virtio drivers
- [ ] Install normally

## Post-installation

- [ ] oobe
- [ ] change your time zone
- [ ] install virtio tools
- [ ] install winfsp
- [ ] set virtiofs service to automatic
- [ ] tweak stuff with winutil
- [ ] disable all updates
- [ ] disable delivery optimization
- [ ] disable/remove windows defender
- [ ] remove microsoft edge
- [ ] install virtual display driver
- [ ] install looking glass
- [ ] add internet
- [ ] activate windows
- [ ] install nvidia drivers with nvcleanstall
- [ ] install bloxstrap [here](https://github.com/bloxstraplabs/bloxstrap)
- [ ] install roblox account manager (remember to add games and account)

## Post-post-installation

- [ ] is your vm off?
- [ ] convert the image? idk this will be your base image:
```sh
qemu-img convert -O qcow2 -o nocow=on,compression_type=zstd /windows/win10.qcow2 /windows/base.qcow2
rm /windows/win10.qcow2
```
- [ ] create a new image:
```sh
qemu-img create -f qcow2 -o compression_type=zstd -b /windows/base.qcow2 /windows/win10.qcow2
```
- [ ] every time you want a reset, just delete win10.qcow2 and create it again
- [ ] in case you want to commit changes:
```sh
qemu-img commit /windows/win10.qcow2
```
