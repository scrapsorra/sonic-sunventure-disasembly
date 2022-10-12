; ---------------------------------------------------------------------------
; HUD code - SCORE, TIME, RINGS (ported from Sonic 2)
; ---------------------------------------------------------------------------

BuildHUD:
		moveq	#0,d1
		btst	#3,(v_framebyte).w
		bne.s	@dontblink					; only blink on certain frames
		tst.w	(v_rings).w
		bne.s	@skiprings					; if yes, skip to time
		addq.w	#1,d1			; set mapping frame for ring count blink
	
	@skiprings:
		cmpi.b	#9,(v_timemin).w			; have 9 minutes elapsed?
		bne.s	@dontblink					; if not, branch
		addq.w	#2,d1						; set mapping frame time counter blink
	
	@dontblink:
		move.w	#$90,d3
		move.w	#$108,d2
		lea		(Map_HUD).l,a1
		movea.w	#$6CA,a3		;	load frame
		add.w	d1,d1
		adda.w	(a1,d1.w),a1				; load frame
		move.b	(a1)+,d1					; load # of pieces in frame
		subq.w	#1,d1
		bmi.s	@end
		jsr		BuildSpr_Normal			; draw frame
	
	@end:
		rts