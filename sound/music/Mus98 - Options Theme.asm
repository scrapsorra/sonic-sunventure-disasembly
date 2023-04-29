PasswordEntry_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     PasswordEntry_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $33

	smpsHeaderDAC       PasswordEntry_DAC,	$00, $01
	smpsHeaderFM        PasswordEntry_FM1,	$00, $13
	smpsHeaderFM        PasswordEntry_FM2,	$F4, $0B
	smpsHeaderFM        PasswordEntry_FM3,	$00, $0F
	smpsHeaderFM        PasswordEntry_FM4,	$00, $0F
	smpsHeaderFM        PasswordEntry_FM5,	$00, $1D
	smpsHeaderPSG       PasswordEntry_PSG1,	$C4+$0C, $03, $07, fTone_07
	smpsHeaderPSG       PasswordEntry_PSG2,	$C4+$0C, $05, $07, fTone_07
	smpsHeaderPSG       PasswordEntry_PSG3,	$0D, $02, $00, fTone_03

; FM1 Data
PasswordEntry_FM1:
	smpsSetvoice        $00
	smpsModSet          $22, $01, $03, $06

PasswordEntry_Jump00:
	dc.b	nE6, $30, nF6, nG6, nG6, $10, nF6, $08, nE6, $10, nF6, $08
	dc.b	nC6, $30, nD6, nE6, nF6, $10, nE6, $08, nD6, $10, nE6, $08
	dc.b	nC6, $60, nB5, $30, nG5, nA5, nF5, $10, nA5, nC6, nB5, $30
	dc.b	nC6, $18, nD6
	smpsJump            PasswordEntry_Jump00

; FM2 Data
PasswordEntry_FM2:
	smpsSetvoice        $01

PasswordEntry_Jump03:
	dc.b	nC4, $18, $18, $18, $10, nG3, $08, nC4, $18, $18, $18, nB3
	dc.b	nA3, nA3, nA3, nA3, $10, nE4, $08, nA3, $18, $18, $18, nG3
	dc.b	nF3, nF3, nF3, nF3, $10, $08, nE4, $18, $18, $18, $10, $08
	dc.b	nG3, $18, $18, $18, $10, $08, $18, $18, nA3, nB3
	smpsJump            PasswordEntry_Jump03

; FM3 Data
PasswordEntry_FM3:
	smpsPan             panLeft, $00
	smpsSetvoice        $02

PasswordEntry_Jump02:
	dc.b	nE5, $04, nRst, $14, nG5, $08, nRst, $10, nF5, $08, nRst, $10
	dc.b	nF5, $04, nRst, $14, nE5, $04, nRst, $14, nE5, $04, nRst, $0C
	dc.b	nF5, $04, nRst, $14, nF5, $1C, nRst, $04, nG5, $04, nRst, $14
	dc.b	nG5, $08, nRst, $10, nF5, $04, nRst, $14, nF5, $04, nRst, $14
	dc.b	nE5, $08, nRst, $10, nE5, $04, nRst, $0C, nF5, $04, nRst, $14
	dc.b	nF5, $1C, nRst, $04, nE5, $08, nRst, $10, nE5, $08, nRst, $10
	dc.b	nD5, $08, nRst, $10, nF5, $0C, nRst, $0C, nG5, $08, nRst, $10
	dc.b	nG5, $08, nRst, $10, nD5, $08, nRst, $10, nD5, $0C, nRst, $0C
	dc.b	nA4, $08, nRst, $10, nC5, $0C, nRst, $0C, nC5, $0C, nRst, $0C
	dc.b	nC5, $0C, nRst, $0C, nD5, $08, nRst, $10, nD5, $08, nRst, $10
	dc.b	nD5, $08, nRst, $10, nD5, $08, nRst, $10
	smpsJump            PasswordEntry_Jump02

; FM4 Data
PasswordEntry_FM4:
	smpsPan             panRight, $00
	smpsSetvoice        $02

PasswordEntry_Jump01:
	dc.b	nG5, $04, nRst, $14, nE5, $04, nRst, $14, nD5, $04, nRst, $14
	dc.b	nD5, $04, nRst, $14, nC5, $04, nRst, $14, nC5, $04, nRst, $0C
	dc.b	nD5, $04, nRst, $14, nD5, $18, nRst, $08, nE5, $04, nRst, $14
	dc.b	nE5, $04, nRst, $14, nD5, $04, nRst, $14, nD5, $04, nRst, $14
	dc.b	nC5, $04, nRst, $14, nC5, $04, nRst, $0C, nD5, $04, nRst, $14
	dc.b	nD5, $1C, nRst, $04, nG5, $08, nRst, $10, nG5, $08, nRst, $10
	dc.b	nF5, $08, nRst, $10, nD5, $08, nRst, $10, nD5, $08, nRst, $10
	dc.b	nD5, $08, nRst, $10, nB4, $08, nRst, $10, nB4, $0C, nRst, $0C
	dc.b	nC5, $08, nRst, $10, nA4, $08, nRst, $10, nA4, $08, nRst, $10
	dc.b	nA4, $08, nRst, $10, nB4, $08, nRst, $10, nB4, $08, nRst, $10
	dc.b	nB4, $08, nRst, $10, nB4, $08, nRst, $10
	smpsJump            PasswordEntry_Jump01

