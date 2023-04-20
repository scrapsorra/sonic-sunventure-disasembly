EmeraldForest_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     EmeraldForest_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $00

	smpsHeaderDAC       EmeraldForest_DAC
	smpsHeaderFM        EmeraldForest_FM1,	$00, $11
	smpsHeaderFM        EmeraldForest_FM2,	$00, $1B
	smpsHeaderFM        EmeraldForest_FM3,	$00, $0C
	smpsHeaderFM        EmeraldForest_FM4,	$00, $23
	smpsHeaderFM        EmeraldForest_FM5,	$00, $0C
	smpsHeaderPSG       EmeraldForest_PSG1,	$00, $04, $00, fTone_01
	smpsHeaderPSG       EmeraldForest_PSG2,	$00, $07, $00, fTone_01
	smpsHeaderPSG       EmeraldForest_PSG3,	$00, $06, $00, fTone_02

; DAC Data
EmeraldForest_DAC:
	smpsPan             panCenter, $00
	dc.b	dCrashCymbal, $0C

EmeraldForest_Loop00:
	dc.b	dSnareS3, dKickS3, $06, $06, dSnareS3, $0C, dKickS3, dSnareS3, dKickS3, $06
	smpsPan             panLeft, $00
	dc.b	nRst
	smpsPan             panCenter, $00
	dc.b	dSnareS3
	smpsPan             panRight, $00
	dc.b	nRst
	smpsPan             panCenter, $00
	dc.b	dKickS3, $0C
	smpsLoop            $00, $03, EmeraldForest_Loop00
	dc.b	dSnareS3, dKickS3, $06, $06, dSnareS3, $0C, dKickS3, dSnareS3, $06, dKickS3, dSnareS3, dSnareS3
	dc.b	dSnareS3
	smpsPan             panRight, $00
	dc.b	dElectricFloorTom
	smpsPan             panCenter, $00
	dc.b	dCrashCymbal, $0C

EmeraldForest_Loop01:
	dc.b	dSnareS3, dKickS3, $06, $06, dSnareS3, $0C, dKickS3
	smpsLoop            $00, $05, EmeraldForest_Loop01
	dc.b	dSnareS3, $06, dKickS3, dSnareS3, dSnareS3, dSnareS3
	smpsPan             panRight, $00
	dc.b	dElectricFloorTom
	smpsPan             panCenter, $00
	dc.b	dCrashCymbal, $0C

EmeraldForest_Loop02:
	dc.b	dSnareS3, $06, dElectricLowTom, dKickS3, dSnareS3, $0C
	smpsPan             panRight, $00
	dc.b	dElectricFloorTom, $06
	smpsPan             panCenter, $00
	dc.b	dKickS3
	smpsPan             panLeft, $00
	dc.b	dElectricMidTom
	smpsPan             panCenter, $00
	smpsLoop            $00, $06, EmeraldForest_Loop02
	dc.b	dSnareS3, dElectricLowTom, dKickS3, dSnareS3, $0C
	smpsPan             panRight, $00
	dc.b	dElectricFloorTom, $06
	smpsPan             panCenter, $00
	dc.b	dSnareS3, dSnareS3, dSnareS3, dSnareS3, dSnareS3, $03, $03, $06, $06, $06
	smpsJump            EmeraldForest_DAC

; FM1 Data
EmeraldForest_FM1:
	smpsAlterNote       $FC
	smpsModSet          $00, $01, $04, $04

EmeraldForest_Jump04:
	smpsSetvoice        $00
	dc.b	nRst, $0C
	smpsPan             panCenter, $00
	dc.b	nC5, nB4, nG4, nF4, $12, nE4, $0C, nRst, nD4, $03, nEb4, nE4
	dc.b	$12, nG4, $4E
	smpsSetvoice        $00
	dc.b	nRst, $0C, nC5, nB4, nG4, nF4, $12, nE4, $0C, nRst, nD4, $03
	dc.b	nEb4, nE4, $12, nG4, $4E
	smpsSetvoice        $04
	dc.b	nRst, $0C, nF5, nE5, nD5, nC5, $12, nB4, nC5, $06, nD5, nRst
	dc.b	$0C, nG5, nF5, nE5, nD5, $12, nCs5, nD5, $06, nE5, nF5, $12
	dc.b	nC5, $1E, nB4, $06, nRst, nA4, nRst, nB4, nD5, $12, nC5

EmeraldForest_Loop14:
	dc.b	$48, nRst, $06, nC5, nRst, nC5
	smpsLoop            $00, $03, EmeraldForest_Loop14
	dc.b	nC5, $48, nRst, $06, nD5, nRst, nE5
	smpsJump            EmeraldForest_Jump04

