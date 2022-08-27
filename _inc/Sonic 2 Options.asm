; ---------------------------------------------------------------------------
; Common menu screen subroutine for transferring text to RAM

; ARGUMENTS:
; d0 = starting art tile
; a1 = data source
; a2 = destination
;
; ---------------------------------------------------------------------------
MenuScreen:
		move.b	#bgm_Fade,d0
		jsr	PlaySound_Special ; fade out music
		jsr	PaletteFadeOut
		move	#$2700,sr
		move.w	($FFFFF60C).w,d0
		andi.b	#$BF,d0
		move.w	d0,($00C00004).l
		jsr	ClearScreen
		lea		($00C00004).l,a6
		move.w	#$8004,(a6)
		move.w	#$8230,(a6)
		move.w	#$8407,(a6)
		move.w	#$8230,(a6)
		move.w	#$8700,(a6)
		move.w	#$8C81,(a6)
		move.w	#$9001,(a6)


		lea	(v_objspace).w,a1
		moveq	#0,d0
		move.w	#$7FF,d1

MenuScreen_ClrObjRam:
		move.l	d0,(a1)+
		dbf		d1,MenuScreen_ClrObjRam

; ===========================================================================

		ResetDMAQueue

		locVRAM	$200
		lea		(Nem_MenuFont).l,a0
		jsr	NemDec
		locVRAM	$E00
		lea		(Nem_MenuBox).l,a0
		jsr	NemDec
		lea	($FF0000).l,a1
		lea	(Eni_MenuBg).l,a0 ; load SONIC/MILES mappings
		move.w	#$6000,d0
		jsr	EniDec

		copyTilemap	$FF0000,$E000,$27,$1B

		bsr.w	MenuScreen_Options	; if yes, branch

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8FBE:
MenuScreenTextToRAM:
		moveq	#0,d1
		move.b	(a1)+,d1

MenuScreenTextToRAM_Cont:
		move.b	(a1)+,d0
		move.w	d0,(a2)+
		dbf	d1,MenuScreenTextToRAM_Cont
		rts
; End of function MenuScreenTextToRAM

; ===========================================================================
; loc_8FCC:
MenuScreen_Options:
		lea	(v_256x256).l,a1
		lea	(Eni_MenuBox).l,a0
		move.w	#$70,d0
		jsr	EniDec
		lea	(v_256x256+$160).l,a1
		lea	(Eni_MenuBox).l,a0
		move.w	#$2070,d0
		jsr	EniDec
		clr.b	(Options_menu_box).w
		bsr.w	OptionScreen_DrawSelected
		addq.b	#1,(Options_menu_box).w
		bsr.w	OptionScreen_DrawUnselected
		addq.b	#1,(Options_menu_box).w
		bsr.w	OptionScreen_DrawUnselected
		clr.b	(Options_menu_box).w
		clr.b	($FFFFF711).w		
		clr.w	($FFFFF7F0).w					 
;-------------------------------------------------------------------------------
		clr.w	($FFFFF7B8).w
		lea		(Anim_SonicMilesBG).l,a2
		bsr.w	Dynamic_Menu
;-------------------------------------------------------------------------------
		moveq	#palid_Options,d0
		jsr		PalLoad1
		move.b	#$98,d0
		jsr	PlaySound_Special ; play options music
		clr.l	(v_screenposx).w
		clr.l	(v_screenposy).w
		move.b	#$16,(v_vbla_routine).w
		jsr	WaitForVBla
		move.w	(v_vdp_buffer1).w,d0
		ori.b	#$40,d0
		move.w	d0,(vdp_control_port).l
		jsr	PaletteFadeIn
; loc_9060:
OptionScreen_Main:
		move.b	#$16,(v_vbla_routine).w
		jsr	WaitForVBla		
		jsr	ReadJoypads			
		move	#$2700,sr
		bsr.w	OptionScreen_DrawUnselected
		bsr.w	OptionScreen_Controls			
		bsr.w	OptionScreen_DrawSelected
		move	#$2300,sr
		lea		(Anim_SonicMilesBG).l,a2		
		bsr.w	Dynamic_Menu		
		andi.b	#btnStart,(v_jpadpress1).w ; check if Start is pressed

		bne.s	OptionScreen_Select		; if yes, branch
		bra.s	OptionScreen_Main
