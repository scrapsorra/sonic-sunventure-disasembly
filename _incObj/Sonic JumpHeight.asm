; ---------------------------------------------------------------------------
; Subroutine controlling Sonic's jump height/duration
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_JumpHeight:
		tst.b	$3C(a0)
		beq.s	loc_134C4
		move.w	#-$400,d1
		btst	#6,obStatus(a0)
		beq.s	loc_134AE
		move.w	#-$200,d1

loc_134AE:
		cmp.w	obVelY(a0),d1
		ble.s	locret_134C2
		move.b	(v_jpadhold2).w,d0
		andi.b	#btnABC,d0	; is A, B or C pressed?
		bne.s	locret_134C2	; if yes, branch
		move.w	d1,obVelY(a0)

locret_134C2:
        tst.b   (f_lockmulti).w      ; Are Controls locked?
        bne.s   locret_134C2            ; If so, branch, and do not bother with Super code
        move.b  (v_jpadpress2).w,d0
        andi.b  #btnB,d0 ; is a jump button pressed?
		bne.w	Sonic_CheckGoSuper
		rts	
; ===========================================================================

loc_134C4:
		cmpi.w	#-$FC0,obVelY(a0)
		bge.s	locret_134D2
		move.w	#-$FC0,obVelY(a0)

locret_134D2:		
		rts	
; End of function Sonic_JumpHeight


; ---------------------------------------------------------------------------
; Subroutine called at the peak of a jump that transforms Sonic into Super Sonic
; if he has enough rings and emeralds
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

Sonic_CheckGoSuper:
		tst.b	(Super_Sonic_flag).w	; is Sonic already Super?
		bne.w	Sonic_RevertToNormal			; if yes, branch	
		cmpi.w	#50,(v_rings).w	; does Sonic have at least 50 rings?
		bcs.s	return_1ABA4		; if not, branch	
		move.b	#1,(Super_Sonic_palette).w
		move.b	#$F,(Palette_timer).w
		move.b	#1,(Super_Sonic_flag).w
		clr.b	(v_shoes).w ; clear speed shoes
		move.b    #$1,(f_lockmulti).w
		move.b    #id_Transform,obAnim(a0)   
		jsr		Super_and_Invincibility_Stars				
		move.b	#id_SuperStars,($FFFFD200).w				
		move.w	#$A00,(v_sonspeedmax).w
		move.w	#$30,(v_sonspeedacc).w
		move.w	#$100,(v_sonspeeddec).w
		move.w	#0,invtime(a0)
		move.b #1,(v_invinc).w ; make Sonic invincible	
		move.w	#$D6,d0         ; 
		jsr	(PlaySound_Special).l	; Play transformation sound effect.
		move.w	#$87,d0         
		jmp	(PlaySound).l	; load the invincibility song and return also playmusic doesn't exist

; ---------------------------------------------------------------------------
return_1ABA4:
		rts
		
; End of subroutine Sonic_CheckGoSuper		
; ---------------------------------------------------------------------------
; Subroutine doing the extra logic for Super Sonic
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1ABA6:
Sonic_Super:
		tst.b	(Super_Sonic_flag).w	; Ignore all this code if not Super Sonic
		beq.w	return_1AC3C
		tst.b	(f_timecount).w
		beq.s	Sonic_RevertToNormal ; ?
		subq.w	#1,(v_pal_buffer+$20).w
		bpl.w	return_1AC3C
		move.w	#60,(v_pal_buffer+$20).w	; Reset frame counter to 60
		tst.w	(v_rings).w
		beq.s	Sonic_RevertToNormal
		ori.b	#1,(f_ringcount).w
		cmpi.w	#1,(v_rings).w
		beq.s	@update
		cmpi.w	#10,(v_rings).w
		beq.s	@update
		cmpi.w	#100,(v_rings).w
		bne.s	@update2
@update
		ori.b	#$80,(f_ringcount).w
@update2
		subq.w	#1,(v_rings).w
		bne.s	return_1AC3C
; loc_1ABF2:
Sonic_RevertToNormal:
		clr.b   (f_lockmulti).w
		move.b	#2,(Super_Sonic_palette).w	; Remove rotating palette
		move.w	#$28,($FFFFF5CC).w	; Unknown
		move.b	#0,(Super_Sonic_flag).w
		move.b    #0,(f_lockmulti).w	
		move.w	#1,invtime(a0)				
		move.b	#1,next_anim(a0)	; Change animation back to normal ?
		clr.b	($FFFFD200).w	; clear Obj7E (super sonic stars object) at $FFFFD200		
		clr.b 	(v_invinc).w
		clr.b 	(v_shoes).w 
		move.b  (v_Saved_music),d0    ; loads song number from RAM
		jsr		(PlaySound).l    ; play normal music		
		move.w	#$600,(v_sonspeedmax).w
		move.w	#$C,(v_sonspeedacc).w
		move.w	#$80,(v_sonspeeddec).w
		btst	#6,obStatus(a0)	; Check if underwater, return if not
		beq.s	return_1AC3C
		move.w	#$300,(v_sonspeedmax).w
		move.w	#6,(v_sonspeedacc).w
		move.w	#$40,(v_sonspeeddec).w
		
return_1AC3C:
		rts
; End of subroutine Sonic_Super	


; ---------------------------------------------------------------------------
; Subroutine to	delete the Super Stars and the Invincibility Stars
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Super_and_Invincibility_Stars:
		clr.w	($FFFFD032).w		; clear time limit of the invincibility
		move.l	a0,-(sp)
		lea		($FFFFD200).w,a0	; stars object ($3801 and $8F)
		jsr		DeleteObject		; delete stars
		lea		($FFFFD240).w,a0	; stars object ($3802)
		jsr		DeleteObject		; delete stars
		lea		($FFFFD280).w,a0	; stars object ($3803)
		jsr		DeleteObject		; delete stars
		lea		($FFFFD2C0).w,a0	; stars object ($3804)
		jsr		DeleteObject		; delete stars
		move.l	(sp)+,a0
		rts
; End of function Super_and_Invincibility_Stars