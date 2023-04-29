KCinv_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     KCinv_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $75

	smpsHeaderDAC       KCinv_DAC,	$00, $BB
	smpsHeaderFM        KCinv_FM1,	$00, $0D
	smpsHeaderFM        KCinv_FM2,	$00, $11
	smpsHeaderFM        KCinv_FM3,	$00, $11
	smpsHeaderFM        KCinv_FM4,	$00, $16
	smpsHeaderFM        KCinv_FM5,	$00, $16
	smpsHeaderPSG       KCinv_PSG1,	$00, $08, $00, sTone_0C
	smpsHeaderPSG       KCinv_PSG2,	$F4, $07, $00, sTone_0C
	smpsHeaderPSG       KCinv_PSG3,	$23+$0C, $06, $00, fTone_02

; FM1 Data
KCinv_FM1:
	smpsSetvoice        $00
	dc.b	nRst, $18

KCinv_Jump03:
	smpsCall            KCinv_Call05
	smpsCall            KCinv_Call05
	smpsAlterPitch      $FF
	smpsCall            KCinv_Call05
	smpsAlterPitch      $05
	smpsCall            KCinv_Call05
	smpsAlterPitch      $FC
	smpsCall            KCinv_Call05
	smpsCall            KCinv_Call05
	smpsAlterPitch      $FF
	smpsCall            KCinv_Call05
	smpsAlterPitch      $01
	dc.b	nRst, $12, nD3, $03, nRst
	smpsCall            KCinv_Call05
	smpsCall            KCinv_Call05
	smpsAlterPitch      $FF
	smpsCall            KCinv_Call05
	smpsAlterPitch      $05
	smpsCall            KCinv_Call05
	smpsAlterPitch      $FC
	smpsCall            KCinv_Call05
	smpsAlterPitch      $05
	smpsCall            KCinv_Call05
	smpsAlterPitch      $FD
	smpsCall            KCinv_Call05
	smpsCall            KCinv_Call05
	smpsAlterPitch      $FE
	smpsJump            KCinv_Jump03

KCinv_Call05:
	dc.b	nBb1, $06, nBb2, $03, nRst, nBb1, $06, nBb2, $03, nRst
	smpsReturn

; FM2 Data
KCinv_FM2:
	smpsSetvoice        $02
	dc.b	nRst, $18

KCinv_Jump02:
	smpsCall            KCinv_Call04
	dc.b	smpsNoAttack, $03
	smpsFMAlterVol      $0A
	smpsPan             panCenter, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$03
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nA3, nG3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $06
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nD4, $06
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nC4, $06, smpsNoAttack, $18
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, $15
	smpsCall            KCinv_Call04
	dc.b	smpsNoAttack, $03
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nBb3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nA3, nG3
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $06
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nD3, $06
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nF3, $06, smpsNoAttack, $06, nG3, $27
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	smpsJump            KCinv_Jump02

KCinv_Call04:
	dc.b	nRst, $06, nA3, $03
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3, nA3
	smpsFMAlterVol      $0A
	smpsPan             panCenter, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nC4, $06, nA3, $03, nC4
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nD4, $06, nA3, $03
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nE4, $09, nF4, $03
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nC4, $12
	smpsFMAlterVol      $0A
	smpsPan             panLeft, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nBb3, $06
	smpsReturn

; FM3 Data
KCinv_FM3:
	smpsSetvoice        $02
	dc.b	nRst, $18

KCinv_Jump01:
	smpsCall            KCinv_Call03
	dc.b	smpsNoAttack, $03
	smpsFMAlterVol      $0A
	smpsPan             panCenter, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	$03
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nE3, nD3
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nD3, $06
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $06
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nG3, $06, smpsNoAttack, $06, nA3, $12
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, $15
	smpsCall            KCinv_Call03
	dc.b	smpsNoAttack, $03
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nE3, nD3
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nBb2, $06
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nBb2, $06
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nC3, $06, smpsNoAttack, $2D
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	smpsJump            KCinv_Jump01

KCinv_Call03:
	dc.b	nRst, $06, nF3, $03
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nE3, nF3
	smpsFMAlterVol      $0A
	smpsPan             panCenter, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nF3, $06, nF3, $03, nF3
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3, $06, nE3, $03
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nG3, $09, $03
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nA3, $12
	smpsFMAlterVol      $0A
	smpsPan             panRight, $00
	dc.b	$03
	smpsFMAlterVol      $F6
	smpsPan             panCenter, $00
	dc.b	nRst, nF3, $06
	smpsReturn

; FM4 Data
KCinv_FM4:
	smpsSetvoice        $01
	dc.b	nRst, $18

KCinv_Loop02:
	smpsCall            KCinv_Call02
	smpsLoop            $00, $08, KCinv_Loop02
	smpsJump            KCinv_Loop02

KCinv_Call02:
	dc.b	nRst, $06, nF4
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nE4, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nD4, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nC4, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nD4, $06
	smpsReturn

; FM5 Data
KCinv_FM5:
	smpsSetvoice        $01
	smpsPan             panRight, $00
	dc.b	nRst, $18

KCinv_Loop01:
	smpsCall            KCinv_Call01
	smpsLoop            $00, $06, KCinv_Loop01
	dc.b	nRst, $06, nD4
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nC4, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nBb3, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nA3, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nBb3, $06
	smpsCall            KCinv_Call01
	smpsJump            KCinv_Loop01