; ===========================================================================
; loc_909A:
OptionScreen_Select:
		move.b	(Options_menu_box).w,d0
		bne.s	OptionScreen_Select_Not1P
		moveq	#0,d0
		move.w	#(id_GHZ<<8),(v_zone).w	; green_hill_zone_act_1
		move.w	d0,(v_rings).w	; clear rings
		move.l	d0,(v_time).w	; clear time
		move.l	d0,(v_score).w	; clear score
		move.b	#3,(v_lives).w	; set lives to 3
		move.l	#$1388,(v_scorelife).w ; extra life is awarded at 50000 points
		move.b	#id_Level,(v_gamemode).w ; => Level (Zone play mode)
		rts
; ===========================================================================
; loc_90B6:
OptionScreen_Select_Not1P:
		subq.b	#1,d0
		bne.s	OptionScreen_Select_Other
		bra.s	OptionScreen_Main
; ===========================================================================
; loc_90D8:
OptionScreen_Select_Other:
		move.b	#id_Sega,(v_gamemode).w ; => SegaScreen
		rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_90E0:
OptionScreen_Controls:
		moveq	#0,d2
		move.b	(Options_menu_box).w,d2			
		move.b	(v_jpadpress1).w,d0		; Ctrl_1_Press
		btst	#0,d0			; is up pressed?
		beq.s	Option_Controls_Down	; if not, branch
		subq.b	#1,d2					; move up 1 selection
		bcc.s	Option_Controls_Down
		move.b	#2,d2

Option_Controls_Down:
		btst	#1,d0			; is down pressed?
		beq.s	Option_Controls_Refresh	; if not, branch
		addq.b	#1,d2					; move down 1 selection
		cmpi.b	#3,d2
		blo.s	Option_Controls_Refresh
		moveq	#0,d2

Option_Controls_Refresh:
		move.b	d2,(Options_menu_box).w
		lsl.w	#2,d2
		move.b	OptionScreen_Choices(pc,d2.w),d3 ; number of choices for the option
		movea.l	OptionScreen_Choices(pc,d2.w),a1 ; location where the choice is stored (in RAM)
		move.w	(a1),d2
		btst	#2,d0				; is left pressed?
		beq.s	Option_Controls_Right		; if not, branch
		subq.b	#1,d2						; subtract 1 from sound test
		bcc.s	Option_Controls_Right
		move.b	d3,d2

Option_Controls_Right:
		btst	#3,d0			; is right pressed?
		beq.s	Option_Controls_Button_A	; if not, branch
		addq.b	#1,d2						; add 1 to sound test
		cmp.b	d3,d2
		bls.s	Option_Controls_Button_A
		moveq	#0,d2

Option_Controls_Button_A:
		btst	#6,d0				; is button A pressed?
		beq.s	Option_Controls_Refresh2	; if not, branch
		addi.b	#$10,d2						; add $10 to sound test
		cmp.b	d3,d2
		bls.s	Option_Controls_Refresh2
		moveq	#0,d2

Option_Controls_Refresh2:
		move.w	d2,(a1)

Option_Controls_NoMove:
		rts
; End of function OptionScreen_Controls

; ===========================================================================
; word_917A:
OptionScreen_Choices:
		dc.l ($A-1)<<24|($FFFFBE&$FFFFFF)
		dc.l (2-1)<<24|($FFFF8A&$FFFFFF)
		dc.l (2-1)<<24|($FFFF84&$FFFFFF)
		even
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


OptionScreen_DrawSelected:
		bsr.w	loc_9268
		moveq	#0,d1
		move.b	(Options_menu_box).w,d1
		lsl.w	#3,d1
		lea	(OptScrBoxData).l,a3
		lea	(a3,d1.w),a3
		move.w	#$6000,d0
		lea	($FFFF0030).l,a2
		movea.l	(a3)+,a1
		bsr.w	MenuScreenTextToRAM
		lea	($FFFF00B6).l,a2
		moveq	#0,d1
		cmpi.b	#2,(Options_menu_box).w
		beq.s	loc_9186
		move.b	(Options_menu_box).w,d1
		lsl.w	#2,d1
		lea	OptionScreen_Choices(pc),a1
		movea.l	(a1,d1.w),a1
		move.w	(a1),d1
		lsl.w	#2,d1

