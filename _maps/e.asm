; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_UMebe:	
		dc.w SME_UMebe_A-SME_UMebe, SME_UMebe_10-SME_UMebe	
		dc.w SME_UMebe_16-SME_UMebe, SME_UMebe_1C-SME_UMebe	
		dc.w SME_UMebe_31-SME_UMebe	
SME_UMebe_A:	dc.b 1	
		dc.b $F8, 9, 0, 0, $F4	
SME_UMebe_10:	dc.b 1	
		dc.b $F0, $F, $20, 6, $F0	
SME_UMebe_16:	dc.b 1	
		dc.b $F0, $F, $20, $16, $F0	
SME_UMebe_1C:	dc.b 4	
		dc.b $EC, $A, $40, $26, $EC	
		dc.b $EC, 5, $40, $2F, 4	
		dc.b 4, 5, $38, $2F, $EC	
		dc.b $FC, $A, $38, $26, $FC	
SME_UMebe_31:	dc.b 4	
		dc.b $EC, $A, $20, $33, $EC	
		dc.b $EC, 5, $20, $3C, 4	
		dc.b 4, 5, $38, $3C, $EC	
		dc.b $FC, $A, $38, $33, $FC	
		even