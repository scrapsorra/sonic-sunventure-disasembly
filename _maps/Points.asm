; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_yDUNR:	
		dc.w SME_yDUNR_E-SME_yDUNR, SME_yDUNR_19-SME_yDUNR	
		dc.w SME_yDUNR_24-SME_yDUNR, SME_yDUNR_2F-SME_yDUNR	
		dc.w SME_yDUNR_3A-SME_yDUNR, SME_yDUNR_40-SME_yDUNR	
		dc.w SME_yDUNR_55-SME_yDUNR	
SME_yDUNR_E:	dc.b 2	
		dc.b $FC, 0, 0, 3, $FC	
		dc.b $FC, 0, 0, 0, 0	
SME_yDUNR_19:	dc.b 2	
		dc.b $FC, 0, 0, 1, $F8	
		dc.b $FC, 0, 0, 0, 0	
SME_yDUNR_24:	dc.b 2	
		dc.b $FC, 0, 0, 2, $F8	
		dc.b $FC, 0, 0, 0, 0	
SME_yDUNR_2F:	dc.b 2	
		dc.b $FC, 0, 0, 3, $F8	
		dc.b $FC, 0, 0, 0, 0	
SME_yDUNR_3A:	dc.b 1	
		dc.b $FC, 0, 0, 3, $FC	
SME_yDUNR_40:	dc.b 4	
		dc.b $FC, 4, 0, 7, 5	
		dc.b $FC, 0, 0, 3, $F4	
		dc.b $FC, 0, 0, 0, $F8	
		dc.b $FC, 0, 0, 0, $FC	
SME_yDUNR_55:	dc.b 2	
		dc.b $FC, 8, 0, 3, $F4	
		dc.b $FC, 4, 0, 7, 6	
		even