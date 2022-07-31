; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_gyvTV:	
		dc.w SME_gyvTV_C-SME_gyvTV, SME_gyvTV_12-SME_gyvTV	
		dc.w SME_gyvTV_18-SME_gyvTV, SME_gyvTV_1E-SME_gyvTV	
		dc.w SME_gyvTV_24-SME_gyvTV, SME_gyvTV_2A-SME_gyvTV	
SME_gyvTV_C:	dc.b 1	
		dc.b $E8, 7, $60, 0, $F8	
SME_gyvTV_12:	dc.b 1	
		dc.b $E8, 7, $60, 8, $F8	
SME_gyvTV_18:	dc.b 1	
		dc.b $F0, 6, $60, $10, $F8	
SME_gyvTV_1E:	dc.b 1	
		dc.b $F8, $D, $60, $16, $E8	
SME_gyvTV_24:	dc.b 1	
		dc.b $F8, $D, $60, $1E, $E8	
SME_gyvTV_2A:	dc.b 1	
		dc.b $F8, 9, $60, $26, $F0	
		even