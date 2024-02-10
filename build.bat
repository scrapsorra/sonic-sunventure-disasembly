@echo off

IF EXIST sunventure.bin move /Y sunventure.bin sunventure.prev.bin >NUL
.build\asm68k /o  op+ /o os+ /o ow+ /o oz+ /o oaq+ /o osq+ /o omq+ /p /o ae- sonic.asm, sunventure.bin >.build\log\sunventure.log, .build\log\sonic.sym, .build\log\sonic.lst
.build\convsym .build\log\sonic.lst sunventure.bin -input asm68k_lst -inopt "/localSign=@ /localJoin=. /ignoreMacroDefs+ /ignoreMacroExp- /addMacrosAsOpcodes+" -a
.build\fixheadr.exe sunventure.bin
type .build\log\sunventure.log
pause