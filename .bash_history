cat README.md
./build.sh -m rpi5 --debug core-image-minimal -k
ls
wget https://hailo-hailort.s3.eu-west-2.amazonaws.com/hailo-hailort/CrossProducts/5.3.0/tokenizers_cpp.tar.gz
./build.sh -m rpi5 --debug pakcagegroup-hailo-hailort -e > output.sh
exit
./build.sh -m rpi5 --debug --update
rm -rf targets/rpi5.lock.yml 
./build.sh -m rpi5 --debug --update
./build.sh -m rpi5 --debug pakcagegroup-hailo-hailort -e > output.sh
./build.sh -m rpi5 --debug -b bitbake pakcagegroup-hailo-hailort
./build.sh -m rpi5 --debug -b bitbake packagegroup-hailo-hailort -e >output.sh
./build.sh -m rpi5 --debug -b bitbake core-image-minimal
grep -r "WORKDIR" sources/meta-hailo/
./build.sh -m rpi5 --debug --update
./build.sh -m rpi5 --debug -b bitbake core-image-minimal
./build.sh -m rpi5 --debug -b bitbake hailo-pci -c cleanall
./build.sh -m rpi5 --debug -b bitbake hailo-pci -c unpack
./build.sh -m rpi5 --debug -b bitbake hailo-pci
./build.sh -m rpi5 --debug -b bitbake core-image-minimal -k
./build.sh -m rpi5 --debug -b bitbake-getvar -r libhailort BUILDDIR
./build.sh -m rpi5 --debug -b bitbake libhailort -e > output.sh
./build.sh -m rpi5 --debug -b bitbake libhailort
grep -r "module" sources/meta-hailo/
./build.sh -m rpi5 --debug -b bitbake hailo-pci -e >output.sh
./build.sh -m rpi5 --debug -b bitbake hailo-pci
cat /yocto/build_rpi5/tmp/work/raspberrypi5-oe-linux/hailo-pci/5.3.0/sources/hailo-pci-5.3.0/linux/pci/../../LICENSE
ls /yocto/build_rpi5/tmp/work/raspberrypi5-oe-linux/hailo-pci/5.3.0/sources/hailo-pci-5.3.0/linux/pcie/
./build.sh -m rpi5 --debug -b bitbake hailo-pci
./build.sh -m rpi5 --debug -b bitbake core-image-minimal -k
