; ---------------------------------------------------------------------------
; Object 19 - Invincibility Stars
; ---------------------------------------------------------------------------

InvStarsObj:
		move.l #Unc_Stars,d1
		move.w #$A820,d2
		move.w #$200,d3
		jsr (QueueDMATransfer).l
Invincibility_Main:
		moveq #0,d0
		move.b $24(a0),d0
Invincibility_Init:
		addq.b #2,$24(a0)
		move.l #Map_Shield,4(a0) ; loads mapping
		move.b #4,1(a0)
		move.w #$80,$18(a0)
		move.b #$10,obActWid(a0)
		move.w #$541,2(a0) ; shield specific code
; ===========================================================================

Obj19_Stars: ; XREF: Obj38_Index
		tst.b ($FFFFFE2D).w ; does Sonic have invincibility?
		beq.s Obj19_Delete2 ; if not, branch
		move.w ($FFFFF7A8).w,d0
		move.b $1C(a0),d1
		subq.b #1,d1
		bra.s Obj19_StarTrail
; ===========================================================================
		lsl.b #4,d1
		addq.b #4,d1
		sub.b d1,d0
		move.b $30(a0),d1
		sub.b d1,d0
		addq.b #4,d1
		andi.b #$F,d1
		move.b d1,$30(a0)
		bra.s Obj19_StarTrail2a
; ===========================================================================

Obj19_StarTrail: ; XREF: Obj19_Stars
		lsl.b #3,d1
		move.b d1,d2
		add.b d1,d1
		add.b d2,d1
		addq.b #4,d1
		sub.b d1,d0
		move.b $30(a0),d1
		sub.b d1,d0
		addq.b #4,d1
		cmpi.b #$18,d1
		bcs.s Obj19_StarTrail2
		moveq #0,d1

Obj19_StarTrail2:
		move.b d1,$30(a0)

Obj19_StarTrail2a:
		lea ($FFFFCB00).w,a1
		lea (a1,d0.w),a1
		move.w (a1)+,8(a0)
		move.w (a1)+,$C(a0)
		move.b ($FFFFD022).w,$22(a0)
		lea (Ani_Shield).l,a1
		jsr (AnimateSprite).l
		jmp (DisplaySprite).l
; ===========================================================================

Obj19_Delete2: ; XREF: Obj19_Stars
		jmp (DeleteObject).l