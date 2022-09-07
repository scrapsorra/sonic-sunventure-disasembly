; ---------------------------------------------------------------------------
; Object 38 - shield
; ---------------------------------------------------------------------------

ShieldItem:
		move.l #Unc_Shield,d1 ; Call for Regular Shield Art
		move.w #$A820,d2 ; Load Art from this location (VRAM location*20)
		; In this case, VRAM = $541*20
		move.w #$200,d3
		jsr (QueueDMATransfer).l
; ---------------------------------------------------------------------------
ShieldObj_Main:
		moveq #0,d0
		move.b $24(a0),d0
		move.w Shield_Index(pc,d0.w),d1
		jmp Shield_Index(pc,d1.w)
; ===========================================================================
Shield_Index:
		dc.w Shield_Init-Shield_Index
		dc.w ShieldChecks-Shield_Index
; ===========================================================================
Shield_Init:
		addq.b #2,$24(a0)
		move.l #Map_Shield2,$4(A0) ; Load Shield Map into place
		move.b #4,1(a0)
		move.w #$80,$18(a0)
		move.b #$18,obActWid(a0)
		move.w #$541,2(a0) ; Set VRAM location
		btst #7,($FFFFD002).w
		beq.s ShieldChecks
		bset #7,2(a0)
; ---------------------------------------------------------------------------
ShieldChecks:
		tst.b ($FFFFFE2D).w ; Test if Sonic has a shield
		bne.s SonicHasShield ; If so, branch to do nothing
		tst.b ($FFFFFE2C).w ; Test if Sonic got invisibility
		beq.s jmp_DeleteObj38 ; If so, delete object temporarily
ShieldProperties:
		move.w ($FFFFD008).w,8(a0) ; Load Main Character X-position
		move.w ($FFFFD00C).w,$C(a0) ; Load Main Character Y-position
		move.b ($FFFFD022).w,$22(a0) ; Something about Character status
		lea (Ani_Shield).l, a1 ; Load Animation Scripts into a1
		jsr AnimateSprite
		jmp DisplaySprite
SonicHasShield:
		rts
jmp_DeleteObj38: ; loc_12648:
		jmp DeleteObject
