@echo off

IF EXIST sunventure.bin move /Y sunventure.bin sunventure.prev.bin >NUL
asm68k /o op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /p /o ae- sonic.asm, sunventure.bin >errors.txt, sonic.sym, sonic.lst
convsym sonic.lst sunventure.bin -input asm68k_lst -inopt "/localSign=@ /localJoin=. /ignoreMacroDefs+ /ignoreMacroExp- /addMacrosAsOpcodes+" -a
fixheadr.exe sunventure.bin
pause