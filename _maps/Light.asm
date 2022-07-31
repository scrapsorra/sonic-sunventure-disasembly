; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_FBl1X:	
		dc.w SME_FBl1X_8-SME_FBl1X, SME_FBl1X_22-SME_FBl1X	
		dc.w SME_FBl1X_3C-SME_FBl1X, SME_FBl1X_5B-SME_FBl1X	
SME_FBl1X_8:	dc.b 5	
		dc.b $E0, 4, 0, $6D, 0	
		dc.b $E8, $C, 0, $6F, $F8	
		dc.b $F0, $C, 0, $73, $F8	
		dc.b $F8, 0, 0, $90, 0	
		dc.b $F8, 0, 8, $90, 8	
SME_FBl1X_22:	dc.b 5	
		dc.b $E0, 4, 0, $77, 0	
		dc.b $E8, 4, 0, $79, 0	
		dc.b $E8, 0, 0, $7B, $10	
		dc.b $F0, 8, 0, $7C, $F8	
		dc.b $F8, 4, 0, $91, 0	
SME_FBl1X_3C:	dc.b 6	
		dc.b $E0, 0, 0, $7F, 0	
		dc.b $E0, 0, 0, $78, 8	
		dc.b $E8, $C, 0, $80, $F8	
		dc.b $F0, $C, 0, $84, $F8	
		dc.b $F8, 0, 0, $93, 8	
		dc.b $F8, 0, 0, $91, 0	
SME_FBl1X_5B:	dc.b 5	
		dc.b $E0, 4, 0, $88, 0	
		dc.b $E8, 8, 0, $8A, $F8	
		dc.b $F0, 8, 0, $8D, 0	
		dc.b $F8, 0, 0, $94, 0	
		dc.b $F8, 0, 8, $90, 8	
		even