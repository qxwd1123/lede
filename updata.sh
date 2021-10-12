#!/bin/env sh
until git pull --no-edit; do
    sleep 5
done
until for d in $(find ./feeds -maxdepth 1 -mindepth 1 -type d ! -name '*tmp'); do pushd $d; git pull --no-edit --rebase=true; popd; done; do
    sleep 5
done
until ./scripts/feeds update -a; do
    sleep 5
done
until ./scripts/feeds install -a; do
    sleep 5
done
make V=sc -j1 2>&1 | tee compile.log

#cp ./bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined-efi.vhdx /mnt/e/Temp/openwrt-x86-64-generic-squashfs-combined.vhdx
scp -P11221 ./bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz root@zz.hs.vc:/var/lib/vz/template/iso
scp -P11220 ./bin/targets/x86/64/openwrt-x86-64-generic-squashfs-combined.img.gz root@zz.hs.vc:/tmp
