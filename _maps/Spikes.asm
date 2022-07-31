; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_XgeaQ:	
		dc.w SME_XgeaQ_C-SME_XgeaQ, SME_XgeaQ_1C-SME_XgeaQ	
		dc.w SME_XgeaQ_2C-SME_XgeaQ, SME_XgeaQ_32-SME_XgeaQ	
		dc.w SME_XgeaQ_42-SME_XgeaQ, SME_XgeaQ_61-SME_XgeaQ	
SME_XgeaQ_C:	dc.b 3	
		dc.b $F0, 3, $20, 4, $EC	
		dc.b $F0, 3, $20, 4, $FC	
		dc.b $F0, 3, $20, 4, $C	
SME_XgeaQ_1C:	dc.b 3	
		dc.b $EC, $C, $20, 0, $F0	
		dc.b $FC, $C, $20, 0, $F0	
		dc.b $C, $C, $20, 0, $F0	
SME_XgeaQ_2C:	dc.b 1	
		dc.b $F0, 3, $20, 4, $FC	
SME_XgeaQ_32:	dc.b 3	
		dc.b $F0, 3, $20, 4, $E4	
		dc.b $F0, 3, $20, 4, $FC	
		dc.b $F0, 3, $20, 4, $14	
SME_XgeaQ_42:	dc.b 6	
		dc.b $F0, 3, $20, 4, $C0	
		dc.b $F0, 3, $20, 4, $D8	
		dc.b $F0, 3, $20, 4, $F0	
		dc.b $F0, 3, $20, 4, 8	
		dc.b $F0, 3, $20, 4, $20	
		dc.b $F0, 3, $20, 4, $38	
SME_XgeaQ_61:	dc.b 1	
		dc.b $FC, $C, $20, 0, $F0	
		even