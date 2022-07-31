; ---------------------------------------------------------------------------
; Animation script - Sonic
; ---------------------------------------------------------------------------
Ani_Sonic:

ptr_Walk:	dc.w SonAni_Walk-Ani_Sonic
ptr_Run:	dc.w SonAni_Run-Ani_Sonic
ptr_Roll:	dc.w SonAni_Roll-Ani_Sonic
ptr_Roll2:	dc.w SonAni_Roll2-Ani_Sonic
ptr_Push:	dc.w SonAni_Push-Ani_Sonic
ptr_Wait:	dc.w SonAni_Wait-Ani_Sonic
ptr_Balance:	dc.w SonAni_Balance-Ani_Sonic
ptr_LookUp:	dc.w SonAni_LookUp-Ani_Sonic
ptr_Duck:	dc.w SonAni_Duck-Ani_Sonic
ptr_Warp1:	dc.w SonAni_Warp1-Ani_Sonic
ptr_Warp2:	dc.w SonAni_Warp2-Ani_Sonic
ptr_Warp3:	dc.w SonAni_Warp3-Ani_Sonic
ptr_Warp4:	dc.w SonAni_Warp4-Ani_Sonic
ptr_Stop:	dc.w SonAni_Stop-Ani_Sonic
ptr_Float1:	dc.w SonAni_Float1-Ani_Sonic
ptr_Float2:	dc.w SonAni_Float2-Ani_Sonic
ptr_Spring:	dc.w SonAni_Spring-Ani_Sonic
ptr_Hang:	dc.w SonAni_Hang-Ani_Sonic
ptr_Leap1:	dc.w SonAni_Leap1-Ani_Sonic
ptr_Leap2:	dc.w SonAni_Leap2-Ani_Sonic
ptr_Surf:	dc.w SonAni_Surf-Ani_Sonic
ptr_GetAir:	dc.w SonAni_GetAir-Ani_Sonic
ptr_Burnt:	dc.w SonAni_Burnt-Ani_Sonic
ptr_Drown:	dc.w SonAni_Drown-Ani_Sonic
ptr_Death:	dc.w SonAni_Death-Ani_Sonic
ptr_Hurt:	dc.w SonAni_Hurt-Ani_Sonic
ptr_WaterSlide:	dc.w SonAni_WaterSlide-Ani_Sonic
ptr_Null:	dc.w SonAni_Null-Ani_Sonic
ptr_Float3:	dc.w SonAni_Float3-Ani_Sonic
ptr_Float4:	dc.w SonAni_Float4-Ani_Sonic
ptr_MaxRun:	dc.w SonAni_MaxRun-Ani_Sonic
ptr_Spindash:	dc.w SonAni_SpinDash-Ani_Sonic ;1F
ptr_Hurt2:	dc.w SonAni_Hurt2-Ani_Sonic
ptr_GetUp:	dc.w SonAni_GetUp-Ani_Sonic
ptr_Blink:	dc.w SonAni_Blink-Ani_Sonic
ptr_Sit:	dc.w SonAni_Sit-Ani_Sonic
ptr_Peelout:	dc.w SonAni_Peelout-Ani_Sonic

SonAni_Walk:	dc.b $FF, fr_walk13, fr_walk14,	fr_walk15, fr_walk16, fr_walk17, fr_walk18, fr_walk11, fr_walk12, afEnd, afEnd, afEnd, afEnd
		even
SonAni_Run:	dc.b $FF, fr_run11,  fr_run12,  fr_run13,  fr_run14, fr_run15,  fr_run16,  fr_run17,  fr_run18, afEnd, afEnd, afEnd, afEnd
		even
SonAni_Roll:	dc.b $FE, fr_Roll1, fr_Roll6, fr_Roll2, fr_Roll7, fr_Roll3, fr_Roll5
		dc.b fr_Roll8, fr_Roll4, fr_Roll9, fr_Roll5, afEnd, afEnd
		even
SonAni_Roll2:	dc.b $FE, fr_Roll1, fr_Roll6, fr_Roll2, fr_Roll7, fr_Roll3, fr_Roll5
		dc.b fr_Roll8, fr_Roll4, fr_Roll9, fr_Roll5, afEnd, afEnd
		even
SonAni_Push:	dc.b $FD,  fr_push1,  fr_push2,  fr_push3,  fr_push4, fr_push5,  fr_push6,  fr_push7,  fr_push8, afEnd, afEnd, afEnd, afEnd
		even
SonAni_Wait:	
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
SonAni_Balance:	dc.b $F, fr_balance1, fr_balance2, fr_balance3, fr_balance4, afEnd
		even
SonAni_LookUp:	dc.b $3, fr_lookup1, fr_lookup2, afBack, 1
		even
SonAni_Duck:	dc.b $2, fr_duck3, fr_duck2, fr_duck, afBack, 1
		even
SonAni_Warp1:	dc.b $3F, fr_warp1, afEnd
		even
SonAni_Warp2:	dc.b $3F, fr_warp2, afEnd
		even
SonAni_Warp3:	dc.b $3F, fr_warp3, afEnd
		even
SonAni_Warp4:	dc.b $3F, fr_warp4, afEnd
		even
SonAni_Stop:	dc.b 2,	fr_stop1, fr_stop2, fr_stop2, fr_stop3, fr_stop3, fr_stop4, fr_stop4, $FD,  0
		even
SonAni_Float1:	dc.b 7,	fr_float1, fr_float4, afEnd
		even
SonAni_Float2:	dc.b 3,	fr_float1, fr_float7, fr_float2, fr_float8, fr_float5, fr_float3, fr_float6, afEnd
		even
SonAni_Spring:	dc.b 7, fr_spring, fr_spring2, fr_spring, fr_spring2, fr_spring, fr_spring2, afChange, id_Walk
		even
