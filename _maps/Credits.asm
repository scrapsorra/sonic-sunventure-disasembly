; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC TEAM	PRESENTS" and credits
; ---------------------------------------------------------------------------
Map_Cred_internal:
		dc.w @staff-Map_Cred_internal
		dc.w @gameplan-Map_Cred_internal
		dc.w @program-Map_Cred_internal
		dc.w @character-Map_Cred_internal
		dc.w @design-Map_Cred_internal
		dc.w @soundproduce-Map_Cred_internal
		dc.w @soundprogram-Map_Cred_internal
		dc.w @thanks-Map_Cred_internal
		dc.w @presentedby-Map_Cred_internal
		dc.w @tryagain-Map_Cred_internal
		dc.w @sonicteam-Map_Cred_internal
@staff:		dc.b $E			 ; SONIC TEAM STAFF
		dc.b $F8, 5, 0,	$2E, $88
		dc.b $F8, 5, 0,	$26, $98
		dc.b $F8, 5, 0,	$1A, $A8
		dc.b $F8, 1, 0,	$46, $B8
		dc.b $F8, 5, 0,	$1E, $C0
		dc.b $F8, 5, 0,	$3E, $D8
		dc.b $F8, 5, 0,	$E, $E8
		dc.b $F8, 5, 0,	4, $F8
		dc.b $F8, 9, 0,	8, 8
		dc.b $F8, 5, 0,	$2E, $28
		dc.b $F8, 5, 0,	$3E, $38
		dc.b $F8, 5, 0,	4, $48
		dc.b $F8, 5, 0,	$5C, $58
		dc.b $F8, 5, 0,	$5C, $68
@gameplan:	dc.b $E	;  GAME PLAN CAROL YAS | GAME PLAN SORRA    
		dc.b $90, 5, 0, 0, $90		; G
		dc.b $90, 5, 0, 4, $A0		; A
		dc.b $90, 9, 0, 8, $B0		; M
		dc.b $90, 5, 0, $0E, $C4	; E
		dc.b $90, 0, 0, $60, $C    ;Space
		dc.b $90, 5, 0, $12, $E4	; P
		dc.b $90, 5, 0, $16, $F4	; L
		dc.b $90, 5, 0, 4, $4		; A
		dc.b $90, 5, 0, $1A, $14	; N

		dc.b $B8, 5, 0, $2E, $C0	; S
		dc.b $B8, 5, 0, $26, $D0	; O
		dc.b $B8, 5, 0, $22, $E0	; R
		dc.b $B8, 5, 0, $22, $F0	; R
		dc.b $B8, 5, 0, 4, $0		; A
@program:	dc.b $1B	;  CHARACTER DESIGN BIGISLAND | PROGRAM ANGELKOR INVISIBLE SUN  
		dc.b $90, 5, 0, $12, $90	; P
		dc.b $90, 5, 0, $22, $A0	; R
		dc.b $90, 5, 0, $26, $B0	; O
		dc.b $90, 5, 0, 0, $C0		; G
		dc.b $90, 5, 0, $22, $D0	; R
		dc.b $90, 5, 0, 4, $E0		; A
		dc.b $90, 9, 0, 8, $F0		; M

		dc.b $B8, 5, 0, 4, $C0		; A
		dc.b $B8, 5, 0, $1A, $D0	; N
		dc.b $B8, 5, 0, 0, $E0		; G
		dc.b $B8, 5, 0, $0E, $F0	; E
		dc.b $B8, 5, 0, $16, $0	; L
		dc.b $B8, 5, 0, $58, $10	; K
		dc.b $B8, 5, 0, $26, $20	; O
		dc.b $B8, 5, 0, $22, $30	; R

		dc.b $D8, 1, 0, $46, $C0	; I
		dc.b $D8, 5, 0, $1A, $C8	; N

		dc.b $D8, 1, 0, $46, $E8	; I
		dc.b $D8, 5, 0, $2E, $F0	; S
		dc.b $D8, 1, 0, $46, $0	; I
		dc.b $D8, 5, 0, $48, $8	; B
		dc.b $D8, 5, 0, $16, $18	; L
		dc.b $D8, 5, 0, $0E, $28	; E

		dc.b $F8, 5, 0, $2E, $C0	; S
		dc.b $F8, 5, 0, $32, $D0	; U
		dc.b $F8, 5, 0, $1A, $E0	; N
