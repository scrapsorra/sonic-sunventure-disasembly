ToxicLandfill_Header:
	smpsHeaderStartSong 1
	smpsHeaderVoice     ToxicLandfill_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $02, $20

	smpsHeaderDAC       ToxicLandfill_DAC
	smpsHeaderFM        ToxicLandfill_FM1,	$00, $0A
	smpsHeaderFM        ToxicLandfill_FM2,	$00, $0A	
	smpsHeaderFM        ToxicLandfill_FM3,	$0C, $0B
	smpsHeaderFM        ToxicLandfill_FM4,	$0C, $0B
	smpsHeaderFM        ToxicLandfill_FM5,	$00, $12
	smpsHeaderPSG       ToxicLandfill_PSG1,	$00, $03, $00, $00
	smpsHeaderPSG       ToxicLandfill_PSG2,	$00, $03, $00, $00
	smpsHeaderPSG       ToxicLandfill_PSG3,	$00, $04, $00, fTone_02

; DAC Data
ToxicLandfill_DAC:
	smpsPan             panCenter, $00
	dc.b	nRst, $7F, $7F, $22, dKick, $06, $18, $03, $03, dSnare, $06, dKick
	dc.b	dKick, dKick, dSnare, dKick, $03, $06, dSnare, dKick, $03, dSnare, dKick

ToxicLandfill_Loop00:
	dc.b	dSnare

ToxicLandfill_Loop01:
	dc.b	dSnare

ToxicLandfill_Jump00:
	dc.b	dKick, $06, dSnare, $03, dKick, $06, $03, dSnare, dKick, dKick, $06, dSnare
	dc.b	$03, dKick, $06, $03
	smpsLoop            $00, $03, ToxicLandfill_Loop00
	dc.b	dSnare, dSnare, dSnare, $06, dKick, $03, dSnare, $06, dKick, $03, dSnare, dKick
	dc.b	$06, dSnare, $03, dKick, dSnare, dKick, dSnare, dKick
	smpsLoop            $01, $02, ToxicLandfill_Loop01

ToxicLandfill_Loop06:
	dc.b	dSnare

ToxicLandfill_Loop02:
	dc.b	dKick, dKick, dSnare, dKick
	smpsLoop            $00, $06, ToxicLandfill_Loop02

ToxicLandfill_Loop03:
	dc.b	dSnare, dKick, dKick
	smpsLoop            $00, $03, ToxicLandfill_Loop03

ToxicLandfill_Loop04:
	dc.b	dKick, dSnare, dKick, dKick
	smpsLoop            $00, $03, ToxicLandfill_Loop04
	dc.b	dKick, dSnare, dKick

ToxicLandfill_Loop05:
	dc.b	dKick, $02, $01, dSnare, $03
	smpsLoop            $00, $06, ToxicLandfill_Loop05
	dc.b	$03, $03, $03
	smpsLoop            $01, $02, ToxicLandfill_Loop06

ToxicLandfill_Loop08:
	dc.b	$03

ToxicLandfill_Loop07:
	dc.b	dKick, $06, dSnare, $03, dKick, $06, $03, dSnare, $06
	smpsLoop            $00, $07, ToxicLandfill_Loop07
	dc.b	dKick, dSnare, $03, dKick, dSnare, dSnare, dSnare
	smpsLoop            $01, $02, ToxicLandfill_Loop08

ToxicLandfill_Loop0D:
	dc.b	dSnare

ToxicLandfill_Loop09:
	dc.b	dKick, dKick, dSnare, dKick
	smpsLoop            $00, $06, ToxicLandfill_Loop09

ToxicLandfill_Loop0A:
	dc.b	dSnare, dKick, dKick
	smpsLoop            $00, $03, ToxicLandfill_Loop0A

ToxicLandfill_Loop0B:
	dc.b	dKick, dSnare, dKick, dKick
	smpsLoop            $00, $03, ToxicLandfill_Loop0B
	dc.b	dKick, dSnare, dKick

ToxicLandfill_Loop0C:
	dc.b	dKick, $02, $01, dSnare, $03
	smpsLoop            $00, $06, ToxicLandfill_Loop0C
	dc.b	$03, $03, $03
	smpsLoop            $01, $02, ToxicLandfill_Loop0D

ToxicLandfill_Loop0E:
	dc.b	$03

ToxicLandfill_Loop0F:
	dc.b	dKick, $06, dSnare, $03, dKick, $06, $03, dSnare, dKick, dKick, $06, dSnare
	dc.b	$03, dKick, $06, $03, dSnare
	smpsLoop            $00, $03, ToxicLandfill_Loop0E
	dc.b	dSnare, dSnare, $06, dKick, $03, dSnare, $06, dKick, $03, dSnare, dKick, $06
	dc.b	dSnare, $03, dKick, dSnare, dKick, dSnare, dKick, dSnare
	smpsLoop            $01, $02, ToxicLandfill_Loop0F

