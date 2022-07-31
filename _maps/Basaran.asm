; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_RhYYA:	
		dc.w SME_RhYYA_8-SME_RhYYA, SME_RhYYA_E-SME_RhYYA	
		dc.w SME_RhYYA_1E-SME_RhYYA, SME_RhYYA_33-SME_RhYYA	
SME_RhYYA_8:	dc.b 1	
		dc.b $F4, 6, $20, 0, $F8	
SME_RhYYA_E:	dc.b 3	
		dc.b $F2, $E, $20, 6, $F4	
		dc.b $A, 4, $20, $12, $FC	
		dc.b 2, 0, $20, $27, $C	
SME_RhYYA_1E:	dc.b 4	
		dc.b $F8, 4, $20, $14, $F8	
		dc.b 0, $C, $20, $16, $F0	
		dc.b 8, 4, $20, $1A, 0	
		dc.b 0, 0, $20, $28, $C	
SME_RhYYA_33:	dc.b 4	
		dc.b $F6, 9, $20, $1C, $F5	
		dc.b 6, 8, $20, $22, $F4	
		dc.b $E, 4, $20, $25, $F4	
		dc.b $FE, 0, $20, $27, $C	
		even