@character:	dc.b $8	;  CHARACTER DESIGN BIGISLAND | ART SORRA    
		dc.b $90, 5, 0, 4, $90		; A
		dc.b $90, 5, 0, $22, $A0	; R
		dc.b $90, 5, 0, $3E, $B0	; T

		dc.b $B8, 5, 0, $2E, $C0	; S
		dc.b $B8, 5, 0, $26, $D0	; O
		dc.b $B8, 5, 0, $22, $E0	; R
		dc.b $B8, 5, 0, $22, $F0	; R
		dc.b $B8, 5, 0, 4, $0
@design:	dc.b $B	;  DESIGN JINYA PHENIX RIE | DESIGN SORRA    
		dc.b $90, 5, 0, $42, $90	; D
		dc.b $90, 5, 0, $0E, $A0	; E
		dc.b $90, 5, 0, $2E, $B0	; S
		dc.b $90, 1, 0, $46, $C0	; I
		dc.b $90, 5, 0, 0, $C8		; G
		dc.b $90, 5, 0, $1A, $D8	; N

		dc.b $B8, 5, 0, $2E, $C0	; S
		dc.b $B8, 5, 0, $26, $D0	; O
		dc.b $B8, 5, 0, $22, $E0	; R
		dc.b $B8, 5, 0, $22, $F0	; R
		dc.b $B8, 5, 0, 4, $0		; A
@soundproduce:	dc.b $1C	;  SOUND PRODUCE MASATO NAKAMURA | SOUND PORT MR JOKER PRODUCTION   
		dc.b $90, 5, 0, $2E, $90	; S
		dc.b $90, 5, 0, $26, $A0	; O
		dc.b $90, 5, 0, $32, $B0	; U
		dc.b $90, 5, 0, $1A, $C0	; N
		dc.b $90, 5, 0, $42, $D0	; D
		dc.b $90, 0, 0, $60, $C    ;Space
		dc.b $90, 5, 0, $12, $F0	; P
		dc.b $90, 5, 0, $26, $0	; O
		dc.b $90, 5, 0, $22, $10	; R
		dc.b $90, 5, 0, $3E, $20	; T

		dc.b $B8, 9, 0, 8, $C0		; M
		dc.b $B8, 5, 0, $22, $D4	; R
		dc.b $B8, 0, 0, $60, $C    ;Space
		dc.b $B8, 5, 0, $4C, $F4	; J
		dc.b $B8, 5, 0, $26, $4	; O
		dc.b $B8, 5, 0, $58, $14	; K
		dc.b $B8, 5, 0, $0E, $24	; E
		dc.b $B8, 5, 0, $22, $34	; R

		dc.b $D8, 5, 0, $12, $C0	; P
		dc.b $D8, 5, 0, $22, $D0	; R
		dc.b $D8, 5, 0, $26, $E0	; O
		dc.b $D8, 5, 0, $42, $F0	; D
		dc.b $D8, 5, 0, $32, $0	; U
		dc.b $D8, 5, 0, $1E, $10	; C
		dc.b $D8, 5, 0, $3E, $20	; T
		dc.b $D8, 1, 0, $46, $30	; I
		dc.b $D8, 5, 0, $26, $38	; O
		dc.b $D8, 5, 0, $1A, $48	; N
@soundprogram:	dc.b $17		 ; SOUND PROGRAM JIMITA	MACKY
		dc.b $D0, 5, 0,	$2E, $98
		dc.b $D0, 5, 0,	$26, $A8
		dc.b $D0, 5, 0,	$32, $B8
		dc.b $D0, 5, 0,	$1A, $C8
		dc.b $D0, 5, 0,	$54, $D8
		dc.b $D0, 5, 0,	$12, $F8
		dc.b $D0, 5, 0,	$22, 8
		dc.b $D0, 5, 0,	$26, $18
		dc.b $D0, 5, 0,	0, $28
		dc.b $D0, 5, 0,	$22, $38
		dc.b $D0, 5, 0,	4, $48
		dc.b $D0, 9, 0,	8, $58
		dc.b 0,	5, 0, $4C, $D0
		dc.b 0,	1, 0, $46, $E0
		dc.b 0,	9, 0, 8, $E8
		dc.b 0,	1, 0, $46, $FC
		dc.b 0,	5, 0, $3E, 4
		dc.b 0,	5, 0, 4, $14
		dc.b $20, 9, 0,	8, $D0
		dc.b $20, 5, 0,	4, $E4
		dc.b $20, 5, 0,	$1E, $F4
		dc.b $20, 5, 0,	$58, 4
		dc.b $20, 5, 0,	$2A, $14
