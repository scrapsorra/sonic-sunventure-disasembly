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


		lea	($FFFFAC00).w,a1
		moveq	#$00,d0
		move.w	#$07FF*2+$FF,d1

MenuScreen_ClrObjRam:
		move.l	d0,(a1)+
		dbf		d1,MenuScreen_ClrObjRam

; ===========================================================================

		clr.w	($FFFFDC00).w
		move.l	#$FFFFDC00,($FFFFDCFC).w
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
		tst.b	($FFFFFFF7).w		; is menu option?
		beq.w	MenuScreen_Options	; if yes, branch

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
		clr.b	($FFFFF5CC).w
		bsr.w	OptionScreen_DrawSelected
		addq.b	#1,($FFFFF5CC).w
		bsr.w	OptionScreen_DrawUnselected
		addq.b	#1,($FFFFF5CC).w
		bsr.w	OptionScreen_DrawUnselected
		clr.b	($FFFFF5CC).w
		clr.w	(v_scroll_block_1_size).w
		clr.w	($FFFFF7F0).w					 
;-------------------------------------------------------------------------------
		move.l	#$0000,(v_lani4_frame).w
		bsr.w	Dynamic_Menu
;-------------------------------------------------------------------------------
		moveq	#palid_Options,d0
		jsr		PalLoad1
		;music	mus_CharacterSelect
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
		move	#$2700,sr
		bsr.w	OptionScreen_DrawUnselected
		bsr.w	OptionScreen_Controls
		bsr.w	OptionScreen_DrawSelected
		move	#$2300,sr
		bsr.w	Dynamic_Menu
		move.b	(v_jpadpress1).w,d0
		andi.b	#$80,d0	; is Start button pressed?
		bne.s	OptionScreen_Select		; if yes, branch
		bra.s	OptionScreen_Main
; ===========================================================================
; loc_909A:
OptionScreen_Select:
		move.b	($FFFFF5CC).w,d0
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
		move.b	($FFFFF5CC).w,d2
		move.b	(v_jpadpress1).w,d0		; Ctrl_1_Press
		andi.b	#0,d0			; is up pressed?
		beq.s	Option_Controls_Down	; if not, branch
		subq.b	#1,d2					; move up 1 selection
		bcc.s	Option_Controls_Down
		move.b	#2,d2

Option_Controls_Down:
		andi.b	#1,d0			; is down pressed?
		beq.s	Option_Controls_Refresh	; if not, branch
		addq.b	#1,d2					; move down 1 selection
		cmpi.b	#3,d2
		blo.s	Option_Controls_Refresh
		moveq	#0,d2

Option_Controls_Refresh:
		move.b	d2,($FFFFF5CC).w
		lsl.w	#2,d2
		move.b	OptionScreen_Choices(pc,d2.w),d3 ; number of choices for the option
		movea.l	OptionScreen_Choices(pc,d2.w),a1 ; location where the choice is stored (in RAM)
		move.w	(a1),d2
		andi.b	#2,d0				; is left pressed?
		beq.s	Option_Controls_Right		; if not, branch
		subq.b	#1,d2						; subtract 1 from sound test
		bcc.s	Option_Controls_Right
		move.b	d3,d2

Option_Controls_Right:
		andi.b	#3,d0			; is right pressed?
		beq.s	Option_Controls_Button_A	; if not, branch
		addq.b	#1,d2						; add 1 to sound test
		cmp.b	d3,d2
		bls.s	Option_Controls_Button_A
		moveq	#0,d2

Option_Controls_Button_A:
		andi.b	#6,d0				; is button A pressed?
		beq.s	Option_Controls_Refresh2	; if not, branch
		addi.b	#$10,d2						; add $10 to sound test
		cmp.b	d3,d2
		bls.s	Option_Controls_Refresh2
		moveq	#0,d2

