; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Water:
		cmpi.b	#id_LZ,(v_zone).w	;TIS is level LZ?
		bne.s	WaterTagforMZ	; if no, branch
		cmpi.b	#id_LZ,(v_zone).w	; is level LZ?
		beq.s	Sonic_Water_LZ	; if yes, branch

	Sonic_Water_Exit:
		rts
; ===========================================================================
LoadGFXLUTWat:	;TIS Water Palette List
        dc.l	Pal_SBZ3SonWat,Pal_SonWater2,Pal_SonWater3,Pal_SonWater4,Pal_SonWater5,Pal_SonWater6,Pal_SonWater7,Pal_SonWater8,Pal_SonWater9,Pal_SonWater10,Pal_SonWater11	

; ===========================================================================

	Sonic_Water_LZ:
		move.w	(v_waterpos1).w,d0
		cmp.w	obY(a0),d0	; is Sonic above the water?
		bge.w	Abovewater	; if yes, branch
		bra	WaterStatus
	WaterTagforMZ:
		cmpi.b	#0,(v_tagwater).w	;TIS
		beq.w	Abovewater	; if yes, branch
		
		moveq	#0,d0
		move.b	($FFFFFFBF).w,d0
        add.w    d0,d0
        add.w    d0,d0
		movea.l    loadGFXLUTWat(pc,d0.w),a1  ;Load a separate list for water palettes
		move.w #$7,d0             ;TIS Length ($F = full line)
		;lea    (Pal_LZSonWatr2),a1  ;Palette location
    	lea    ($FFFFFB00),a2        ;RAM location ($FB00 = line 1)
		jsr	Palload_Loop
	WaterStatus:
		bset	#6,obStatus(a0)
		bne.w	Sonic_Water_Exit
		bsr.w	ResumeMusic
		move.w	(v_player+obY).w,(v_watersplashpos).w	;TIS copy y-pos
		move.b	#id_DrownCount,(v_objspace+$340).w ; load bubbles object from Sonic's mouth
		move.b	#$81,(v_objspace+$340+obSubtype).w
		move.w	#$300,(v_sonspeedmax).w ; change Sonic's top speed
		move.w	#6,(v_sonspeedacc).w ; change Sonic's acceleration
		move.w	#$40,(v_sonspeeddec).w ; change Sonic's deceleration
		tst.b	(Super_Sonic_flag).w	; Is Sonic Super?
		beq.s	@Skip			; If not branch
		move.w	#$500,(v_sonspeedmax).w
		move.w	#$18,(v_sonspeedacc).w
		move.w	#$80,(v_sonspeeddec).w
@Skip		
		asr	obVelX(a0)
		asr	obVelY(a0)
		asr	obVelY(a0)	; slow Sonic
		beq.w	Sonic_Water_Exit		; branch if Sonic stops moving
		;move.w	(v_player+obY).w,(v_watersplashpos).w	;TIS copy y-pos
        	move.w    #$100,($FFFFD1DC).w    ; set the spin dash dust animation to splash
		sfx	sfx_Splash,1,0,0	 ; play splash sound
		cmpi.b	#0,(v_tagwater).w	;TIS 
		bne.w	@return
		
		
	@return:
		rts

; ===========================================================================

LoadGFXLUT:	;TIS Dry Palette List
        dc.l   Pal_Sonic,Pal_Sonic2,Pal_Sonic3,Pal_Sonic4,Pal_Sonic5,Pal_Sonic6,Pal_Sonic7,Pal_Sonic8,Pal_Sonic8,Pal_Sonic9,Pal_Sonic10,Pal_Sonic11

; ===========================================================================

Abovewater:
		moveq	#0,d0
		move.b	($FFFFFFBF).w,d0
		add.w    d0,d0
        add.w    d0,d0
		movea.l    loadGFXLUT(pc,d0.w),a1  ;Load a separate list for palettes

		move.w #$7,d0             ;TIS Length ($F = full line)
		;lea    (Pal_Sonic),a1  ;Palette location
		lea    ($FFFFFB00),a2        ;RAM location ($FB00 = line 1)
		jsr	Palload_Loop
		bclr	#6,obStatus(a0)
		beq.w	Sonic_Water_Exit
		bsr.w	ResumeMusic
		move.w	(v_player+obY).w,(v_watersplashpos).w	;TIS copy y-pos

		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; restore Sonic's deceleration
		tst.b	(Super_Sonic_flag).w	; Is Sonic Super?
		beq.s	@Skip			; If not branch
		move.w	#$A00,(v_sonspeedmax).w
		move.w	#$30,(v_sonspeedacc).w
		move.w	#$100,(v_sonspeeddec).w
@Skip		
		asl	obVelY(a0)
		beq.w	Sonic_Water_Exit
        move.w    #$100,($FFFFD1DC).w    ; set the spin dash dust animation to splash
		cmpi.w	#-$1000,obVelY(a0)
		bgt.s	@belowmaxspeed
		move.w	#-$1000,obVelY(a0) ; set maximum speed on leaving water

	@belowmaxspeed:
		sfx	sfx_Splash,1,0,0	 ; play splash sound
; End of function Sonic_Water

