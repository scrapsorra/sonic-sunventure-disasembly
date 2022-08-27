; ---------------------------------------------------------------------------
; Palette pointers
; ---------------------------------------------------------------------------

palp:	macro paladdress,ramaddress,colors
	dc.l paladdress
	dc.w ramaddress, (colors>>1)-1
	endm

PalPointers:

; palette address, RAM address, colors

ptr_Pal_SegaBG:		palp	Pal_SegaBG,v_pal_dry,$40		; 0 - Sega logo
ptr_Pal_Title:		palp	Pal_Title,v_pal_dry,$40		; 1 - title screen
ptr_Pal_LevelSel:	palp	Pal_LevelSel,v_pal_dry,$40		; 2 - level select
ptr_Pal_Sonic:		palp	Pal_Sonic,v_pal_dry,$10		; 3 - Sonic
Pal_Levels:
ptr_Pal_GHZ:		palp	Pal_GHZ,v_pal_dry+$20, $30		; 4 - GHZ
ptr_Pal_LZ:		palp	Pal_LZ,v_pal_dry+$20,$30		; 5 - LZ
ptr_Pal_MZ:		palp	Pal_MZ,v_pal_dry+$20,$30		; 6 - MZ
ptr_Pal_SLZ:		palp	Pal_SLZ,v_pal_dry+$20,$30		; 7 - SLZ
ptr_Pal_SYZ:		palp	Pal_SYZ,v_pal_dry+$20,$30		; 8 - SYZ
ptr_Pal_SBZ1:		palp	Pal_SBZ1,v_pal_dry+$20,$30		; 9 - SBZ1
			zonewarning Pal_Levels,8
ptr_Pal_Special:	palp	Pal_Special,v_pal_dry,$40		; $A (10) - special stage
ptr_Pal_LZWater:	palp	Pal_LZWater,v_pal_dry,$40		; $B (11) - LZ underwater
ptr_Pal_SBZ3:		palp	Pal_SBZ3,v_pal_dry+$20,$30		; $C (12) - SBZ3
ptr_Pal_SBZ3Water:	palp	Pal_SBZ3Water,v_pal_dry,$40		; $D (13) - SBZ3 underwater
ptr_Pal_SBZ2:		palp	Pal_SBZ2,v_pal_dry+$20,$30		; $E (14) - SBZ2
ptr_Pal_LZSonWater:	palp	Pal_LZSonWater,v_pal_dry,$10	; $F (15) - LZ Sonic underwater
ptr_Pal_SBZ3SonWat:	palp	Pal_SBZ3SonWat,v_pal_dry,$10	; $10 (16) - SBZ3 Sonic underwater
ptr_Pal_SSResult:	palp	Pal_SSResult,v_pal_dry,$40		; $11 (17) - special stage results
ptr_Pal_Continue:	palp	Pal_Continue,v_pal_dry,$20		; $12 (18) - special stage results continue
ptr_Pal_Ending:		palp	Pal_Ending,v_pal_dry,$40		; $13 (19) - ending sequence
ptr_Pal_Options:		palp	Pal_Options,v_pal_dry,$40		; $14 (20) - options screen
ptr_Pal_Sonic2:		palp	Pal_Sonic2,v_pal_dry,$10		; $15 (20) - Sonic (Sonic 1)
ptr_Pal_Sonic3:		palp	Pal_Sonic3,v_pal_dry,$10		; $16 (21) - Sonic (Beta)
ptr_Pal_Sonic4:		palp	Pal_Sonic4,v_pal_dry,$10		; $17 (22) - Sonic (Midnight)
ptr_Pal_Sonic5:		palp	Pal_Sonic5,v_pal_dry,$10		; $18 (23) - Sonic (C2)
ptr_Pal_Sonic6:		palp	Pal_Sonic6,v_pal_dry,$10		; $19 (24) - Sonic (Crackers)
ptr_Pal_Sonic7:		palp	Pal_Sonic7,v_pal_dry,$10		; $1A (25) - Sonic (RHS)
ptr_Pal_Sonic8:		palp	Pal_Sonic8,v_pal_dry,$10		; $1B (26) - Sonic (Socket)
ptr_Pal_Sonic9:		palp	Pal_Sonic9,v_pal_dry,$10		; $1C (27) - Sonic (Cringe)
ptr_Pal_Sonic10:		palp	Pal_Sonic10,v_pal_dry,$10		; $1D (28) - Sonic (Darker)
ptr_Pal_SonWater2:		palp	Pal_SonWater2,v_pal_dry,$10		; $15 (20) - Sonic Underwater (Sonic 1)
ptr_Pal_SonWater3:		palp	Pal_SonWater3,v_pal_dry,$10		; $16 (21) - Sonic Underwater (Beta)
ptr_Pal_SonWater4:		palp	Pal_SonWater4,v_pal_dry,$10		; $17 (22) - Sonic Underwater (Midnight)
ptr_Pal_SonWater5:		palp	Pal_SonWater5,v_pal_dry,$10		; $18 (23) - Sonic Underwater (C2)
ptr_Pal_SonWater6:		palp	Pal_SonWater6,v_pal_dry,$10		; $19 (24) - Sonic Underwater (Crackers)
ptr_Pal_SonWater7:		palp	Pal_SonWater7,v_pal_dry,$10		; $1A (25) - Sonic Underwater (RHS)
ptr_Pal_SonWater8:		palp	Pal_SonWater8,v_pal_dry,$10		; $1B (26) - Sonic Underwater (Socket)
ptr_Pal_SonWater9:		palp	Pal_SonWater9,v_pal_dry,$10		; $1C (27) - Sonic Underwater (Cringe)
ptr_Pal_SonWater10:		palp	Pal_SonWater10,v_pal_dry,$10		; $1D (28) - Sonic Underwater (Darker)

			even

