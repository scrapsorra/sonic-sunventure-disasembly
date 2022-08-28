; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_VSEMD:	
		dc.w SME_VSEMD_1E-SME_VSEMD, SME_VSEMD_24-SME_VSEMD	
		dc.w SME_VSEMD_2F-SME_VSEMD, SME_VSEMD_3A-SME_VSEMD	
		dc.w SME_VSEMD_45-SME_VSEMD, SME_VSEMD_50-SME_VSEMD	
		dc.w SME_VSEMD_5B-SME_VSEMD, SME_VSEMD_66-SME_VSEMD	
		dc.w SME_VSEMD_71-SME_VSEMD, SME_VSEMD_7C-SME_VSEMD	
		dc.w SME_VSEMD_87-SME_VSEMD, SME_VSEMD_92-SME_VSEMD	
		dc.w SME_VSEMD_AC-SME_VSEMD, SME_VSEMD_B7-SME_VSEMD	
		dc.w SME_VSEMD_C2-SME_VSEMD	
SME_VSEMD_1E:	dc.b 1	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_24:	dc.b 2	
		dc.b $F5, 5, 0, $10, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_2F:	dc.b 2	
		dc.b $F5, 5, 0, $14, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_3A:	dc.b 2	
		dc.b $F5, 5, 0, $18, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_45:	dc.b 2	
		dc.b $F5, 5, 1, $54, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_50:	dc.b 2	
		dc.b $F5, 5, 0, $24, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_5B:	dc.b 2	
		dc.b $F5, 5, $20, $28, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_66:	dc.b 2	
		dc.b $F5, 5, 0, $2C, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_71:	dc.b 2	
		dc.b $F5, 5, $20, $30, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_7C:	dc.b 2	
		dc.b $F5, 5, 0, $34, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_87:	dc.b 2	
		dc.b $F5, 5, 0, $20, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_92:	dc.b 5	
		dc.b 1, $C, 0, $38, $F0	
		dc.b 9, 0, 0, 3, $F0	
		dc.b 9, 0, 0, 7, $F8	
		dc.b 9, 0, 0, $B, 0	
		dc.b 9, 0, 0, $F, 8	
SME_VSEMD_AC:	dc.b 2	
		dc.b $F5, 5, 0, $1C, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_B7:	dc.b 2	
		dc.b $F5, 5, $20, $40, $F8	
		dc.b $F1, $F, 0, 0, $F0	
SME_VSEMD_C2:	dc.b 2	
		dc.b $F5, 5, 0, $3C, $F8	
		dc.b $F1, $F, 0, 0, $F0	
		even