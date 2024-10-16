; =============================================================================================
; Created by Flamewing, based on S1SMPS2ASM version 1.1 by Marc Gordon (AKA Cinossu)
; =============================================================================================
SourceDriver = 1 ; Please don't modify the value.
; PSG conversion to S3/S&K/S3D drivers require a tone shift of 12 semi-tones.
psgdelta	EQU 12
; ---------------------------------------------------------------------------------------------
; Standard Octave Pitch Equates
smpsPitch10lo	EQU $88
smpsPitch09lo	EQU $94
smpsPitch08lo	EQU $A0
smpsPitch07lo	EQU $AC
smpsPitch06lo	EQU $B8
smpsPitch05lo	EQU $C4
smpsPitch04lo	EQU $D0
smpsPitch03lo	EQU $DC
smpsPitch02lo	EQU $E8
smpsPitch01lo	EQU $F4
smpsPitch00		EQU $00
smpsPitch01hi	EQU $0C
smpsPitch02hi	EQU $18
smpsPitch03hi	EQU $24
smpsPitch04hi	EQU $30
smpsPitch05hi	EQU $3C
smpsPitch06hi	EQU $48
smpsPitch07hi	EQU $54
smpsPitch08hi	EQU $60
smpsPitch09hi	EQU $6C
smpsPitch10hi	EQU $78
; ---------------------------------------------------------------------------------------------
; Note Equates
nRst		EQU	$80
nC0			EQU	$81
nCs0		EQU	$82
nD0			EQU	$83
nEb0		EQU	$84
nE0			EQU	$85
nF0			EQU	$86
nFs0		EQU	$87
nG0			EQU	$88
nAb0		EQU	$89
nA0			EQU	$8A
nBb0		EQU	$8B
nB0			EQU	$8C
nC1			EQU	$8D
nCs1		EQU	$8E
nD1			EQU	$8F
nEb1		EQU	$90
nE1			EQU	$91
nF1			EQU	$92
nFs1		EQU	$93
nG1			EQU	$94
nAb1		EQU	$95
nA1			EQU	$96
nBb1		EQU	$97
nB1			EQU	$98
nC2			EQU	$99
nCs2		EQU	$9A
nD2			EQU	$9B
nEb2		EQU	$9C
nE2			EQU	$9D
nF2			EQU	$9E
nFs2		EQU	$9F
nG2			EQU	$A0
nAb2		EQU	$A1
nA2			EQU	$A2
nBb2		EQU	$A3
nB2			EQU	$A4
nC3			EQU	$A5
nCs3		EQU	$A6
nD3			EQU	$A7
nEb3		EQU	$A8
nE3			EQU	$A9
nF3			EQU	$AA
nFs3		EQU	$AB
nG3			EQU	$AC
nAb3		EQU	$AD
nA3			EQU	$AE
nBb3		EQU	$AF
nB3			EQU	$B0
nC4			EQU	$B1
nCs4		EQU	$B2
nD4			EQU	$B3
nEb4		EQU	$B4
nE4			EQU	$B5
nF4			EQU	$B6
nFs4		EQU	$B7
nG4			EQU	$B8
nAb4		EQU	$B9
nA4			EQU	$BA
nBb4		EQU	$BB
nB4			EQU	$BC
nC5			EQU	$BD
nCs5		EQU	$BE
nD5			EQU	$BF
nEb5		EQU	$C0
nE5			EQU	$C1
nF5			EQU	$C2
nFs5		EQU	$C3
nG5			EQU	$C4
nAb5		EQU	$C5
nA5			EQU	$C6
nBb5		EQU	$C7
nB5			EQU	$C8
nC6			EQU	$C9
nCs6		EQU	$CA
nD6			EQU	$CB
nEb6		EQU	$CC
nE6			EQU	$CD
nF6			EQU	$CE
nFs6		EQU	$CF
nG6			EQU	$D0
nAb6		EQU	$D1
nA6			EQU	$D2
nBb6		EQU	$D3
nB6			EQU	$D4
nC7			EQU	$D5
nCs7		EQU	$D6
nD7			EQU	$D7
nEb7		EQU	$D8
nE7			EQU	$D9
nF7			EQU	$DA
nFs7		EQU	$DB
nG7			EQU	$DC
nAb7		EQU	$DD
nA7			EQU	$DE
nBb7		EQU	$DF
; SMPS2ASM uses nMaxPSG for songs from S1/S2 drivers.
; nMaxPSG1 and nMaxPSG2 are used only for songs from S3/S&K/S3D drivers.
; The use of psgdelta is intended to undo the effects of PSGPitchConvert
; and ensure that the ending note is indeed the maximum PSG frequency.
	if SourceDriver<=2