ToxicLandfill_Loop10:
	dc.b	dKick, $06, dSnare, $03, dKick, $06, $03, dSnare, $06
	smpsLoop            $00, $07, ToxicLandfill_Loop10
	dc.b	dKick, dSnare, $03, dKick, dSnare, dSnare, dSnare, dSnare
	smpsLoop            $01, $04, ToxicLandfill_Loop10
	smpsJump            ToxicLandfill_Jump00

; FM1 Data
ToxicLandfill_FM1:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst, $7F, $7F, $76, nE3, $02, nF3, $01, nFs3, $02, nG3, $01
	dc.b	nAb3, $02, nA3, $01, nBb3, $02, nB3, $01

ToxicLandfill_Loop44:
	dc.b	nG3, $09, $09, $09, nF3, $03, nG3, $06, $06, nBb3, nG3, $09
	dc.b	$09, $09, nF3, $03, nG3, $06, $06, nC4, nG3, $09, $09, $09
	dc.b	nF3, $03, nG3, $06, $06, nBb3, nD3, $09, $09, $09, nC3, $03
	dc.b	nD3, $06, $06, nF3
	smpsLoop            $00, $02, ToxicLandfill_Loop44

ToxicLandfill_Loop46:
	dc.b	nG3, $12, nF3, $36, nE3, $02, nEb3, $01, nD3, $02, nCs3, $01
	dc.b	nC3, $02, nB2, $01, nBb2, $02, nA2, $01, nAb2, $02, nG2, $01
	dc.b	nFs2, $02, nF2, $01, nE2, $02, nEb2, $01, nD2, $02, nCs2, $01
	dc.b	nG3, $12, nF3, $2A, $03, nE3, nF3, nE3

ToxicLandfill_Loop45:
	dc.b	nF3, $02, nE3, $01
	smpsLoop            $00, $04, ToxicLandfill_Loop45
	dc.b	nF3, $02, nC3, nAb2, nF3, nC3, nAb2
	smpsLoop            $01, $02, ToxicLandfill_Loop46

ToxicLandfill_Loop47:
	dc.b	nC4, $06, nG3, nBb3, nB3, $03, nC4, $09, nG3, $06, nBb3, nB3
	smpsLoop            $00, $02, ToxicLandfill_Loop47

ToxicLandfill_Loop48:
	dc.b	nC4, nF3, nG3, nBb3, $03, nC4, $09, nF3, $06, nG3, nBb3
	smpsLoop            $00, $02, ToxicLandfill_Loop48
	smpsLoop            $01, $02, ToxicLandfill_Loop47

ToxicLandfill_Loop4A:
	dc.b	nG4, $12, nF4, $36, nE4, $02, nEb4, $01, nD4, $02, nCs4, $01
	dc.b	nC4, $02, nB3, $01, nBb3, $02, nA3, $01, nAb3, $02, nG3, $01
	dc.b	nFs3, $02, nF3, $01, nE3, $02, nEb3, $01, nD3, $02, nCs3, $01
	dc.b	nG4, $12, nF4, $2A, $03, nE4, nF4, nE4

ToxicLandfill_Loop49:
	dc.b	nF4, $02, nE4, $01
	smpsLoop            $00, $04, ToxicLandfill_Loop49
	dc.b	nF4, $02, nC4, nAb3, nF4, nC4, nAb3
	smpsLoop            $01, $02, ToxicLandfill_Loop4A

ToxicLandfill_Loop4B:
	dc.b	nG4, $09, $09, $09, nF4, $03, nG4, $06, $06, nBb4, nG4, $09
	dc.b	$09, $09, nF4, $03, nG4, $06, $06, nC5, nG4, $09, $09, $09
	dc.b	nF4, $03, nG4, $06, $06, nBb4, nD4, $09, $09, $09, nC4, $03
	dc.b	nD4, $06, $06, nF4
	smpsLoop            $00, $02, ToxicLandfill_Loop4B

ToxicLandfill_Loop4C:
	dc.b	nC5, nG4, nBb4, nB4, $03, nC5, $09, nG4, $06, nBb4, nB4
	smpsLoop            $00, $02, ToxicLandfill_Loop4C

ToxicLandfill_Loop4D:
	dc.b	nC5, nF4, nG4, nBb4, $03, nC5, $09, nF4, $06, nG4, nBb4
	smpsLoop            $00, $02, ToxicLandfill_Loop4D
	smpsLoop            $01, $04, ToxicLandfill_Loop4C
	smpsJump            ToxicLandfill_Loop44

