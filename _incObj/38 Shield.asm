; ---------------------------------------------------------------------------
; Object 38 - Shield
; ---------------------------------------------------------------------------
ShieldItem: ; XREF: Obj_Index
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	ShieldItem_Index(pc,d0.w),d1
		jmp	ShieldItem_Index(pc,d1.w)
; ===========================================================================
; off_1D900:
ShieldItem_Index:
		dc.w ShieldItem_Init-ShieldItem_Index	; 0
		dc.w ShieldItem_Main-ShieldItem_Index	; 2
; ===========================================================================
; loc_1D904:
ShieldItem_Init:
		move.l	#Map_Shield,obMap(a0)
		move.l	#DPLC_Shield,shield_DPLC_Address(a0)	; Used by PLCLoad_Shields
		move.l	#Art_Shield,shield_Art_Address(a0)	; Used by PLCLoad_Shields
		move.b	#4,obRender(a0)
		move.w	#$80,obPriority(a0)
		move.b	#$18,obActWid(a0)
		move.w	#$541,obGfx(a0)
		move.w	#$A820,shield_vram_art(a0)	; Used by PLCLoad_Shields
		btst	#7,(v_player+obGfx).w
		beq.s	loc_195F0S
		bset	#7,obGfx(a0)

loc_195F0S:
		move.w	#1,obAnim(a0)	; Clear anim and set prev_anim to 1
		move.b	#-1,shield_LastLoadedDPLC(a0)	; Reset LastLoadedDPLC (used by PLCLoad_Shields)
		addq.b	#2,obRoutine(a0) ; => ShieldItem_Main
; loc_1D92C:
ShieldItem_Main:
		lea	(v_player).w,a2 ; a2=character
		tst.b	(v_invinc).w
		bne.s	return_1D976
		;cmpi.b	#id_Null,obAnim(a2)	; Is player in their 'blank' animation?
		;beq.s	return_1D976	; If so, do not display and do not update variables
		tst.b	(v_shield).w
		beq.w	ShieldItem_Destroy	; If not, change to Insta-Shield
		move.w	obX(a2),obX(a0)
		move.w	obY(a2),obY(a0)
		andi.w	#$7FFF,obGFX(a0)
		tst.w	obGFX(a2)
		bpl.s	@nothighpriority
		ori.w	#$8000,obGFX(a0)

		@nothighpriority:
		lea	(Ani_Shield).l,a1
		jsr	(AnimateSprite).l
		jsr	(PLCLoad_Shields).l
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
; ===========================================================================

return_1D976:
		rts

ShieldItem_Destroy:
		clr.b	(v_shield).w		; remove shield				
		rts
; ===========================================================================