; FM2 Data
EmeraldForest_FM2:
	smpsSetvoice        $00
	smpsAlterNote       $03
	smpsModSet          $00, $01, $04, $04
	dc.b	nRst, $09

EmeraldForest_Jump03:
	dc.b	nRst, $0C
	smpsPan             panCenter, $00
	dc.b	nC5, nB4, nG4, nF4, $12, nE4, $0C, nRst, nD4, $03, nEb4, nE4
	dc.b	$12, nG4, $4E
	smpsSetvoice        $00
	dc.b	nRst, $0C, nC5, nB4, nG4, nF4, $12, nE4, $0C, nRst, nD4, $03
	dc.b	nEb4, nE4, $12, nG4, $4E
	smpsSetvoice        $04
	dc.b	nRst, $0C, nF5, nE5, nD5, nC5, $12, nB4, nC5, $06, nD5, nRst
	dc.b	$0C, nG5, nF5, nE5, nD5, $12, nCs5, nD5, $06, nE5, nF5, $12
	dc.b	nC5, $1E, nB4, $06, nRst, nA4, nRst, nB4, nD5, $12, nC5

EmeraldForest_Loop13:
	dc.b	$48, nRst, $06, nC5, nRst, nC5
	smpsLoop            $00, $03, EmeraldForest_Loop13
	dc.b	nC5, $48, nRst, $06, nD5, nRst, nE5
	smpsSetvoice        $00
	smpsJump            EmeraldForest_Jump03

; FM3 Data
EmeraldForest_FM3:
	smpsAlterNote       $04

EmeraldForest_Jump02:
	smpsModSet          $00, $01, $04, $04
	smpsSetvoice        $01

EmeraldForest_Loop11:
	dc.b	nRst, $06
	smpsPan             panRight, $00
	dc.b	nC2, $0C, $06
	smpsPan             panLeft, $00
	dc.b	nA1, $0C, nE1, $06, $06
	smpsLoop            $00, $03, EmeraldForest_Loop11
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	smpsAlterVol        $09
	dc.b	nC5, $0C
	smpsPan             panLeft, $00
	dc.b	nG4
	smpsPan             panRight, $00
	dc.b	nG5
	smpsPan             panCenter, $00
	dc.b	nD5
	smpsSetvoice        $01
	smpsAlterVol        $F7

EmeraldForest_Loop12:
	dc.b	nRst, $06
	smpsPan             panRight, $00
	dc.b	nC2, $0C, $06
	smpsPan             panLeft, $00
	dc.b	nA1, $0C, nE1, $06, $06
	smpsLoop            $00, $03, EmeraldForest_Loop12
	smpsSetvoice        $02
	smpsPan             panCenter, $00
	smpsAlterVol        $09
	dc.b	nC5, $0C
	smpsPan             panLeft, $00
	dc.b	nG4
	smpsPan             panRight, $00
	dc.b	nG5
	smpsPan             panCenter, $00
	dc.b	nD5
	smpsModOn
	smpsSetvoice        $05
	smpsAlterVol        $09
	dc.b	nA4, $30, nG4, nB4, nA4, nC5, $18, nA4, nG4, nF4, nE4, $48
	dc.b	nRst, $06, nC5, nRst, nBb4, nBb4, $48, nRst, $06, nBb4, nRst, nA4
	dc.b	nA4, $48, nRst, $06, nA4, nRst, nAb4, nAb4, $48, nRst, $06, nAb4
	dc.b	nRst, nAb4
	smpsAlterVol        $EE
	smpsJump            EmeraldForest_Jump02

; FM4 Data
EmeraldForest_FM4:
	smpsAlterNote       $FB

EmeraldForest_Jump01:
	smpsModSet          $00, $01, $04, $04
	smpsSetvoice        $02
	dc.b	nRst, $7F, $17
	smpsPan             panCenter, $00
	dc.b	nC5, $0C
	smpsPan             panLeft, $00
	dc.b	nG4
	smpsPan             panRight, $00
	dc.b	nG5
	smpsPan             panCenter, $00
	dc.b	nD5, nRst, $7F, $11, nC5, $0C
	smpsPan             panLeft, $00
	dc.b	nG4
	smpsPan             panRight, $00
	dc.b	nG5
	smpsPan             panCenter, $00
	dc.b	nD5
	smpsModOn
	smpsSetvoice        $05
	dc.b	nA4, $30, nG4, nB4, nA4, nC5, $18, nA4, nG4, nF4, nE4, $48
	dc.b	nG4, $06, nRst, nG4, nG4, $48, nRst, $06, nG4

EmeraldForest_Loop10:
	dc.b	nRst, nF4, nF4, $48, nRst, $06, nF4
	smpsLoop            $00, $02, EmeraldForest_Loop10
	dc.b	nRst, nE4
	smpsJump            EmeraldForest_Jump01

; FM5 Data
EmeraldForest_FM5:
	smpsAlterNote       $01
	smpsSetvoice        $03
	smpsModSet          $00, $01, $04, $04

EmeraldForest_Jump00:
	smpsPan             panCenter, $00

EmeraldForest_Loop03:
	dc.b	nC3, $03, $03, $03, nRst, nC3, nRst, nC3, nRst, nC3, nRst, nC4
	dc.b	nRst, nC3, nRst, nC3, nRst
	smpsLoop            $00, $02, EmeraldForest_Loop03
	dc.b	nF2, nF2

EmeraldForest_Loop04:
	dc.b	nF2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop04
	dc.b	nF3, nRst, nF2, nRst, nF2, nRst, nG2, nG2

EmeraldForest_Loop05:
	dc.b	nG2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop05
	dc.b	nG3, nRst, nG2, nRst, nG2, nRst
	smpsLoop            $01, $02, EmeraldForest_Loop03
	dc.b	nF2, nF2

EmeraldForest_Loop06:
	dc.b	nF2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop06
	dc.b	nF3, nRst, nF2, nRst, nF2, nRst, nG2, nG2

EmeraldForest_Loop07:
	dc.b	nG2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop07
	dc.b	nG3, nRst, nG2, nRst, nG2, nRst, nE2, nE2

EmeraldForest_Loop08:
	dc.b	nE2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop08
	dc.b	nE3, nRst, nE2, nRst, nE2, nRst, nA2, nA2

EmeraldForest_Loop09:
	dc.b	nA2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop09
	dc.b	nA3, nRst, nA2, nRst, nA2, nRst, nF2, nF2

EmeraldForest_Loop0A:
	dc.b	nF2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop0A
	dc.b	nF3, nRst, nF2, nRst, nF2, nRst, nG2, nG2

EmeraldForest_Loop0B:
	dc.b	nG2, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop0B
	dc.b	nG3, nRst, nG2, nRst, nG2

EmeraldForest_Loop0D:
	dc.b	nRst, nC3, nC3

EmeraldForest_Loop0C:
	dc.b	nC3, nRst
	smpsLoop            $00, $04, EmeraldForest_Loop0C
	dc.b	nC4, nRst, nC3, nRst, nC3
	smpsLoop            $01, $02, EmeraldForest_Loop0D

EmeraldForest_Loop0F:
	dc.b	nRst, nC3, nC3

EmeraldForest_Loop0E:
	dc.b	nC3, nRst, nC4, nRst, nC3, nRst
	smpsLoop            $00, $02, EmeraldForest_Loop0E
	dc.b	nC4
	smpsLoop            $01, $06, EmeraldForest_Loop0F
	dc.b	nRst
	smpsJump            EmeraldForest_Jump00

; PSG1 Data
EmeraldForest_PSG1:
	dc.b	nB2, $03, nG2, $06, nA2, $03, nG2, $06, nE2, $03, nD2, $06
	dc.b	nE2, $03, nG2, $06, nD2, nE2
	smpsLoop            $00, $08, EmeraldForest_PSG1
	dc.b	nRst, $7F, $7F, $7F, $03, nC0, $04, nCs0, nD0, nEb0, nE0, nF0
	dc.b	nFs0, nG0, nAb0, nA0, nBb0, nB0, nC1, nCs1, nD1, nEb1, nE1, nF1
	dc.b	nFs1, nG1, nAb1, nA1, nBb1, nB1, nC2, nCs2, nD2, nEb2, nE2, nF2
	dc.b	nFs2, nG2, nAb2, nA2, nBb2, nB2, nC3, nB2, nBb2, nA2, nAb2, nG2
	dc.b	nFs2, nF2, nE2, nEb2, nD2, nCs2, nC2, nB1, nBb1, nA1, nAb1, nG1
	dc.b	nFs1, nF1, nE1, nEb1, nD1, nCs1, nC1, nB0, nBb0, nA0, nAb0, nG0
	dc.b	nFs0, nF0, nE0, nEb0, nD0, nCs0
	smpsJump            EmeraldForest_PSG1

; PSG2 Data
EmeraldForest_PSG2:
	dc.b	nRst, $06

