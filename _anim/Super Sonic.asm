; ---------------------------------------------------------------------------
; Animation script - Super Sonic
; ---------------------------------------------------------------------------
Ani_SuperSonic:

ptr_SuperWalk:	dc.w SuperSonAni_Walk-Ani_SuperSonic
ptr_SuperRun:	dc.w SuperSonAni_Run-Ani_SuperSonic
ptr_SuperRoll:	dc.w SuperSonAni_Roll-Ani_Sonic
ptr_SuperRoll2:	dc.w SuperSonAni_Roll2-Ani_Sonic
ptr_SuperPush:	dc.w SuperSonAni_Push-Ani_SuperSonic
ptr_SuperWait:	dc.w SuperSonAni_Wait-Ani_SuperSonic
ptr_SuperBalance:	dc.w SuperSonAni_Balance-Ani_SuperSonic
ptr_SuperLookUp:	dc.w SuperSonAni_LookUp-Ani_SuperSonic
ptr_SuperDuck:	dc.w SuperSonAni_Duck-Ani_SuperSonic
ptr_SuperWarp1:	dc.w SuperSonAni_Warp1-Ani_Sonic
ptr_SuperWarp2:	dc.w SuperSonAni_Warp2-Ani_Sonic
ptr_SuperWarp3:	dc.w SuperSonAni_Warp3-Ani_Sonic
ptr_SuperWarp4:	dc.w SuperSonAni_Warp4-Ani_Sonic
ptr_SuperStop:	dc.w SuperSonAni_Stop-Ani_SuperSonic
ptr_SuperFloat1:	dc.w SuperSonAni_Float1-Ani_SuperSonic
ptr_SuperFloat2:	dc.w SuperSonAni_Float2-Ani_SuperSonic
ptr_SuperSpring:	dc.w SuperSonAni_Spring-Ani_SuperSonic
ptr_SuperHang:	dc.w SuperSonAni_Hang-Ani_SuperSonic
ptr_SuperLeap1:	dc.w SuperSonAni_Leap1-Ani_Sonic
ptr_SuperLeap2:	dc.w SuperSonAni_Leap2-Ani_Sonic
ptr_SuperSurf:	dc.w SuperSonAni_Surf-Ani_SuperSonic
ptr_SuperGetAir:	dc.w SuperSonAni_GetAir-Ani_SuperSonic
ptr_SuperBurnt:	dc.w SuperSonAni_Burnt-Ani_Sonic
ptr_SuperDrown:	dc.w SuperSonAni_Drown-Ani_Sonic
ptr_SuperDeath:	dc.w SuperSonAni_Death-Ani_Sonic
ptr_SuperHurt:	dc.w SuperSonAni_Hurt-Ani_Sonic
ptr_SuperWaterSlide:	dc.w SuperSonAni_WaterSlide-Ani_Sonic
ptr_SuperNull:	dc.w SuperSonAni_Null-Ani_Sonic
ptr_SuperFloat3:	dc.w SuperSonAni_Float3-Ani_SuperSonic
ptr_SuperFloat4:	dc.w SuperSonAni_Float4-Ani_SuperSonic
ptr_SuperMaxRun:	dc.w SuperSonAni_MaxRun-Ani_SuperSonic
ptr_SuperSpindash:	dc.w SuperSonAni_SpinDash-Ani_Sonic ;1F
ptr_SuperHurt2:	dc.w SuperSonAni_Hurt2-Ani_Sonic
ptr_SuperGetUp:	dc.w SuperSonAni_GetUp-Ani_Sonic
ptr_SuperBlink:	dc.w SuperSonAni_Blink-Ani_SuperSonic
ptr_SuperSit:	dc.w SuperSonAni_Sit-Ani_Sonic
ptr_SuperPeelout:	dc.w SuperSonAni_Peelout-Ani_SuperSonic
ptr_SuperHang2:	dc.w SuperSonAni_Hang2-Ani_SuperSonic
ptr_SuperTransform:	dc.w SuperSonAni_Transform-Ani_SuperSonic

SuperSonAni_Walk:	dc.b $FF, fr_walk13, fr_walk14,	fr_walk15, fr_walk16, fr_walk17, fr_walk18, fr_walk11, fr_walk12, afEnd, afEnd, afEnd, afEnd
		even
SuperSonAni_Run:	dc.b $FF, fr_run11,  fr_run12,  fr_run13,  fr_run14, fr_run15,  fr_run16,  fr_run17,  fr_run18, afEnd, afEnd, afEnd, afEnd
		even
SuperSonAni_Roll:	dc.b $FE, fr_Roll1, fr_Roll6, fr_Roll2, fr_Roll7, fr_Roll3, fr_Roll5
		dc.b fr_Roll8, fr_Roll4, fr_Roll9, fr_Roll5, afEnd, afEnd
		even
SuperSonAni_Roll2:	dc.b $FE, fr_Roll1, fr_Roll6, fr_Roll2, fr_Roll7, fr_Roll3, fr_Roll5
		dc.b fr_Roll8, fr_Roll4, fr_Roll9, fr_Roll5, afEnd, afEnd
		even
SuperSonAni_Push:	dc.b $FD,  fr_push1,  fr_push2,  fr_push3,  fr_push4, fr_push5,  fr_push6,  fr_push7,  fr_push8, afEnd, afEnd, afEnd, afEnd
		even
