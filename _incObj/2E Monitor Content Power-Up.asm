; ---------------------------------------------------------------------------
; Object 2E - contents of monitors
; ---------------------------------------------------------------------------

PowerUp:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Pow_Index(pc,d0.w),d1
		jsr	Pow_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Pow_Index:	dc.w Pow_Main-Pow_Index
		dc.w Pow_Move-Pow_Index
		dc.w Pow_Delete-Pow_Index
; ===========================================================================

Pow_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.w	#$680,obGfx(a0)
		move.b	#$24,obRender(a0)
		move.w	#$180,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.w	#-$300,obVelY(a0)
		moveq	#0,d0
		move.b	obAnim(a0),d0	; get subtype
		addq.b	#2,d0
		move.b	d0,obFrame(a0)	; use correct frame
		movea.l	#Map_Monitor,a1
		add.b	d0,d0
		adda.w	(a1,d0.w),a1
		addq.w	#1,a1
		move.l	a1,obMap(a0)

Pow_Move:	; Routine 2
		tst.w	obVelY(a0)	; is object moving?
		bpl.w	Pow_Checks	; if not, branch
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)	; reduce object	speed
		rts	
; ===========================================================================

Pow_Checks:
		addq.b	#2,obRoutine(a0)
		move.w	#29,obTimeFrame(a0) ; display icon for half a second

Pow_ChkEggman:
		move.b	obAnim(a0),d0
		cmpi.b	#1,d0		; does monitor contain Eggman?
		bne.s	Pow_ChkSonic
		
		jmp	Spik_Hurt
		
		rts
; ===========================================================================

Pow_ChkSonic:
		cmpi.b	#2,d0		; does monitor contain Sonic?
		bne.s	Pow_ChkShoes

	ExtraLife:
		addq.b	#1,(v_lives).w	; add 1 to the number of lives you have
		addq.b	#1,(f_lifecount).w ; update the lives counter
		music	bgm_ExtraLife,1,0,0	; play extra life music

; ===========================================================================

Pow_ChkShoes:
		cmpi.b	#3,d0		; does monitor contain speed shoes?
		bne.s	Pow_ChkShield
		cmpi.b #1,(Super_Sonic_Flag).w ; Prevent Sonic from getting (invincibility, shoes) if Super
		beq 	Pow_NoMus
		move.b	#1,(v_shoes).w	; speed up the BG music
		move.w	#$4B0,(v_player+$34).w	; time limit for the power-up
		move.w	#$C00,(v_sonspeedmax).w ; change Sonic's top speed
		move.w	#$18,(v_sonspeedacc).w	; change Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w	; change Sonic's deceleration
		tst.b	(f_lockscreen).w ; is boss mode on?
		bne.s	Pow_NoMus	; if yes, branch
		if Revision=0
		else
			cmpi.w	#$C,(v_air).w
			bls.s	Pow_NoMus
		endc
		music	bgm_Ending,1,0,0 ; play speed shoes music
; ===========================================================================

Pow_NoMus:
		rts	
; ===========================================================================

Pow_ChkShield:
        cmpi.b    #4,d0        ; does monitor contain a shield?
        bne.s    Pow_ChkInvinc

        move.b    #1,(v_shield).w    ; give Sonic a shield
		move.b	#0,(v_rshield).w ; remove red shield
		move.b	#0,(v_gshield).w ; remove g shield
		move.b	#0,(v_spshield).w ; remove s shield
        move.b    #id_ShieldItem,(v_objspace+$180).w ; load shield object ($38)
        clr.b    (v_objspace+$180+obRoutine).w
        move.w    #sfx_Shield,d0
        jmp    (PlaySound_Special).l    ; play shield sound
; ===========================================================================

Pow_ChkInvinc:
		cmpi.b	#5,d0		; does monitor contain invincibility?
		bne.s	Pow_ChkRings
		cmpi.b #1,(Super_Sonic_Flag).w ; Prevent Sonic from getting (invincibility, shoes) if Super
		beq 	Pow_NoMusic
		move.b	#1,(v_invinc).w	; make Sonic invincible
		move.w	#$560,(v_player+$32).w ; time limit for the power-up
		move.b	#id_InvStars,(v_objspace+$200).w ; load stars object ($3801)
		move.b	#1,(v_objspace+$200+obAnim).w
		move.b	#id_InvStars,(v_objspace+$240).w ; load stars object ($3802)
		move.b	#2,(v_objspace+$240+obAnim).w
		move.b	#id_InvStars,(v_objspace+$280).w ; load stars object ($3803)
		move.b	#3,(v_objspace+$280+obAnim).w
		move.b	#id_InvStars,(v_objspace+$2C0).w ; load stars object ($3804)
		move.b	#4,(v_objspace+$2C0+obAnim).w
		tst.b	(f_lockscreen).w ; is boss mode on?
		bne.s	Pow_NoMusic	; if yes, branch
		if Revision=0
		else
			cmpi.w	#$C,(v_air).w
			bls.s	Pow_NoMusic
		endc
		music	bgm_Invincible,1,0,0 ; play invincibility music
