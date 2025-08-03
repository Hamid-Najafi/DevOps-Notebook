# -------==========-------
# QEMU
# -------==========-------
sudo dnf install -y ninja-build pixman-devel.x86_64 wget 
cd /home/fedora/
git clone https://gitlab.com/qemu-project/qemu.git
cd qemu
git submodule update --init --recursive
./configure --enable-gtk --enable-sdl --target-list=x86_64-softmmu --disable-werror --disable-stack-protector
make -j4
/home/fedora/qemu-7.2.0/build/qemu-system-x86_64 --version