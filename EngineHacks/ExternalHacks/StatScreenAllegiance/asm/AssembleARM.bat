@echo off
SET startDir=C:\devkitPro\devkitARM\bin\
SET as="%startDir%arm-none-eabi-as"
SET objcopy="%startDir%arm-none-eabi-objcopy"
%as% -g -mcpu=arm7tdmi -mthumb-interwork %1 -o "%~n1.elf"
%objcopy% -S "%~n1.elf" -O binary "%~n1.dmp"
echo y | del "%~n1.elf"
