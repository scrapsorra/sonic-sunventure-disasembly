; ---------------------------------------------------------------------------
; Animation script - bubbles (LZ)
; ---------------------------------------------------------------------------
Ani_Bub:	dc.w @small-Ani_Bub
		dc.w @medium-Ani_Bub
		dc.w @large-Ani_Bub
		dc.w @incroutine-Ani_Bub
		dc.w @incroutine-Ani_Bub
		dc.w @burst-Ani_Bub
		dc.w @bubmaker-Ani_Bub
@small:		dc.b $D, 0, 1, 2, afRoutine ; small bubble forming
		even
@medium:	dc.b $D, 1, 2, 3, 4, afRoutine ; medium bubble forming
@large:		dc.b $D, 2, 3, 4, 5, 6,	afRoutine ; full size bubble forming
		even
@incroutine:	dc.b 4,	afRoutine	; increment routine counter (no animation)
@burst:		dc.b 4,	6, 7, 8, afRoutine ; large bubble bursts
		even
@bubmaker:	dc.b $E, $13, $14, $15,	afEnd ; bubble maker on the floor
		even