nMaxPSG				EQU nA5
nMaxPSG1			EQU nA5+psgdelta
nMaxPSG2			EQU nA5+psgdelta
	else
nMaxPSG				EQU nBb6-psgdelta
nMaxPSG1			EQU nBb6
nMaxPSG2			EQU nB6
	endif
; ---------------------------------------------------------------------------------------------
; PSG Flutter Equates
fTone_00	EQU	$00
fTone_01	EQU	$01
fTone_02	EQU	$02
fTone_03	EQU	$03
fTone_04	EQU	$04
fTone_05	EQU	$05
fTone_06	EQU	$06
fTone_07	EQU	$07
fTone_08	EQU	$08
fTone_09	EQU	$09
fTone_0A	EQU	$07
fTone_0B	EQU	$05
fTone_0C	EQU	$00
;fTone_0D	EQU	$00
sTone_01	EQU	$02
sTone_02	EQU	$0E
sTone_03	EQU	$05
sTone_04	EQU	$0B
sTone_05	EQU	$10
sTone_06	EQU	$03
sTone_07	EQU	$00	; SFX envelope, probably unused in S3K
sTone_08	EQU	$09
sTone_09	EQU	$05
sTone_0A	EQU	$11
sTone_0B	EQU	$00	; For FM volume envelopes
sTone_0C	EQU	$09
sTone_0D	EQU	$00	; This time it matches 100%
sTone_0E	EQU	$02	; Duplicate of 01
sTone_0F	EQU	$0E	; Duplicate of 02
sTone_10	EQU	$00
sTone_11	EQU	$0F
sTone_12	EQU	$10	; Duplicate of 05
sTone_13	EQU	$03	; Duplicate of 06
sTone_14	EQU	$00	; SFX envelope, probably unused in S3K
sTone_15	EQU	$09	; Duplicate of 08
sTone_16	EQU	$05	; Duplicate of 09
sTone_17	EQU	$11	; Duplicate of 0A
sTone_18	EQU	$00	; For FM volume envelopes
sTone_19	EQU	$09	; Duplicate of 0C
sTone_1A	EQU	$02
sTone_1B	EQU	$09	; Duplicate of 0C
sTone_1C	EQU	$06
sTone_1D	EQU	$0A
sTone_1E	EQU	$02
sTone_1F	EQU	$04
sTone_20	EQU	$00	; This time it matches 100%
sTone_21	EQU	$09
sTone_22	EQU	$04
sTone_23	EQU	$0C
sTone_24	EQU	$02
sTone_25	EQU	$09
sTone_26	EQU	$0D
sTone_27	EQU	$0E
;sTone_28	EQU	$09
; ---------------------------------------------------------------------------------------------
; DAC Equates
dKick equ $81
dSnare equ $82
dKickS3 equ $83
dSnareS3 equ $84
dClapS3 equ $85
dCrashCymbal equ $86
dMuffledSnare equ $87
dHiTimpani equ $88
dMidTimpani equ $89
dLowTimpani equ $8A
dFloorTimpani equ $8B
dElectricHighTom equ $8C
dElectricMidTom equ $8D
dElectricLowTom equ $8E
dElectricFloorTom equ $8F
dHighTom equ $90
dMidTomS3 equ $91
dLowTomS3 equ $92
dFloorTomS3 equ $93
dMidTom equ $94
dLowTom equ $95
dFloorTom equ $96
dBeat equ $97
dSnareSC equ $98
dTightSnare equ $99
dMidpitchSnare equ $9A
dLooseSnare equ $9B
dLooserSnare equ $9C
; ---------------------------------------------------------------------------------------------
; Channel IDs for SFX
cPSG1				EQU $80
cPSG2				EQU $A0
cPSG3				EQU $C0
cNoise				EQU $E0	; Not for use in S3/S&K/S3D
cFM3				EQU $02
cFM4				EQU $04
cFM5				EQU $05
cFM6				EQU $06	; Only in S3/S&K/S3D, overrides DAC
; ---------------------------------------------------------------------------------------------
; Conversion macros and functions

