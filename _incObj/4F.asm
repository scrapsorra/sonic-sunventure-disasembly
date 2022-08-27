; ---------------------------------------------------------------------------
; Object 4F - Splats
; ---------------------------------------------------------------------------

Obj4F:
                moveq   #0,d0
                move.b  $24(a0),d0
                move.w  ObjSplats_Index(pc,d0.w),d1
                jmp     ObjSplats_Index(pc,d1.w)
; ---------------------------------------------------------------------------
ObjSplats_Index:dc.w ObjSplats_Init-*
                dc.w loc_D246-ObjSplats_Index
                dc.w ObjSplats_Bounce-ObjSplats_Index
                dc.w loc_D2C8-ObjSplats_Index
; ---------------------------------------------------------------------------

ObjSplats_Init:
                addq.b  #2,$24(a0)
                move.l  #Map_Splats,4(a0)
                move.w  #$24E4,2(a0)
                move.b  #4,1(a0)
                move.b  #4,obActWid(a0)
				move.w	#$200,obPriority(a0)
                move.b  #$14,$16(a0)
                move.b  #2,$20(a0)
                tst.b   $28(a0)
                beq.s   loc_D246
                move.w  #$300,d2
                bra.s   ObjSplats_FaceRight
; ---------------------------------------------------------------------------

loc_D246:
                move.w  #$E0,d2

ObjSplats_FaceRight:
                move.w  #$100,d1
                bset    #0,1(a0)
                move.w  ($FFFFD008).w,d0
                sub.w   8(a0),d0
                bcc.s   ObjSplats_Move
                neg.w   d0
                neg.w   d1
                bclr    #0,1(a0)

ObjSplats_Move:
                cmp.w   d2,d0
                bcc.s   ObjSplats_Bounce
                move.w  d1,$10(a0)
                addq.b  #2,$24(a0)

ObjSplats_Bounce:
                bsr.w   ObjectFall
                move.b  #1,$1A(a0)
                tst.w   $12(a0)
                bmi.s   ObjSplats_Turn
                move.b  #0,$1A(a0)
                bsr.w   ObjFloorDist
                tst.w   d1
                bpl.s   ObjSplats_Turn
                move.w  (a1),d0
                andi.w  #$3FF,d0
                cmpi.w  #$2D2,d0
                bcs.s   ObjSplats_Fall
                addq.b  #2,$24(a0)
                bra.s   ObjSplats_Turn
; ---------------------------------------------------------------------------

ObjSplats_Fall:
                add.w   d1,$C(a0)
                move.w  #$FC00,$12(a0)

ObjSplats_Turn:
                bsr.w   Yad_ChkWall
                beq.s   loc_D2C4
                neg.w   $10(a0)
                bchg    #0,1(a0)
                bchg    #0,$22(a0)

loc_D2C4:
                bra.w   RememberState
; ---------------------------------------------------------------------------

loc_D2C8:
                bsr.w   ObjectFall
                bsr.w   DisplaySprite
                tst.b   1(a0)
                bpl.w   DeleteObject
                rts