PalPointers2:

; palette address, RAM address, colors
; Note, Uses Duplicate entries to ensure they are in the correct place, but they are not needed in the IDs
ptr_Pal_SegaBG_D:		palp	Pal_SegaBG,v_pal_dry,$40		; 0 - Sega logo
ptr_Pal_Title_D:		palp	Pal_Title,v_pal_dry,$40		; 1 - title screen
ptr_Pal_LevelSel_D:	palp	Pal_LevelSel,v_pal_dry,$40		; 2 - level select
ptr_Pal_SonicD:		palp	Pal_Sonic,v_pal_dry,$10		; 3 - Sonic
Pal_Levels_2:
ptr_Pal_GHZ2:		palp	Pal_GHZ2,v_pal_dry+$20, $30		; 4 - GHZ
ptr_Pal_LZ2:		palp	Pal_LZ2,v_pal_dry+$20,$30		; 5 - LZ
ptr_Pal_MZ2:		palp	Pal_MZ2,v_pal_dry+$20,$30		; 6 - MZ
ptr_Pal_SLZ2:		palp	Pal_SLZ2,v_pal_dry+$20,$30		; 7 - SLZ
ptr_Pal_SYZ2:		palp	Pal_SYZ2,v_pal_dry+$20,$30		; 8 - SYZ
ptr_Pal_SBZ1_D:		palp	Pal_SBZ1,v_pal_dry+$20,$30		; 9 - SBZ1
			zonewarning Pal_Levels_2,8
