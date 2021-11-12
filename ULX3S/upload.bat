FT_Prog-CmdLine.exe scan prog 0 ULX3S.xml cycl 0
fujprog ulx3s_12f_passthru.bit
esptool --chip esp32 --port COM10 erase_flash
esptool --chip esp32 --port COM10 --baud 460800 write_flash -z 0x1000 esp32spiram-20210418-v1.15.bin
fujprog -j flash ulx3s_v20_85f_f32c_selftest_100mhz_flash.img
