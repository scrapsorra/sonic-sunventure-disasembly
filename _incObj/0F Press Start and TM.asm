; ---------------------------------------------------------------------------
; Object 0F - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------

PSBTM:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Obj0F_Index(pc,d0.w),d1
		jsr	Obj0F_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Obj0F_Index:	dc.w Obj0F_Init-Obj0F_Index	
		dc.w Obj0F_Main-Obj0F_Index
		dc.w MENURTS-Obj0F_Index	
; ===========================================================================
Obj0F_Init:
	addq.b	#2,obRoutine(a0) ; => Obj0F_Main
    move.l   #Map_TitleMenu,4(a0)
    move.w   #$101,8(a0)
    move.w   #$151,$A(a0)
	move.w	#$56F,2(a0)
	andi.b	#1,(Title_screen_option).w
	move.b	(Title_screen_option).w,mapping_frame(a0)


Obj0F_Main:
      moveq   #0,d2
      move.b   (Title_screen_option).w,d2
      move.b   ($FFFFF605).w,d0
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
      beq.s   MENURTS   ; rts
      move.w   #$CD,d0 ; selection blip sound
      jsr   PlaySound_Special

MENURTS:
      rts															 
; ===========================================================================

Map_TitleMenu:
		include "_maps\Title Screen Menu.asm"		