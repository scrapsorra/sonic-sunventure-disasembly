; ---------------------------------------------------------------------------
; Animation script - vanishing platforms (SBZ)
; ---------------------------------------------------------------------------
Ani_Van:	dc.w @vanish-Ani_Van
		dc.w @appear-Ani_Van
@vanish:	dc.b 3,	0, 1, 2, 3, 4, 5, 6, afBack, 1
		even
@appear:	dc.b 3,	6, 5, 4, 3, 2, 1, 0, afBack, 1
		even