; FM5 Data
PasswordEntry_FM5:
	smpsSetvoice        $00
	smpsAlterNote       $FB
	dc.b	nRst, $0C
	smpsJump            PasswordEntry_Jump00

; PSG1 Data
PasswordEntry_PSG1:
	dc.b	nG5, $10, nC6, $08, nE6, $10, nG6, $38, nG5, $10, nC6, $08
	dc.b	nE6, $10, nG6, $38, nG5, $10, nC6, $08, nE6, $10, nG6, $38
	dc.b	nG5, $10, nC6, $08, nE6, $10, nG6, $38, nG5, $10, nC6, $08
	dc.b	nE6, $10, nG6, $38, nG5, $10, nB5, $08, nD6, $10, nG6, $38
	dc.b	nF5, $10, nA5, $08, nC6, $10, nF6, $18, nC6, $08, nA5, $10
	dc.b	nF5, $08, nG5, $10, nB5, $08, nD6, $10, nG6, $18, nD6, $08
	dc.b	nB5, $10, nG5, $08
	smpsJump            PasswordEntry_PSG1

; PSG2 Data
PasswordEntry_PSG2:
	smpsAlterNote       $FF
	dc.b	nRst, $0C
	smpsJump            PasswordEntry_PSG1

; PSG3 Data
PasswordEntry_PSG3:
	smpsPSGvoice        fTone_02
	smpsPSGform         $E7
	dc.b	nAb5, $08, nRst, nAb5, nAb5, $08, nRst, nAb5, nAb5, $08, nRst, nAb5
	dc.b	nAb5, $08, nRst, nAb5, nAb5, $08, nRst, nAb5, nAb5, $08, nRst, nAb5
	dc.b	nAb5, $08, nRst, nAb5, nAb5, $08, nAb5
	smpsPSGvoice        fTone_03
	dc.b	nAb5
	smpsJump            PasswordEntry_PSG3

; DAC Data
PasswordEntry_DAC:
	dc.b	dKick, $18, dSnare, dKick, dSnare, $10, dKick, $08, dKick, $18, dSnare, dKick
	dc.b	$08, nRst, $08, dKick, dSnare, $10, dKick, $08
	smpsLoop            $00, $03, PasswordEntry_DAC
	dc.b	dKick, $18, dSnare, dKick, dSnare, $10, dKick, $08, dKick, $18, dSnare, dKick
	dc.b	$08, nRst, $08, dKick, dSnare, $10, dSnare, $08

PasswordEntry_Loop00:
	dc.b	dKick, $18, dSnare, dKick, dSnare, $10, dKick, $08, dKick, $18, dSnare, dKick
	dc.b	$08, nRst, $08, dKick, dSnare, $10, dKick, $08
	smpsLoop            $00, $03, PasswordEntry_Loop00
	dc.b	dKick, $18, dSnare, dKick, dSnare, $10, dKick, $08, dKick, $08, nRst, $08
	dc.b	dKick, dSnare, dKick, dSnare, dSnare, dSnare, dHiTimpani, dMidTimpani, dMidTimpani, dLowTimpani
	smpsJump            PasswordEntry_DAC

PasswordEntry_Voices:
;	Voice $00
;	$04
;	$02, $01, $01, $00, 	$1F, $10, $1F, $12, 	$09, $03, $0B, $04
;	$03, $00, $00, $05, 	$EF, $FF, $2F, $0F, 	$1C, $80, $19, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $01, $01, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $1F, $10, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $04, $0B, $03, $09
	smpsVcDecayRate2    $05, $00, $00, $03
	smpsVcDecayLevel    $00, $02, $0F, $0E
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $19, $00, $1C

;	Voice $01
;	$39
;	$03, $61, $40, $00, 	$1F, $5F, $5F, $5F, 	$10, $11, $09, $09
;	$06, $00, $00, $00, 	$C8, $F8, $F8, $F8, 	$1E, $24, $20, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $04, $06, $00
	smpsVcCoarseFreq    $00, $00, $01, $03
	smpsVcRateScale     $01, $01, $01, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $09, $09, $11, $10
	smpsVcDecayRate2    $00, $00, $00, $06
	smpsVcDecayLevel    $0F, $0F, $0F, $0C
	smpsVcReleaseRate   $08, $08, $08, $08
	smpsVcTotalLevel    $00, $20, $24, $1E

;	Voice $02
;	$2C
;	$41, $00, $23, $00, 	$1F, $1F, $1F, $1F, 	$08, $0A, $0B, $0A
;	$04, $05, $00, $05, 	$45, $56, $85, $86, 	$14, $82, $18, $82
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $02, $00, $04
	smpsVcCoarseFreq    $00, $03, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0B, $0A, $08
	smpsVcDecayRate2    $05, $00, $05, $04
	smpsVcDecayLevel    $08, $08, $05, $04
	smpsVcReleaseRate   $06, $05, $06, $05
	smpsVcTotalLevel    $02, $18, $02, $14

