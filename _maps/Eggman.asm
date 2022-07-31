; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_F_pyS:	
		dc.w SME_F_pyS_1A-SME_F_pyS, SME_F_pyS_34-SME_F_pyS	
		dc.w SME_F_pyS_44-SME_F_pyS, SME_F_pyS_54-SME_F_pyS	
		dc.w SME_F_pyS_69-SME_F_pyS, SME_F_pyS_7E-SME_F_pyS	
		dc.w SME_F_pyS_93-SME_F_pyS, SME_F_pyS_A8-SME_F_pyS	
		dc.w SME_F_pyS_CC-SME_F_pyS, SME_F_pyS_D2-SME_F_pyS	
		dc.w SME_F_pyS_D8-SME_F_pyS, SME_F_pyS_D9-SME_F_pyS	
		dc.w SME_F_pyS_E4-SME_F_pyS	
SME_F_pyS_1A:	dc.b 5	
		dc.b $EC, 1, 0, $A, $E4	
		dc.b $FC, $E, $20, $10, $E4	
		dc.b $FC, $E, $20, $1C, 4	
		dc.b $14, $C, $20, $28, $EC	
		dc.b $14, 0, $20, $2C, $C	
SME_F_pyS_34:	dc.b 3	
		dc.b $E4, 4, 0, 0, $F4	
		dc.b $EC, $D, 0, 2, $EC	
		dc.b $EC, 5, 0, $C, $C	
SME_F_pyS_44:	dc.b 3	
		dc.b $E4, 4, 0, 0, $F4	
		dc.b $EC, $D, 0, $35, $EC	
		dc.b $EC, 5, 0, $C, $C	
SME_F_pyS_54:	dc.b 4	
		dc.b $E4, 8, 0, $3D, $F4	
		dc.b $EC, 9, 0, $40, $EC	
		dc.b $EC, 5, 0, $46, 4	
		dc.b $EC, 1, 0, $E, $14	
SME_F_pyS_69:	dc.b 4	
		dc.b $E4, 8, 0, $4A, $F4	
		dc.b $EC, 9, 0, $4D, $EC	
		dc.b $EC, 5, 0, $53, 4	
		dc.b $EC, 1, 0, $E, $14	
SME_F_pyS_7E:	dc.b 4	
		dc.b $E4, 8, 0, $57, $F4	
		dc.b $EC, 9, 0, $5A, $EC	
		dc.b $EC, 5, 0, $60, 4	
		dc.b $EC, 1, 0, $E, $14	
SME_F_pyS_93:	dc.b 4	
		dc.b $E4, 4, 0, $64, 4	
		dc.b $E4, 4, 0, 0, $F4	
		dc.b $EC, $D, 0, $35, $EC	
		dc.b $EC, 5, 0, $C, $C	
SME_F_pyS_A8:	dc.b 7	
		dc.b $E4, 9, 0, $66, $F4	
		dc.b $E4, 8, 0, $57, $F4	
		dc.b $EC, 5, 0, $60, 4	
		dc.b $EC, 1, 0, $35, $EC	
		dc.b $F4, 0, 0, $5D, $F4	
		dc.b $F4, 0, 0, $5F, $FC	
		dc.b $EC, 1, 0, $E, $14	
SME_F_pyS_CC:	dc.b 1	
		dc.b 4, 5, 0, $2D, $22	
SME_F_pyS_D2:	dc.b 1	
		dc.b 4, 5, 0, $31, $22	
SME_F_pyS_D8:	dc.b 0	
SME_F_pyS_D9:	dc.b 2	
		dc.b 0, 8, 1, $2A, $22	
		dc.b 8, 8, $11, $2A, $22	
SME_F_pyS_E4:	dc.b 2	
		dc.b $F8, $B, 1, $2D, $22	
		dc.b 0, 1, 1, $39, $3A	
		even