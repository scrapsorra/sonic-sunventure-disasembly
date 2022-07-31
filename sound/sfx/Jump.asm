SndA0_Jump_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     SndA0_Jump_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $01

	smpsHeaderSFXChannel cPSG2, SndA0_Jump_PSG2,	$F4, $00

; PSG2 Data
SndA0_Jump_PSG2:
	smpsPSGvoice        $00
	dc.b	nF2, $05
	smpsModSet          $00, $01, $F8, $64
	dc.b	nBb2, $15
	smpsStop

; Song seems to not use any FM voices
SndA0_Jump_Voices:
