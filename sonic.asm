;  =========================================================================
; |           Sonic the Hedgehog Disassembly for Sega Mega Drive            |
;  =========================================================================
;
; Disassembly created by Hivebrain
; thanks to drx, Stealth and Esrael L.G. Neto

; ===========================================================================

	include	"_s1smps2asm_inc.asm"
	include	"Constants.asm"
	include	"Variables.asm"
	include	"Macros.asm"
	include "Debugger.asm"

; ===========================================================================
; flags & shit
; ===========================================================================
GameIsPlayable:	equ 0	; =P
SRAMEnabled:	equ 1	; change to 1 to enable SRAM
BackupSRAM:		equ 1
AddressSRAM:	equ 3	; 0 = odd+even; 2 = even only; 3 = odd only

; Change to 0 to build the original version of the game, dubbed REV00
; Change to 1 to build the later vesion, dubbed REV01, which includes various bugfixes and enhancements
; Change to 2 to build the version from Sonic Mega Collection, dubbed REVXB, which fixes the infamous "spike bug"
Revision:	equ 2

ZoneCount:	equ 6	; discrete zones are: GHZ, MZ, SYZ, LZ, SLZ, and SBZ

OptimiseSound:	equ 0	; change to 1 to optimise sound queuing

; ===========================================================================

StartOfRom:
Vectors:	dc.l v_systemstack&$FFFFFF	; Initial stack pointer value
		dc.l EntryPoint			; Start of program
		dc.l BusError			; Bus error
		dc.l AddressError		; Address error (4)
		dc.l IllegalInstr		; Illegal instruction
		dc.l ZeroDivide			; Division by zero
		dc.l ChkInstr			; CHK exception
		dc.l TrapvInstr			; TRAPV exception (8)
		dc.l PrivilegeViol		; Privilege violation
		dc.l Trace				; TRACE exception
		dc.l Line1010Emu		; Line-A emulator
		dc.l Line1111Emu		; Line-F emulator (12)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (16)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (20)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved)
		dc.l ErrorExcept		; Unused (reserved) (24)
		dc.l ErrorExcept		; Spurious exception
		dc.l ErrorTrap			; IRQ level 1
		dc.l ErrorTrap			; IRQ level 2
		dc.l ErrorTrap			; IRQ level 3 (28)
		dc.l HBlank				; IRQ level 4 (horizontal retrace interrupt)
		dc.l ErrorTrap			; IRQ level 5
		dc.l VBlank				; IRQ level 6 (vertical retrace interrupt)
		dc.l ErrorTrap			; IRQ level 7 (32)
		dc.l ErrorTrap			; TRAP #00 exception
		dc.l ErrorTrap			; TRAP #01 exception
		dc.l ErrorTrap			; TRAP #02 exception
		dc.l ErrorTrap			; TRAP #03 exception (36)
		dc.l ErrorTrap			; TRAP #04 exception
		dc.l ErrorTrap			; TRAP #05 exception
		dc.l ErrorTrap			; TRAP #06 exception
		dc.l ErrorTrap			; TRAP #07 exception (40)
		dc.l ErrorTrap			; TRAP #08 exception
		dc.l ErrorTrap			; TRAP #09 exception
		dc.l ErrorTrap			; TRAP #10 exception
		dc.l ErrorTrap			; TRAP #11 exception (44)
		dc.l ErrorTrap			; TRAP #12 exception
		dc.l ErrorTrap			; TRAP #13 exception
		dc.l ErrorTrap			; TRAP #14 exception
		dc.l ErrorTrap			; TRAP #15 exception (48)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
	if Revision<>2
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
		dc.l ErrorTrap			; Unused (reserved)
	else
loc_E0:
		; Relocated code from Spik_Hurt. REVXB was a nasty hex-edit.
		move.l	obY(a0),d3
		move.w	obVelY(a0),d0
		ext.l	d0
		asl.l	#8,d0
		jmp	(loc_D5A2).l

		dc.w ErrorTrap
		dc.l ErrorTrap
		dc.l ErrorTrap
		dc.l ErrorTrap
	endif
Console1:	dc.b "SEGA MEGA DRIVE " ; Hardware system ID (Console name)
Date:		dc.b "(C)SEGA 1991.APR" ; Copyright holder and release date (generally year)
Title_Local:	dc.b "SONIC SUNVENTURE                                " ; Domestic name
Title_Int:	dc.b "SONIC SUNVENTURE                                " ; International name
Serial:		if Revision=0
		dc.b "GM 00001009-00"   ; Serial/version number (Rev 0)
		else
			dc.b "GM 00004049-01" ; Serial/version number (Rev non-0)
		endc
Checksum: dc.w $0
		dc.b "J               " ; I/O support
RomStartLoc:	dc.l StartOfRom		; Start address of ROM
RomEndLoc:	dc.l EndOfRom-1		; End address of ROM
RamStartLoc:	dc.l $FF0000		; Start address of RAM
RamEndLoc:	dc.l $FFFFFF		; End address of RAM
SRAMSupport:	if SRAMEnabled=1
		dc.b 'RA',$F8,$20    ; SRAM type
		else
		dc.l $20202020
		endc
		dc.l $200000		; SRAM start
		dc.l $2001FF		; SRAM end
Notes:		dc.b "                                                    " ; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
Region:		dc.b "JUE             " ; Region (Country code)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000. Unlike Sonic 2, Sonic 1 uses the 68000 for playing music, so it stops too

ErrorTrap:
		nop	
		nop	
		bra.s	ErrorTrap
; ===========================================================================

EntryPoint:
		tst.l	(z80_port_1_control).l ; test port A & B control registers
		bne.s	PortA_Ok
		tst.w	(z80_expansion_control).l ; test port C control register

PortA_Ok:
		bne.w	SkipSetup ; Skip the VDP and Z80 setup code if port A, B or C is ok...?
		lea	SetupValues(pc),a5	; Load setup values array address.
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	-$10FF(a1),d0	; get hardware version (from $A10001)
		andi.b	#$F,d0
		beq.s	SkipSecurity	; If the console has no TMSS, skip the security stuff.
		move.l	#'SEGA',$2F00(a1) ; move "SEGA" to TMSS register ($A14000)

SkipSecurity:
		move.w	(a4),d0	; clear write-pending flag in VDP to prevent issues if the 68k has been reset in the middle of writing a command long word to the VDP.
		moveq	#0,d0	; clear d0
		movea.l	d0,a6	; clear a6
		move.l	a6,usp	; set usp to $0

		moveq	#$17,d1
VDPInitLoop:
		move.b	(a5)+,d5	; add $8000 to value
		move.w	d5,(a4)		; move value to	VDP register
		add.w	d7,d5		; next register
		dbf	d1,VDPInitLoop
		
		move.l	(a5)+,(a4)
		move.w	d0,(a3)		; clear	the VRAM
		move.w	d7,(a1)		; stop the Z80
		move.w	d7,(a2)		; reset	the Z80

WaitForZ80:
		btst	d0,(a1)		; has the Z80 stopped?
		bne.s	WaitForZ80	; if not, branch

		moveq	#$25,d2
Z80InitLoop:
		move.b	(a5)+,(a0)+
		dbf	d2,Z80InitLoop
		
		move.w	d0,(a2)
		move.w	d0,(a1)		; start	the Z80
		move.w	d7,(a2)		; reset	the Z80

ClrRAMLoop:
		move.l	d0,-(a6)	; clear 4 bytes of RAM
		dbf	d6,ClrRAMLoop	; repeat until the entire RAM is clear
		move.l	(a5)+,(a4)	; set VDP display mode and increment mode
		move.l	(a5)+,(a4)	; set VDP to CRAM write

		moveq	#$1F,d3	; set repeat times
ClrCRAMLoop:
		move.l	d0,(a3)	; clear 2 palettes
		dbf	d3,ClrCRAMLoop	; repeat until the entire CRAM is clear
		move.l	(a5)+,(a4)	; set VDP to VSRAM write

		moveq	#$13,d4
ClrVSRAMLoop:
		move.l	d0,(a3)	; clear 4 bytes of VSRAM.
		dbf	d4,ClrVSRAMLoop	; repeat until the entire VSRAM is clear
		moveq	#3,d5

PSGInitLoop:
		move.b	(a5)+,$11(a3)	; reset	the PSG
		dbf	d5,PSGInitLoop	; repeat for other channels
		move.w	d0,(a2)
		movem.l	(a6),d0-a6	; clear all registers
		disable_ints

InitSRAM: ; could have been done more cleanly
        enableSRAM
        lea ($200000).l,a0

        movep.l $DD(a0),d0 ; where the "FUCK" should be
        move.l  #"FUCK",d1

		cmp.l   d0,d1 ; reset SRAM if there's no "FUCK"
        beq.s   @Continue

		move.b 	#0,SavedColor(a0)	; clear settings
		move.b 	#0,SavedCamera(a0)
		move.b	#$FF,SavedZone(a0)
		move.b	#3,SavedLives(a0)

        move.l  #" OUT",d2 ; the rest of the string (lol)
        move.l  #"TA M",d3
        move.l  #"Y SR",d4
        move.l  #"AM  ",d5

        movep.l d1,$DD(a0) ; save the string
        movep.l d2,$E5(a0)
        movep.l d3,$ED(a0)
        movep.l d4,$F5(a0)
        movep.l d5,$FD(a0)

@Continue:
        disableSRAM

SkipSetup:
		bra.s	GameProgram	; begin game

; ===========================================================================
SetupValues:	dc.w $8000		; VDP register start number
		dc.w $3FFF		; size of RAM/4
		dc.w $100		; VDP register diff

		dc.l z80_ram		; start	of Z80 RAM
		dc.l z80_bus_request	; Z80 bus request
		dc.l z80_reset		; Z80 reset
		dc.l vdp_data_port	; VDP data
		dc.l vdp_control_port	; VDP control

		dc.b 4			; VDP $80 - 8-colour mode
		dc.b $14		; VDP $81 - Megadrive mode, DMA enable
		dc.b ($C000>>10)	; VDP $82 - foreground nametable address
		dc.b ($F000>>10)	; VDP $83 - window nametable address
		dc.b ($E000>>13)	; VDP $84 - background nametable address
		dc.b ($D800>>9)		; VDP $85 - sprite table address
		dc.b 0			; VDP $86 - unused
		dc.b 0			; VDP $87 - background colour
		dc.b 0			; VDP $88 - unused
		dc.b 0			; VDP $89 - unused
		dc.b 255		; VDP $8A - HBlank register
		dc.b 0			; VDP $8B - full screen scroll
		dc.b $81		; VDP $8C - 40 cell display
		dc.b ($DC00>>10)	; VDP $8D - hscroll table address
		dc.b 0			; VDP $8E - unused
		dc.b 1			; VDP $8F - VDP increment
		dc.b 1			; VDP $90 - 64 cell hscroll size
		dc.b 0			; VDP $91 - window h position
		dc.b 0			; VDP $92 - window v position
		dc.w $FFFF		; VDP $93/94 - DMA length
		dc.w 0			; VDP $95/96 - DMA source
		dc.b $80		; VDP $97 - DMA fill VRAM
		dc.l $40000080		; VRAM address 0

		dc.b $AF		; xor	a
		dc.b $01, $D9, $1F	; ld	bc,1fd9h
		dc.b $11, $27, $00	; ld	de,0027h
		dc.b $21, $26, $00	; ld	hl,0026h
		dc.b $F9		; ld	sp,hl
		dc.b $77		; ld	(hl),a
		dc.b $ED, $B0		; ldir
		dc.b $DD, $E1		; pop	ix
		dc.b $FD, $E1		; pop	iy
		dc.b $ED, $47		; ld	i,a
		dc.b $ED, $4F		; ld	r,a
		dc.b $D1		; pop	de
		dc.b $E1		; pop	hl
		dc.b $F1		; pop	af
		dc.b $08		; ex	af,af'
		dc.b $D9		; exx
		dc.b $C1		; pop	bc
		dc.b $D1		; pop	de
		dc.b $E1		; pop	hl
		dc.b $F1		; pop	af
		dc.b $F9		; ld	sp,hl
		dc.b $F3		; di
		dc.b $ED, $56		; im1
		dc.b $36, $E9		; ld	(hl),e9h
		dc.b $E9		; jp	(hl)

		dc.w $8104		; VDP display mode
		dc.w $8F02		; VDP increment
		dc.l $C0000000		; CRAM write mode
		dc.l $40000010		; VSRAM address 0

		dc.b $9F, $BF, $DF, $FF	; values for PSG channel volumes
; ===========================================================================

GameProgram:
		tst.w	(vdp_control_port).l
		btst	#6,($A1000D).l
		beq.s	CheckSumCheck
		cmpi.l	#'init',(v_init).w ; has checksum routine already run?
		beq.w	GameInit	; if yes, branch

CheckSumCheck:
		movea.l	#EndOfHeader,a0	; start	checking bytes after the header	($200)
		movea.l	#RomEndLoc,a1	; stop at end of ROM
		move.l	(a1),d0
		moveq	#0,d1

	@loop:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bhs.s	@loop
		movea.l	#Checksum,a1	; read the checksum
		cmp.w	(a1),d1		; compare checksum in header to ROM
		bne.w	CheckSumError	; if they don't match, branch

	CheckSumOk:
		lea	($FFFFFE00).w,a6
		moveq	#0,d7
		move.w	#$7F,d6
	@clearRAM:
		move.l	d7,(a6)+
		dbf	d6,@clearRAM	; clear RAM ($FE00-$FFFF)

		move.b	(z80_version).l,d0
		andi.b	#$C0,d0
		move.b	d0,(v_megadrive).w ; get region setting
		move.l	#'init',(v_init).w ; set flag so checksum won't run again

GameInit:
		lea	($FF0000).l,a6
		moveq	#0,d7
		move.w	#$3F7F,d6
	@clearRAM:
		move.l	d7,(a6)+
		dbf	d6,@clearRAM	; clear RAM ($0000-$FDFF)
        	bsr.w	InitDMAQueue
		bsr.w	VDPSetupGame
		bsr.w	SoundDriverLoad
		bsr.w	JoypadInit
		move.b	#id_Sega,(v_gamemode).w ; set Game Mode to Sega Screen

MainGameLoop:
		bsr.w	ReadJoypads
		move.b	(v_gamemode).w,d0 ; load Game Mode
		andi.w	#$7C,d0	; limit Game Mode value to $1C max (change to a maximum of 7C to add more game modes)
		movea.l	GameModeArray(pc,d0.w),a0 ; jump to apt location in ROM
		jsr		(a0)
		bra.s	MainGameLoop	; loop indefinitely
; ===========================================================================
; ---------------------------------------------------------------------------
; Main game mode array
; ---------------------------------------------------------------------------

GameModeArray:
ptr_GM_Sega:		dc.l	GM_Sega		; Sega Screen ($00)
ptr_GM_Title:		dc.l	GM_Title	; Title	Screen ($04)
ptr_GM_Demo:		dc.l	GM_Level	; Demo Mode ($08)
ptr_GM_Level:		dc.l	GM_Level	; Normal Level ($0C)
ptr_GM_Special:		dc.l	GM_Special	; Special Stage	($10)
ptr_GM_Cont:		dc.l	GM_Continue	; Continue Screen ($14)
ptr_GM_Ending:		dc.l	GM_Ending	; End of game sequence ($18)
ptr_GM_Credits:		dc.l	GM_Credits	; Credits ($1C)
ptr_GM_MenuScreen:	dc.l	MenuScreen	; Credits ($20)
		rts	
; ===========================================================================

CheckSumError:
		bsr.w	VDPSetupGame
		move.l	#$C0000000,(vdp_control_port).l ; set VDP to CRAM write
		moveq	#$3F,d7

	@fillred:
		move.w	#cRed,(vdp_data_port).l ; fill palette with red
		dbf	d7,@fillred	; repeat $3F more times

	@endlessloop:
		bra.s	@endlessloop
; ===========================================================================


; ===========================================================================

loc_43A:
		disable_ints
		addq.w	#2,sp
		move.l	(sp)+,(v_spbuffer).w
		addq.w	#2,sp
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		bsr.w	ShowErrorValue
		move.l	(v_spbuffer).w,d0
		bsr.w	ShowErrorValue
		bra.s	loc_478
; ===========================================================================

loc_462:
		disable_ints
		movem.l	d0-a7,(v_regbuffer).w
		bsr.w	ShowErrorMessage
		move.l	2(sp),d0
		bsr.w	ShowErrorValue

loc_478:
		bsr.w	ErrorWaitForC
		movem.l	(v_regbuffer).w,d0-a7
		enable_ints
		rte	

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ShowErrorMessage:
		lea	(vdp_data_port).l,a6
		locVRAM	$F800
		lea	(Art_Text).l,a0
		move.w	#$27F,d1
	@loadgfx:
		move.w	(a0)+,(a6)
		dbf	d1,@loadgfx

		moveq	#0,d0		; clear	d0
		move.b	(v_errortype).w,d0 ; load error code
		move.w	ErrorText(pc,d0.w),d0
		lea	ErrorText(pc,d0.w),a0
		locVRAM	(vram_fg+$604)
		moveq	#$12,d1		; number of characters (minus 1)

	@showchars:
		moveq	#0,d0
		move.b	(a0)+,d0
		addi.w	#$790,d0
		move.w	d0,(a6)
		dbf	d1,@showchars	; repeat for number of characters
		rts	
; End of function ShowErrorMessage

; ===========================================================================
ErrorText:	dc.w @exception-ErrorText, @bus-ErrorText
		dc.w @address-ErrorText, @illinstruct-ErrorText
		dc.w @zerodivide-ErrorText, @chkinstruct-ErrorText
		dc.w @trapv-ErrorText, @privilege-ErrorText
		dc.w @trace-ErrorText, @line1010-ErrorText
		dc.w @line1111-ErrorText
@exception:	dc.b "ERROR EXCEPTION    "
@bus:		dc.b "BUS ERROR          "
@address:	dc.b "ADDRESS ERROR      "
@illinstruct:	dc.b "ILLEGAL INSTRUCTION"
@zerodivide:	dc.b "@ERO DIVIDE        "
@chkinstruct:	dc.b "CHK INSTRUCTION    "
@trapv:		dc.b "TRAPV INSTRUCTION  "
@privilege:	dc.b "PRIVILEGE VIOLATION"
@trace:		dc.b "TRACE              "
@line1010:	dc.b "LINE 1010 EMULATOR "
@line1111:	dc.b "LINE 1111 EMULATOR "
		even

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ShowErrorValue:
		move.w	#$7CA,(a6)	; display "$" symbol
		moveq	#7,d2

	@loop:
		rol.l	#4,d0
		bsr.s	@shownumber	; display 8 numbers
		dbf	d2,@loop
		rts	
; End of function ShowErrorValue


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


@shownumber:
		move.w	d0,d1
		andi.w	#$F,d1
		cmpi.w	#$A,d1
		blo.s	@chars0to9
		addq.w	#7,d1		; add 7 for characters A-F

	@chars0to9:
		addi.w	#$7C0,d1
		move.w	d1,(a6)
		rts	
; End of function sub_5CA


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ErrorWaitForC:
		bsr.w	ReadJoypads
		cmpi.b	#btnC,(v_jpadpress1).w ; is button C pressed?
		bne.w	ErrorWaitForC	; if not, branch
		rts
; End of function ErrorWaitForC

; ===========================================================================

Art_Text:	incbin	"artunc\menutext.bin" ; text used in level select and debug mode
		even

; ---------------------------------------------------------------------------
; Vertical interrupt
; ---------------------------------------------------------------------------

VBlank:
		movem.l	d0-a6,-(sp)
		tst.b	(v_vbla_routine).w
		beq.s	VBla_00
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l ; send screen y-axis pos. to VSRAM
		btst	#6,(v_megadrive).w ; is Megadrive PAL?
		beq.s	@notPAL		; if not, branch

		move.w	#$700,d0
	@waitPAL:
		dbf	d0,@waitPAL ; wait here in a loop doing nothing for a while...

	@notPAL:
		move.b	(v_vbla_routine).w,d0
		move.b	#0,(v_vbla_routine).w
		move.w	#1,(f_hbla_pal).w
		andi.w	#$3E,d0
		move.w	VBla_Index(pc,d0.w),d0
		jsr	VBla_Index(pc,d0.w)

VBla_Music:
		jsr	(UpdateMusic).l

VBla_Exit:
		addq.l	#1,(v_vbla_count).w
		movem.l	(sp)+,d0-a6
		rte
; ===========================================================================
VBla_Index:	dc.w VBla_00-VBla_Index, VBla_02-VBla_Index
		dc.w VBla_04-VBla_Index, VBla_06-VBla_Index
		dc.w VBla_08-VBla_Index, VBla_0A-VBla_Index
		dc.w VBla_0C-VBla_Index, VBla_0E-VBla_Index
		dc.w VBla_10-VBla_Index, VBla_12-VBla_Index
		dc.w VBla_14-VBla_Index, VBla_16-VBla_Index
		dc.w VBla_0C-VBla_Index
; ===========================================================================

VBla_00:
		cmpi.b	#$80+id_Level,(v_gamemode).w
		beq.s	@islevel
		cmpi.b	#id_Level,(v_gamemode).w ; is game on a level?
		bne.s	VBla_Music	; if not, branch

	@islevel:
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ ?
		bne.s	VBla_Music	; if not, branch

		move.w	(vdp_control_port).l,d0
		btst	#6,(v_megadrive).w ; is Megadrive PAL?
		beq.s	@notPAL		; if not, branch

		move.w	#$700,d0
	@waitPAL:
		dbf	d0,@waitPAL

	@notPAL:
		move.w	#1,(f_hbla_pal).w ; set HBlank flag
		tst.b	(f_wtr_state).w	; is water above top of screen?
		bne.s	@waterabove 	; if yes, branch

		writeCRAM	v_pal_dry,$80,0
		bra.s	@waterbelow

@waterabove:
		writeCRAM	v_pal_water,$80,0

	@waterbelow:
		move.w	(v_hbla_hreg).w,(a5)
		bra.w	VBla_Music
; ===========================================================================

VBla_02:
		bsr.w	sub_106E

VBla_14:
		tst.w	(v_demolength).w
		beq.s	@end
		subq.w	#1,(v_demolength).w

	@end:
		rts
; ===========================================================================

VBla_04:
		bsr.w	sub_106E
		bsr.w	LoadTilesAsYouMove_BGOnly
		bsr.w 	ProcessDMAQueue
		bsr.w	sub_1642
		tst.w	(v_demolength).w
		beq.s	@end
		subq.w	#1,(v_demolength).w

	@end:
		rts
; ===========================================================================

VBla_06:
		bsr.w	sub_106E
		rts
; ===========================================================================

VBla_10:
		cmpi.b	#id_Special,(v_gamemode).w ; is game on special stage?
		beq.w	VBla_0A		; if yes, branch

VBla_08:
		bsr.w	ReadJoypads
		tst.b	(f_wtr_state).w
		bne.s	@waterabove

		writeCRAM	v_pal_dry,$80,0
		bra.s	@waterbelow

@waterabove:
		writeCRAM	v_pal_water,$80,0

	@waterbelow:
		move.w	(v_hbla_hreg).w,(a5)

		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		bsr.w	ProcessDMAQueue

	@nochg:
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w
		cmpi.b	#96,(v_hbla_line).w
		bhs.s	Demo_Time
		move.b	#1,($FFFFF64F).w
		addq.l	#4,sp
		bra.w	VBla_Exit

; ---------------------------------------------------------------------------
; Subroutine to	run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Demo_Time:
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		bsr.w	ProcessDPLC2
		tst.w	(v_demolength).w ; is there time left on the demo?
		beq.s	@end		; if not, branch
		subq.w	#1,(v_demolength).w ; subtract 1 from time left

	@end:
		rts
; End of function Demo_Time

; ===========================================================================

VBla_0A:
		bsr.w	ReadJoypads
		writeCRAM	v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		bsr.w	PalCycle_SS
		bsr.w	ProcessDMAQueue

	@nochg:
		tst.w	(v_demolength).w	; is there time left on the demo?
		beq.s	@end	; if not, return
		subq.w	#1,(v_demolength).w	; subtract 1 from time left in demo

	@end:
		rts
; ===========================================================================

VBla_0C:
		bsr.w	ReadJoypads
		tst.b	(f_wtr_state).w
		bne.s	@waterabove

		writeCRAM	v_pal_dry,$80,0
		bra.s	@waterbelow

@waterabove:
		writeCRAM	v_pal_water,$80,0

	@waterbelow:
		move.w	(v_hbla_hreg).w,(a5)
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		bsr.w	ProcessDMAQueue

	@nochg:
		movem.l	(v_screenposx).w,d0-d7
		movem.l	d0-d7,(v_screenposx_dup).w
		movem.l	(v_fg_scroll_flags).w,d0-d1
		movem.l	d0-d1,(v_fg_scroll_flags_dup).w
		bsr.w	LoadTilesAsYouMove
		jsr	(AnimateLevelGfx).l
		jsr	(HUD_Update).l
		bra.w	sub_1642
; ===========================================================================

VBla_0E:
		bsr.w	sub_106E
		addq.b	#1,($FFFFF628).w
		move.b	#$E,(v_vbla_routine).w
		rts
; ===========================================================================

VBla_12:
		bsr.w	sub_106E
		move.w	(v_hbla_hreg).w,(a5)
		bra.w	sub_1642
; ===========================================================================

VBla_16:
		bsr.w	ReadJoypads
		writeCRAM	v_pal_dry,$80,0
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		bsr.w	ProcessDMAQueue
	@nochg:
		tst.w	(v_demolength).w
		beq.s	@end
		subq.w	#1,(v_demolength).w

	@end:
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_106E:
		bsr.w	ReadJoypads
		tst.b	(f_wtr_state).w ; is water above top of screen?
		bne.s	@waterabove	; if yes, branch
		writeCRAM	v_pal_dry,$80,0
		bra.s	@waterbelow

	@waterabove:
		writeCRAM	v_pal_water,$80,0

	@waterbelow:
		writeVRAM	v_spritetablebuffer,$280,vram_sprites
		writeVRAM	v_hscrolltablebuffer,$380,vram_hscroll
		rts
; End of function sub_106E

; ---------------------------------------------------------------------------
; Horizontal interrupt
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


HBlank:
		disable_ints
		tst.w	(f_hbla_pal).w	; is palette set to change?
		beq.s	@nochg		; if not, branch
		move.w	#0,(f_hbla_pal).w
		movem.l	a0-a1,-(sp)
		lea	(vdp_data_port).l,a1
		lea	(v_pal_water).w,a0 ; get palette from RAM
		move.l	#$C0000000,4(a1) ; set VDP to CRAM write
		move.l	(a0)+,(a1)	; move palette to CRAM
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.l	(a0)+,(a1)
		move.w	#$8A00+223,4(a1) ; reset HBlank register
		movem.l	(sp)+,a0-a1
		tst.b	($FFFFF64F).w
		bne.s	loc_119E

	@nochg:
		rte
; ===========================================================================

loc_119E:
		clr.b	($FFFFF64F).w
		movem.l	d0-a6,-(sp)
		bsr.w	Demo_Time
		jsr	(UpdateMusic).l
		movem.l	(sp)+,d0-a6
		rte
; End of function HBlank

; ---------------------------------------------------------------------------
; Subroutine to	initialise joypads
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


JoypadInit:
		moveq	#$40,d0
		move.b	d0,($A10009).l	; init port 1 (joypad 1)
		move.b	d0,($A1000B).l	; init port 2 (joypad 2)
		move.b	d0,($A1000D).l	; init port 3 (expansion/extra)
		rts
; End of function JoypadInit

; ---------------------------------------------------------------------------
; Subroutine to	read joypad input, and send it to the RAM
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ReadJoypads:
		lea	(v_jpadhold1).w,a0 ; address where joypad states are written
		lea	($A10003).l,a1	; first	joypad port
		bsr.s	@read		; do the first joypad
		addq.w	#2,a1		; do the second	joypad

	@read:
		move.b	#0,(a1)
		nop
		nop
		move.b	(a1),d0
		lsl.b	#2,d0
		andi.b	#$C0,d0
		move.b	#$40,(a1)
		nop
		nop
		move.b	(a1),d1
		andi.b	#$3F,d1
		or.b	d1,d0
		not.b	d0
		move.b	(a0),d1
		eor.b	d0,d1
		move.b	d0,(a0)+
		and.b	d0,d1
		move.b	d1,(a0)+
		rts
; End of function ReadJoypads

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


VDPSetupGame:
		lea	(vdp_control_port).l,a0
		lea	(vdp_data_port).l,a1
		lea	(VDPSetupArray).l,a2
		moveq	#$12,d7

	@setreg:
		move.w	(a2)+,(a0)
		dbf	d7,@setreg	; set the VDP registers

		move.w	(VDPSetupArray+2).l,d0
		move.w	d0,(v_vdp_buffer1).w
		move.w	#$8A00+223,(v_hbla_hreg).w	; H-INT every 224th scanline
		moveq	#0,d0
		move.l	#$C0000000,(vdp_control_port).l ; set VDP to CRAM write
		move.w	#$3F,d7

	@clrCRAM:
		move.w	d0,(a1)
		dbf	d7,@clrCRAM	; clear	the CRAM

		clr.l	(v_scrposy_dup).w
		clr.l	(v_scrposx_dup).w
		move.l	d1,-(sp)
		fillVRAM	0,$FFFF,0

	@waitforDMA:
		move.w	(a5),d1
		btst	#1,d1		; is DMA (fillVRAM) still running?
		bne.s	@waitforDMA	; if yes, branch

		move.w	#$8F02,(a5)	; set VDP increment size
		move.l	(sp)+,d1
		rts
; End of function VDPSetupGame

; ===========================================================================
VDPSetupArray:	dc.w $8004		; 8-colour mode
		dc.w $8134		; enable V.interrupts, enable DMA
		dc.w $8200+(vram_fg>>10) ; set foreground nametable address
		dc.w $8300+($A000>>10)	; set window nametable address
		dc.w $8400+(vram_bg>>13) ; set background nametable address
		dc.w $8500+(vram_sprites>>9) ; set sprite table address
		dc.w $8600		; unused
		dc.w $8700		; set background colour (palette entry 0)
		dc.w $8800		; unused
		dc.w $8900		; unused
		dc.w $8A00		; default H.interrupt register
		dc.w $8B00		; full-screen vertical scrolling
		dc.w $8C81		; 40-cell display mode
		dc.w $8D00+(vram_hscroll>>10) ; set background hscroll address
		dc.w $8E00		; unused
		dc.w $8F02		; set VDP increment size
		dc.w $9001		; 64-cell hscroll size
		dc.w $9100		; window horizontal position
		dc.w $9200		; window vertical position

; ---------------------------------------------------------------------------
; Subroutine to	clear the screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ClearScreen:
		fillVRAM	0,$FFF,vram_fg ; clear foreground namespace

	@wait1:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	@wait1

		move.w	#$8F02,(a5)
		fillVRAM	0,$FFF,vram_bg ; clear background namespace

	@wait2:
		move.w	(a5),d1
		btst	#1,d1
		bne.s	@wait2

		move.w	#$8F02,(a5)
		if Revision=0
		move.l	#0,(v_scrposy_dup).w
		move.l	#0,(v_scrposx_dup).w
		else
		clr.l	(v_scrposy_dup).w
		clr.l	(v_scrposx_dup).w
		endc

		lea	(v_spritetablebuffer).w,a1
		moveq	#0,d0
		move.w	#($280/4),d1	; This should be ($280/4)-1, leading to a slight bug (first bit of v_pal_water is cleared)

	@clearsprites:
		move.l	d0,(a1)+
		dbf	d1,@clearsprites ; clear sprite table (in RAM)

		lea	(v_hscrolltablebuffer).w,a1
		moveq	#0,d0
		move.w	#($400/4),d1	; This should be ($400/4)-1, leading to a slight bug (first bit of the Sonic object's RAM is cleared)

	@clearhscroll:
		move.l	d0,(a1)+
		dbf	d1,@clearhscroll ; clear hscroll table (in RAM)
		rts
; End of function ClearScreen

; ---------------------------------------------------------------------------
; Subroutine to	load the sound driver
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SoundDriverLoad:            ; XREF: GameClrRAM; TitleScreen
		move.w    #$100,d0
		move.w    d0,($A11100).l
		move.w    d0,($A11200).l
		lea    (MegaPCM).l,a0
 		lea    ($A00000).l,a1
 		move.w    #(MegaPCM_End-MegaPCM)-1,d1

    	@Load:    move.b    (a0)+,(a1)+
        	dbf    d1,@Load
        	moveq    #0,d1
        	move.w    d1,($A11200).l
        	move.w    d0,($A11200).l
        	move.w    d1,($A11100).l
		rts
; End of function SoundDriverLoad

		include	"_incObj\sub PlaySound.asm"
		include	"_inc\PauseGame.asm"

; ---------------------------------------------------------------------------
; Subroutine to	copy a tile map from RAM to VRAM namespace

; input:
;	a1 = tile map address
;	d0 = VRAM address
;	d1 = width (cells)
;	d2 = height (cells)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


TilemapToVRAM:
		lea	(vdp_data_port).l,a6
		move.l	#$800000,d4

	Tilemap_Line:
		move.l	d0,4(a6)	; move d0 to VDP_control_port
		move.w	d1,d3

	Tilemap_Cell:
		move.w	(a1)+,(a6)	; write value to namespace
		dbf	d3,Tilemap_Cell	; next tile
		add.l	d4,d0		; goto next line
		dbf	d2,Tilemap_Line	; next line
		rts
; End of function TilemapToVRAM

		include	"_inc\Nemesis Decompression.asm"


    pusho	; buffer local label symbol config
    opt ws+  ; change local label symbol to '.'

; ---------------------------------------------------------------------------
; MACRO ResetDMAQueue
; Clears the DMA queue, discarding all previously-queued DMAs.
; ---------------------------------------------------------------------------
; ROUTINE Process_DMA_Queue / ProcessDMAQueue
; Performs all queued DMA transfers and clears the DMA queue.
;
; Output:
; 	a1,a5	trashed
; ---------------------------------------------------------------------------
; ROUTINE InitDMAQueue
; Pre-initializes the DMA queue with VDP register numbers in alternating bytes.
; Must be called before the queue is used, and the queue expects that only it
; write to this region of RAM.
;
; Output:
; 	a0,d0,d1	trashed
; ---------------------------------------------------------------------------
; ROUTINE Add_To_DMA_Queue / QueueDMATransfer
; Queues a DMA with parameters given in registers.
;
; Options:
; 	AssumeSourceAddressInBytes (default 1)
; 	AssumeSourceAddressIsRAMSafe (default 0)
; 	UseRAMSourceSafeDMA (default 1&(AssumeSourceAddressIsRAMSafe=0))
; 	Use128kbSafeDMA (default 0)
; 	UseVIntSafeDMA (default 0)
; Input:
; 	d1	Source address (in bytes, or in words if AssumeSourceAddressInBytes is
; 		set to 0)
; 	d2	Destination address
; 	d3	Transfer length (in words)
; Output:
; 	d0,d1,d2,d3,a1	trashed
;
; With the default settings, runs in:
; * 48(11/0) cycles if queue is full (DMA discarded)
; * 184(29/9) cycles otherwise (DMA queued)
;
; With Use128kbSafeDMA = 1, runs in:
; * 48(11/0) cycles if queue is full at the start (DMA discarded)
; * 200(32/9) cycles if the DMA does not cross a 128kB boundary (DMA queued)
; * 226(38/9) cycles if the DMA crosses a 128kB boundary, and the first piece
;   fills the queue (second piece is discarded)
; * 338(56/17) cycles if the DMA crosses a 128kB boundary, and the queue has
;   space for both pieces (both pieces queued)
;
; Setting UseVIntSafeDMA to 1 adds 46(6/1) cycles to all times.
;
; Setting AssumeSourceAddressInBytes to 0 reduces all times by 10(1/0) cycles,
; but only if the DMA is not entirely discarded. However, all callers must be
; edited to make sure the adresss given is correct.
;
; Setting AssumeSourceAddressIsRAMSafe to 1, or UseRAMSourceSafeDMA to 0,
; reduces all times by 14(2/0) cycles, but only if the DMA is not entirely
; discarded. However, all callers must be edited to make sure the adresss given
; in the correct form. You can use the dmaSource function for that.
; ---------------------------------------------------------------------------
; MACRO QueueStaticDMA
; Directly queues a DMA on the spot. Requires all parameters to be known at
; assembly time; that is, no registers. Gives assembly errors when the DMA
; crosses a 128kB boundary, is at an odd ROM location, or is zero length.
;
; Options:
; 	UseVIntSafeDMA (default 0)
; Input:
; 	Source address (in bytes), transfer length (in bytes), destination address
; Output:
; 	d0,a1	trashed
;
; With the default settings, runs in:
; * 32(7/0) cycles if queue is full (DMA discarded)
; * 122(21/8) cycles otherwise (DMA queued)
;
; Setting UseVIntSafeDMA to 1 adds 46(6/1) cycles to both cases.
; ===========================================================================
; option: AssumeSourceAddressInBytes
;
; This option makes the function work as a drop-in replacement of the original
; functions. If you modify all callers to supply a position in words instead of
; bytes (i.e., divide source address by 2) you can set this to 0 to gain 10(1/0)
AssumeSourceAddressInBytes = 1
; ===========================================================================
; option: AssumeSourceAddressIsRAMSafe
;
; This option (which is disabled by default) makes the DMA queue assume that the
; source address is given to the function in a way that makes them safe to use
; with RAM sources. You need to edit all callers to ensure this.
; Enabling this option turns off UseRAMSourceSafeDMA, and saves 14(2/0).
AssumeSourceAddressIsRAMSafe = 0
; ===========================================================================
; option: UseRAMSourceSafeDMA
;
; This option (which is enabled by default) makes source addresses in RAM safe
; at the cost of 14(2/0). If you modify all callers so as to clear the top byte
; of source addresses (i.e., by ANDing them with $FFFFFF).
UseRAMSourceSafeDMA = 1&(AssumeSourceAddressIsRAMSafe=0)
; ===========================================================================
; option: Use128kbSafeDMA
;
; This option breaks DMA transfers that crosses a 128kB block into two. It is
; disabled by default because you can simply align the art in ROM and avoid the
; issue altogether. It is here so that you have a high-performance routine to do
; the job in situations where you can't align it in ROM.
Use128kbSafeDMA = 1
; ===========================================================================
; option UseVIntSafeDMA
;
; Option to mask interrupts while updating the DMA queue. This fixes many race
; conditions in the DMA funcion, but it costs 46(6/1) cycles. The better way to
; handle these race conditions would be to make unsafe callers (such as S3&K's
; KosM decoder) prevent these by masking off interrupts before calling and then
; restore interrupts after.
UseVIntSafeDMA = 0
; ===========================================================================


; Convenience macros, for increased maintainability of the code.
	if ~def(DMA)
DMA = %100111
	endif
	if ~def(VRAM)
VRAM = %100001
	endif
	if ~def(vdpCommReg_defined)
; Like vdpComm, but starting from an address contained in a register
vdpCommReg_defined = 1
vdpCommReg macro reg,type,rwd,clr
	lsl.l	#2,\reg							; Move high bits into (word-swapped) position, accidentally moving everything else
	if ((\type&\rwd)&3)<>0
		addq.w	#((\type&\rwd)&3),\reg			; Add upper access type bits
	endif
	ror.w	#2,\reg							; Put upper access type bits into place, also moving all other bits into their correct (word-swapped) places
	swap	\reg								; Put all bits in proper places
	if \clr <> 0
		andi.w	#3,\reg						; Strip whatever junk was in upper word of reg
	endif
	if ((\type&\rwd)&$FC)=$20
		tas.b	\reg							; Add in the DMA flag -- tas fails on memory, but works on registers
	elseif ((\type&\rwd)&$FC)<>0
		ori.w	#(((\type&\rwd)&$FC)<<2),\reg	; Add in missing access type bits
	endif
	endm
	endif
; ---------------------------------------------------------------------------
	if ~def(intMacros_defined)
intMacros_defined = 1
enableInts macro
	move	#$2300,sr
	endm

disableInts macro
	move	#$2700,sr
	endm
	endif
; ---------------------------------------------------------------------------
	if ~def(DMAEntry_defined)
DMAEntry_defined = 1
        rsreset
DMAEntry.Reg94:		rs.b	1
			  
DMAEntry.Size:      rs.b    0
DMAEntry.SizeH:		rs.b	1
DMAEntry.Reg93:		rs.b	1
DMAEntry.Source:    rs.b    0
DMAEntry.SizeL:		rs.b	1
DMAEntry.Reg97:		rs.b	1
DMAEntry.SrcH:		rs.b	1
DMAEntry.Reg96:		rs.b	1
DMAEntry.SrcM:		rs.b	1
DMAEntry.Reg95:		rs.b	1
DMAEntry.SrcL:		rs.b	1
DMAEntry.Command:	rs.l	1
DMAEntry.len:   rs.w    0
	endif
; ---------------------------------------------------------------------------
QueueSlotCount = (VDP_Command_Buffer_Slot-VDP_Command_Buffer)/DMAEntry.len
; ---------------------------------------------------------------------------
	if ~def(QueueStaticDMA_defined)
						
										   
									   
	  
																			 
							  
QueueStaticDMA_defined = 1
; Expects source address and DMA length in bytes. Also, expects source, size, and dest to be known
; at assembly time. Gives errors if DMA starts at an odd address, transfers
; crosses a 128kB boundary, or has size 0.
QueueStaticDMA macro src,length,dest
    local   len
		if ((\src)&1)<>0
			inform 3,"DMA queued from odd source \1!"
		endif
		if ((\length)&1)<>0
			inform 3,"DMA an odd number of bytes \2!"
		endif
		if (\length)=0
			inform 3,"DMA transferring 0 bytes (becomes a 128kB transfer). If you really mean it, pass 128kB instead."
		endif
		if (((\src)+(\length)-1)>>17)<>((\src)>>17)
			inform 3,"DMA crosses a 128kB boundary. You should either split the DMA manually or align the source adequately."
		endif
	  
	if UseVIntSafeDMA=1
		move.w	sr,-(sp)										; Save current interrupt mask
		disableInts												; Mask off interrupts
	endif ; UseVIntSafeDMA=1
	movea.w	(VDP_Command_Buffer_Slot).w,a1
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	.done												; Return if there's no more room in the buffer
	len: = ((length>>1)&$7FFF)
    move.b	#(len>>8)&$FF,DMAEntry.SizeH(a1)		; Write top byte of size/2
	move.l	#((len&$FF)<<24)|((src>>1)&$7FFFFF),d0	; Set d0 to bottom byte of size/2 and the low 3 bytes of source/2
	movep.l	d0,DMAEntry.SizeL(a1)								; Write it all to the queue
	lea	DMAEntry.Command(a1),a1									; Seek to correct RAM address to store VDP DMA command
	move.l	#$40000080,(a1)+						; Write VDP DMA command for destination address
	move.w	a1,(VDP_Command_Buffer_Slot).w						; Write next queue slot
.done:
	if UseVIntSafeDMA=1
		move.w	(sp)+,sr										; Restore interrupts to previous state
	endif ;UseVIntSafeDMA=1
	endm
	endif

    

; ---------------------------------------------------------------------------
ResetDMAQueue: macro
	move.w	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	endm
; ===========================================================================

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_144E: DMA_68KtoVRAM: QueueCopyToVRAM: QueueVDPCommand:
Add_To_DMA_Queue:
QueueDMATransfer:
	if UseVIntSafeDMA=1
		move.w	sr,-(sp)									; Save current interrupt mask
		disableInts											; Mask off interrupts
	endif ; UseVIntSafeDMA=1
	movea.w	(VDP_Command_Buffer_Slot).w,a1
	cmpa.w	#VDP_Command_Buffer_Slot,a1
	beq.s	.done											; Return if there's no more room in the buffer

	if AssumeSourceAddressInBytes<>0
		lsr.l	#1,d1										; Source address is in words for the VDP registers
	endif
	if UseRAMSourceSafeDMA<>0
		bclr.l	#23,d1										; Make sure bit 23 is clear (68k->VDP DMA flag)
	endif	; UseRAMSourceSafeDMA
	movep.l	d1,DMAEntry.Source(a1)							; Write source address; the useless top byte will be overwritten later
	moveq	#0,d0											; We need a zero on d0

	if Use128kbSafeDMA<>0
		; Detect if transfer crosses 128KB boundary
		; Using sub+sub instead of move+add handles the following edge cases:
		; (1) d3.w = 0 => 128kB transfer
		;   (a) d1.w = 0 => no carry, don't split the DMA
		;   (b) d1.w != 0 => carry, need to split the DMA
		; (2) d3.w != 0
		;   (a) if there is carry on d1.w + d3.w
		;     (* ) if d1.w + d3.w = 0 => transfer comes entirely from current 128kB block, don't split the DMA
		;     (**) if d1.w + d3.w != 0 => need to split the DMA
		;   (b) if there is no carry on d1.w + d3.w => don't split the DMA
		; The reason this works is that carry on d1.w + d3.w means that
		; d1.w + d3.w >= $10000, whereas carry on (-d3.w) - (d1.w) means that
		; d1.w + d3.w > $10000.
		sub.w	d3,d0										; Using sub instead of move and add allows checking edge cases
		sub.w	d1,d0										; Does the transfer cross over to the next 128kB block?
		bcs.s	.doubletransfer								; Branch if yes
	endif	; Use128kbSafeDMA
	; It does not cross a 128kB boundary. So just finish writing it.
	movep.w	d3,DMAEntry.Size(a1)							; Write DMA length, overwriting useless top byte of source address

.finishxfer:
	; Command to specify destination address and begin DMA
	move.w	d2,d0											; Use the fact that top word of d0 is zero to avoid clearing on vdpCommReg
	vdpCommReg d0,VRAM,DMA,0								; Convert destination address to VDP DMA command
	lea	DMAEntry.Command(a1),a1								; Seek to correct RAM address to store VDP DMA command
	move.l	d0,(a1)+										; Write VDP DMA command for destination address
	move.w	a1,(VDP_Command_Buffer_Slot).w					; Write next queue slot

.done:
	if UseVIntSafeDMA=1
		move.w	(sp)+,sr									; Restore interrupts to previous state
	endif ;UseVIntSafeDMA=1
	rts
; ---------------------------------------------------------------------------
	if Use128kbSafeDMA<>0
.doubletransfer:
		; We need to split the DMA into two parts, since it crosses a 128kB block
		add.w	d3,d0										; Set d0 to the number of words until end of current 128kB block
		movep.w	d0,DMAEntry.Size(a1)						; Write DMA length of first part, overwriting useless top byte of source addres

		cmpa.w	#VDP_Command_Buffer_Slot-DMAEntry.len,a1	; Does the queue have enough space for both parts?
		beq.s	.finishxfer									; Branch if not

		; Get second transfer's source, destination, and length
		sub.w	d0,d3										; Set d3 to the number of words remaining
		add.l	d0,d1										; Offset the source address of the second part by the length of the first part
		add.w	d0,d0										; Convert to number of bytes
		add.w	d2,d0										; Set d0 to the VRAM destination of the second part

		; If we know top word of d2 is clear, the following vdpCommReg can be set to not
		; clear it. There is, unfortunately, no faster way to clear it than this.
		vdpCommReg d2,VRAM,DMA,1							; Convert destination address of first part to VDP DMA command
		move.l	d2,DMAEntry.Command(a1)						; Write VDP DMA command for destination address of first part

		; Do second transfer
		movep.l	d1,DMAEntry.len+DMAEntry.Source(a1)			; Write source address of second part; useless top byte will be overwritten later
		movep.w	d3,DMAEntry.len+DMAEntry.Size(a1)			; Write DMA length of second part, overwriting useless top byte of source addres

		; Command to specify destination address and begin DMA
		vdpCommReg d0,VRAM,DMA,0							; Convert destination address to VDP DMA command; we know top half of d0 is zero
		lea	DMAEntry.len+DMAEntry.Command(a1),a1			; Seek to correct RAM address to store VDP DMA command of second part
		move.l	d0,(a1)+									; Write VDP DMA command for destination address of second part

		move.w	a1,(VDP_Command_Buffer_Slot).w				; Write next queue slot
		if UseVIntSafeDMA=1
			move.w	(sp)+,sr								; Restore interrupts to previous state
		endif ;UseVIntSafeDMA=1
		rts
	endif	; Use128kbSafeDMA
; End of function QueueDMATransfer
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine for issuing all VDP commands that were queued
; (by earlier calls to QueueDMATransfer)
; Resets the queue when it's done
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_14AC: CopyToVRAM: IssueVDPCommands: Process_DMA:
Process_DMA_Queue:
ProcessDMAQueue:
	movea.w	(VDP_Command_Buffer_Slot).w,a1
	jmp	.jump_table-VDP_Command_Buffer(a1)
; ---------------------------------------------------------------------------
.jump_table:
	rts
	rept 6
		trap	#0											; Just in case
	endr
; ---------------------------------------------------------------------------
    c: = 1
	rept QueueSlotCount
		lea	(vdp_control_port).l,a5
		lea	(VDP_Command_Buffer).w,a1
		if c<>QueueSlotCount
			bra.w	.jump0 - c*8
		endif
    c: = c + 1
	endr
; ---------------------------------------------------------------------------
	rept QueueSlotCount
		move.l	(a1)+,(a5)									; Transfer length
		move.l	(a1)+,(a5)									; Source address high
		move.l	(a1)+,(a5)									; Source address low + destination high
		move.w	(a1)+,(a5)									; Destination low, trigger DMA
	endr

.jump0:
	ResetDMAQueue
	rts
; End of function ProcessDMAQueue
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine for initializing the DMA queue.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

InitDMAQueue:
	lea	(VDP_Command_Buffer).w,a0
	moveq	#-$6C,d0				; fast-store $94 (sign-extended) in d0
	move.l	#$93979695,d1
    c: = 0
	rept QueueSlotCount
		move.b	d0,c + DMAEntry.Reg94(a0)
		movep.l	d1,c + DMAEntry.Reg93(a0)
    c: = c + DMAEntry.len
	endr

	ResetDMAQueue
	rts
; End of function ProcessDMAQueue
; ===========================================================================


    popo	; buffer local label symbol config


; ---------------------------------------------------------------------------
; Subroutine to load pattern load cues (aka to queue pattern load requests)
; ---------------------------------------------------------------------------

; ARGUMENTS
; d0 = index of PLC list
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; LoadPLC:
AddPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1		; jump to relevant PLC
		lea	(v_plc_buffer).w,a2 ; PLC buffer space

	@findspace:
		tst.l	(a2)		; is space available in RAM?
		beq.s	@copytoRAM	; if yes, branch
		addq.w	#6,a2		; if not, try next space
		bra.s	@findspace
; ===========================================================================

@copytoRAM:
		move.w	(a1)+,d0	; get length of PLC
		bmi.s	@skip

	@loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+	; copy PLC to RAM
		dbf	d0,@loop	; repeat for length of PLC

	@skip:
		movem.l	(sp)+,a1-a2 ; a1=object
		rts	
; End of function AddPLC


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; Queue pattern load requests, but clear the PLQ first

; ARGUMENTS
; d0 = index of PLC list (see ArtLoadCues)

; NOTICE: This subroutine does not check for buffer overruns. The programmer
;	  (or hacker) is responsible for making sure that no more than
;	  16 load requests are copied into the buffer.
;	  _________DO NOT PUT MORE THAN 16 LOAD REQUESTS IN A LIST!__________
;         (or if you change the size of Plc_Buffer, the limit becomes (Plc_Buffer_Only_End-Plc_Buffer)/6)

; LoadPLC2:
NewPLC:
		movem.l	a1-a2,-(sp)
		lea	(ArtLoadCues).l,a1
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1	; jump to relevant PLC
		bsr.s	ClearPLC	; erase any data in PLC buffer space
		lea	(v_plc_buffer).w,a2
		move.w	(a1)+,d0	; get length of PLC
		bmi.s	@skip		; if it's negative, skip the next loop

	@loop:
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+	; copy PLC to RAM
		dbf	d0,@loop		; repeat for length of PLC

	@skip:
		movem.l	(sp)+,a1-a2
		rts	
; End of function NewPLC

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to	clear the pattern load cues
; ---------------------------------------------------------------------------

; Clear the pattern load queue ($FFF680 - $FFF700)


ClearPLC:
		lea	(v_plc_buffer).w,a2 ; PLC buffer space in RAM
		moveq	#$1F,d0	; bytesToLcnt(v_plc_buffer_end-v_plc_buffer)

	@loop:
		clr.l	(a2)+
		dbf	d0,@loop
		rts	
; End of function ClearPLC

; ---------------------------------------------------------------------------
; Subroutine to	use graphics listed in a pattern load cue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


RunPLC:
		tst.l	(v_plc_buffer).w
		beq.s	Rplc_Exit
		tst.w	(f_plc_execute).w
		bne.s	Rplc_Exit
		movea.l	(v_plc_buffer).w,a0
		lea	NemPCD_WriteRowToVDP(pc),a3
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2
		bpl.s	loc_160E
		lea	NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP(a3),a3

loc_160E:
		andi.w	#$7FFF,d2
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5
		asl.w	#8,d5
		move.b	(a0)+,d5
		moveq	#$10,d6
		moveq	#0,d0
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_ptrnemcode).w
		move.l	d0,($FFFFF6E4).w
		move.l	d0,($FFFFF6E8).w
		move.l	d0,($FFFFF6EC).w
		move.l	d5,($FFFFF6F0).w
		move.l	d6,($FFFFF6F4).w
		move.w	d2,(f_plc_execute).w

Rplc_Exit:
		rts
; End of function RunPLC


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_1642:
		tst.w	(f_plc_execute).w
		beq.s	Rplc_Exit
		move.w	#9,($FFFFF6FA).w
		moveq	#0,d0
		move.w	($FFFFF684).w,d0
		addi.w	#$120,($FFFFF684).w
		bra.s	loc_1676
; End of function sub_1642


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


; sub_165E:
ProcessDPLC2:
		tst.w	(f_plc_execute).w
		beq.s	locret_16DA
		move.w	#3,($FFFFF6FA).w
		moveq	#0,d0
		move.w	($FFFFF684).w,d0
		addi.w	#$60,($FFFFF684).w

loc_1676:
		lea	(vdp_control_port).l,a4
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(a4)
		subq.w	#4,a4
		movea.l	(v_plc_buffer).w,a0
		movea.l	(v_ptrnemcode).w,a3
		move.l	($FFFFF6E4).w,d0
		move.l	($FFFFF6E8).w,d1
		move.l	($FFFFF6EC).w,d2
		move.l	($FFFFF6F0).w,d5
		move.l	($FFFFF6F4).w,d6
		lea	(v_ngfx_buffer).w,a1

loc_16AA:
		movea.w	#8,a5
		bsr.w	NemPCD_NewRow
		subq.w	#1,(f_plc_execute).w
		beq.s	loc_16DC
		subq.w	#1,($FFFFF6FA).w
		bne.s	loc_16AA
		move.l	a0,(v_plc_buffer).w
		move.l	a3,(v_ptrnemcode).w
		move.l	d0,($FFFFF6E4).w
		move.l	d1,($FFFFF6E8).w
		move.l	d2,($FFFFF6EC).w
		move.l	d5,($FFFFF6F0).w
		move.l	d6,($FFFFF6F4).w

locret_16DA:
		rts
; ===========================================================================

loc_16DC:
		lea	(v_plc_buffer).w,a0
		moveq	#$15,d0

loc_16E2:
		move.l	6(a0),(a0)+
		dbf	d0,loc_16E2
		rts
; End of function ProcessDPLC2

; ---------------------------------------------------------------------------
; Subroutine to	execute	the pattern load cue
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


QuickPLC:
		lea	(ArtLoadCues).l,a1 ; load the PLC index
		add.w	d0,d0
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		move.w	(a1)+,d1	; get length of PLC

	Qplc_Loop:
		movea.l	(a1)+,a0	; get art pointer
		moveq	#0,d0
		move.w	(a1)+,d0	; get VRAM address
		lsl.l	#2,d0
		lsr.w	#2,d0
		ori.w	#$4000,d0
		swap	d0
		move.l	d0,(vdp_control_port).l ; converted VRAM address to VDP format
		bsr.w	NemDec		; decompress
		dbf	d1,Qplc_Loop	; repeat for length of PLC
		rts
; End of function QuickPLC

		include	"_inc\Enigma Decompression.asm"
		include	"_inc\Kosinski Decompression.asm"

		include	"_inc\PaletteCycle.asm"

Pal_TitleCyc:	incbin	"palette\Cycle - Title Screen Water.bin"
Pal_GHZCyc:	incbin	"palette\Cycle - GHZ.bin"
Pal_LZCyc1:	incbin	"palette\Cycle - LZ Waterfall.bin"
Pal_LZCyc2:	incbin	"palette\Cycle - LZ Conveyor Belt.bin"
Pal_LZCyc3:	incbin	"palette\Cycle - LZ Conveyor Belt Underwater.bin"
Pal_SBZ3Cyc1:	incbin	"palette\Cycle - SBZ3 Waterfall.bin"
Pal_SLZCyc:	incbin	"palette\Cycle - SLZ.bin"
Pal_SYZCyc1:	incbin	"palette\Cycle - SYZ1.bin"
Pal_SYZCyc2:	incbin	"palette\Cycle - SYZ2.bin"
Pal_SYZCyc1_2:	incbin	"palette\Cycle - SYZ1 Act 2.bin"
Pal_SYZCyc2_2:	incbin	"palette\Cycle - SYZ2 Act 2.bin"
Pal_SYZCyc1_3:	incbin	"palette\Cycle - SYZ1 Act 3.bin"
Pal_SYZCyc2_3:	incbin	"palette\Cycle - SYZ2 Act 3.bin"

		include	"_inc\SBZ Palette Scripts.asm"

Pal_SBZCyc1:	incbin	"palette\Cycle - SBZ 1.bin"
Pal_SBZCyc2:	incbin	"palette\Cycle - SBZ 2.bin"
Pal_SBZCyc3:	incbin	"palette\Cycle - SBZ 3.bin"
Pal_SBZCyc4:	incbin	"palette\Cycle - SBZ 4.bin"
Pal_SBZCyc5:	incbin	"palette\Cycle - SBZ 5.bin"
Pal_SBZCyc6:	incbin	"palette\Cycle - SBZ 6.bin"
Pal_SBZCyc7:	incbin	"palette\Cycle - SBZ 7.bin"
Pal_SBZCyc8:	incbin	"palette\Cycle - SBZ 8.bin"
Pal_SBZCyc9:	incbin	"palette\Cycle - SBZ 9.bin"
Pal_SBZCyc10:	incbin	"palette\Cycle - SBZ 10.bin"
; ---------------------------------------------------------------------------
; Subroutine to	fade in from black
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteFadeIn:
		move.w	#$003F,(v_pfade_start).w ; set start position = 0; size = $40

PalFadeIn_Alt:				; start position and size are already set
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		moveq	#cBlack,d1
		move.b	(v_pfade_size).w,d0

	@fill:
		move.w	d1,(a0)+
		dbf	d0,@fill 	; fill palette with black

		move.w	#$15,d4

	@mainloop:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	FadeIn_FromBlack
		bsr.w	RunPLC
		dbf	d4,@mainloop
		rts
; End of function PaletteFadeIn


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeIn_FromBlack:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		lea	(v_pal_dry_dup).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

	@addcolour:
		bsr.s	FadeIn_AddColour ; increase colour
		dbf	d0,@addcolour	; repeat for size of palette

		cmpi.b	#id_LZ,(v_zone).w	; is level Labyrinth?
		bne.s	@exit		; if not, branch

		moveq	#0,d0
		lea	(v_pal_water).w,a0
		lea	(v_pal_water_dup).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

	@addcolour2:
		bsr.s	FadeIn_AddColour ; increase colour again
		dbf	d0,@addcolour2 ; repeat

@exit:
		rts	
; End of function FadeIn_FromBlack


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeIn_AddColour:
@addblue:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3		; is colour already at threshold level?
		beq.s	@next		; if yes, branch
		move.w	d3,d1
		addi.w	#$200,d1	; increase blue	value
		cmp.w	d2,d1		; has blue reached threshold level?
		bhi.s	@addgreen	; if yes, branch
		move.w	d1,(a0)+	; update palette
		rts	
; ===========================================================================

@addgreen:
		move.w	d3,d1
		addi.w	#$20,d1		; increase green value
		cmp.w	d2,d1
		bhi.s	@addred
		move.w	d1,(a0)+	; update palette
		rts	
; ===========================================================================

@addred:
		addq.w	#2,(a0)+	; increase red value
		rts	
; ===========================================================================

@next:
		addq.w	#2,a0		; next colour
		rts	
; End of function FadeIn_AddColour


; ---------------------------------------------------------------------------
; Subroutine to fade out to black
; ---------------------------------------------------------------------------


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteFadeOut:
		move.w	#$003F,(v_pfade_start).w ; start position = 0; size = $40
		move.w	#$15,d4

	@mainloop:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	FadeOut_ToBlack
		bsr.w	RunPLC
		dbf	d4,@mainloop
		rts	
; End of function PaletteFadeOut


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeOut_ToBlack:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

	@decolour:
		bsr.s	FadeOut_DecColour ; decrease colour
		dbf	d0,@decolour	; repeat for size of palette

		moveq	#0,d0
		lea	(v_pal_water).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

	@decolour2:
		bsr.s	FadeOut_DecColour
		dbf	d0,@decolour2
		rts	
; End of function FadeOut_ToBlack


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FadeOut_DecColour:
@dered:
		move.w	(a0),d2
		beq.s	@next
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	@degreen
		subq.w	#2,(a0)+	; decrease red value
		rts	
; ===========================================================================

@degreen:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	@deblue
		subi.w	#$20,(a0)+	; decrease green value
		rts	
; ===========================================================================

@deblue:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	@next
		subi.w	#$200,(a0)+	; decrease blue	value
		rts	
; ===========================================================================

@next:
		addq.w	#2,a0
		rts	
; End of function FadeOut_DecColour

; ---------------------------------------------------------------------------
; Subroutine to	fade in from white (Special Stage)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteWhiteIn:
		move.w	#$003F,(v_pfade_start).w ; start position = 0; size = $40
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.w	#cWhite,d1
		move.b	(v_pfade_size).w,d0

	@fill:
		move.w	d1,(a0)+
		dbf	d0,@fill 	; fill palette with white

		move.w	#$15,d4

	@mainloop:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	WhiteIn_FromWhite
		bsr.w	RunPLC
		dbf	d4,@mainloop
		rts	
; End of function PaletteWhiteIn


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteIn_FromWhite:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		lea	(v_pal_dry_dup).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

	@decolour:
		bsr.s	WhiteIn_DecColour ; decrease colour
		dbf	d0,@decolour	; repeat for size of palette

		cmpi.b	#id_LZ,(v_zone).w	; is level Labyrinth?
		bne.s	@exit		; if not, branch
		moveq	#0,d0
		lea	(v_pal_water).w,a0
		lea	(v_pal_water_dup).w,a1
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		adda.w	d0,a1
		move.b	(v_pfade_size).w,d0

	@decolour2:
		bsr.s	WhiteIn_DecColour
		dbf	d0,@decolour2

	@exit:
		rts	
; End of function WhiteIn_FromWhite


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteIn_DecColour:
@deblue:
		move.w	(a1)+,d2
		move.w	(a0),d3
		cmp.w	d2,d3
		beq.s	@next
		move.w	d3,d1
		subi.w	#$200,d1	; decrease blue	value
		blo.s	@degreen
		cmp.w	d2,d1
		blo.s	@degreen
		move.w	d1,(a0)+
		rts	
; ===========================================================================

@degreen:
		move.w	d3,d1
		subi.w	#$20,d1		; decrease green value
		blo.s	@dered
		cmp.w	d2,d1
		blo.s	@dered
		move.w	d1,(a0)+
		rts	
; ===========================================================================

@dered:
		subq.w	#2,(a0)+	; decrease red value
		rts	
; ===========================================================================

@next:
		addq.w	#2,a0
		rts	
; End of function WhiteIn_DecColour

; ---------------------------------------------------------------------------
; Subroutine to fade to white (Special Stage)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PaletteWhiteOut:
		move.w	#$003F,(v_pfade_start).w ; start position = 0; size = $40
		move.w	#$15,d4

	@mainloop:
		move.b	#$12,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.s	WhiteOut_ToWhite
		bsr.w	RunPLC
		dbf	d4,@mainloop
		rts	
; End of function PaletteWhiteOut


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteOut_ToWhite:
		moveq	#0,d0
		lea	(v_pal_dry).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

	@addcolour:
		bsr.s	WhiteOut_AddColour
		dbf	d0,@addcolour

		moveq	#0,d0
		lea	(v_pal_water).w,a0
		move.b	(v_pfade_start).w,d0
		adda.w	d0,a0
		move.b	(v_pfade_size).w,d0

	@addcolour2:
		bsr.s	WhiteOut_AddColour
		dbf	d0,@addcolour2
		rts	
; End of function WhiteOut_ToWhite


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WhiteOut_AddColour:
@addred:
		move.w	(a0),d2
		cmpi.w	#cWhite,d2
		beq.s	@next
		move.w	d2,d1
		andi.w	#$E,d1
		cmpi.w	#cRed,d1
		beq.s	@addgreen
		addq.w	#2,(a0)+	; increase red value
		rts	
; ===========================================================================

@addgreen:
		move.w	d2,d1
		andi.w	#$E0,d1
		cmpi.w	#cGreen,d1
		beq.s	@addblue
		addi.w	#$20,(a0)+	; increase green value
		rts	
; ===========================================================================

@addblue:
		move.w	d2,d1
		andi.w	#$E00,d1
		cmpi.w	#cBlue,d1
		beq.s	@next
		addi.w	#$200,(a0)+	; increase blue	value
		rts	
; ===========================================================================

@next:
		addq.w	#2,a0
		rts	
; End of function WhiteOut_AddColour

; ---------------------------------------------------------------------------
; Palette cycling routine - Sega logo
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_Sega:
		tst.b	(v_pcyc_time+1).w
		bne.s	loc_206A
		lea	(v_pal_dry+$20).w,a1
		lea	(Pal_Sega1).l,a0
		moveq	#5,d1
		move.w	(v_pcyc_num).w,d0

loc_2020:
		bpl.s	loc_202A
		addq.w	#2,a0
		subq.w	#1,d1
		addq.w	#2,d0
		bra.s	loc_2020
; ===========================================================================

loc_202A:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2034
		addq.w	#2,d0

loc_2034:
		cmpi.w	#$60,d0
		bhs.s	loc_203E
		move.w	(a0)+,(a1,d0.w)

loc_203E:
		addq.w	#2,d0
		dbf	d1,loc_202A

		move.w	(v_pcyc_num).w,d0
		addq.w	#2,d0
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_2054
		addq.w	#2,d0

loc_2054:
		cmpi.w	#$64,d0
		blt.s	loc_2062
		move.w	#$401,(v_pcyc_time).w
		moveq	#-$C,d0

loc_2062:
		move.w	d0,(v_pcyc_num).w
		moveq	#1,d0
		rts	
; ===========================================================================

loc_206A:
		subq.b	#1,(v_pcyc_time).w
		bpl.s	loc_20BC
		move.b	#4,(v_pcyc_time).w
		move.w	(v_pcyc_num).w,d0
		addi.w	#$C,d0
		cmpi.w	#$30,d0
		blo.s	loc_2088
		moveq	#0,d0
		rts	
; ===========================================================================

loc_2088:
		move.w	d0,(v_pcyc_num).w
		lea	(Pal_Sega2).l,a0
		lea	(a0,d0.w),a0
		lea	(v_pal_dry+$04).w,a1
		move.l	(a0)+,(a1)+
		move.l	(a0)+,(a1)+
		move.w	(a0)+,(a1)
		lea	(v_pal_dry+$20).w,a1
		moveq	#0,d0
		moveq	#$2C,d1

loc_20A8:
		move.w	d0,d2
		andi.w	#$1E,d2
		bne.s	loc_20B2
		addq.w	#2,d0

loc_20B2:
		move.w	(a0),(a1,d0.w)
		addq.w	#2,d0
		dbf	d1,loc_20A8

loc_20BC:
		moveq	#1,d0
		rts	
; End of function PalCycle_Sega

; ===========================================================================

Pal_Sega1:	incbin	"palette\Sega1.bin"
Pal_Sega2:	incbin	"palette\Sega2.bin"

; ---------------------------------------------------------------------------
; Subroutines to load palettes

; input:
;	d0 = index number for palette
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


; ---------------------------------------------------------------------------
; Subroutines to load pallets
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

PalLoad1:
		move.b ($FFFFFE11),d1
		lea (PalPointers).l,a1
		cmp.b #0,d1
		beq.w PalLoad1_Continue
		lea (PalPointers2).l,a1
		cmp.b #1,d1
		beq.w PalLoad1_Continue
		lea (PalPointers3).l,a1

PalLoad1_Continue:
		lsl.w #3,d0
		adda.w d0,a1
		movea.l (a1)+,a2
		movea.w (a1)+,a3
		adda.w #$80,a3
		move.w (a1)+,d7

loc_2110:
		move.l (a2)+,(a3)+
		dbf d7,loc_2110
		rts
 ; End of function PalLoad1


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

PalLoad2:
		move.b ($FFFFFE11),d1
		lea (PalPointers).l,a1
		cmp.b #0,d1
		beq.w PalLoad2_Continue
		lea (PalPointers2).l,a1
		cmp.b #1,d1
		beq.w PalLoad2_Continue
		lea (PalPointers3).l,a1


PalLoad2_Continue:
		lsl.w #3,d0
		adda.w d0,a1
		movea.l (a1)+,a2
		movea.w (a1)+,a3
		move.w (a1)+,d7

loc_2128:
		move.l (a2)+,(a3)+
		dbf d7,loc_2128
		rts
; End of function PalLoad2

; ||||||||||||||| S U B    R O U T    I N E |||||||||||||||||||||||||||||||||||||||


PalLoad_Loop: ;Quick load - TIS
        
        move.w    (a1)+,(a2)+              ;Copy pallete data to RAM
        dbf    d0,PalLoad_Loop               ;Loop d0 (length)
        rts

; ---------------------------------------------------------------------------
; Underwater pallet loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

PalLoad3_Water:
		move.b ($FFFFFE11),d1
		lea (PalPointers).l,a1
		cmp.b #0,d1
		beq.w PalLoad3_Continue
		lea (PalPointers2).l,a1
		cmp.b #1,d1
		beq.w PalLoad3_Continue
		lea (PalPointers3).l,a1

PalLoad3_Continue:
		lsl.w #3,d0
		adda.w d0,a1
		movea.l (a1)+,a2
		movea.w (a1)+,a3
		suba.w #$80,a3
		move.w (a1)+,d7

loc_2144:
		move.l (a2)+,(a3)+
		dbf d7,loc_2144
		rts
; End of function PalLoad3_Water


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


PalLoad4_Water:
		move.b ($FFFFFE11),d1
		lea (PalPointers).l,a1
		cmp.b #0,d1
		beq.w PalLoad4_Continue
		lea (PalPointers2).l,a1
		cmp.b #1,d1
		beq.w PalLoad4_Continue
		lea (PalPointers3).l,a1

PalLoad4_Continue:
		lsl.w #3,d0
		adda.w d0,a1
		movea.l (a1)+,a2
		movea.w (a1)+,a3
		suba.w #$100,a3
		move.w (a1)+,d7
loc_2160:
		move.l (a2)+,(a3)+
		dbf d7,loc_2160
		rts
 ; End of function PalLoad4_Water

; ===========================================================================

		include	"_inc\Palette Pointers.asm"
		
		;include	"_inc\Palette Pointers2.asm"
		
		;include	"_inc\Palette Pointers3.asm"
		

; ---------------------------------------------------------------------------
; Palette data
; ---------------------------------------------------------------------------
Pal_SegaBG:	incbin	"palette\Sega Background.bin"
Pal_Title:	incbin	"palette\Title Screen.bin"
Pal_LevelSel:	incbin	"palette\Level Select.bin"
Pal_Sonic:	incbin	"palette\Sonic Pal\01 Default.bin"
Pal_GHZ:	incbin	"palette\Green Hill Zone.bin"
Pal_GHZ2:	incbin	"palette\Green Hill Zone2.bin"
Pal_GHZ3:	incbin	"palette\Green Hill Zone3.bin"
Pal_LZ:		incbin	"palette\Labyrinth Zone.bin"
Pal_LZ2:	incbin	"palette\Labyrinth Zone2.bin"
Pal_LZ3:	incbin	"palette\Labyrinth Zone3.bin"
Pal_LZWater:	incbin	"palette\Labyrinth Zone Underwater.bin"
Pal_LZWatr2:	incbin	"palette\Labyrinth Zone Underwater2.bin"
Pal_LZWatr3:	incbin	"palette\Labyrinth Zone Underwater3.bin"
Pal_MZ:		incbin	"palette\Marble Zone.bin"
Pal_MZ2:	incbin	"palette\Marble Zone2.bin"
Pal_MZ3:	incbin	"palette\Marble Zone3.bin"
Pal_SLZ:	incbin	"palette\Star Light Zone.bin"
Pal_SLZ2:	incbin	"palette\Star Light Zone2.bin"
Pal_SLZ3:	incbin	"palette\Star Light Zone3.bin"
Pal_SYZ:	incbin	"palette\Spring Yard Zone.bin"
Pal_SYZ2:	incbin	"palette\Spring Yard Zone2.bin"
Pal_SYZ3:	incbin	"palette\Spring Yard Zone3.bin"
Pal_SBZ1:	incbin	"palette\SBZ Act 1.bin"
Pal_SBZ2:	incbin	"palette\SBZ Act 2.bin"
Pal_Special:	incbin	"palette\Special Stage.bin"
Pal_SBZ3:	incbin	"palette\SBZ Act 3.bin"
Pal_SBZ3Water:	incbin	"palette\SBZ Act 3 Underwater.bin"
Pal_LZSonWater:	incbin	"palette\Sonic - LZ Underwater.bin"
Pal_LZSonWatr2:	incbin	"palette\Sonic - LZ2 Underwater.bin"
Pal_SBZ3SonWat:	incbin	"palette\Sonic - SBZ3 Underwater.bin"
Pal_SSResult:	incbin	"palette\Special Stage Results.bin"
Pal_Continue:	incbin	"palette\Special Stage Continue Bonus.bin"
Pal_Ending:	incbin	"palette\Ending.bin"
Pal_Options:	incbin	"palette\Options.bin"
Pal_Sonic2:	incbin	"palette\Sonic Pal\02 Sonic 1.bin"
Pal_Sonic3:	incbin	"palette\Sonic Pal\03 Beta.bin"
Pal_Sonic4:	incbin	"palette\Sonic Pal\04 Midnight.bin"
Pal_Sonic5:	incbin	"palette\Sonic Pal\05 C2.bin"
Pal_Sonic6:	incbin	"palette\Sonic Pal\06 Clacker.bin"
Pal_Sonic7:	incbin	"palette\Sonic Pal\07 Red Hot.bin"
Pal_Sonic8:	incbin	"palette\Sonic Pal\08 Socket.bin"
Pal_Sonic9:	incbin	"palette\Sonic Pal\09 Cringe.bin"
Pal_Sonic10:	incbin	"palette\Sonic Pal\10 Dark.bin"
Pal_Sonic11:	incbin	"palette\Sonic Pal\11 DeltaWooloo.bin"
Pal_SonWater2:	incbin	"palette\Sonic Pal\02 Sonic 1 Underwater.bin"
Pal_SonWater3:	incbin	"palette\Sonic Pal\03 Beta Underwater.bin"
Pal_SonWater4:	incbin	"palette\Sonic Pal\04 Midnight Underwater.bin"
Pal_SonWater5:	incbin	"palette\Sonic Pal\05 C2 Underwater.bin"
Pal_SonWater6:	incbin	"palette\Sonic Pal\06 Clacker Underwater.bin"
Pal_SonWater7:	incbin	"palette\Sonic Pal\07 Red Hot Underwater.bin"
Pal_SonWater8:	incbin	"palette\Sonic Pal\08 Socket Underwater.bin"
Pal_SonWater9:	incbin	"palette\Sonic Pal\09 Cringe Underwater.bin"
Pal_SonWater10:	incbin	"palette\Sonic Pal\10 Dark Underwater.bin"
Pal_SonWater11:	incbin	"palette\Sonic Pal\11 DeltaWooloo Underwater.bin"
Pal_SBZ3SonWat2:	incbin	"palette\Sonic Pal\02 Sonic 1 SBZ3.bin"
Pal_SBZ3SonWat3:	incbin	"palette\Sonic Pal\03 Beta SBZ3.bin"
Pal_SBZ3SonWat4:	incbin	"palette\Sonic Pal\04 Midnight SBZ3.bin"
Pal_SBZ3SonWat5:	incbin	"palette\Sonic Pal\05 C2 SBZ3.bin"
Pal_SBZ3SonWat6:	incbin	"palette\Sonic Pal\06 Clacker SBZ3.bin"
Pal_SBZ3SonWat7:	incbin	"palette\Sonic Pal\07 Red Hot SBZ3.bin"
Pal_SBZ3SonWat8:	incbin	"palette\Sonic Pal\08 Socket SBZ3.bin"
Pal_SBZ3SonWat9:	incbin	"palette\Sonic Pal\09 Cringe SBZ3.bin"
Pal_SBZ3SonWat10:	incbin	"palette\Sonic Pal\10 Dark SBZ3.bin"
Pal_SBZ3SonWat11:	incbin	"palette\Sonic Pal\11 DeltaWooloo SBZ3.bin"
; ---------------------------------------------------------------------------
; Subroutine to	wait for VBlank routines to complete
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


WaitForVBla:
		enable_ints

	@wait:
		tst.b	(v_vbla_routine).w ; has VBlank routine finished?
		bne.s	@wait		; if not, branch
		rts	
; End of function WaitForVBla

		include	"_incObj\sub RandomNumber.asm"
		include	"_incObj\sub CalcSine.asm"
		include	"_incObj\sub CalcAngle.asm"

; ---------------------------------------------------------------------------
; Sega screen
; ---------------------------------------------------------------------------

GM_Sega:
		sfx	bgm_Stop,0,1,1 ; stop music
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8700,(a6)	; set background colour (palette entry 0)
		move.w	#$8B00,(a6)	; full-screen vertical scrolling
		clr.b	(f_wtr_state).w
		disable_ints
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		locVRAM	0
		lea	(Nem_SegaLogo).l,a0 ; load Sega	logo patterns
		bsr.w	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_SegaLogo).l,a0 ; load Sega	logo mappings
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,$E510,$17,7
		copyTilemap	$FF0180,$C000,$27,$1B

		if Revision=0
		else
			tst.b   (v_megadrive).w	; is console Japanese?
			bmi.s   @loadpal
			copyTilemap	$FF0A40,$C53A,2,1 ; hide "TM" with a white rectangle
		endc

	@loadpal:
		moveq	#palid_SegaBG,d0
		bsr.w	PalLoad2	; load Sega logo palette
        lea        ($FFFFFB80).l,a3
        moveq    #$3F,d7
 
    .loop:
        move.w    #cBlack,(a3)+    ; move data to RAM
        dbf        d7,.loop
        bsr.w     PaletteFadeIn ; added to allow fade in			
		move.w	#-$A,(v_pcyc_num).w
		move.w	#0,(v_pcyc_time).w
		move.w	#0,(v_pal_buffer+$12).w
		move.w	#0,(v_pal_buffer+$10).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l

Sega_WaitPal:
		move.b	#2,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	PalCycle_Sega
		bne.s	Sega_WaitPal

		sfx	sfx_Sega,0,1,1	; play "SEGA" sound
		move.b	#$14,(v_vbla_routine).w
		bsr.w	WaitForVBla
		move.w	#$1E,(v_demolength).w

Sega_WaitEnd:
		move.b	#2,(v_vbla_routine).w
		bsr.w	WaitForVBla
		tst.w	(v_demolength).w
		beq.s	Sega_GotoTitle
		andi.b	#btnStart,(v_jpadpress1).w ; is Start button pressed?
		beq.s	Sega_WaitEnd	; if not, branch

Sega_GotoTitle:
		move.b	#id_Title,(v_gamemode).w ; go to title screen
		rts	
; ===========================================================================

; ---------------------------------------------------------------------------
; Title	screen
; ---------------------------------------------------------------------------

GM_Title:
		sfx	bgm_Stop,0,1,1 ; stop music
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		disable_ints
		bsr.w	SoundDriverLoad
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)	; 64-cell hscroll size
		move.w	#$9200,(a6)	; window vertical position
		move.w	#$8B03,(a6)
		move.w	#$8720,(a6)	; set background colour (palette line 2, entry 0)
		clr.b	(f_wtr_state).w
		bsr.w	ClearScreen
		;jsr		SHC2022 

		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

	Tit_ClrObj1:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrObj1	; fill object space ($D000-$EFFF) with 0

		bsr.w	PaletteFadeIn
		disable_ints
		locVRAM	$4000
		lea	(Nem_TitleFg).l,a0 ; load title	screen patterns
		bsr.w	NemDec
		locVRAM	$6900
		lea	(Nem_TitleSonic).l,a0 ;	load Sonic title screen	patterns
		bsr.w	NemDec
		locVRAM $ADE0
		lea (Nem_TitleMenu).l,a0 ; Load Menu Text/Characters pattern
		bsr.w 	NemDec
		lea	(vdp_data_port).l,a6
		locVRAM	$D000,4(a6)
		lea	(Art_Text).l,a5	; load level select font
		move.w	#$28F,d1

	Tit_LoadText:
		move.w	(a5)+,(a6)
		dbf	d1,Tit_LoadText	; load level select font

		move.b	#0,(v_lastlamp).w ; clear lamppost counter
		move.w	#0,(v_debuguse).w ; disable debug item placement mode
		move.w	#0,(f_demo).w	; disable debug mode
		move.w	#0,($FFFFFFEA).w ; unused variable
		move.w	#(id_GHZ<<8),(v_zone).w	; set level to GHZ (00)
		move.w	#0,(v_pcyc_time).w ; disable palette cycling
		
		jsr 	LoadSRAMConfig
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		lea	(v_16x16).w,a1
		lea	(Blk16_TS).l,a0 ; load	GHZ 16x16 mappings
		move.w	#0,d0
		bsr.w	EniDec
		lea	(Blk256_TS).l,a0 ; load GHZ 256x256 mappings
		lea	(v_256x256).l,a1
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		bsr.w	PaletteFadeOut
		disable_ints
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	DrawChunks
		lea	($FF0000).l,a1
		lea	(Eni_Title).l,a0 ; load	title screen mappings
		move.w	#0,d0
		bsr.w	EniDec

		copyTilemap	$FF0000,$C206,$21,$15

		locVRAM	0
		lea	(Nem_TS_1st).l,a0 ; load title screen patterns
		bsr.w	NemDec
		locVRAM	$F000
		lea	(Nem_TitleTM).l,a0 ; load title screen patterns
		bsr.w	NemDec
		moveq	#palid_Title,d0	; load title screen palette
		bsr.w	PalLoad1
		sfx		bgm_Title,0,1,1	; play title screen music
		move.b	#0,(f_debugmode).w ; disable debug mode
		move.w	#$900,(v_demolength).w ; run title screen for $178 frames
		lea	(v_objspace+$80).w,a1
		moveq	#0,d0
		move.w	#7,d1

	Tit_ClrObj2:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrObj2

		move.b	#id_TitleSonic,(v_objspace+$40).w ; load big Sonic object
		move.b	#id_PSBTM,(v_objspace+$80).w ; load "PRESS START BUTTON" object
		clr.b	(v_objspace+$80+obRoutine).w ; The 'Mega Games 10' version of Sonic 1 added this line, to fix the 'PRESS START BUTTON' object not appearing

		if Revision=0
		else
			tst.b   (v_megadrive).w	; is console Japanese?
			bpl.s   @isjap		; if yes, branch
		endc

		move.b	#id_PSBTM,(v_objspace+$C0).w ; load "TM" object
		move.b	#3,(v_objspace+$C0+obFrame).w
	@isjap:
		move.b	#id_PSBTM,(v_objspace+$100).w ; load object which hides part of Sonic
		move.b	#2,(v_objspace+$100+obFrame).w
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		moveq	#plcid_Main,d0
		bsr.w	NewPLC
		move.w	#0,(v_title_dcount).w
		move.w	#0,(v_title_ccount).w
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteFadeIn

Tit_MainLoop:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		bsr.w	PCycle_Title
		bsr.w	RunPLC
		move.w	(v_objspace+obX).w,d0
		addq.w	#2,d0
		move.w	d0,(v_objspace+obX).w ; move Sonic to the right
		cmpi.w	#$1C00,d0	; has Sonic object passed $1C00 on x-axis?
		blo.s	Tit_ChkRegion	; if not, branch

		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		rts	
; ===========================================================================

Tit_ChkRegion:
		tst.b	(v_megadrive).w	; check	if the machine is US or	Japanese
		bpl.s	Tit_RegionJap	; if Japanese, branch

		lea	(LevSelCode_US).l,a0 ; load US code
		bra.s	Tit_EnterCheat

	Tit_RegionJap:
		lea	(LevSelCode_J).l,a0 ; load J code

Tit_EnterCheat:
		move.w	(v_title_dcount).w,d0
		adda.w	d0,a0
		move.b	(v_jpadpress1).w,d0 ; get button press
		andi.b	#btnDir,d0	; read only UDLR buttons
		cmp.b	(a0),d0		; does button press match the cheat code?
		bne.s	Tit_ResetCheat	; if not, branch
		addq.w	#1,(v_title_dcount).w ; next button press
		tst.b	d0
		bne.s	Tit_CountC
		lea	(f_levselcheat).w,a0
		move.w	(v_title_ccount).w,d1
		lsr.w	#1,d1
		andi.w	#3,d1
		beq.s	Tit_PlayRing
		tst.b	(v_megadrive).w
		bpl.s	Tit_PlayRing
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)	; cheat depends on how many times C is pressed

	Tit_PlayRing:
		move.b	#1,(a0,d1.w)	; activate cheat
		sfx	sfx_Ring,0,1,1	; play ring sound when code is entered
		bra.s	Tit_CountC
; ===========================================================================

Tit_ResetCheat:
		tst.b	d0
		beq.s	Tit_CountC
		cmpi.w	#9,(v_title_dcount).w
		beq.s	Tit_CountC
		move.w	#0,(v_title_dcount).w ; reset UDLR counter

Tit_CountC:
		move.b	(v_jpadpress1).w,d0
		andi.b	#btnC,d0	; is C button pressed?
		beq.s	loc_3230	; if not, branch
		addq.w	#1,(v_title_ccount).w ; increment C counter
		
loc_3230:
		tst.w	(v_demolength).w
		beq.w	GotoDemo
		andi.b	#btnStart,(v_jpadpress1).w ; check if Start is pressed
		beq.w	Tit_MainLoop	; if not, branch

Tit_ChkLevSel:
		tst.b	(f_levselcheat).w ; check if level select code is on
		beq.w	@cont	; if not, play level
		btst	#bitA,(v_jpadhold1).w ; check if A is pressed
		beq.w	@cont	; if not, play level
		bra.w	Tit_LevelSelect

	@cont:		
		cmp.b	#6,($FFFFD0A4).w   ; is Title Menu on
		beq.w	Tit_MainLoop         ; if it not was deleted, branch  	
		moveq	#0,d2
		move.b	(Title_screen_option).w,d2   ; load the choice
		add.w	d2,d2            ; multiply by 2
		move.w	Tit_Menu_Choice(pc,d2.w),d2
		jmp   Tit_Menu_Choice(pc,d2.w)   ; jump to the choice code

; ===========================================================================
Tit_Menu_Choice:
		dc.w PlaySavedLevel-Tit_Menu_Choice   ; 0
		dc.w Menu_Options-Tit_Menu_Choice  ; 2
; ===========================================================================

Menu_Options:
		move.b	#$20,(v_gamemode).w
		rts

Tit_LevelSelect:	
		moveq	#palid_LevelSel,d0
		bsr.w	PalLoad2	; load level select palette
		lea	(v_hscrolltablebuffer).w,a1
		moveq	#0,d0
		move.w	#$DF,d1

	Tit_ClrScroll1:
		move.l	d0,(a1)+
		dbf	d1,Tit_ClrScroll1 ; clear scroll data (in RAM)

		move.l	d0,(v_scrposy_dup).w
		disable_ints
		lea	(vdp_data_port).l,a6
		locVRAM	$E000
		move.w	#$3FF,d1

	Tit_ClrScroll2:
		move.l	d0,(a6)
		dbf	d1,Tit_ClrScroll2 ; clear scroll data (in VRAM)

		bsr.w	LevSelTextLoad

; ---------------------------------------------------------------------------
; Level	Select
; ---------------------------------------------------------------------------

LevelSelect:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	LevSelControls
		bsr.w	RunPLC
		tst.l	(v_plc_buffer).w
		bne.s	LevelSelect
		andi.b	#btnABC+btnStart,(v_jpadpress1).w ; is A, B, C, or Start pressed?
		beq.s	LevelSelect	; if not, branch
		move.w	(v_levselitem).w,d0
		cmpi.w	#$14,d0		; have you selected item $14 (sound test)?
		bne.s	LevSel_Level_SS	; if not, go to	Level/SS subroutine
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		;cmpi.w	#$9F,d0		; is sound $9F being played?
		;beq.s	LevSel_Ending	; if yes, branch
		;cmpi.w	#$9E,d0		; is sound $9E being played?
		;beq.s	LevSel_Credits	; if yes, branch

LevSel_PlaySnd:
		bsr.w	PlaySound_Special
		bra.s	LevelSelect
; ===========================================================================

LevSel_Ending:
		move.b	#id_Ending,(v_gamemode).w ; set screen mode to $18 (Ending)
		move.w	#(id_EndZ<<8),(v_zone).w ; set level to 0600 (Ending)
		rts	
; ===========================================================================

LevSel_Credits:
		move.b	#id_Credits,(v_gamemode).w ; set screen mode to $1C (Credits)
		sfx	bgm_Tribute,0,1,1 ; play credits music
		move.w	#0,(v_creditsnum).w
		rts	
; ===========================================================================

LevSel_Level_SS:
		add.w	d0,d0
		move.w	LevSel_Ptrs(pc,d0.w),d0 ; load level number
		bmi.w	LevelSelect
		cmpi.w	#id_SS*$100,d0	; check	if level is 0700 (Special Stage)
		bne.s	LevSel_Level	; if not, branch
		move.b	#id_Special,(v_gamemode).w ; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).w	; clear	level
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		if Revision=0
		else
			move.l	#5000,(v_scorelife).w ; extra life is awarded at 50000 points
		endc
		rts	
; ===========================================================================

LevSel_Level:
		andi.w	#$3FFF,d0
		move.w	d0,(v_zone).w	; set level number

PlayLevel:
		move.b	#id_Level,(v_gamemode).w ; set screen mode to $0C (level)
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		; Commented out so it doesn't mess with save data
		move.l	d0,(v_score).w	; clear score
		move.b	#1,(v_continues).w ; set continues to 1
		;move.b	d0,(v_lastspecial).w ; clear special stage number
		move.b	d0,(v_emeralds).w ; clear emeralds
		;move.l	d0,(v_emldlist).w ; clear emeralds
		;move.l	d0,(v_emldlist+4).w ; clear emeralds
		
		;move.l	#5000,(v_scorelife).w ; extra life is awarded at 50000 points
		sfx	bgm_Fade,0,1,1 ; fade out music
		rts	
		
PlaySavedLevel:
		move.b	#id_Level,(v_gamemode).w ; set screen mode to $0C (level)
		jsr 	LoadSavedGame
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Level	select - level pointers
; ---------------------------------------------------------------------------
LevSel_Ptrs:	if Revision=0
		; old level order
		dc.b id_GHZ, 0
		dc.b id_GHZ, 1
		dc.b id_GHZ, 2
		dc.b id_LZ, 0
		dc.b id_LZ, 1
		dc.b id_LZ, 2
		dc.b id_MZ, 0
		dc.b id_MZ, 1
		dc.b id_MZ, 2
		dc.b id_SLZ, 0
		dc.b id_SLZ, 1
		dc.b id_SLZ, 2
		dc.b id_SYZ, 0
		dc.b id_SYZ, 1
		dc.b id_SYZ, 2
		dc.b id_SBZ, 0
		dc.b id_SBZ, 1
		dc.b id_LZ, 3		; Scrap Brain Zone 3
		dc.b id_SBZ, 2		; Final Zone
		else
		; correct level order
		dc.b id_GHZ, 0
		dc.b id_GHZ, 1
		dc.b id_GHZ, 2
		dc.b id_MZ, 0
		dc.b id_MZ, 1
		dc.b id_MZ, 2
		dc.b id_SYZ, 0
		dc.b id_SYZ, 1
		dc.b id_SYZ, 2
		dc.b id_LZ, 0
		dc.b id_LZ, 1
		dc.b id_LZ, 2
		dc.b id_SLZ, 0
		dc.b id_SLZ, 1
		dc.b id_SLZ, 2
		dc.b id_SBZ, 0
		dc.b id_SBZ, 1
		dc.b id_LZ, 3
		dc.b id_SBZ, 2
		endc
		dc.b id_SS, 0		; Special Stage
		dc.w $8000		; Sound Test
		even
; ---------------------------------------------------------------------------
; Level	select codes
; ---------------------------------------------------------------------------
LevSelCode_J:	if Revision=0
		dc.b btnUp,btnDn,btnL,btnR,0,$FF
		else
		dc.b btnUp,btnDn,btnDn,btnDn,btnL,btnR,0,$FF
		endc
		even

LevSelCode_US:	dc.b btnUp,btnDn,btnL,btnR,0,$FF
		even
; ===========================================================================

; ---------------------------------------------------------------------------
; Demo mode
; ---------------------------------------------------------------------------

GotoDemo:
		move.w	#$1E,(v_demolength).w

loc_33B6:
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	DeformLayers
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		move.w	(v_objspace+obX).w,d0
		addq.w	#2,d0
		move.w	d0,(v_objspace+obX).w
		cmpi.w	#$1C00,d0
		blo.s	loc_33E4
		move.b	#id_Sega,(v_gamemode).w
		rts	
; ===========================================================================

loc_33E4:
		andi.b	#btnStart,(v_jpadpress1).w ; is Start button pressed?
		bne.w	Tit_ChkLevSel	; if yes, branch
		tst.w	(v_demolength).w
		bne.w	loc_33B6
		sfx	bgm_Fade,0,1,1 ; fade out music
		move.w	(v_demonum).w,d0 ; load	demo number
		andi.w	#7,d0
		add.w	d0,d0
		move.w	Demo_Levels(pc,d0.w),d0	; load level number for	demo
		move.w	d0,(v_zone).w
		addq.w	#1,(v_demonum).w ; add 1 to demo number
		cmpi.w	#4,(v_demonum).w ; is demo number less than 4?
		blo.s	loc_3422	; if yes, branch
		move.w	#0,(v_demonum).w ; reset demo number to	0

loc_3422:
		move.w	#1,(f_demo).w	; turn demo mode on
		move.b	#id_Demo,(v_gamemode).w ; set screen mode to 08 (demo)
		cmpi.w	#$600,d0	; is level number 0600 (special	stage)?
		bne.s	Demo_Level	; if not, branch
		move.b	#id_Special,(v_gamemode).w ; set screen mode to $10 (Special Stage)
		clr.w	(v_zone).w	; clear	level number
		clr.b	(v_lastspecial).w ; clear special stage number

Demo_Level:
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		if Revision=0
		else
			move.l	#5000,(v_scorelife).w ; extra life is awarded at 50000 points
		endc
		rts	
; ===========================================================================
; ---------------------------------------------------------------------------
; Levels used in demos
; ---------------------------------------------------------------------------
Demo_Levels:	incbin	"misc\Demo Level Order - Intro.bin"
		even

; ---------------------------------------------------------------------------
; Subroutine to	change what you're selecting in the level select
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSelControls:
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnUp+btnDn,d1	; is up/down pressed and held?
		bne.s	LevSel_UpDown	; if yes, branch
		subq.w	#1,(v_levseldelay).w ; subtract 1 from time to next move
		bpl.s	LevSel_SndTest	; if time remains, branch

LevSel_UpDown:
		move.w	#$B,(v_levseldelay).w ; reset time delay
		move.b	(v_jpadhold1).w,d1
		andi.b	#btnUp+btnDn,d1	; is up/down pressed?
		beq.s	LevSel_SndTest	; if not, branch
		move.w	(v_levselitem).w,d0
		btst	#bitUp,d1	; is up	pressed?
		beq.s	LevSel_Down	; if not, branch
		subq.w	#1,d0		; move up 1 selection
		bhs.s	LevSel_Down
		moveq	#$14,d0		; if selection moves below 0, jump to selection	$14

LevSel_Down:
		btst	#bitDn,d1	; is down pressed?
		beq.s	LevSel_Refresh	; if not, branch
		addq.w	#1,d0		; move down 1 selection
		cmpi.w	#$15,d0
		blo.s	LevSel_Refresh
		moveq	#0,d0		; if selection moves above $14,	jump to	selection 0

LevSel_Refresh:
		move.w	d0,(v_levselitem).w ; set new selection
		bsr.w	LevSelTextLoad	; refresh text
		rts	
; ===========================================================================

LevSel_SndTest:
		cmpi.w	#$14,(v_levselitem).w ; is item $14 selected?
		bne.s	LevSel_NoMove	; if not, branch
		move.b	(v_jpadpress1).w,d1
		andi.b	#btnR+btnL,d1	; is left/right	pressed?
		beq.s	LevSel_NoMove	; if not, branch
		move.w	(v_levselsound).w,d0
		btst	#bitL,d1	; is left pressed?
		beq.s	LevSel_Right	; if not, branch
		subq.w	#1,d0		; subtract 1 from sound	test
		bhs.s	LevSel_Right
		moveq	#$55,d0		; if sound test	moves below 0, set to $55

LevSel_Right:
		btst	#bitR,d1	; is right pressed?
		beq.s	LevSel_Refresh2	; if not, branch
		addq.w	#1,d0		; add 1	to sound test
		cmpi.w	#$56,d0
		blo.s	LevSel_Refresh2
		moveq	#0,d0		; if sound test	moves above $55, set to	0

LevSel_Refresh2:
		move.w	d0,(v_levselsound).w ; set sound test number
		bsr.w	LevSelTextLoad	; refresh text

LevSel_NoMove:
		rts	
; End of function LevSelControls

; ---------------------------------------------------------------------------
; Subroutine to load level select text
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSelTextLoad:

	textpos:	= ($40000000+(($E210&$3FFF)<<16)+(($E210&$C000)>>14))
					; $E210 is a VRAM address

		lea	(LevelMenuText).l,a1
		lea	(vdp_data_port).l,a6
		move.l	#textpos,d4	; text position on screen
		move.w	#$E680,d3	; VRAM setting (4th palette, $680th tile)
		moveq	#$14,d1		; number of lines of text

	LevSel_DrawAll:
		move.l	d4,4(a6)
		bsr.w	LevSel_ChgLine	; draw line of text
		addi.l	#$800000,d4	; jump to next line
		dbf	d1,LevSel_DrawAll

		moveq	#0,d0
		move.w	(v_levselitem).w,d0
		move.w	d0,d1
		move.l	#textpos,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	(LevelMenuText).l,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$C680,d3	; VRAM setting (3rd palette, $680th tile)
		move.l	d4,4(a6)
		bsr.w	LevSel_ChgLine	; recolour selected line
		move.w	#$E680,d3
		cmpi.w	#$14,(v_levselitem).w
		bne.s	LevSel_DrawSnd
		move.w	#$C680,d3

LevSel_DrawSnd:
		locVRAM	$EC30		; sound test position on screen
		move.w	(v_levselsound).w,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	LevSel_ChgSnd	; draw 1st digit
		move.b	d2,d0
		bsr.w	LevSel_ChgSnd	; draw 2nd digit
		rts	
; End of function LevSelTextLoad


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_ChgSnd:
		andi.w	#$F,d0
		cmpi.b	#$A,d0		; is digit $A-$F?
		blo.s	LevSel_Numb	; if not, branch
		addi.b	#7,d0		; use alpha characters

	LevSel_Numb:
		add.w	d3,d0
		move.w	d0,(a6)
		rts	
; End of function LevSel_ChgSnd


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevSel_ChgLine:
		moveq	#$17,d2		; number of characters per line

	LevSel_LineLoop:
		moveq	#0,d0
		move.b	(a1)+,d0	; get character
		bpl.s	LevSel_CharOk	; branch if valid
		move.w	#0,(a6)		; use blank character
		dbf	d2,LevSel_LineLoop
		rts	


	LevSel_CharOk:
		add.w	d3,d0		; combine char with VRAM setting
		move.w	d0,(a6)		; send to VRAM
		dbf	d2,LevSel_LineLoop
		rts	
; End of function LevSel_ChgLine

; ===========================================================================
; ---------------------------------------------------------------------------
; Level	select menu text
; ---------------------------------------------------------------------------
LevelMenuText:	if Revision=0
		incbin	"misc\Level Select Text.bin"
		else
		incbin	"misc\Level Select Text (JP1).bin"
		endc
		even
; ---------------------------------------------------------------------------
; Music	playlist
; ---------------------------------------------------------------------------
MusicList:
			dc.b bgm_GHZ    ; GHZ1
        	dc.b bgm_LZ    ; GHZ2
        	dc.b bgm_Seaside   ; GHZ3
        	dc.b bgm_LZ    ; GHZ4
        	dc.b bgm_Stop    ; LZ1
        	dc.b bgm_Stop   ; LZ2
        	dc.b bgm_Stop    ; LZ3
        	dc.b bgm_SBZ3    ; LZ4
        	dc.b bgm_MZ    ; MZ1
        	dc.b bgm_SBZ    ; MZ2
        	dc.b bgm_RRZ2   ; MZ3
        	dc.b bgm_SBZ    ; MZ4
        	dc.b bgm_LZ    ; SLZ1
        	dc.b bgm_LZ    ; SLZ2
        	dc.b bgm_LZ    ; SLZ3
        	dc.b bgm_LZ    ; SLZ4
        	dc.b bgm_SYZ    ; SYZ1
        	dc.b bgm_SLZ    ; SYZ2
        	dc.b bgm_SLZ    ; SYZ3
        	dc.b bgm_SLZ    ; SYZ4
        	dc.b bgm_SBZ    ; SBZ1
        	dc.b bgm_SBZ    ; SBZ2
        	dc.b bgm_FZ		; SBZ3
        	dc.b bgm_SBZ    ; SBZ4
        	dc.b bgm_GHZ    ; GHZ1
        	dc.b bgm_GHZ    ; GHZ1
        	dc.b bgm_GHZ    ; GHZ1
        	dc.b bgm_GHZ    ; GHZ1
        	even
; ===========================================================================

; ---------------------------------------------------------------------------
; Level
; ---------------------------------------------------------------------------

GM_Level:
		bset	#7,(v_gamemode).w ; add $80 to screen mode (for pre level sequence)
		tst.w	(f_demo).w
		bmi.s	Level_NoMusicFade
		sfx	bgm_Fade,0,1,1 ; fade out music

	Level_NoMusicFade:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		tst.w	(f_demo).w	; is an ending sequence demo running?
		bmi.s	Level_ClrRam	; if yes, branch
		disable_ints
		locVRAM	$B000
		lea	(Nem_TitleCard).l,a0 ; load title card patterns
		bsr.w	NemDec
		enable_ints
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	loc_37FC
		bsr.w	AddPLC		; load level patterns

loc_37FC:
		moveq	#plcid_Main2,d0
		bsr.w	AddPLC		; load standard	patterns
		jsr	LoadLifeIcon

Level_ClrRam:
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

	Level_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrObjRam ; clear object RAM

		lea	($FFFFF628).w,a1
		moveq	#0,d0
		moveq	#$15,d1

	Level_ClrVars1:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrVars1 ; clear misc variables

		lea	(v_screenposx).w,a1
		moveq	#0,d0
		moveq	#$3F,d1

	Level_ClrVars2:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrVars2 ; clear misc variables

		lea	(v_oscillate+2).w,a1
		moveq	#0,d0
		moveq	#$47,d1

	Level_ClrVars3:
		move.l	d0,(a1)+
		dbf	d1,Level_ClrVars3 ; clear object variables

		disable_ints
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_hbla_hreg).w ; set palette change position (for water)
		move.w	(v_hbla_hreg).w,(a6)

		ResetDMAQueue

		jsr 	SaveGame

		cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
		bne.s	Level_LoadPal	; if not, branch

		move.w	#$8014,(a6)	; enable H-interrupts
		moveq	#0,d0
		move.b	(v_act).w,d0
		add.w	d0,d0
		lea	WaterHeight(pc),a1 ; load water	height array
		move.w	(a1,d0.w),d0
		move.w	d0,(v_waterpos1).w ; set water heights
		move.w	d0,(v_waterpos2).w
		move.w	d0,(v_waterpos3).w
		moveq	#0,d0
                move.b	d0,(v_wtr_routine).w ; clear water routine counter
		move.b	d0,(f_wtr_state).w	; clear	water state
		move.b	#1,(f_water).w	; enable water

Level_LoadPal:
		move.w	#$1E,($FFFFFE14).w
		move	#$2300,sr
		jsr		LoadPlayerPal
		bsr.w	PalLoad2	; load Sonic's pallet line
		cmp.b	#1,(f_water).w ; Is water enabled?
		bne.s	Level_GetBgm	; if not, branch
		jsr		LoadPlayerWaterPal
		bsr.w	PalLoad3_Water	; load underwater pallet (see d0)
		tst.b	($FFFFFE30).w
		beq.s	Level_GetBgm
		move.b	($FFFFFE53).w,($FFFFF64E).w

	Level_GetBgm:
		tst.w	(f_demo).w
        	bmi.s	Level_SkipTtlCard
        	moveq	#0,d0
		move.w	(v_zone).w,d0
		ror.b	#2,d0
		lsr.w   #6,d0
        	lea	(MusicList).l,a1 ; load    music playlist
        	move.b	(a1,d0.w),d0
		move.b	d0,((v_Saved_music)).w
        	bsr.w	PlaySound    ; play music
        	move.b	#id_TitleCard,(v_objspace+$80).w ; load title card object


Level_TtlCardLoop:
		move.b	#$C,(v_vbla_routine).w
		bsr.w	WaitForVBla
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	RunPLC
		move.w	(v_objspace+$108).w,d0
		cmp.w	(v_objspace+$130).w,d0 ; has title card sequence finished?
		bne.s	Level_TtlCardLoop ; if not, branch
		tst.l	(v_plc_buffer).w ; are there any items in the pattern load cue?
		bne.s	Level_TtlCardLoop ; if yes, branch
		jsr	(Hud_Base).l	; load basic HUD gfx

	Level_SkipTtlCard:
		jsr		LoadPlayerPal
		bsr.w	PalLoad1	; load Sonic's palette
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		bset	#2,(v_fg_scroll_flags).w
		bsr.w	LevelDataLoad ; load block mappings and palettes
		bsr.w	LoadTilesFromStart
		jsr	(FloorLog_Unk).l
		bsr.w	ColIndexLoad
		bsr.w	LZWaterFeatures
		move.b	#id_SonicPlayer,(v_player).w ; load Sonic object
		tst.w	(f_demo).w
		bmi.s	Level_ChkDebug
		move.b	#id_HUD,(v_objspace+$40).w ; load HUD object

Level_ChkDebug:
		tst.b	(f_debugcheat).w ; has debug cheat been entered?
		beq.s	Level_ChkWater	; if not, branch
		btst	#bitA,(v_jpadhold1).w ; is A button held?
		beq.s	Level_ChkWater	; if not, branch
		move.b	#1,(f_debugmode).w ; enable debug mode

Level_ChkWater:
		moveq	#0,d0
                move.w	d0,(v_jpadhold2).w
		move.w	d0,(v_jpadhold1).w
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ?
		bne.s	Level_LoadObj	; if not, branch
		move.b	#id_WaterSurface,(v_objspace+$780).w ; load water surface object
		move.w	#$60,(v_objspace+$780+obX).w
		move.b	#id_WaterSurface,(v_objspace+$7C0).w
		move.w	#$120,(v_objspace+$7C0+obX).w

Level_LoadObj:
		jsr	(ObjPosLoad).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		moveq	#0,d0
		tst.b	(v_lastlamp).w	; are you starting from	a lamppost?
		bne.s	Level_SkipClr	; if yes, branch
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.b	d0,(v_lifecount).w ; clear lives counter
		move.b	#0,(v_tagwater).w	;TIS - reset water state

	Level_SkipClr:
		move.b	d0,(f_timeover).w
		move.b	d0,(v_shield).w	; clear shield
		move.b	d0,(v_rshield).w; clear red shield
		move.b	d0,(v_gshield).w; clear gold shield
		move.b	d0,(v_spshield).w; clear gold shield
		move.b	d0,(v_invinc).w	; clear invincibility
		move.b	d0,(v_shoes).w	; clear speed shoes
		move.b	d0,($FFFFFE2F).w
		move.w	d0,(v_debuguse).w
		move.w	d0,(f_restart).w
		move.w	d0,(v_framecount).w
		bsr.w	OscillateNumInit
		moveq	#1,d0
                move.b	d0,(f_scorecount).w ; update score counter
		move.b	d0,(f_ringcount).w ; update rings counter
		move.b	d0,(f_timecount).w ; update time counter
		move.w	#0,(v_btnpushtime1).w
		lea	(DemoDataPtr).l,a1 ; load demo data
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		tst.w	(f_demo).w	; is demo mode on?
		bpl.s	Level_Demo	; if yes, branch
		lea	(DemoEndDataPtr).l,a1 ; load ending demo data
		move.w	(v_creditsnum).w,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1

Level_Demo:
		move.b	1(a1),(v_btnpushtime2).w ; load key press duration
		subq.b	#1,(v_btnpushtime2).w ; subtract 1 from duration
		move.w	#1800,(v_demolength).w
		tst.w	(f_demo).w
		bpl.s	Level_ChkWaterPal
		move.w	#540,(v_demolength).w
		cmpi.w	#4,(v_creditsnum).w
		bne.s	Level_ChkWaterPal
		move.w	#510,(v_demolength).w

Level_ChkWaterPal:
		cmpi.b	#id_LZ,(v_zone).w ; is level LZ/SBZ3?
		bne.s	Level_Delay	; if not, branch
		moveq	#palid_LZWater,d0 ; palette $B (LZ underwater)
		cmpi.b	#3,(v_act).w	; is level SBZ3?
		bne.s	Level_WtrNotSbz	; if not, branch
		moveq	#palid_SBZ3Water,d0 ; palette $D (SBZ3 underwater)

	Level_WtrNotSbz:
		bsr.w	PalLoad4_Water

Level_Delay:
		moveq	#3,d1

	Level_DelayLoop:
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		dbf	d1,Level_DelayLoop

		move.w	#$202F,(v_pfade_start).w ; fade in 2nd, 3rd & 4th palette lines
		bsr.w	PalFadeIn_Alt
		tst.w	(f_demo).w	; is an ending sequence demo running?
		bmi.s	Level_ClrCardArt ; if yes, branch
		addq.b	#2,(v_objspace+$80+obRoutine).w ; make title card move
		addq.b	#4,(v_objspace+$C0+obRoutine).w
		addq.b	#4,(v_objspace+$100+obRoutine).w
		addq.b	#4,(v_objspace+$140+obRoutine).w
		bra.s	Level_StartGame
; ===========================================================================

Level_ClrCardArt:
		moveq	#plcid_Explode,d0
		jsr	(AddPLC).l	; load explosion gfx
		moveq	#0,d0
		move.b	(v_zone).w,d0
		addi.w	#plcid_GHZAnimals,d0
		jsr	(AddPLC).l	; load animal gfx (level no. + $15)

Level_StartGame:
		bclr	#7,(v_gamemode).w ; subtract $80 from mode to end pre-level stuff

; ---------------------------------------------------------------------------
; Main level loop (when	all title card and loading sequences are finished)
; ---------------------------------------------------------------------------

Level_MainLoop:
		bsr.w	PauseGame
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		addq.w	#1,(v_framecount).w ; add 1 to level timer
		bsr.w	MoveSonicInDemo
		bsr.w	LZWaterFeatures
		jsr	(ExecuteObjects).l
		if Revision=0
		else
			tst.w   (f_restart).w
			bne     GM_Level
		endc
		tst.w	(v_debuguse).w	; is debug mode being used?
		bne.s	Level_DoScroll	; if yes, branch
		cmpi.b	#6,(v_player+obRoutine).w ; has Sonic just died?
		bhs.s	Level_SkipScroll ; if yes, branch

	Level_DoScroll:
		bsr.w	DeformLayers

	Level_SkipScroll:
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	PaletteCycle
		bsr.w	RunPLC
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		bsr.w	SignpostArtLoad

		cmpi.b	#id_Demo,(v_gamemode).w
		beq.s	Level_ChkDemo	; if mode is 8 (demo), branch
		if Revision=0
		tst.w	(f_restart).w	; is the level set to restart?
		bne.w	GM_Level	; if yes, branch
		else
		endc

		tst.b	(v_flashtimer).w ; is white flash counter empty?
		beq.s	@Continue	; if yes, branch
		
		subq.b	#1,(v_flashtimer).w	; sub 1 from counter
		cmpi.b	#1,(v_flashtimer).w	; sub 1 from counter
		bge.s	@Continue	; is counter now empty? if not, branch
		
		lea	($FFFFFA80).w,a4	; load palette location to a4
		lea	($FFFFCA00).w,a3	; load backed up palette to a3
		move.w	#$007F,d5		; set d3 to $7F (+1 for the first run)

@RestorePalette:
		move.w	(a3)+,(a4)+		; set new palette palette
		dbf	d5,@RestorePalette	; loop

@Continue:
		cmpi.b	#id_Level,(v_gamemode).w
		beq.w	Level_MainLoop	; if mode is $C (level), branch
		jmp	SaveGame	; this saves sram when you exit the game mode, fixing an issues with saved lives
; ===========================================================================

Level_ChkDemo:
		tst.w	(f_restart).w	; is level set to restart?
		bne.s	Level_EndDemo	; if yes, branch
		tst.w	(v_demolength).w ; is there time left on the demo?
		beq.s	Level_EndDemo	; if not, branch
		cmpi.b	#id_Demo,(v_gamemode).w
		beq.w	Level_MainLoop	; if mode is 8 (demo), branch
		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		rts	
; ===========================================================================

Level_EndDemo:
		cmpi.b	#id_Demo,(v_gamemode).w
		bne.s	Level_FadeDemo	; if mode is 8 (demo), branch
		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		tst.w	(f_demo).w	; is demo mode on & not ending sequence?
		bpl.s	Level_FadeDemo	; if yes, branch
		move.b	#id_Credits,(v_gamemode).w ; go to credits

Level_FadeDemo:
		move.w	#$3C,(v_demolength).w
		move.w	#$3F,(v_pfade_start).w
		clr.w	(v_palchgspeed).w

	Level_FDLoop:
		move.b	#8,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	MoveSonicInDemo
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		subq.w	#1,(v_palchgspeed).w
		bpl.s	loc_3BC8
		move.w	#2,(v_palchgspeed).w
		bsr.w	FadeOut_ToBlack

loc_3BC8:
		tst.w	(v_demolength).w
		bne.s	Level_FDLoop
		rts	
; ===========================================================================

		include	"_inc\LZWaterFeatures.asm"
		include	"_inc\MoveSonicInDemo.asm"

; ---------------------------------------------------------------------------
; Collision index pointer loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ColIndexLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#2,d0
		move.l	ColPointers(pc,d0.w),(v_collindex).w
		rts	
; End of function ColIndexLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision index pointers
; ---------------------------------------------------------------------------
ColPointers:	dc.l Col_GHZ
		dc.l Col_LZ
		dc.l Col_MZ
		dc.l Col_SLZ
		dc.l Col_SYZ
		dc.l Col_SBZ
		zonewarning ColPointers,4
;		dc.l Col_GHZ ; Pointer for Ending is missing by default.

		include	"_inc\Oscillatory Routines.asm"

; ---------------------------------------------------------------------------
; Subroutine to	change synchronised animation variables (rings, giant rings)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SynchroAnimate:

; Used for GHZ spiked log
Sync1:
		subq.b	#1,(v_ani0_time).w ; has timer reached 0?
		bpl.s	Sync2		; if not, branch
		move.b	#$B,(v_ani0_time).w ; reset timer
		subq.b	#1,(v_ani0_frame).w ; next frame
		andi.b	#7,(v_ani0_frame).w ; max frame is 7

; Used for rings and giant rings
Sync2:
		subq.b	#1,(v_ani1_time).w
		bpl.s	Sync3
		move.b	#7,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#3,(v_ani1_frame).w

; Used for nothing
Sync3:
		subq.b	#1,(v_ani2_time).w
		bpl.s	Sync4
		move.b	#7,(v_ani2_time).w
		addq.b	#1,(v_ani2_frame).w
		cmpi.b	#6,(v_ani2_frame).w
		blo.s	Sync4
		move.b	#0,(v_ani2_frame).w

; Used for bouncing rings
Sync4:
		tst.b	(v_ani3_time).w
		beq.s	SyncEnd
		moveq	#0,d0
		move.b	(v_ani3_time).w,d0
		add.w	(v_ani3_buf).w,d0
		move.w	d0,(v_ani3_buf).w
		rol.w	#7,d0
		andi.w	#3,d0
		move.b	d0,(v_ani3_frame).w
		subq.b	#1,(v_ani3_time).w

SyncEnd:
		rts	
; End of function SynchroAnimate

; ---------------------------------------------------------------------------
; End-of-act signpost pattern loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SignpostArtLoad:
		tst.w	(v_debuguse).w	; is debug mode	being used?
		bne.w	@exit		; if yes, branch
		cmpi.b	#2,(v_act).w	; is act number 02 (act 3)?
		beq.s	@exit		; if yes, branch

		move.w	(v_screenposx).w,d0
		move.w	(v_limitright2).w,d1
		subi.w	#$100,d1
		cmp.w	d1,d0		; has Sonic reached the	edge of	the level?
		blt.s	@exit		; if not, branch
		tst.b	(f_timecount).w
		beq.s	@exit
		cmp.w	(v_limitleft2).w,d1
		beq.s	@exit
		move.w	d1,(v_limitleft2).w ; move left boundary to current screen position
		moveq	#plcid_Signpost,d0
		bra.w	NewPLC		; load signpost	patterns

	@exit:
		rts	
; End of function SignpostArtLoad

; ===========================================================================
Demo_GHZ:	incbin	"demodata\Intro - GHZ.bin"
Demo_MZ:	incbin	"demodata\Intro - MZ.bin"
Demo_SYZ:	incbin	"demodata\Intro - SYZ.bin"
Demo_SS:	incbin	"demodata\Intro - Special Stage.bin"
; ===========================================================================

; ---------------------------------------------------------------------------
; Special Stage
; ---------------------------------------------------------------------------

GM_Special:
		sfx	sfx_EnterSS,0,1,0 ; play special stage entry sound
		bsr.w	PaletteWhiteOut
		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8004,(a6)	; 8-colour mode
		move.w	#$8A00+175,(v_hbla_hreg).w
		move.w	#$9011,(a6)	; 128-cell hscroll size
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		enable_ints
		fillVRAM	0,$6FFF,$5000

	SS_WaitForDMA:
		move.w	(a5),d1		; read control port ($C00004)
		btst	#1,d1		; is DMA running?
		bne.s	SS_WaitForDMA	; if yes, branch
		move.w	#$8F02,(a5)	; set VDP increment to 2 bytes
		bsr.w	SS_BGLoad
		moveq	#plcid_SpecialStage,d0
		bsr.w	QuickPLC	; load special stage patterns

		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	SS_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrObjRam	; clear	the object RAM

		lea	(v_screenposx).w,a1
		moveq	#0,d0
		move.w	#$3F,d1
	SS_ClrRam1:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrRam1	; clear	variables

		lea	(v_oscillate+2).w,a1
		moveq	#0,d0
		move.w	#$27,d1
	SS_ClrRam2:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrRam2	; clear	variables

		lea	(v_ngfx_buffer).w,a1
		moveq	#0,d0
		move.w	#$7F,d1
	SS_ClrNemRam:
		move.l	d0,(a1)+
		dbf	d1,SS_ClrNemRam	; clear	Nemesis	buffer

		clr.b	(f_wtr_state).w
		clr.w	(f_restart).w
		moveq	#palid_Special,d0
		bsr.w	PalLoad1	; load special stage palette
		jsr	(SS_Load).l		; load SS layout data
		move.l	#0,(v_screenposx).w
		move.l	#0,(v_screenposy).w
		move.b	#id_SonicSpecial,(v_player).w ; load special stage Sonic object
		bsr.w	PalCycle_SS
		clr.w	(v_ssangle).w	; set stage angle to "upright"
		move.w	#$40,(v_ssrotate).w ; set stage rotation speed
		music	bgm_SS,0,1,0	; play special stage BG	music
		move.w	#0,(v_btnpushtime1).w
		lea	(DemoDataPtr).l,a1
		moveq	#6,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		move.b	1(a1),(v_btnpushtime2).w
		subq.b	#1,(v_btnpushtime2).w
		clr.w	(v_rings).w
		clr.b	(v_lifecount).w
		move.w	#0,(v_debuguse).w
		move.w	#1800,(v_demolength).w
		tst.b	(f_debugcheat).w ; has debug cheat been entered?
		beq.s	SS_NoDebug	; if not, branch
		btst	#bitA,(v_jpadhold1).w ; is A button pressed?
		beq.s	SS_NoDebug	; if not, branch
		move.b	#1,(f_debugmode).w ; enable debug mode

	SS_NoDebug:
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteWhiteIn

; ---------------------------------------------------------------------------
; Main Special Stage loop
; ---------------------------------------------------------------------------

SS_MainLoop:
		bsr.w	PauseGame
		move.b	#$A,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	MoveSonicInDemo
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(SS_ShowLayout).l
		bsr.w	SS_BGAnimate
		tst.w	(f_demo).w	; is demo mode on?
		beq.s	SS_ChkEnd	; if not, branch
		tst.w	(v_demolength).w ; is there time left on the demo?
		beq.w	SS_ToSegaScreen	; if not, branch

	SS_ChkEnd:
		cmpi.b	#id_Special,(v_gamemode).w ; is game mode $10 (special stage)?
		beq.w	SS_MainLoop	; if yes, branch

		tst.w	(f_demo).w	; is demo mode on?
		if Revision=0
		bne.w	SS_ToSegaScreen	; if yes, branch
		else
		bne.w	SS_ToLevel
		endc
		move.b	#id_Level,(v_gamemode).w ; set screen mode to $0C (level)
		cmpi.w	#(id_SBZ<<8)+3,(v_zone).w ; is level number higher than FZ?
		blo.s	SS_Finish	; if not, branch
		clr.w	(v_zone).w	; set to GHZ1

SS_Finish:
		move.w	#60,(v_demolength).w ; set delay time to 1 second
		move.w	#$3F,(v_pfade_start).w
		clr.w	(v_palchgspeed).w

	SS_FinLoop:
		move.b	#$16,(v_vbla_routine).w
		bsr.w	WaitForVBla
		bsr.w	MoveSonicInDemo
		move.w	(v_jpadhold1).w,(v_jpadhold2).w
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		jsr	(SS_ShowLayout).l
		bsr.w	SS_BGAnimate
		subq.w	#1,(v_palchgspeed).w
		bpl.s	loc_47D4
		move.w	#2,(v_palchgspeed).w
		bsr.w	WhiteOut_ToWhite

loc_47D4:
		tst.w	(v_demolength).w
		bne.s	SS_FinLoop

		disable_ints
		lea	(vdp_control_port).l,a6
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		bsr.w	ClearScreen
		locVRAM	$B000
		lea	(Nem_TitleCard).l,a0 ; load title card patterns
		bsr.w	NemDec
		jsr	(Hud_Base).l
		ResetDMAQueue	
		enable_ints
		moveq	#palid_SSResult,d0
		bsr.w	PalLoad2	; load results screen palette
		moveq	#plcid_Main,d0
		bsr.w	NewPLC
		moveq	#plcid_SSResult,d0
		bsr.w	AddPLC		; load results screen patterns
		move.b	#1,(f_scorecount).w ; update score counter
		move.b	#1,(f_endactbonus).w ; update ring bonus counter
		move.w	(v_rings).w,d0
		mulu.w	#10,d0		; multiply rings by 10
		move.w	d0,(v_ringbonus).w ; set rings bonus
		sfx	bgm_GotThrough,0,0,0	 ; play end-of-level music

		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	SS_EndClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,SS_EndClrObjRam ; clear object RAM

		move.b	#id_SSResult,(v_objspace+$5C0).w ; load results screen object

SS_NormalExit:
		bsr.w	PauseGame
		move.b	#$C,(v_vbla_routine).w
		bsr.w	WaitForVBla
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		bsr.w	RunPLC
		tst.w	(f_restart).w
		beq.s	SS_NormalExit
		tst.l	(v_plc_buffer).w
		bne.s	SS_NormalExit
		sfx	sfx_EnterSS,0,1,0 ; play special stage exit sound
		bsr.w	PaletteWhiteOut
		rts	
; ===========================================================================

SS_ToSegaScreen:
		move.b	#id_Sega,(v_gamemode).w ; goto Sega screen
		rts

		if Revision=0
		else
SS_ToLevel:	cmpi.b	#id_Level,(v_gamemode).w
		beq.s	SS_ToSegaScreen
		rts
		endc

; ---------------------------------------------------------------------------
; Special stage	background loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_BGLoad:
		lea	($FF0000).l,a1
		lea	(Eni_SSBg1).l,a0 ; load	mappings for the birds and fish
		move.w	#$4051,d0
		bsr.w	EniDec
		move.l	#$50000001,d3
		lea	($FF0080).l,a2
		moveq	#6,d7

loc_48BE:
		move.l	d3,d0
		moveq	#3,d6
		moveq	#0,d4
		cmpi.w	#3,d7
		bhs.s	loc_48CC
		moveq	#1,d4

loc_48CC:
		moveq	#7,d5

loc_48CE:
		movea.l	a2,a1
		eori.b	#1,d4
		bne.s	loc_48E2
		cmpi.w	#6,d7
		bne.s	loc_48F2
		lea	($FF0000).l,a1

loc_48E2:
		movem.l	d0-d4,-(sp)
		moveq	#7,d1
		moveq	#7,d2
		bsr.w	TilemapToVRAM
		movem.l	(sp)+,d0-d4

loc_48F2:
		addi.l	#$100000,d0
		dbf	d5,loc_48CE
		addi.l	#$3800000,d0
		eori.b	#1,d4
		dbf	d6,loc_48CC
		addi.l	#$10000000,d3
		bpl.s	loc_491C
		swap	d3
		addi.l	#$C000,d3
		swap	d3

loc_491C:
		adda.w	#$80,a2
		dbf	d7,loc_48BE
		lea	($FF0000).l,a1
		lea	(Eni_SSBg2).l,a0 ; load	mappings for the clouds
		move.w	#$4000,d0
		bsr.w	EniDec
		lea	($FF0000).l,a1
		move.l	#$40000003,d0
		moveq	#$3F,d1
		moveq	#$1F,d2
		bsr.w	TilemapToVRAM
		lea	($FF0000).l,a1
		move.l	#$50000003,d0
		moveq	#$3F,d1
		moveq	#$3F,d2
		bsr.w	TilemapToVRAM
		rts	
; End of function SS_BGLoad

; ---------------------------------------------------------------------------
; Palette cycling routine - special stage
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


PalCycle_SS:
		tst.w	(f_pause).w
		bne.s	locret_49E6
		subq.w	#1,(v_palss_time).w
		bpl.s	locret_49E6
		lea	(vdp_control_port).l,a6
		move.w	(v_palss_num).w,d0
		addq.w	#1,(v_palss_num).w
		andi.w	#$1F,d0
		lsl.w	#2,d0
		lea	(byte_4A3C).l,a0
		adda.w	d0,a0
		move.b	(a0)+,d0
		bpl.s	loc_4992
		move.w	#$1FF,d0

loc_4992:
		move.w	d0,(v_palss_time).w
		moveq	#0,d0
		move.b	(a0)+,d0
		move.w	d0,($FFFFF7A0).w
		lea	(byte_4ABC).l,a1
		lea	(a1,d0.w),a1
		move.w	#-$7E00,d0
		move.b	(a1)+,d0
		move.w	d0,(a6)
		move.b	(a1),(v_scrposy_dup).w
		move.w	#-$7C00,d0
		move.b	(a0)+,d0
		move.w	d0,(a6)
		move.l	#$40000010,(vdp_control_port).l
		move.l	(v_scrposy_dup).w,(vdp_data_port).l
		moveq	#0,d0
		move.b	(a0)+,d0
		bmi.s	loc_49E8
		lea	(Pal_SSCyc1).l,a1
		adda.w	d0,a1
		lea	(v_pal_dry+$4E).w,a2
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+
		move.l	(a1)+,(a2)+

locret_49E6:
		rts	
; ===========================================================================

loc_49E8:
		move.w	($FFFFF79E).w,d1
		cmpi.w	#$8A,d0
		blo.s	loc_49F4
		addq.w	#1,d1

loc_49F4:
		mulu.w	#$2A,d1
		lea	(Pal_SSCyc2).l,a1
		adda.w	d1,a1
		andi.w	#$7F,d0
		bclr	#0,d0
		beq.s	loc_4A18
		lea	(v_pal_dry+$6E).w,a2
		move.l	(a1),(a2)+
		move.l	4(a1),(a2)+
		move.l	8(a1),(a2)+

loc_4A18:
		adda.w	#$C,a1
		lea	(v_pal_dry+$5A).w,a2
		cmpi.w	#$A,d0
		blo.s	loc_4A2E
		subi.w	#$A,d0
		lea	(v_pal_dry+$7A).w,a2

loc_4A2E:
		move.w	d0,d1
		add.w	d0,d0
		add.w	d1,d0
		adda.w	d0,a1
		move.l	(a1)+,(a2)+
		move.w	(a1)+,(a2)+
		rts	
; End of function PalCycle_SS

; ===========================================================================
byte_4A3C:	dc.b 3,	0, 7, $92, 3, 0, 7, $90, 3, 0, 7, $8E, 3, 0, 7,	$8C

		dc.b 3,	0, 7, $8B, 3, 0, 7, $80, 3, 0, 7, $82, 3, 0, 7,	$84
		dc.b 3,	0, 7, $86, 3, 0, 7, $88, 7, 8, 7, 0, 7,	$A, 7, $C
		dc.b $FF, $C, 7, $18, $FF, $C, 7, $18, 7, $A, 7, $C, 7,	8, 7, 0
		dc.b 3,	0, 6, $88, 3, 0, 6, $86, 3, 0, 6, $84, 3, 0, 6,	$82
		dc.b 3,	0, 6, $81, 3, 0, 6, $8A, 3, 0, 6, $8C, 3, 0, 6,	$8E
		dc.b 3,	0, 6, $90, 3, 0, 6, $92, 7, 2, 6, $24, 7, 4, 6,	$30
		dc.b $FF, 6, 6,	$3C, $FF, 6, 6,	$3C, 7,	4, 6, $30, 7, 2, 6, $24
		even
byte_4ABC:	dc.b $10, 1, $18, 0, $18, 1, $20, 0, $20, 1, $28, 0, $28, 1
		even

Pal_SSCyc1:	incbin	"palette\Cycle - Special Stage 1.bin"
		even
Pal_SSCyc2:	incbin	"palette\Cycle - Special Stage 2.bin"
		even

; ---------------------------------------------------------------------------
; Subroutine to	make the special stage background animated
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_BGAnimate:
		move.w	($FFFFF7A0).w,d0
		bne.s	loc_4BF6
		move.w	#0,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w

loc_4BF6:
		cmpi.w	#8,d0
		bhs.s	loc_4C4E
		cmpi.w	#6,d0
		bne.s	loc_4C10
		addq.w	#1,(v_bg3screenposx).w
		addq.w	#1,(v_bgscreenposy).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w

loc_4C10:
		moveq	#0,d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		swap	d0
		lea	(byte_4CCC).l,a1
		lea	(v_ngfx_buffer).w,a3
		moveq	#9,d3

loc_4C26:
		move.w	2(a3),d0
		bsr.w	CalcSine
		moveq	#0,d2
		move.b	(a1)+,d2
		muls.w	d2,d0
		asr.l	#8,d0
		move.w	d0,(a3)+
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d2,(a3)+
		dbf	d3,loc_4C26
		lea	(v_ngfx_buffer).w,a3
		lea	(byte_4CB8).l,a2
		bra.s	loc_4C7E
; ===========================================================================

loc_4C4E:
		cmpi.w	#$C,d0
		bne.s	loc_4C74
		subq.w	#1,(v_bg3screenposx).w
		lea	($FFFFAB00).w,a3
		move.l	#$18000,d2
		moveq	#6,d1

loc_4C64:
		move.l	(a3),d0
		sub.l	d2,d0
		move.l	d0,(a3)+
		subi.l	#$2000,d2
		dbf	d1,loc_4C64

loc_4C74:
		lea	($FFFFAB00).w,a3
		lea	(byte_4CC4).l,a2

loc_4C7E:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		swap	d0
		moveq	#0,d3
		move.b	(a2)+,d3
		move.w	(v_bgscreenposy).w,d2
		neg.w	d2
		andi.w	#$FF,d2
		lsl.w	#2,d2

loc_4C9A:
		move.w	(a3)+,d0
		addq.w	#2,a3
		moveq	#0,d1
		move.b	(a2)+,d1
		subq.w	#1,d1

loc_4CA4:
		move.l	d0,(a1,d2.w)
		addq.w	#4,d2
		andi.w	#$3FC,d2
		dbf	d1,loc_4CA4
		dbf	d3,loc_4C9A
		rts	
; End of function SS_BGAnimate

; ===========================================================================
byte_4CB8:	dc.b 9,	$28, $18, $10, $28, $18, $10, $30, $18,	8, $10,	0
		even
byte_4CC4:	dc.b 6,	$30, $30, $30, $28, $18, $18, $18
		even
byte_4CCC:	dc.b 8,	2, 4, $FF, 2, 3, 8, $FF, 4, 2, 2, 3, 8,	$FD, 4,	2, 2, 3, 2, $FF
		even

; ===========================================================================

; ---------------------------------------------------------------------------
; Continue screen
; ---------------------------------------------------------------------------

GM_Continue:
		bsr.w	PaletteFadeOut
		disable_ints
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; 8 colour mode
		move.w	#$8700,(a6)	; background colour
		bsr.w	ClearScreen
		ResetDMAQueue
		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	Cont_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,Cont_ClrObjRam ; clear object RAM

		locVRAM	$B000
		lea	(Nem_TitleCard).l,a0 ; load title card patterns
		bsr.w	NemDec
		locVRAM	$A000
		lea	(Nem_ContSonic).l,a0 ; load Sonic patterns
		bsr.w	NemDec
		locVRAM	$AA20
		lea	(Nem_MiniSonic).l,a0 ; load continue screen patterns
		bsr.w	NemDec
		moveq	#10,d1
		jsr	(ContScrCounter).l	; run countdown	(start from 10)
		moveq	#palid_Continue,d0
		bsr.w	PalLoad1	; load continue	screen palette
		music	bgm_Continue,0,1,1	; play continue	music
		move.w	#659,(v_demolength).w ; set time delay to 11 seconds
		clr.l	(v_screenposx).w
		move.l	#$1000000,(v_screenposy).w
		move.b	#id_ContSonic,(v_player).w ; load Sonic object
		move.b	#id_ContScrItem,(v_objspace+$40).w ; load continue screen objects
		move.b	#id_ContScrItem,(v_objspace+$80).w
		move.b	#3,(v_objspace+$80+obPriority).w
		move.b	#4,(v_objspace+$80+obFrame).w
		move.b	#id_ContScrItem,(v_objspace+$C0).w
		move.b	#4,(v_objspace+$C0+obRoutine).w
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Continue screen main loop
; ---------------------------------------------------------------------------

Cont_MainLoop:
		move.b	#$16,(v_vbla_routine).w
		bsr.w	WaitForVBla
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	loc_4DF2
		disable_ints
		move.w	(v_demolength).w,d1
		divu.w	#$3C,d1
		andi.l	#$F,d1
		jsr	(ContScrCounter).l
		enable_ints

loc_4DF2:
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		cmpi.w	#$180,(v_player+obX).w ; has Sonic run off screen?
		bhs.s	Cont_GotoLevel	; if yes, branch
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	Cont_MainLoop
		tst.w	(v_demolength).w
		bne.w	Cont_MainLoop
		move.b	#id_Sega,(v_gamemode).w ; go to Sega screen
		rts	
; ===========================================================================

Cont_GotoLevel:
		move.b	#id_Level,(v_gamemode).w ; set screen mode to $0C (level)
		move.b	#3,(v_lives).w	; set lives to 3
		moveq	#0,d0
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		move.b	d0,(v_lastlamp).w ; clear lamppost count
		subq.b	#1,(v_continues).w ; subtract 1 from continues
		rts	
; ===========================================================================

		include	"_incObj\80 Continue Screen Elements.asm"
		include	"_incObj\81 Continue Screen Sonic.asm"
		include	"_anim\Continue Screen Sonic.asm"
Map_ContScr:	include	"_maps\Continue Screen.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Ending sequence in Green Hill	Zone
; ---------------------------------------------------------------------------

GM_Ending:
		sfx	bgm_Stop,0,1,1 ; stop music
		bsr.w	PaletteFadeOut

		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	End_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,End_ClrObjRam ; clear object	RAM

		lea	($FFFFF628).w,a1
		moveq	#0,d0
		move.w	#$15,d1
	End_ClrRam1:
		move.l	d0,(a1)+
		dbf	d1,End_ClrRam1	; clear	variables

		lea	(v_screenposx).w,a1
		moveq	#0,d0
		move.w	#$3F,d1
	End_ClrRam2:
		move.l	d0,(a1)+
		dbf	d1,End_ClrRam2	; clear	variables

		lea	(v_oscillate+2).w,a1
		moveq	#0,d0
		move.w	#$47,d1
	End_ClrRam3:
		move.l	d0,(a1)+
		dbf	d1,End_ClrRam3	; clear	variables

		disable_ints
		move.w	(v_vdp_buffer1).w,d0
		andi.b	#$BF,d0
		move.w	d0,(vdp_control_port).l
		bsr.w	ClearScreen
		lea	(vdp_control_port).l,a6
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$8500+(vram_sprites>>9),(a6) ; set sprite table address
		move.w	#$9001,(a6)		; 64-cell hscroll size
		move.w	#$8004,(a6)		; 8-colour mode
		move.w	#$8720,(a6)		; set background colour (line 3; colour 0)
		move.w	#$8A00+223,(v_hbla_hreg).w ; set palette change position (for water)
		move.w	(v_hbla_hreg).w,(a6)
		move.w	#30,(v_air).w
		move.w	#id_EndZ<<8,(v_zone).w ; set level number to 0600 (extra flowers)
		cmpi.b	#0,(v_emeralds).w ; do you have all 6 emeralds?
		beq.s	End_LoadData	; if yes, branch
		move.w	#(id_EndZ<<8)+1,(v_zone).w ; set level number to 0601 (no flowers)

End_LoadData:
		moveq	#plcid_Ending,d0
		bsr.w	QuickPLC	; load ending sequence patterns
		jsr	(Hud_Base).l
		bsr.w	LevelSizeLoad
		bsr.w	DeformLayers
		bset	#2,(v_fg_scroll_flags).w
		bsr.w	LevelDataLoad
		bsr.w	LoadTilesFromStart
		move.l	#Col_GHZ,(v_collindex).w ; load collision index
		enable_ints
		lea	(Kos_EndFlowers).l,a0 ;	load extra flower patterns
		lea	($FFFF9400).w,a1 ; RAM address to buffer the patterns
		bsr.w	KosDec
		jsr		LoadPlayerPal
		bsr.w	PalLoad1	; load Sonic's palette
		music	bgm_Tribute,0,1,0	; play ending sequence music
		btst	#bitA,(v_jpadhold1).w ; is button A pressed?
		beq.s	End_LoadSonic	; if not, branch
		move.b	#1,(f_debugmode).w ; enable debug mode

End_LoadSonic:
		move.b	#id_SonicPlayer,(v_player).w ; load Sonic object
		bset	#0,(v_player+obStatus).w ; make Sonic face left
		move.b	#1,(f_lockctrl).w ; lock controls
		move.w	#(btnL<<8),(v_jpadhold2).w ; move Sonic to the left
		move.w	#$F600,(v_player+obInertia).w ; set Sonic's speed
		move.b	#id_HUD,(v_objspace+$40).w ; load HUD object
		jsr	(ObjPosLoad).l
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		moveq	#0,d0
		move.w	d0,(v_rings).w
		move.l	d0,(v_time).w
		move.b	d0,(v_lifecount).w
		move.b	d0,(v_shield).w
		move.b	d0,(v_invinc).w
		move.b	d0,(v_shoes).w
		move.b	d0,($FFFFFE2F).w
		move.w	d0,(v_debuguse).w
		move.w	d0,(f_restart).w
		move.w	d0,(v_framecount).w
		bsr.w	OscillateNumInit
		move.b	#1,(f_scorecount).w
		move.b	#1,(f_ringcount).w
		move.b	#0,(f_timecount).w
		move.w	#1800,(v_demolength).w
		move.b	#$18,(v_vbla_routine).w
		bsr.w	WaitForVBla
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		move.w	#$3F,(v_pfade_start).w
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; Main ending sequence loop
; ---------------------------------------------------------------------------

End_MainLoop:
		bsr.w	PauseGame
		move.b	#$18,(v_vbla_routine).w
		bsr.w	WaitForVBla
		addq.w	#1,(v_framecount).w
		bsr.w	End_MoveSonic
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	PaletteCycle
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		cmpi.b	#id_Ending,(v_gamemode).w ; is game mode $18 (ending)?
		beq.s	End_ChkEmerald	; if yes, branch

		move.b	#id_Credits,(v_gamemode).w ; goto credits
		move.w	#0,(v_creditsnum).w ; set credits index number to 0
		rts	
; ===========================================================================

End_ChkEmerald:
		tst.w	(f_restart).w	; has Sonic released the emeralds?
		beq.w	End_MainLoop	; if not, branch

		clr.w	(f_restart).w
		move.w	#$3F,(v_pfade_start).w
		clr.w	(v_palchgspeed).w

	End_AllEmlds:
		bsr.w	PauseGame
		move.b	#$18,(v_vbla_routine).w
		bsr.w	WaitForVBla
		addq.w	#1,(v_framecount).w
		bsr.w	End_MoveSonic
		jsr	(ExecuteObjects).l
		bsr.w	DeformLayers
		jsr	(BuildSprites).l
		jsr	(ObjPosLoad).l
		bsr.w	OscillateNumDo
		bsr.w	SynchroAnimate
		subq.w	#1,(v_palchgspeed).w
		bpl.s	End_SlowFade
		move.w	#2,(v_palchgspeed).w
		bsr.w	WhiteOut_ToWhite

	End_SlowFade:
		tst.w	(f_restart).w
		beq.w	End_AllEmlds
		clr.w	(f_restart).w
		move.w	#$2829,(v_lvllayout+$80).w ; modify level layout
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		bsr.w	DrawChunks
		moveq	#palid_Ending,d0
		bsr.w	PalLoad1	; load ending palette
		bsr.w	PaletteWhiteIn
		bra.w	End_MainLoop

; ---------------------------------------------------------------------------
; Subroutine controlling Sonic on the ending sequence
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


End_MoveSonic:
		move.b	(v_sonicend).w,d0
		bne.s	End_MoveSon2
		cmpi.w	#$90,(v_player+obX).w ; has Sonic passed $90 on x-axis?
		bhs.s	End_MoveSonExit	; if not, branch

		addq.b	#2,(v_sonicend).w
		move.b	#1,(f_lockctrl).w ; lock player's controls
		move.w	#(btnR<<8),(v_jpadhold2).w ; move Sonic to the right
		rts	
; ===========================================================================

End_MoveSon2:
		subq.b	#2,d0
		bne.s	End_MoveSon3
		cmpi.w	#$A0,(v_player+obX).w ; has Sonic passed $A0 on x-axis?
		blo.s	End_MoveSonExit	; if not, branch

		addq.b	#2,(v_sonicend).w
		moveq	#0,d0
		move.b	d0,(f_lockctrl).w
		move.w	d0,(v_jpadhold2).w ; stop Sonic moving
		move.w	d0,(v_player+obInertia).w
		move.b	#$81,(f_lockmulti).w ; lock controls & position
		move.b	#3,(v_player+obFrame).w
		move.w	#(id_Wait<<8)+id_Wait,(v_player+obAnim).w ; use "standing" animation
		move.b	#3,(v_player+obTimeFrame).w
		rts	
; ===========================================================================

End_MoveSon3:
		subq.b	#2,d0
		bne.s	End_MoveSonExit
		addq.b	#2,(v_sonicend).w
		move.w	#$A0,(v_player+obX).w
		move.b	#id_EndSonic,(v_player).w ; load Sonic ending sequence object
		clr.w	(v_player+obRoutine).w

End_MoveSonExit:
		rts	
; End of function End_MoveSonic

; ===========================================================================

		include	"_incObj\87 Ending Sequence Sonic.asm"
		include "_anim\Ending Sequence Sonic.asm"
		include	"_incObj\88 Ending Sequence Emeralds.asm"
		include	"_incObj\89 Ending Sequence STH.asm"
Map_ESon:	include	"_maps\Ending Sequence Sonic.asm"
Map_ECha:	include	"_maps\Ending Sequence Emeralds.asm"
Map_ESth:	include	"_maps\Ending Sequence STH.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Credits ending sequence
; ---------------------------------------------------------------------------

GM_Credits:
		bsr.w	ClearPLC
		bsr.w	PaletteFadeOut
		lea	(vdp_control_port).l,a6
		move.w	#$8004,(a6)	; use 8-colour mode
		move.w	#$8200+(vram_fg>>10),(a6) ; set foreground nametable address
		move.w	#$8400+(vram_bg>>13),(a6) ; set background nametable address
		move.w	#$9001,(a6)	; 64-cell hscroll size
		move.w	#$9200,(a6)	; window vertical position
		move.w	#$8B03,(a6)	; line scroll mode
		move.w	#$8720,(a6)	; set background colour (line 3; colour 0)
		clr.b	(f_wtr_state).w
		bsr.w	ClearScreen

		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1
	TryAg_ClrObjRam:
		move.l	d0,(a1)+
		dbf	d1,TryAg_ClrObjRam ; clear object RAM

		moveq	#plcid_TryAgain,d0
		bsr.w	QuickPLC	; load "TRY AGAIN" or "END" patterns

		lea	(v_pal_dry_dup).w,a1
		moveq	#0,d0
		move.w	#$1F,d1
	TryAg_ClrPal:
		move.l	d0,(a1)+
		dbf	d1,TryAg_ClrPal ; fill palette with black

		moveq	#palid_Ending,d0
		bsr.w	PalLoad1	; load ending palette
		clr.w	(v_pal_dry_dup+$40).w
		move.b	#id_EndEggman,(v_objspace+$80).w ; load Eggman object
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		move.w	#2880,(v_demolength).w ; show screen for 48 seconds
		bsr.w	PaletteFadeIn

; ---------------------------------------------------------------------------
; "TRY AGAIN" and "END"	screen main loop
; ---------------------------------------------------------------------------
TryAg_MainLoop:
		bsr.w	PauseGame
		move.b	#4,(v_vbla_routine).w
		bsr.w	WaitForVBla
		jsr	(ExecuteObjects).l
		jsr	(BuildSprites).l
		andi.b	#btnStart,(v_jpadpress1).w ; is Start button pressed?
		bne.s	TryAg_Exit	; if yes, branch
		tst.w	(v_demolength).w ; has 30 seconds elapsed?
		beq.s	TryAg_Exit	; if yes, branch
		cmpi.b	#id_Credits,(v_gamemode).w
		beq.s	TryAg_MainLoop

TryAg_Exit:
		move.b	#id_Sega,(v_gamemode).w ; goto Sega screen
		rts	

; ===========================================================================

		include	"_incObj\8B Try Again & End Eggman.asm"
		include "_anim\Try Again & End Eggman.asm"
		include	"_incObj\8C Try Again Emeralds.asm"
Map_EEgg:	include	"_maps\Try Again & End Eggman.asm"

; ---------------------------------------------------------------------------
; Ending sequence demos
; ---------------------------------------------------------------------------
Demo_EndGHZ1:	incbin	"demodata\Ending - GHZ1.bin"
		even
Demo_EndMZ:	incbin	"demodata\Ending - MZ.bin"
		even
Demo_EndSYZ:	incbin	"demodata\Ending - SYZ.bin"
		even
Demo_EndLZ:	incbin	"demodata\Ending - LZ.bin"
		even
Demo_EndSLZ:	incbin	"demodata\Ending - SLZ.bin"
		even
Demo_EndSBZ1:	incbin	"demodata\Ending - SBZ1.bin"
		even
Demo_EndSBZ2:	incbin	"demodata\Ending - SBZ2.bin"
		even
Demo_EndGHZ2:	incbin	"demodata\Ending - GHZ2.bin"
		even

		if Revision=0
		include	"_inc\LevelSizeLoad & BgScrollSpeed.asm"
		include	"_inc\DeformLayers.asm"
		else
		include	"_inc\LevelSizeLoad & BgScrollSpeed (JP1).asm"
		include	"_inc\DeformLayers (JP1).asm"
		endc


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6886:
LoadTilesAsYouMove_BGOnly:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_bg1_scroll_flags).w,a2
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags).w,a2
		lea	(v_bg2screenposx).w,a3
		bra.w	DrawBGScrollBlock2
; End of function sub_6886

; ---------------------------------------------------------------------------
; Subroutine to	display	correct	tiles as you move
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesAsYouMove:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		; First, update the background
		lea	(v_bg1_scroll_flags_dup).w,a2	; Scroll block 1 scroll flags
		lea	(v_bgscreenposx_dup).w,a3	; Scroll block 1 X coordinate
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2			; VRAM thing for selecting Plane B
		bsr.w	DrawBGScrollBlock1
		lea	(v_bg2_scroll_flags_dup).w,a2	; Scroll block 2 scroll flags
		lea	(v_bg2screenposx_dup).w,a3	; Scroll block 2 X coordinate
		bsr.w	DrawBGScrollBlock2
		if Revision>=1
		; REV01 added a third scroll block, though, technically,
		; the RAM for it was already there in REV00
		lea	(v_bg3_scroll_flags_dup).w,a2	; Scroll block 3 scroll flags
		lea	(v_bg3screenposx_dup).w,a3	; Scroll block 3 X coordinate
		bsr.w	DrawBGScrollBlock3
		endc
		; Then, update the foreground
		lea	(v_fg_scroll_flags_dup).w,a2	; Foreground scroll flags
		lea	(v_screenposx_dup).w,a3		; Foreground X coordinate
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2			; VRAM thing for selecting Plane A
		; The FG's update function is inlined here
		tst.b	(a2)
		beq.s	locret_6952	; If there are no flags set, nothing needs updating
		bclr	#0,(a2)
		beq.s	loc_6908
		; Draw new tiles at the top
		moveq	#-16,d4	; Y coordinate. Note that 16 is the size of a block in pixels
		moveq	#-16,d5 ; X coordinate
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4 ; Y coordinate
		moveq	#-16,d5 ; X coordinate
		bsr.w	DrawBlocks_LR

loc_6908:
		bclr	#1,(a2)
		beq.s	loc_6922
		; Draw new tiles at the bottom
		move.w	#224,d4	; Start at bottom of the screen. Since this draws from top to bottom, we don't need 224+16
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_LR

loc_6922:
		bclr	#2,(a2)
		beq.s	loc_6938
		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	DrawBlocks_TB

loc_6938:
		bclr	#3,(a2)
		beq.s	locret_6952
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	DrawBlocks_TB

locret_6952:
		rts	
; End of function LoadTilesAsYouMove


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; sub_6954:
DrawBGScrollBlock1:
		tst.b	(a2)
		beq.w	locret_69F2
		bclr	#0,(a2)
		beq.s	loc_6972
		; Draw new tiles at the top
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		if Revision=0
		moveq	#(512/16)-1,d6	 ; Draw entire row of plane
		bsr.w	DrawBlocks_LR_2
		else
			bsr.w	DrawBlocks_LR
		endc

loc_6972:
		bclr	#1,(a2)
		beq.s	loc_698E
		; Draw new tiles at the top
		move.w	#224,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	#224,d4
		moveq	#-16,d5
		if Revision=0
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2
		else
			bsr.w	DrawBlocks_LR
		endc

loc_698E:
		bclr	#2,(a2)

		if Revision=0
		beq.s	loc_69BE
		; Draw new tiles on the left
		moveq	#-16,d4
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		moveq	#-16,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1		; Floor camera Y coordinate to the nearest block
		sub.w	d1,d6
		blt.s	loc_69BE	; If scroll block 1 is offscreen, skip loading its tiles
		lsr.w	#4,d6		; Get number of rows not above the screen
		cmpi.w	#((224+16+16)/16)-1,d6
		blo.s	loc_69BA
		moveq	#((224+16+16)/16)-1,d6	; Cap at height of screen

loc_69BA:
		bsr.w	DrawBlocks_TB_2

loc_69BE:
		bclr	#3,(a2)
		beq.s	locret_69F2
		; Draw new tiles on the right
		moveq	#-16,d4
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		moveq	#-16,d4
		move.w	#320,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	locret_69F2
		lsr.w	#4,d6
		cmpi.w	#((224+16+16)/16)-1,d6
		blo.s	loc_69EE
		moveq	#((224+16+16)/16)-1,d6

loc_69EE:
		bsr.w	DrawBlocks_TB_2

		else

			beq.s	locj_6D56
			; Draw new tiles on the left
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			moveq	#-16,d4
			moveq	#-16,d5
			bsr.w	DrawBlocks_TB
	locj_6D56:

			bclr	#3,(a2)
			beq.s	locj_6D70
			; Draw new tiles on the right
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			moveq	#-16,d4
			move.w	#320,d5
			bsr.w	DrawBlocks_TB
	locj_6D70:

			bclr	#4,(a2)
			beq.s	locj_6D88
			; Draw entire row at the top
			moveq	#-16,d4
			moveq	#0,d5
			bsr.w	Calc_VRAM_Pos_2
			moveq	#-16,d4
			moveq	#0,d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_6D88:

			bclr	#5,(a2)
			beq.s	locret_69F2
			; Draw entire row at the bottom
			move.w	#224,d4
			moveq	#0,d5
			bsr.w	Calc_VRAM_Pos_2
			move.w	#224,d4
			moveq	#0,d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
		endc

locret_69F2:
		rts	
; End of function DrawBGScrollBlock1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Essentially, this draws everything that isn't scroll block 1
; sub_69F4:
DrawBGScrollBlock2:
		if Revision=0

		tst.b	(a2)
		beq.w	locret_6A80
		bclr	#2,(a2)
		beq.s	loc_6A3E
		; Draw new tiles on the left
		cmpi.w	#16,(a3)
		blo.s	loc_6A3E
		move.w	(v_scroll_block_1_size).w,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4	; Get remaining coverage of screen that isn't scroll block 1
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos
		move.w	(sp)+,d4
		moveq	#-16,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	loc_6A3E	; If scroll block 1 is completely offscreen, branch?
		lsr.w	#4,d6
		subi.w	#((224+16)/16)-1,d6	; Get however many of the rows on screen are not scroll block 1
		bhs.s	loc_6A3E
		neg.w	d6
		bsr.w	DrawBlocks_TB_2

loc_6A3E:
		bclr	#3,(a2)
		beq.s	locret_6A80
		; Draw new tiles on the right
		move.w	(v_scroll_block_1_size).w,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos
		move.w	(sp)+,d4
		move.w	#320,d5
		move.w	(v_scroll_block_1_size).w,d6
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d6
		blt.s	locret_6A80
		lsr.w	#4,d6
		subi.w	#((224+16)/16)-1,d6
		bhs.s	locret_6A80
		neg.w	d6
		bsr.w	DrawBlocks_TB_2

locret_6A80:
		rts	
; End of function DrawBGScrollBlock2

; ===========================================================================

; Abandoned unused scroll block code.
; This would have drawn a scroll block that started at 208 pixels down, and was 48 pixels long.
		tst.b	(a2)
		beq.s	locret_6AD6
		bclr	#2,(a2)
		beq.s	loc_6AAC
		; Draw new tiles on the left
		move.w	#224-16,d4	; Note that full screen coverage is normally 224+16+16. This is exactly three blocks less.
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		moveq	#-16,d5
		bsr.w	Calc_VRAM_Pos_Unknown
		move.w	(sp)+,d4
		moveq	#-16,d5
		moveq	#3-1,d6	; Draw only three rows
		bsr.w	DrawBlocks_TB_2

loc_6AAC:
		bclr	#3,(a2)
		beq.s	locret_6AD6
		; Draw new tiles on the right
		move.w	#224-16,d4
		move.w	4(a3),d1
		andi.w	#-16,d1
		sub.w	d1,d4
		move.w	d4,-(sp)
		move.w	#320,d5
		bsr.w	Calc_VRAM_Pos_Unknown
		move.w	(sp)+,d4
		move.w	#320,d5
		moveq	#3-1,d6
		bsr.w	DrawBlocks_TB_2

locret_6AD6:
		rts	

		else

			tst.b	(a2)
			beq.w	locj_6DF2
			cmpi.b	#id_SBZ,(v_zone).w
			beq.w	Draw_SBz
			bclr	#0,(a2)
			beq.s	locj_6DD2
			; Draw new tiles on the left
			move.w	#224/2,d4	; Draw the bottom half of the screen
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#224/2,d4
			moveq	#-16,d5
			moveq	#3-1,d6		; Draw three rows... could this be a repurposed version of the above unused code?
			bsr.w	DrawBlocks_TB_2
	locj_6DD2:
			bclr	#1,(a2)
			beq.s	locj_6DF2
			; Draw new tiles on the right
			move.w	#224/2,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#224/2,d4
			move.w	#320,d5
			moveq	#3-1,d6
			bsr.w	DrawBlocks_TB_2
	locj_6DF2:
			rts
;===============================================================================
	locj_6DF4:
			dc.b $00,$00,$00,$00,$00,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$04
			dc.b $04,$04,$04,$04,$04,$04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$00						
;===============================================================================
	Draw_SBz:
			moveq	#-16,d4
			bclr	#0,(a2)
			bne.s	locj_6E28
			bclr	#1,(a2)
			beq.s	locj_6E72
			move.w	#224,d4
	locj_6E28:
			lea	(locj_6DF4+1).l,a0
			move.w	(v_bgscreenposy).w,d0
			add.w	d4,d0
			andi.w	#$1F0,d0
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			lea	(locj_6FE4).l,a3
			movea.w	(a3,d0.w),a3
			beq.s	locj_6E5E
			moveq	#-16,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos
			movem.l	(sp)+,d4/d5
			bsr.w	DrawBlocks_LR
			bra.s	locj_6E72
;===============================================================================
	locj_6E5E:
			moveq	#0,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos_2
			movem.l	(sp)+,d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_6E72:
			tst.b	(a2)
			bne.s	locj_6E78
			rts
;===============================================================================			
	locj_6E78:
			moveq	#-16,d4
			moveq	#-16,d5
			move.b	(a2),d0
			andi.b	#$A8,d0
			beq.s	locj_6E8C
			lsr.b	#1,d0
			move.b	d0,(a2)
			move.w	#320,d5
	locj_6E8C:
			lea	(locj_6DF4).l,a0
			move.w	(v_bgscreenposy).w,d0
			andi.w	#$1F0,d0
			lsr.w	#4,d0
			lea	(a0,d0.w),a0
			bra.w	locj_6FEC						
;===============================================================================


	; locj_6EA4:
	DrawBGScrollBlock3:
			tst.b	(a2)
			beq.w	locj_6EF0
			cmpi.b	#id_MZ,(v_zone).w
			beq.w	Draw_Mz
			bclr	#0,(a2)
			beq.s	locj_6ED0
			; Draw new tiles on the left
			move.w	#$40,d4
			moveq	#-16,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#$40,d4
			moveq	#-16,d5
			moveq	#3-1,d6
			bsr.w	DrawBlocks_TB_2
	locj_6ED0:
			bclr	#1,(a2)
			beq.s	locj_6EF0
			; Draw new tiles on the right
			move.w	#$40,d4
			move.w	#320,d5
			bsr.w	Calc_VRAM_Pos
			move.w	#$40,d4
			move.w	#320,d5
			moveq	#3-1,d6
			bsr.w	DrawBlocks_TB_2
	locj_6EF0:
			rts
	locj_6EF2:
			dc.b $00,$00,$00,$00,$00,$00,$06,$06,$04,$04,$04,$04,$04,$04,$04,$04
			dc.b $04,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02
			dc.b $02,$00
;===============================================================================
	Draw_Mz:
			moveq	#-16,d4
			bclr	#0,(a2)
			bne.s	locj_6F66
			bclr	#1,(a2)
			beq.s	locj_6FAE
			move.w	#224,d4
	locj_6F66:
			lea	(locj_6EF2+1).l,a0
			move.w	(v_bgscreenposy).w,d0
			subi.w	#$200,d0
			add.w	d4,d0
			andi.w	#$7F0,d0
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			movea.w	locj_6FE4(pc,d0.w),a3
			beq.s	locj_6F9A
			moveq	#-16,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos
			movem.l	(sp)+,d4/d5
			bsr.w	DrawBlocks_LR
			bra.s	locj_6FAE
;===============================================================================
	locj_6F9A:
			moveq	#0,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos_2
			movem.l	(sp)+,d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_6FAE:
			tst.b	(a2)
			bne.s	locj_6FB4
			rts
;===============================================================================			
	locj_6FB4:
			moveq	#-16,d4
			moveq	#-16,d5
			move.b	(a2),d0
			andi.b	#$A8,d0
			beq.s	locj_6FC8
			lsr.b	#1,d0
			move.b	d0,(a2)
			move.w	#320,d5
	locj_6FC8:
			lea	(locj_6EF2).l,a0
			move.w	(v_bgscreenposy).w,d0
			subi.w	#$200,d0
			andi.w	#$7F0,d0
			lsr.w	#4,d0
			lea	(a0,d0.w),a0
			bra.w	locj_6FEC
;===============================================================================			
	locj_6FE4:
			dc.w v_bgscreenposx_dup, v_bgscreenposx_dup, v_bg2screenposx_dup, v_bg3screenposx_dup
	locj_6FEC:
			moveq	#((224+16+16)/16)-1,d6
			move.l	#$800000,d7
	locj_6FF4:			
			moveq	#0,d0
			move.b	(a0)+,d0
			btst	d0,(a2)
			beq.s	locj_701C
			move.w	locj_6FE4(pc,d0.w),a3
			movem.l	d4/d5/a0,-(sp)
			movem.l	d4/d5,-(sp)
			bsr.w	GetBlockData
			movem.l	(sp)+,d4/d5
			bsr.w	Calc_VRAM_Pos
			bsr.w	DrawBlock
			movem.l	(sp)+,d4/d5/a0
	locj_701C:
			addi.w	#16,d4
			dbf	d6,locj_6FF4
			clr.b	(a2)
			rts			

		endc

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from left to right
; when the camera's moving up or down
; DrawTiles_LR:
DrawBlocks_LR:
		moveq	#((320+16+16)/16)-1,d6	; Draw the entire width of the screen + two extra columns
; DrawTiles_LR_2:
DrawBlocks_LR_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

	@loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1		; Two tiles ahead
		andi.b	#$7F,d1		; Wrap around row
		movem.l	(sp)+,d4-d5
		addi.w	#16,d5		; Move X coordinate one block ahead
		dbf	d6,@loop
		rts
; End of function DrawBlocks_LR

		if Revision>=1
; DrawTiles_LR_3:
DrawBlocks_LR_3:
		move.l	#$800000,d7
		move.l	d0,d1

	@loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData_2
		move.l	d1,d0
		bsr.w	DrawBlock
		addq.b	#4,d1
		andi.b	#$7F,d1
		movem.l	(sp)+,d4-d5
		addi.w	#16,d5
		dbf	d6,@loop
		rts	
; End of function DrawBlocks_LR_3
		endc


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Don't be fooled by the name: this function's for drawing from top to bottom
; when the camera's moving left or right
; DrawTiles_TB:
DrawBlocks_TB:
		moveq	#((224+16+16)/16)-1,d6	; Draw the entire height of the screen + two extra rows
; DrawTiles_TB_2:
DrawBlocks_TB_2:
		move.l	#$800000,d7	; Delta between rows of tiles
		move.l	d0,d1

	@loop:
		movem.l	d4-d5,-(sp)
		bsr.w	GetBlockData
		move.l	d1,d0
		bsr.w	DrawBlock
		addi.w	#$100,d1	; Two rows ahead
		andi.w	#$FFF,d1	; Wrap around plane
		movem.l	(sp)+,d4-d5
		addi.w	#16,d4		; Move X coordinate one block ahead
		dbf	d6,@loop
		rts	
; End of function DrawBlocks_TB_2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Draws a block's worth of tiles
; Parameters:
; a0 = Pointer to block metadata (block index and X/Y flip)
; a1 = Pointer to block
; a5 = Pointer to VDP command port
; a6 = Pointer to VDP data port
; d0 = VRAM command to access plane
; d2 = VRAM plane A/B specifier
; d7 = Plane row delta
; DrawTiles:
DrawBlock:
		or.w	d2,d0	; OR in that plane A/B specifier to the VRAM command
		swap	d0
		btst	#4,(a0)	; Check Y-flip bit
		bne.s	DrawFlipY
		btst	#3,(a0)	; Check X-flip bit
		bne.s	DrawFlipX
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,(a6)	; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipX:
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4	; Invert X-flip bits of each tile
		swap	d4		; Swap the tiles around
		move.l	d4,(a6)		; Write top two tiles
		add.l	d7,d0		; Next row
		move.l	d0,(a5)
		move.l	(a1)+,d4
		eori.l	#$8000800,d4
		swap	d4
		move.l	d4,(a6)		; Write bottom two tiles
		rts	
; ===========================================================================

DrawFlipY:
		btst	#3,(a0)
		bne.s	DrawFlipXY
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$10001000,d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$10001000,d5
		move.l	d5,(a6)
		rts	
; ===========================================================================

DrawFlipXY:
		move.l	d0,(a5)
		move.l	(a1)+,d5
		move.l	(a1)+,d4
		eori.l	#$18001800,d4
		swap	d4
		move.l	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		eori.l	#$18001800,d5
		swap	d5
		move.l	d5,(a6)
		rts	
; End of function DrawBlocks

; ===========================================================================
; unused garbage
		if Revision=0
; This is interesting. It draws a block, but not before
; incrementing its palette lines by 1. This may have been
; a debug function to discolour mirrored tiles, to test
; if they're loading properly.
		rts	
		move.l	d0,(a5)
		move.w	#$2000,d5
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		add.l	d7,d0
		move.l	d0,(a5)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		move.w	(a1)+,d4
		add.w	d5,d4
		move.w	d4,(a6)
		rts
		endc

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Gets address of block at a certain coordinate
; Parameters:
; a4 = Pointer to level layout
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns:
; a0 = Address of block metadata
; a1 = Address of block
; DrawBlocks:
GetBlockData:
		if Revision=0
		lea	(v_16x16).w,a1
		add.w	4(a3),d4	; Add camera Y coordinate to relative coordinate
		add.w	(a3),d5		; Add camera X coordinate to relative coordinate
		else
			add.w	(a3),d5
	GetBlockData_2:
			add.w	4(a3),d4
			lea	(v_16x16).w,a1
		endc
		; Turn Y coordinate into index into level layout
		move.w	d4,d3
		lsr.w	#1,d3
		andi.w	#$380,d3
		; Turn X coordinate into index into level layout
		lsr.w	#3,d5
		move.w	d5,d0
		lsr.w	#5,d0
		andi.w	#$7F,d0
		; Get chunk from level layout
		add.w	d3,d0
		moveq	#-1,d3
		move.b	(a4,d0.w),d3
		beq.s	locret_6C1E	; If chunk 00, just return a pointer to the first block (expected to be empty)
		; Turn chunk ID into index into chunk table
		subq.b	#1,d3
		andi.w	#$7F,d3
		ror.w	#7,d3
		; Turn Y coordinate into index into chunk
		add.w	d4,d4
		andi.w	#$1E0,d4
		; Turn X coordinate into index into chunk
		andi.w	#$1E,d5
		; Get block metadata from chunk
		add.w	d4,d3
		add.w	d5,d3
		movea.l	d3,a0
		move.w	(a0),d3
		; Turn block ID into address
		andi.w	#$3FF,d3
		lsl.w	#3,d3
		adda.w	d3,a1

locret_6C1E:
		rts	
; End of function GetBlockData


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; Produces a VRAM plane access command from coordinates
; Parameters:
; d4 = Relative Y coordinate
; d5 = Relative X coordinate
; Returns VDP command in d0
Calc_VRAM_Pos:
		if Revision=0
		add.w	4(a3),d4	; Add camera Y coordinate
		add.w	(a3),d5		; Add camera X coordinate
		else
			add.w	(a3),d5
	Calc_VRAM_Pos_2:
			add.w	4(a3),d4
		endc
		; Floor the coordinates to the nearest pair of tiles (the size of a block).
		; Also note that this wraps the value to the size of the plane:
		; The plane is 64*8 wide, so wrap at $100, and it's 32*8 tall, so wrap at $200
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		; Transform the adjusted coordinates into a VDP command
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#3,d0	; Highest bits of plane VRAM address
		swap	d0
		move.w	d4,d0
		rts	
; End of function Calc_VRAM_Pos


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; not used

; This is just like Calc_VRAM_Pos, but seemingly for an earlier
; VRAM layout: the only difference is the high bits of the
; plane's VRAM address, which are 10 instead of 11.
; Both the foreground and background are at $C000 and $E000
; respectively, so this one starting at $8000 makes no sense.
; sub_6C3C:
Calc_VRAM_Pos_Unknown:
		add.w	4(a3),d4
		add.w	(a3),d5
		andi.w	#$F0,d4
		andi.w	#$1F0,d5
		lsl.w	#4,d4
		lsr.w	#2,d5
		add.w	d5,d4
		moveq	#2,d0
		swap	d0
		move.w	d4,d0
		rts	
; End of function Calc_VRAM_Pos_Unknown

; ---------------------------------------------------------------------------
; Subroutine to	load tiles as soon as the level	appears
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LoadTilesFromStart:
		lea	(vdp_control_port).l,a5
		lea	(vdp_data_port).l,a6
		lea	(v_screenposx).w,a3
		lea	(v_lvllayout).w,a4
		move.w	#$4000,d2
		bsr.s	DrawChunks
		lea	(v_bgscreenposx).w,a3
		lea	(v_lvllayout+$40).w,a4
		move.w	#$6000,d2
		if Revision=0
		else
			tst.b	(v_zone).w
			beq.w	Draw_GHz_Bg
			cmpi.b	#id_MZ,(v_zone).w
			beq.w	Draw_Mz_Bg
			cmpi.w	#(id_SBZ<<8)+0,(v_zone).w
			beq.w	Draw_SBz_Bg
			cmpi.b	#id_EndZ,(v_zone).w
			beq.w	Draw_GHz_Bg
		endc
; End of function LoadTilesFromStart


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DrawChunks:
		moveq	#-16,d4
		moveq	#((224+16+16)/16)-1,d6

	@loop:
		movem.l	d4-d6,-(sp)
		moveq	#0,d5
		move.w	d4,d1
		bsr.w	Calc_VRAM_Pos
		move.w	d1,d4
		moveq	#0,d5
		moveq	#(512/16)-1,d6
		bsr.w	DrawBlocks_LR_2
		movem.l	(sp)+,d4-d6
		addi.w	#16,d4
		dbf	d6,@loop
		rts	
; End of function DrawChunks

		if Revision>=1
	Draw_GHz_Bg:
			moveq	#0,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_7224:			
			movem.l	d4-d6,-(sp)
			lea	(locj_724a),a0
			move.w	(v_bgscreenposy).w,d0
			add.w	d4,d0
			andi.w	#$F0,d0
			bsr.w	locj_72Ba
			movem.l	(sp)+,d4-d6
			addi.w	#16,d4
			dbf	d6,locj_7224
			rts
	locj_724a:
			dc.b $00,$00,$00,$00,$06,$06,$06,$04,$04,$04,$00,$00,$00,$00,$00,$00
;-------------------------------------------------------------------------------
	Draw_Mz_Bg:;locj_725a:
			moveq	#-16,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_725E:			
			movem.l	d4-d6,-(sp)
			lea	(locj_6EF2+1),a0
			move.w	(v_bgscreenposy).w,d0
			subi.w	#$200,d0
			add.w	d4,d0
			andi.w	#$7F0,d0
			bsr.w	locj_72Ba
			movem.l	(sp)+,d4-d6
			addi.w	#16,d4
			dbf	d6,locj_725E
			rts
;-------------------------------------------------------------------------------
	Draw_SBz_Bg:;locj_7288:
			moveq	#-16,d4
			moveq	#((224+16+16)/16)-1,d6
	locj_728C:			
			movem.l	d4-d6,-(sp)
			lea	(locj_6DF4+1),a0
			move.w	(v_bgscreenposy).w,d0
			add.w	d4,d0
			andi.w	#$1F0,d0
			bsr.w	locj_72Ba
			movem.l	(sp)+,d4-d6
			addi.w	#16,d4
			dbf	d6,locj_728C
			rts
;-------------------------------------------------------------------------------
	locj_72B2:
			dc.w v_bgscreenposx, v_bgscreenposx, v_bg2screenposx, v_bg3screenposx
	locj_72Ba:
			lsr.w	#4,d0
			move.b	(a0,d0.w),d0
			movea.w	locj_72B2(pc,d0.w),a3
			beq.s	locj_72da
			moveq	#-16,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos
			movem.l	(sp)+,d4/d5
			bsr.w	DrawBlocks_LR
			bra.s	locj_72EE
	locj_72da:
			moveq	#0,d5
			movem.l	d4/d5,-(sp)
			bsr.w	Calc_VRAM_Pos_2
			movem.l	(sp)+,d4/d5
			moveq	#(512/16)-1,d6
			bsr.w	DrawBlocks_LR_3
	locj_72EE:
			rts
		endc

; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelDataLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a1	; RAM address for 16x16 mappings
		moveq	#0,d0
		bsr.w	EniDec
		movea.l	(a2)+,a0
		lea	(v_256x256).l,a1 ; RAM address for 256x256 mappings
		bsr.w	KosDec
		bsr.s	LevelLayoutLoad
		move.l	(a2),d0
		andi.w	#$FF,d0
		cmpi.w	#(id_LZ<<8)+3,(v_zone).w ; is level SBZ3 (LZ4) ?
		bne.s	@notSBZ3	; if not, branch
		moveq	#palid_SBZ3,d0	; use SB3 palette

	@notSBZ3:
		cmpi.w	#(id_SBZ<<8)+1,(v_zone).w ; is level SBZ2?
		beq.s	@isSBZorFZ	; if yes, branch
		cmpi.w	#(id_SBZ<<8)+2,(v_zone).w ; is level FZ?
		bne.s	@normalpal	; if not, branch

	@isSBZorFZ:
		moveq	#palid_SBZ2,d0	; use SBZ2/FZ palette

	@normalpal:
		bsr.w	PalLoad1	; load palette (based on d0)
		movea.l	(sp)+,a2
		addq.w	#4,a2		; read number for 2nd PLC
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	@skipPLC	; if 2nd PLC is 0 (i.e. the ending sequence), branch
		bra.w	AddPLC		; load pattern load cues

	@skipPLC:
		rts
; End of function LevelDataLoad

; ---------------------------------------------------------------------------
; Level	layout loading subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelLayoutLoad:
		lea	(v_lvllayout).w,a3 ; RAM address for level layout
		moveq	#0,d1
		bsr.s	LevelLayoutLoad2 ; load	level layout into RAM
		lea	(v_lvllayout+$40).w,a3 ; RAM address for background layout
		moveq	#2,d1
; End of function LevelLayoutLoad

; "LevelLayoutLoad2" is	run twice - for	the level and the background

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


LevelLayoutLoad2:
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#5,d0
		move.w	d0,d2
		add.w	d0,d0
		add.w	d2,d0
		add.w	d1,d0
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1	; load level width (in tiles)
		move.b	(a1)+,d2	; load level height (in	tiles)

LevLoad_NumRows:
		move.w	d1,d0
		movea.l	a3,a0

LevLoad_Row:
		move.b	(a1)+,(a0)+
		dbf	d0,LevLoad_Row	; load 1 row
		lea	$80(a3),a3	; do next row
		dbf	d2,LevLoad_NumRows ; repeat for	number of rows
		rts
; End of function LevelLayoutLoad2

		include	"_inc\DynamicLevelEvents.asm"

		include	"_incObj\11 Bridge (part 1).asm"

; ---------------------------------------------------------------------------
; Platform subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

PlatformObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)	; is Sonic moving up/jumping?
		bmi.w	Plat_Exit	; if yes, branch

;		perform x-axis range check
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit

	Plat_NoXCheck:
		move.w	obY(a0),d0
		subq.w	#8,d0

Platform3:
;		perform y-axis range check
		move.w	obY(a1),d2
		move.b	obHeight(a1),d1
		ext.w	d1
		add.w	d2,d1
		addq.w	#4,d1
		sub.w	d1,d0
		bhi.w	Plat_Exit
		cmpi.w	#-$10,d0
		blo.w	Plat_Exit

		tst.b	(f_lockmulti).w
		bmi.w	Plat_Exit
		cmpi.b	#6,obRoutine(a1)
		bhs.w	Plat_Exit
		add.w	d0,d2
		addq.w	#3,d2
		move.w	d2,obY(a1)
		addq.b	#2,obRoutine(a0)

loc_74AE:
		btst	#3,obStatus(a1)
		beq.s	loc_74DC
		moveq	#0,d0
		move.b	$3D(a1),d0
		lsl.w	#6,d0
		addi.l	#v_objspace&$FFFFFF,d0
		movea.l	d0,a2
		bclr	#3,obStatus(a2)
		clr.b	ob2ndRout(a2)
		cmpi.b	#4,obRoutine(a2)
		bne.s	loc_74DC
		subq.b	#2,obRoutine(a2)

loc_74DC:
		move.w	a0,d0
		subi.w	#-$3000,d0
		lsr.w	#6,d0
		andi.w	#$7F,d0
		move.b	d0,$3D(a1)
		move.b	#0,obAngle(a1)
		move.w	#0,obVelY(a1)
		move.w	obVelX(a1),obInertia(a1)
		btst	#1,obStatus(a1)
		beq.s	loc_7512
		move.l	a0,-(sp)
		movea.l	a1,a0
		jsr	(Sonic_ResetOnFloor).l
		movea.l	(sp)+,a0

loc_7512:
		bset	#3,obStatus(a1)
		bset	#3,obStatus(a0)

Plat_Exit:
		rts	
; End of function PlatformObject

; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and	SLZ seesaws)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SlopeObject:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.s	Plat_Exit
		btst	#0,obRender(a0)
		beq.s	loc_754A
		not.w	d0
		add.w	d1,d0

loc_754A:
		lsr.w	#1,d0
		moveq	#0,d3
		move.b	(a2,d0.w),d3
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Platform3
; End of function SlopeObject


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Swing_Solid:
		lea	(v_player).w,a1
		tst.w	obVelY(a1)
		bmi.w	Plat_Exit
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.w	Plat_Exit
		add.w	d1,d1
		cmp.w	d1,d0
		bhs.w	Plat_Exit
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.w	Platform3
; End of function Obj15_Solid

; ===========================================================================

		include	"_incObj\11 Bridge (part 2).asm"

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk or jump off	a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ExitPlatform:
		move.w	d1,d2

ExitPlatform2:
		add.w	d2,d2
		lea	(v_player).w,a1
		btst	#1,obStatus(a1)
		bne.s	loc_75E0
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_75E0
		cmp.w	d2,d0
		blo.s	locret_75F2

loc_75E0:
		bclr	#3,obStatus(a1)
		move.b	#2,obRoutine(a0)
		bclr	#3,obStatus(a0)

locret_75F2:
		rts	
; End of function ExitPlatform

		include	"_incObj\11 Bridge (part 3).asm"
Map_Bri:	include	"_maps\Bridge.asm"

		include	"_incObj\15 Swinging Platforms (part 1).asm"

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MvSonicOnPtfm:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		sub.w	d3,d0
		bra.s	MvSonic2
; End of function MvSonicOnPtfm

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's position with a platform
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


MvSonicOnPtfm2:
		lea	(v_player).w,a1
		move.w	obY(a0),d0
		subi.w	#9,d0

MvSonic2:
		tst.b	(f_lockmulti).w
		bmi.s	locret_7B62
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	locret_7B62
		tst.w	(v_debuguse).w
		bne.s	locret_7B62
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_7B62:
		rts	
; End of function MvSonicOnPtfm2

		include	"_incObj\15 Swinging Platforms (part 2).asm"
Map_Swing_GHZ:	include	"_maps\Swinging Platforms (GHZ).asm"
Map_Swing_SLZ:	include	"_maps\Swinging Platforms (SLZ).asm"
		include	"_incObj\17 Spiked Pole Helix.asm"
Map_Hel:	include	"_maps\Spiked Pole Helix.asm"
		include	"_incObj\18 Platforms.asm"
Map_Plat_Unused:include	"_maps\Platforms (unused).asm"
Map_Plat_GHZ:	include	"_maps\Platforms (GHZ).asm"
Map_Plat_SYZ:	include	"_maps\Platforms (SYZ).asm"
Map_Plat_SLZ:	include	"_maps\Platforms (SLZ).asm"
Map_GBall:	include	"_maps\GHZ Ball.asm"
		include	"_incObj\1A Collapsing Ledge (part 1).asm"
		include	"_incObj\53 Collapsing Floors.asm"

; ===========================================================================

Ledge_Fragment:
		move.b	#0,ledge_collapse_flag(a0)

loc_847A:
		lea	CFlo_Data1(pc),a4
		moveq	#$18,d1
		addq.b	#2,obFrame(a0)

loc_8486:
		moveq	#0,d0
		move.b	obFrame(a0),d0
		add.w	d0,d0
		movea.l	obMap(a0),a3
		adda.w	(a3,d0.w),a3
		addq.w	#1,a3
		bset	#5,obRender(a0)
		movea.l	a0,a1
		move.b	#6,obRoutine(a1)
		move.b	(a0),(a1)
		move.l	a3,obMap(a1)
		move.b	obRender(a0),obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.w	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		subq.w	#1,d1
		lea		(v_lvlobjspace).w,a1
		moveq	#$5F,d0
; ===========================================================================

loc_84AA:
		tst.b	(a1)
		beq.s	@cont
		lea		$40(a1),a1
		dbf		d0,loc_84AA
		bne.s	loc_84F2
	@cont:
		addq.w	#5,a3

loc_84B2:
		move.b	#6,obRoutine(a1)
		move.b	(a0),(a1)
		move.l	a3,obMap(a1)
		move.b	obRender(a0),obRender(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.w	obPriority(a0),obPriority(a1)
		move.b	obActWid(a0),obActWid(a1)
		move.b	(a4)+,ledge_timedelay(a1)
		bsr.w	DisplaySprite1

loc_84EE:
		dbf	d1,loc_84AA

loc_84F2:
		bsr.w	DisplaySprite
		sfx	sfx_Collapse,1,0,0	; play collapsing sound
; ===========================================================================
; ---------------------------------------------------------------------------
; Disintegration data for collapsing ledges (MZ, SLZ, SBZ)
; ---------------------------------------------------------------------------
CFlo_Data1:	dc.b $1C, $18, $14, $10, $1A, $16, $12,	$E, $A,	6, $18,	$14, $10, $C, 8, 4
		dc.b $16, $12, $E, $A, 6, 2, $14, $10, $C, 0
CFlo_Data2:	dc.b $1E, $16, $E, 6, $1A, $12,	$A, 2
CFlo_Data3:	dc.b $16, $1E, $1A, $12, 6, $E,	$A, 2

; ---------------------------------------------------------------------------
; Sloped platform subroutine (GHZ collapsing ledges and	MZ platforms)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SlopeObject2:
		lea	(v_player).w,a1
		btst	#3,obStatus(a1)
		beq.s	locret_856E
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		lsr.w	#1,d0
		btst	#0,obRender(a0)
		beq.s	loc_854E
		not.w	d0
		add.w	d1,d0

loc_854E:
		moveq	#0,d1
		move.b	(a2,d0.w),d1
		move.w	obY(a0),d0
		sub.w	d1,d0
		moveq	#0,d1
		move.b	obHeight(a1),d1
		sub.w	d1,d0
		move.w	d0,obY(a1)
		sub.w	obX(a0),d2
		sub.w	d2,obX(a1)

locret_856E:
		rts	
; End of function SlopeObject2

; ===========================================================================
; ---------------------------------------------------------------------------
; Collision data for GHZ collapsing ledge
; ---------------------------------------------------------------------------
Ledge_SlopeData:
		incbin	"misc\GHZ Collapsing Ledge Heightmap.bin"
		even

Map_Ledge:	include	"_maps\Collapsing Ledge.asm"
Map_CFlo:	include	"_maps\Collapsing Floors.asm"

		include	"_incObj\1C Scenery.asm"
Map_Scen:	include	"_maps\Scenery.asm"

		include	"_incObj\1D Water Switcher.asm"
Map_Swi:	include	"_maps\Unused Switch.asm"

		include	"_incObj\2A SBZ Small Door.asm"
		include	"_anim\SBZ Small Door.asm"
Map_ADoor:	include	"_maps\SBZ Small Door.asm"

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj44_SolidWall:
		bsr.w	Obj44_SolidWall2
		beq.s	loc_8AA8
		bmi.w	loc_8AC4
		tst.w	d0
		beq.w	loc_8A92
		bmi.s	loc_8A7C
		tst.w	obVelX(a1)
		bmi.s	loc_8A92
		bra.s	loc_8A82
; ===========================================================================

loc_8A7C:
		tst.w	obVelX(a1)
		bpl.s	loc_8A92

loc_8A82:
		sub.w	d0,obX(a1)
		move.w	#0,obInertia(a1)
		move.w	#0,obVelX(a1)

loc_8A92:
		btst	#1,obStatus(a1)
		bne.s	loc_8AB6
		bset	#5,obStatus(a1)
		bset	#5,obStatus(a0)
		rts	
; ===========================================================================

loc_8AA8:
		btst	#5,obStatus(a0)
		beq.s	locret_8AC2
		move.w	#id_Run,obAnim(a1)

loc_8AB6:
		bclr	#5,obStatus(a0)
		bclr	#5,obStatus(a1)

locret_8AC2:
		rts	
; ===========================================================================

loc_8AC4:
		tst.w	obVelY(a1)
		bpl.s	locret_8AD8
		tst.w	d3
		bpl.s	locret_8AD8
		sub.w	d3,obY(a1)
		move.w	#0,obVelY(a1)

locret_8AD8:
		rts	
; End of function Obj44_SolidWall


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Obj44_SolidWall2:
		lea	(v_player).w,a1
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		add.w	d1,d0
		bmi.s	loc_8B48
		move.w	d1,d3
		add.w	d3,d3
		cmp.w	d3,d0
		bhi.s	loc_8B48
		move.b	obHeight(a1),d3
		ext.w	d3
		add.w	d3,d2
		move.w	obY(a1),d3
		sub.w	obY(a0),d3
		add.w	d2,d3
		bmi.s	loc_8B48
		move.w	d2,d4
		add.w	d4,d4
		cmp.w	d4,d3
		bhs.s	loc_8B48
		tst.b	(f_lockmulti).w
		bmi.s	loc_8B48
		cmpi.b	#6,(v_player+obRoutine).w
		bhs.s	loc_8B48
		tst.w	(v_debuguse).w
		bne.s	loc_8B48
		move.w	d0,d5
		cmp.w	d0,d1
		bhs.s	loc_8B30
		add.w	d1,d1
		sub.w	d1,d0
		move.w	d0,d5
		neg.w	d5

loc_8B30:
		move.w	d3,d1
		cmp.w	d3,d2
		bhs.s	loc_8B3C
		sub.w	d4,d3
		move.w	d3,d1
		neg.w	d1

loc_8B3C:
		cmp.w	d1,d5
		bhi.s	loc_8B44
		moveq	#1,d4
		rts	
; ===========================================================================

loc_8B44:
		moveq	#-1,d4
		rts	
; ===========================================================================

loc_8B48:
		moveq	#0,d4
		rts	
; End of function Obj44_SolidWall2

; ===========================================================================

		include	"_incObj\1E Ball Hog.asm"
		include	"_incObj\20 Cannonball.asm"
		include	"_incObj\24, 27 & 3F Explosions.asm"
		include	"_anim\Ball Hog.asm"
Map_Hog:	include	"_maps\Ball Hog.asm"
Map_MisDissolve:include	"_maps\Buzz Bomber Missile Dissolve.asm"
		include	"_maps\Explosions.asm"

		include	"_incObj\28 Animals.asm"
		include	"_incObj\29 Points.asm"
Map_Animal1:	include	"_maps\Animals 1.asm"
Map_Animal2:	include	"_maps\Animals 2.asm"
Map_Animal3:	include	"_maps\Animals 3.asm"
Map_Poi:	include	"_maps\Points.asm"

		include	"_incObj\1F Crabmeat.asm"
		include	"_anim\Crabmeat.asm"
Map_Crab:	include	"_maps\Crabmeat.asm"
		include	"_incObj\06 Mozzietron.asm"
		include	"_incObj\22 Buzz Bomber.asm"
		include	"_incObj\23 Buzz Bomber Missile.asm"
		include	"_anim\Mozzietron.asm"
		include	"_anim\Buzz Bomber.asm"
		include	"_anim\Buzz Bomber Missile.asm"
Map_Mozzietron:	include	"_maps\Mozzietron.asm"
Map_Buzz:	include	"_maps\Buzz Bomber.asm"
Map_Missile:	include	"_maps\Buzz Bomber Missile.asm"

		include	"_incObj\25 & 37 Rings.asm"
		include	"_incObj\4B Giant Ring.asm"
		include	"_incObj\7C Ring Flash.asm"

		include	"_anim\Rings.asm"
		if Revision=0
Map_Ring:	include	"_maps\Rings.asm"
		else
Map_Ring:		include	"_maps\Rings (JP1).asm"
		endc
Map_GRing:	include	"_maps\Giant Ring.asm"
Map_Flash:	include	"_maps\Ring Flash.asm"
		include	"_incObj\26 Monitor.asm"
		include	"_incObj\2E Monitor Content Power-Up.asm"
		include	"_incObj\26 Monitor (SolidSides subroutine).asm"
		include	"_anim\Monitor.asm"
Map_Monitor:	include	"_maps\Monitor.asm"

		include	"_incObj\0E Title Screen Sonic.asm"
		include	"_incObj\0F Press Start and TM.asm"

		include	"_anim\Title Screen Sonic.asm"
		include	"_anim\Press Start and TM.asm"

		include	"_incObj\sub AnimateSprite.asm"

Map_PSB:	include	"_maps\Press Start and TM.asm"
Map_TSon:	include	"_maps\Title Screen Sonic.asm"

		include	"_incObj\2B Chopper.asm"
		include	"_anim\Chopper.asm"
Map_Chop:	include	"_maps\Chopper.asm"
		include	"_incObj\2C Jaws.asm"
		include	"_anim\Jaws.asm"
Map_Jaws:	include	"_maps\Jaws.asm"
		include	"_incObj\2D Burrobot.asm"
		include	"_anim\Burrobot.asm"
Map_Burro:	include	"_maps\Burrobot.asm"

		include	"_incObj\2F MZ Large Grassy Platforms.asm"
		include	"_incObj\35 Burning Grass.asm"
		include	"_anim\Burning Grass.asm"
Map_LGrass:	include	"_maps\MZ Large Grassy Platforms.asm"
Map_Fire:	include	"_maps\Fireballs.asm"
		include	"_incObj\30 MZ Large Green Glass Blocks.asm"
Map_Glass:	include	"_maps\MZ Large Green Glass Blocks.asm"
		include	"_incObj\31 Chained Stompers.asm"
		include	"_incObj\45 Sideways Stomper.asm"
Map_CStom:	include	"_maps\Chained Stompers.asm"
Map_SStom:	include	"_maps\Sideways Stomper.asm"

		include	"_incObj\32 Button.asm"
Map_But:	include	"_maps\Button.asm"

		include	"_incObj\33 Pushable Blocks.asm"
Map_Push:	include	"_maps\Pushable Blocks.asm"

		include	"_incObj\34 Title Cards.asm"
		include	"_incObj\39 Game Over.asm"
		include	"_incObj\3A Got Through Card.asm"
		include	"_incObj\7E Special Stage Results.asm"
		include	"_incObj\7F SS Result Chaos Emeralds.asm"

; ---------------------------------------------------------------------------
; Sprite mappings - zone title cards
; ---------------------------------------------------------------------------
Map_Card:	dc.w M_Card_GHZ-Map_Card
		dc.w M_Card_LZ-Map_Card
		dc.w M_Card_MZ-Map_Card
		dc.w M_Card_SLZ-Map_Card
		dc.w M_Card_SYZ-Map_Card
		dc.w M_Card_SBZ-Map_Card
		dc.w M_Card_Zone-Map_Card
		dc.w M_Card_Act1-Map_Card
		dc.w M_Card_Act2-Map_Card
		dc.w M_Card_Act3-Map_Card
		dc.w M_Card_Oval-Map_Card
		dc.w M_Card_FZ-Map_Card
M_Card_GHZ:	dc.b 9 			; GREEN HILL
		dc.b $F8, 5, 0,	$18, $B4
		dc.b $F8, 5, 0,	$3A, $C4
		dc.b $F8, 5, 0,	$10, $D4
		dc.b $F8, 5, 0,	$10, $E4
		dc.b $F8, 5, 0,	$2E, $F4
		dc.b $F8, 5, 0,	$1C, $14
		dc.b $F8, 1, 0,	$20, $24
		dc.b $F8, 5, 0,	$26, $2C
		dc.b $F8, 5, 0,	$26, $3C
		even
M_Card_LZ:	dc.b $D	;  LABYRINTH | ROBOTIC ABYSS
		dc.b $F8, 5, 0, $3A, $9C	; R
		dc.b $F8, 5, 0, $32, $AC	; O
		dc.b $F8, 5, 0, 4, $BC		; B
		dc.b $F8, 5, 0, $32, $CC	; O
		dc.b $F8, 5, 0, $42, $DC	; T
		dc.b $F8, 1, 0, $20, $EC	; I
		dc.b $F8, 5, 0, 8, $F4		; C
		dc.b $F8, 0, 0, $56, $4	; Space
		dc.b $F8, 5, 0, 0, $14		; A
		dc.b $F8, 5, 0, 4, $24		; B
		dc.b $F8, 5, 0, $4A, $34	; Y
		dc.b $F8, 5, 0, $3E, $44	; S
		dc.b $F8, 5, 0, $3E, $54	; S
M_Card_MZ:	dc.b $B	;  MARBLE | SCRAP RUINS
		dc.b $F8, 5, 0, $3E, $A4	; S
		dc.b $F8, 5, 0, 8, $B4		; C
		dc.b $F8, 5, 0, $3A, $C4	; R
		dc.b $F8, 5, 0, 0, $D4		; A
		dc.b $F8, 5, 0, $36, $E4	; P
		dc.b $F8, 0, 0, $56, $F4	; Space
		dc.b $F8, 5, 0, $3A, $4	; R
		dc.b $F8, 5, 0, $46, $14	; U
		dc.b $F8, 1, 0, $20, $24	; I
		dc.b $F8, 5, 0, $2E, $2C	; N
		dc.b $F8, 5, 0, $3E, $3C	; S
M_Card_SLZ:	dc.b 9			; STAR LIGHT
		dc.b $F8, 5, 0,	$3E, $B4
		dc.b $F8, 5, 0,	$42, $C4
		dc.b $F8, 5, 0,	0, $D4
		dc.b $F8, 5, 0,	$3A, $E4
		dc.b $F8, 5, 0,	$26, 4
		dc.b $F8, 1, 0,	$20, $14
		dc.b $F8, 5, 0,	$18, $1C
		dc.b $F8, 5, 0,	$1C, $2C
		dc.b $F8, 5, 0,	$42, $3C
		even
M_Card_SYZ:	dc.b $A	;  SPRING YARD | FUTURE BAY
		dc.b $F8, 5, 0, $14, $AC	; F
		dc.b $F8, 5, 0, $46, $BC	; U
		dc.b $F8, 5, 0, $42, $CC	; T
		dc.b $F8, 5, 0, $46, $DC	; U
		dc.b $F8, 5, 0, $3A, $EC	; R
		dc.b $F8, 5, 0, $10, $FC	; E
		dc.b $F8, 0, 0, $56, $C	; Space
		dc.b $F8, 5, 0, 4, $1C		; B
		dc.b $F8, 5, 0, 0, $2C		; A
		dc.b $F8, 5, 0, $4A, $3C	; Y
M_Card_SBZ:	dc.b $A			; SCRAP BRAIN
		dc.b $F8, 5, 0,	$3E, $AC
		dc.b $F8, 5, 0,	8, $BC
		dc.b $F8, 5, 0,	$3A, $CC
		dc.b $F8, 5, 0,	0, $DC
		dc.b $F8, 5, 0,	$36, $EC
		dc.b $F8, 5, 0,	4, $C
		dc.b $F8, 5, 0,	$3A, $1C
		dc.b $F8, 5, 0,	0, $2C
		dc.b $F8, 1, 0,	$20, $3C
		dc.b $F8, 5, 0,	$2E, $44
		even
M_Card_Zone:	dc.b 4			; ZONE
		dc.b $F8, 5, 0,	$4E, $E0
		dc.b $F8, 5, 0,	$32, $F0
		dc.b $F8, 5, 0,	$2E, 0
		dc.b $F8, 5, 0,	$10, $10
		even
M_Card_Act1:	dc.b 2			; ACT 1
		dc.b 4,	$C, 0, $53, $EC
		dc.b $F4, 2, 0,	$57, $C
M_Card_Act2:	dc.b 2			; ACT 2
		dc.b 4,	$C, 0, $53, $EC
		dc.b $F4, 6, 0,	$5A, 8
M_Card_Act3:	dc.b 2			; ACT 3
		dc.b 4,	$C, 0, $53, $EC
		dc.b $F4, 6, 0,	$60, 8
M_Card_Oval:	dc.b $D			; Oval
		dc.b $E4, $C, 0, $70, $F4
		dc.b $E4, 2, 0,	$74, $14
		dc.b $EC, 4, 0,	$77, $EC
		dc.b $F4, 5, 0,	$79, $E4
		dc.b $14, $C, $18, $70,	$EC
		dc.b 4,	2, $18,	$74, $E4
		dc.b $C, 4, $18, $77, 4
		dc.b $FC, 5, $18, $79, $C
		dc.b $EC, 8, 0,	$7D, $FC
		dc.b $F4, $C, 0, $7C, $F4
		dc.b $FC, 8, 0,	$7C, $F4
		dc.b 4,	$C, 0, $7C, $EC
		dc.b $C, 8, 0, $7C, $EC
		even
M_Card_FZ:	dc.b 5			; FINAL
		dc.b $F8, 5, 0,	$14, $DC
		dc.b $F8, 1, 0,	$20, $EC
		dc.b $F8, 5, 0,	$2E, $F4
		dc.b $F8, 5, 0,	0, 4
		dc.b $F8, 5, 0,	$26, $14
		even

Map_Over:	include	"_maps\Game Over.asm"

; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC HAS PASSED" title card
; ---------------------------------------------------------------------------
Map_Got:	dc.w M_Got_SonicHas-Map_Got
		dc.w M_Got_Passed-Map_Got
		dc.w M_Got_Score-Map_Got
		dc.w M_Got_TBonus-Map_Got
		dc.w M_Got_RBonus-Map_Got
		dc.w M_Card_Oval-Map_Got
		dc.w M_Card_Act1-Map_Got
		dc.w M_Card_Act2-Map_Got
		dc.w M_Card_Act3-Map_Got
M_Got_SonicHas:	dc.b 8			; SONIC HAS
		dc.b $F8, 5, 0,	$3E, $B8
		dc.b $F8, 5, 0,	$32, $C8
		dc.b $F8, 5, 0,	$2E, $D8
		dc.b $F8, 1, 0,	$20, $E8
		dc.b $F8, 5, 0,	8, $F0
		dc.b $F8, 5, 0,	$1C, $10
		dc.b $F8, 5, 0,	0, $20
		dc.b $F8, 5, 0,	$3E, $30
M_Got_Passed:	dc.b 6			; PASSED
		dc.b $F8, 5, 0,	$36, $D0
		dc.b $F8, 5, 0,	0, $E0
		dc.b $F8, 5, 0,	$3E, $F0
		dc.b $F8, 5, 0,	$3E, 0
		dc.b $F8, 5, 0,	$10, $10
		dc.b $F8, 5, 0,	$C, $20
M_Got_Score:	dc.b 6			; SCORE
		dc.b $F8, $D, 1, $4A, $B0
		dc.b $F8, 1, 1,	$62, $D0
		dc.b $F8, 9, 1,	$64, $18
		dc.b $F8, $D, 1, $6A, $30
		dc.b $F7, 4, 0,	$6E, $CD
		dc.b $FF, 4, $18, $6E, $CD
M_Got_TBonus:	dc.b 7			; TIME BONUS
		dc.b $F8, $D, 1, $5A, $B0
		dc.b $F8, $D, 0, $66, $D9
		dc.b $F8, 1, 1,	$4A, $F9
		dc.b $F7, 4, 0,	$6E, $F6
		dc.b $FF, 4, $18, $6E, $F6
		dc.b $F8, $D, $FF, $F0,	$28
		dc.b $F8, 1, 1,	$70, $48
M_Got_RBonus:	dc.b 7			; RING BONUS
		dc.b $F8, $D, 1, $52, $B0
		dc.b $F8, $D, 0, $66, $D9
		dc.b $F8, 1, 1,	$4A, $F9
		dc.b $F7, 4, 0,	$6E, $F6
		dc.b $FF, 4, $18, $6E, $F6
		dc.b $F8, $D, $FF, $F8,	$28
		dc.b $F8, 1, 1,	$70, $48
		even
; ---------------------------------------------------------------------------
; Sprite mappings - special stage results screen
; ---------------------------------------------------------------------------
Map_SSR:	dc.w M_SSR_Chaos-Map_SSR
		dc.w M_SSR_Score-Map_SSR
		dc.w byte_CD0D-Map_SSR
		dc.w M_Card_Oval-Map_SSR
		dc.w byte_CD31-Map_SSR
		dc.w byte_CD46-Map_SSR
		dc.w byte_CD5B-Map_SSR
		dc.w byte_CD6B-Map_SSR
		dc.w byte_CDA8-Map_SSR
M_SSR_Chaos:	dc.b $D			; "CHAOS EMERALDS"
		dc.b $F8, 5, 0,	8, $90
		dc.b $F8, 5, 0,	$1C, $A0
		dc.b $F8, 5, 0,	0, $B0
		dc.b $F8, 5, 0,	$32, $C0
		dc.b $F8, 5, 0,	$3E, $D0
		dc.b $F8, 5, 0,	$10, $F0
		dc.b $F8, 5, 0,	$2A, 0
		dc.b $F8, 5, 0,	$10, $10
		dc.b $F8, 5, 0,	$3A, $20
		dc.b $F8, 5, 0,	0, $30
		dc.b $F8, 5, 0,	$26, $40
		dc.b $F8, 5, 0,	$C, $50
		dc.b $F8, 5, 0,	$3E, $60
M_SSR_Score:	dc.b 6			; "SCORE"
		dc.b $F8, $D, 1, $4A, $B0
		dc.b $F8, 1, 1,	$62, $D0
		dc.b $F8, 9, 1,	$64, $18
		dc.b $F8, $D, 1, $6A, $30
		dc.b $F7, 4, 0,	$6E, $CD
		dc.b $FF, 4, $18, $6E, $CD
byte_CD0D:	dc.b 7
		dc.b $F8, $D, 1, $52, $B0
		dc.b $F8, $D, 0, $66, $D9
		dc.b $F8, 1, 1,	$4A, $F9
		dc.b $F7, 4, 0,	$6E, $F6
		dc.b $FF, 4, $18, $6E, $F6
		dc.b $F8, $D, $FF, $F8,	$28
		dc.b $F8, 1, 1,	$70, $48
byte_CD31:	dc.b 4
		dc.b $F8, $D, $FF, $D1,	$B0
		dc.b $F8, $D, $FF, $D9,	$D0
		dc.b $F8, 1, $FF, $E1, $F0
		dc.b $F8, 6, $1F, $E3, $40
byte_CD46:	dc.b 4
		dc.b $F8, $D, $FF, $D1,	$B0
		dc.b $F8, $D, $FF, $D9,	$D0
		dc.b $F8, 1, $FF, $E1, $F0
		dc.b $F8, 6, $1F, $E9, $40
byte_CD5B:	dc.b 3
		dc.b $F8, $D, $FF, $D1,	$B0
		dc.b $F8, $D, $FF, $D9,	$D0
		dc.b $F8, 1, $FF, $E1, $F0
byte_CD6B:	dc.b $C			; "SPECIAL STAGE"
		dc.b $F8, 5, 0,	$3E, $9C
		dc.b $F8, 5, 0,	$36, $AC
		dc.b $F8, 5, 0,	$10, $BC
		dc.b $F8, 5, 0,	8, $CC
		dc.b $F8, 1, 0,	$20, $DC
		dc.b $F8, 5, 0,	0, $E4
		dc.b $F8, 5, 0,	$26, $F4
		dc.b $F8, 5, 0,	$3E, $14
		dc.b $F8, 5, 0,	$42, $24
		dc.b $F8, 5, 0,	0, $34
		dc.b $F8, 5, 0,	$18, $44
		dc.b $F8, 5, 0,	$10, $54
byte_CDA8:	dc.b $F			; "SONIC GOT THEM ALL"
		dc.b $F8, 5, 0,	$3E, $88
		dc.b $F8, 5, 0,	$32, $98
		dc.b $F8, 5, 0,	$2E, $A8
		dc.b $F8, 1, 0,	$20, $B8
		dc.b $F8, 5, 0,	8, $C0
		dc.b $F8, 5, 0,	$18, $D8
		dc.b $F8, 5, 0,	$32, $E8
		dc.b $F8, 5, 0,	$42, $F8
		dc.b $F8, 5, 0,	$42, $10
		dc.b $F8, 5, 0,	$1C, $20
		dc.b $F8, 5, 0,	$10, $30
		dc.b $F8, 5, 0,	$2A, $40
		dc.b $F8, 5, 0,	0, $58
		dc.b $F8, 5, 0,	$26, $68
		dc.b $F8, 5, 0,	$26, $78
		even

Map_SSRC:	include	"_maps\SS Result Chaos Emeralds.asm"

		include	"_incObj\36 Spikes.asm"
Map_Spike:	include	"_maps\Spikes.asm"
		include	"_incObj\3B Purple Rock.asm"
		include	"_incObj\49 Waterfall Sound.asm"
Map_PRock:	include	"_maps\Purple Rock.asm"
		include	"_incObj\3C Smashable Wall.asm"

		include	"_incObj\sub SmashObject.asm"

; ===========================================================================
; Smashed block	fragment speeds
;
Smash_FragSpd1:	dc.w $400, -$500	; x-move speed,	y-move speed
		dc.w $600, -$100
		dc.w $600, $100
		dc.w $400, $500
		dc.w $600, -$600
		dc.w $800, -$200
		dc.w $800, $200
		dc.w $600, $600

Smash_FragSpd2:	dc.w -$600, -$600
		dc.w -$800, -$200
		dc.w -$800, $200
		dc.w -$600, $600
		dc.w -$400, -$500
		dc.w -$600, -$100
		dc.w -$600, $100
		dc.w -$400, $500

Map_Smash:	include	"_maps\Smashable Walls.asm"

; ---------------------------------------------------------------------------
; Object code execution subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||



ExecuteObjects: ; XREF: GM_Title; et al
		lea (v_objspace).w,a0 ; set address for object RAM
		moveq #$7F,d7
		moveq #0,d0
		cmpi.b #6,(v_player+obRoutine).w
		bcc.s loc_D362

loc_D348:
		move.b (a0),d0 ; load object number from RAM
		beq.s loc_D358
		add.w d0,d0
		add.w d0,d0
		movea.l Obj_Index-4(pc,d0.w),a1
		jsr (a1) ; run the object's code
		moveq #0,d0

loc_D358:
		lea $40(a0),a0 ; next object
		dbf d7,loc_D348
		rts
; ===========================================================================

loc_D362:
		moveq #$1F,d7
		bsr.s loc_D348
		moveq #$5F,d7

loc_D368:
		moveq #0,d0 ; Clear d0 quickly
		move.b (a0),d0 ; get the object's ID
		beq.s loc_D37C ; if it's obj00, skip it
		tst.b obRender(a0) ; should we render it?
		bpl.s loc_D37C ; if not, skip it
		move.w obpriority(a0),d0 ; move object's priority to d0
		btst #6,obRender(a0) ; is the compound sprites flag set?
		beq.s loc_D378 ; if not, branch
		move.w #$200,d0 ; move $200 to d0

loc_D378:
		bsr.w DisplaySprite2
		
loc_D37C:
		lea $40(a0),a0
		dbf d7,loc_D368
		rts
; End of function ExecuteObjects

; ===========================================================================
; ---------------------------------------------------------------------------
; Object pointers
; ---------------------------------------------------------------------------
Obj_Index:
		include	"_inc\Object Pointers.asm"

		include	"_incObj\sub ObjectFall.asm"
		include	"_incObj\sub SpeedToPos.asm"
		include	"_incObj\sub DisplaySprite.asm"
		include	"_incObj\sub DeleteObject.asm"

; ===========================================================================
BldSpr_ScrPos:	dc.l 0				; blank
		dc.l v_screenposx&$FFFFFF	; main screen x-position
		dc.l v_bgscreenposx&$FFFFFF	; background x-position	1
		dc.l v_bg3screenposx&$FFFFFF	; background x-position	2
; ---------------------------------------------------------------------------
; Subroutine to	convert	mappings (etc) to proper Megadrive sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
BuildSprites:                ; XREF: TitleScreen; et al
		lea	(v_spritetablebuffer).w,a2 ; set address for sprite table
		moveq	#0,d5
		lea	(v_spritequeue).w,a4
		moveq	#7,d7
		
loc_D66A:
		tst.w	(a4)
		beq.w	loc_D72E
		moveq	#2,d6

loc_D672:
        movea.w    (a4,d6.w),a0
        tst.b    (a0)
        beq.w    loc_D726
        bclr    #7,1(a0)
        move.b    1(a0),d0
        move.b    d0,d4
        cmpi.b    #1,(a0)    ; is this object is Sonic
        beq.s    @skip    ; if it is, branch
        btst    #6,d0    ; is the multi-draw flag set?
        bne.w   BuildSprites_MultiDraw    ; if it is, branch
   @skip:
		andi.w	#$C,d0
		beq.s	loc_D6DE
		movea.l	BldSpr_ScrPos(pc,d0.w),a1
		moveq	#0,d0
		move.b	width_pixels(a0),d0
		move.w	8(a0),d3
		sub.w	(a1),d3
		move.w	d3,d1
		add.w	d0,d1
		bmi.w	loc_D726
		move.w	d3,d1
		sub.w	d0,d1
		cmpi.w	#$140,d1
		bge.s	loc_D726
		addi.w	#$80,d3
		btst	#4,d4
		beq.s	loc_D6E8
		moveq	#0,d0
		move.b	$16(a0),d0
		move.w	$C(a0),d2
		sub.w	4(a1),d2
		move.w	d2,d1
		add.w	d0,d1
		bmi.s	loc_D726
		move.w	d2,d1
		sub.w	d0,d1
		cmpi.w	#$E0,d1
		bge.s	loc_D726
		addi.w	#$80,d2
		bra.s	loc_D700
; ===========================================================================

loc_D6DE:
		move.w	$A(a0),d2
		move.w	8(a0),d3
		bra.s	loc_D700
; ===========================================================================

loc_D6E8:
		move.w	$C(a0),d2
		sub.w	4(a1),d2
		addi.w	#$80,d2
		cmpi.w	#$60,d2
		bcs.s	loc_D726
		cmpi.w	#$180,d2
		bcc.s	loc_D726

loc_D700:
		movea.l	4(a0),a1
		moveq	#0,d1
		btst	#5,d4
		bne.s	loc_D71C
		move.b	$1A(a0),d1
		add.w	d1,d1					; MJ: changed from byte to word (we want more than 7F sprites)
		adda.w	(a1,d1.w),a1
		moveq	#$00,d1					; MJ: clear d1 (because of our byte to word change)
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_D720

loc_D71C:
		jsr	sub_D750

loc_D720:
		bset	#7,1(a0)

loc_D726:
		addq.w	#2,d6
		subq.w	#2,(a4)
		bne.w	loc_D672

loc_D72E:
		lea	$80(a4),a4
		dbf	d7,loc_D66A
		move.b	d5,($FFFFF62C).w
		cmpi.b	#$50,d5
		beq.s	loc_D748
		move.l	#0,(a2)
		rts	
; ===========================================================================

loc_D748:
		move.b	#0,-5(a2)
		rts	
; End of function BuildSprites

BuildSprites_MultiDraw:
	move.l	a4,-(sp)
	lea	($FFFFF700).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0

	; check if object is within X bounds
	move.b	mainspr_width(a0),d0	; load pixel width
	move.w	x_pos(a0),d3
	sub.w	(a4),d3
	move.w	d3,d1                            
	add.w	d0,d1                            ; is the object right edge to the left of the screen? 
	bmi.w	BuildSprites_MultiDraw_NextObj   ; if it is, branch
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1                          ; is the object left edge to the right of the screen?
	bge.w	BuildSprites_MultiDraw_NextObj   ; if it is, branch
	addi.w	#128,d3

	; check if object is within Y bounds
	btst	#4,d4                            ; is the accurate Y check flag set?
	beq.s	BuildSpritesMulti_ApproxYCheck
	moveq	#0,d0
	move.b	mainspr_height(a0),d0	         ; load pixel height
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_MultiDraw_NextObj  ; if the object is above the screen
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_MultiDraw_NextObj  ; if the object is below the screen
	addi.w	#128,d2
	bra.s	BuildSpritesMulti_DrawSprite
BuildSpritesMulti_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_MultiDraw_NextObj
BuildSpritesMulti_DrawSprite:
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1	         ; get current frame
	beq.s	.noparenttodraw
	add.w	d1,d1
	movea.l	a5,a1                            ; a5 is mappings(a0), copy to a1
	adda.w	(a1,d1.w),a1
	moveq	#0,d1
	move.b	(a1)+,d1
	subq.b	#1,d1                            ; get number of pieces
	bmi.s	.noparenttodraw                  ; if there are 0 pieces, branch
	move.w	d4,-(sp)
	jsr	ChkDrawSprite	                 ; draw the sprite
	move.w	(sp)+,d4
.noparenttodraw:
	ori.b	#$80,render_flags(a0)	         ; set onscreen flag
	lea	sub2_x_pos(a0),a6                ; address of first child sprite info
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0	 ; get child sprite count
	subq.w	#1,d0		                 ; if there are 0, go to next object
	bcs.s	BuildSprites_MultiDraw_NextObj

@drawchildloop:
	swap	d0
	move.w	(a6)+,d3	                 ; get X pos
	sub.w	(a4),d3                          ; subtract the screen's x position
	addi.w	#128,d3
	move.w	(a6)+,d2	                 ; get Y pos
	sub.w	4(a4),d2   ; subtract the screen's y position
	addi.w	#128,d2
	andi.w	#$7FF,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1	                 ; get mapping frame
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	moveq	#0,d1
	move.b	(a1)+,d1
	subq.b	#1,d1                            ; get number of pieces
	bmi.s	@nochildleft                     ; if there are 0 pieces, branch
	move.w	d4,-(sp)
	jsr	ChkDrawSprite
	move.w	(sp)+,d4
@nochildleft:
	swap	d0
	dbf	d0,@drawchildloop	         ; repeat for number of child sprites
; loc_16804:
BuildSprites_MultiDraw_NextObj:
	movea.l	(sp)+,a4
	bra.w	loc_D726; End of function BuildSprites


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1680A:
ChkDrawSprite:
	cmpi.b	#80,d5		; has the sprite limit been reached?
	blo.s	loc_1681C	; if it hasn't, branch
	rts	; otherwise, return

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_D750:				; XREF: BuildSprites
		movea.w	2(a0),a3
loc_1681C:
		btst	#0,d4
		bne.s	loc_D796
		btst	#1,d4
		bne.w	loc_D7E4
; End of function sub_D750


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_D762:				; XREF: sub_D762; SS_ShowLayout
		cmpi.b	#$50,d5
		beq.s	locret_D794
sub_D762_2:				; XREF: sub_D762; SS_ShowLayout
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D78E
		addq.w	#1,d0

loc_D78E:
		move.w	d0,(a2)+
		dbf	d1,sub_D762

locret_D794:
		rts
; End of function sub_D762

; ===========================================================================

loc_D796:
		btst	#1,d4
		bne.w	loc_D82A

loc_D79E:
		cmpi.b	#$50,d5
		beq.s	locret_D7E2
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D7DC
		addq.w	#1,d0

loc_D7DC:
		move.w	d0,(a2)+
		dbf	d1,loc_D79E

locret_D7E2:
		rts
; ===========================================================================

loc_D7E4:				; XREF: sub_D750
		cmpi.b	#$50,d5
		beq.s	locret_D828
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1000,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D822
		addq.w	#1,d0

loc_D822:
		move.w	d0,(a2)+
		dbf	d1,loc_D7E4

locret_D828:
		rts
; ===========================================================================

loc_D82A:
		cmpi.b	#$50,d5
		beq.s	locret_D87C
		move.b	(a1)+,d0
		move.b	(a1),d4
		ext.w	d0
		neg.w	d0
		lsl.b	#3,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d2,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d4
		move.b	d4,(a2)+
		addq.b	#1,d5
		move.b	d5,(a2)+
		move.b	(a1)+,d0
		lsl.w	#8,d0
		move.b	(a1)+,d0
		add.w	a3,d0
		eori.w	#$1800,d0
		move.w	d0,(a2)+
		move.b	(a1)+,d0
		ext.w	d0
		neg.w	d0
		add.b	d4,d4
		andi.w	#$18,d4
		addq.w	#8,d4
		sub.w	d4,d0
		add.w	d3,d0
		andi.w	#$1FF,d0
		bne.s	loc_D876
		addq.w	#1,d0

loc_D876:
		move.w	d0,(a2)+
		dbf	d1,loc_D82A

locret_D87C:
		rts
; End of function BuildSpr_Normal

; ===========================================================================

		include	"_incObj\sub ChkObjectVisible.asm"

; ---------------------------------------------------------------------------
; Subroutine to	load a level's objects
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	OPL_Index(pc,d0.w),d0
		jmp	OPL_Index(pc,d0.w)
; End of function ObjPosLoad

; ===========================================================================
OPL_Index:	dc.w OPL_Main-OPL_Index
		dc.w OPL_Next-OPL_Index
; ===========================================================================

OPL_Main:
		addq.b	#2,(v_opl_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(v_opl_data).w
		move.l	a0,(v_opl_data+4).w
		adda.w	2(a1,d0.w),a1
		move.l	a1,(v_opl_data+8).w
		move.l	a1,(v_opl_data+$C).w
		lea	(v_objstate).w,a2
		move.w	#$101,(a2)+
		move.w	#$5E,d0

OPL_ClrList:
		clr.l	(a2)+
		dbf	d0,OPL_ClrList	; clear	pre-destroyed object list

		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		subi.w	#$80,d6
		bhs.s	loc_D93C
		moveq	#0,d6

loc_D93C:
		andi.w	#$FF80,d6
		movea.l	(v_opl_data).w,a0

loc_D944:
		cmp.w	(a0),d6
		bls.s	loc_D956
		tst.b	4(a0)
		bpl.s	loc_D952
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_D952:
		addq.w	#6,a0
		bra.s	loc_D944
; ===========================================================================

loc_D956:
		move.l	a0,(v_opl_data).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$80,d6
		blo.s	loc_D976

loc_D964:
		cmp.w	(a0),d6
		bls.s	loc_D976
		tst.b	4(a0)
		bpl.s	loc_D972
		addq.b	#1,1(a2)

loc_D972:
		addq.w	#6,a0
		bra.s	loc_D964
; ===========================================================================

loc_D976:
		move.l	a0,(v_opl_data+4).w
		move.w	#-1,(v_opl_screen).w

OPL_Next:
		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#$FF80,d6
		cmp.w	(v_opl_screen).w,d6
		beq.w	locret_DA3A
		bge.s	loc_D9F6
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$80,d6
		blo.s	loc_D9D2

loc_D9A6:
		cmp.w	-6(a0),d6
		bge.s	loc_D9D2
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.s	loc_D9BC
		subq.b	#1,1(a2)
		move.b	1(a2),d2

loc_D9BC:
		bsr.w	loc_DA3C
		bne.s	loc_D9C6
		subq.w	#6,a0
		bra.s	loc_D9A6
; ===========================================================================

loc_D9C6:
		tst.b	4(a0)
		bpl.s	loc_D9D0
		addq.b	#1,1(a2)

loc_D9D0:
		addq.w	#6,a0

loc_D9D2:
		move.l	a0,(v_opl_data+4).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$300,d6

loc_D9DE:
		cmp.w	-6(a0),d6
		bgt.s	loc_D9F0
		tst.b	-2(a0)
		bpl.s	loc_D9EC
		subq.b	#1,(a2)

loc_D9EC:
		subq.w	#6,a0
		bra.s	loc_D9DE
; ===========================================================================

loc_D9F0:
		move.l	a0,(v_opl_data).w
		rts	
; ===========================================================================

loc_D9F6:
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data).w,a0
		addi.w	#$280,d6

loc_DA02:
		cmp.w	(a0),d6
		bls.s	loc_DA16
		tst.b	4(a0)
		bpl.s	loc_DA10
		move.b	(a2),d2
		addq.b	#1,(a2)

loc_DA10:
		bsr.w	loc_DA3C
		beq.s	loc_DA02

loc_DA16:
		move.l	a0,(v_opl_data).w
		movea.l	(v_opl_data+4).w,a0
		subi.w	#$300,d6
		blo.s	loc_DA36

loc_DA24:
		cmp.w	(a0),d6
		bls.s	loc_DA36
		tst.b	4(a0)
		bpl.s	loc_DA32
		addq.b	#1,1(a2)

loc_DA32:
		addq.w	#6,a0
		bra.s	loc_DA24
; ===========================================================================

loc_DA36:
		move.l	a0,(v_opl_data+4).w

locret_DA3A:
		rts	
; ===========================================================================

loc_DA3C:
		tst.b	4(a0)
		bpl.s	OPL_MakeItem
		bset	#7,2(a2,d2.w)
		beq.s	OPL_MakeItem
		addq.w	#6,a0
		moveq	#0,d0
		rts	
; ===========================================================================

OPL_MakeItem:
		bsr.w	FindFreeObj
		bne.s	locret_DA8A
		move.w	(a0)+,obX(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$FFF,d0
		move.w	d0,obY(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,obRender(a1)
		move.b	d1,obStatus(a1)
		move.b	(a0)+,d0
		bpl.s	loc_DA80
		andi.b	#$7F,d0
		move.b	d2,obRespawnNo(a1)

loc_DA80:
		move.b	d0,0(a1)
		move.b	(a0)+,obSubtype(a1)
		moveq	#0,d0

locret_DA8A:
		rts	

		include	"_incObj\sub FindFreeObj.asm"
		include	"_incObj\41 Springs.asm"
		include	"_anim\Springs.asm"
Map_Spring:	include	"_maps\Springs.asm"

		include	"_incObj\42 Newtron.asm"
		include	"_anim\Newtron.asm"
Map_Newt:	include	"_maps\Newtron.asm"
		include	"_incObj\43 Roller.asm"
		include	"_anim\Roller.asm"
Map_Roll:	include	"_maps\Roller.asm"

		include	"_incObj\44 GHZ Edge Walls.asm"
Map_Edge:	include	"_maps\GHZ Edge Walls.asm"

		include	"_incObj\13 Lava Ball Maker.asm"
		include	"_incObj\14 Lava Ball.asm"
		include	"_anim\Fireballs.asm"

		include	"_incObj\6D Flamethrower.asm"
		include	"_anim\Flamethrower.asm"
Map_Flame:	include	"_maps\Flamethrower.asm"

		include	"_incObj\46 MZ Bricks.asm"
Map_Brick:	include	"_maps\MZ Bricks.asm"

		include	"_incObj\12 Light.asm"
Map_Light	include	"_maps\Light.asm"
		include	"_incObj\47 Bumper.asm"
		include	"_anim\Bumper.asm"
Map_Bump:	include	"_maps\Bumper.asm"

		include	"_incObj\0D Signpost.asm" ; includes "GotThroughAct" subroutine
		include	"_anim\Signpost.asm"
Map_Sign:	include	"_maps\Signpost.asm"

		include	"_incObj\4C & 4D Lava Geyser Maker.asm"
		include	"_incObj\54 Lava Tag.asm"
Map_LTag:	include	"_maps\Lava Tag.asm"
		include	"_anim\Lava Geyser.asm"
Map_Geyser:	include	"_maps\Lava Geyser.asm"

		include	"_incObj\40 Moto Bug.asm" ; includes "_incObj\sub RememberState.asm"
		include	"_anim\Moto Bug.asm"
Map_Moto:	include	"_maps\Moto Bug.asm"
		include	"_incObj\4F.asm"
Map_Splats:	include	"_maps\Splats.asm"

		include	"_incObj\50 Yadrin.asm"
		include	"_anim\Yadrin.asm"
Map_Yad:	include	"_maps\Yadrin.asm"

		include	"_incObj\sub SolidObject.asm"

		include	"_incObj\51 Smashable Green Block.asm"
Map_Smab:	include	"_maps\Smashable Green Block.asm"

		include	"_incObj\52 Moving Blocks.asm"
Map_MBlock:	include	"_maps\Moving Blocks (MZ and SBZ).asm"
Map_MBlockLZ:	include	"_maps\Moving Blocks (LZ).asm"

		include	"_incObj\55 Basaran.asm"
		include	"_anim\Basaran.asm"
Map_Bas:	include	"_maps\Basaran.asm"

		include	"_incObj\56 Floating Blocks and Doors.asm"
Map_FBlock:	include	"_maps\Floating Blocks and Doors.asm"

		include	"_incObj\57 Spiked Ball and Chain.asm"
Map_SBall:	include	"_maps\Spiked Ball and Chain (SYZ).asm"
Map_SBall2:	include	"_maps\Spiked Ball and Chain (LZ).asm"
		include	"_incObj\58 Big Spiked Ball.asm"
Map_BBall:	include	"_maps\Big Spiked Ball.asm"
		include	"_incObj\59 SLZ Elevators.asm"
Map_Elev:	include	"_maps\SLZ Elevators.asm"
		include	"_incObj\5A SLZ Circling Platform.asm"
Map_Circ:	include	"_maps\SLZ Circling Platform.asm"
		include	"_incObj\5B Staircase.asm"
Map_Stair:	include	"_maps\Staircase.asm"
		include	"_incObj\5C Pylon.asm"
Map_Pylon:	include	"_maps\Pylon.asm"

		include	"_incObj\1B Water Surface.asm"
Map_Surf:	include	"_maps\Water Surface.asm"
		include	"_incObj\0B Pole that Breaks.asm"
Map_Pole:	include	"_maps\Pole that Breaks.asm"
		include	"_incObj\0C Flapping Door.asm"
		include	"_anim\Flapping Door.asm"
Map_Flap:	include	"_maps\Flapping Door.asm"

		include	"_incObj\71 Invisible Barriers.asm"
Map_Invis:	include	"_maps\Invisible Barriers.asm"

		include	"_incObj\5D Fan.asm"
Map_Fan:	include	"_maps\Fan.asm"
		include	"_incObj\5E Seesaw.asm"
Map_Seesaw:	include	"_maps\Seesaw.asm"
Map_SSawBall:	include	"_maps\Seesaw Ball.asm"
		include	"_incObj\5F Bomb Enemy.asm"
		include	"_anim\Bomb Enemy.asm"
Map_Bomb:	include	"_maps\Bomb Enemy.asm"

		include	"_incObj\60 Orbinaut.asm"
		include	"_anim\Orbinaut.asm"
Map_Orb:	include	"_maps\Orbinaut.asm"

		include	"_incObj\16 Harpoon.asm"
		include	"_anim\Harpoon.asm"
Map_Harp:	include	"_maps\Harpoon.asm"
		include	"_incObj\61 LZ Blocks.asm"
Map_LBlock:	include	"_maps\LZ Blocks.asm"
		include	"_incObj\62 Gargoyle.asm"
Map_Gar:	include	"_maps\Gargoyle.asm"
		include	"_incObj\63 LZ Conveyor.asm"
Map_LConv:	include	"_maps\LZ Conveyor.asm"
		include	"_incObj\64 Bubbles.asm"
		include	"_anim\Bubbles.asm"
Map_Bub:	include	"_maps\Bubbles.asm"
		include	"_incObj\65 Waterfalls.asm"
		include	"_anim\Waterfalls.asm"
Map_WFall	include	"_maps\Waterfalls.asm"


SpinDash_dust:				;TIS - Changed to allow for dynamic positioning
Sprite_1DD20:				; DATA XREF: ROM:0001600C?o
		moveq	#0,d0
		move.b	$24(a0),d0
		move	off_1DD2E(pc,d0.w),d1
		jmp	off_1DD2E(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_1DD2E:	dc loc_1DD36-off_1DD2E; 0 ; DATA XREF: h+6DBA?o h+6DBC?o ...
		dc loc_1DD90-off_1DD2E; 1
		dc loc_1DE46-off_1DD2E; 2
		dc loc_1DE4A-off_1DD2E; 3
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DD36:				; DATA XREF: h+6DBA?o
		addq.b	#2,$24(a0)
		move.l	#MapUnc_1DF5E,4(a0)
		or.b	#4,1(a0)
		move.w	#$80,obPriority(a0)
		move.b	#$10,obActWid(a0)
		move	#$7AC,2(a0)
		move	#-$3000,$3E(a0)
		move	#$F580,$3C(a0)
		cmp	#-$2E40,a0
		beq.s	loc_1DD8C
		move.b	#1,$34(a0)
;		cmp	#2,($FFFFFF70).w
;		beq.s	loc_1DD8C
;		move	#$48C,2(a0)
;		move	#-$4FC0,$3E(a0)
;		move	#-$6E80,$3C(a0)

loc_1DD8C:				; CODE XREF: h+6DF6?j h+6E04?j
;		bsr.w	sub_16D6E

loc_1DD90:				; DATA XREF: h+6DBA?o
		movea.w	$3E(a0),a2
		moveq	#0,d0
		move.b	$1C(a0),d0
		add	d0,d0
		move	off_1DDA4(pc,d0.w),d1
		jmp	off_1DDA4(pc,d1.w)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_1DDA4:	dc loc_1DE28-off_1DDA4; 0 ; DATA XREF: h+6E30?o h+6E32?o ...
		dc loc_1DDAC-off_1DDA4; 1
		dc loc_1DDCC-off_1DDA4; 2
		dc loc_1DE20-off_1DDA4; 3
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DDAC:				; DATA XREF: h+6E30?o
		move	(v_waterpos1).w,$C(a0)	;TIS - Changed to variable name
		cmpi.b	#id_LZ,(v_zone).w	;TIS is level LZ?
		beq.s	StandardWaterLevel	;TIS - if no, branch
		move	(v_watersplashpos).w,$C(a0)	;TIS - Dynamic water position
	StandardWaterLevel:
		tst.b	$1D(a0)
		bne.s	loc_1DE28
		move	8(a2),8(a0)
		move.b	#0,$22(a0)
		and	#$7FFF,2(a0)
		bra.s	loc_1DE28
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DDCC:				; DATA XREF: h+6E30?o
;		cmp.b	#$C,$28(a2)
;		bcs.s	loc_1DE3E
		cmp.b	#4,$24(a2)
		bcc.s	loc_1DE3E
		tst.b	$39(a2)
		beq.s	loc_1DE3E
		move	8(a2),8(a0)
		move	$C(a2),$C(a0)
		move.b	$22(a2),$22(a0)
		and.b	#1,$22(a0)
		tst.b	$34(a0)
		beq.s	loc_1DE06
		sub	#4,$C(a0)

loc_1DE06:				; CODE XREF: h+6E8A?j
		tst.b	$1D(a0)
		bne.s	loc_1DE28
		and	#$7FFF,2(a0)
		tst	2(a2)
		bpl.s	loc_1DE28
		or	#-$8000,2(a0)
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DE20:				; DATA XREF: h+6E30?o
loc_1DE28:				; CODE XREF: h+6E42?j h+6E56?j ...
		lea	(off_1DF38).l,a1
		jsr	AnimateSprite
		bsr.w	loc_1DEE4
		jmp	DisplaySprite
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DE3E:				; CODE XREF: h+6E5E?j h+6E66?j ...
		move.b	#0,$1C(a0)
		rts	
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DE46:				; DATA XREF: h+6DBA?o
		bra.w	DeleteObject
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ



loc_1DE4A:
	movea.w	$3E(a0),a2
	moveq	#$10,d1
	cmp.b	#$D,$1C(a2)
	beq.s	loc_1DE64
	moveq	#$6,d1
	cmp.b	#$3,$21(a2)
	beq.s	loc_1DE64
	move.b	#2,$24(a0)
	move.b	#0,$32(a0)
	rts
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DE64:				; CODE XREF: h+6EE0?j
		subq.b	#1,$32(a0)
		bpl.s	loc_1DEE0
		move.b	#3,$32(a0)
		jsr	FindFreeObj
		bne.s	loc_1DEE0
		move.b	0(a0),0(a1)
		move	8(a2),8(a1)
		move	$C(a2),$C(a1)
		tst.b	$34(a0)
		beq.s	loc_1DE9A
		sub	#4,d1

loc_1DE9A:				; CODE XREF: h+6F1E?j
		add	d1,$C(a1)
		move.b	#0,$22(a1)
		move.b	#3,$1C(a1)
		addq.b	#2,$24(a1)
		move.l	4(a0),4(a1)
		move.b	1(a0),1(a1)
		move.w	#$80,obPriority(a1)
		move.b	#4,obActWid(a1)
		move	2(a0),2(a1)
		move	$3E(a0),$3E(a1)
		and	#$7FFF,2(a1)
		tst	2(a2)
		bpl.s	loc_1DEE0
		or	#-$8000,2(a1)

loc_1DEE0:				; CODE XREF: h+6EF4?j h+6F00?j ...
		bsr.s	loc_1DEE4
		rts	
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

loc_1DEE4:				; CODE XREF: h+6EC0?p h+6F6C?p
		moveq	#0,d0
		move.b	$1A(a0),d0
		cmp.b	$30(a0),d0
		beq.w	locret_1DF36
		move.b	d0,$30(a0)
		lea	(off_1E074).l,a2
		add	d0,d0
		add	(a2,d0.w),a2
		move	(a2)+,d5
		subq	#1,d5
		bmi.w	locret_1DF36
		move $3C(a0),d4

loc_1DF0A:				; CODE XREF: h+6FBE?j
		moveq	#0,d1
		move	(a2)+,d1
		move	d1,d3
		lsr.w	#8,d3
		and	#$F0,d3	; 'ð'
		add	#$10,d3
		and	#$FFF,d1
		lsl.l	#5,d1
		add.l	#Art_Dust,d1
		move	d4,d2
		add	d3,d4
		add	d3,d4
		jsr	(QueueDMATransfer).l
		dbf	d5,loc_1DF0A
    rts

locret_1DF36:				; CODE XREF: h+6F7A?j h+6F90?j
		rts	
; ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
off_1DF38:	dc byte_1DF40-off_1DF38; 0 ; DATA XREF: h+6EB4?o h+6FC4?o ...
		dc byte_1DF43-off_1DF38; 1
		dc byte_1DF4F-off_1DF38; 2
		dc byte_1DF58-off_1DF38; 3
byte_1DF40:	dc.b $1F,  0,$FF	; 0 ; DATA XREF: h+6FC4?o
byte_1DF43:	dc.b   3,  1,  2,  3,  4,  5,  6,  7,  8,  9,$FD,  0; 0	; DATA XREF: h+6FC4?o
byte_1DF4F:	dc.b   1, $A, $B, $C, $D, $E, $F,$10,$FF; 0 ; DATA XREF: h+6FC4?o
byte_1DF58:	dc.b   3,$11,$12,$13,$14,$FC; 0	; DATA XREF: h+6FC4?o
; -------------------------------------------------------------------------------
; Unknown Sprite Mappings
; -------------------------------------------------------------------------------
MapUnc_1DF5E:
	dc word_1DF8A-MapUnc_1DF5E; 0
	dc word_1DF8C-MapUnc_1DF5E; 1
	dc word_1DF96-MapUnc_1DF5E; 2
	dc word_1DFA0-MapUnc_1DF5E; 3
	dc word_1DFAA-MapUnc_1DF5E; 4
	dc word_1DFB4-MapUnc_1DF5E; 5
	dc word_1DFBE-MapUnc_1DF5E; 6
	dc word_1DFC8-MapUnc_1DF5E; 7
	dc word_1DFD2-MapUnc_1DF5E; 8
	dc word_1DFDC-MapUnc_1DF5E; 9
	dc word_1DFE6-MapUnc_1DF5E; 10
	dc word_1DFF0-MapUnc_1DF5E; 11
	dc word_1DFFA-MapUnc_1DF5E; 12
	dc word_1E004-MapUnc_1DF5E; 13
	dc word_1E016-MapUnc_1DF5E; 14
	dc word_1E028-MapUnc_1DF5E; 15
	dc word_1E03A-MapUnc_1DF5E; 16
	dc word_1E04C-MapUnc_1DF5E; 17
	dc word_1E056-MapUnc_1DF5E; 18
	dc word_1E060-MapUnc_1DF5E; 19
	dc word_1E06A-MapUnc_1DF5E; 20
	dc word_1DF8A-MapUnc_1DF5E; 21
word_1DF8A:	dc.b 0
word_1DF8C:	dc.b 1
	dc.b $F2, $0D, $0, 0,$F0; 0
word_1DF96:	dc.b 1
	dc.b $E2, $0F, $0, 0,$F0; 0
word_1DFA0:	dc.b 1
	dc.b $E2, $0F, $0, 0,$F0; 0
word_1DFAA:	dc.b 1
	dc.b $E2, $0F, $0, 0,$F0; 0
word_1DFB4:	dc.b 1
	dc.b $E2, $0F, $0, 0,$F0; 0
word_1DFBE:	dc.b 1
	dc.b $E2, $0F, $0, 0,$F0; 0
word_1DFC8:	dc.b 1
	dc.b $F2, $0D, $0, 0,$F0; 0
word_1DFD2:	dc.b 1
	dc.b $F2, $0D, $0, 0,$F0; 0
word_1DFDC:	dc.b 1
	dc.b $F2, $0D, $0, 0,$F0; 0
word_1DFE6:	dc.b 1
	dc.b $4, $0D, $0, 0,$E0; 0
word_1DFF0:	dc.b 1
	dc.b $4, $0D, $0, 0,$E0; 0
word_1DFFA:	dc.b 1
	dc.b $4, $0D, $0, 0,$E0; 0
word_1E004:	dc.b 2
	dc.b $F4, $01, $0, 0,$E8; 0
	dc.b $4, $0D, $0, 2,$E0; 4
word_1E016:	dc.b 2
	dc.b $F4, $05, $0, 0,$E8; 0
	dc.b $4, $0D, $0, 4,$E0; 4
word_1E028:	dc.b 2
	dc.b $F4, $09, $0, 0,$E0; 0
	dc.b $4, $0D, $0, 6,$E0; 4
word_1E03A:	dc.b 2
	dc.b $F4, $09, $0, 0,$E0; 0
	dc.b $4, $0D, $0, 6,$E0; 4
word_1E04C:	dc.b 1
	dc.b $F8, $05, $0, 0,$F8; 0
word_1E056:	dc.b 1
	dc.b $F8, $05, $0, 4,$F8; 0
word_1E060:	dc.b 1
	dc.b $F8, $05, $0, 8,$F8; 0
word_1E06A:	dc.b 1
	dc.b $F8, $05, $0, $C,$F8; 0
	dc.b 0
off_1E074:	dc word_1E0A0-off_1E074; 0
	dc word_1E0A2-off_1E074; 1
	dc word_1E0A6-off_1E074; 2
	dc word_1E0AA-off_1E074; 3
	dc word_1E0AE-off_1E074; 4
	dc word_1E0B2-off_1E074; 5
	dc word_1E0B6-off_1E074; 6
	dc word_1E0BA-off_1E074; 7
	dc word_1E0BE-off_1E074; 8
	dc word_1E0C2-off_1E074; 9
	dc word_1E0C6-off_1E074; 10
	dc word_1E0CA-off_1E074; 11
	dc word_1E0CE-off_1E074; 12
	dc word_1E0D2-off_1E074; 13
	dc word_1E0D8-off_1E074; 14
	dc word_1E0DE-off_1E074; 15
	dc word_1E0E4-off_1E074; 16
	dc word_1E0EA-off_1E074; 17
	dc word_1E0EA-off_1E074; 18
	dc word_1E0EA-off_1E074; 19
	dc word_1E0EA-off_1E074; 20
	dc word_1E0EC-off_1E074; 21
word_1E0A0:	dc 0
word_1E0A2:	dc 1
	dc $7000
word_1E0A6:	dc 1
	dc $F008
word_1E0AA:	dc 1
	dc $F018
word_1E0AE:	dc 1
	dc $F028
word_1E0B2:	dc 1
	dc $F038
word_1E0B6:	dc 1
	dc $F048
word_1E0BA:	dc 1
	dc $7058
word_1E0BE:	dc 1
	dc $7060
word_1E0C2:	dc 1
	dc $7068
word_1E0C6:	dc 1
	dc $7070
word_1E0CA:	dc 1
	dc $7078
word_1E0CE:	dc 1
	dc $7080
word_1E0D2:	dc 2
	dc $1088
	dc $708A
word_1E0D8:	dc 2
	dc $3092
	dc $7096
word_1E0DE:	dc 2
	dc $509E
	dc $70A4
word_1E0E4:	dc 2
	dc $50AC
	dc $70B2
word_1E0EA:	dc 0
word_1E0EC:	dc 1
	dc $F0BA
	even

; ===========================================================================

LoadPlayerPal:
		moveq	#0,d0
		move.b	($FFFFFFBF).w,d0
		move.b	@palLUT(pc,d0.w),d0
		rts

	@palLUT:
		dc.b	palid_Sonic, palid_Sonic2, palid_Sonic3, palid_Sonic4, palid_Sonic5
		dc.b	palid_Sonic6, palid_Sonic7, palid_Sonic8, palid_Sonic9, palid_Sonic10, palid_Sonic11
		even

LoadPlayerWaterPal:
		moveq	#0,d0
		move.b	($FFFFFFBF).w,d0
		move.b	@palLUT(pc,d0.w),d0
		rts

	@palLUT:
		dc.b	palid_SBZ3SonWat, palid_SonWater2, palid_SonWater3, palid_SonWater4, palid_SonWater5
		dc.b	palid_SonWater6, palid_SonWater7, palid_SonWater8, palid_SonWater9, palid_SonWater10, palid_SonWater11
		even

LoadLifeIcon:
		moveq	#0,d0
		move.w	(v_zone).w,d0
		ror.b	#2,d0
		lsr.w 	#6,d0
		move.b	LoadLifeIcon_Table(pc,d0.w),d0
		jmp	(AddPLC).l

LoadLifeIcon_Table:
		; GHZ
		dc.b	plcid_LifeIcon
		dc.b	plcid_LifeIcon
		dc.b	plcid_LifeIcon	
		dc.b	plcid_LifeIcon	
		; LZ
		dc.b	plcid_LifeIcon
		dc.b	plcid_LifeIcon
		dc.b	plcid_LifeIcon	
		dc.b	plcid_LifeIconF	
		; MZ
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF
		; SLZ
		dc.b	plcid_LifeIcon
		dc.b	plcid_LifeIcon
		dc.b	plcid_LifeIcon	
		dc.b	plcid_LifeIcon	
		; SYZ
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF	
		; SBZ
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF
		dc.b	plcid_LifeIconF	
		even

; ===========================================================================
; SRAM FUCKERY
; ===========================================================================

LoadSRAMConfig:
        enableSRAM

        lea 	($200000).l, a0
		move.b 	SavedColor(a0), ($FFFFFFBF).w
		move.b 	SavedCamera(a0), ($FFFFFF8B).w

        disableSRAM
		rts

; ---------------------------------------------------------------------------

SaveGame:
		enableSRAM
		lea 	($200000).l, a0
	;	move.b	SavedZone(a0), d0
	;	cmp.b	(v_zone).w, d0
	;	beq.s   @DoNotSave 		; don't write zone number if it's the same in SRAM 
		;move.b 	(v_zone),SavedZone(a0)
		;move.b	(v_lives),SavedLives(a0)

@DoNotSave:
		disableSRAM
		rts

; ---------------------------------------------------------------------------

LoadSavedGame:
		move.l	d0,(v_score).w	; clear score
        enableSRAM
        lea 	($200000).l, a0
		cmp.b   #$FF, SavedZone(a0)
		bne.s   @HasSavedGame
		
		move.b 	#0, SavedZone(a0)
		bra.s	@Return

@HasSavedGame:
		move.b 	SavedZone(a0), (v_zone).w

@Return:
		move.b	SavedLives(a0),d0
		bne.s	@LivesNotZero
		moveq	#3,d0		; if zero, reset lives counter
		move.b	d0,SavedLives(a0)
		
@LivesNotZero:
		move.b	d0,(v_lives)
        disableSRAM
		rts

; ===========================================================================

WhiteFlash:
		cmpi.l	#$0EEE0EEE,($FFFFFB00).w	; are the first two colors white?
		beq.s	@Return			; if yes, assume white flashing is still in progress and therefore skip it
		lea	($FFFFFA80).w,a3	; load palette location to a3
		lea	($FFFFCA00).w,a4	; load backup location to a4
		move.w	#$007F,d3		; set d3 to $7F (+1 for the first run)

@BackupPal_Loop:
		move.w	(a3)+,(a4)+		; backup palette
		dbf	d3,@BackupPal_Loop	; loop

		lea	($FFFFFA80).w,a1	; load palette location to a3
		move.w	#$EEE,d1		; set colour to white
		move.w	#$007F,d3		; set d3 to $7F (+1 for the first run)

@MakeWhite_Loop:
		move.w	d1,(a1)+		; set new color
		dbf	d3,@MakeWhite_Loop	; loop
		move.b	#5,(v_flashtimer).w	; Set flash timer
@Return:
		rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Object 01 - Sonic
; ---------------------------------------------------------------------------

SonicPlayer:
		tst.w	(v_debuguse).w	; is debug mode	being used?
		beq.s	Sonic_Normal	; if not, branch
		jmp	(DebugMode).l
; ===========================================================================

Sonic_Normal:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Sonic_Index(pc,d0.w),d1
		jmp	Sonic_Index(pc,d1.w)
; ===========================================================================
Sonic_Index:	dc.w Sonic_Main-Sonic_Index
		dc.w Sonic_Control-Sonic_Index
		dc.w Sonic_Hurt-Sonic_Index
		dc.w Sonic_Death-Sonic_Index
		dc.w Sonic_ResetLevel-Sonic_Index
; ===========================================================================

Sonic_Main:	; Routine 0
		move.b	#5,$FFFFD1C0.w
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#9,obWidth(a0)
		move.l	#Map_Sonic,obMap(a0)
		move.w	#$780,obGfx(a0)
		move.w	#$100,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.b	#4,obRender(a0)
		move.w	#$600,(v_sonspeedmax).w ; Sonic's top speed
		move.w	#$C,(v_sonspeedacc).w ; Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; Sonic's deceleration
		move.b	#5,$FFFFD1C0.w
		move.b	#0,(Super_Sonic_flag).w
		
Sonic_Control:    ; Routine 2
 		tst.b	($FFFFFF8B).w
		beq.w	@cont    
		bsr.s    Sonic_PanCamera    ; ++add this++
 
	@cont: 
		tst.w    (f_debugmode).w    ; is debug cheat enabled?
		beq.s    loc_12C58    ; if not, branch
		btst    #bitB,(v_jpadpress1).w ; is button B pressed?
		beq.s    loc_12C58    ; if not, branch
		move.w    #1,(v_debuguse).w ; change Sonic into a ring/item
		clr.b    (f_lockctrl).w
		rts
		
		include    "_incObj\Sonic PanCamera.asm"    ; ++add this++
; ===========================================================================

loc_12C58:
		tst.b	(f_lockctrl).w	; are controls locked?
		bne.s	loc_12C64	; if yes, branch
		move.w	(v_jpadhold1).w,(v_jpadhold2).w ; enable joypad control

loc_12C64:
		btst	#0,(f_lockmulti).w ; are controls locked?
		bne.s	loc_12C7E	; if yes, branch
		moveq	#0,d0
		move.b	obStatus(a0),d0
		andi.w	#6,d0
		move.w	Sonic_Modes(pc,d0.w),d1
		jsr	Sonic_Modes(pc,d1.w)

loc_12C7E:
		bsr.s	Sonic_Display
		bsr.w	Sonic_Super
		bsr.w	Sonic_RecordPosition
		bsr.w	Sonic_Water
		move.b	(v_anglebuffer).w,$36(a0)
		move.b	($FFFFF76A).w,$37(a0)
		tst.b	(f_wtunnelmode).w
		beq.s	loc_12CA6
		tst.b	obAnim(a0)
		bne.s	loc_12CA6
		move.b	obNextAni(a0),obAnim(a0)

loc_12CA6:
		bsr.w	Sonic_Animate
		tst.b	(f_lockmulti).w
		bmi.s	loc_12CB6
		jsr	(ReactToItem).l

loc_12CB6:
		bsr.w	Sonic_Loops
		bsr.w	Sonic_LoadGfx
		rts	
; ===========================================================================
Sonic_Modes:	dc.w Sonic_MdNormal-Sonic_Modes
		dc.w Sonic_MdJump-Sonic_Modes
		dc.w Sonic_MdRoll-Sonic_Modes
		dc.w Sonic_MdJump2-Sonic_Modes
; ---------------------------------------------------------------------------
; Music	to play	after invincibility wears off
; ---------------------------------------------------------------------------
MusicList2:
		dc.b bgm_GHZ
		dc.b bgm_LZ
		dc.b bgm_MZ
		dc.b bgm_SLZ
		dc.b bgm_SYZ
		dc.b bgm_SBZ
		zonewarning MusicList2,1
		; The ending doesn't get an entry
		even

		include	"_incObj\Sonic Display.asm"
		include	"_incObj\Sonic RecordPosition.asm"
		include	"_incObj\Sonic Water.asm"
		include "_incObj\03 Hangable Sprite.asm"

; ===========================================================================
; ---------------------------------------------------------------------------
; Modes	for controlling	Sonic
; ---------------------------------------------------------------------------

Sonic_MdNormal:
		if (GameIsPlayable=69)
		bsr.w	Sonic_Peelout
		bsr.w	Sonic_SpinDash
		endif
		bsr.w	Sonic_Jump
		bsr.w	Sonic_SlopeResist
		bsr.w	Sonic_Move
		bsr.w	Sonic_Roll
		bsr.w	Sonic_LevelBound
		jsr	(SpeedToPos).l
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts	

; ===========================================================================

Sonic_MdJump:
		bsr.w   Sonic_AirRoll
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		jsr	(ObjectFall).l
		btst	#6,obStatus(a0)
		beq.s	loc_12E5C
		subi.w	#$28,obVelY(a0)

loc_12E5C:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts	
; ===========================================================================

Sonic_MdRoll:
		bsr.w	Sonic_Jump
		bsr.w	Sonic_RollRepel
		bsr.w	Sonic_RollSpeed
		bsr.w	Sonic_LevelBound
		jsr	(SpeedToPos).l
		bsr.w	Sonic_AnglePos
		bsr.w	Sonic_SlopeRepel
		rts	
; ===========================================================================

Sonic_MdJump2:
		bsr.w	Sonic_HomingAttack
		bsr.w	Sonic_JumpHeight
		bsr.w	Sonic_JumpDirection
		bsr.w	Sonic_LevelBound
		jsr	(ObjectFall).l
		btst	#6,obStatus(a0)
		beq.s	loc_12EA6
		subi.w	#$28,obVelY(a0)

loc_12EA6:
		bsr.w	Sonic_JumpAngle
		bsr.w	Sonic_Floor
		rts	

		include	"_incObj\Sonic Move.asm"
		include	"_incObj\Sonic RollSpeed.asm"
		include	"_incObj\Sonic JumpDirection.asm"
		include "_incObj\Sonic Peelout.asm"
		include "_incObj\Sonic Spindash.asm"
		include	"_incObj\Sonic HomingAttack.asm"

Sonic_AirRoll:
	cmpi.b  #id_walk,$1C(a0)      ; is sonic in the walk animation?
	beq.s   AirRoll_CheckBtn   ; if yes, advance
	cmpi.b  #id_spring,$1C(a0)      ; is sonic in the spring animation?
	bne.s   AirRoll_Return   ; if not, return

AirRoll_CheckBtn:
        move.b	($FFFFF603).w,d0 ; Move $FFFFF603 to d0
        andi.b	#btnABC,d0 ; Has A/B/C been pressed?
        beq.s	AirRoll_Return
		move.b	#id_roll,$1C(a0) ; Set Sonic's animation to rolling.
       ; move.w	#$BC,d0
       ; jsr	(PlaySound_Special).l ;    play Sonic rolling sound

AirRoll_Return:
        rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Unused subroutine to squash Sonic
; ---------------------------------------------------------------------------
		move.b	obAngle(a0),d0
		addi.b	#$20,d0
		andi.b	#$C0,d0
		bne.s	locret_13302
		bsr.w	Sonic_DontRunOnWalls
		tst.w	d1
		bpl.s	locret_13302
		move.w	#0,obInertia(a0) ; stop Sonic moving
		move.w	#0,obVelX(a0)
		move.w	#0,obVelY(a0)
		move.b	#id_Warp3,obAnim(a0) ; use "warping" animation

locret_13302:
		rts		
		include	"_incObj\Sonic LevelBound.asm"
		include	"_incObj\Sonic Roll.asm"
		include	"_incObj\Sonic Jump.asm"
		include	"_incObj\Sonic JumpHeight.asm"
		include	"_incObj\Sonic SlopeResist.asm"
		include	"_incObj\Sonic RollRepel.asm"
		include	"_incObj\Sonic SlopeRepel.asm"
		include	"_incObj\Sonic JumpAngle.asm"
		include	"_incObj\Sonic Floor.asm"
		include	"_incObj\Sonic ResetOnFloor.asm"
		include	"_incObj\Sonic (part 2).asm"
		include	"_incObj\Sonic Loops.asm"
		include	"_incObj\Sonic Animate.asm"
		include	"_anim\Sonic.asm"
		include	"_anim\Super Sonic.asm"		
		include	"_incObj\Sonic LoadGfx.asm"

		include	"_incObj\0A Drowning Countdown.asm"


; ---------------------------------------------------------------------------
; Subroutine to	play music for LZ/SBZ3 after a countdown
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ResumeMusic:
		;cmpi.w	#12,(v_air).w	; more than 12 seconds of air left?
		;bhi.s	@over12		; if yes, branch
		;move.b	(v_Saved_music),d0
		;tst.b	(v_invinc).w ; is Sonic invincible?
		;beq.s	@notinvinc ; if not, branch
		;move.w	#bgm_Invincible,d0
		;tst.b	(v_shoes).w ; is Sonic speed shoes?
		;beq.s	@notinvinc	; if not, branch
		;move.w	#bgm_Ending,d0

	;@notinvinc:
		;tst.b	(f_lockscreen).w ; is Sonic at a boss?
		;beq.s	@playselected ; if not, branch
		;move.w	#bgm_Boss,d0

	;@playselected:
		;jsr	(PlaySound).l

	;@over12:
		move.w	#30,(v_air).w	; reset air to 30 seconds
		clr.b	(v_objspace+$340+$32).w
		rts	

;End of function ResumeMusic

; ===========================================================================

		include	"_anim\Drowning Countdown.asm"
Map_Drown:	include	"_maps\Drowning Countdown.asm"

; --------------------------------------------------
; Subroutine to load the shield's art over DMA
; --------------------------------------------------

PLCLoad_Shields:
		moveq	#0,d0
		move.b	obFrame(a0),d0	; load frame number
		cmp.b	shield_LastLoadedDPLC(a0),d0
		beq.s	locret2_13C96
		move.b	d0,shield_LastLoadedDPLC(a0)
		move.l  shield_DPLC_Address(A0),a2
		add.w   d0,d0
		adda.w  (a2,D0),a2
		move.w  (a2)+,d5
		subq.w  #1,d5
		bmi.s	locret2_13C96
		move.w  shield_vram_art(A0),d4

loc_199BE:
		moveq	#0,d1
		move.b	(a2)+,d1
		lsl.w	#8,d1
		move.b	(a2)+,d1
		move.w	d1,d3
		lsr.w	#8,d3
		andi.w	#$F0,d3
		addi.w	#$10,d3
		andi.w	#$FFF,d1
		lsl.l	#5,d1
		add.l   shield_Art_Address(a0),d1
		move.w  d4,d2
		add.w   d3,d4
		add.w   d3,d4
		jsr     (QueueDMATransfer).l
		dbf     d5,loc_199BE	; repeat for number of entries

locret2_13C96:
		rts	
; End of function PLCLoad_Shields

		include	"_incObj\4E Silver Shield.asm"
		include	"_incObj\04 Gold Shield.asm"
		include	"_incObj\07 Red Shield.asm"
		include	"_incObj\38 Shield.asm"
		include	"_incObj\19 Invincibility Stars.asm"	
		include	"_incObj\8D Super Stars.asm"			
		include	"_incObj\4A Special Stage Entry (Unused).asm"
		include	"_incObj\08 Water Splash.asm"
		include	"_anim\Shield and Invincibility.asm"
Map_Shield:	include	"_maps\Shield.asm"
DPLC_Shield:	include	"_maps\Shield - Dynamic Gfx Script.asm"
Map_InvStars:	include	"_maps\Invincibility Stars.asm"
		include	"_anim\Special Stage Entry (Unused).asm"
Map_Vanish:	include	"_maps\Special Stage Entry (Unused).asm"
		include	"_anim\Water Splash.asm"
Map_Splash:	include	"_maps\Water Splash.asm"

		include	"_incObj\Sonic AnglePos.asm"

		include	"_incObj\sub FindNearestTile.asm"
		include	"_incObj\sub FindFloor.asm"
		include	"_incObj\sub FindWall.asm"

; ---------------------------------------------------------------------------
; Unused floor/wall subroutine - logs something	to do with collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FloorLog_Unk:
		rts	

		lea	(CollArray1).l,a1
		lea	(CollArray1).l,a2
		move.w	#$FF,d3

loc_14C5E:
		moveq	#$10,d5
		move.w	#$F,d2

loc_14C64:
		moveq	#0,d4
		move.w	#$F,d1

loc_14C6A:
		move.w	(a1)+,d0
		lsr.l	d5,d0
		addx.w	d4,d4
		dbf	d1,loc_14C6A

		move.w	d4,(a2)+
		suba.w	#$20,a1
		subq.w	#1,d5
		dbf	d2,loc_14C64

		adda.w	#$20,a1
		dbf	d3,loc_14C5E

		lea	(CollArray1).l,a1
		lea	(CollArray2).l,a2
		bsr.s	FloorLog_Unk2
		lea	(CollArray1).l,a1
		lea	(CollArray1).l,a2

; End of function FloorLog_Unk

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FloorLog_Unk2:
		move.w	#$FFF,d3

loc_14CA6:
		moveq	#0,d2
		move.w	#$F,d1
		move.w	(a1)+,d0
		beq.s	loc_14CD4
		bmi.s	loc_14CBE

loc_14CB2:
		lsr.w	#1,d0
		bhs.s	loc_14CB8
		addq.b	#1,d2

loc_14CB8:
		dbf	d1,loc_14CB2

		bra.s	loc_14CD6
; ===========================================================================

loc_14CBE:
		cmpi.w	#-1,d0
		beq.s	loc_14CD0

loc_14CC4:
		lsl.w	#1,d0
		bhs.s	loc_14CCA
		subq.b	#1,d2

loc_14CCA:
		dbf	d1,loc_14CC4

		bra.s	loc_14CD6
; ===========================================================================

loc_14CD0:
		move.w	#$10,d0

loc_14CD4:
		move.w	d0,d2

loc_14CD6:
		move.b	d2,(a2)+
		dbf	d3,loc_14CA6

		rts	

; End of function FloorLog_Unk2


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkSpeed:
		move.l	obX(a0),d3
		move.l	obY(a0),d2
		move.w	obVelX(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d3
		move.w	obVelY(a0),d1
		ext.l	d1
		asl.l	#8,d1
		add.l	d1,d2
		swap	d2
		swap	d3
		move.b	d0,(v_anglebuffer).w
		move.b	d0,($FFFFF76A).w
		move.b	d0,d1
		addi.b	#$20,d0
		bpl.s	loc_14D1A
		move.b	d1,d0
		bpl.s	loc_14D14
		subq.b	#1,d0

loc_14D14:
		addi.b	#$20,d0
		bra.s	loc_14D24
; ===========================================================================

loc_14D1A:
		move.b	d1,d0
		bpl.s	loc_14D20
		addq.b	#1,d0

loc_14D20:
		addi.b	#$1F,d0

loc_14D24:
		andi.b	#$C0,d0
		beq.w	loc_14DF0
		cmpi.b	#$80,d0
		beq.w	loc_14F7C
		andi.b	#$38,d1
		bne.s	loc_14D3C
		addq.w	#8,d2

loc_14D3C:
		cmpi.b	#$40,d0
		beq.w	loc_1504A
		bra.w	loc_14EBC

; End of function Sonic_WalkSpeed


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14D48:
		move.b	d0,(v_anglebuffer).w
		move.b	d0,($FFFFF76A).w
		addi.b	#$20,d0
		andi.b	#$C0,d0
		cmpi.b	#$40,d0
		beq.w	loc_14FD6
		cmpi.b	#$80,d0
		beq.w	Sonic_DontRunOnWalls
		cmpi.b	#$C0,d0
		beq.w	sub_14E50

; End of function sub_14D48

; ---------------------------------------------------------------------------
; Subroutine to	make Sonic land	on the floor after jumping
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HitFloor:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#0,d2

loc_14DD0:
		move.b	($FFFFF76A).w,d3
		cmp.w	d0,d1
		ble.s	loc_14DDE
		move.b	(v_anglebuffer).w,d3
		exg	d0,d1

loc_14DDE:
		btst	#0,d3
		beq.s	locret_14DE6
		move.b	d2,d3

locret_14DE6:
		rts	

; End of function Sonic_HitFloor

; ===========================================================================
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_14DF0:
		addi.w	#$A,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#0,d2

loc_14E0A:
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14E16
		move.b	d2,d3

locret_14E16:
		rts	

		include	"_incObj\sub ObjFloorDist.asm"


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14E50:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#-$40,d2
		bra.w	loc_14DD0

; End of function sub_14E50


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


sub_14EB4:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_14EBC:
		addi.w	#$A,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#-$40,d2
		bra.w	loc_14E0A

; End of function sub_14EB4

; ---------------------------------------------------------------------------
; Subroutine to	detect when an object hits a wall to its right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitWallRight:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14F06
		move.b	#-$40,d3

locret_14F06:
		rts	

; End of function ObjHitWallRight

; ---------------------------------------------------------------------------
; Subroutine preventing	Sonic from running on walls and	ceilings when he
; touches them
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_DontRunOnWalls:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	($FFFFF76A).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		move.b	#-$80,d2
		bra.w	loc_14DD0
; End of function Sonic_DontRunOnWalls

; ===========================================================================
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_14F7C:
		subi.w	#$A,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	#-$80,d2
		bra.w	loc_14E0A

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitCeiling:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$E,d5
		bsr.w	FindFloor
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_14FD4
		move.b	#-$80,d3

locret_14FD4:
		rts	
; End of function ObjHitCeiling

; ===========================================================================

loc_14FD6:
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	obY(a0),d2
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	($FFFFF76A).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		move.b	#$40,d2
		bra.w	loc_14DD0

; ---------------------------------------------------------------------------
; Subroutine to	stop Sonic when	he jumps at a wall
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_HitWall:
		move.w	obY(a0),d2
		move.w	obX(a0),d3

loc_1504A:
		subi.w	#$A,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	#$40,d2
		bra.w	loc_14E0A
; End of function Sonic_HitWall

; ---------------------------------------------------------------------------
; Subroutine to	detect when an object hits a wall to its left
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjHitWallLeft:
		add.w	obX(a0),d3
		move.w	obY(a0),d2
		; Engine bug: colliding with left walls is erratic with this function.
		; The cause is this: a missing instruction to flip collision on the found
		; 16x16 block; this one:
		;eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4
		move.b	#0,(a4)
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$E,d5
		bsr.w	FindWall
		move.b	(v_anglebuffer).w,d3
		btst	#0,d3
		beq.s	locret_15098
		move.b	#$40,d3

locret_15098:
		rts	
; End of function ObjHitWallLeft

; ===========================================================================

		include	"_incObj\66 Rotating Junction.asm"
Map_Jun:	include	"_maps\Rotating Junction.asm"
		include	"_incObj\67 Running Disc.asm"
Map_Disc:	include	"_maps\Running Disc.asm"
		include	"_incObj\68 Conveyor Belt.asm"
		include	"_incObj\69 SBZ Spinning Platforms.asm"
		include	"_anim\SBZ Spinning Platforms.asm"
Map_Trap:	include	"_maps\Trapdoor.asm"
Map_Spin:	include	"_maps\SBZ Spinning Platforms.asm"
		include	"_incObj\6A Saws and Pizza Cutters.asm"
Map_Saw:	include	"_maps\Saws and Pizza Cutters.asm"
		include	"_incObj\6B SBZ Stomper and Door.asm"
Map_Stomp:	include	"_maps\SBZ Stomper and Door.asm"
		include	"_incObj\6C SBZ Vanishing Platforms.asm"
		include	"_anim\SBZ Vanishing Platforms.asm"
Map_VanP:	include	"_maps\SBZ Vanishing Platforms.asm"
		include	"_incObj\6E Electrocuter.asm"
		include	"_anim\Electrocuter.asm"
Map_Elec:	include	"_maps\Electrocuter.asm"
		include	"_incObj\6F SBZ Spin Platform Conveyor.asm"
		include	"_anim\SBZ Spin Platform Conveyor.asm"

off_164A6:	dc.w word_164B2-off_164A6, word_164C6-off_164A6, word_164DA-off_164A6
		dc.w word_164EE-off_164A6, word_16502-off_164A6, word_16516-off_164A6
word_164B2:	dc.w $10, $E80,	$E14, $370, $EEF, $302,	$EEF, $340, $E14, $3AE
word_164C6:	dc.w $10, $F80,	$F14, $2E0, $FEF, $272,	$FEF, $2B0, $F14, $31E
word_164DA:	dc.w $10, $1080, $1014,	$270, $10EF, $202, $10EF, $240,	$1014, $2AE
word_164EE:	dc.w $10, $F80,	$F14, $570, $FEF, $502,	$FEF, $540, $F14, $5AE
word_16502:	dc.w $10, $1B80, $1B14,	$670, $1BEF, $602, $1BEF, $640,	$1B14, $6AE
word_16516:	dc.w $10, $1C80, $1C14,	$5E0, $1CEF, $572, $1CEF, $5B0,	$1C14, $61E
; ===========================================================================

		include	"_incObj\70 Girder Block.asm"
Map_Gird:	include	"_maps\Girder Block.asm"
		include	"_incObj\72 Teleporter.asm"

		include	"_incObj\78 Caterkiller.asm"
		include	"_anim\Caterkiller.asm"
Map_Cat:	include	"_maps\Caterkiller.asm"

		include	"_incObj\79 Lamppost.asm"
Map_Lamp:	include	"_maps\Lamppost.asm"
		include	"_incObj\7D Hidden Bonuses.asm"
Map_Bonus:	include	"_maps\Hidden Bonuses.asm"

		include	"_incObj\8A Credits.asm"
Map_Cred:	include	"_maps\Credits.asm"

		include	"_incObj\3D Boss - Green Hill (part 1).asm"

; ---------------------------------------------------------------------------
; Defeated boss	subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BossDefeated:
		move.b	(v_vbla_byte).w,d0
		andi.b	#7,d0
		bne.s	locret_178A2
		jsr	(FindFreeObj).l
		bne.s	locret_178A2
		move.b	#id_ExplosionBomb,0(a1)	; load explosion object
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		jsr	(RandomNumber).l
		move.w	d0,d1
		moveq	#0,d1
		move.b	d0,d1
		lsr.b	#2,d1
		subi.w	#$20,d1
		add.w	d1,obX(a1)
		lsr.w	#8,d0
		lsr.b	#3,d0
		add.w	d0,obY(a1)

locret_178A2:
		rts	
; End of function BossDefeated

; ---------------------------------------------------------------------------
; Subroutine to	move a boss
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BossMove:
		movem.w	obVelX(a0),d0/d2
		lsl.l	#8,d0
		add.l	d0,$30(a0)
		lsl.l	#8,d2
		add.l	d2,$38(a0)
		rts
; End of function BossMove

; ===========================================================================

		include	"_incObj\3D Boss - Green Hill (part 2).asm"
		include	"_incObj\48 Eggman's Swinging Ball.asm"
		include	"_anim\Eggman.asm"
Map_Eggman:	include	"_maps\Eggman.asm"
Map_BossItems:	include	"_maps\Boss Items.asm"
		include	"_incObj\77 Boss - Labyrinth.asm"
		include	"_incObj\73 Boss - Marble.asm"
		include	"_incObj\74 MZ Boss Fire.asm"

	Obj7A_Delete:
		jmp	(DeleteObject).l

		include	"_incObj\7A Boss - Star Light.asm"
		include	"_incObj\7B SLZ Boss Spikeball.asm"
Map_BSBall:	include	"_maps\SLZ Boss Spikeball.asm"
		include	"_incObj\75 Boss - Spring Yard.asm"
		include	"_incObj\76 SYZ Boss Blocks.asm"
Map_BossBlock:	include	"_maps\SYZ Boss Blocks.asm"

loc_1982C:
		jmp	(DeleteObject).l

		include	"_incObj\82 Eggman - Scrap Brain 2.asm"
		include	"_anim\Eggman - Scrap Brain 2 & Final.asm"
Map_SEgg:	include	"_maps\Eggman - Scrap Brain 2.asm"
		include	"_incObj\83 SBZ Eggman's Crumbling Floor.asm"
Map_FFloor:	include	"_maps\SBZ Eggman's Crumbling Floor.asm"
		include	"_incObj\85 Boss - Final.asm"
		include	"_anim\FZ Eggman in Ship.asm"
Map_FZDamaged:	include	"_maps\FZ Damaged Eggmobile.asm"
Map_FZLegs:	include	"_maps\FZ Eggmobile Legs.asm"
		include	"_incObj\84 FZ Eggman's Cylinders.asm"
Map_EggCyl:	include	"_maps\FZ Eggman's Cylinders.asm"
		include	"_incObj\86 FZ Plasma Ball Launcher.asm"
		include	"_anim\Plasma Ball Launcher.asm"
Map_PLaunch:	include	"_maps\Plasma Ball Launcher.asm"
		include	"_anim\Plasma Balls.asm"
Map_Plasma:	include	"_maps\Plasma Balls.asm"

		include	"_incObj\3E Prison Capsule.asm"
		include	"_anim\Prison Capsule.asm"
Map_Pri:	include	"_maps\Prison Capsule.asm"

		include	"_incObj\sub ReactToItem.asm"

; ---------------------------------------------------------------------------
; Subroutine to	show the special stage layout
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_ShowLayout:
		bsr.w	SS_AniWallsRings
		bsr.w	SS_AniItems
		move.w	d5,-(sp)
		lea	($FFFF8000).w,a1
		move.b	(v_ssangle).w,d0
		andi.b	#$FC,d0
		jsr	(CalcSine).l
		move.w	d0,d4
		move.w	d1,d5
		muls.w	#$18,d4
		muls.w	#$18,d5
		moveq	#0,d2
		move.w	(v_screenposx).w,d2
		divu.w	#$18,d2
		swap	d2
		neg.w	d2
		addi.w	#-$B4,d2
		moveq	#0,d3
		move.w	(v_screenposy).w,d3
		divu.w	#$18,d3
		swap	d3
		neg.w	d3
		addi.w	#-$B4,d3
		move.w	#$F,d7

loc_1B19E:
		movem.w	d0-d2,-(sp)
		movem.w	d0-d1,-(sp)
		neg.w	d0
		muls.w	d2,d1
		muls.w	d3,d0
		move.l	d0,d6
		add.l	d1,d6
		movem.w	(sp)+,d0-d1
		muls.w	d2,d0
		muls.w	d3,d1
		add.l	d0,d1
		move.l	d6,d2
		move.w	#$F,d6

loc_1B1C0:
		move.l	d2,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		move.l	d1,d0
		asr.l	#8,d0
		move.w	d0,(a1)+
		add.l	d5,d2
		add.l	d4,d1
		dbf	d6,loc_1B1C0

		movem.w	(sp)+,d0-d2
		addi.w	#$18,d3
		dbf	d7,loc_1B19E

		move.w	(sp)+,d5
		lea	($FF0000).l,a0
		moveq	#0,d0
		move.w	(v_screenposy).w,d0
		divu.w	#$18,d0
		mulu.w	#$80,d0
		adda.l	d0,a0
		moveq	#0,d0
		move.w	(v_screenposx).w,d0
		divu.w	#$18,d0
		adda.w	d0,a0
		lea	($FFFF8000).w,a4
		move.w	#$F,d7

loc_1B20C:
		move.w	#$F,d6

loc_1B210:
		moveq	#0,d0
		move.b	(a0)+,d0
		beq.s	loc_1B268
		cmpi.b	#$4E,d0
		bhi.s	loc_1B268
		move.w	(a4),d3
		addi.w	#$120,d3
		cmpi.w	#$70,d3
		blo.s	loc_1B268
		cmpi.w	#$1D0,d3
		bhs.s	loc_1B268
		move.w	2(a4),d2
		addi.w	#$F0,d2
		cmpi.w	#$70,d2
		blo.s	loc_1B268
		cmpi.w	#$170,d2
		bhs.s	loc_1B268
		lea	($FF4000).l,a5
		lsl.w	#3,d0
		lea	(a5,d0.w),a5
		movea.l	(a5)+,a1
		move.w	(a5)+,d1
		add.w	d1,d1
		adda.w	(a1,d1.w),a1
		movea.w	(a5)+,a3
		moveq	#0,d1
		move.b	(a1)+,d1
		subq.b	#1,d1
		bmi.s	loc_1B268
		jsr	(sub_D762).l

loc_1B268:
		addq.w	#4,a4
		dbf	d6,loc_1B210

		lea	$70(a0),a0
		dbf	d7,loc_1B20C

		move.b	d5,(v_spritecount).w
		cmpi.b	#$50,d5
		beq.s	loc_1B288
		move.l	#0,(a2)
		rts	
; ===========================================================================

loc_1B288:
		move.b	#0,-5(a2)
		rts	
; End of function SS_ShowLayout

; ---------------------------------------------------------------------------
; Subroutine to	animate	walls and rings	in the special stage
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_AniWallsRings:
		lea	($FF400C).l,a1
		moveq	#0,d0
		move.b	(v_ssangle).w,d0
		lsr.b	#2,d0
		andi.w	#$F,d0
		moveq	#$23,d1

loc_1B2A4:
		move.w	d0,(a1)
		addq.w	#8,a1
		dbf	d1,loc_1B2A4

		lea	($FF4005).l,a1
		subq.b	#1,(v_ani1_time).w
		bpl.s	loc_1B2C8
		move.b	#7,(v_ani1_time).w
		addq.b	#1,(v_ani1_frame).w
		andi.b	#3,(v_ani1_frame).w

loc_1B2C8:
		move.b	(v_ani1_frame).w,$1D0(a1)
		subq.b	#1,(v_ani2_time).w
		bpl.s	loc_1B2E4
		move.b	#7,(v_ani2_time).w
		addq.b	#1,(v_ani2_frame).w
		andi.b	#1,(v_ani2_frame).w

loc_1B2E4:
		move.b	(v_ani2_frame).w,d0
		move.b	d0,$138(a1)
		move.b	d0,$160(a1)
		move.b	d0,$148(a1)
		move.b	d0,$150(a1)
		move.b	d0,$1D8(a1)
		move.b	d0,$1E0(a1)
		move.b	d0,$1E8(a1)
		move.b	d0,$1F0(a1)
		move.b	d0,$1F8(a1)
		move.b	d0,$200(a1)
		subq.b	#1,(v_ani3_time).w
		bpl.s	loc_1B326
		move.b	#4,(v_ani3_time).w
		addq.b	#1,(v_ani3_frame).w
		andi.b	#3,(v_ani3_frame).w

loc_1B326:
		move.b	(v_ani3_frame).w,d0
		move.b	d0,$168(a1)
		move.b	d0,$170(a1)
		move.b	d0,$178(a1)
		move.b	d0,$180(a1)
		subq.b	#1,(v_ani0_time).w
		bpl.s	loc_1B350
		move.b	#7,(v_ani0_time).w
		subq.b	#1,(v_ani0_frame).w
		andi.b	#7,(v_ani0_frame).w

loc_1B350:
		lea	($FF4016).l,a1
		lea	(SS_WaRiVramSet).l,a0
		moveq	#0,d0
		move.b	(v_ani0_frame).w,d0
		add.w	d0,d0
		lea	(a0,d0.w),a0
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		move.w	(a0),(a1)
		move.w	2(a0),8(a1)
		move.w	4(a0),$10(a1)
		move.w	6(a0),$18(a1)
		move.w	8(a0),$20(a1)
		move.w	$A(a0),$28(a1)
		move.w	$C(a0),$30(a1)
		move.w	$E(a0),$38(a1)
		adda.w	#$20,a0
		adda.w	#$48,a1
		rts	
; End of function SS_AniWallsRings

; ===========================================================================
SS_WaRiVramSet:	dc.w $142, $6142, $142,	$142, $142, $142, $142,	$6142
		dc.w $142, $6142, $142,	$142, $142, $142, $142,	$6142
		dc.w $2142, $142, $2142, $2142,	$2142, $2142, $2142, $142
		dc.w $2142, $142, $2142, $2142,	$2142, $2142, $2142, $142
		dc.w $4142, $2142, $4142, $4142, $4142,	$4142, $4142, $2142
		dc.w $4142, $2142, $4142, $4142, $4142,	$4142, $4142, $2142
		dc.w $6142, $4142, $6142, $6142, $6142,	$6142, $6142, $4142
		dc.w $6142, $4142, $6142, $6142, $6142,	$6142, $6142, $4142
; ---------------------------------------------------------------------------
; Subroutine to	remove items when you collect them in the special stage
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_RemoveCollectedItem:
		lea	($FF4400).l,a2
		move.w	#$1F,d0

loc_1B4C4:
		tst.b	(a2)
		beq.s	locret_1B4CE
		addq.w	#8,a2
		dbf	d0,loc_1B4C4

locret_1B4CE:
		rts	
; End of function SS_RemoveCollectedItem

; ---------------------------------------------------------------------------
; Subroutine to	animate	special	stage items when you touch them
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_AniItems:
		lea	($FF4400).l,a0
		move.w	#$1F,d7

loc_1B4DA:
		moveq	#0,d0
		move.b	(a0),d0
		beq.s	loc_1B4E8
		lsl.w	#2,d0
		movea.l	SS_AniIndex-4(pc,d0.w),a1
		jsr	(a1)

loc_1B4E8:
		addq.w	#8,a0

loc_1B4EA:
		dbf	d7,loc_1B4DA

		rts	
; End of function SS_AniItems

; ===========================================================================
SS_AniIndex:	dc.l SS_AniRingSparks
		dc.l SS_AniBumper
		dc.l SS_Ani1Up
		dc.l SS_AniReverse
		dc.l SS_AniEmeraldSparks
		dc.l SS_AniGlassBlock
; ===========================================================================

SS_AniRingSparks:
		subq.b	#1,2(a0)
		bpl.s	locret_1B530
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniRingData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B530
		clr.l	(a0)
		clr.l	4(a0)

locret_1B530:
		rts	
; ===========================================================================
SS_AniRingData:	dc.b $42, $43, $44, $45, 0, 0
; ===========================================================================

SS_AniBumper:
		subq.b	#1,2(a0)
		bpl.s	locret_1B566
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniBumpData(pc,d0.w),d0
		bne.s	loc_1B564
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$25,(a1)
		rts	
; ===========================================================================

loc_1B564:
		move.b	d0,(a1)

locret_1B566:
		rts	
; ===========================================================================
SS_AniBumpData:	dc.b $32, $33, $32, $33, 0, 0
; ===========================================================================

SS_Ani1Up:
		subq.b	#1,2(a0)
		bpl.s	locret_1B596
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_Ani1UpData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B596
		clr.l	(a0)
		clr.l	4(a0)

locret_1B596:
		rts	
; ===========================================================================
SS_Ani1UpData:	dc.b $46, $47, $48, $49, 0, 0
; ===========================================================================

SS_AniReverse:
		subq.b	#1,2(a0)
		bpl.s	locret_1B5CC
		move.b	#7,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniRevData(pc,d0.w),d0
		bne.s	loc_1B5CA
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#$2B,(a1)
		rts	
; ===========================================================================

loc_1B5CA:
		move.b	d0,(a1)

locret_1B5CC:
		rts	
; ===========================================================================
SS_AniRevData:	dc.b $2B, $31, $2B, $31, 0, 0
; ===========================================================================

SS_AniEmeraldSparks:
		subq.b	#1,2(a0)
		bpl.s	locret_1B60C
		move.b	#5,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniEmerData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B60C
		clr.l	(a0)
		clr.l	4(a0)
		move.b	#4,($FFFFD024).w
		sfx	sfx_SSGoal,0,0,0	; play special stage GOAL sound

locret_1B60C:
		rts	
; ===========================================================================
SS_AniEmerData:	dc.b $46, $47, $48, $49, 0, 0
; ===========================================================================

SS_AniGlassBlock:
		subq.b	#1,2(a0)
		bpl.s	locret_1B640
		move.b	#1,2(a0)
		moveq	#0,d0
		move.b	3(a0),d0
		addq.b	#1,3(a0)
		movea.l	4(a0),a1
		move.b	SS_AniGlassData(pc,d0.w),d0
		move.b	d0,(a1)
		bne.s	locret_1B640
		move.b	4(a0),(a1)
		clr.l	(a0)
		clr.l	4(a0)

locret_1B640:
		rts	
; ===========================================================================
SS_AniGlassData:dc.b $4B, $4C, $4D, $4E, $4B, $4C, $4D,	$4E, 0,	0

; ---------------------------------------------------------------------------
; Special stage	layout pointers
; ---------------------------------------------------------------------------
SS_LayoutIndex:
		dc.l SS_1
		dc.l SS_2
		dc.l SS_3
		dc.l SS_4
		dc.l SS_5
		dc.l SS_6
		even

; ---------------------------------------------------------------------------
; Special stage start locations
; ---------------------------------------------------------------------------
SS_StartLoc:	include	"_inc\Start Location Array - Special Stages.asm"

; ---------------------------------------------------------------------------
; Subroutine to	load special stage layout
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


SS_Load:
		moveq	#0,d0
		move.b	(v_lastspecial).w,d0 ; load number of last special stage entered
		addq.b	#1,(v_lastspecial).w
		cmpi.b	#6,(v_lastspecial).w
		blo.s	SS_ChkEmldNum
		move.b	#0,(v_lastspecial).w ; reset if higher than 6

SS_ChkEmldNum:
		cmpi.b	#6,(v_emeralds).w ; do you have all emeralds?
		beq.s	SS_LoadData	; if yes, branch
		moveq	#0,d1
		move.b	(v_emeralds).w,d1
		subq.b	#1,d1
		blo.s	SS_LoadData
		lea	(v_emldlist).w,a3 ; check which emeralds you have

SS_ChkEmldLoop:	
		cmp.b	(a3,d1.w),d0
		bne.s	SS_ChkEmldRepeat
		bra.s	SS_Load
; ===========================================================================

SS_ChkEmldRepeat:
		dbf	d1,SS_ChkEmldLoop

SS_LoadData:
		lsl.w	#2,d0
		lea	SS_StartLoc(pc,d0.w),a1
		move.w	(a1)+,(v_player+obX).w
		move.w	(a1)+,(v_player+obY).w
		movea.l	SS_LayoutIndex(pc,d0.w),a0
		lea	($FF4000).l,a1
		move.w	#0,d0
		jsr	(EniDec).l
		lea	($FF0000).l,a1
		move.w	#$FFF,d0

SS_ClrRAM3:
		clr.l	(a1)+
		dbf	d0,SS_ClrRAM3

		lea	($FF1020).l,a1
		lea	($FF4000).l,a0
		moveq	#$3F,d1

loc_1B6F6:
		moveq	#$3F,d2

loc_1B6F8:
		move.b	(a0)+,(a1)+
		dbf	d2,loc_1B6F8

		lea	$40(a1),a1
		dbf	d1,loc_1B6F6

		lea	($FF4008).l,a1
		lea	(SS_MapIndex).l,a0
		moveq	#$4D,d1

loc_1B714:
		move.l	(a0)+,(a1)+
		move.w	#0,(a1)+
		move.b	-4(a0),-1(a1)
		move.w	(a0)+,(a1)+
		dbf	d1,loc_1B714

		lea	($FF4400).l,a1
		move.w	#$3F,d1

loc_1B730:

		clr.l	(a1)+
		dbf	d1,loc_1B730

		rts	
; End of function SS_Load

; ===========================================================================

SS_MapIndex:
		include	"_inc\Special Stage Mappings & VRAM Pointers.asm"

Map_SS_R:	include	"_maps\SS R Block.asm"
Map_SS_Glass:	include	"_maps\SS Glass Block.asm"
Map_SS_Up:	include	"_maps\SS UP Block.asm"
Map_SS_Down:	include	"_maps\SS DOWN Block.asm"
		include	"_maps\SS Chaos Emeralds.asm"

		include	"_incObj\09 Sonic in Special Stage.asm"

		include	"_incObj\10.asm"

		include	"_inc\AnimateLevelGfx.asm"

		include	"_incObj\21 HUD.asm"
Map_HUD:	include	"_maps\HUD.asm"

; ---------------------------------------------------------------------------
; Add points subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


AddPoints:
		move.b	#1,(f_scorecount).w ; set score counter to update

		if Revision=0
		lea	(v_scorecopy).w,a2
		lea	(v_score).w,a3
		add.l	d0,(a3)		; add d0*10 to the score
		move.l	#999999,d1
		cmp.l	(a3),d1		; is score below 999999?
		bhi.w	@belowmax	; if yes, branch
		move.l	d1,(a3)		; reset	score to 999999
		move.l	d1,(a2)

	@belowmax:
		move.l	(a3),d0
		cmp.l	(a2),d0
		blo.w	@locret_1C6B6
		move.l	d0,(a2)

		else

			lea     (v_score).w,a3
			add.l   d0,(a3)
			move.l  #999999,d1
			cmp.l   (a3),d1 ; is score below 999999?
			bhi.s   @belowmax ; if yes, branch
			move.l  d1,(a3) ; reset score to 999999
		@belowmax:
			move.l  (a3),d0
			cmp.l   (v_scorelife).w,d0 ; has Sonic got 50000+ points?
			blo.s   @noextralife ; if not, branch

			addi.l  #5000,(v_scorelife).w ; increase requirement by 50000
			tst.b   (v_megadrive).w
			bmi.s   @noextralife ; branch if Mega Drive is Japanese
			addq.b  #1,(v_lives).w ; give extra life
			addq.b  #1,(f_lifecount).w
			music	bgm_ExtraLife,1,0,0
		endc

@locret_1C6B6:
@noextralife:
		rts	
; End of function AddPoints

		include	"_inc\HUD_Update.asm"

; ---------------------------------------------------------------------------
; Subroutine to	load countdown numbers on the continue screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ContScrCounter:
		locVRAM	$DF80
		lea	(vdp_data_port).l,a6
		lea	(Hud_10).l,a2
		moveq	#1,d6
		moveq	#0,d4
		lea	Art_Hud(pc),a1 ; load numbers patterns

ContScr_Loop:
		moveq	#0,d2
		move.l	(a2)+,d3

loc_1C95A:
		sub.l	d3,d1
		blo.s	loc_1C962
		addq.w	#1,d2
		bra.s	loc_1C95A
; ===========================================================================

loc_1C962:
		add.l	d3,d1
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		dbf	d6,ContScr_Loop	; repeat 1 more	time

		rts	
; End of function ContScrCounter

; ===========================================================================

		include	"_inc\HUD (part 2).asm"

Art_Hud:	incbin	"artunc\HUD Numbers.bin" ; 8x16 pixel numbers on HUD
		even
Art_LivesNums:	incbin	"artunc\Lives Counter Numbers.bin" ; 8x8 pixel numbers on lives counter
		even

		include	"_incObj\DebugMode.asm"
		include	"_inc\DebugList.asm"
		include	"_inc\LevelHeaders.asm"
		include	"_inc\Pattern Load Cues.asm"

		align	$200,$FF
		if Revision=0
Nem_SegaLogo:	incbin	"artnem\Sega Logo.bin"	; large Sega logo
		even
Eni_SegaLogo:	incbin	"tilemaps\Sega Logo.bin" ; large Sega logo (mappings)
		even
		else
			dcb.b	$300,$FF
	Nem_SegaLogo:	incbin	"artnem\Sega Logo (JP1).bin" ; large Sega logo
			even
	Eni_SegaLogo:	incbin	"tilemaps\Sega Logo (JP1).bin" ; large Sega logo (mappings)
			even
		endc
Eni_Title:	incbin	"tilemaps\Title Screen.bin" ; title screen foreground (mappings)
		even
Nem_TitleFg:	incbin	"artnem\Title Screen Foreground.bin"
		even
Nem_TitleSonic:	incbin	"artnem\Title Screen Sonic.bin"
		even
Nem_TitleTM:	incbin	"artnem\Title Screen TM.bin"
		even
Nem_TitleMenu:   incbin   "artnem\titlemenu.bin"  
		even		
Eni_JapNames:	incbin	"tilemaps\Hidden Japanese Credits.bin" ; Japanese credits (mappings)
		even
Nem_JapNames:	incbin	"artnem\Hidden Japanese Credits.bin"
		even

Map_Sonic:	include	"_maps\Sonic.asm"
SonicDynPLC:	include	"_maps\Sonic - Dynamic Gfx Script.asm"

; ---------------------------------------------------------------------------
; Uncompressed graphics	- Sonic
; ---------------------------------------------------------------------------
Art_Sonic:	incbin	"artunc\Sonic.bin"	; Sonic
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
		if Revision=0
Nem_Smoke:	incbin	"artnem\Unused - Smoke.bin"
		even
Nem_SyzSparkle:	incbin	"artnem\Unused - SYZ Sparkles.bin"
		even
		else
		endc
Art_GShield:	incbin	"artunc\Gold Shield.bin"
		even
Art_RedShield:	incbin	"artunc\Red Shield.bin"
		even
Art_SpShield:	incbin	"artunc\Gray Shield.bin"
		even
Art_Shield:	incbin	"artunc\Shield.bin"
		even
Unc_Stars:	incbin	"artunc\Invincibility Stars.bin"
		even
		if Revision=0
Nem_LzSonic:	incbin	"artnem\Unused - LZ Sonic.bin" ; Sonic holding his breath
		even
Nem_UnkFire:	incbin	"artnem\Unused - Fireball.bin" ; unused fireball
		even
Nem_Warp:	incbin	"artnem\Unused - SStage Flash.bin" ; entry to special stage flash
		even
Nem_Goggle:	incbin	"artnem\Unused - Goggles.bin" ; unused goggles
		even
		else
		endc

Map_SSWalls:	include	"_maps\SS Walls.asm"

; ---------------------------------------------------------------------------
; Compressed graphics - special stage
; ---------------------------------------------------------------------------
Nem_SSWalls:	incbin	"artnem\Special Walls.bin" ; special stage walls
		even
Eni_SSBg1:	incbin	"tilemaps\SS Background 1.bin" ; special stage background (mappings)
		even
Nem_SSBgFish:	incbin	"artnem\Special Birds & Fish.bin" ; special stage birds and fish background
		even
Eni_SSBg2:	incbin	"tilemaps\SS Background 2.bin" ; special stage background (mappings)
		even
Nem_SSBgCloud:	incbin	"artnem\Special Clouds.bin" ; special stage clouds background
		even
Nem_SSGOAL:	incbin	"artnem\Special GOAL.bin" ; special stage GOAL block
		even
Nem_SSRBlock:	incbin	"artnem\Special R.bin"	; special stage R block
		even
Nem_SS1UpBlock:	incbin	"artnem\Special 1UP.bin" ; special stage 1UP block
		even
Nem_SSEmStars:	incbin	"artnem\Special Emerald Twinkle.bin" ; special stage stars from a collected emerald
		even
Nem_SSRedWhite:	incbin	"artnem\Special Red-White.bin" ; special stage red/white block
		even
Nem_SSZone1:	incbin	"artnem\Special ZONE1.bin" ; special stage ZONE1 block
		even
Nem_SSZone2:	incbin	"artnem\Special ZONE2.bin" ; ZONE2 block
		even
Nem_SSZone3:	incbin	"artnem\Special ZONE3.bin" ; ZONE3 block
		even
Nem_SSZone4:	incbin	"artnem\Special ZONE4.bin" ; ZONE4 block
		even
Nem_SSZone5:	incbin	"artnem\Special ZONE5.bin" ; ZONE5 block
		even
Nem_SSZone6:	incbin	"artnem\Special ZONE6.bin" ; ZONE6 block
		even
Nem_SSUpDown:	incbin	"artnem\Special UP-DOWN.bin" ; special stage UP/DOWN block
		even
Nem_SSEmerald:	incbin	"artnem\Special Emeralds.bin" ; special stage chaos emeralds
		even
Nem_SSGhost:	incbin	"artnem\Special Ghost.bin" ; special stage ghost block
		even
Nem_SSWBlock:	incbin	"artnem\Special W.bin"	; special stage W block
		even
Nem_SSGlass:	incbin	"artnem\Special Glass.bin" ; special stage destroyable glass block
		even
Nem_ResultEm:	incbin	"artnem\Special Result Emeralds.bin" ; chaos emeralds on special stage results screen
		even
; ---------------------------------------------------------------------------
; Compressed graphics - GHZ stuff
; ---------------------------------------------------------------------------
Nem_Stalk:	incbin	"artnem\GHZ Flower Stalk.bin"
		even
Nem_Swing:	incbin	"artnem\GHZ Swinging Platform.bin"
		even
Nem_Bridge:	incbin	"artnem\GHZ Bridge.bin"
		even
Nem_GhzUnkBlock:incbin	"artnem\Unused - GHZ Block.bin"
		even
Nem_Ball:	incbin	"artnem\GHZ Giant Ball.bin"
		even
Nem_Spikes:	incbin	"artnem\Spikes.bin"
		even
Nem_GhzLog:	incbin	"artnem\Unused - GHZ Log.bin"
		even
Nem_SpikePole:	incbin	"artnem\GHZ Spiked Log.bin"
		even
Nem_PplRock:	incbin	"artnem\GHZ Purple Rock.bin"
		even
Nem_GhzWall1:	incbin	"artnem\GHZ Breakable Wall.bin"
		even
Nem_GhzWall2:	incbin	"artnem\GHZ Edge Wall.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - LZ stuff
; ---------------------------------------------------------------------------
Nem_Water:	incbin	"artnem\LZ Water Surface.bin"
		even
Nem_Splash:	incbin	"artnem\LZ Water & Splashes.bin"
		even
Nem_LzSpikeBall:incbin	"artnem\LZ Spiked Ball & Chain.bin"
		even
Nem_FlapDoor:	incbin	"artnem\LZ Flapping Door.bin"
		even
Nem_Bubbles:	incbin	"artnem\LZ Bubbles & Countdown.bin"
		even
Nem_LzBlock3:	incbin	"artnem\LZ 32x16 Block.bin"
		even
Nem_LzDoor1:	incbin	"artnem\LZ Vertical Door.bin"
		even
Nem_Harpoon:	incbin	"artnem\LZ Harpoon.bin"
		even
Nem_LzPole:	incbin	"artnem\LZ Breakable Pole.bin"
		even
Nem_LzDoor2:	incbin	"artnem\LZ Horizontal Door.bin"
		even
Nem_LzWheel:	incbin	"artnem\LZ Wheel.bin"
		even
Nem_Gargoyle:	incbin	"artnem\LZ Gargoyle & Fireball.bin"
		even
Nem_LzBlock2:	incbin	"artnem\LZ Blocks.bin"
		even
Nem_LzPlatfm:	incbin	"artnem\LZ Rising Platform.bin"
		even
Nem_Cork:	incbin	"artnem\LZ Cork.bin"
		even
Nem_LzBlock1:	incbin	"artnem\LZ 32x32 Block.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - MZ stuff
; ---------------------------------------------------------------------------
Nem_MzMetal:	incbin	"artnem\MZ Metal Blocks.bin"
		even
Nem_MzSwitch:	incbin	"artnem\MZ Switch.bin"
		even
Nem_MzGlass:	incbin	"artnem\MZ Green Glass Block.bin"
		even
Nem_UnkGrass:	incbin	"artnem\Unused - Grass.bin"
		even
Nem_MzFire:	incbin	"artnem\Fireballs.bin"
		even
Nem_Lava:	incbin	"artnem\MZ Lava.bin"
		even
Nem_MzBlock:	incbin	"artnem\MZ Green Pushable Block.bin"
		even
Nem_MzUnkBlock:	incbin	"artnem\Unused - MZ Background.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SLZ stuff
; ---------------------------------------------------------------------------
Nem_Seesaw:	incbin	"artnem\SLZ Seesaw.bin"
		even
Nem_SlzSpike:	incbin	"artnem\SLZ Little Spikeball.bin"
		even
Nem_Fan:	incbin	"artnem\SLZ Fan.bin"
		even
Nem_SlzWall:	incbin	"artnem\SLZ Breakable Wall.bin"
		even
Nem_Pylon:	incbin	"artnem\SLZ Pylon.bin"
		even
Nem_SlzSwing:	incbin	"artnem\SLZ Swinging Platform.bin"
		even
Nem_SlzBlock:	incbin	"artnem\SLZ 32x32 Block.bin"
		even
Nem_SlzCannon:	incbin	"artnem\SLZ Cannon.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SYZ stuff
; ---------------------------------------------------------------------------
Nem_Bumper:	incbin	"artnem\SYZ Bumper.bin"
		even
Nem_SyzSpike2:	incbin	"artnem\SYZ Small Spikeball.bin"
		even
Nem_LzSwitch:	incbin	"artnem\Switch.bin"
		even
Nem_SyzSpike1:	incbin	"artnem\SYZ Large Spikeball.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - SBZ stuff
; ---------------------------------------------------------------------------
Nem_SbzWheel1:	incbin	"artnem\SBZ Running Disc.bin"
		even
Nem_SbzWheel2:	incbin	"artnem\SBZ Junction Wheel.bin"
		even
Nem_Cutter:	incbin	"artnem\SBZ Pizza Cutter.bin"
		even
Nem_Stomper:	incbin	"artnem\SBZ Stomper.bin"
		even
Nem_SpinPform:	incbin	"artnem\SBZ Spinning Platform.bin"
		even
Nem_TrapDoor:	incbin	"artnem\SBZ Trapdoor.bin"
		even
Nem_SbzFloor:	incbin	"artnem\SBZ Collapsing Floor.bin"
		even
Nem_Electric:	incbin	"artnem\SBZ Electrocuter.bin"
		even
Nem_SbzBlock:	incbin	"artnem\SBZ Vanishing Block.bin"
		even
Nem_FlamePipe:	incbin	"artnem\SBZ Flaming Pipe.bin"
		even
Nem_SbzDoor1:	incbin	"artnem\SBZ Small Vertical Door.bin"
		even
Nem_SlideFloor:	incbin	"artnem\SBZ Sliding Floor Trap.bin"
		even
Nem_SbzDoor2:	incbin	"artnem\SBZ Large Horizontal Door.bin"
		even
Nem_Girder:	incbin	"artnem\SBZ Crushing Girder.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - enemies
; ---------------------------------------------------------------------------
Nem_BallHog:	incbin	"artnem\Enemy Ball Hog.bin"
		even
Nem_Crabmeat:	incbin	"artnem\Enemy Crabmeat.bin"
		even
Nem_Mozzietron:	incbin	"artnem\Enemy Mozzietron.bin"
		even
Nem_Buzz:	incbin	"artnem\Enemy Buzz Bomber.bin"
		even
Nem_UnkExplode:	incbin	"artnem\Unused - Explosion.bin"
		even
Nem_Burrobot:	incbin	"artnem\Enemy Burrobot.bin"
		even
Nem_Chopper:	incbin	"artnem\Enemy Chopper.bin"
		even
Nem_Jaws:	incbin	"artnem\Enemy Jaws.bin"
		even
Nem_Roller:	incbin	"artnem\Enemy Roller.bin"
		even
Nem_Motobug:	incbin	"artnem\Enemy Motobug.bin"
		even
Nem_Newtron:	incbin	"artnem\Enemy Newtron.bin"
		even
Nem_Yadrin:	incbin	"artnem\Enemy Yadrin.bin"
		even
Nem_Basaran:	incbin	"artnem\Enemy Basaran.bin"
		even
Nem_Splats:	incbin	"artnem\Enemy Splats.bin"
		even
Nem_Bomb:	incbin	"artnem\Enemy Bomb.bin"
		even
Nem_Orbinaut:	incbin	"artnem\Enemy Orbinaut.bin"
		even
Nem_Cater:	incbin	"artnem\Enemy Caterkiller.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - various
; ---------------------------------------------------------------------------
Nem_TitleCard:	incbin	"artnem\Title Cards.bin"
		even
Nem_Hud:	incbin	"artnem\HUD.bin"	; HUD (rings, time, score)
		even
Nem_Lives:	incbin	"artnem\HUD - Life Counter Icon.bin"
		even
Nem_Future:	incbin	"artnem\HUD - Life Counter Icon Future.bin"
		even
Nem_Ring:	incbin	"artnem\Rings.bin"
		even
Nem_Monitors:	incbin	"artnem\Monitors.bin"
		even
Nem_Explode:	incbin	"artnem\Explosion.bin"
		even
Nem_Points:	incbin	"artnem\Points.bin"	; points from destroyed enemy or object
		even
Nem_GameOver:	incbin	"artnem\Game Over.bin"	; game over / time over
		even
Nem_HSpring:	incbin	"artnem\Spring Horizontal.bin"
		even
Nem_VSpring:	incbin	"artnem\Spring Vertical.bin"
		even
Nem_SignPost:	incbin	"artnem\Signpost.bin"	; end of level signpost
		even
Nem_Lamp:	incbin	"artnem\Lamppost.bin"
		even
Nem_BigFlash:	incbin	"artnem\Giant Ring Flash.bin"
		even
Nem_Bonus:	incbin	"artnem\Hidden Bonuses.bin" ; hidden bonuses at end of a level
		even
; ---------------------------------------------------------------------------
; Compressed graphics - continue screen
; ---------------------------------------------------------------------------
Nem_ContSonic:	incbin	"artnem\Continue Screen Sonic.bin"
		even
Nem_MiniSonic:	incbin	"artnem\Continue Screen Stuff.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - animals
; ---------------------------------------------------------------------------
Nem_Rabbit:	incbin	"artnem\Animal Rabbit.bin"
		even
Nem_Chicken:	incbin	"artnem\Animal Chicken.bin"
		even
Nem_BlackBird:	incbin	"artnem\Animal Blackbird.bin"
		even
Nem_Seal:	incbin	"artnem\Animal Seal.bin"
		even
Nem_Pig:	incbin	"artnem\Animal Pig.bin"
		even
Nem_Flicky:	incbin	"artnem\Animal Flicky.bin"
		even
Nem_Squirrel:	incbin	"artnem\Animal Squirrel.bin"
		even
; ---------------------------------------------------------------------------
; Compressed graphics - primary patterns and block mappings
; ---------------------------------------------------------------------------
Blk16_GHZ:	incbin	"map16\GHZ.bin"
		even
Nem_GHZ_1st:	incbin	"artnem\8x8 - GHZ1.bin"	; GHZ primary patterns
		even
Nem_GHZ_2nd:	incbin	"artnem\8x8 - GHZ2.bin"	; GHZ secondary patterns
		even
Blk256_GHZ:	incbin	"map256\GHZ.bin"
		even
Blk16_TS:	incbin	"map16\TS.bin"
		even
Nem_TS_1st:	incbin	"artnem\8x8 - TS1.bin"	; GHZ primary patterns
		even
Blk256_TS:	incbin	"map256\TS.bin"
		even
Blk16_LZ:	incbin	"map16\LZ.bin"
		even
Nem_LZ:		incbin	"artnem\8x8 - LZ.bin"	; LZ primary patterns
		even
Blk256_LZ:	incbin	"map256\LZ.bin"
		even
Blk16_MZ:	incbin	"map16\MZ.bin"
		even
Nem_MZ:		incbin	"artnem\8x8 - MZ.bin"	; MZ primary patterns
		even
Blk256_MZ:	if Revision=0
		incbin	"map256\MZ.bin"
		else
		incbin	"map256\MZ (JP1).bin"
		endc
		even
Blk16_SLZ:	incbin	"map16\SLZ.bin"
		even
Nem_SLZ:	incbin	"artnem\8x8 - SLZ.bin"	; SLZ primary patterns
		even
Blk256_SLZ:	incbin	"map256\SLZ.bin"
		even
Blk16_SYZ:	incbin	"map16\SYZ.bin"
		even
Nem_SYZ:	incbin	"artnem\8x8 - SYZ.bin"	; SYZ primary patterns
		even
Blk256_SYZ:	incbin	"map256\SYZ.bin"
		even
Blk16_SBZ:	incbin	"map16\SBZ.bin"
		even
Nem_SBZ:	incbin	"artnem\8x8 - SBZ.bin"	; SBZ primary patterns
		even
Blk256_SBZ:	if Revision=0
		incbin	"map256\SBZ.bin"
		else
		incbin	"map256\SBZ (JP1).bin"
		endc
		even
; ---------------------------------------------------------------------------
; Compressed graphics - bosses and ending sequence
; ---------------------------------------------------------------------------
Nem_Eggman:	incbin	"artnem\Boss - Main.bin"
		even
Nem_Weapons:	incbin	"artnem\Boss - Weapons.bin"
		even
Nem_Prison:	incbin	"artnem\Prison Capsule.bin"
		even
Nem_Sbz2Eggman:	incbin	"artnem\Boss - Eggman in SBZ2 & FZ.bin"
		even
Nem_FzBoss:	incbin	"artnem\Boss - Final Zone.bin"
		even
Nem_FzEggman:	incbin	"artnem\Boss - Eggman after FZ Fight.bin"
		even
Nem_Exhaust:	incbin	"artnem\Boss - Exhaust Flame.bin"
		even
Nem_EndEm:	incbin	"artnem\Ending - Emeralds.bin"
		even
Nem_EndSonic:	incbin	"artnem\Ending - Sonic.bin"
		even
Nem_TryAgain:	incbin	"artnem\Ending - Try Again.bin"
		even
Nem_EndEggman:	if Revision=0
		incbin	"artnem\Unused - Eggman Ending.bin"
		else
		endc
		even
Kos_EndFlowers:	incbin	"artkos\Flowers at Ending.bin" ; ending sequence animated flowers
		even
Nem_EndFlower:	incbin	"artnem\Ending - Flowers.bin"
		even
Nem_CreditText:	incbin	"artnem\Ending - Credits.bin"
		even
Nem_EndStH:	incbin	"artnem\Ending - StH Logo.bin"
		even

		if Revision=0
		dcb.b $104,$FF			; why?
		else
		dcb.b $40,$FF
		endc
; ---------------------------------------------------------------------------
; Collision data
; ---------------------------------------------------------------------------
AngleMap:	incbin	"collide\Angle Map.bin"
		even
CollArray1:	incbin	"collide\Collision Array (Normal).bin"
		even
CollArray2:	incbin	"collide\Collision Array (Rotated).bin"
		even
Col_GHZ:	incbin	"collide\GHZ.bin"	; GHZ index
		even
Col_LZ:		incbin	"collide\LZ.bin"	; LZ index
		even
Col_MZ:		incbin	"collide\MZ.bin"	; MZ index
		even
Col_SLZ:	incbin	"collide\SLZ.bin"	; SLZ index
		even
Col_SYZ:	incbin	"collide\SYZ.bin"	; SYZ index
		even
Col_SBZ:	incbin	"collide\SBZ.bin"	; SBZ index
		even
; ---------------------------------------------------------------------------
; Special Stage layouts
; ---------------------------------------------------------------------------
SS_1:		incbin	"sslayout\1.bin"
		even
SS_2:		incbin	"sslayout\2.bin"
		even
SS_3:		incbin	"sslayout\3.bin"
		even
SS_4:		incbin	"sslayout\4.bin"
		even
		if Revision=0
SS_5:		incbin	"sslayout\5.bin"
		even
SS_6:		incbin	"sslayout\6.bin"
		else
	SS_5:		incbin	"sslayout\5 (JP1).bin"
			even
	SS_6:		incbin	"sslayout\6 (JP1).bin"
		endc
		even
; ---------------------------------------------------------------------------
; Animated uncompressed graphics
; ---------------------------------------------------------------------------
Art_GhzWater:	incbin	"artunc\GHZ Waterfall.bin"
		even
Art_GhzFlower1:	incbin	"artunc\GHZ Flower Large.bin"
		even
Art_GhzFlower2:	incbin	"artunc\GHZ Flower Small.bin"
		even
Art_MzLava1:	incbin	"artunc\MZ Lava Surface.bin"
		even
Art_MzLava2:	incbin	"artunc\MZ Lava.bin"
		even
Art_MzTorch:	incbin	"artunc\MZ Background Torch.bin"
		even
Art_SbzSmoke:	incbin	"artunc\SBZ Background Smoke.bin"
		even

; ---------------------------------------------------------------------------
; Level	layout index
; ---------------------------------------------------------------------------
Level_Index:
		; GHZ
		dc.w Level_GHZ1-Level_Index, Level_GHZbg-Level_Index, byte_68D70-Level_Index
		dc.w Level_GHZ2-Level_Index, Level_GHZbg-Level_Index, byte_68E3C-Level_Index
		dc.w Level_GHZ3-Level_Index, Level_GHZbg-Level_Index, byte_68F84-Level_Index
		dc.w byte_68F88-Level_Index, byte_68F88-Level_Index, byte_68F88-Level_Index
		; LZ
		dc.w Level_LZ1-Level_Index, Level_LZbg-Level_Index, byte_69190-Level_Index
		dc.w Level_LZ2-Level_Index, Level_LZbg-Level_Index, byte_6922E-Level_Index
		dc.w Level_LZ3-Level_Index, Level_LZbg-Level_Index, byte_6934C-Level_Index
		dc.w Level_SBZ3-Level_Index, Level_LZbg-Level_Index, byte_6940A-Level_Index
		; MZ
		dc.w Level_MZ1-Level_Index, Level_MZ1bg-Level_Index, Level_MZ1-Level_Index
		dc.w Level_MZ2-Level_Index, Level_MZ2bg-Level_Index, byte_6965C-Level_Index
		dc.w Level_MZ3-Level_Index, Level_MZ3bg-Level_Index, byte_697E6-Level_Index
		dc.w byte_697EA-Level_Index, byte_697EA-Level_Index, byte_697EA-Level_Index
		; SLZ
		dc.w Level_SLZ1-Level_Index, Level_SLZbg-Level_Index, byte_69B84-Level_Index
		dc.w Level_SLZ2-Level_Index, Level_SLZbg-Level_Index, byte_69B84-Level_Index
		dc.w Level_SLZ3-Level_Index, Level_SLZbg-Level_Index, byte_69B84-Level_Index
		dc.w byte_69B84-Level_Index, byte_69B84-Level_Index, byte_69B84-Level_Index
		; SYZ
		dc.w Level_SYZ1-Level_Index, Level_SYZbg-Level_Index, byte_69C7E-Level_Index
		dc.w Level_SYZ2-Level_Index, Level_SYZbg-Level_Index, byte_69D86-Level_Index
		dc.w Level_SYZ3-Level_Index, Level_SYZbg-Level_Index, byte_69EE4-Level_Index
		dc.w byte_69EE8-Level_Index, byte_69EE8-Level_Index, byte_69EE8-Level_Index
		; SBZ
		dc.w Level_SBZ1-Level_Index, Level_SBZ1bg-Level_Index, Level_SBZ1bg-Level_Index
		dc.w Level_SBZ2-Level_Index, Level_SBZ2bg-Level_Index, Level_SBZ2bg-Level_Index
		dc.w Level_SBZ2-Level_Index, Level_SBZ2bg-Level_Index, byte_6A2F8-Level_Index
		dc.w byte_6A2FC-Level_Index, byte_6A2FC-Level_Index, byte_6A2FC-Level_Index
		zonewarning Level_Index,24
		; Ending
		dc.w Level_End-Level_Index, Level_GHZbg-Level_Index, byte_6A320-Level_Index
		dc.w Level_End-Level_Index, Level_GHZbg-Level_Index, byte_6A320-Level_Index
		dc.w byte_6A320-Level_Index, byte_6A320-Level_Index, byte_6A320-Level_Index
		dc.w byte_6A320-Level_Index, byte_6A320-Level_Index, byte_6A320-Level_Index

Level_GHZ1:	incbin	"levels\ghz1.bin"
		even
byte_68D70:	dc.b 0,	0, 0, 0
Level_GHZ2:	incbin	"levels\ghz2.bin"
		even
byte_68E3C:	dc.b 0,	0, 0, 0
Level_GHZ3:	incbin	"levels\ghz3.bin"
		even
Level_GHZbg:	incbin	"levels\ghzbg.bin"
		even
byte_68F84:	dc.b 0,	0, 0, 0
byte_68F88:	dc.b 0,	0, 0, 0

Level_LZ1:	incbin	"levels\lz1.bin"
		even
Level_LZbg:	incbin	"levels\lzbg.bin"
		even
byte_69190:	dc.b 0,	0, 0, 0
Level_LZ2:	incbin	"levels\lz2.bin"
		even
byte_6922E:	dc.b 0,	0, 0, 0
Level_LZ3:	incbin	"levels\lz3.bin"
		even
byte_6934C:	dc.b 0,	0, 0, 0
Level_SBZ3:	incbin	"levels\sbz3.bin"
		even
byte_6940A:	dc.b 0,	0, 0, 0

Level_MZ1:	incbin	"levels\mz1.bin"
		even
Level_MZ1bg:	incbin	"levels\mz1bg.bin"
		even
Level_MZ2:	incbin	"levels\mz2.bin"
		even
Level_MZ2bg:	incbin	"levels\mz2bg.bin"
		even
byte_6965C:	dc.b 0,	0, 0, 0
Level_MZ3:	incbin	"levels\mz3.bin"
		even
Level_MZ3bg:	incbin	"levels\mz3bg.bin"
		even
byte_697E6:	dc.b 0,	0, 0, 0
byte_697EA:	dc.b 0,	0, 0, 0

Level_SLZ1:	incbin	"levels\slz1.bin"
		even
Level_SLZbg:	incbin	"levels\slzbg.bin"
		even
Level_SLZ2:	incbin	"levels\slz2.bin"
		even
Level_SLZ3:	incbin	"levels\slz3.bin"
		even
byte_69B84:	dc.b 0,	0, 0, 0

Level_SYZ1:	incbin	"levels\syz1.bin"
		even
Level_SYZbg:	if Revision=0
		incbin	"levels\syzbg.bin"
		else
		incbin	"levels\syzbg (JP1).bin"
		endc
		even
byte_69C7E:	dc.b 0,	0, 0, 0
Level_SYZ2:	incbin	"levels\syz2.bin"
		even
byte_69D86:	dc.b 0,	0, 0, 0
Level_SYZ3:	incbin	"levels\syz3.bin"
		even
byte_69EE4:	dc.b 0,	0, 0, 0
byte_69EE8:	dc.b 0,	0, 0, 0

Level_SBZ1:	incbin	"levels\sbz1.bin"
		even
Level_SBZ1bg:	incbin	"levels\sbz1bg.bin"
		even
Level_SBZ2:	incbin	"levels\sbz2.bin"
		even
Level_SBZ2bg:	incbin	"levels\sbz2bg.bin"
		even
byte_6A2F8:	dc.b 0,	0, 0, 0
byte_6A2FC:	dc.b 0,	0, 0, 0
Level_End:	incbin	"levels\ending.bin"
		even
byte_6A320:	dc.b 0,	0, 0, 0


Art_BigRing:	incbin	"artunc\Giant Ring.bin"
		even

		align	$100,$FF

; ---------------------------------------------------------------------------
; Sprite locations index
; ---------------------------------------------------------------------------
ObjPos_Index:
		; GHZ
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_GHZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; LZ
		dc.w ObjPos_LZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_LZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SBZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; MZ
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_MZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SLZ
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SLZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SYZ
		dc.w ObjPos_SYZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SYZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SYZ3-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SYZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; SBZ
		dc.w ObjPos_SBZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SBZ2-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_FZ-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_SBZ1-ObjPos_Index, ObjPos_Null-ObjPos_Index
		zonewarning ObjPos_Index,$10
		; Ending
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		dc.w ObjPos_End-ObjPos_Index, ObjPos_Null-ObjPos_Index
		; --- Put extra object data here. ---
ObjPosLZPlatform_Index:
		dc.w ObjPos_LZ1pf1-ObjPos_Index, ObjPos_LZ1pf2-ObjPos_Index
		dc.w ObjPos_LZ2pf1-ObjPos_Index, ObjPos_LZ2pf2-ObjPos_Index
		dc.w ObjPos_LZ3pf1-ObjPos_Index, ObjPos_LZ3pf2-ObjPos_Index
		dc.w ObjPos_LZ1pf1-ObjPos_Index, ObjPos_LZ1pf2-ObjPos_Index
ObjPosSBZPlatform_Index:
		dc.w ObjPos_SBZ1pf1-ObjPos_Index, ObjPos_SBZ1pf2-ObjPos_Index
		dc.w ObjPos_SBZ1pf3-ObjPos_Index, ObjPos_SBZ1pf4-ObjPos_Index
		dc.w ObjPos_SBZ1pf5-ObjPos_Index, ObjPos_SBZ1pf6-ObjPos_Index
		dc.w ObjPos_SBZ1pf1-ObjPos_Index, ObjPos_SBZ1pf2-ObjPos_Index
		dc.b $FF, $FF, 0, 0, 0,	0
ObjPos_GHZ1:	incbin	"objpos\ghz1.bin"
		even
ObjPos_GHZ2:	incbin	"objpos\ghz2.bin"
		even
ObjPos_GHZ3:	if Revision=0
		incbin	"objpos\ghz3.bin"
		else
		incbin	"objpos\ghz3 (JP1).bin"
		endc
		even
ObjPos_LZ1:	if Revision=0
		incbin	"objpos\lz1.bin"
		else
		incbin	"objpos\lz1 (JP1).bin"
		endc
		even
ObjPos_LZ2:	incbin	"objpos\lz2.bin"
		even
ObjPos_LZ3:	if Revision=0
		incbin	"objpos\lz3.bin"
		else
		incbin	"objpos\lz3 (JP1).bin"
		endc
		even
ObjPos_SBZ3:	incbin	"objpos\sbz3.bin"
		even
ObjPos_LZ1pf1:	incbin	"objpos\lz1pf1.bin"
		even
ObjPos_LZ1pf2:	incbin	"objpos\lz1pf2.bin"
		even
ObjPos_LZ2pf1:	incbin	"objpos\lz2pf1.bin"
		even
ObjPos_LZ2pf2:	incbin	"objpos\lz2pf2.bin"
		even
ObjPos_LZ3pf1:	incbin	"objpos\lz3pf1.bin"
		even
ObjPos_LZ3pf2:	incbin	"objpos\lz3pf2.bin"
		even
ObjPos_MZ1:	if Revision=0
		incbin	"objpos\mz1.bin"
		else
		incbin	"objpos\mz1 (JP1).bin"
		endc
		even
ObjPos_MZ2:	incbin	"objpos\mz2.bin"
		even
ObjPos_MZ3:	incbin	"objpos\mz3.bin"
		even
ObjPos_SLZ1:	incbin	"objpos\slz1.bin"
		even
ObjPos_SLZ2:	incbin	"objpos\slz2.bin"
		even
ObjPos_SLZ3:	incbin	"objpos\slz3.bin"
		even
ObjPos_SYZ1:	incbin	"objpos\syz1.bin"
		even
ObjPos_SYZ2:	incbin	"objpos\syz2.bin"
		even
ObjPos_SYZ3:	if Revision=0
		incbin	"objpos\syz3.bin"
		else
		incbin	"objpos\syz3 (JP1).bin"
		endc
		even
ObjPos_SBZ1:	if Revision=0
		incbin	"objpos\sbz1.bin"
		else
		incbin	"objpos\sbz1 (JP1).bin"
		endc
		even
ObjPos_SBZ2:	incbin	"objpos\sbz2.bin"
		even
ObjPos_FZ:	incbin	"objpos\fz.bin"
		even
ObjPos_SBZ1pf1:	incbin	"objpos\sbz1pf1.bin"
		even
ObjPos_SBZ1pf2:	incbin	"objpos\sbz1pf2.bin"
		even
ObjPos_SBZ1pf3:	incbin	"objpos\sbz1pf3.bin"
		even
ObjPos_SBZ1pf4:	incbin	"objpos\sbz1pf4.bin"
		even
ObjPos_SBZ1pf5:	incbin	"objpos\sbz1pf5.bin"
		even
ObjPos_SBZ1pf6:	incbin	"objpos\sbz1pf6.bin"
		even
ObjPos_End:	incbin	"objpos\ending.bin"
		even
ObjPos_Null:	dc.b $FF, $FF, 0, 0, 0,	0

		if Revision=0
		dcb.b $62A,$FF
		else
		dcb.b $63C,$FF
		endc
		;dcb.b ($10000-(*%$10000))-(EndOfRom-SoundDriver),$FF

SoundDriver:	include "s1.sounddriver.asm"

			include "_inc\Sonic 2 Options.asm"

SHC2022:    incbin "SHC22_Full_Sonic12.bin"
            even

Art_Dust:	incbin	artunc\spindust.bin

; ===============================================================
; ==============================================================
; --------------------------------------------------------------
; Debugging modules
; --------------------------------------------------------------

   include   "ErrorHandler.asm"

; end of 'ROM'
		even
EndOfRom:


		END