Option_Controls_Refresh2:
		move.w	d2,(a1)
		cmpi.b	#2,($FFFFF5CC).w
		bne.s	Option_Controls_NoMove	; rts
		andi.w	#$10+$20,d0	; B or C pressed?
		beq.s	Option_Controls_NoMove	; if not, branch
		move.w	(v_levselsound).w,d0	; get sound selected
		addi.w	#$80,d0					; add $80 to sound selected
		jmp		PlaySound

Option_Controls_NoMove:
		rts
; End of function OptionScreen_Controls

; ===========================================================================
; word_917A:
OptionScreen_Choices:
		dc.l (1-1)<<24|($FFFF8A&$FFFFFF)
		dc.l (1-1)<<24|($FFFFBE&$FFFFFF)
		dc.l ($7F)<<24|($FFFF84&$FFFFFF)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


OptionScreen_DrawSelected:
		bsr.w	loc_9268
		moveq	#0,d1
		move.b	($FFFFF5CC).w,d1
		lsl.w	#3,d1
		lea	(OptScrBoxData).l,a3
		lea	(a3,d1.w),a3
		move.w	#$6000,d0
		lea	($FFFF0030).l,a2
		movea.l	(a3)+,a1
		bsr.w	MenuScreenTextToRAM
		lea	($FFFF00B6).l,a2
		moveq	#0,d1
		cmpi.b	#2,($FFFFF5CC).w
		beq.s	loc_9186
		move.b	($FFFFF5CC).w,d1
		lsl.w	#2,d1
		lea	OptionScreen_Choices(pc),a1
		movea.l	(a1,d1.w),a1
		move.w	(a1),d1
		lsl.w	#2,d1

loc_9186:
		movea.l	(a4,d1.w),a1
		bsr.w	MenuScreenTextToRAM
		cmpi.b	#2,($FFFFF5CC).w
		bne.s	loc2_9186
		lea	($FFFF00C2).l,a2
		bsr.w	loc_9296

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
		move.b	($FFFFF5CC).w,d1
		lsl.w	#3,d1
		lea	(OptScrBoxData).l,a3
		lea	(a3,d1.w),a3
		moveq	#0,d0
		lea	($FFFF0190).l,a2
		movea.l	(a3)+,a1
		bsr.w	MenuScreenTextToRAM
		lea	($FFFF0216).l,a2
		moveq	#0,d1
		cmpi.b	#2,($FFFFF5CC).w
		beq.s	loc2_91F8
		move.b	($FFFFF5CC).w,d1
		lsl.w	#2,d1
		lea	OptionScreen_Choices(pc),a1
		movea.l	(a1,d1.w),a1
		move.w	(a1),d1
		lsl.w	#2,d1

loc2_91F8
		movea.l	(a4,d1.w),a1
		bsr.w	MenuScreenTextToRAM
		cmpi.b	#2,($FFFFF5CC).w
		bne.s	loc3_91F8
		lea	($FFFF0222).l,a2
		bsr.w	loc_9296

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
		tst.b	($FFFFF5CC).w
		beq.s	loc3_9268
		lea	(off_92EA).l,a4

loc3_9268:
		cmpi.b	#2,($FFFFF5CC).w
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
		dc.l TextOptScr_0
; ===========================================================================

TextOptScr_PlayerSelect:	asc	"* PLAYER SELECT *"	; byte_97CA:
TextOptScr_Sonic:			asc	"SONIC          "	; byte_97FC:
TextOptScr_Miles:			asc	"MILES          "	; byte_980C:
TextOptScr_Tails:			asc	"TAILS          "	; byte_981C:
TextOptScr_Knux:			asc "KNUCKLES       "
TextOptScr_LivesSystem:		asc	"* 	  TEST	    *"	; byte_982C:
TextOptScr_On:				asc	"      ON       "	; byte_984E:
TextOptScr_Off:				asc	"      OFF      "	; byte_984E:
TextOptScr_SoundTest:		asc	"*  SOUND TEST   *"	; byte_985E:
TextOptScr_0:				asc	"      00       "	; byte_9870:

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