;conv0To256  macro val 
	;if val<$01
		;dc.b (256-val+$FF)&$FF
	;else	
		;dc.b (256-val)&$FF	
	;endc
	;endm
; ---------------------------------------------------------------------------------------------
; Header Macros
smpsHeaderStartSong macro ver
SourceDriver set ver
songStart set *
	endm

smpsHeaderStartSongConvert macro ver
SourceDriver set ver
songStart set *
	endm

smpsHeaderVoiceNull macro
	if songStart<>*
		fatal "Missing smpsHeaderStartSong or smpsHeaderStartSongConvert"
	endif
	dc.w	$0000
	endm

; Header - Set up Voice Location
; Common to music and SFX
smpsHeaderVoice macro loc
	if songStart<>*
		fatal "Missing smpsHeaderStartSong or smpsHeaderStartSongConvert"
	endif
	dc.w	loc-songStart
	endm

; Header macros for music (not for SFX)
; Header - Set up Channel Usage
smpsHeaderChan macro fm,psg
	dc.b	fm,psg
	endm

; Header - Set up Tempo
smpsHeaderTempo macro div,mod
	dc.b	div
tempoDivider set div
	dc.b    mod
	endm

; Header - Set up DAC Channel
smpsHeaderDAC macro loc,pitch,vol
	dc.w	loc-songStart
	if (narg=2)
		dc.b	pitch
		if (narg=3)
			dc.b	vol
		else
			dc.b	$00
		endif
	else
		dc.w	$00
	endif
	endm

; Header - Set up FM Channel
smpsHeaderFM macro loc,pitch,vol
	dc.w	loc-songStart
	dc.b	pitch,vol
	endm

; Header - Set up PSG Channel
smpsHeaderPSG macro loc,pitch,vol,mod,voice
	dc.w	loc-songStart
	if SourceDriver>=3
		dc.b	(pitch-psgdelta)&$FF
	else
		dc.b	pitch
	endif
	dc.b	vol,mod,voice
	endm

; Header macros for SFX (not for music)
; Header - Set up Tempo
smpsHeaderTempoSFX macro div
	dc.b	div
	endm

; Header - Set up Channel Usage
smpsHeaderChanSFX macro chan
	dc.b	chan
	endm

; Header - Set up FM Channel
smpsHeaderSFXChannel macro chanid,loc,pitch,vol
	if (chanid=cNoise)
		fatal "Using channel ID of FM6 ($06) in Sonic 1 or Sonic 2 drivers is unsupported. Change it to another channel."
	endif
	dc.b	$80,chanid
	dc.w	loc-songStart
	if (chanid&$80)<>0
	if SourceDriver>=3
		dc.b	(pitch-psgdelta)&$FF
	else
		dc.b	pitch
	endif
	else
		dc.b	pitch
	endif
	dc.b	vol
	endm
; ---------------------------------------------------------------------------------------------
; Co-ord Flag Macros and Equates
; E0xx - Panning, AMS, FMS
smpsPan macro direction,amsfms
panNone set $00
panRight set $40
panLeft set $80
panCentre set $C0
panCenter set $C0 ; silly Americans :U
	dc.b $E0,direction+amsfms
	endm

