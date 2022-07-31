; ---------------------------------------------------------------------------
; Animation script - Buzz Bomber enemy
; ---------------------------------------------------------------------------
Ani_Mozzietron:	dc.w byte_9A1E-Ani_Mozzietron;0
		dc.w byte_9A22-Ani_Mozzietron;1
		dc.w byte_9A26-Ani_Mozzietron;2
byte_9A1E:	dc.b 1,	0, 1, $FF
byte_9A22:	dc.b 1,	2, 3, $FF
byte_9A26:	dc.b 5, 2, 3, 4, 5, $FE, 1
		even