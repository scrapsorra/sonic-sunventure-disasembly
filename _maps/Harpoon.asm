; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_JPFHb:	
		dc.w SME_JPFHb_C-SME_JPFHb, SME_JPFHb_12-SME_JPFHb	
		dc.w SME_JPFHb_18-SME_JPFHb, SME_JPFHb_23-SME_JPFHb	
		dc.w SME_JPFHb_29-SME_JPFHb, SME_JPFHb_2F-SME_JPFHb	
SME_JPFHb_C:	dc.b 1	
		dc.b $FC, 4, $20, 0, $F8	
SME_JPFHb_12:	dc.b 1	
		dc.b $FC, $C, $20, 2, $F8	
SME_JPFHb_18:	dc.b 2	
		dc.b $FC, 8, $20, 6, $F8	
		dc.b $FC, 8, $20, 3, $10	
SME_JPFHb_23:	dc.b 1	
		dc.b $F8, 1, $20, 9, $FC	
SME_JPFHb_29:	dc.b 1	
		dc.b $E8, 3, $20, $B, $FC	
SME_JPFHb_2F:	dc.b 2	
		dc.b $D8, 2, $20, $B, $FC	
		dc.b $F0, 2, $20, $F, $FC	
		even