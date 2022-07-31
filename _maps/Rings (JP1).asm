; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_aSMQh:	
		dc.w SME_aSMQh_14-SME_aSMQh, SME_aSMQh_1A-SME_aSMQh	
		dc.w SME_aSMQh_20-SME_aSMQh, SME_aSMQh_26-SME_aSMQh	
		dc.w SME_aSMQh_2C-SME_aSMQh, SME_aSMQh_32-SME_aSMQh	
		dc.w SME_aSMQh_38-SME_aSMQh, SME_aSMQh_3E-SME_aSMQh	
		dc.w SME_aSMQh_44-SME_aSMQh, SME_aSMQh_4A-SME_aSMQh	
SME_aSMQh_14:	dc.b 1	
		dc.b $F8, 5, 0, 0, $F8	
SME_aSMQh_1A:	dc.b 1	
		dc.b $F8, 5, 0, 4, $F8	
SME_aSMQh_20:	dc.b 1	
		dc.b $F8, 5, 0, $A, $F8	
SME_aSMQh_26:	dc.b 1	
		dc.b $F8, 1, 0, 8, $FC	
SME_aSMQh_2C:	dc.b 1	
		dc.b $F8, 5, 8, $A, $F8	
SME_aSMQh_32:	dc.b 1	
		dc.b $F8, 5, 8, 4, $F8	
SME_aSMQh_38:	dc.b 1	
		dc.b $F8, 5, 0, $10, $F8	
SME_aSMQh_3E:	dc.b 1	
		dc.b $F8, 5, $18, $10, $F8	
SME_aSMQh_44:	dc.b 1	
		dc.b $F8, 5, 8, $10, $F8	
SME_aSMQh_4A:	dc.b 1	
		dc.b $F8, 5, $10, $10, $F8	
		even