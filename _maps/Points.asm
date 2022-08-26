; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_qLvsg:	
		dc.w SME_qLvsg_E-SME_qLvsg, SME_qLvsg_14-SME_qLvsg	
		dc.w SME_qLvsg_1A-SME_qLvsg, SME_qLvsg_20-SME_qLvsg	
		dc.w SME_qLvsg_26-SME_qLvsg, SME_qLvsg_2C-SME_qLvsg	
		dc.w SME_qLvsg_37-SME_qLvsg	
SME_qLvsg_E:	dc.b 1	
		dc.b $FC, 4, 0, 0, $F8	
SME_qLvsg_14:	dc.b 1	
		dc.b $FC, 4, 0, 2, $F8	
SME_qLvsg_1A:	dc.b 1	
		dc.b $FC, 4, 0, 4, $F8	
SME_qLvsg_20:	dc.b 1	
		dc.b $FC, 4, 0, 6, $F8	
SME_qLvsg_26:	dc.b 1	
		dc.b $FC, 0, 0, 6, $FC	
SME_qLvsg_2C:	dc.b 2	
		dc.b $FC, 8, 0, 6, $F4	
		dc.b $FC, 4, 0, 7, 1	
SME_qLvsg_37:	dc.b 2	
		dc.b $FC, 8, 0, 6, $F4	
		dc.b $FC, 4, 0, 7, 6	
		even