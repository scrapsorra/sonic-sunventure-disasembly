; ---------------------------------------------------------------------------
; Subroutine to	make an	object fall downwards, increasingly fast
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ObjectFall:
		cmpi.b	#$50,obVelY(a0)
		beq.s	@donothing
		move.w	obVelX(a0),d0
		ext.l	d0
		lsl.l	#8,d0
		add.l	d0,obX(a0)
        cmp.w   #$FC8,obVelY(a0)   ; check if Sonic's Y speed is lower than this value
        ble.s   @skipline       ; if yes, branch
        move.w  #$FC8,obVelY(a0)    ; alter Sonic's Y speed
    @skipline:		
		move.w	obVelY(a0),d0
		addi.w	#$38,obVelY(a0)	; increase vertical speed
		ext.l	d0
		lsl.l	#8,d0
		add.l	d0,obY(a0)
		rts	
	
	@donothing:
		rts

; End of function ObjectFall