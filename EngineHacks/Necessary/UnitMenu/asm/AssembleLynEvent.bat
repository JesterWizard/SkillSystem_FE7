@echo off
SET startDir="C:\devkitPro\devkitARM\bin\"
SET as="%startDir%arm-none-eabi-as"
SET LYN="C:\devkitPro\lyn.exe"

%as% -g -mcpu=arm7tdmi -mthumb-interwork %1 -o "%~n1.elf"
%LYN% "%~n1.elf" > "%~n1.lyn.event"
del "%~n1.elf"
