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

		clr.w	($FFFFC800).w
		move.l	#$FFFFC800,($FFFFC8FC).w
		move.l	#$42000000,(vdp_control_port).l
		lea		(Nem_MenuFont).l,a0
		jsr	NemDec
		move.l	#$4E000000,(vdp_control_port).l
		lea		(Nem_MenuBox).l,a0
		jsr	NemDec
		lea		(v_256x256),a1
		lea		(Eni_MenuBg),a0
		move.w	#$6000,d0
		jsr	EniDec
		lea		(v_256x256),a1
		move.l	#$60000003,d0
		moveq	#$27,d1
		moveq	#$1B,d2
		jsr	TilemapToVRAM	; fullscreen background
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
		clr.l ($FFFFF7B8).w ; clear RAM adresses $F7B8 to $F7BA
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
		bsr.w	Dynamic_Menu
		move.b	(v_jpadpress1).w,d0
		andi.b	#-$80,d0 ; check if Start is pressed
		bne.s	OptionScreen_Select		; if yes, branch
		bra.s	OptionScreen_Main
; ===========================================================================
; loc_909A:
OptionScreen_Select:
		move.b	(Options_menu_box).w,d0
		bne.s	OptionScreen_Select_Not1P
		moveq	#0,d0
		move.w	d0,($FFFFFE10).w	; green_hill_zone_act_1
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
	move.b	(v_jpadpress1).w,d0
	btst	#0,d0
	beq.s	@cont
	subq.b	#1,d2	; Up 1 box
	bcc.s	@cont
	move.b	#2,d2	; if you go below 0, wrap back to 2

@cont:
	btst	#1,d0
	beq.s	@cont2
	addq.b	#1,d2	; down 1 box
	cmpi.b	#3,d2	; if you go above 2,
	blo.s	@cont2
	moveq	#0,d2	; wrap back around to 0

@cont2:
	move.b	d2,(Options_menu_box).w
	lsl.w	#2,d2
	move.b	OptionScreen_Choices(pc,d2.w),d3 ; number of choices for the option
	movea.l	OptionScreen_Choices(pc,d2.w),a1 ; location where the choice is stored (in RAM)
	move.w	(a1),d2
	btst	#2,d0
	beq.s	@cont3	; didn't press Left
	subq.b	#1,d2	; subtract 1
	bcc.s	@cont3	; wrap back around...? (branch carry clear...)
	move.b	d3,d2	; move d3 to d2. wait, this is the number of choices for the option. so, this is wrapping back around?

@cont3:
	btst	#3,d0
	beq.s	@cont4
	addq.b	#1,d2
	cmp.b	d3,d2
	bls.s	@cont4
	moveq	#0,d2

@cont4:
	btst	#6,d0
	beq.s	@cont5
	addi.b	#$10,d2
	cmp.b	d3,d2
	bls.s	@cont5
	moveq	#0,d2

@cont5:
		rts
; End of function OptionScreen_Controls

; ===========================================================================
; word_917A:
OptionScreen_Choices:
		dc.l (3-1)<<24|($FFFF8A&$FFFFFF)
		dc.l (2-1)<<24|($FFFFBE&$FFFFFF)
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
		movea.l	(a4,d1.w),a1
		bsr.w	MenuScreenTextToRAM
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
		movea.l	(a4,d1.w),a1
		bsr.w	MenuScreenTextToRAM
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
		move.w	(v_levselsound).w,d1
		move.b	d1,d2
		lsr.b	#4,d1
		bsr.s	loc2_9296
		move.b	d2,d1

loc2_9296:
		andi.w	#$F,d1
		cmpi.b	#$A,d1
		blo.s	loc3_9296
		addi.b	#4,d1

loc3_9296:
		addi.b	#$10,d1
		move.b	d1,d0
		move.w	d0,(a2)+
		rts

Dynamic_Menu:
		subq.b  #$01, (v_lani4_time).w
		bpl.s   Exit_Dinamic_Menu
		move.b  #$07, (v_lani4_time).w
		move.b  (v_lani4_frame).w, D0
		addq.b  #$01, (v_lani4_frame).w
		andi.w  #$001F, D0
		move.b  Sonic_Miles_Frame_Select(PC, D0), D0
		lsl.w   #$06, D0
		lea     (vdp_data_port), A6
		move.l  #$40200000, $0004(A6)
		lea     (Sonic_Miles_Spr), A1
		lea     $00(A1, D0), A1
		move.w  #$0009, D0
Menu_Loop_Load_Tiles:
		move.l  (A1)+, (A6)
		move.l  (A1)+, (A6)
		move.l  (A1)+, (A6)
		move.l  (A1)+, (A6)
		move.l  (A1)+, (A6)
		move.l  (A1)+, (A6)
		move.l  (A1)+, (A6)
		move.l  (A1)+, (A6)
		dbra    D0, Menu_Loop_Load_Tiles
Exit_Dinamic_Menu:
				rts
Sonic_Miles_Frame_Select:
				dc.b    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
				dc.b    $05, $0A
				dc.b    $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
				dc.b    $0A, $05
				; 0 = 0000000000  ; 1 = 0101000000  ; 2 = 1010000000 ; 3 = 1111000000
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
		dc.l TextOptScr_Sonic
		dc.l TextOptScr_Miles
		dc.l TextOptScr_Knux
off_92DE:
		dc.l TextOptScr_Sonic
		dc.l TextOptScr_Tails
		dc.l TextOptScr_Knux
off_92EA:
		dc.l TextOptScr_On
		dc.l TextOptScr_Off
off_92F2:
		dc.l TextOptScr_Null
		dc.l TextOptScr_Null2
; ===========================================================================

TextOptScr_PlayerSelect:	asc	"* PLAYER SELECT *"	; byte_97CA:
TextOptScr_Sonic:			asc	"SONIC          "	; byte_97FC:
TextOptScr_Miles:			asc	"MILES          "	; byte_980C:
TextOptScr_Tails:			asc	"TAILS          "	; byte_981C:
TextOptScr_Knux:			asc "KNUCKLES       "
TextOptScr_LivesSystem:		asc	"*EXTENDED CAMERA*"	; byte_982C:
TextOptScr_On:				asc	"      OFF       "	; byte_984E:
TextOptScr_Off:				asc	"      ON      "	; byte_984E:
TextOptScr_SoundTest:		asc	"*    MOVESET    *"	; byte_985E:
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