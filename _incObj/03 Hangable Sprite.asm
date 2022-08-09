; ===========================================================================
; ----------------------------------------------------------------------------
; Object 03 - Invisible sprite that you can hang on to
; ----------------------------------------------------------------------------
; Sprite_2C92C:
Obj03:
	moveq    #0,d0
    move.b    obRoutine(a0),d0            ;just use s1 version of this variable
    move.w    Obj03_Index(pc,d0.w),d1
    jmp    Obj03_Index(pc,d1.w)
; ===========================================================================
; off_2C93A:
Obj03_Index:
    dc.w Obj03_Main-Obj03_Index
        dc.w Obj03_Init-Obj03_Index
; ===========================================================================
; loc_2C93E:
Obj03_Init:
    addq.b    #2,obRoutine(a0)        ;just use s1 version of this variable
    move.b    #4,obRender(a0)    ;just use s1 version of this variable
    move.b    #$18,obActWid(a0)    ;just use s1 version of this variable
    move.b    #4,obPriority(a0)            ;just use s1 version of this variable
; loc_2C954:
Obj03_Main:
    lea    $30(a0),a2
    lea    (v_player).w,a1 ; a1=character
    move.w    (v_jpadhold1).w,d0 			;S1 has same ram address for controller as S2 just different variable name like on the line above
    bsr.s    Obj03_Check
;    lea    (Sidekick).w,a1 ; a1=character  ;disabled
;    addq.w    #1,a2                          ;disabled
;    move.w    (Ctrl_2).w,d0                    ;disabled
;    bsr.s    Obj03_Check         	;disabled
	jmp		bonu_chkdel
; ===========================================================================
; loc_2C972:
Obj03_Check:
		tst.b	(a2)
		beq.s	loc_2C9A0
		andi.b	#btnABC,d0
		beq.w	Obj03_Check_End
		clr.b	f_lockmulti.w
		clr.b	(a2)
		move.b	#$12,2(a2)
		andi.w	#$F00,d0
		beq.s	loc_2C954
		move.b	#$3C,2(a2)
	
loc_2C954:
		move.w	#-$300,y_vel(a1)
		bra.w	Obj03_Check_End
; ===========================================================================

loc_2C9A0:
		tst.b	2(a2)
		beq.s	loc_2C972
		subq.b	#1,2(a2)
		bne.w	Obj03_Check_End

loc_2C972:
		move.w	obX(a1),d0
		sub.w	obX(a0),d0
		addi.w	#$18,d0
		cmpi.w	#$30,d0
		bhs.w	Obj03_Check_End
		move.w	obY(a1),d1
		sub.w	obY(a0),d1
		cmpi.w	#$10,d1
		bhs.w	Obj03_Check_End
		tst.b	f_lockmulti.w
		bmi.s	Obj03_Check_End
		cmpi.b	#6,obRoutine(a1)
		bhs.s	Obj03_Check_End
		tst.w	(f_debugmode).w
		bne.s	Obj03_Check_End
		clr.w	x_vel(a1)
		clr.w	y_vel(a1)
		clr.w	obInertia(a1)
		move.w	obY(a0),obY(a1)
		move.b	#id_Hang2,obAnim(a1)
		move.b	#1,f_lockmulti.w
		move.b	#1,(a2)

; return_2CA08:
Obj03_Check_End:
		rts