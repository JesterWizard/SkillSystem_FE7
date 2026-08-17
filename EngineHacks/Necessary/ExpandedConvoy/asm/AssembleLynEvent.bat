@echo off
SET startDir=C:\devkitPro\devkitARM\bin\
SET as=%startDir%arm-none-eabi-as
SET LYN=C:\devkitPro\lyn.exe

%as% -g -mcpu=arm7tdmi -mthumb-interwork SaveLoadConvoy.s -o SaveLoadConvoy.elf
%LYN% SaveLoadConvoy.elf > SaveLoadConvoy.lyn.event
del SaveLoadConvoy.elf
