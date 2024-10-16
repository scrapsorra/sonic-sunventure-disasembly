SignpostCD_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Snd9D_Voices
	smpsHeaderTempoSFX  $01
	smpsHeaderChanSFX   $02

	smpsHeaderSFXChannel cFM5, Snd9D_FM5,	$27, $03
	smpsHeaderSFXChannel cFM4, Snd9D_FM4,	$27, $00

; FM5 Data
Snd9D_FM5:
	dc.b	nRst, $04

; FM4 Data
Snd9D_FM4:
	smpsSetvoice        $00

Snd9D_Loop00:
	dc.b	nEb4, $05
	smpsFMAlterVol      $04
	smpsLoop            $00, $08, Snd9D_Loop00
	smpsStop

Snd9D_Voices:
;	Voice $00
;	$F4
;	$06, $04, $0F, $0E, 	$1F, $1F, $1F, $1F, 	$00, $00, $0B, $0B
;	$00, $00, $05, $08, 	$0F, $0F, $FF, $FF, 	$0C, $85, $00, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $03
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $0E, $0F, $04, $06
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0B, $0B, $00, $00
	smpsVcDecayRate2    $08, $05, $00, $00
	smpsVcDecayLevel    $0F, $0F, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $80, $00, $85, $0C