loc_9186:		
		movea.l	(a4,d1.w),a1
		bsr.w	MenuScreenTextToRAM
		;cmpi.b	#2,(Options_menu_box).w
		;bne.s	loc2_9186
		;lea	($FFFF00C2).l,a2
		;bsr.w	loc_9296

loc2_9186:		
		lea	(v_256x256).l,a1
		move.l	(a3)+,d0
		moveq	#$15,d1
		moveq	#7,d2
		jmp	TilemapToVRAM
; ===========================================================================

OptionScreen_DrawUnselected:
		bsr.w	loc_9268
		moveq	#0,d1
		move.b	(Options_menu_box).w,d1
		lsl.w	#3,d1
		lea	(OptScrBoxData).l,a3
		lea	(a3,d1.w),a3
		moveq	#0,d0
		lea	($FFFF0190).l,a2
		movea.l	(a3)+,a1
		bsr.w	MenuScreenTextToRAM
		lea	($FFFF0216).l,a2
		moveq	#0,d1
		cmpi.b	#2,(Options_menu_box).w
		beq.s	loc2_91F8
		move.b	(Options_menu_box).w,d1
		lsl.w	#2,d1
		lea	OptionScreen_Choices(pc),a1
		movea.l	(a1,d1.w),a1
		move.w	(a1),d1
		lsl.w	#2,d1

loc2_91F8		
		movea.l	(a4,d1.w),a1
		bsr.w	MenuScreenTextToRAM
		;cmpi.b	#2,(Options_menu_box).w
		;bne.s	loc3_91F8
		;lea	($FFFF0222).l,a2
		;bsr.w	loc_9296

loc3_91F8		
		lea	($FFFF0160).l,a1
		move.l	(a3)+,d0
		moveq	#$15,d1
		moveq	#7,d2
		jmp	TilemapToVRAM
; ===========================================================================

loc_9268:
		lea	(off_92D2).l,a4
		tst.b	(v_megadrive).w
		bpl.s	loc2_9268
		lea	(off_92DE).l,a4

loc2_9268:
		tst.b	(Options_menu_box).w
		beq.s	loc3_9268
		lea	(off_92EA).l,a4

loc3_9268:
		cmpi.b	#2,(Options_menu_box).w
		bne.s	loc4_9268		; rts
		lea	(off_92F2).l,a4

loc4_9268:
		rts
; ===========================================================================

loc_9296:
		rts

Dynamic_Menu:
	lea	($FFFFF7B8).w,a3

loc_3FF30:
	move.w	(a2)+,d6	; loop counter. We start off with 00 the first time.

loc_3FF32:
	subq.b	#1,(a3)		; decrement timer
	bcc.s	loc_3FF78	; if time remains, branch ahead
	moveq	#0,d0
	move.b	1(a3),d0	; load animation counter from animation data table
	cmp.b	6(a2),d0
	blo.s	loc_3FF48
	moveq	#0,d0
	move.b	d0,1(a3)	; set animation counter

loc_3FF48:
	addq.b	#1,1(a3)	; increment animation counter
	move.b	(a2),(a3)	; set timer
	bpl.s	loc_3FF56
	add.w	d0,d0
	move.b	9(a2,d0.w),(a3)

loc_3FF56:
	move.b	8(a2,d0.w),d0
	lsl.w	#5,d0
	move.w	4(a2),d2
	move.l	(a2),d1
	andi.l	#$FFFFFF,d1		; Filter out the first byte, which contains the first PLC ID, leaving the address of the zone's art in d0
	add.l	d0,d1
	moveq	#0,d3
	move.b	7(a2),d3
	lsl.w	#4,d3
	jsr	(QueueDMATransfer).l	; Use d1, d2, and d3 to locate the decompressed art and ready for transfer to VRAM

