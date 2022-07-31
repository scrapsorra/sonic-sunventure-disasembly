; ---------------------------------------------------------------------------
; Animation script - Yadrin enemy
; ---------------------------------------------------------------------------
Ani_Yad:	dc.w @stand-Ani_Yad
		dc.w @walk-Ani_Yad

@stand:		dc.b 8,	0, afEnd
		even
@walk:		dc.b 8, 0, 0, 2, 0, 0, 1, 1, 1, 3, 1, 1, 1, afEnd
		even