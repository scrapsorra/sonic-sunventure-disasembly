; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_qvHIs:	
		dc.w SME_qvHIs_C-SME_qvHIs, SME_qvHIs_17-SME_qvHIs	
		dc.w SME_qvHIs_1D-SME_qvHIs, SME_qvHIs_28-SME_qvHIs	
		dc.w SME_qvHIs_38-SME_qvHIs, SME_qvHIs_4D-SME_qvHIs	
SME_qvHIs_C:	dc.b 2	
		dc.b $FD, $C, $20, 0, $F0	
		dc.b $ED, 9, $20, 4, $F8	
SME_qvHIs_17:	dc.b 1	
		dc.b $F8, $D, $20, $A, $F0	
SME_qvHIs_1D:	dc.b 2	
		dc.b $E9, $A, $20, $12, $F8	
		dc.b $F9, 1, $20, $1B, $F0	
SME_qvHIs_28:	dc.b 3	
		dc.b $DF, 7, $20, $25, $FB	
		dc.b $E7, 0, $20, $30, $B	
		dc.b $FF, 0, 0, $2D, $FB	
SME_qvHIs_38:	dc.b 4	
		dc.b $E5, 9, $20, $1D, $F4	
		dc.b $F5, 1, $20, $23, $FC	
		dc.b $F5, 0, $20, $2E, $F4	
		dc.b $F5, 0, $20, $2F, 4	
SME_qvHIs_4D:	dc.b 4	
		dc.b $E5, 9, $20, $1D, $F4	
		dc.b $F5, 1, $20, $23, $FC	
		dc.b $F5, 0, $20, $2E, $F4	
		dc.b $F5, 0, $20, $2F, 4	
		even