; FM2 Data
ToxicLandfill_FM2:
	smpsPan             panCenter, $00
	smpsSetvoice        $00
	dc.b	nRst, $7F, $7F, $76, nE3, $02, nF3, $01, nFs3, $02, nG3, $01
	dc.b	nAb3, $02, nA3, $01, nBb3, $02, nB3, $01

ToxicLandfill_Loop3A:
	dc.b	nC4, $09, $09, $09, nBb3, $03, nC4, $06, $06, nEb4, nC4, $09
	dc.b	$09, $09, nBb3, $03, nC4, $06, $06, nF4, nC4, $09, $09, $09
	dc.b	nBb3, $03, nC4, $06, $06, nEb4, nG3, $09, $09, $09, nF3, $03
	dc.b	nG3, $06, $06, nBb3
	smpsLoop            $00, $02, ToxicLandfill_Loop3A

ToxicLandfill_Loop3C:
	dc.b	nC4, $12, nBb3, $36, nA3, $02, nAb3, $01, nG3, $02, nFs3, $01
	dc.b	nF3, $02, nE3, $01, nEb3, $02, nD3, $01, nCs3, $02, nC3, $01
	dc.b	nB2, $02, nBb2, $01, nA2, $02, nAb2, $01, nG2, $02, nFs2, $01
	dc.b	nC4, $12, nBb3, $2A, $03, nA3, nBb3, nA3

ToxicLandfill_Loop3B:
	dc.b	nBb3, $02, nA3, $01
	smpsLoop            $00, $04, ToxicLandfill_Loop3B
	dc.b	nBb3, $02, nF3, nCs3, nBb3, nF3, nCs3
	smpsLoop            $01, $02, ToxicLandfill_Loop3C

ToxicLandfill_Loop3D:
	dc.b	nG3, $06, nD3, nF3, nFs3, $03, nG3, $09, nD3, $06, nF3, nFs3
	smpsLoop            $00, $02, ToxicLandfill_Loop3D

ToxicLandfill_Loop3E:
	dc.b	nG3, nC3, nD3, nF3, $03, nG3, $09, nC3, $06, nD3, nF3
	smpsLoop            $00, $02, ToxicLandfill_Loop3E
	smpsLoop            $01, $02, ToxicLandfill_Loop3D

ToxicLandfill_Loop40:
	dc.b	nC5, $12, nBb4, $36, nA4, $02, nAb4, $01, nG4, $02, nFs4, $01
	dc.b	nF4, $02, nE4, $01, nEb4, $02, nD4, $01, nCs4, $02, nC4, $01
	dc.b	nB3, $02, nBb3, $01, nA3, $02, nAb3, $01, nG3, $02, nFs3, $01
	dc.b	nC5, $12, nBb4, $2A, $03, nA4, nBb4, nA4

ToxicLandfill_Loop3F:
	dc.b	nBb4, $02, nA4, $01
	smpsLoop            $00, $04, ToxicLandfill_Loop3F
	dc.b	nBb4, $02, nF4, nCs4, nBb4, nF4, nCs4
	smpsLoop            $01, $02, ToxicLandfill_Loop40

ToxicLandfill_Loop41:
	dc.b	nC5, $09, $09, $09, nBb4, $03, nC5, $06, $06, nEb5, nC5, $09
	dc.b	$09, $09, nBb4, $03, nC5, $06, $06, nF5, nC5, $09, $09, $09
	dc.b	nBb4, $03, nC5, $06, $06, nEb5, nG4, $09, $09, $09, nF4, $03
	dc.b	nG4, $06, $06, nBb4
	smpsLoop            $00, $02, ToxicLandfill_Loop41
	dc.b	nG4, nD4, nF4, nFs4, $03, nG4, $09, nD4, $06, nF4, nFs4, nG4
	dc.b	nD4, nF4, nFs4, $03, nRst, $09, nD4, $06, nF4, nFs4, nG4, nC4
	dc.b	nD4, nF4, $03, nG4, $09, nC4, $06, nD4, nF4, nG4, nC4, nD4
	dc.b	nF4, $03, nRst, $09, nC4, $06, nD4, nF4, nG4, nD4, nF4, nFs4
	dc.b	$03, nG4, $09, nD4, $06, nF4, nFs4, nG4, nD4, nF4, nFs4, $03
	dc.b	nRst, $09, nD4, $06, nF4, nFs4

ToxicLandfill_Loop42:
	dc.b	nG4, nC4, nD4, nF4, $03, nG4, $09, nC4, $06, nD4, nF4
	smpsLoop            $00, $02, ToxicLandfill_Loop42

