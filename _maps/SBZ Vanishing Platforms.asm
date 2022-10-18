; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_Mrcg1:	
		dc.w SME_Mrcg1_E-SME_Mrcg1, SME_Mrcg1_14-SME_Mrcg1	
		dc.w SME_Mrcg1_29-SME_Mrcg1, SME_Mrcg1_2F-SME_Mrcg1	
		dc.w SME_Mrcg1_3A-SME_Mrcg1, SME_Mrcg1_40-SME_Mrcg1	
		dc.w SME_Mrcg1_46-SME_Mrcg1	
SME_Mrcg1_E:	dc.b 1	
		dc.b $F8, $F, 0, 0, $F0	
SME_Mrcg1_14:	dc.b 4	
		dc.b $F8, 3, 0, $10, $F8	
		dc.b $F8, 3, 0, $10, 0	
		dc.b $F8, 3, 0, $10, $F0	
		dc.b $F8, 3, 0, $10, 8	
SME_Mrcg1_29:	dc.b 1	
		dc.b $F8, 7, 0, 0, $F8	
SME_Mrcg1_2F:	dc.b 2	
		dc.b $F8, 3, 0, $10, $F8	
		dc.b $F8, 3, 0, $10, 0	
SME_Mrcg1_3A:	dc.b 1	
		dc.b $F8, 3, 0, 0, $FD	
SME_Mrcg1_40:	dc.b 1	
		dc.b $F8, 3, 0, $10, $FD	
SME_Mrcg1_46:	dc.b 0	
		even