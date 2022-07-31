; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_XNaLt:	
		dc.w SME_XNaLt_C-SME_XNaLt, SME_XNaLt_17-SME_XNaLt	
		dc.w SME_XNaLt_27-SME_XNaLt, SME_XNaLt_41-SME_XNaLt	
		dc.w SME_XNaLt_56-SME_XNaLt, SME_XNaLt_75-SME_XNaLt	
SME_XNaLt_C:	dc.b 2	
		dc.b $F8, 4, 0, 0, $F8	
		dc.b 0, 6, 0, 2, $F8	
SME_XNaLt_17:	dc.b 3	
		dc.b $F8, 5, 0, 8, $F8	
		dc.b $F8, 4, $60, 0, $F8	
		dc.b 0, 6, 0, 2, $F8	
SME_XNaLt_27:	dc.b 5	
		dc.b $F8, 5, 0, 8, $F8	
		dc.b $F8, 4, $60, 0, $F8	
		dc.b 0, 6, 0, 2, $F8	
		dc.b $F6, $D, 0, $C, 8	
		dc.b $F6, $D, 8, $C, $DC	
SME_XNaLt_41:	dc.b 4	
		dc.b $F8, 4, 0, 0, $F8	
		dc.b 0, 6, 0, 2, $F8	
		dc.b $F6, $D, 0, $C, 8	
		dc.b $F6, $D, 8, $C, $DC	
SME_XNaLt_56:	dc.b 6	
		dc.b $F8, 5, 0, 8, $F8	
		dc.b 0, 6, 0, 2, $F8	
		dc.b $F6, $D, $10, $C, 8	
		dc.b $F6, $D, $18, $C, $DC	
		dc.b $F6, $D, 0, $C, $24	
		dc.b $F6, $D, 8, $C, $C0	
SME_XNaLt_75:	dc.b 4	
		dc.b $F8, 4, 0, 0, $F8	
		dc.b 0, 6, 0, 2, $F8	
		dc.b $F6, $D, $10, $C, $24	
		dc.b $F6, $D, $18, $C, $C0	
		even