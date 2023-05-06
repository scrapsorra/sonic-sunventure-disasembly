; ---------------------------------------------------------------------------
; Object 0F - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------

PSBTM:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	PSB_Index(pc,d0.w),d1
		jsr	PSB_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
PSB_Index:	dc.w PSB_Main-PSB_Index
		dc.w PSB_PrsStart-PSB_Index
		dc.w PSB_Exit-PSB_Index
		dc.w PSB_Menu-PSB_Index		
; ===========================================================================

PSB_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$D0,obX(a0)
		move.w	#$130,obScreenY(a0)
		move.l	#Map_PSB,obMap(a0)
		move.w	#$200,obGfx(a0)
		cmpi.b	#2,obFrame(a0)	; is object "PRESS START"?
		bcs.s	PSB_PrsStart	; if yes, branch

		addq.b	#2,obRoutine(a0)
		cmpi.b	#3,obFrame(a0)	; is the object	"TM"?
		bne.s	PSB_Exit	; if not, branch

		move.w	#$2780,obGfx(a0) ; "TM" specific code
		move.w	#$170,obX(a0)
		move.w	#$F8,obScreenY(a0)

PSB_Exit:	; Routine 4
		rts	
; ===========================================================================

PSB_PrsStart:	; Routine 2
		btst   #7,(v_jpadpress1).w   ; check if Start is pressed
		beq.s   PSB_PrsStart_Show   ; if not, branch
		addq.b   #4,obRoutine(a0)      ; go to Menu in next frame
		move.w   #$56F,obGfx(a0)
		move.l   #Map_TitleMenu,obMap(a0) 
		move.w	#$F8,obX(a0)
		move.w	#$150,obScreenY(a0)
		move.w	#$A1,d0 
		jmp	PlaySound_Special

PSB_PrsStart_Show:
		lea	(Ani_PSBTM).l,a1
		bra.w	AnimateSprite	; "PRESS START" is animated

PSB_Menu:
      moveq   #0,d2
      move.b   (Title_screen_option).w,d2
      move.b   (v_jpadpress1).w,d0
      btst   #0,d0
      beq.s   MAIN2
      subq.b   #1,d2
      bcc.s   MAIN2
      move.b   #1,d2

MAIN2:
      btst   #1,d0
      beq.s   MAIN3
      addq.b   #1,d2
      cmpi.b   #2,d2
      blo.s   MAIN3
      moveq   #0,d2

MAIN3:
      move.b   d2,$1A(a0)
      move.b   d2,(Title_screen_option).w
      andi.b   #3,d0
      beq.s   MAIN4   
      move.w   #$CD,d0 ; selection blip sound
      jsr   PlaySound_Special

MAIN4:
      btst   #7,(v_jpadpress1).w   ; check if Start is pressed
      beq.s   MENURTS   ; if not, branch
      jmp   DeleteObject   ; if yes, delete the Title Screen Menu

MENURTS:
      rts															 
; ===========================================================================


Map_TitleMenu:
		include "_maps\Title Screen Menu.asm"		