KCinv_Call01:
	dc.b	nRst, $06, nD4
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nC4, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nA3, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nA3, $06
	smpsFMAlterVol      $0A
	dc.b	$03
	smpsFMAlterVol      $F6
	dc.b	nA3, $06
	smpsReturn


; PSG1 Data
KCinv_PSG1:
	smpsPSGvoice        $0D+$02
	dc.b	nRst, $18

KCinv_Loop07:
	smpsCall            KCinv_Call07
	smpsLoop            $00, $12, KCinv_Loop07
	dc.b	nF3, $03, nF3, nRst, $18

KCinv_Loop08:
	smpsCall            KCinv_Call07
	smpsLoop            $00, $15, KCinv_Loop08
	dc.b	nF3, $03
	smpsJump            KCinv_Loop07

KCinv_Call07:
	dc.b	nF3, $03, nF3, nF2
	smpsReturn

; PSG2 Data
KCinv_PSG2:
	smpsPSGvoice        $0D+$02
	dc.b	nRst, $18

KCinv_Loop05:
	smpsCall            KCinv_Call07
	smpsLoop            $00, $12, KCinv_Loop05
	dc.b	nF3, $03, nF3, nRst, $18

KCinv_Loop06:
	smpsCall            KCinv_Call07
	smpsLoop            $00, $15, KCinv_Loop06
	dc.b	nF3, $03
	smpsJump            KCinv_Loop05

; PSG3 Data
KCinv_PSG3:
	smpsPSGform         $E7
	smpsCall            KCinv_Call06

KCinv_Loop03:
	smpsCall            KCinv_Call06
	smpsLoop            $01, $07, KCinv_Loop03
	smpsPSGvoice        $0D+$02
	dc.b	(nMaxPSG2-$23)&$FF, $03, nRst, $0F
	smpsPSGvoice        $0D+$05
	dc.b	$06

KCinv_Loop04:
	smpsCall            KCinv_Call06
	smpsLoop            $01, $08, KCinv_Loop04
	smpsJump            KCinv_Loop03

KCinv_Call06:
	smpsPSGvoice        $0D+$02
	dc.b	(nMaxPSG2-$23)&$FF, $03, $03
	smpsPSGvoice        $0D+$05
	dc.b	$06
	smpsLoop            $00, $02, KCinv_Call06
	smpsReturn

; DAC Data
KCinv_DAC:
	dc.b	dSnareS3, $03
	smpsFMAlterVol      $F9
	dc.b	dSnareS3
	smpsFMAlterVol      $07
	dc.b	dSnareS3, dSnareS3
	smpsFMAlterVol      $F9
	dc.b	dSnareS3
	smpsFMAlterVol      $07
	smpsFMAlterVol      $90
	dc.b	dSnareS3, dSnareS3
	smpsFMAlterVol      $70
	dc.b	dSnareS3

KCinv_DAC_Jump00:
	dc.b	dCrashCymbal, $0C, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, $09, $03, dKickS3
	dc.b	$0C, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, $15, dSnareS3, $03, dCrashCymbal, $0C
	dc.b	dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, $09, $03, dKickS3, $0C, dSnareS3
	dc.b	dKickS3, dSnareS3, dKickS3, dSnareS3, dKickS3, dSnareS3, $09, $03
	smpsJump           KCinv_DAC_Jump00

KCinv_Voices:
;	Voice $00
;	$3C
;	$01, $03, $00, $00, 	$1F, $1F, $15, $1F, 	$11, $0D, $10, $05
;	$07, $04, $09, $02, 	$55, $1A, $55, $1A, 	$0E, $80, $08, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $03, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $15, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $10, $0D, $11
	smpsVcDecayRate2    $02, $09, $04, $07
	smpsVcDecayLevel    $01, $05, $01, $05
	smpsVcReleaseRate   $0A, $05, $0A, $05
	smpsVcTotalLevel    $00, $08, $00, $0E

;	Voice $01
;	$33
;	$11, $08, $11, $02, 	$5F, $9F, $5F, $1F, 	$0B, $0F, $02, $09
;	$10, $13, $13, $10, 	$05, $15, $25, $3A, 	$0A, $1D, $09, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $01, $00, $01
	smpsVcCoarseFreq    $02, $01, $08, $01
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $02, $0F, $0B
	smpsVcDecayRate2    $10, $13, $13, $10
	smpsVcDecayLevel    $03, $02, $01, $00
	smpsVcReleaseRate   $0A, $05, $05, $05
	smpsVcTotalLevel    $00, $09, $1D, $0A

;	Voice $02
;	$3D
;	$02, $02, $01, $02, 	$94, $19, $19, $19, 	$0F, $0D, $0D, $0D
;	$07, $04, $04, $04, 	$25, $1A, $1A, $1A, 	$14, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $02, $02
	smpsVcRateScale     $00, $00, $00, $02
	smpsVcAttackRate    $19, $19, $19, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $0D, $0D, $0F
	smpsVcDecayRate2    $04, $04, $04, $07
	smpsVcDecayLevel    $01, $01, $01, $02
	smpsVcReleaseRate   $0A, $0A, $0A, $05
	smpsVcTotalLevel    $00, $00, $00, $14

