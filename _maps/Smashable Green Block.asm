; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_wdHTM:	
		dc.w SME_wdHTM_6-SME_wdHTM, SME_wdHTM_1B-SME_wdHTM	
		dc.w SME_wdHTM_30-SME_wdHTM	
SME_wdHTM_6:	dc.b 4	
		dc.b $F0, 5, 0, 0, 0	
		dc.b 0, 5, 0, 0, 0	
		dc.b 0, 5, 0, 0, $F0	
		dc.b $F0, 5, 0, 0, $F0	
SME_wdHTM_1B:	dc.b 4	
		dc.b $F0, 5, 0, 0, 0	
		dc.b 0, 5, 0, 0, 0	
		dc.b 0, 5, 0, 0, $F0	
		dc.b $F0, 5, 0, 0, $F0	
SME_wdHTM_30:	dc.b 0	
		even