@thanks:	dc.b $11	;  SPECIAL THANKS FUJIO MINEGISHI PAPA | SPECIAL  THANKS YOU   
		dc.b $90, 5, 0, $2E, $90	; S
		dc.b $90, 5, 0, $12, $A0	; P
		dc.b $90, 5, 0, $0E, $B0	; E
		dc.b $90, 5, 0, $1E, $C0	; C
		dc.b $90, 1, 0, $46, $D0	; I
		dc.b $90, 5, 0, 4, $D8		; A
		dc.b $90, 5, 0, $16, $E8	; L
		dc.b $90, 0, 0, $60, $C    ;Space

		dc.b $B8, 5, 0, $3E, $C0	; T
		dc.b $B8, 5, 0, $3A, $D0	; H
		dc.b $B8, 5, 0, 4, $E0		; A
		dc.b $B8, 5, 0, $1A, $F0	; N
		dc.b $B8, 5, 0, $58, $0	; K
		dc.b $B8, 5, 0, $2E, $10	; S

		dc.b $D8, 5, 0, $2A, $C0	; Y
		dc.b $D8, 5, 0, $26, $D0	; O
		dc.b $D8, 5, 0, $32, $E0	; U
@presentedby:	dc.b $10	;  PRESENTED BY SEGA | PRESENTED BY SORRA   
		dc.b $90, 5, 0, $12, $90	; P
		dc.b $90, 5, 0, $22, $A0	; R
		dc.b $90, 5, 0, $0E, $B0	; E
		dc.b $90, 5, 0, $2E, $C0	; S
		dc.b $90, 5, 0, $0E, $D0	; E
		dc.b $90, 5, 0, $1A, $E0	; N
		dc.b $90, 5, 0, $3E, $F0	; T
		dc.b $90, 5, 0, $0E, $0	; E
		dc.b $90, 5, 0, $42, $10	; D

		dc.b $B8, 5, 0, $48, $C0	; B
		dc.b $B8, 5, 0, $2A, $D0	; Y

		dc.b $D8, 5, 0, $2E, $C0	; S
		dc.b $D8, 5, 0, $26, $D0	; O
		dc.b $D8, 5, 0, $22, $E0	; R
		dc.b $D8, 5, 0, $22, $F0	; R
		dc.b $D8, 5, 0, 4, $0		; A
@tryagain:	dc.b 8			 ; TRY AGAIN
		dc.b $30, 5, 0,	$3E, $C0
		dc.b $30, 5, 0,	$22, $D0
		dc.b $30, 5, 0,	$2A, $E0
		dc.b $30, 5, 0,	4, $F8
		dc.b $30, 5, 0,	0, 8
		dc.b $30, 5, 0,	4, $18
		dc.b $30, 1, 0,	$46, $28
		dc.b $30, 5, 0,	$1A, $30
@sonicteam:	dc.b $E	;  SONIC TEAM PRESENTS | SORRA PRESENTS
		dc.b $E8, 5, 0, $2E, $D0	; S
		dc.b $E8, 5, 0, $26, $E0	; O
		dc.b $E8, 5, 0, $22, $F0	; R
		dc.b $E8, 5, 0, $22, $0	; R
		dc.b $E8, 5, 0, 4, $10		; A
		dc.b $E8, 0, 0, $60, $C   	 ; Space

		dc.b 0,	5, 0, $12, $C0	; P
		dc.b 0,	5, 0, $22, $D0	; R
		dc.b 0,	5, 0, $E, $E0	; E
		dc.b 0,	5, 0, $2E, $F0	; S
		dc.b 0,	5, 0, $E, 0	; E
		dc.b 0,	5, 0, $1A, $10	; N
		dc.b 0,	5, 0, $3E, $20	; T
		dc.b 0,	5, 0, $2E, $30	; S
		even