; E1xx - Set channel frequency displacement to xx
smpsAlterNote macro val
	dc.b	$E1,val
	endm

smpsDetune macro val
	dc.b		$E1, val
	endm

; E2xx - Useless
smpsNop macro val
	dc.b	$E2,val
	endm

; Return (used after smpsCall)
smpsReturn macro val
	dc.b	$E3
	endm

; Fade in previous song (ie. 1-Up)
smpsFade macro val
	dc.b	$E4
	endm

; E5xx - Set channel tempo divider to xx
smpsChanTempoDiv macro val
	dc.b	$E5,val
	endm

; E6xx - Alter Volume by xx
smpsAlterVol macro val
	dc.b	$E6,val
	endm
sVol	EQU $E6

; E7 - Prevent attack of next note
smpsNoAttack	EQU $E7
smpsNA	EQU smpsNoAttack
sNA	EQU smpsNoAttack

; E8xx - Set note fill to xx
smpsNoteFill macro val
	dc.b	$E8,val
	endm

; Add xx to channel pitch
smpsAlterPitch macro val
	dc.b	$E9,val
	endm

smpsChangeTransposition macro val
	if SourceDriver>=3
		dc.b	$FF,val
	else
		dc.b	$E9,val
	endif
	endm

; Set music tempo modifier to xx
smpsSetTempoMod macro val
	dc.b	$EA
	dc.b    val
	endm

; Set music tempo divider to xx
smpsSetTempoDiv macro val
	dc.b	$EB,val
	endm

; ECxx - Set Volume to xx
smpsSetVol macro val
	fatal "Coord. Flag to set volume (instead of volume attenuation) does not exist in S1 or S2 drivers. Complain to Flamewing to add it."
	endm

; Works on all drivers
smpsPSGAlterVol macro vol
	dc.b	$EC,vol
	endm
spVol	EQU $EC

; Clears pushing sound flag in S1
smpsClearPush macro
	dc.b	$ED
	endm

; Stops special SFX (S1 only) and restarts overridden music track
smpsStopSpecial macro
	dc.b	$EE
	endm

; EFxx[yy] - Set Voice of FM channel to xx; xx < 0 means yy present
smpsSetvoice macro voice,songID
	dc.b	$EF,voice
	endm

; EFxx - Set Voice of FM channel to xx
smpsFMvoice macro voice
	dc.b	$EF,voice
	endm

; F0wwxxyyzz - Modulation - ww: wait time - xx: modulation speed - yy: change per step - zz: number of steps
smpsModSet macro wait,speed,change,step
	dc.b	$F0
	if SourceDriver>=3
		dc.b	wait+1,speed,change,(step*speed-1)&$FF
	else
		dc.b	wait,speed,change,step
	endif
	;dc.b	speed,change,step
	endm

; Turn on Modulation
smpsModOn macro
	dc.b	$F1
	endm

; F2 - End of channel
smpsStop macro
	dc.b	$F2
	endm

; F3xx - PSG waveform to xx
smpsPSGform macro form
	dc.b	$F3,form
	endm

; Turn off Modulation
smpsModOff macro
	dc.b	$F4
	endm

; F5xx - PSG voice to xx
smpsPSGvoice macro voice
	dc.b	$F5,voice
	endm

; F6xxxx - Jump to xxxx
smpsJump macro loc
	dc.b	$F6
	dc.w	loc-*-1
	endm

; F7xxyyzzzz - Loop back to zzzz yy times, xx being the loop index for loop recursion fixing
smpsLoop macro index,loops,loc
	dc.b	$F7
	dc.b	index,loops
	dc.w	loc-*-1
	endm

; F8xxxx - Call pattern at xxxx, saving return point
smpsCall macro loc
	dc.b	$F8
	dc.w	loc-*-1
	endm
; ---------------------------------------------------------------------------------------------
; Alter Volume
smpsFMAlterVol macro val1,val2
	dc.b	$E6,val1
	endm

