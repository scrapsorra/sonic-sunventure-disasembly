; ---------------------------------------------------------------------------
; Fuzzy - Chaos Emerald
; ---------------------------------------------------------------------------
ChaosEmerald:
        moveq   #0, d0
        move.b  obRoutine(a0), d0
        move.w  @Index(pc,d0.w), d1
        jsr     @Index(pc, d1.w)

        jmp     DisplaySprite

; ===========================================================================
@BaseY:         equ $38
@BlinkCounter:  equ $3A
@SineTimer:     equ $3F

@Index: dc.w @Init-@Index
        dc.w @Hover-@Index
        dc.w @Collect-@Index
        dc.w @Destroy-@Index
; ===========================================================================

@Init:
        move.b  obSubtype(a0), d0
        move.b  (v_emldlist).w, d1

        btst    d0, d1              ; do you have this emerald?
        bne.s   @Destroy            ; if not, break

        move.l  #Map_Emerald, obMap(a0)
        move.w  #$7BC, obGfx(a0)
        move.b  #$47, obColType(a0) ; sets routine counter to 4 on touch
        move.b	#4, obRender(a0)
        move.b  obY(a0), @BaseY(a0)
        addq.b  #2, obRoutine(a0)

@Hover:
        ; calculate sine based on timer
        move.b	@SineTimer(a0),d0
        jsr	(CalcSine).l
        asr.w	#7, d0

        ; add our base y position to the sine and apply position
        add.w	@BaseY(a0), d0
        move.w	d0, obY(a0)
        add.w	#$50,obY(a0)

        ; add to sine timer
        addq.b	#3, @SineTimer(a0)

        ; remember state
        bra.w	RememberState

@Collect:
        move.b  #2, obId(a0)
        move.b  #2, obRoutine(a0)
        move.b  obSubtype(a0), d0

        bset    d0, (v_emldlist).w  ; add emerald to list
        add.b   #1, (v_emeralds)    ; add 1 to emerald counter
        move.b	#1, (f_emeraldm).w  ; set emerald collected flag
        move.b  #0, obRoutine(a0)
        
        move.b  #sfx_GiantRing, d0
        jsr     PlaySound_Special
        jsr     WhiteFlash

@Destroy:
        jmp     DeleteObject

; ===========================================================================

Nem_Emerald:
        incbin  "artnem/Chaos Emerald.bin"
        even

        include "_maps/Chaos Emerald.asm"
        