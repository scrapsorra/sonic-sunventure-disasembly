; ---------------------------------------------------------------------------
; Object 10 - After-Image
; ---------------------------------------------------------------------------

Obj10:
      cmpi.b   #id_Death,(v_player+obAnim).w   ; is Sonic using the death animation?
      beq.w   AfterimageEnd      ; if yes, delete the After Image

      moveq   #0,d0
      move.b   obRoutine(a0),d0
      move.w   Afterimage_Index(pc,d0.w),d1
      jmp	Afterimage_Index(pc,d1.w)

; ===========================================================================
;           Change the length by moving around the "No Afterimage" and "After Image Start/ After Image L Priority" sections.
; ===========================================================================
Afterimage_Index:
      dc.w NoAfterImage-Afterimage_Index
      dc.w NoAfterImage-Afterimage_Index
      dc.w NoAfterImage-Afterimage_Index
      dc.w AfterimageStart-Afterimage_Index
      dc.w NoAfterImage-Afterimage_Index
      dc.w NoAfterImage-Afterimage_Index
      dc.w NoAfterImage-Afterimage_Index
      dc.w AfterimageLPrio-Afterimage_Index
      dc.w AfterimageEnd-Afterimage_Index
; ===========================================================================
NoAfterImage:
      addq.b   #2,obRoutine(a0)         ; go to next item of index, at the next frame
      rts
; ===========================================================================
AfterimageStart:
      move.b   #2,obPriority(a0)         ; set sprite priority to 2
      bra.s   Afterimage_Show
; ===========================================================================
AfterimageLPrio:
      addq.b   #1,obPriority(a0)         ; set a lower sprite priority
; ===========================================================================
Afterimage_Show:
      addq.b   #2,obRoutine(a0)            ; go to next item of index
      jsr   (RandomNumber).l         ; get a random number
      andi.b   #3,d0               ; get a number equal or lower than 2 (0 until 2)
      bne.s   AfterimageException   ; if is not 0, branch
      rts                        ; if it is 0, then don't show the after-image

AfterimageException:
      move.w   (v_player+obGfx).w,obGfx(a0)      ; copy Sonic map to after-image map
       move.b   (v_player+obRender).w,obRender(a0)      ; copy Sonic frame infos (horizontal/vertical mirror, coordinate system......)
       move.l   (v_player+obFrame).w,obFrame(a0)   ; copy the Sonic animation frame
      jmp   DisplaySprite
; ===========================================================================
AfterimageEnd:
      jmp   DeleteObject