SuperSonAni_Wait:	
		dc.b   5,  1,  1,  1,  1,  1,  1,  1,  1,  2,  1,  1,  1,  1,  1
		dc.b   1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  1,  1,  1,  1,  1
		dc.b   1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  1,  1,  1,  1,  1
		dc.b   2,  3,  3,  3,  4,  4,  5,  5,  5,  6,  6,  6,  7,  7,  7
		dc.b   6,  6,  6,  7,  7,  7,  6,  6,  6,  7,  7,  7,  6,  6,  6
		dc.b   7,  7,  7,  6,  6,  6,  7,  7,  7,  6,  6,  6,  7,  7,  7
		dc.b   6,  6,  6,  7,  7,  7,  6,  6,  6,  7,  7,  7,  6,  6,  6
		dc.b   7,  7,  7,  6,  6,  6,  7,  7,  7,  6,  6,  6,  7,  7,  7
		dc.b   8,  8,  9,  9,  $A, $A, $FE, 4
		even
SuperSonAni_Balance:	dc.b $F, fr_balance1, fr_balance2, fr_balance3, fr_balance4, afEnd
		even
SuperSonAni_LookUp:	dc.b $3, fr_lookup1, fr_lookup2, afBack, 1
		even
SuperSonAni_Duck:	dc.b $2, fr_duck2, fr_duck, afBack, 1
		even
SuperSonAni_Warp1:	dc.b $3F, fr_warp1, afEnd
		even
SuperSonAni_Warp2:	dc.b $3F, fr_warp2, afEnd
		even
SuperSonAni_Warp3:	dc.b $3F, fr_warp3, afEnd
		even
SuperSonAni_Warp4:	dc.b $3F, fr_warp4, afEnd
		even
SuperSonAni_Stop:	dc.b 2,	fr_stop1, fr_stop2, fr_stop2, fr_stop3, fr_stop3, fr_stop4, fr_stop4, $FD,  0
		even
SuperSonAni_Float1:	dc.b 7,	fr_float1, fr_float4, afBack, 2
		even
SuperSonAni_Float2:	dc.b 3,	fr_float1, fr_float7, fr_float2, fr_float8, fr_float5, fr_float3, fr_float6, afEnd
		even
SuperSonAni_Spring:	dc.b 7, fr_spring, fr_spring2, fr_spring, fr_spring2, fr_spring, fr_spring2, afChange, id_Walk
		even
SuperSonAni_Hang:	dc.b 4,	fr_hang1, fr_hang2, afEnd
		even
SuperSonAni_Leap1:	dc.b $F, fr_leap1, fr_leap1, fr_leap1,	afBack, 1
		even
SuperSonAni_Leap2:	dc.b $F, fr_leap1, fr_leap2, afBack, 1
		even
SuperSonAni_Surf:	dc.b $3F, fr_surf, afEnd
		even
SuperSonAni_GetAir:	dc.b $B, fr_getair, fr_getair, fr_walk15, fr_walk16, afChange, id_Walk
		even
SuperSonAni_Burnt:	dc.b $20, fr_burnt, afEnd
		even
SuperSonAni_Drown:	dc.b $2F, fr_drown, afEnd
		even
SuperSonAni_Death:	dc.b 3,	fr_death, afEnd
		even
SuperSonAni_Hurt:	dc.b 3,	fr_injury, afEnd
		even
SuperSonAni_WaterSlide:
		dc.b 7, fr_injury, fr_waterslide, afEnd
		even
SuperSonAni_Null:	dc.b $77, fr_null, afChange, id_Walk
		even
SuperSonAni_Float3:	dc.b 3,	fr_float1, fr_float2, fr_float5, fr_float3, fr_float6, afEnd
		even
SuperSonAni_Float4:	dc.b 3,	fr_float1, afChange, id_Walk
		even
SuperSonAni_MaxRun:  dc.b $FF, fr_peelout11, fr_peelout12, fr_peelout13, fr_peelout14, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
		even
SuperSonAni_SpinDash: dc.b 0, fr_Spindash1, fr_spindash2, fr_spindash1, fr_spindash3, fr_spindash1, fr_spindash4, fr_spindash1, fr_spindash5, fr_spindash1, fr_spindash6, afEnd
		even
SuperSonAni_Hurt2:	dc.b 2, fr_skele1, fr_injury, fr_skele2, afEnd	
		even
SuperSonAni_GetUp:	dc.b 3, $B,$FD,  0
		even
SuperSonAni_Blink:	dc.b   1,  2,$FD,  0
		even
SuperSonAni_Sit:	dc.b   8, 8, 9, 9, $A, $A,  9, $FE, 5
		even
SuperSonAni_Peelout: dc.b 	0, $E, $E, $E, $E, $E, $E, $F, $F
		dc.b	$F, $F, $10, $10, $11, $11, $12, $13
		dc.b	$14, $15, $2E, $2F, $30, $31, $32
		dc.b	$33, $34, $35
		dc.b	$4E, $4F, $50,  $51, -2, 4, $FE
		even
SuperSonAni_Hang2:	dc.b $13, fr_vhang3, fr_vhang1, fr_vhang2, fr_vhang1, $FF	
		even
SuperSonAni_Transform:
				dc.b 2, $A1,$A1,$A2,$A3,$A3,$A4,$A4,$A4,$A5
		dc.b	$A6,$A5,$A7,$A7,$A9,$A8,$A9,$A8,$A9,$A8, afchange, id_Walk
		even		