ToxicLandfill_Loop43:
	dc.b	nG4, nD4, nF4, nFs4, $03, nG4, $09, nD4, $06, nF4, nFs4
	smpsLoop            $00, $02, ToxicLandfill_Loop43
	smpsLoop            $01, $02, ToxicLandfill_Loop42
	dc.b	nG4, nC4, nD4, nF4, $03, nG4, $09, nC4, $06, nD4, nF4, nG4
	dc.b	nC4, nD4, nF4, $03, nRst, $09, nC4, $06, nD4, nF4
	smpsJump            ToxicLandfill_Loop3A

; FM3 Data
ToxicLandfill_FM3:
	smpsPan             panCenter, $00
	smpsSetvoice        $01

ToxicLandfill_Loop2D:
	dc.b	nC2, $03, nC3, nRst, nF2, nRst, nFs2, nRst, nG2, nRst, nFs2, nRst
	dc.b	nF2, nRst, nEb2, nF2, nEb2, nC2, nEb2, nRst, nF2, nRst, nEb2, nRst
	dc.b	nF2, nRst, nFs2, nF2, nEb2, nF2, nEb2, nBb1, nB1
	smpsLoop            $00, $03, ToxicLandfill_Loop2D
	dc.b	nC2, nC3, nRst, nF2, nRst, nFs2, nRst, nG2, nRst, nFs2, nRst, nF2
	dc.b	nRst, nEb2, nF2, nEb2, nC2, nEb2, nRst, nF2, nRst, nEb2, nRst, nF2
	dc.b	nRst, nFs2, nF2, nEb2, nE2, $02, nF2, $01, nFs2, $02, nG2, $01
	dc.b	nAb2, $02, nA2, $01, nBb2, $02, nB2, $01

ToxicLandfill_Loop2E:
	dc.b	nC3, $06, nG2, nBb2, nB2, $03, nC3, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop2E
	dc.b	nC3, nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2, nG2
	dc.b	$09, $09, $09, $09, $06, nBb2
	smpsLoop            $01, $02, ToxicLandfill_Loop2E

ToxicLandfill_Loop31:
	dc.b	nC3, $03, nC2, nC2, nC3

ToxicLandfill_Loop2F:
	dc.b	nC2, nC2, nBb2
	smpsLoop            $00, $03, ToxicLandfill_Loop2F
	dc.b	nC2, nBb2

ToxicLandfill_Loop30:
	dc.b	nC2, nBb2, nC2
	smpsLoop            $00, $04, ToxicLandfill_Loop30
	dc.b	nC2, nBb2, nG2, nBb2, nB2
	smpsLoop            $01, $04, ToxicLandfill_Loop31

ToxicLandfill_Loop32:
	dc.b	nC3, $06, $06, nG2, nG2, $03, nBb2, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop32

ToxicLandfill_Loop33:
	dc.b	nC3, nC3, nF2, nF2, $03, nG2, $09, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop33
	smpsLoop            $01, $02, ToxicLandfill_Loop32

ToxicLandfill_Loop36:
	dc.b	nC3, $03, nC2, nC2, nC3

ToxicLandfill_Loop34:
	dc.b	nC2, nC2, nBb2
	smpsLoop            $00, $03, ToxicLandfill_Loop34
	dc.b	nC2, nBb2

ToxicLandfill_Loop35:
	dc.b	nC2, nBb2, nC2
	smpsLoop            $00, $04, ToxicLandfill_Loop35
	dc.b	nC2, nBb2, nG2, nBb2, nB2
	smpsLoop            $01, $04, ToxicLandfill_Loop36

ToxicLandfill_Loop37:
	dc.b	nC3, $06, nG2, nBb2, nB2, $03, nC3, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop37
	dc.b	nC3, nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2, nG2
	dc.b	$09, $09, $09, $09, $06, nBb2
	smpsLoop            $01, $02, ToxicLandfill_Loop37

ToxicLandfill_Loop38:
	dc.b	nC3, nC3, nG2, nG2, $03, nBb2, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop38

ToxicLandfill_Loop39:
	dc.b	nC3, nC3, nF2, nF2, $03, nG2, $09, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop39
	smpsLoop            $01, $04, ToxicLandfill_Loop38
	smpsJump            ToxicLandfill_Loop2E

; FM4 Data
ToxicLandfill_FM4:
	smpsPan             panCenter, $00
	smpsSetvoice        $01

ToxicLandfill_Loop20:
	dc.b	nC1, $03, nC2, nRst, nF1, nRst, nFs1, nRst, nG1, nRst, nFs1, nRst
	dc.b	nF1, nRst, nEb1, nF1, nEb1, nC1, nEb1, nRst, nF1, nRst, nEb1, nRst
	dc.b	nF1, nRst, nFs1, nF1, nEb1, nF1, nEb1, nBb0, nB0
	smpsLoop            $00, $03, ToxicLandfill_Loop20
	dc.b	nC1, nC2, nRst, nF1, nRst, nFs1, nRst, nG1, nRst, nFs1, nRst, nF1
	dc.b	nRst, nEb1, nF1, nEb1, nC1, nEb1, nRst, nF1, nRst, nEb1, nRst, nF1
	dc.b	nRst, nFs1, nF1, nEb1, nF1, nFs1, $02, nG1, $01, nAb1, $02, nA1
	dc.b	$01, nBb1, $02, nB1, $01