; ===========================================================================

Pow_NoMusic:
		rts	
; ===========================================================================

Pow_ChkRings:
		cmpi.b	#6,d0		; does monitor contain 10 rings?
		bne.s	Pow_ChkS

		addi.w	#10,(v_rings).w	; add 10 rings to the number of rings you have
		ori.b	#1,(f_ringcount).w ; update the ring counter
		cmpi.w	#100,(v_rings).w ; check if you have 100 rings
		bcs.s	Pow_RingSound
		bset	#1,(v_lifecount).w
		beq.w	ExtraLife
		cmpi.w	#200,(v_rings).w ; check if you have 200 rings
		bcs.s	Pow_RingSound
		bset	#2,(v_lifecount).w
		beq.w	ExtraLife

	Pow_RingSound:
		music	sfx_Ring,1,0,0	; play ring sound
; ===========================================================================

Pow_ChkS:
		cmpi.b	#7,d0		; does monitor contain 'S'?
		bne.s	Pow_ChkSRing

		cmpi.b	#6,(v_emeralds).w ; do you have all the emeralds?
		beq.s	PowS2	; if yes, branch
		subi.b	#$3B,d4
		moveq	#0,d0
		move.b	#0,(f_emeraldm).w
		move.b	#1,(f_emeraldm).w
		bra.s	PowSPlay

PowS2:
		addi.w	#50,(v_rings).w	; add 50 rings to the number of rings you have
		move.b	#0,(f_emeraldm).w
		ori.b	#5,(f_ringcount).w ; update the ring counter
		cmpi.w	#100,(v_rings).w ; check if you have 100 rings
		bcs.s	PowSPlay
		bset	#1,(v_lifecount).w
		beq.w	ExtraLife
		cmpi.w	#200,(v_rings).w ; check if you have 200 rings
		bcs.s	PowSPlay
		bset	#2,(v_lifecount).w
		beq.w	ExtraLife	

PowSPlay:
		jsr	WhiteFlash
		sfx	sfx_GiantRing,1,0,0	; play giant ring sound

		


Pow_ChkSRing:
		cmpi.b	#8,d0		; does monitor contain 'S'?
		bne.s	Pow_ChkRShield

		
		addi.w	#20,(v_rings).w	; add 20 rings to the number of rings you have
		ori.b	#2,(f_ringcount).w ; update the ring counter
		cmpi.w	#100,(v_rings).w ; check if you have 100 rings
		bcs.s	Pow_ChkSRingSound
		bset	#1,(v_lifecount).w
		beq.w	ExtraLife
		cmpi.w	#200,(v_rings).w ; check if you have 200 rings
		bcs.s	Pow_ChkSRingSound
		bset	#2,(v_lifecount).w
		beq.w	ExtraLife	

Pow_ChkSRingSound:
		sfx	sfx_LRingBox,1,0,0	; play cash register sound


Pow_ChkRShield:
        cmpi.b    #10,d0        ; does monitor contain a shield?
        bne.s    Pow_ChkGShield

        move.b    #2,(v_rshield).w    ; give Sonic a shield
		move.b	#0,(v_shield).w ; remove red shield
		move.b	#0,(v_gshield).w ; remove g shield
		move.b	#0,(v_spshield).w ; remove s shield
        move.b    #id_RShieldItem,(v_objspace+$180).w ; load shield object ($38)
        clr.b    (v_objspace+$180+obRoutine).w
        move.w    #sfx_FireShield,d0
        jmp    (PlaySound_Special).l    ; play shield sound

Pow_ChkGShield:
        cmpi.b    #11,d0        ; does monitor contain a shield?
        bne.s    Pow_ChkSpShield

        move.b    #1,(v_gshield).w    ; give Sonic a shield
		move.b	#0,(v_shield).w ; remove red shield
		move.b	#0,(v_rshield).w ; remove g shield
		move.b	#0,(v_spshield).w ; remove s shield
        move.b    #id_GShieldItem,(v_objspace+$180).w ; load shield object ($38)
        clr.b    (v_objspace+$180+obRoutine).w
        move.w    #sfx_LightningShield,d0
        jmp    (PlaySound_Special).l    ; play shield sound

Pow_ChkSpShield:
       cmpi.b    #12,d0        ; does monitor contain a shield?
        bne.s    Pow_ChkSpShield

        move.b    #1,(v_spshield).w    ; give Sonic a shield
		move.b	#0,(v_shield).w ; remove red shield
		move.b	#0,(v_rshield).w ; remove g shield
		move.b	#0,(v_gshield).w ; remove s shield
        move.b    #id_SpShieldItem,(v_objspace+$180).w ; load shield object ($38)
        clr.b    (v_objspace+$180+obRoutine).w
        move.w    #sfx_SpikesMove,d0
        jmp    (PlaySound_Special).l    ; play shield sound

Pow_ChkEnd:
		rts
; ===========================================================================

Pow_Delete:	; Routine 4
		subq.w	#1,obTimeFrame(a0)
		bmi.w	DeleteObject	; delete after half a second
		rts	
