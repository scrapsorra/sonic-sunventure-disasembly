; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_u_DKx:	
		dc.w SME_u_DKx_6-SME_u_DKx, SME_u_DKx_20-SME_u_DKx	
		dc.w SME_u_DKx_26-SME_u_DKx	
SME_u_DKx_6:	dc.b 5	
		dc.b $E8, 4, 0, 0, $F8	
		dc.b $F0, $F, 0, 2, $F0	
		dc.b $F8, 1, 0, $12, $E8	
		dc.b $F8, 1, 0, $14, $10	
		dc.b $10, 4, 0, $16, $F8	
SME_u_DKx_20:	dc.b 1	
		dc.b $F8, 5, 0, $20, $F8	
SME_u_DKx_26:	dc.b 2	
		dc.b $F8, $D, 0, $18, $F0	
		dc.b $E8, $D, $10, $18, $F0	
		even