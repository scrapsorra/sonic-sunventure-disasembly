; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_TTY9T:	
		dc.w SME_TTY9T_E-SME_TTY9T, SME_TTY9T_23-SME_TTY9T	
		dc.w SME_TTY9T_38-SME_TTY9T, SME_TTY9T_52-SME_TTY9T	
		dc.w SME_TTY9T_58-SME_TTY9T, SME_TTY9T_5E-SME_TTY9T	
		dc.w SME_TTY9T_64-SME_TTY9T	
SME_TTY9T_E:	dc.b 4	
		dc.b $F0, $D, $20, 0, $EC	
		dc.b 0, $C, $20, 8, $EC	
		dc.b $F8, 1, $20, $C, $C	
		dc.b 8, 8, $20, $E, $F4	
SME_TTY9T_23:	dc.b 4	
		dc.b $F1, $D, $20, 0, $EC	
		dc.b 1, $C, $20, 8, $EC	
		dc.b $F9, 1, $20, $C, $C	
		dc.b 9, 8, $20, $11, $F4	
SME_TTY9T_38:	dc.b 5	
		dc.b $F0, $D, $20, 0, $EC	
		dc.b 0, $C, $20, $14, $EC	
		dc.b $F8, 1, $20, $C, $C	
		dc.b 8, 4, $20, $18, $EC	
		dc.b 8, 4, $20, $12, $FC	
SME_TTY9T_52:	dc.b 1	
		dc.b $FA, 0, 0, $1A, $10	
SME_TTY9T_58:	dc.b 1	
		dc.b $FA, 0, 0, $1B, $10	
SME_TTY9T_5E:	dc.b 1	
		dc.b $FA, 0, 0, $1C, $10	
SME_TTY9T_64:	dc.b 0	
		even