ptr_Pal_Special_D:	palp	Pal_Special,v_pal_dry,$40		; $A (10) - special stage
ptr_Pal_LZWatr2:	palp	Pal_LZWatr2,v_pal_dry,$40		; $B (11) - LZ underwater
ptr_Pal_SBZ3_D:		palp	Pal_SBZ3,v_pal_dry+$20,$30		; $C (12) - SBZ3
ptr_Pal_SBZ3Water_D:	palp	Pal_SBZ3Water,v_pal_dry,$40		; $D (13) - SBZ3 underwater
ptr_Pal_SBZ2_D:		palp	Pal_SBZ2,v_pal_dry+$20,$30		; $E (14) - SBZ2
ptr_Pal_LZSonWatr2:	palp	Pal_LZSonWatr2,v_pal_dry,$10	; $F (15) - LZ Sonic underwater
ptr_Pal_SBZ3SonWat_D:	palp	Pal_SBZ3SonWat,v_pal_dry,$10	; $10 (16) - SBZ3 Sonic underwater
ptr_Pal_SSResult_D:	palp	Pal_SSResult,v_pal_dry,$40		; $11 (17) - special stage results
ptr_Pal_Continue_D:	palp	Pal_Continue,v_pal_dry,$20		; $12 (18) - special stage results continue
ptr_Pal_Ending_D:		palp	Pal_Ending,v_pal_dry,$40		; $13 (19) - ending sequence
ptr_Pal_Sonic2_D:		palp	Pal_Sonic2,v_pal_dry,$10		; $15 (20) - Sonic (Sonic 1)
ptr_Pal_Sonic3_D:		palp	Pal_Sonic3,v_pal_dry,$10		; $16 (21) - Sonic (Beta)
ptr_Pal_Sonic4_D:		palp	Pal_Sonic4,v_pal_dry,$10		; $17 (22) - Sonic (Midnight)
ptr_Pal_Sonic5_D:		palp	Pal_Sonic5,v_pal_dry,$10		; $18 (23) - Sonic (C2)
ptr_Pal_Sonic6_D:		palp	Pal_Sonic6,v_pal_dry,$10		; $19 (24) - Sonic (Crackers)
ptr_Pal_Sonic7_D:		palp	Pal_Sonic7,v_pal_dry,$10		; $1A (25) - Sonic (RHS)
ptr_Pal_Sonic8_D:		palp	Pal_Sonic8,v_pal_dry,$10		; $1B (26) - Sonic (Socket)
ptr_Pal_Sonic9_D:		palp	Pal_Sonic9,v_pal_dry,$10		; $1C (27) - Sonic (Cringe)
ptr_Pal_Sonic10_D:		palp	Pal_Sonic10,v_pal_dry,$10		; $1D (28) - Sonic (Darker)
ptr_Pal_SonWater2_D:		palp	Pal_SonWater2,v_pal_dry,$10		; $15 (20) - Sonic Underwater (Sonic 1)
ptr_Pal_SonWater3_D:		palp	Pal_SonWater3,v_pal_dry,$10		; $16 (21) - Sonic Underwater (Beta)
ptr_Pal_SonWater4_D:		palp	Pal_SonWater4,v_pal_dry,$10		; $17 (22) - Sonic Underwater (Midnight)
ptr_Pal_SonWater5_D:		palp	Pal_SonWater5,v_pal_dry,$10		; $18 (23) - Sonic Underwater (C2)
ptr_Pal_SonWater6_D:		palp	Pal_SonWater6,v_pal_dry,$10		; $19 (24) - Sonic Underwater (Crackers)
ptr_Pal_SonWater7_D:		palp	Pal_SonWater7,v_pal_dry,$10		; $1A (25) - Sonic Underwater (RHS)
ptr_Pal_SonWater8_D:		palp	Pal_SonWater8,v_pal_dry,$10		; $1B (26) - Sonic Underwater (Socket)
ptr_Pal_SonWater9_D:		palp	Pal_SonWater9,v_pal_dry,$10		; $1C (27) - Sonic Underwater (Cringe)
ptr_Pal_SonWater10_D:		palp	Pal_SonWater10,v_pal_dry,$10		; $1D (28) - Sonic Underwater (Darker)
			even