ToxicLandfill_Loop21:
	dc.b	nC2, $06, nG1, nBb1, nB1, $03, nC2, $09, nG1, $06, nBb1, nB1
	smpsLoop            $00, $02, ToxicLandfill_Loop21
	dc.b	nC2, nF1, nG1, nBb1, $03, nC2, $09, nF1, $06, nG1, nBb1, nG1
	dc.b	$09, $09, $09, $09, $06, nBb1
	smpsLoop            $01, $02, ToxicLandfill_Loop21

ToxicLandfill_Loop24:
	dc.b	nC2, $03, nC1, nC1, nC2

ToxicLandfill_Loop22:
	dc.b	nC1, nC1, nBb1
	smpsLoop            $00, $03, ToxicLandfill_Loop22
	dc.b	nC1, nBb1

ToxicLandfill_Loop23:
	dc.b	nC1, nBb1, nC1
	smpsLoop            $00, $04, ToxicLandfill_Loop23
	dc.b	nC1, nBb1, nG1, nBb1, nB1
	smpsLoop            $01, $04, ToxicLandfill_Loop24

ToxicLandfill_Loop25:
	dc.b	nC2, $06, $06, nG1, nG1, $03, nBb1, $09, nG1, $06, nBb1, nB1
	smpsLoop            $00, $02, ToxicLandfill_Loop25

ToxicLandfill_Loop26:
	dc.b	nC2, nC2, nF1, nF1, $03, nG1, $09, $06, nBb1, nB1
	smpsLoop            $00, $02, ToxicLandfill_Loop26
	smpsLoop            $01, $02, ToxicLandfill_Loop25

ToxicLandfill_Loop29:
	dc.b	nC2, $03, nC1, nC1, nC2

ToxicLandfill_Loop27:
	dc.b	nC1, nC1, nBb1
	smpsLoop            $00, $03, ToxicLandfill_Loop27
	dc.b	nC1, nBb1

ToxicLandfill_Loop28:
	dc.b	nC1, nBb1, nC1
	smpsLoop            $00, $04, ToxicLandfill_Loop28
	dc.b	nC1, nBb1, nG1, nBb1, nB1
	smpsLoop            $01, $04, ToxicLandfill_Loop29

ToxicLandfill_Loop2A:
	dc.b	nC2, $06, nG1, nBb1, nB1, $03, nC2, $09, nG1, $06, nBb1, nB1
	smpsLoop            $00, $02, ToxicLandfill_Loop2A
	dc.b	nC2, nF1, nG1, nBb1, $03, nC2, $09, nF1, $06, nG1, nBb1, nG1
	dc.b	$09, $09, $09, $09, $06, nBb1
	smpsLoop            $01, $02, ToxicLandfill_Loop2A

ToxicLandfill_Loop2B:
	dc.b	nC2, nC2, nG1, nG1, $03, nBb1, $09, nG1, $06, nBb1, nB1
	smpsLoop            $00, $02, ToxicLandfill_Loop2B

ToxicLandfill_Loop2C:
	dc.b	nC2, nC2, nF1, nF1, $03, nG1, $09, $06, nBb1, nB1
	smpsLoop            $00, $02, ToxicLandfill_Loop2C
	smpsLoop            $01, $04, ToxicLandfill_Loop2B
	smpsJump            ToxicLandfill_Loop21

; FM5 Data
ToxicLandfill_FM5:
	smpsPan             panCenter, $00
	smpsAlterVol			-$06		
	smpsDetune			$02	
	smpsSetvoice        $00
	dc.b	nRst, $7F, $7F, $78, nE3, $02, nF3, $01, nFs3, $02, nG3, $01
	dc.b	nAb3, $02, nA3, $01, nBb3

ToxicLandfill_Jump01:
	dc.b	smpsNoAttack, $01, nB3

ToxicLandfill_Loop11:
	dc.b	nG3, $09, $09, $09, nF3, $03, nG3, $06, $06, nBb3, nG3, $09
	dc.b	$09, $09, nF3, $03, nG3, $06, $06, nC4, nG3, $09, $09, $09
	dc.b	nF3, $03, nG3, $06, $06, nBb3, nD3, $09, $09, $09, nC3, $03
	dc.b	nD3, $06, $06, nF3
	smpsLoop            $00, $02, ToxicLandfill_Loop11

