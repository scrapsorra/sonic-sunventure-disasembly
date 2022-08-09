; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_LGSi8:	
		dc.w SME_LGSi8_C-SME_LGSi8, SME_LGSi8_1C-SME_LGSi8	
		dc.w SME_LGSi8_2C-SME_LGSi8, SME_LGSi8_3C-SME_LGSi8	
		dc.w SME_LGSi8_5B-SME_LGSi8, SME_LGSi8_7A-SME_LGSi8	
SME_LGSi8_C:	dc.b 3	
		dc.b $F8, $D, 0, 0, $A0	
		dc.b $F8, $D, 0, 0, $E0	
		dc.b $F8, $D, 0, 0, $20	
SME_LGSi8_1C:	dc.b 3	
		dc.b $F8, $D, 0, 8, $A0	
		dc.b $F8, $D, 0, 8, $E0	
		dc.b $F8, $D, 0, 8, $20	
SME_LGSi8_2C:	dc.b 3	
		dc.b $F8, $D, 8, 0, $A0	
		dc.b $F8, $D, 8, 0, $E0	
		dc.b $F8, $D, 8, 0, $20	
SME_LGSi8_3C:	dc.b 6	
		dc.b $F8, $D, 0, 0, $A0	
		dc.b $F8, $D, 0, 0, $C0	
		dc.b $F8, $D, 0, 0, $E0	
		dc.b $F8, $D, 0, 0, 0	
		dc.b $F8, $D, 0, 0, $20	
		dc.b $F8, $D, 0, 0, $40	
SME_LGSi8_5B:	dc.b 6	
		dc.b $F8, $D, 0, 8, $A0	
		dc.b $F8, $D, 0, 8, $C0	
		dc.b $F8, $D, 0, 8, $E0	
		dc.b $F8, $D, 0, 8, 0	
		dc.b $F8, $D, 0, 8, $20	
		dc.b $F8, $D, 0, 8, $40	
SME_LGSi8_7A:	dc.b 6	
		dc.b $F8, $D, 8, 0, $A0	
		dc.b $F8, $D, 8, 0, $C0	
		dc.b $F8, $D, 8, 0, $E0	
		dc.b $F8, $D, 8, 0, 0	
		dc.b $F8, $D, 8, 0, $20	
		dc.b $F8, $D, 8, 0, $40	
		even