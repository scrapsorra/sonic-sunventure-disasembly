
; ===========================================================================
; Fuzzy - SRAM-Related Routines
; ===========================================================================

InitSRAM:
		OperateInSRAM
		KDebug.WriteLine "Initializing SRAM..."
		lea 	($200001).l, a0     ; Load SRAM memory into a0 (Change the last digit to 0 if you're using even SRAM)

		movep.l InitSting(a0), d0		; Get the existing string at the start of SRAM
		cmp.l   #Version, d0			; Was it already in SRAM?
		bne.s   ResetSRAM2			; If so, skip

		ExitSRAM
		rts

; ===========================================================================

ResetSRAM:
		OperateInSRAM
		lea		($200001).l, a0

ResetSRAM2:
		KDebug.WriteLine "Resetting SRAM..."

		move.l	#Version, d0
		movep.l	d0, 0(a0)			; SRAM => Version
		move.l	SRAMDefaults(pc), d0
		movep.l	d0, 8(a0)			; SRAM => Color, Camera, Zone, Emeralds
		move.l	SRAMDefaults+4(pc), d0
		movep.l	d0, $10(a0)			; SRAM => Emeralds List, Saved Lives, Null, Null

		ExitSRAM
		rts

; ===========================================================================

SRAMDefaults:
		dc.b 0, 0, 0, 0 			; Color, Camera, Zone, Emeralds
		dc.b 0, 3, 0, 0 			; Emeralds List, Saved Lives, Null, Null
		even


; ===========================================================================
; SRAM loading and saving routines
; ===========================================================================
LoadSRAM:
		OperateInSRAM
		KDebug.WriteLine "Loading from SRAM..."

		lea 	($200001).l, a0
		move.b 	SavedColor(a0), (v_playerpal).w
		move.b 	SavedCamera(a0), (v_extendedcam).w
		move.b 	SavedZone(a0), (v_zone).w
		move.b 	SavedEmeralds(a0), (v_emeralds).w
		move.b 	SavedEmeraldList(a0), (v_emldlist).w
		move.b 	SavedLives(a0), (v_lives).w
		
		ExitSRAM
		rts

; ===========================================================================

SaveSRAM:
		OperateInSRAM
		KDebug.WriteLine "Saving to SRAM..."

		lea 	($200001).l, a0
		move.b 	(v_playerpal).w, SavedColor(a0)
		move.b 	(v_extendedcam).w, SavedCamera(a0)
		move.b 	(v_zone).w, SavedZone(a0)
		move.b 	(v_emeralds).w, SavedEmeralds(a0)
		move.b 	(v_emldlist).w, SavedEmeraldList(a0)
		move.b 	(v_lives).w, SavedLives(a0)

		ExitSRAM
		rts