ToxicLandfill_Loop13:
	dc.b	nG3, $12, nF3, $36, nE3, $02, nEb3, $01, nD3, $02, nCs3, $01
	dc.b	nC3, $02, nB2, $01, nBb2, $02, nA2, $01, nAb2, $02, nG2, $01
	dc.b	nFs2, $02, nF2, $01, nE2, $02, nEb2, $01, nD2, $02, nCs2, $01
	dc.b	nG3, $12, nF3, $2A, $03, nE3, nF3, nE3

ToxicLandfill_Loop12:
	dc.b	nF3, $02, nE3, $01
	smpsLoop            $00, $04, ToxicLandfill_Loop12
	dc.b	nF3, $02, nC3, nAb2, nF3, nC3, nAb2
	smpsLoop            $01, $02, ToxicLandfill_Loop13

ToxicLandfill_Loop14:
	dc.b	nC4, $06, nG3, nBb3, nB3, $03, nC4, $09, nG3, $06, nBb3, nB3
	smpsLoop            $00, $02, ToxicLandfill_Loop14

ToxicLandfill_Loop15:
	dc.b	nC4, nF3, nG3, nBb3, $03, nC4, $09, nF3, $06, nG3, nBb3
	smpsLoop            $00, $02, ToxicLandfill_Loop15
	smpsLoop            $01, $02, ToxicLandfill_Loop14

ToxicLandfill_Loop17:
	dc.b	nG4, $12, nF4, $36, nE4, $02, nEb4, $01, nD4, $02, nCs4, $01
	dc.b	nC4, $02, nB3, $01, nBb3, $02, nA3, $01, nAb3, $02, nG3, $01
	dc.b	nFs3, $02, nF3, $01, nE3, $02, nEb3, $01, nD3, $02, nCs3, $01
	dc.b	nG4, $12, nF4, $2A, $03, nE4, nF4, nE4

ToxicLandfill_Loop16:
	dc.b	nF4, $02, nE4, $01
	smpsLoop            $00, $04, ToxicLandfill_Loop16
	dc.b	nF4, $02, nC4, nAb3, nF4, nC4, nAb3
	smpsLoop            $01, $02, ToxicLandfill_Loop17

ToxicLandfill_Loop18:
	dc.b	nG4, $09, $09, $09, nF4, $03, nG4, $06, $06, nBb4, nG4, $09
	dc.b	$09, $09, nF4, $03, nG4, $06, $06, nC5, nG4, $09, $09, $09
	dc.b	nF4, $03, nG4, $06, $06, nBb4, nD4, $09, $09, $09, nC4, $03
	dc.b	nD4, $06, $06, nF4
	smpsLoop            $00, $02, ToxicLandfill_Loop18

ToxicLandfill_Loop19:
	dc.b	nC5, nG4, nBb4, nB4, $03, nC5, $09, nG4, $06, nBb4, nB4
	smpsLoop            $00, $02, ToxicLandfill_Loop19

ToxicLandfill_Loop1A:
	dc.b	nC5, nF4, nG4, nBb4, $03, nC5, $09, nF4, $06, nG4, nBb4
	smpsLoop            $00, $02, ToxicLandfill_Loop1A

ToxicLandfill_Loop1B:
	dc.b	nC5, nG4, nBb4, nB4, $03, nC5, $09, nG4, $06, nBb4, nB4
	smpsLoop            $00, $02, ToxicLandfill_Loop1B
	dc.b	nC5, nF4, nG4, nBb4, $03, nC5, $09, nF4, $06, nG4, nBb4, nC5
	dc.b	nF4, nG4, nBb4, $03, nC5, $09, nF4, $06, nG4, nBb4, $02, nRst
	smpsSetvoice        $02
	smpsDetune			-$02
	smpsAlterVol		$06
	
ToxicLandfill_Loop1C:
	dc.b	nC4, $06, nG3, nBb3, nB3, $03, nC4, $09, nG3, $06, nBb3, nB3	
	smpsLoop            $00, $02, ToxicLandfill_Loop1C

ToxicLandfill_Loop1D:
	dc.b	nC4, nF3, nG3, nBb3, $03, nC4, $09, nF3, $06, nG3, nBb3
	smpsLoop            $00, $02, ToxicLandfill_Loop1D

ToxicLandfill_Loop1E:
	dc.b	nC5, nG4, nBb4, nB4, $03, nC5, $09, nG4, $06, nBb4, nB4
	smpsLoop            $00, $02, ToxicLandfill_Loop1E

ToxicLandfill_Loop1F:
	dc.b	nC5, nF4, nG4, nBb4, $03, nC5, $09, nF4, $06, nG4, nBb4
	smpsLoop            $00, $02, ToxicLandfill_Loop1F
	smpsSetvoice        $00
	smpsDetune			$02
	smpsAlterVol		-$06	
	smpsJump            ToxicLandfill_Jump01

