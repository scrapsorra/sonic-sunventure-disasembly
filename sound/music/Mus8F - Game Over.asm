GameOver_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     GameOver_Voices
	smpsHeaderChan      $06, $00
	smpsHeaderTempo     $02, $00

	smpsHeaderDAC       GameOver_DAC,	$00, $0F
	smpsHeaderFM        GameOver_FM1,	$00, $0D
	smpsHeaderFM        GameOver_FM2,	$0C, $11
	smpsHeaderFM        GameOver_FM3,	$0C, $11
	smpsHeaderFM        GameOver_FM4,	$00, $0F
	smpsHeaderFM        GameOver_FM5,	$00, $14

; FM1 Data
GameOver_FM1:

GameOver_Jump00:
	smpsSetvoice        $00
	dc.b	nD5, $10, nE5, nF5, nE5, nD5, nF5, nE5, nD5, nC5
	dc.b	nE5, nD5, $40, nA5
	smpsStop

; FM2 Data
GameOver_FM2:
	smpsSetvoice        $01
	smpsPan             panRight, $00
	dc.b	nRst, $20, nBb3, $40, nC4, nD4, nD6
	smpsStop

; FM3 Data
GameOver_FM3:
	smpsSetvoice        $01
	smpsPan             panLeft, $00
	dc.b	nD4, $10, nC4, nF3, $40, nG3, nA3, nD4, $12, nC4, $02, nBb3
	dc.b	nA3, nG3, nF3, nE3, nD3, $22
	smpsStop

; FM4 Data
GameOver_FM4:
	smpsSetvoice        $02
	dc.b	nRst, $20

GameOver_Loop00:
	dc.b	nBb2, $08, nBb2, nF2, nBb2, $10, nF2, $08, nBb2, nF2
	smpsAlterPitch      $02
	smpsLoop            $00, $03, GameOver_Loop00
	dc.b	nAb2, $40
	smpsStop

; FM5 Data
GameOver_FM5:
	dc.b	nRst, $02
	smpsAlterNote       $04
	smpsJump            GameOver_Jump00

; DAC Data
GameOver_DAC:
	smpsStop

GameOver_Voices:
;	Voice $00
;	$3A
;	$34, $25, $61, $03, 	$5F, $5F, $5C, $58, 	$02, $01, $03, $02
;	$02, $01, $01, $01, 	$14, $14, $14, $18, 	$20, $20, $34, $07
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $06, $02, $03
	smpsVcCoarseFreq    $03, $01, $05, $04
	smpsVcRateScale     $01, $01, $01, $01
	smpsVcAttackRate    $18, $1C, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $02, $03, $01, $02
	smpsVcDecayRate2    $01, $01, $01, $02
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $08, $04, $04, $04
	smpsVcTotalLevel    $07, $34, $20, $20

;	Voice $01
;	$3A
;	$01, $07, $01, $01, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $00, 	$13, $F7, $13, $09, 	$18, $28, $27, $07
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
	smpsVcTotalLevel    $07, $27, $28, $18

;	Voice $02
;	$3B
;	$08, $02, $00, $00, 	$1B, $1F, $1F, $1F, 	$0E, $0C, $12, $05
;	$00, $00, $00, $05, 	$3A, $3A, $5A, $EF, 	$1E, $2D, $0F, $02
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
	smpsVcTotalLevel    $02, $0F, $2D, $1E

