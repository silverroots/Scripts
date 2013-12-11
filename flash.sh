sudo ~/scripts/fastboot flash cdt.bin cdt.bin

sudo ~/scripts/fastboot erase cache

sudo ~/scripts/fastboot flash logo.bin logo.bin

sudo ~/scripts/fastboot flash ebr ebr

sudo ~/scripts/fastboot flash mbr mbr

sudo ~/scripts/fastboot flash devtree device_tree.bin

sudo ~/scripts/fastboot flash boot boot.img

sudo ~/scripts/fastboot flash system system.img

sudo ~/scripts/fastboot flash recovery recovery.img

sudo ~/scripts/fastboot flash radio radio.img

sudo ~/scripts/fastboot erase userdata

sudo ~/scripts/fastboot reboot
