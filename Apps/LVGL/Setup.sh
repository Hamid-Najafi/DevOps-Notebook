# sudo apt update && sudo apt-get install -y git software-properties-common libreadline-dev libffi-dev git pkg-config libsdl2-2.0-0 parallel
#* ==== HDMI Display Settings ==== *# 
hdmi_group=2
hdmi_mode=87
hdmi_cvt 800 480 60 6 0 0 0
hdmi_drive=1

#* ==== PC simulator project for LVGL embedded GUI Library. ==== *# 
#* Install Libs
sudo apt-get update && sudo apt-get install -y git build-essential gcc g++ gdb libsdl2-dev cmake

#* Clone LVGL Simulator repo
git clone --recursive https://github.com/lvgl/lv_port_pc_eclipse.git
cd lv_port_pc_eclipse

#* Make a new directory. The name doesn't matter 
mkdir build && cd build 

#* Set Display Resolution
nano ../lv_drv_conf.h 
#  define SDL_HOR_RES     800
#  define SDL_VER_RES     48

#* Compile and build *# CMake will generate the appropriate build files.
cmake ..

#* Build Application
make -j4 
cmake --build . --parallel

#* Run the Application built using
./../build/bin/main


#* ==== Micropython bindings to LVGL for Embedded devices, Unix and JavaScript ==== *# 
#* Install Libs
sudo apt-get update && sudo apt-get install -y git build-essential gcc g++ gdb libsdl2-dev cmake

#* Clone lv_micropython repo
git clone https://github.com/lvgl/lv_micropython.git
cd lv_micropython
git submodule update --init --recursive lib/lv_bindings
make -C mpy-cross
make -C ports/unix submodules
make -C ports/unix
# ./ports/unix/micropython


#* ==== Autostart Service ==== *# 
cat > /etc/systemd/system/app.service << "EOF"
[Unit]
Description=LVGL App

[Service]
Type=idle
# ExecStart=/bin/sh -c '~/lv_micropython/ports/unix/micropython ~/lv_micropython/b.py'
ExecStart=/bin/sh -c '~/lv_port_pc_eclipse/build/bin/main'
Restart=always
User=pi
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable app
sudo systemctl start app

sudo journalctl -u app.service -f