; PSG1 Data
ToxicLandfill_PSG1:
	dc.b	nRst, $7F, $7F, $7F, $03

ToxicLandfill_Jump04:
	dc.b	nRst

ToxicLandfill_Loop57:
	dc.b	$60
	smpsLoop            $00, $08, ToxicLandfill_Loop57

ToxicLandfill_Loop58:
	dc.b	nC3, $06, nG2, nBb2, nB2, $03, nC3, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop58

ToxicLandfill_Loop59:
	dc.b	nC3, nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2
	smpsLoop            $00, $02, ToxicLandfill_Loop59

ToxicLandfill_Loop5A:
	dc.b	nC3, nG2, nBb2, nB2, $03, nC3, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop5A
	dc.b	nC3, nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2, nC3
	dc.b	nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2, $04, nRst

ToxicLandfill_Loop5B:
	dc.b	$6E
	smpsLoop            $00, $07, ToxicLandfill_Loop5B

ToxicLandfill_Loop5C:
	dc.b	nC3, $06, nG2, nBb2, nB2, $03, nC3, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop5C

ToxicLandfill_Loop5D:
	dc.b	nC3, nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2
	smpsLoop            $00, $02, ToxicLandfill_Loop5D
	smpsLoop            $01, $03, ToxicLandfill_Loop5C

ToxicLandfill_Loop5E:
	dc.b	nC3, nG2, nBb2, nB2, $03, nC3, $09, nG2, $06, nBb2, nB2
	smpsLoop            $00, $02, ToxicLandfill_Loop5E
	dc.b	nC3, nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2, nC3
	dc.b	nF2, nG2, nBb2, $03, nC3, $09, nF2, $06, nG2, nBb2, $05, nRst
	dc.b	$01
	smpsJump            ToxicLandfill_Jump04

; PSG2 Data
ToxicLandfill_PSG2:
	dc.b	nRst, $7F, $7F, $7F, $03

ToxicLandfill_Jump03:
	dc.b	nRst

ToxicLandfill_Loop50:
	dc.b	$60
	smpsLoop            $00, $08, ToxicLandfill_Loop50
	dc.b	nG2, $06, nD2, nF2, nFs2, $03, nG2, $09, nD2, $06, nF2, nFs2
	dc.b	nG2, nD2, nF2, nFs2, $03, nG2, $08, nRst, $01, nD2, $06, nF2
	dc.b	nFs2, nG2, nC2, nD2, nF2, $03, nG2, $09, nC2, $06, nD2, nF2
	dc.b	nG2, nC2, nD2, nF2, $03, nG2, $08, nRst, $01, nC2, $06, nD2
	dc.b	nF2

ToxicLandfill_Loop51:
	dc.b	nG2, nD2, nF2, nFs2, $03, nG2, $09, nD2, $06, nF2, nFs2
	smpsLoop            $00, $02, ToxicLandfill_Loop51
	dc.b	nG2, nC2, nD2, nF2, $03, nG2, $09, nC2, $06, nD2, nF2, nG2
	dc.b	nC2, nD2, nF2, $03, nG2, $08, nRst, $01, nC2, $06, nD2, nF2
	dc.b	$05, nRst

ToxicLandfill_Loop52:
	dc.b	$60
	smpsLoop            $00, $08, ToxicLandfill_Loop52
	dc.b	$01

ToxicLandfill_Loop53:
	dc.b	nG2, $06, nD2, nF2, nFs2, $03, nG2, $09, nD2, $06, nF2, nFs2
	dc.b	nG2, nD2, nF2, nFs2, $03, nG2, $08, nRst, $01, nD2, $06, nF2
	dc.b	nFs2, nG2, nC2, nD2, nF2, $03, nG2, $09, nC2, $06, nD2, nF2
	dc.b	nG2, nC2, nD2, nF2, $03, nG2, $08, nRst, $01, nC2, $06, nD2
	dc.b	nF2
	smpsLoop            $00, $02, ToxicLandfill_Loop53

ToxicLandfill_Loop54:
	dc.b	nG2, nD2, nF2, nFs2, $03, nG2, $09, nD2, $06, nF2, nFs2
	smpsLoop            $00, $02, ToxicLandfill_Loop54

ToxicLandfill_Loop55:
	dc.b	nG2, nC2, nD2, nF2, $03, nG2, $09, nC2, $06, nD2, nF2
	smpsLoop            $00, $02, ToxicLandfill_Loop55

ToxicLandfill_Loop56:
	dc.b	nG2, nD2, nF2, nFs2, $03, nG2, $09, nD2, $06, nF2, nFs2
	smpsLoop            $00, $02, ToxicLandfill_Loop56
	dc.b	nG2, nC2, nD2, nF2, $03, nG2, $09, nC2, $06, nD2, nF2, nG2
	dc.b	nC2, nD2, nF2, $03, nG2, $09, nC2, $06, nD2, nF2, $05, nRst
	dc.b	$01
	smpsJump            ToxicLandfill_Jump03