; ---------------------------------------------------------------------------------------------
; S1/S2 only coordination flag
; Sets D1L to maximum volume (minimum attenuation) and RR to maximum for operators 3 and 4 of FM1
smpsWeirdD1LRR macro
	dc.b	$F9
	endm
; ---------------------------------------------------------------------------------------------
; Macros for FM instruments
; Voices - Feedback
smpsVcFeedback macro val
vcFeedback set val
	endm

; Voices - Algorithm
smpsVcAlgorithm macro val
vcAlgorithm set val
	endm

smpsVcUnusedBits macro val
vcUnusedBits set val
	endm

; Voices - Detune
smpsVcDetune macro op1,op2,op3,op4
vcDT1 set op1
vcDT2 set op2
vcDT3 set op3
vcDT4 set op4
	endm

; Voices - Coarse-Frequency
smpsVcCoarseFreq macro op1,op2,op3,op4
vcCF1 set op1
vcCF2 set op2
vcCF3 set op3
vcCF4 set op4
	endm

; Voices - Rate Scale
smpsVcRateScale macro op1,op2,op3,op4
vcRS1 set op1
vcRS2 set op2
vcRS3 set op3
vcRS4 set op4
	endm

; Voices - Attack Rate
smpsVcAttackRate macro op1,op2,op3,op4
vcAR1 set op1
vcAR2 set op2
vcAR3 set op3
vcAR4 set op4
	endm

; Voices - Amplitude Modulation
smpsVcAmpMod macro op1,op2,op3,op4
vcAM1 set op1
vcAM2 set op2
vcAM3 set op3
vcAM4 set op4
	endm

; Voices - First Decay Rate
smpsVcDecayRate1 macro op1,op2,op3,op4
vcD1R1 set op1
vcD1R2 set op2
vcD1R3 set op3
vcD1R4 set op4
	endm

; Voices - Second Decay Rate
smpsVcDecayRate2 macro op1,op2,op3,op4
vcD2R1 set op1
vcD2R2 set op2
vcD2R3 set op3
vcD2R4 set op4
	endm

; Voices - Decay Level
smpsVcDecayLevel macro op1,op2,op3,op4
vcDL1 set op1
vcDL2 set op2
vcDL3 set op3
vcDL4 set op4
	endm

; Voices - Release Rate
smpsVcReleaseRate macro op1,op2,op3,op4
vcRR1 set op1
vcRR2 set op2
vcRR3 set op3
vcRR4 set op4
	endm

; Voices - Total Level
smpsVcTotalLevel macro op1,op2,op3,op4
vcTL1 set op1
vcTL2 set op2
vcTL3 set op3
vcTL4 set op4
	dc.b	(vcUnusedBits<<6)+(vcFeedback<<3)+vcAlgorithm
	dc.b	(vcDT4<<4)+vcCF4, (vcDT3<<4)+vcCF3, (vcDT2<<4)+vcCF2, (vcDT1<<4)+vcCF1
	dc.b	(vcRS4<<6)+vcAR4, (vcRS3<<6)+vcAR3, (vcRS2<<6)+vcAR2, (vcRS1<<6)+vcAR1
	dc.b	(vcAM4<<5)+vcD1R4, (vcAM3<<5)+vcD1R3, (vcAM2<<5)+vcD1R2, (vcAM1<<5)+vcD1R1
	dc.b	vcD2R4, vcD2R3, vcD2R2, vcD2R1
	dc.b	(vcDL4<<4)+vcRR4, (vcDL3<<4)+vcRR3, (vcDL2<<4)+vcRR2, (vcDL1<<4)+vcRR1
	;dc.b	vcTL4|vcTLMask4, vcTL3|vcTLMask3, vcTL2|vcTLMask2, vcTL1|vcTLMask1
	if vcAlgorithm=7
		dc.b	op4|$80
	else
		dc.b	op4
	endif

	if vcAlgorithm>=4
		dc.b    op3|$80
	else
		dc.b    op3
	endif

	if vcAlgorithm>=5
		dc.b    op2|$80
	else
		dc.b    op2
	endif
		dc.b    op1|$80
	endm

