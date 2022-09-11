; ---------------------------------------------------------------------------
; Subroutine to display Sonic and set music
; ---------------------------------------------------------------------------

Sonic_Display:
		move.w    flashtime(a0),d0
		beq.s    @showAfterImage
		subq.w    #1,flashtime(a0)
        	lsr.w    #3,d0
        	bcc.s    @chkinvincible

	@showAfterImage:
        	move.w    obInertia(a0),d0            ; get inertia
		tst.w    d0                    ; is inertia greater than 0?
		bge.s    @AfterImage_Start    ; if yes, don't negate it
		neg        d0                    ; if not, negate it

	@AfterImage_Start:        
		tst.b	(v_shoes).w	; does Sonic have speed	shoes?
		beq.s	@display	; if not, don't show the After Image
		;cmpi.w    #$900,d0	; is the sonic inertia greater than A00?
		;blt.s    @display	; if not, don't show the After Image
	
	@AfterImage_Start2:    
        	bsr.w    FindFreeObj    ; search a free space in object RAM
        	bne.s    @display    ; if not have, don't load the After Image
        	move.b  #$10,0(a1)        ; load after-image object
        	move.l    obMap(a0),obMap(a1)        ; copy Sonic mappings to after-image mappings
        	move.w    obX(a0),obX(a1)        ; copy Sonic x-pos to after-image x-pos
        	move.w    obY(a0),obY(a1)    ; copy Sonic y-pos to after-image y-pos

    	@display:
        	jsr    (DisplaySprite).l

	@chkinvincible:
		tst.b	(v_invinc).w	; does Sonic have invincibility?
		beq.s	@chkshoes	; if not, branch
		tst.w	invtime(a0)	; check	time remaining for invinciblity
		beq.s	@chkshoes	; if no	time remains, branch
		subq.w	#1,invtime(a0)	; subtract 1 from time
		bne.s	@chkshoes
		tst.b	(f_lockscreen).w
		bne.s	@removeinvincible
		cmpi.w	#$C,(v_air).w
		bcs.s	@removeinvincible	
		cmpi.b	#$1,(f_lockscreen).w	
		beq.b	@removeinvincible				
		move.b  (v_Saved_music),d0    ; loads song number from RAM
        	jsr	(PlaySound).l    ; play normal music

	@removeinvincible:
		move.b	#0,(v_invinc).w ; cancel invincibility

	@chkshoes:
		tst.b	(v_shoes).w	; does Sonic have speed	shoes?
		beq.s	@exit		; if not, branch
		tst.w	shoetime(a0)	; check	time remaining
		beq.s	@exit
		subq.w	#1,shoetime(a0)	; subtract 1 from time
		bne.s	@exit
		move.w	#$600,(v_sonspeedmax).w ; restore Sonic's speed
		move.w	#$C,(v_sonspeedacc).w ; restore Sonic's acceleration
		move.w	#$80,(v_sonspeeddec).w ; restore Sonic's deceleration
		move.b	#0,(v_shoes).w	; cancel speed shoes
		cmpi.b	#$1,(f_lockscreen).w	
		beq.b	@exit		
		move.b  (v_Saved_music),d0    ; loads song number from RAM
        	jsr	(PlaySound).l    ; play normal music
		
	@exit:
		rts	