SonAni_Hang:	dc.b 4,	fr_hang1, fr_hang2, afEnd
		even
SonAni_Leap1:	dc.b $F, fr_leap1, fr_leap1, fr_leap1,	afBack, 1
		even
SonAni_Leap2:	dc.b $F, fr_leap1, fr_leap2, afBack, 1
		even
SonAni_Surf:	dc.b $3F, fr_surf, afEnd
		even
SonAni_GetAir:	dc.b $B, fr_getair, fr_getair, fr_walk15, fr_walk16, afChange, id_Walk
		even
SonAni_Burnt:	dc.b $20, fr_burnt, afEnd
		even
SonAni_Drown:	dc.b $2F, fr_drown, afEnd
		even
SonAni_Death:	dc.b 3,	fr_death, afEnd
		even
SonAni_Hurt:	dc.b 3,	fr_injury, afEnd
		even
SonAni_WaterSlide:
		dc.b 7, fr_injury, fr_waterslide, afEnd
		even
SonAni_Null:	dc.b $77, fr_null, afChange, id_Walk
		even
SonAni_Float3:	dc.b 3,	fr_float1, fr_float2, fr_float5, fr_float3, fr_float6, afEnd
		even
SonAni_Float4:	dc.b 3,	fr_float1, afChange, id_Walk
		even
SonAni_MaxRun:  dc.b $FF, fr_peelout11, fr_peelout12, fr_peelout13, fr_peelout14, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd, afEnd
		even
SonAni_SpinDash: dc.b 0, fr_Spindash1, fr_spindash2, fr_spindash1, fr_spindash3, fr_spindash1, fr_spindash4, fr_spindash1, fr_spindash5, fr_spindash1, fr_spindash6, afEnd
		even
SonAni_Hurt2:	dc.b 2, fr_skele1, fr_injury, fr_skele2, afEnd	
		even
SonAni_GetUp:	dc.b 3, $B,$FD,  0
		even
SonAni_Blink:	dc.b   1,  2,$FD,  0
		even
SonAni_Sit:	dc.b   8, 8, 9, 9, $A, $A,  9, $FE, 5
		even
SonAni_Peelout: dc.b 	0, $E, $E, $E, $E, $E, $E, $F, $F
		dc.b	$F, $F, $10, $10, $11, $11, $12, $13
		dc.b	$14, $15, $2E, $2F, $30, $31, $32
		dc.b	$33, $34, $35
		dc.b	$4E, $4F, $50,  $51, -2, 4, $FE
		even


id_Walk:	equ (ptr_Walk-Ani_Sonic)/2	; 0
id_Run:		equ (ptr_Run-Ani_Sonic)/2	; 1
id_Roll:	equ (ptr_Roll-Ani_Sonic)/2	; 2
id_Roll2:	equ (ptr_Roll2-Ani_Sonic)/2	; 3
id_Push:	equ (ptr_Push-Ani_Sonic)/2	; 4
id_Wait:	equ (ptr_Wait-Ani_Sonic)/2	; 5
id_Balance:	equ (ptr_Balance-Ani_Sonic)/2	; 6
id_LookUp:	equ (ptr_LookUp-Ani_Sonic)/2	; 7
id_Duck:	equ (ptr_Duck-Ani_Sonic)/2	; 8
id_Warp1:	equ (ptr_Warp1-Ani_Sonic)/2	; 9
id_Warp2:	equ (ptr_Warp2-Ani_Sonic)/2	; $A
id_Warp3:	equ (ptr_Warp3-Ani_Sonic)/2	; $B
id_Warp4:	equ (ptr_Warp4-Ani_Sonic)/2	; $C
id_Stop:	equ (ptr_Stop-Ani_Sonic)/2	; $D
id_Float1:	equ (ptr_Float1-Ani_Sonic)/2	; $E
id_Float2:	equ (ptr_Float2-Ani_Sonic)/2	; $F
id_Spring:	equ (ptr_Spring-Ani_Sonic)/2	; $10
id_Hang:	equ (ptr_Hang-Ani_Sonic)/2	; $11
id_Leap1:	equ (ptr_Leap1-Ani_Sonic)/2	; $12
id_Leap2:	equ (ptr_Leap2-Ani_Sonic)/2	; $13
id_Surf:	equ (ptr_Surf-Ani_Sonic)/2	; $14
id_GetAir:	equ (ptr_GetAir-Ani_Sonic)/2	; $15
id_Burnt:	equ (ptr_Burnt-Ani_Sonic)/2	; $16
id_Drown:	equ (ptr_Drown-Ani_Sonic)/2	; $17
id_Death:	equ (ptr_Death-Ani_Sonic)/2	; $18
id_Hurt:	equ (ptr_Hurt-Ani_Sonic)/2	; $19
id_WaterSlide:	equ (ptr_WaterSlide-Ani_Sonic)/2 ; $1A
id_Null:	equ (ptr_Null-Ani_Sonic)/2	; $1B
id_Float3:	equ (ptr_Float3-Ani_Sonic)/2	; $1C
id_Float4:	equ (ptr_Float4-Ani_Sonic)/2	; $1D
id_MaxRun:	equ (ptr_MaxRun-Ani_Sonic)/2	; $1E
id_Spindash:	equ (ptr_Spindash-Ani_Sonic)/2	; $1F
id_Hurt2:	equ (ptr_Hurt2-Ani_Sonic)/2	; $21
id_GetUp:	equ (ptr_GetUp-Ani_Sonic)/2	; $22
id_Blink:	equ (ptr_Blink-Ani_Sonic)/2	; $23
id_Sit:		equ (ptr_Sit-Ani_Sonic)/2	; $24
id_Peelout:	equ (ptr_Peelout-Ani_Sonic)/2	; $25