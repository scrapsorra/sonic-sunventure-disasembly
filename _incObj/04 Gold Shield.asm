; ---------------------------------------------------------------------------
; Object 07 - red shield
; ---------------------------------------------------------------------------

GShieldItem:
		move.l #Unc_GShield,d1 ; Call for Red Shield Art
		move.w #$A820,d2 ; Load Art from this location (VRAM location*20)
		; In this case, VRAM = $541*20
		move.w #$200,d3
		jsr (QueueDMATransfer).l
; ---------------------------------------------------------------------------
GShieldObj_Main:
		moveq #0,d0
		move.b $24(a0),d0
		move.w GShield_Index(pc,d0.w),d1
		jmp GShield_Index(pc,d1.w)
; ===========================================================================
GShield_Index:
		dc.w GShield_Init-GShield_Index
		dc.w GShieldChecks-GShield_Index
; ===========================================================================
GShield_Init:
		addq.b #2,$24(a0)
		move.l #Map_Shield,$4(A0) ; Load Shield Map into place
		move.b #4,1(a0)
		move.b #1,$18(a0)
		move.b #$18,$19(a0)
		move.w #$541,2(a0) ; Set VRAM location
		btst #7,($FFFFD002).w
		beq.s GShieldChecks
		bset #7,2(a0)
; ---------------------------------------------------------------------------
GShieldChecks:
		tst.b ($FFFFFE2D).w ; Test if Sonic has a shield
		bne.s GSonicHasShield ; If so, branch to do nothing
		tst.b (v_GShield).w ; Test if Sonic got invisibility
		beq.s Gjmp_DeleteObj38 ; If so, delete object temporarily
GShieldProperties:
		move.w ($FFFFD008).w,8(a0) ; Load Main Character X-position
		move.w ($FFFFD00C).w,$C(a0) ; Load Main Character Y-position
		move.b ($FFFFD022).w,$22(a0) ; Something about Character status
		lea (Ani_Shield).l, a1 ; Load Animation Scripts into a1
		jsr AnimateSprite
		jmp DisplaySprite
GSonicHasShield:
		rts
Gjmp_DeleteObj38: ; loc_12648:
		jmp DeleteObject