loc_3FF78:
	move.b	6(a2),d0
	tst.b	(a2)
	bpl.s	loc_3FF82
	add.b	d0,d0

loc_3FF82:
	addq.b	#1,d0
	andi.w	#$FE,d0
	lea	8(a2,d0.w),a2
	addq.w	#2,a3
	dbf	d6,loc_3FF32
	rts
; ------------------------------------------------------------------------
; MENU ANIMATION SCRIPT
; ------------------------------------------------------------------------
;word_87C6:
Anim_SonicMilesBG:
	dc.w   0
; Sonic/Miles animated background
	dc.l $FF<<24|Sonic_Miles_Spr
	dc.w $20
	dc.b 6
	dc.b $A
	dc.b   0,$C7    ; "SONIC"
	dc.b  $A,  5	; 2
	dc.b $14,  5	; 4
	dc.b $1E,$C7	; "TAILS"
	dc.b $14,  5	; 8
	dc.b  $A,  5	; 10	
; ===========================================================================
; off_92BA:
OptScrBoxData:

		dc.l TextOptScr_PlayerSelect
		dc.w $4192
		dc.w 3
		dc.l TextOptScr_LivesSystem
		dc.w $4592
		dc.w 3
		dc.l TextOptScr_SoundTest
		dc.w $4992
		dc.w 3

off_92D2:
		dc.l TextOptScr_Default
		dc.l TextOptScr_Original
		dc.l TextOptScr_Beta
		dc.l TextOptScr_Midnight
		dc.l TextOptScr_C2
		dc.l TextOptScr_Clackers
		dc.l TextOptScr_RHS
		dc.l TextOptScr_Socket
		dc.l TextOptScr_Cringe
		dc.l TextOptScr_Dark		
off_92DE:
		dc.l TextOptScr_Default
		dc.l TextOptScr_Original
		dc.l TextOptScr_Beta
		dc.l TextOptScr_Midnight
		dc.l TextOptScr_C2
		dc.l TextOptScr_Clackers
		dc.l TextOptScr_RHS
		dc.l TextOptScr_Socket
		dc.l TextOptScr_Cringe
		dc.l TextOptScr_Dark	
off_92EA:
		dc.l TextOptScr_On
		dc.l TextOptScr_Off
off_92F2:
		dc.l TextOptScr_Null
		dc.l TextOptScr_Null2
; ===========================================================================

TextOptScr_PlayerSelect:	asc	"* PALETTE PICKER *"	; byte_97CA:
TextOptScr_Default:			asc	"    DEFAULT      "	; byte_97FC:
TextOptScr_Original:			asc	"    ORIGINAL   "	; byte_980C:
TextOptScr_Beta:			asc	"     DEMO     "	; byte_981C:
TextOptScr_Midnight:			asc	"   MIDNIGHT    "
TextOptScr_C2:			asc	"   CLASSIC      "
TextOptScr_Clackers:			asc	"   CRACKERS     "
TextOptScr_RHS:			asc	"  REDHOTSONIC   "
TextOptScr_Socket:			asc	"    SOCKET    "
TextOptScr_Cringe:			asc	"    CRINGE    "
TextOptScr_Dark:			asc	"    DARKER    "
TextOptScr_LivesSystem:		asc	"*   SCD CAMERA   *"	; byte_982C:
TextOptScr_On:				asc	"    DISABLED     "	; byte_984E:
TextOptScr_Off:				asc	"    ENABLED    "	; byte_984E:
TextOptScr_SoundTest:		asc	"* NEW MOVESTYLES *"	; byte_985E:
TextOptScr_Null:				asc	"FINISH THE GAME"	; byte_9870:
TextOptScr_Null2:				asc	"      NULLS       "	; byte_9870:
; ============================================================================

Sonic_Miles_Spr:incbin  "artunc/Sonic and Miles text.bin"
		even
Eni_MenuBg:    incbin    "tilemaps/menubgeni.bin"
		even
Nem_MenuFont:    incbin    "artnem/Standard font.bin"
		even
Nem_MenuBox:    incbin   "artnem/Menu Box.bin"
		even
Eni_MenuBox:    incbin    "tilemaps/menuboxeni.bin"
		even