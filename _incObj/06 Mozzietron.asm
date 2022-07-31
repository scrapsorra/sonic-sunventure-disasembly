; ===========================================================================
; ---------------------------------------------------------------------------
; Object 06 - Mozzietron enemy	(GHZ)
; ---------------------------------------------------------------------------

Mozzietron:					; XREF: Obj_Index
		moveq	#0,d0
		move.b	$24(a0),d0
		move.w	MozIndex(pc,d0.w),d1
		jmp	MozIndex(pc,d1.w)
; ===========================================================================
MozIndex:	dc.w MozMain-MozIndex
		dc.w MozAction-MozIndex
		dc.w MozDelete-MozIndex
; ===========================================================================

MozMain:				; XREF: MozIndex
		addq.b	#2,$24(a0)
		move.l	#Map_Mozzietron,4(a0)
		move.w	#$444,2(a0)
		move.b	#4,1(a0)
		move.b	#3,$18(a0)
		move.b	#5,$20(a0) ; hit box
		move.b	#$18,$19(a0)
MozAction:				; XREF: MozIndex
		moveq	#0,d0
		move.b	$25(a0),d0
		move.w	MozIndex2(pc,d0.w),d1
		jsr	MozIndex2(pc,d1.w)
		lea	(Ani_Mozzietron).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
MozIndex2:	dc.w MozMove-MozIndex2
		dc.w MozChkNrSonic-MozIndex2
		dc.w MozPinned-MozIndex2
; ===========================================================================

MozMove:				; XREF: MozIndex2
		subq.w	#1,$32(a0)	; subtract 1 from time delay
		bpl.s	locret_986C	; if time remains, branch
		btst	#1,$34(a0)	; is Buzz Bomber near Sonic?
		bne.s	MozFire	; if yes, branch
		addq.b	#2,$25(a0)
		move.w	#100,$32(a0)	; set time delay to just over 2	seconds
		move.w	#$100,$10(a0)	; move Buzz Bomber to the right
		move.b	#0,$1C(a0)	; use "flying" animation
		btst	#0,$22(a0)	; is Buzz Bomber facing	left?
		bne.s	locret_986C	; if not, branch
		neg.w	$10(a0)		; move Buzz Bomber to the left

locret_986C:
		rts	
; ===========================================================================

MozFire:				; XREF: MozMove
		move.b	#2,$1C(a0)	; use "diving" animation
		bsr.w	ObjectFall
		jsr     ObjFloorDist ; check distance between object and floor
		tst.w	d1 ; is floor distance positive? 
		bpl.s   @return ; if yes, branch 
		move.w    #$B6,d0
		jsr    (PlaySound_Special).l ;    play "spikes moving" sound
		move.b #4,$25(a0) ; set 2nd state to pinned
		add.w	d1,$C(a0) ; snap to the ground
		clr.w	$12(a0) ; clear Y Velocity 
		clr.b	$15(a0) ; $15(a0) is unused in this object, except this line
		@return:
	    		rts
		

; ===========================================================================

MozPinned:
        rts
        
; ===========================================================================

MozChkDel:				; XREF: Obj55_DropFly
		tst.b	1(a0)
		bpl.w	DeleteObject
		rts	
; ===========================================================================

MozChkNrSonic:			; XREF: MozIndex2
;		subq.w	#1,$32(a0)	; subtract 1 from time delay
		bmi.s	MozChgDir
		bsr.w	SpeedToPos
		tst.b	$34(a0)
		bne.s	locret_992A
		move.w	($FFFFD008).w,d0
		sub.w	8(a0),d0
		bpl.s	MozSetNrSonic
		neg.w	d0

MozSetNrSonic:
		cmpi.w	#$05,d0		; is Buzz Bomber within	$05 pixels of Sonic?
		bcc.s	locret_992A	; if not, branch
		tst.b	1(a0)
		bpl.s	locret_992A
		move.b	#2,$34(a0)	; set Buzz Bomber to "near Sonic"
		move.w	#29,$32(a0)	; set time delay to half a second
		move.b	#2,$1C(a0)	; use "firing" animation
		bra.s	MozStop
; ===========================================================================

MozChgDir:				; XREF: MozChkNrSonic
		move.b	#0,$34(a0)	; set Buzz Bomber to "normal"
		bchg	#0,$22(a0)	; change direction
		move.w	#59,$32(a0)

MozStop:				; XREF: MozSetNrSonic
		subq.b	#2,$25(a0)	; run "MozFire" routine
		move.w	#0,$10(a0)	; stop Buzz Bomber moving
		move.b	#0,$1C(a0)	; use "hovering" animation

locret_992A:
		rts	
; ===========================================================================

MozDelete:				; XREF: MozIndex
		bsr.w	DeleteObject
		rts	
