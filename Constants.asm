; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

Size_of_SegaPCM:		equ $6978

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
vdp_counter:		equ $C00008

psg_input:		equ $C00011

; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
z80_dac3_pitch:		equ $A000EA
z80_dac_status:		equ $A01FFD
z80_dac_sample:		equ $A01FFF
z80_ram_end:		equ $A02000	; end of non-reserved Z80 RAM
z80_version:		equ $A10001
z80_port_1_data:	equ $A10002
z80_port_1_control:	equ $A10008
z80_port_2_control:	equ $A1000A
z80_expansion_control:	equ $A1000C
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200
ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003

security_addr:		equ $A14000

; Sound driver constants
TrackPlaybackControl:	equ 0		; All tracks
TrackVoiceControl:	equ 1		; All tracks
TrackTempoDivider:	equ 2		; All tracks
TrackDataPointer:	equ 4		; All tracks (4 bytes)
TrackTranspose:		equ 8		; FM/PSG only (sometimes written to as a word, to include TrackVolume)
TrackVolume:		equ 9		; FM/PSG only
TrackAMSFMSPan:		equ $A		; FM/DAC only
TrackVoiceIndex:	equ $B		; FM/PSG only
TrackVolEnvIndex:	equ $C		; PSG only
TrackStackPointer:	equ $D		; All tracks
TrackDurationTimeout:	equ $E		; All tracks
TrackSavedDuration:	equ $F		; All tracks
TrackSavedDAC:		equ $10		; DAC only
TrackFreq:		equ $10		; FM/PSG only (2 bytes)
TrackNoteTimeout:	equ $12		; FM/PSG only
TrackNoteTimeoutMaster:equ $13		; FM/PSG only
TrackModulationPtr:	equ $14		; FM/PSG only (4 bytes)
TrackModulationWait:	equ $18		; FM/PSG only
TrackModulationSpeed:	equ $19		; FM/PSG only
TrackModulationDelta:	equ $1A		; FM/PSG only
TrackModulationSteps:	equ $1B		; FM/PSG only
TrackModulationVal:	equ $1C		; FM/PSG only (2 bytes)
TrackDetune:		equ $1E		; FM/PSG only
TrackPSGNoise:		equ $1F		; PSG only
TrackFeedbackAlgo:	equ $1F		; FM only
TrackVoicePtr:		equ $20		; FM SFX only (4 bytes)
TrackLoopCounters:	equ $24		; All tracks (multiple bytes)
TrackGoSubStack:	equ TrackSz	; All tracks (multiple bytes. This constant won't get to be used because of an optimisation that just uses zTrackSz)

TrackSz:	equ $30

; VRAM data
vram_fg:	equ $C000	; foreground namespace
vram_bg:	equ $E000	; background namespace
vram_sonic:	equ $F000	; Sonic graphics
vram_sprites:	equ $F800	; sprite table
vram_hscroll:	equ $FC00	; horizontal scroll table

; Game modes
id_Sega:	equ ptr_GM_Sega-GameModeArray	; $00
id_Title:	equ ptr_GM_Title-GameModeArray	; $04
id_Demo:	equ ptr_GM_Demo-GameModeArray	; $08
id_Level:	equ ptr_GM_Level-GameModeArray	; $0C
id_Special:	equ ptr_GM_Special-GameModeArray; $10
id_Continue:	equ ptr_GM_Cont-GameModeArray	; $14
id_Ending:	equ ptr_GM_Ending-GameModeArray	; $18
id_Credits:	equ ptr_GM_Credits-GameModeArray; $1C

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SS:		equ 7

; colors
cBlack:		equ $000		; color black
cWhite:		equ $EEE		; color white
cBlue:		equ $E00		; color blue
cGreen:		equ $0E0		; color green
cRed:		equ $00E		; color red
cYellow:	equ cGreen+cRed		; color yellow
cAqua:		equ cGreen+cBlue	; color aqua
cMagenta:	equ cBlue+cRed		; color magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
obId:       equ 0   ; object id
obRender:	equ 1	; bitfield for x/y flip, display mode
obGfx:		equ 2	; palette line & VRAM setting (2 bytes)
obMap:		equ 4	; mappings address (4 bytes)
obX:		equ 8	; x-axis position (2-4 bytes)
obScreenY:	equ $A	; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C	; y-axis position (2-4 bytes)
obVelX:		equ $10	; x-axis velocity (2 bytes)
obVelY:		equ $12	; y-axis velocity (2 bytes)
obInertia:	equ $20	; potential speed (2 bytes)
obHeight:	equ $16	; height/2
obWidth:	equ $17	; width/2
obPriority:	equ $18	; sprite stack priority -- 0 is front
obActWid:	equ $14	; action width
obFrame:	equ $1A	; current frame displayed
obAniFrame:	equ $1B	; current frame in animation script
obAnim:		equ $1C	; current animation
obNextAni:	equ $1D	; next animation
obTimeFrame:	equ $1E	; time to next frame
obDelayAni:	equ $1F	; time to delay animation
obColType:	equ $20	; collision response type
obColProp:	equ $21	; collision extra property
obStatus:	equ $22	; orientation or mode
obRespawnNo:	equ $23	; respawn list index number
obRoutine:	equ $24	; routine number
ob2ndRout:	equ $25	; secondary routine number
obAngle:	equ $26	; angle
obSubtype:	equ $28	; object subtype
obSolid:	equ ob2ndRout ; solid status flag

; Object variables used by Sonic
flashtime:	equ $30	; time between flashes after getting hit
invtime:	equ $32	; time left for invincibility
shoetime:	equ $34	; time left for speed shoes

; Shield variables
shield_LastLoadedDPLC:    equ $33
shield_DPLC_Address:    equ $3C
shield_Art_Address:    equ $38
shield_vram_art:    equ $36

; Object variables (Sonic 2 disassembly nomenclature)
render_flags:	equ 1	; bitfield for x/y flip, display mode
art_tile:	equ 2	; palette line & VRAM setting (2 bytes)
mappings:	equ 4	; mappings address (4 bytes)
x_pos:		equ 8	; x-axis position (2-4 bytes)
y_pos:		equ $C	; y-axis position (2-4 bytes)
x_vel:		equ $10	; x-axis velocity (2 bytes)
y_vel:		equ $12	; y-axis velocity (2 bytes)
y_radius:	equ $16	; height/2
x_radius:	equ $17	; width/2
priority:	equ $18	; sprite stack priority -- 0 is front
width_pixels:	equ $14	; action width
mapping_frame:	equ $1A	; current frame displayed
anim_frame:	equ $1B	; current frame in animation script
anim:		equ $1C	; current animation
next_anim:	equ $1D	; next animation
anim_frame_duration: equ $1E ; time to next frame
collision_flags: equ $20 ; collision response type
collision_property: equ $21 ; collision extra property
status:		equ $22	; orientation or mode
respawn_index:	equ $23	; respawn list index number
routine:	equ $24	; routine number
routine_secondary: equ $25 ; secondary routine number
angle:		equ $26	; angle
subtype:	equ $28	; object subtype

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter


mainspr_mapframe    = $B
mainspr_width        = $E
mainspr_childsprites     = $F    ; amount of child sprites
mainspr_height        = $14
sub2_x_pos        = $10    ;x_vel
sub2_y_pos        = $12    ;y_vel
sub2_mapframe        = $15
sub3_x_pos        = $16    ;y_radius
sub3_y_pos        = $18    ;priority
sub3_mapframe        = $1B    ;anim_frame
sub4_x_pos        = $1C    ;anim
sub4_y_pos        = $1E    ;anim_frame_duration
sub4_mapframe        = $21    ;collision_property
sub5_x_pos        = $22    ;status
sub5_y_pos        = $24    ;routine
sub5_mapframe        = $27
sub6_x_pos        = $28    ;subtype
sub6_y_pos        = $2A
sub6_mapframe        = $2D
sub7_x_pos        = $2E
sub7_y_pos        = $30
sub7_mapframe        = $33
sub8_x_pos        = $34
sub8_y_pos        = $36
sub8_mapframe        = $39
sub9_x_pos        = $3A
sub9_y_pos        = $3C
sub9_mapframe        = $3F
next_subspr       = $6

; Background music
bgm__First:	equ $81
bgm_GHZ:	equ ((ptr_mus81-MusicIndex)/4)+bgm__First
bgm_LZ:		equ ((ptr_mus82-MusicIndex)/4)+bgm__First
bgm_MZ:		equ ((ptr_mus83-MusicIndex)/4)+bgm__First
bgm_SLZ:	equ ((ptr_mus84-MusicIndex)/4)+bgm__First
bgm_SYZ:	equ ((ptr_mus85-MusicIndex)/4)+bgm__First
bgm_SBZ:	equ ((ptr_mus86-MusicIndex)/4)+bgm__First
bgm_Invincible:	equ ((ptr_mus87-MusicIndex)/4)+bgm__First
bgm_ExtraLife:	equ ((ptr_mus88-MusicIndex)/4)+bgm__First
bgm_SS:		equ ((ptr_mus89-MusicIndex)/4)+bgm__First
bgm_Title:	equ ((ptr_mus8A-MusicIndex)/4)+bgm__First
bgm_Ending:	equ ((ptr_mus8B-MusicIndex)/4)+bgm__First
bgm_Boss:	equ ((ptr_mus8C-MusicIndex)/4)+bgm__First
bgm_FZ:		equ ((ptr_mus8D-MusicIndex)/4)+bgm__First
bgm_GotThrough:	equ ((ptr_mus8E-MusicIndex)/4)+bgm__First
bgm_GameOver:	equ ((ptr_mus8F-MusicIndex)/4)+bgm__First
bgm_Continue:	equ ((ptr_mus90-MusicIndex)/4)+bgm__First
bgm_Credits:	equ ((ptr_mus91-MusicIndex)/4)+bgm__First
bgm_Drowning:	equ ((ptr_mus92-MusicIndex)/4)+bgm__First
bgm_Emerald:	equ ((ptr_mus93-MusicIndex)/4)+bgm__First
bgm_Pinch:		equ ((ptr_mus94-MusicIndex)/4)+bgm__First
bgm_Seaside:	equ ((ptr_mus95-MusicIndex)/4)+bgm__First
bgm_SBZ3:		equ ((ptr_mus96-MusicIndex)/4)+bgm__First
bgm_TimeOver:	equ ((ptr_mus97-MusicIndex)/4)+bgm__First
bgm_Options:	equ ((ptr_mus98-MusicIndex)/4)+bgm__First
bgm_ToxicLandfill:	equ ((ptr_mus99-MusicIndex)/4)+bgm__First
bgm_RRZ2:	equ ((ptr_mus9A-MusicIndex)/4)+bgm__First
bgm_TTZBF:	equ ((ptr_mus9B-MusicIndex)/4)+bgm__First
bgm_Tribute:	equ ((ptr_mus9C-MusicIndex)/4)+bgm__First
bgm__Last:	equ ((ptr_musend-MusicIndex-4)/4)+bgm__First

; Sound effects
sfx__First:	equ $A0
sfx_Jump:	equ ((ptr_sndA0-SoundIndex)/4)+sfx__First
sfx_Lamppost:	equ ((ptr_sndA1-SoundIndex)/4)+sfx__First
sfx_A2:		equ ((ptr_sndA2-SoundIndex)/4)+sfx__First
sfx_Death:	equ ((ptr_sndA3-SoundIndex)/4)+sfx__First
sfx_Skid:	equ ((ptr_sndA4-SoundIndex)/4)+sfx__First
sfx_LRingBox:	equ ((ptr_sndA5-SoundIndex)/4)+sfx__First
sfx_HitSpikes:	equ ((ptr_sndA6-SoundIndex)/4)+sfx__First
sfx_Push:	equ ((ptr_sndA7-SoundIndex)/4)+sfx__First
sfx_SSGoal:	equ ((ptr_sndA8-SoundIndex)/4)+sfx__First
sfx_SSItem:	equ ((ptr_sndA9-SoundIndex)/4)+sfx__First
sfx_Splash:	equ ((ptr_sndAA-SoundIndex)/4)+sfx__First
sfx_FireShield:	equ ((ptr_FireShield-SoundIndex)/4)+sfx__First
sfx_HitBoss:	equ ((ptr_sndAC-SoundIndex)/4)+sfx__First
sfx_Bubble:	equ ((ptr_sndAD-SoundIndex)/4)+sfx__First
sfx_Fireball:	equ ((ptr_sndAE-SoundIndex)/4)+sfx__First
sfx_Shield:	equ ((ptr_sndAF-SoundIndex)/4)+sfx__First
sfx_Saw:	equ ((ptr_sndB0-SoundIndex)/4)+sfx__First
sfx_Electric:	equ ((ptr_sndB1-SoundIndex)/4)+sfx__First
sfx_Drown:	equ ((ptr_sndB2-SoundIndex)/4)+sfx__First
sfx_Flamethrower:equ ((ptr_sndB3-SoundIndex)/4)+sfx__First
sfx_Bumper:	equ ((ptr_sndB4-SoundIndex)/4)+sfx__First
sfx_Ring:	equ ((ptr_sndB5-SoundIndex)/4)+sfx__First
sfx_SpikesMove:	equ ((ptr_sndB6-SoundIndex)/4)+sfx__First
sfx_Rumbling:	equ ((ptr_sndB7-SoundIndex)/4)+sfx__First
sfx_B8:		equ ((ptr_sndB8-SoundIndex)/4)+sfx__First
sfx_Collapse:	equ ((ptr_sndB9-SoundIndex)/4)+sfx__First
sfx_SSGlass:	equ ((ptr_sndBA-SoundIndex)/4)+sfx__First
sfx_Door:	equ ((ptr_sndBB-SoundIndex)/4)+sfx__First
sfx_Teleport:	equ ((ptr_sndBC-SoundIndex)/4)+sfx__First
sfx_ChainStomp:	equ ((ptr_sndBD-SoundIndex)/4)+sfx__First
sfx_Roll:	equ ((ptr_sndBE-SoundIndex)/4)+sfx__First
sfx_Continue:	equ ((ptr_sndBF-SoundIndex)/4)+sfx__First
sfx_Basaran:	equ ((ptr_sndC0-SoundIndex)/4)+sfx__First
sfx_BreakItem:	equ ((ptr_sndC1-SoundIndex)/4)+sfx__First
sfx_Warning:	equ ((ptr_sndC2-SoundIndex)/4)+sfx__First
sfx_GiantRing:	equ ((ptr_sndC3-SoundIndex)/4)+sfx__First
sfx_Bomb:	equ ((ptr_sndC4-SoundIndex)/4)+sfx__First
sfx_Cash:	equ ((ptr_sndC5-SoundIndex)/4)+sfx__First
sfx_RingLoss:	equ ((ptr_sndC6-SoundIndex)/4)+sfx__First
sfx_ChainRise:	equ ((ptr_sndC7-SoundIndex)/4)+sfx__First
sfx_Burning:	equ ((ptr_sndC8-SoundIndex)/4)+sfx__First
sfx_Bonus:	equ ((ptr_sndC9-SoundIndex)/4)+sfx__First
sfx_EnterSS:	equ ((ptr_sndCA-SoundIndex)/4)+sfx__First
sfx_WallSmash:	equ ((ptr_sndCB-SoundIndex)/4)+sfx__First
sfx_Spring:	equ ((ptr_sndCC-SoundIndex)/4)+sfx__First
sfx_Switch:	equ ((ptr_sndCD-SoundIndex)/4)+sfx__First
sfx_RingLeft:	equ ((ptr_sndCE-SoundIndex)/4)+sfx__First
sfx_Signpost:	equ ((ptr_sndCF-SoundIndex)/4)+sfx__First
sfx__Last:	equ ((ptr_sndend-SoundIndex-4)/4)+sfx__First

; Special sound effects
spec__First:	equ $D0
sfx_Waterfall:	equ ((ptr_sndD0-SpecSoundIndex)/4)+spec__First
sfx_LightningShield:	equ ((ptr_sndD1-SpecSoundIndex)/4)+spec__First
sfx_Peelout:	equ ((ptr_sndD2-SpecSoundIndex)/4)+spec__First
sfx_PeeloutRelease:	equ ((ptr_sndD3-SpecSoundIndex)/4)+spec__First
sfx_PeeloutStop:	equ ((ptr_sndD4-SpecSoundIndex)/4)+spec__First
sfx_Spindash:	equ ((ptr_sndD5-SpecSoundIndex)/4)+spec__First
spec__Last:	equ ((ptr_specend-SpecSoundIndex-4)/4)+spec__First

flg__First:	equ $E0
bgm_Fade:	equ ((ptr_flgE0-Sound_ExIndex)/4)+flg__First
sfx_Sega:	equ ((ptr_flgE1-Sound_ExIndex)/4)+flg__First
bgm_Speedup:	equ ((ptr_flgE2-Sound_ExIndex)/4)+flg__First
bgm_Slowdown:	equ ((ptr_flgE3-Sound_ExIndex)/4)+flg__First
bgm_Stop:	equ ((ptr_flgE4-Sound_ExIndex)/4)+flg__First
flg__Last:	equ ((ptr_flgend-Sound_ExIndex-4)/4)+flg__First

; Sonic frame IDs
fr_Null:	equ 0
fr_Stand:	equ 1
fr_Blink:	equ 2
fr_Wait1:	equ 3
fr_Wait2:	equ 4
fr_Wait3:	equ 5
fr_Wait4:	equ 6
fr_Wait5:	equ 7
fr_Wait6:	equ 8
fr_Wait7:	equ 9
fr_Wait8:	equ $A
fr_Wait9:	equ $B
fr_LookUp1:	equ $C
fr_LookUp2:	equ $D
fr_Walk11:	equ $E
fr_Walk12:	equ $F
fr_Walk13:	equ $10
fr_Walk14:	equ $11
fr_Walk15:	equ $12
fr_Walk16:	equ $13
fr_Walk17:	equ $14
fr_Walk18:	equ $15
fr_Walk21:	equ $16
fr_Walk22:	equ $17
fr_Walk23:	equ $18
fr_Walk24:	equ $19
fr_Walk25:	equ $1A
fr_Walk26:	equ $1B
fr_Walk27:	equ $1C
fr_Walk28:	equ $1D
fr_Walk31:	equ $1E
fr_Walk32:	equ $1F
fr_Walk33:	equ $20
fr_Walk34:	equ $21
fr_Walk35:	equ $22
fr_Walk36:	equ $23
fr_Walk37:	equ $24
fr_Walk38:	equ $25
fr_Walk41:	equ $26
fr_Walk42:	equ $27
fr_Walk43:	equ $28
fr_Walk44:	equ $29
fr_Walk45:	equ $2A
fr_Walk46:	equ $2B
fr_Walk47:	equ $2C
fr_Walk48:	equ $2D
fr_Run11:	equ $2E
fr_Run12:	equ $2F
fr_Run13:	equ $30
fr_Run14:	equ $31
fr_Run15:	equ $32
fr_Run16:	equ $33
fr_Run17:	equ $34
fr_Run18:	equ $35
fr_Run21:	equ $36
fr_Run22:	equ $37
fr_Run23:	equ $38
fr_Run24:	equ $39
fr_Run25:	equ $3A
fr_Run26:	equ $3B
fr_Run27:	equ $3C
fr_Run28:	equ $3D
fr_Run31:	equ $3E
fr_Run32:	equ $3F
fr_Run33:	equ $40
fr_Run34:	equ $41
fr_Run35:	equ $42
fr_Run36:	equ $43
fr_Run37:	equ $44
fr_Run38:	equ $45
fr_Run41:	equ $46
fr_Run42:	equ $47
fr_Run43:	equ $48
fr_Run44:	equ $49
fr_Run45:	equ $4A
fr_Run46:	equ $4B
fr_Run47:	equ $4C
fr_Run48:	equ $4D
fr_peelout11:	equ $4E
fr_peelout12:	equ $4F
fr_peelout13:	equ $50
fr_peelout14:	equ $51
fr_peelout21:	equ $52
fr_peelout22:	equ $53
fr_peelout23:	equ $54
fr_peelout24:	equ $55
fr_peelout31:	equ $56
fr_peelout32:	equ $57
fr_peelout33:	equ $58
fr_peelout34:	equ $59
fr_peelout41:	equ $5A
fr_peelout42:	equ $5B
fr_peelout43:	equ $5C
fr_peelout44:	equ $5D
fr_Roll1:	equ $5E
fr_Roll2:	equ $60
fr_Roll3:	equ $62
fr_Roll4:	equ $64
fr_Roll5:	equ $66
fr_Roll6:	equ $5F
fr_Roll7:	equ $61
fr_Roll8:	equ $63
fr_Roll9:	equ $65
fr_Warp1:	equ $67
fr_Warp2:	equ $68
fr_Warp3:	equ $69
fr_Warp4:	equ $6A
fr_Stop1:	equ $6B
fr_Stop2:	equ $6C
fr_Stop3:	equ $6D
fr_Stop4:	equ $6E
fr_Leap3:	equ $6F
fr_Duck2:	equ $70
fr_Duck:	equ $71
fr_Balance1:	equ $72
fr_Balance2:	equ $73
fr_Balance3:	equ $74
fr_Balance4:	equ $75
fr_GetAir2:		equ $76
fr_VHang1:		equ $77
fr_VHang2:		equ $78
fr_Blank:		equ $79
fr_Blank2:		equ $7A

fr_Float1:	equ $7C
fr_Float2:	equ $7E
fr_Float3:	equ $81
fr_Float4:	equ $82
fr_Float5:	equ $80
fr_Float6:	equ $7B
fr_float7:	equ $7D
fr_float8:	equ $7F
fr_Spring:	equ $83
fr_Spring2:	equ $84
fr_Hang1:	equ $85
fr_Hang2:	equ $86
fr_Leap1:	equ $87
fr_Leap2:	equ $88
fr_Push1:	equ $89
fr_Push2:	equ $8A
fr_Push3:	equ $8B
fr_Push4:	equ $8C
fr_Push5:	equ $8D
fr_Push6:	equ $8E
fr_Push7:	equ $8F
fr_Push8:	equ $90
fr_Surf:	equ $91
fr_Burnt:	equ $92
fr_Drown:	equ $93
fr_Death:	equ $94
fr_GetAir:	equ $95
fr_Injury:	equ $96
fr_WaterSlide:	equ $97
fr_skele1:	equ $98
fr_skele2:	equ $99
fr_hurtblue:	equ $9A
fr_Spindash1	equ $9B
fr_Spindash2	equ $9C
fr_Spindash3	equ $9D
fr_Spindash4	equ $9E
fr_Spindash5	equ $9F
fr_Spindash6	equ $A0
fr_Transform1	equ	$A1
fr_Transform2	equ	$A2
fr_Transform3	equ	$A3
fr_Transform4	equ	$A4
fr_Transform5	equ	$A5
fr_Transform6	equ	$A6
fr_Transform7	equ	$A7
fr_Transform8	equ	$A8
fr_Transform9	equ	$A9

; SRAM Map
	rsset	0
InitSting:          rs.w 4
SavedColor:         rs.w 1
SavedCamera:        rs.w 1
SavedZone:          rs.w 1
SavedEmeralds:      rs.w 1
SavedEmeraldList:   rs.w 1
SavedLives:         rs.w 1