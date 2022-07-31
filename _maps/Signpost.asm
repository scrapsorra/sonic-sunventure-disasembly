; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_KvSue:	
		dc.w SME_KvSue_A-SME_KvSue, SME_KvSue_1F-SME_KvSue	
		dc.w SME_KvSue_2F-SME_KvSue, SME_KvSue_3F-SME_KvSue	
		dc.w SME_KvSue_4F-SME_KvSue	
SME_KvSue_A:	dc.b 4	
		dc.b $F0, $B, 0, 0, $E8	
		dc.b $F0, $B, 8, 0, 0	
		dc.b $10, 1, 0, $38, $FC	
		dc.b $20, 8, 0, $3A, $F4	
SME_KvSue_1F:	dc.b 3	
		dc.b $F0, $F, 0, $C, $F0	
		dc.b $10, 1, 0, $38, $FC	
		dc.b $20, 8, 0, $3A, $F4	
SME_KvSue_2F:	dc.b 3	
		dc.b $F0, 3, 0, $1C, $FC	
		dc.b $10, 1, 8, $38, $FC	
		dc.b $20, 8, 0, $3A, $F4	
SME_KvSue_3F:	dc.b 3	
		dc.b $F0, $F, 8, $C, $F0	
		dc.b $10, 1, 8, $38, $FC	
		dc.b $20, 8, 0, $3A, $F4	
SME_KvSue_4F:	dc.b 4	
		dc.b $F0, $B, 0, $20, $E8	
		dc.b $F0, $B, 0, $2C, 0	
		dc.b $10, 1, 0, $38, $FC	
		dc.b $20, 8, 0, $3A, $F4	
		even