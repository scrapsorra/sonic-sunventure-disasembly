; ---------------------------------------------------------------------------
; Subroutine to make Sonic perform a peelout
; ---------------------------------------------------------------------------
; If you use this makes sure to search for ;Peelout in Sonic1.asm
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

Sonic_Peelout:
		btst	#1,$39(a0)
		bne.s	SCDPeelout_Launch
		cmpi.b	#7,$1C(a0) ;check to see if your looking up
		bne.s	@return
		move.b	($FFFFF603).w,d0
		andi.b	#%01110000,d0
		beq.w	@return
		move.b	#1,$1C(a0)
		move.w	#0,$3A(a0)
		move.w	#$D2,d0
		jsr	(PlaySound_Special).l 		; Play peelout charge sound
	;	sfx 	sfx_PeeloutCharge 		; These are if you use AMPS
		addq.l	#4,sp
		bset	#1,$39(a0)
		
		clr.w	obInertia(a0)
 
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_AnglePos
 
	@return:
		rts	
; ---------------------------------------------------------------------------
 
SCDPeelout_Launch:
		btst	#1,$39(a0)
		move.b	($FFFFF602).w,d0
		btst	#0,d0
		bne.w	SCDPeelout_Charge
		bclr	#1,$39(a0)	; stop Dashing
		cmpi.b	#$1E,$3A(a0)	; have we been charging long enough?
		bne.w	SCDPeelout_Stop_Sound
		move.b	#0,$1C(a0)	; launches here (peelout sprites)
		move.w	#1,$10(a0)	; force X speed to nonzero for camera lag's benefit
		move.w	obInertia(a0),d0
		subi.w	#$800,d0
		add.w	d0,d0
		andi.w	#$1F00,d0
		neg.w	d0
		addi.w	#$2000,d0
		move.w	d0,($FFFFC904).w
		btst	#0,$22(a0)
		beq.s	@dontflip
		neg.w	obInertia(a0)
 
@dontflip:
		bclr	#7,$22(a0)
		move.w	#$D3,d0
		jsr	(PlaySound_Special).l
	;	sfx 	sfx_PeeloutRelease
		move.b	obAngle(a0),d0
		jsr	(CalcSine).l
		muls.w	obInertia(a0),d1
		asr.l	#8,d1
		move.w	d1,obVelX(a0)
		muls.w	obInertia(a0),d0
		asr.l	#8,d0
		move.w	d0,obVelY(a0)	
		bra.w	SCDPeelout_ResetScr
; ---------------------------------------------------------------------------
 
SCDPeelout_Charge:				; If still charging the dash...
		move.w	($FFFFF760).w,d1	; get top peelout speed
		move.w	d1,d2
		add.w	d1,d1
		tst.b   ($FFFFFE2E).w 		; test for speed shoes
		beq.s	@noshoes
		asr.w	#1,d2
		sub.w	d2,d1

@noshoes:
		addi.w	#$64,obInertia(a0)		; increment speed
		cmp.w	obInertia(a0),d1
		bgt.s	@inctimer
		move.w	d1,obInertia(a0)

@inctimer:
		addq.b	#1,$3A(a0)		; increment timer
		cmpi.b	#$1E,$3A(a0)
		bcs.s	SCDPeelout_ResetScr
		move.b	#$1E,$3A(a0)
		jmp 	SCDPeelout_ResetScr
		
SCDPeelout_Stop_Sound:
		move.w	#$D4,d0
		jsr		(PlaySound_Special).l
	;	sfx 	sfx_PeeloutStop
		clr.w	obInertia(a0)

SCDPeelout_ResetScr:
		addq.l	#4,sp			; increase stack ptr ; was 4
		cmpi.w	#$60,($FFFFF73E).w
		beq.s	@finish
		bcc.s	@skip
		addq.w	#4,($FFFFF73E).w
 
	@skip:
		subq.w	#2,($FFFFF73E).w
 
	@finish:
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_AnglePos
		rts
		