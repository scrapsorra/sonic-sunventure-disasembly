; ---------------------------------------------------------------------------
; Object 91 - Super Sonic Stars
; ---------------------------------------------------------------------------

SuperStars:					; XREF: Obj_Index					  ; ...
		move.l	#Unc_SuperSonic_stars,d1			        ; Call for Regular Shield Art
		move.w	#$ABC0,d2			        ; Load Art from this location (VRAM location*20)
								; In this case, VRAM = $541*20
		move.w	#$100,d3
		jsr	(QueueDMATransfer).l
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	SuperStars_States(pc,d0.w),d1
		jmp	SuperStars_States(pc,d1.w)
; ---------------------------------------------------------------------------
SuperStars_States:	dc.w SuperStars_Init-SuperStars_States,SuperStars_Main-SuperStars_States; 0	; ...
; ---------------------------------------------------------------------------

SuperStars_Init:					  ; ...
		addq.b	#2,obRoutine(a0)
		move.l	#SuperStars_MapUnc_1E1BE,4(a0)
		move.b	#4,obRender(a0)
		move.w	#$80,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.w	#$55E,art_tile(a0)
		btst	#7,(v_player+art_tile).w
		beq.s	SuperStars_Main
		bset	#7,art_tile(a0)
; loc_1E138:
SuperStars_Main:
		tst.b	(Super_Sonic_flag).w
		beq.s	JmpTo8_DeleteObject
		tst.b	$30(a0)
		beq.s	loc_1E188
		subq.b	#1,anim_frame_duration(a0)
		bpl.s	loc_1E170
		move.b	#1,anim_frame_duration(a0)
		addq.b	#1,mapping_frame(a0)
		cmpi.b	#6,mapping_frame(a0)
		bcs.s	loc_1E170
		move.b	#0,mapping_frame(a0)
		move.b	#0,$30(a0)
		move.b	#1,$31(a0)
		rts
; ===========================================================================

loc_1E170:
		tst.b	$31(a0)
		bne.s	JmpTo6_DisplaySprite

loc_1E176:
		move.w	(v_player+obX).w,obX(a0)
		move.w	(v_player+obY).w,obY(a0)

JmpTo6_DisplaySprite:
		jmp	DisplaySprite
; ===========================================================================

loc_1E188:
		tst.b	($FFFFF7C8).w
		bne.s	loc_1E1AA
		move.w	(v_player+obInertia).w,d0
		bpl.s	loc_1E196
		neg.w	d0

loc_1E196:
		cmpi.w	#$800,d0
		bcs.s	loc_1E1AA
		move.b	#0,mapping_frame(a0)
		move.b	#1,$30(a0)
		bra.s	loc_1E176
; ===========================================================================

loc_1E1AA:
		move.b	#0,$30(a0)
		move.b	#0,$31(a0)
		rts
; ===========================================================================

JmpTo8_DeleteObject:
		jmp	DeleteObject
; ===========================================================================

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
;Obj8F_MapUnc_1E1BE:
SuperStars_MapUnc_1E1BE:	include "_maps/Super Stars.asm"	

Unc_SuperSonic_stars:	incbin "artunc/Super Stars.bin"
			even