; PSG3 Data
ToxicLandfill_PSG3:
	smpsPSGform         $E7
	dc.b	nRst, $7F, $41, nMaxPSG, $0C, $0C, $0C, $0C

ToxicLandfill_Loop4E:
	dc.b	$0C, $0C, $06, $03, $03
	smpsPSGvoice        fTone_01
	dc.b	$0C
	smpsPSGvoice        fTone_02
	smpsLoop            $00, $02, ToxicLandfill_Loop4E
	dc.b	$06, $03, $03
	smpsPSGvoice        fTone_01
	dc.b	$06
	smpsPSGvoice        fTone_02
	dc.b	$03
	smpsPSGvoice        fTone_01
	dc.b	$09, $06, $06, $06

ToxicLandfill_Jump02:
	dc.b	smpsNoAttack, $7F, smpsNoAttack, $7F, smpsNoAttack, $7F, smpsNoAttack, $15
	smpsPSGvoice        fTone_02
	dc.b	nMaxPSG, $18, $18, $18
	smpsPSGvoice        fTone_01
	dc.b	$18
	smpsPSGvoice        fTone_02
	dc.b	$18, $06
	smpsPSGvoice        fTone_01
	dc.b	$09, $09, $09, $09, $06, $18
	smpsPSGvoice        fTone_02
	dc.b	$18, $18, $18
	smpsPSGvoice        fTone_01
	dc.b	$18
	smpsPSGvoice        fTone_02
	dc.b	$18, $06
	smpsPSGvoice        fTone_01
	dc.b	$09, $09, $09, $09, $06, $7F, smpsNoAttack, $7F, smpsNoAttack, $7F, smpsNoAttack, $1B
	smpsPSGvoice        fTone_02
	dc.b	$18, $18, $18
	smpsPSGvoice        fTone_01
	dc.b	$18
	smpsPSGvoice        fTone_02
	dc.b	$18, $06
	smpsPSGvoice        fTone_01
	dc.b	$09, $09, $09, $09, $06, $18
	smpsPSGvoice        fTone_02
	dc.b	$18, $18, $18
	smpsPSGvoice        fTone_01
	dc.b	$18
	smpsPSGvoice        fTone_02
	dc.b	$18, $06
	smpsPSGvoice        fTone_01
	dc.b	$09, $09, $09, $09, $06

ToxicLandfill_Loop4F:
	dc.b	$59, smpsNoAttack
	smpsLoop            $00, $0C, ToxicLandfill_Loop4F
	dc.b	$5A
	smpsJump            ToxicLandfill_Jump02


ToxicLandfill_Voices:
;	Voice $00
;	$29
;	$33, $02, $02, $01, 	$1F, $1F, $1F, $19, 	$00, $02, $00, $0B
;	$03, $02, $00, $03, 	$0A, $1A, $0A, $1A, 	$1A, $1D, $20, $05
	smpsVcAlgorithm     $01
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $03
	smpsVcCoarseFreq    $01, $02, $02, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $19, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0B, $00, $02, $00
	smpsVcDecayRate2    $03, $00, $02, $03
	smpsVcDecayLevel    $01, $00, $01, $00
	smpsVcReleaseRate   $0A, $0A, $0A, $0A
	smpsVcTotalLevel    $05, $20, $1D, $1A
	
;	Voice $01
;	$18
;	$37, $30, $30, $31, 	$9E, $DC, $1C, $9C, 	$0D, $06, $04, $01
;	$08, $0A, $03, $05, 	$BF, $BF, $3F, $2F, 	$32, $22, $14, $00
	smpsVcAlgorithm     $00
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $03
	smpsVcCoarseFreq    $01, $00, $00, $07
	smpsVcRateScale     $02, $00, $03, $02
	smpsVcAttackRate    $1C, $1C, $1C, $1E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $01, $04, $06, $0D
	smpsVcDecayRate2    $05, $03, $0A, $08
	smpsVcDecayLevel    $02, $03, $0B, $0B
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $14, $22, $32

;	Voice $02
;	$2C
;	$72, $78, $34, $34, 	$1F, $12, $1F, $12, 	$00, $0A, $00, $0A
;	$00, $00, $00, $00, 	$00, $16, $00, $16, 	$16, $00, $17, $00
	smpsVcAlgorithm     $04
	smpsVcFeedback      $05
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $04, $08, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $1F, $12, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $00, $0A, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $00, $01, $00
	smpsVcReleaseRate   $06, $00, $06, $00
	smpsVcTotalLevel    $00, $17, $00, $16
