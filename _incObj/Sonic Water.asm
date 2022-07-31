; ---------------------------------------------------------------------------
; Subroutine for Sonic when he's underwater
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Water:
		cmpi.b	#5,(v_zone).w	;TIS is level MZ?
		beq.s	WaterTagforMZ	; if yes, branch
		cmpi.b	#1,(v_zone).w	; is level LZ?
		beq.s	Sonic_Water_LZ	; if yes, branch

	Sonic_Water_Exit:
		rts	
; ===========================================================================

	Sonic_Water_LZ:
		move.w	(v_waterpos1).w,d0
		cmp.w	obY(a0),d0	; is Sonic above the water?
		bge.w	Abovewater	; if yes, branch
		bra	WaterStatus
	WaterTagforMZ:
		cmpi.b	#0,(v_tagwater).w	;TIS Lava Tag?
		beq.w	Abovewater	; if yes, branch
		move.w #$F,d0             ;TIS Length ($F = full line)
		lea    (Pal_LZSonWatr2),a1  ;Palette location
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
		asr	obVelX(a0)
		asr	obVelY(a0)
		asr	obVelY(a0)	; slow Sonic
		beq.w	Sonic_Water_Exit		; branch if Sonic stops moving
		;move.w	(v_player+obY).w,(v_watersplashpos).w	;TIS copy y-pos
		move.b	#id_Splash,(v_objspace+$300).w ; load splash object
		sfx	sfx_Splash,1,0,0	 ; play splash sound
		cmpi.b	#0,(v_tagwater).w	;TIS Lava Tag?
		bne.w	@return
		
		
	@return:
		rts
; ===========================================================================

Abovewater:
		move.w	#$F,d0             ;TIS Length ($F = full line)
		lea    (Pal_Sonic),a1  ;Palette location
        	lea    ($FFFFFB00),a2        ;RAM location ($FB00 = line 1)
		jsr	Palload_Loop

		bclr	#6,obStatus(a0)
		beq.w	Sonic_Water_Exit
		bsr.w	ResumeMusic
		move.w	(v_player+obY).w,(v_watersplashpos).w	;TIS copy y-pos

		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; restore Sonic's deceleration
		asl	obVelY(a0)
		beq.w	Sonic_Water_Exit
		move.b	#id_Splash,(v_objspace+$300).w ; load splash object
		cmpi.w	#-$1000,obVelY(a0)
		bgt.s	@belowmaxspeed
		move.w	#-$1000,obVelY(a0) ; set maximum speed on leaving water

	@belowmaxspeed:
		sfx	sfx_Splash,1,0,0	 ; play splash sound
; End of function Sonic_Water