EmeraldForest_Loop19:
	dc.b	nB2, $03, nG2, $06, nA2, $03, nG2, $06, nE2, $03, nD2, $06
	dc.b	nE2, $03, nG2, $06, nD2, nE2
	smpsLoop            $00, $08, EmeraldForest_Loop19
	dc.b	nRst, $7F, $7F, $7F, $03, nC0, $04, nCs0, nD0, nEb0, nE0, nF0
	dc.b	nFs0, nG0, nAb0, nA0, nBb0, nB0, nC1, nCs1, nD1, nEb1, nE1, nF1
	dc.b	nFs1, nG1, nAb1, nA1, nBb1, nB1, nC2, nCs2, nD2, nEb2, nE2, nF2
	dc.b	nFs2, nG2, nAb2, nA2, nBb2, nB2, nC3, nB2, nBb2, nA2, nAb2, nG2
	dc.b	nFs2, nF2, nE2, nEb2, nD2, nCs2, nC2, nB1, nBb1, nA1, nAb1, nG1
	dc.b	nFs1, nF1, nE1, nEb1, nD1, nCs1, nC1, nB0, nBb0, nA0, nAb0, nG0
	dc.b	nFs0, nF0, nE0, nEb0, nD0, nCs0
	smpsStop

; PSG3 Data
EmeraldForest_PSG3:
	smpsPSGform         $E7

EmeraldForest_Jump05:
	dc.b	nC5, $06, $06, $06

EmeraldForest_Loop16:
	dc.b	$03, $03

EmeraldForest_Loop15:
	dc.b	$06
	smpsLoop            $00, $07, EmeraldForest_Loop15
	smpsLoop            $01, $07, EmeraldForest_Loop16
	dc.b	$03, $03

EmeraldForest_Loop17:
	dc.b	$06, $06, $06, $06, $06, $06
	smpsPSGAlterVol     $FC
	dc.b	$0C
	smpsPSGAlterVol     $04
	smpsLoop            $00, $06, EmeraldForest_Loop17

EmeraldForest_Loop18:
	dc.b	$06
	smpsLoop            $00, $07, EmeraldForest_Loop18
	dc.b	$03, $03
	smpsLoop            $01, $08, EmeraldForest_Loop18
	dc.b	$06, $06, $06, $06
	smpsJump            EmeraldForest_Jump05

EmeraldForest_Voices:
;	Voice $00
;	$3A
;	$72, $32, $32, $71, 	$1F, $9F, $1F, $91, 	$00, $11, $00, $04
;	$00, $06, $00, $00, 	$0F, $4F, $0F, $2F, 	$1F, $1A, $24, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $03, $07
	smpsVcCoarseFreq    $01, $02, $02, $02
	smpsVcRateScale     $02, $00, $02, $00
	smpsVcAttackRate    $11, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $00, $11, $00
	smpsVcDecayRate2    $00, $00, $06, $00
	smpsVcDecayLevel    $02, $00, $04, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $24, $1A, $1F

;	Voice $01
;	$3C
;	$03, $0C, $03, $05, 	$1F, $1F, $1F, $1F, 	$16, $16, $00, $15
;	$00, $15, $00, $12, 	$2F, $5F, $0F, $3F, 	$26, $00, $26, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $05, $03, $0C, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $15, $00, $16, $16
	smpsVcDecayRate2    $12, $00, $15, $00
	smpsVcDecayLevel    $03, $00, $05, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $26, $00, $26

;	Voice $02
;	$04
;	$77, $72, $37, $32, 	$1F, $1F, $1F, $1F, 	$0C, $0C, $0C, $0C
;	$06, $06, $06, $06, 	$4F, $4F, $4F, $4F, 	$17, $00, $17, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $02, $07, $02, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $0C, $0C, $0C
	smpsVcDecayRate2    $06, $06, $06, $06
	smpsVcDecayLevel    $04, $04, $04, $04
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $17, $00, $17

;	Voice $03
;	$3B
;	$08, $02, $00, $00, 	$1B, $1F, $1F, $1F, 	$0E, $0C, $12, $05
;	$00, $00, $00, $05, 	$3A, $3A, $5A, $EF, 	$1E, $2D, $0F, $00
	smpsVcAlgorithm     $03
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $02, $08
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $12, $0C, $0E
	smpsVcDecayRate2    $05, $00, $00, $00
	smpsVcDecayLevel    $0E, $05, $03, $03
	smpsVcReleaseRate   $0F, $0A, $0A, $0A
	smpsVcTotalLevel    $00, $0F, $2D, $1E

;	Voice $04
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$13, $F7, $13, $09, 	$18, $28, $27, $00
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $09, $03, $07, $03
	smpsVcTotalLevel    $00, $27, $28, $18

;	Voice $05
;	$04
;	$03, $01, $08, $01, 	$1F, $17, $1F, $1F, 	$00, $00, $00, $00
;	$00, $00, $00, $05, 	$00, $08, $00, $48, 	$26, $00, $35, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $08, $01, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $17, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $05, $00, $00, $00
	smpsVcDecayLevel    $04, $00, $00, $00
	smpsVcReleaseRate   $08, $00, $08, $00
	smpsVcTotalLevel    $00, $35, $00, $26