palid_SegaBG:		equ (ptr_Pal_SegaBG-PalPointers)/8
palid_Title:		equ (ptr_Pal_Title-PalPointers)/8
palid_LevelSel:		equ (ptr_Pal_LevelSel-PalPointers)/8
palid_Sonic:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_GHZ:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_LZ:		equ (ptr_Pal_LZ-PalPointers)/8
palid_MZ:		equ (ptr_Pal_MZ-PalPointers)/8
palid_SLZ:		equ (ptr_Pal_SLZ-PalPointers)/8
palid_SYZ:		equ (ptr_Pal_SYZ-PalPointers)/8
palid_SBZ1:		equ (ptr_Pal_SBZ1-PalPointers)/8
palid_Special:		equ (ptr_Pal_Special-PalPointers)/8
palid_LZWater:		equ (ptr_Pal_LZWater-PalPointers)/8
palid_SBZ3:		equ (ptr_Pal_SBZ3-PalPointers)/8
palid_SBZ3Water:	equ (ptr_Pal_SBZ3Water-PalPointers)/8
palid_SBZ2:		equ (ptr_Pal_SBZ2-PalPointers)/8
palid_LZSonWater:	equ (ptr_Pal_LZSonWater-PalPointers)/8
palid_SBZ3SonWat:	equ (ptr_Pal_SBZ3SonWat-PalPointers)/8
palid_SSResult:		equ (ptr_Pal_SSResult-PalPointers)/8
palid_Continue:		equ (ptr_Pal_Continue-PalPointers)/8
palid_Ending:		equ (ptr_Pal_Ending-PalPointers)/8
palid_Options:		equ (ptr_Pal_Options-PalPointers)/8
palid_Sonic_D:		equ (ptr_Pal_Sonic-PalPointers)/8
palid_GHZ2:		equ (ptr_Pal_GHZ-PalPointers)/8
palid_LZ2:		equ (ptr_Pal_LZ-PalPointers)/8
palid_MZ2:		equ (ptr_Pal_MZ-PalPointers)/8
palid_SLZ2:		equ (ptr_Pal_SLZ-PalPointers)/8
palid_SYZ2:		equ (ptr_Pal_SYZ-PalPointers)/8
palid_LZWatr2:		equ (ptr_Pal_LZWatr2-PalPointers)/8
palid_LZSonWatr2:	equ (ptr_Pal_LZSonWater-PalPointers)/8
palid_Sonic2:		equ (ptr_Pal_Sonic2-PalPointers)/8
palid_Sonic3:		equ (ptr_Pal_Sonic3-PalPointers)/8
palid_Sonic4:		equ (ptr_Pal_Sonic4-PalPointers)/8
palid_Sonic5:		equ (ptr_Pal_Sonic5-PalPointers)/8
palid_Sonic6:		equ (ptr_Pal_Sonic6-PalPointers)/8
palid_Sonic7:		equ (ptr_Pal_Sonic7-PalPointers)/8
palid_Sonic8:		equ (ptr_Pal_Sonic8-PalPointers)/8
palid_Sonic9:		equ (ptr_Pal_Sonic9-PalPointers)/8
palid_Sonic10:		equ (ptr_Pal_Sonic10-PalPointers)/8
palid_SonWater2:		equ (ptr_Pal_SonWater2-PalPointers)/8
palid_SonWater3:		equ (ptr_Pal_SonWater3-PalPointers)/8
palid_SonWater4:		equ (ptr_Pal_SonWater4-PalPointers)/8
palid_SonWater5:		equ (ptr_Pal_SonWater5-PalPointers)/8
palid_SonWater6:		equ (ptr_Pal_SonWater6-PalPointers)/8
palid_SonWater7:		equ (ptr_Pal_SonWater7-PalPointers)/8
palid_SonWater8:		equ (ptr_Pal_SonWater8-PalPointers)/8
palid_SonWater9:		equ (ptr_Pal_SonWater9-PalPointers)/8
palid_SonWater10:		equ (ptr_Pal_SonWater10-PalPointers)/8