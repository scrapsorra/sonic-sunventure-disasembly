; ---------------------------------------------------------------------------
; Object 07 - red shield
; ---------------------------------------------------------------------------

RShieldItem:
		move.l #Unc_RedShield,d1 ; Call for Red Shield Art
		move.w #$A820,d2 ; Load Art from this location (VRAM location*20)
		; In this case, VRAM = $541*20
		move.w #$200,d3
		jsr (QueueDMATransfer).l
; ---------------------------------------------------------------------------
RShieldObj_Main:
		moveq #0,d0
		move.b $24(a0),d0
		move.w RShield_Index(pc,d0.w),d1
		jmp RShield_Index(pc,d1.w)
; ===========================================================================
RShield_Index:
		dc.w RShield_Init-RShield_Index
		dc.w RShieldChecks-RShield_Index
; ===========================================================================
RShield_Init:
		addq.b #2,$24(a0)
		move.l #Map_Shield,$4(A0) ; Load Shield Map into place
		move.b #4,1(a0)
		move.w #$80,$18(a0)
		move.b #$18,obActWid(a0)
		move.w #$541,2(a0) ; Set VRAM location
		btst #7,($FFFFD002).w
		beq.s RShieldChecks
		bset #7,2(a0)
; ---------------------------------------------------------------------------
RShieldChecks:
		tst.b ($FFFFFE2D).w ; Test if Sonic has a shield
		bne.s RSonicHasShield ; If so, branch to do nothing
		tst.b (v_rshield).w ; Test if Sonic got invisibility
		beq.s Rjmp_DeleteObj38 ; If so, delete object temporarily
RShieldProperties:
		move.w ($FFFFD008).w,8(a0) ; Load Main Character X-position
		move.w ($FFFFD00C).w,$C(a0) ; Load Main Character Y-position
		move.b ($FFFFD022).w,$22(a0) ; Something about Character status
		lea (Ani_Shield).l, a1 ; Load Animation Scripts into a1
		jsr AnimateSprite
		jmp DisplaySprite
RSonicHasShield:
		rts
Rjmp_DeleteObj38: ; loc_12648:
		jmp DeleteObject