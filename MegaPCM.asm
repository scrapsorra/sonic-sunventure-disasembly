
; ===============================================================
; Mega PCM Driver Include File
; (c) 2012, Vladikcomper
; ===============================================================

; ---------------------------------------------------------------
; Variables used in DAC table
; ---------------------------------------------------------------

; flags
panLR	= $C0
panL	= $80
panR	= $40
pcm	= 0
dpcm	= 4
loop	= 2
pri	= 1

; ---------------------------------------------------------------
; Macros
; ---------------------------------------------------------------

z80word macro Value
	dc.w	((\Value)&$FF)<<8|((\Value)&$FF00)>>8
	endm

DAC_Entry macro Pitch,Offset,Flags
	dc.b	\Flags			; 00h	- Flags
	dc.b	\Pitch			; 01h	- Pitch
	dc.b	(\Offset>>15)&$FF	; 02h	- Start Bank
	dc.b	(\Offset\_End>>15)&$FF	; 03h	- End Bank
	z80word	(\Offset)|$8000		; 04h	- Start Offset (in Start bank)
	z80word	(\Offset\_End-1)|$8000	; 06h	- End Offset (in End bank)
	endm
	
IncludeDAC macro Name,Extension
\Name:
	if strcmp('\extension','wav')
		incbin	'dac/\Name\.\Extension\',$3A
	else
		incbin	'dac/\Name\.\Extension\'
	endc
\Name\_End:
	endm

; ---------------------------------------------------------------
; Driver's code
; ---------------------------------------------------------------

MegaPCM:
	incbin	'MegaPCM.z80'

; ---------------------------------------------------------------
; DAC Samples Table
; ---------------------------------------------------------------

	DAC_Entry	$18,	Kick, pcm			; $81 - Kick (Sonic 2)
    DAC_Entry	$09, 	Snare, pcm			; $82 - Snare (Sonic 2) (lower pitched)
	DAC_Entry   $04+2, 	KickS3, dpcm 		; $83 - Kick (Sonic 3K)
    DAC_Entry   $04+2, 	SnareS3, dpcm 		; $84 - Snare (Sonic 3K)
	DAC_Entry   $08+2, 	ClapS3, dpcm 		; $85 - Clap (Sonic 3K)	
	DAC_Entry   $06+2, 	CrashCymbalS3, dpcm	; $86 - Crash Cymbal (Sonic 3K)
    DAC_Entry   $04+2, 	KickSnare, dpcm 	; $87 - Muffled Snare (Sonic 3K)
	DAC_Entry	$12, 	Timpani, dpcm		; $88 - Hi-Timpani (Sonic 2)
	DAC_Entry	$15, 	Timpani, dpcm		; $89 - Mid-Timpani (Sonic 2)
	DAC_Entry	$1B, 	Timpani, dpcm		; $8A - Mid-Low-Timpani (Sonic 2)
	DAC_Entry	$1D, 	Timpani, dpcm		; $8B - Low-Timpani (Sonic 2)
    DAC_Entry   $03+2,	ElectricTom, dpcm 	; $8C - Electric High-Tom (Sonic 3K)
    DAC_Entry   $07+2,	ElectricTom, dpcm 	; $8D - Electric Mid-Tom (Sonic 3K)
    DAC_Entry   $0A+2,	ElectricTom, dpcm 	; $8E - Electric Low-Tom (Sonic 3K)
    DAC_Entry	$0E+2, 	ElectricTom, dpcm 	; $8F - Electric Floor Tom (Sonic 3K)
	DAC_Entry   $0E+2, 	TomS3, dpcm			; $90 - High-Tom (Sonic 3K)
	DAC_Entry   $14+2, 	TomS3, dpcm			; $91 - Mid-Tom (Sonic 3K)
	DAC_Entry   $1A+2, 	TomS3, dpcm			; $92 - Low-Tom (Sonic 3K)
	DAC_Entry   $20+2, 	TomS3, dpcm			; $93 - Floor Tom (Sonic 3K)
    DAC_Entry	$04,	TomS2, pcm        	; $94 - Mid-Tom (Sonic 2)
    DAC_Entry	$07, 	TomS2, pcm        	; $95 - Low-Tom (Sonic 2)
    DAC_Entry	$0A, 	TomS2, pcm        	; $96 - Floor-Tom (Sonic 2)	
	DAC_Entry   $04+2, 	Beat, dpcm	 		; $97 - Beat (Sonic Crackers)
    DAC_Entry   $04+2, 	SnareSC, dpcm 		; $98 - Snare (Sonic Crackers)	
    DAC_Entry   $06+2, 	TightSnare, dpcm 	; $99 - Tight Snare (Sonic 3K)
    DAC_Entry   $0A+2, 	TightSnare, dpcm 	; $9A - Mid-pitch Snare (Sonic 3K)
    DAC_Entry   $0D+2, 	TightSnare, dpcm 	; $9B - Loose Snare (Sonic 3K)
    DAC_Entry   $12+2, 	TightSnare, dpcm 	; $9C - Looser Snare (Sonic 3K)
MegaPCM_End:

; ---------------------------------------------------------------
; DAC Samples Files
; ---------------------------------------------------------------

	IncludeDAC	Kick, bin
	IncludeDAC	Snare, bin
	IncludeDAC	Timpani, bin
	IncludeDAC	KickS3, bin
	IncludeDAC	SnareS3, bin
	IncludeDAC	ClapS3, bin
	IncludeDAC	Beat, bin
	IncludeDAC	SnareSC, bin
	IncludeDAC	ElectricTom, bin	
	IncludeDAC	TomS3, bin		
	IncludeDAC	TomS2, bin	
	IncludeDAC	CrashCymbalS3, bin		
	IncludeDAC	KickSnare, bin		
	IncludeDAC	TightSnare, bin			
	even

