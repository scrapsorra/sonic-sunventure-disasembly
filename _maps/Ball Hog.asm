; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_ZER01:	
		dc.w SME_ZER01_C-SME_ZER01, SME_ZER01_17-SME_ZER01	
		dc.w SME_ZER01_22-SME_ZER01, SME_ZER01_2D-SME_ZER01	
		dc.w SME_ZER01_38-SME_ZER01, SME_ZER01_3E-SME_ZER01	
SME_ZER01_C:	dc.b 2	
		dc.b $EF, 9, $20, 0, $F4	
		dc.b $FF, $A, $20, 6, $F4	
SME_ZER01_17:	dc.b 2	
		dc.b $EF, 9, $20, 0, $F4	
		dc.b $FF, $A, $20, $F, $F4	
SME_ZER01_22:	dc.b 2	
		dc.b $F4, 9, $20, 0, $F4	
		dc.b 4, 9, $20, $18, $F4	
SME_ZER01_2D:	dc.b 2	
		dc.b $E4, 9, $20, 0, $F4	
		dc.b $F4, $A, $20, $1E, $F4	
SME_ZER01_38:	dc.b 1	
		dc.b $F8, 5, 0, $27, $F8	
SME_ZER01_3E:	dc.b 1	
		dc.b $F8, 5, $60, $2B, $F8	
		even