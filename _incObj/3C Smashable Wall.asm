; ---------------------------------------------------------------------------
; Object 3C - smashable	wall (GHZ, SLZ)
; ---------------------------------------------------------------------------

SmashWall:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Smash_Index(pc,d0.w),d1
		jsr	Smash_Index(pc,d1.w)
		bra.w	RememberState
; ===========================================================================
Smash_Index:	dc.w Smash_Main-Smash_Index
		dc.w Smash_Solid-Smash_Index
		dc.w Smash_FragMove-Smash_Index

smash_speed:	equ $30		; Sonic's horizontal speed
; ===========================================================================

Smash_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Smash,obMap(a0)
		move.w	#$450F,obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$10,obActWid(a0)
		move.w	#$200,obPriority(a0)
		move.b	obSubtype(a0),obFrame(a0)

Smash_Solid:	; Routine 2
		move.w	(v_player+obVelX).w,smash_speed(a0) ; load Sonic's horizontal speed
		move.w	#$1B,d1
		move.w	#$20,d2
		move.w	#$20,d3
		move.w	obX(a0),d4
		bsr.w	SolidObject	
		tst.b	d4
		bgt.w	@chkroll	
		beq.w	@donothing								
		btst	#5,obStatus(a0)	; is Sonic pushing against the wall?
		beq.w	@donothing	; if yes, branch
; ===========================================================================

@chkroll:
		cmpi.b	#id_Roll,obAnim(a1) ; is Sonic rolling?
		bne.s	@donothing	; if not, branch	
		move.w	smash_speed(a0),d0
		bpl.s	@chkspeed
		neg.w	d0

	@chkspeed:
		cmpi.w	#$480,d0	; is Sonic's speed $480 or higher?
		bcs.s	@donothing	; if not, branch	
		
	@continue:	
		bclr	#5,obStatus(a0)
		move.w	smash_speed(a0),obVelX(a1)
		lea	(Smash_FragSpd1).l,a4 ;	use fragments that move	right
		move.w	obX(a0),d0
		cmp.w	obX(a1),d0	; is Sonic to the right	of the block?
		bcs.s	@smash		; if yes, branch
		lea	(Smash_FragSpd2).l,a4 ;	use fragments that move	left

	@smash:
		move.w	obVelX(a1),obInertia(a1)
		bclr	#5,obStatus(a1)
		moveq	#6,d1		; load 7 fragments
		move.w	#$70,d2
		bsr.s	SmashObject

@donothing:
		rts	

Smash_FragMove:	; Routine 4
		addq.l	#4,sp
		bsr.w	SpeedToPos
		addi.w	#$70,obVelY(a0)	; make fragment	fall faster
		tst.b	obRender(a0)
		bpl.w	DeleteObject
		bra.w	DisplaySprite

