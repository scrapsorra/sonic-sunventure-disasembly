extralifejingle_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     extralifejingle_Voices
	smpsHeaderChan      $07, $03
	smpsHeaderTempo     $01, $00

	smpsHeaderDAC       extralifejingle_DAC,	$00, $F2
	smpsHeaderFM        extralifejingle_FM1,	$00, $00
	smpsHeaderFM        extralifejingle_FM2,	$00, $00
	smpsHeaderFM        extralifejingle_FM3,	$00, $00
	smpsHeaderFM        extralifejingle_FM4,	$00, $00
	smpsHeaderFM        extralifejingle_FM5,	$00, $00
	smpsHeaderFM        extralifejingle_FM6,	$00, $00
	smpsHeaderPSG       extralifejingle_PSG1,	$00, $00, $00, $00
	smpsHeaderPSG       extralifejingle_PSG2,	$00, $00, $00, $00
	smpsHeaderPSG       extralifejingle_PSG3,	$00, $00, $00, $00

; DAC Data
extralifejingle_DAC:
	dc.b	nRst, $7F, $55
	smpsFade
; PSG1 Data
extralifejingle_PSG1:
; PSG2 Data
extralifejingle_PSG2:
; PSG3 Data
extralifejingle_PSG3:
	smpsStop

; FM1 Data
extralifejingle_FM1:
	smpsSetvoice        $00
	smpsAlterVol        $16
	smpsPan             panCenter, $00
	dc.b	nCs3, $1A, nB4, $13, nBb4, $12, nAb4, $13, nF4, $0D, nG3, $2C
	dc.b	nG3, $06, nRst, $0C
	smpsStop

; FM2 Data
extralifejingle_FM2:
	smpsSetvoice        $01
	smpsAlterVol        $16
	smpsPan             panCenter, $00
	dc.b	nF4, $1A, nAb3, $13, nFs3, $12, nF3, $13, nCs3, $0D, nA2, $2C
	dc.b	nA2, $06, nRst, $0C
	smpsStop

; FM3 Data
extralifejingle_FM3:
	smpsSetvoice        $01
	smpsAlterVol        $16
	smpsPan             panCenter, $00
	dc.b	nAb3, $0D, nB4, $13, nAb4, nFs4, nF4, $0C, nCs4, $0D, nC4, $2C
	dc.b	nC4, $06, nRst, $0C
	smpsStop

; FM4 Data
extralifejingle_FM4:
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	dc.b	nRst, $01
	smpsAlterVol        $16
	dc.b	nCs5, $0C, nAb4, $13, nFs3, nF3, nCs3, $0C, nA2, $0D, nE5, $2C
	dc.b	nE5, $06, nRst, $0C
	smpsStop

; FM5 Data
extralifejingle_FM5:
	smpsSetvoice        $03
	smpsAlterVol        $02
	smpsPan             panCenter, $00
	dc.b	nRst, $01
	smpsSetvoice        $05
	smpsAlterVol        $0A
	dc.b	smpsNoAttack, nRst, $0C, nB5, $06, nCs4, $07, nAb4, $06, nBb5, nCs4, $07
	dc.b	nFs4, $06, nAb5, nB5, nF4, $07, nF5, $06, nCs4, nCs5, $07, nA5
	dc.b	$06, nC5, nE5, nG5, $07, nC5, $06, nE5, nG5, $07, nC5, $06
	dc.b	nE5, nG5, nRst
	smpsStop

; FM6 Data
extralifejingle_FM6:
	smpsSetvoice        $04
	smpsAlterVol        $07
	smpsPan             panCenter, $00
	dc.b	nRst, $01
	smpsSetvoice        $06
	smpsAlterVol        $F9
	dc.b	nCs3, $58, nD3, $2C, nD3, $0C, nRst
	smpsStop

extralifejingle_Voices:
;	Voice $00
;	$3A
;	$34, $73, $74, $31, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $1F, $1F
;	$00, $00, $00, $00, 	$03, $03, $03, $05, 	$22, $22, $22, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $03
	smpsVcCoarseFreq    $01, $04, $03, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $05, $03, $03, $03
	smpsVcTotalLevel    $00, $22, $22, $22

;	Voice $01
;	$3A
;	$34, $73, $74, $31, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $1F, $1F
;	$00, $00, $00, $00, 	$03, $03, $03, $05, 	$22, $22, $22, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $03
	smpsVcCoarseFreq    $01, $04, $03, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $05, $03, $03, $03
	smpsVcTotalLevel    $00, $22, $22, $22

;	Voice $02
;	$3A
;	$34, $73, $74, $31, 	$1F, $1F, $1F, $1F, 	$1F, $1F, $1F, $1F
;	$00, $00, $00, $00, 	$03, $03, $03, $05, 	$22, $22, $22, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $07, $07, $03
	smpsVcCoarseFreq    $01, $04, $03, $04
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $1F, $1F, $1F
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $05, $03, $03, $03
	smpsVcTotalLevel    $00, $22, $22, $22

;	Voice $03
;	$00
;	$01, $0E, $00, $00, 	$1E, $1E, $1E, $1D, 	$1A, $1C, $10, $10
;	$00, $00, $00, $00, 	$FD, $FE, $F8, $F8, 	$1A, $25, $05, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $0E, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1D, $1E, $1E, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $10, $10, $1C, $1A
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0F, $0F, $0F
	smpsVcReleaseRate   $08, $08, $0E, $0D
	smpsVcTotalLevel    $00, $05, $25, $1A

;	Voice $04
;	$03
;	$66, $40, $40, $31, 	$1F, $1F, $1F, $1C, 	$0E, $05, $02, $01
;	$01, $00, $04, $06, 	$AA, $6A, $16, $18, 	$2A, $1A, $20, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $04, $04, $06
	smpsVcCoarseFreq    $01, $00, $00, $06
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1C, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $02, $05, $0E
	smpsVcDecayRate2    $06, $04, $00, $01
	smpsVcDecayLevel    $01, $01, $06, $0A
	smpsVcReleaseRate   $08, $06, $0A, $0A
	smpsVcTotalLevel    $00, $20, $1A, $2A

;	Voice $05
;	$34
;	$33, $7E, $01, $74, 	$9B, $1F, $5F, $1F, 	$14, $07, $07, $08
;	$00, $00, $00, $00, 	$F6, $E4, $F7, $F7, 	$19, $71, $00, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $00, $07, $03
	smpsVcCoarseFreq    $04, $01, $0E, $03
	smpsVcRateScale     $00, $01, $00, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $07, $07, $14
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0F, $0E, $0F
	smpsVcReleaseRate   $07, $07, $04, $06
	smpsVcTotalLevel    $00, $00, $71, $19

;	Voice $06
;	$30
;	$01, $00, $00, $01, 	$9F, $1F, $1F, $5C, 	$0F, $0D, $10, $14
;	$08, $18, $05, $08, 	$6F, $00, $0F, $18, 	$15, $1F, $19, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $00, $00, $01
	smpsVcRateScale     $01, $00, $00, $02
	smpsVcAttackRate    $1C, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $14, $10, $0D, $0F
	smpsVcDecayRate2    $08, $05, $18, $08
	smpsVcDecayLevel    $01, $00, $00, $06
	smpsVcReleaseRate   $08, $0F, $00, $0F
	smpsVcTotalLevel    $00, $19, $1F, $15

