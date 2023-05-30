; ---------------------------------------------------------------------------
; Nemesis decompression	subroutine, decompresses art directly to VRAM
; Inputs:
; a0 = art address

; For format explanation see http://info.sonicretro.org/Nemesis_compression
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Nemesis decompression to VRAM
NemDec:
		movem.l	d0-a1/a3/a5,-(sp)
		lea	NemPCD_WriteRowToVDP(pc),a3	; write all data to the same location
		lea	(v_ngfx_buffer).w,a1
		move.w	(a0)+,d2	; get number of patterns
		bpl.s	loc_146A	; branch if the sign bit isn't set
		lea	NemPCD_WriteRowToVDP_XOR-NemPCD_WriteRowToVDP(a3),a3	; otherwise the file uses XOR mode

loc_146A:
		lsl.w	#3,d2	; get number of 8-pixel rows in the uncompressed data
		movea.w	d2,a5	; and store it in a5 because there aren't any spare data registers
		moveq	#7,d3	; 8 pixels in a pattern row
		moveq	#0,d2
		moveq	#0,d4
		bsr.w	NemDec_BuildCodeTable
		move.b	(a0)+,d5	; get first byte of compressed data
		asl.w	#8,d5	; shift up by a byte
		move.b	(a0)+,d5	; get second byte of compressed data
		moveq	#$10,d6	; set initial shift value
		bsr.s	NemDec_ProcessCompressedData
		movem.l	(sp)+,d0-a1/a3/a5
		rts
; End of function NemDec

; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, processes the actual compressed data
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


NemDec_ProcessCompressedData:
		move.b	d6,d7
		subq.b	#8,d7	; get shift value
		move.w	d5,d1
		lsr.w	d7,d1	; shift so that high bit of the code is in bit position 7
		cmpi.b	#%11111100,d1	; are the high 6 bits set?
		bcc.s	NemPCD_InlineData	; if they are, it signifies inline data
		andi.w	#$FF,d1
		add.w	d1,d1
		sub.b	(a1,d1.w),d6	; get the length of the code in bits
		moveq	#0,d0
		move.b	1(a1,d1.w),d0

NemPCD_FindNewByte:
		cmpi.b	#9,d6	; does a new byte need to be read?
		bcc.s	loc_14B2	; if not, branch
		addq.b	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5	; read next byte

loc_14B2:
		moveq	#$F,d1	; get palette index for pixel
		and.w	d0,d1

NemPCD_ProcessCompressedData:
		lsr.w	#4,d0	; get repeat count

NemPCD_WritePixel:
		lsl.l	#4,d4	; shift up by a nybble
		or.b	d1,d4	; write pixel
		dbf	d3,NemPCD_WritePixel_Loop	; if not, loop
		jmp	(a3)	; otherwise, write the row to its destination, by doing a dynamic jump to NemPCD_WriteRowToVDP, NemDec_WriteAndAdvance, NemPCD_WriteRowToVDP_XOR, or NemDec_WriteAndAdvance_XOR
; End of function NemDec_ProcessCompressedData


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


NemPCD_NewRow:
		moveq	#0,d4	; reset row
		moveq	#7,d3	; reset nybble counter

NemPCD_WritePixel_Loop:
		dbf	d0,NemPCD_WritePixel
		bra.s	NemDec_ProcessCompressedData
; ===========================================================================

NemPCD_InlineData:
		cmpi.b	#9+6,d6
		bcc.s	loc_14E4
		addq.b	#8,d6
		asl.w	#8,d5
		move.b	(a0)+,d5

loc_14E4:
		subi.b	#7+6,d6	; and 7 bits needed for the inline data itself
		move.w	d5,d1
		lsr.w	d6,d1	; shift so that low bit of the code is in bit position 0
		moveq	#$7F,d0
		and.w	d1,d0	; get palette index for pixel
		bra.s	NemPCD_FindNewByte
; End of function NemPCD_NewRow

; ===========================================================================

NemPCD_WriteRowToVDP:
		move.l	d4,(vdp_data_port).l	; write 8-pixel row
		subq.w	#1,a5
		move.w	a5,d4	; have all the 8-pixel rows been written?
		bne.s	NemPCD_NewRow	; if not, branch
		rts		; otherwise the decompression is finished
; ===========================================================================
NemPCD_WriteRowToVDP_XOR:
		eor.l	d4,d2	; XOR the previous row by the current row
		move.l	d2,(vdp_data_port).l	; and write the result
		subq.w	#1,a5
		move.w	a5,d4
		bne.s	NemPCD_NewRow
		rts

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; ---------------------------------------------------------------------------
; Part of the Nemesis decompressor, builds the code table (in RAM)
; ---------------------------------------------------------------------------


NemDec_BuildCodeTable:
		move.b	(a0)+,d0	; read first byte

NemBCT_ChkEnd:
		addq.b	#1,d0	; has the end of the code table description been reached?
		bne.s	NemBCT_NewPALIndex	; if not, branch
		rts	; otherwise, this subroutine's work is done
; ===========================================================================

NemBCT_NewPALIndex:
		subq.b	#1,d0
                move.b	d0,d7

NemBCT_Loop:
		move.b	(a0)+,d0	; read next byte
		bmi.s	NemBCT_ChkEnd

		move.b	d0,d1
		andi.w	#$F,d7	; get palette index
		andi.w	#$70,d1	; get repeat count for palette index
		or.w	d1,d7	; combine the two
		andi.w	#$F,d0	; get the length of the code in bits
		move.b	d0,d1
		lsl.w	#8,d1
		or.w	d1,d7	; combine with palette index and repeat count to form code table entry
		moveq	#8,d1
		sub.w	d0,d1	; is the code 8 bits long?
		bne.s	NemBCT_ShortCode	; if not, a bit of extra processing is needed
		move.b	(a0)+,d0	; get code
		add.w	d0,d0	; each code gets a word-sized entry in the table
		move.w	d7,(a1,d0.w)	; store the entry for the code
		bra.s	NemBCT_Loop	; repeat
; ===========================================================================

; the Nemesis decompressor uses prefix-free codes (no valid code is a prefix of a longer code)
; e.g. if 10 is a valid 2-bit code, 110 is a valid 3-bit code but 100 isn't
; also, when the actual compressed data is processed the high bit of each code is in bit position 7
; so the code needs to be bit-shifted appropriately over here before being used as a code table index
; additionally, the code needs multiple entries in the table because no masking is done during compressed data processing
; so if 11000 is a valid code then all indices of the form 11000XXX need to have the same entry
NemBCT_ShortCode:
		move.b	(a0)+,d0	; get code
		lsl.w	d1,d0	; get index into code table
		add.w	d0,d0	; shift so that high bit is in bit position 7
		moveq	#1,d5
		lsl.w	d1,d5
		subq.w	#1,d5	; d5 = 2^d1 - 1

NemBCT_ShortCode_Loop:
		move.w	d7,(a1,d0.w)	; store entry
		addq.w	#2,d0	; increment index
		dbf	d5,NemBCT_ShortCode_Loop	; repeat for required number of entries
		bra.s	NemBCT_Loop
; End of function NemDec_BuildCodeTable
