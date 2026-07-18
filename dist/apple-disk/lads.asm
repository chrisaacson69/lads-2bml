; disassembled from lads_apple.bin by dis2src.py -- reassembles byte-exact
.setcpu "6502"

; ---- equates: zero-page variables & ROM routines ----
CURPOS       = $24
FARM         = $2A
FMOP         = $2C
BMEMTOP      = $4C
VARTAB       = $69
HIGHDS       = $94
PRGEND       = $AF
CHRGET       = $B1
TXTPTR       = $B8
MEMTOP       = $EB
PARRAY       = $ED
FNAMELEN     = $F9
TEMP         = $FB
SA           = $FD
BABUF        = $0200
SCREEN       = $0400
FKEX         = $67F6
CSWD         = $AA57
SCRNOP       = $BC9A
HEXBUF       = $BEDE
PRNTR        = $C090
PRNTRDN      = $C1C1
KEYWDS       = $D0D0
LININS       = $D46A
LINGET       = $DA0C
OUTNUM       = $ED24
LOUT         = $FDF0

.org $79FD

    jmp STLINK
START:
    lda #$00
    ldy #$32
STRTLP:
    sta OP,Y
    dey
    bne STRTLP
    lda #$00
    sta MEMTOP
    sta BMEMTOP
    sta ARRAYTOP
    lda #$7A
    sta $EC
    sta $4D
    sta L8FE5
    lda #$01
    sta HXFLAG
STMO:
    lda SCREEN,Y
    cmp #$A0
    beq STM1
STM3:
    sta FILEN,Y
    iny
    jmp STMO
STM1:
    sta $BEF3,Y
    iny
    lda SCREEN,Y
    cmp #$A0
    bne STMO
    dey
    sty FNAMELEN
    jsr OPEN1
STORE:
    jsr GETSA
    lda #$00
    sta ENDFLAG
    jsr INDISK
    lda PASS
    bne STARTLINE
    jsr PRNTCR
    lda #$E6
    jsr L81D6
    lda #$4C
    jsr L81D6
    lda #$41
    jsr L81D6
    lda #$44
    jsr L81D6
    lda #$53
    jsr L81D6
    jsr PRNTCR
CKHEX:
    lda HEXFLAG
    bne STAR1
    lda #$F1
    sta TEMP
    lda #$8D
    sta $FC
    jsr VALDEC
STAR1:
    lda RESULT
    sta SA
    lda TA,X
    lda ARGSIZE
    sta $FE
    sta L8FD1
STARTLINE:
    jsr L822F
    lda ENDFLAG
    beq EVIND
    jmp FINI
EVIND:
    jsr INDISK
    lda #$00
    sta EXPRESSF
    lda BUFLAG,X
    ldy PASS
    bne MOREEV
    jmp MOE4
MOREEV:
    sty LOCFLAG
    lda SFLAG
    beq MX
    jsr PRNTLINE
    jsr PRNTSPACE
    jsr PRNTSA
    jsr PRNTSPACE
MX:
    lda PLUSFLAG
    beq MOE4
    jsr MATH
MOE4:
    jmp FINDMN
EVAR:
    lda TP
    beq TPIJMP
    cmp #$03
    bne EVGO
    lda #$01
    sta TP
    lda L8DF4
    bne EVGO
    lda #$08
    clc
    adc OP
    lda OP,X
TPIJMP:
    jmp TP1
EQLABEL:
    lda PASS
    beq EQLAB1
    ldy #$FF
EVX1:
    iny
    lda LABEL,Y
    beq GONOAR
    sta $BEF3,Y
    cmp #$20
    bne EVX1
    iny
    lda LABEL,Y
    cmp #$3D
    bne NOTEQ
    jmp INLINE
NOTEQ:
    ldx #$00
    stx LOCFLAG
    txa
    sta FILEN,Y
EVX5:
    lda LABEL,Y
    beq EVX4
    sta LABEL,X
    inx
    iny
    jmp EVX5
EVX4:
    sta LABEL,X
    jmp MOE4
GONOAR:
    jsr NOAR
EQLAB1:
    jsr EQUATE
    jmp MOE4
EVEXLAB:
    lda BUFFER
    cmp #$40
    bcs EVE1
    lda L8E39
    inc BUFLAG
EVE1:
    eor #$80
    sta WORK
    jsr ARRAY
    jmp L340
EVGO:
    ldy #$00
    sty EXPRESSF
    lda L8DF5,Y
    cmp #$41
    bcc L7B56
    inc EXPRESSF
L7B56:
    sta BUFFER,Y
    .byte $CB
    lda L8DF5,Y
    beq EVM03
    sta BUFFER,Y
    cmp #$41
    bcc EVM02
    inc EXPRESSF
EVM02:
    iny
    lda L8DF5,Y
    beq EVM03
    sta BUFFER,Y
    jmp EVM02
EVM03:
    dey
    sty ARGSIZE
    lda HEXFLAG
    bne L340
    lda EXPRESSF
    bne EVEXLAB
    lda #$38
    sta TEMP
    lda #$8E
    sta $FC
    ldy #$00
    lda $BE38
    cmp #$30
    bcs MCAL
    clc
    inc TEMP
    bcc MCAL
    inc $FC
MCAL:
    lda (TEMP),Y
    beq MCAL1
    cmp #$29
    beq MCAL1
    cmp #$2C
    beq MCAL1
    cmp #$20
    beq MCAL1
    iny
    jmp MCAL
MCAL1:
    pha
    tya
    pha
    lda #$00
    sta (TEMP),Y
    jsr VALDEC
    pla
    .byte $AB
    pla
    sta (TEMP),Y
L340:
    lda BUFFER
    cmp #$23
    beq DIMMED
    cmp #$28
    beq INDIR
    lda TP
    cmp #$08
    beq REL
    cmp #$03
    bne EVM05
    lda #$08
    clc
    adc OP
    sta OP
    jmp TP1
INDIR:
    ldy ARGSIZE
    lda $BE38,Y
    cmp #$29
    beq MINDIR
    lda TP
    cmp #$01
    bne MINDIR
    lda #$10
    clc
    adc OP
    lda OP,X
MINDIR:
    lda TP
    cmp #$06
    beq JJUMP
    jmp TWOS
DIMMED:
    jmp IMMED
REL:
    lda PASS
    bne MREL
    jmp TWOS
MREL:
    sec
    lda $0FD7
    sbc SA
    pha
    lda $0FD8
    sbc $FE
    bcs FOR
    cmp #$FF
    beq MPXS
    pla
    jmp DOBERR
MPXS:
    pla
    bpl BERR
    jmp RELM
FOR:
    beq MPXS1
    pla
    jmp DOBERR
MPXS1:
    pla
    bpl RELM
BERR:
    jmp DOBERR
RELM:
    sec
    sbc #$02
    lda RESULT,X
    lda #$00
    sta L8FD8
    jmp TWOS
EVM05:
    ldy $0FDB
    dey
    lda BUFFER,Y
    cmp #$2C
    bne JJUMP
    iny
    jmp XYTYPE
JJUMP:
    lda OP
    cmp #$4C
    bne MEV
    jmp JUMP
MEV:
    lda L8FD8
    bne PREPTHREES
    lda TP
    cmp #$06
    bcs TWOS
    cmp #$02
    beq TWOS
    lda #$04
    clc
    adc OP
    lda $0FCE,X
TWOS:
    jsr FORMAT
    jsr PRINT2
    jmp INLINE
JUMP:
    ldy ARGSIZE
    lda BUFFER,Y
    cmp #$29
    bne JUMO
    lda #$6C
    lda OP,X
JUMO:
    jmp THREES
IMMED:
    lda L8E39
    cmp #$22
    bne IMMEDX
    lda $BE3A
    sta RESULT
IMMEDX:
    lda TP
    cmp #$01
    bne TWOS
    lda #$08
    clc
    adc OP
    lda OP,X
    jmp TWOS
TP1:
    jsr FORMAT
    jmp INLINE
PREPTHREES:
    lda TP
    cmp #$02
    beq PTT
    cmp #$07
    bne PT1
PTT:
    lda OP
    clc
    adc #$08
    sta OP
    jmp THREES
PT1:
    cmp #$06
    bcs THREES
    lda OP
    clc
    adc #$0C
    sta OP
THREES:
    jsr FORMAT
    jsr PRINT3
INLINE:
    lda PASS
    bne NLOX1
    jmp JST
NLOX1:
    lda SFLAG
    bne NLOX
    jmp JST
NLOX:
    lda $0FFB
    bne PRMMX1
    lda PRINTFLAG
    beq PRMM
    lda #$14
    sec
    sbc CURPOS
    lda L8FEB,X
    jsr L821C
    ldx #$04
    jsr L81A6
    ldy VARA
    bpl PRXM1
    ldy #$02
    jmp PRMLOP
PRXM1:
    lda #$20
PRMLOP:
    jsr L81D6
    dey
    bne PRMLOP
    jsr L821C
    ldx #$01
    jsr $61A2
PRMM:
    lda #$14
    sta CURPOS
    lda #$F3
    sta TEMP
    lda #$8E
    sta $FC
    jsr PRNTMESS
PRMMX1:
    lda #$1E
    sec
    sbc CURPOS
    sta $0FE9
    lda #$1E
    sta CURPOS
    lda PRINTFLAG
    beq PRMMFIN
    jsr L821C
    ldx #$04
    jsr L81A6
    ldy VARX
    beq PXMX
    bmi PXMX
    lda #$20
PRMLOPX:
    jsr L81D6
    dey
    bne PRMLOPX
PXMX:
    jsr L821C
    ldx #$01
    jsr L81A2
PRMMFIN:
    jsr PRNTINPUT
    lda BYTFLAG
    beq PRXM
    cmp #$01
    bne M05
    lda #$3C
    jmp PRMO
M05:
    lda #$3E
PRMO:
    jsr L81D6
    jsr PTP1
PRXM:
    lda BABFLAG
    beq RETTX
    jsr PRNTSPACE
    lda #$3B
    jsr L81D6
    lda #$00
    sta TEMP
    lda #$02
    sta $FC
    jsr PRNTMESS
RETTX:
    jsr PRNTCR
    lda ENDFLAG
    bne FINI
JST:
    jmp STARTLINE
FINI:
    lda PASS
    bne FIN
    inc PASS
    sec
    lda SA
    sbc TA
    sta L8FFD
    lda $FE
    sbc L8FD1
    lda L8FFE,X
    lda TA
    sta SA
    lda L8FD1
    sta $FE
    jsr L821C
    lda #$01
    jsr L8235
    jsr OPEN1
    jmp STORE
FIN:
    jsr L821C
    lda #$01
    jsr L8235
    lda #$02
    jsr L8235
    lda PRINTFLAG
    beq FINFIN
    jsr L821C
    ldx #$04
    jsr L81A6
    lda #$0D
    jsr L81D6
    jsr L821C
    lda #$04
    jsr L8235
FINFIN:
    jmp $03D0
XYTYPE:
    lda $BE38,Y
    cmp #$58
    beq L720
    dey
    dey
    lda BUFFER,Y
    cmp #$29
    bne ZEROY
    jmp INDIR
ZEROY:
    lda ARGSIZE
    bne L680
    lda TP
    cmp #$02
    beq L730
    cmp #$05
    beq L730
    cmp #$01
    beq ML760
L680:
    lda TP
    cmp #$01
    bne L690
    lda OP
    clc
    adc #$18
    sta OP
    jmp THREES
L690:
    lda TP
    cmp #$05
    beq M6
    lda #$31
    jsr P
    jmp L700
M6:
    lda OP
    clc
    adc #$1C
    sta OP
    jmp THREES
L700:
    jsr ERRING
    jsr PRNTLINE
    lda #$B4
    sta TEMP
    lda #$8F
    sta $FC
    jsr $B8F9
    jmp INLINE
L720:
    lda L8FD8
    bne L780
L730:
    lda TP
    cmp #$02
    bne L740
    lda #$10
    clc
    adc OP
    sta OP
    jmp TWOS
L740:
    cmp #$01
    beq L759
    cmp #$03
    beq L759
    cmp #$05
    beq L759
L750:
    lda #$32
    jsr P
    jmp L700
L759:
    lda #$14
    clc
    adc OP
    lda OP,X
ML760:
    jmp TWOS
L780:
    lda TP
    cmp #$02
    bne L790
    lda #$18
    clc
    adc OP
    sta OP
    jmp THREES
L790:
    cmp #$01
    beq L809
    cmp #$03
    beq L809
    cmp #$05
    beq L809
L800:
    lda #$33
    jsr P
    jmp L700
L809:
    lda #$1C
    clc
    adc OP
    lda OP,X
    jmp THREES
P:
    sta L8FEB
    sty VARY
    stx VARX
    lda #$BA
    jsr L81D6
    pla
    tax
    pla
    tay
    tya
    pha
    txa
    pha
    tya
    jsr OUTNUM
    lda VARA
    ldy VARY
    ldx VARX
    rts
CLEANLAB:
    ldy #$00
    tya
CLEMORE:
    sta LABEL,Y
    iny
    cpy #$FF
    bne CLEMORE
    rts
DOBERR:
    jsr PRNTCR
    jsr ERRING
    jsr PRNTLINE
    lda #$23
    sta TEMP
    lda #$8F
    sta $FC
    jsr PRNTMESS
    jsr PRNTCR
    jmp TWOS
EQUATE:
    ldy #$FF
EQ1:
    iny
    lda LABEL,Y
    beq NOAR
    cmp #$20
    bne EQ1
    iny
    iny
    sty LABSIZE
SUBMEM:
    sec
    lda MEMTOP
    sbc LABSIZE
    sta MEMTOP
    lda $EC
    sbc #$00
    sta $EC
    ldy #$00
    lda LABEL,Y
    eor #$80
    sta (MEMTOP),Y
EQ3:
    .byte $CB
    lda LABEL,Y
    cmp #$20
    beq EQ2
    sta (MEMTOP),Y
    jmp EQ3
EQ2:
    iny
    lda LABEL,Y
    cmp #$3D
    beq EQUAL
    dey
    lda SA
    sta (MEMTOP),Y
    iny
    lda $FE
    sta (MEMTOP),Y
    ldx LABSIZE
    dex
    ldy #$00
EQ5:
    lda LABEL,X
    beq L7F74
    sta LABEL,Y
    inx
    .byte $CB
    jmp EQ5
L7F74:
    sta LABEL,Y
    rts
NOAR:
    jsr ERRING
    lda #$5C
    sta TEMP
    lda #$8F
    sta $FC
    jsr PRNTMESS
    jmp EQRET
EQUAL:
    dey
    sty LABPTR
    lda HEXFLAG
    bne FINEQ
    iny
    iny
    iny
    sty L8FD6
    lda #$F1
    clc
    adc L8FD6
    sta TEMP
    lda #$8D
    adc #$00
    sta $FC
    jsr VALDEC
FINEQ:
    ldy LABPTR
    lda RESULT
    sta (MEMTOP),Y
    lda L8FD8
    iny
    sta (MEMTOP),Y
EQRET:
    pla
    pla
    jmp INLINE
ARRAY:
    lda ARRAYTOP
    sta PARRAY
    lda L8FE5
    sta $EE
    jsr DECPAR
    lda #$FF
    sta FOUNDFLAG
STARTLK:
    sec
    lda MEMTOP
    sbc PARRAY
    lda $EC
    sbc $EE
    bcs ADONE
    ldx #$00
    sec
    lda PARRAY
    sbc #$02
    sta PARRAY
    lda $EE
    sbc #$00
    sta $EE
    ldy #$00
LPAR:
    lda (PARRAY),Y
    bmi FOUNDONE
    lda PARRAY
    bne MDECX
    dec $EE
MDECX:
    dec PARRAY
    inx
    jmp LPAR
FOUNDONE:
    lda PARRAY
    lda L8FEB,X
    lda $EE
    sta L8FEC
    lda (PARRAY),Y
    cmp WORK
    beq LKMORE
    jmp STARTOVER
LKMORE:
    inx
    stx L8FD6
    ldx #$01
    lda BUFLAG
    beq LKM1
    iny
    jsr DECPAR
LKM1:
    iny
    lda $BE38,Y
    beq FOUNDIT
    cmp #$30
    bcc FOUNDIT
    inx
    cmp (PARRAY),Y
    beq LKM1
STARTOVER:
    lda L8FEB
    sta PARRAY
    lda L8FEC
    sta $EE
    jsr DECPAR
    jmp STARTLK
ADONE:
    lda FOUNDFLAG
    bmi AD1
    rts
AD1:
    lda PASS
    bne ADlX
    beq ADONE1
ADlX:
    jsr ERRING
    jsr PRNTLINE
    jsr PRNTSPACE
    lda #$4C
    sta TEMP
    lda #$8F
    sta $FC
    jsr PRNTMESS
    jsr PRNTCR
ADONE1:
    pla
    pla
    lda OP
    and #$1F
    cmp #$10
    beq AD02
    lda BYTFLAG
    bne AD02
    jmp THREES
AD02:
    jmp TWOS
FOUNDIT:
    cpx L8FD6
    beq FOUNDF
    jmp STARTOVER
FOUNDF:
    inc FOUNDFLAG
    beq FOFX
    jsr DUPLAB
FOFX:
    ldy L8FD6
    lda BUFLAG
    beq FOF
    iny
FOF:
    lda (PARRAY),Y
    sta RESULT
    iny
    lda (PARRAY),Y
    sta ARGSIZE
    lda BYTFLAG
    beq CMPMO
    cmp #$02
    bne AREND
    lda L8FD8
    lda RESULT,X
CMPMO:
    lda PLUSFLAG
    beq AREND
    clc
    lda ADDNUM
    adc RESULT
    sta RESULT
    lda L8FF1
    adc L8FD8
    sta ARGSIZE
AREND:
    lda PASS
    beq ARENX
    rts
ARENX:
    jmp STARTOVER
DECPAR:
    lda PARRAY
    bne MDEC
    dec $EE
MDEC:
    dec PARRAY
    rts
DUPLAB:
    jsr ERRING
    lda #$96
    sta TEMP
    lda #$8F
    sta $FC
    jsr PRNTMESS
    jsr PRNTCR
    rts
OPEN1:
    jsr L821C
    lda #$01
    jsr L8235
    lda #$01
    sta FMOP
    lda #$90
    sta $2D
    jsr L815F
    inc L8FFF
    rts
L80FC:
    lda #$13
    sta FMOP
    lda #$90
    sta $2D
    jsr L815F
    inc L9000
    rts
OPEN4:
    rts
L810C:
    lda #$25
    sta FMOP
    lda #$90
    sta $2D
    jsr L818A
    jsr $03DC
    sta $2B
    sty FARM
    ldy #$08
    lda (FARM),Y
    rts
L8123:
    sta L903F
    lda #$37
    sta FMOP
    lda #$90
    sta $2D
    jsr L818A
    rts
L8132:
    lda L8FFF
    beq L815E
    lda #$49
    sta FMOP
    lda #$90
    sta $2D
    jsr L818A
    lda #$00
    sta L8FFF
    rts
L8148:
    lda L9000
    beq L815E
    lda #$5B
    sta FMOP
    lda #$90
    sta $2D
    jsr L818A
    lda #$00
    sta L9000
    rts
L815E:
    rts
L815F:
    ldy #$08
    lda (FMOP),Y
    sta FARM
    iny
    lda (FMOP),Y
    sta $2B
    lda #$F3
    sta TEMP
    lda #$8E
    sta $FC
    ldy #$00
    lda #$A0
L8176:
    sta (FARM),Y
    iny
    cpy #$1F
    bne L8176
    ldy #$00
L817F:
    lda (TEMP),Y
    ora #$60
    sta (FARM),Y
    iny
    cpy FNAMELEN
    bne L817F
L818A:
    jsr $03DC
    sta $2B
    sty FARM
    ldy #$00
L8193:
    lda (FMOP),Y
    sta (FARM),Y
    iny
    cpy #$12
    bne L8193
    ldx #$00
    jsr $03D6
    rts
L81A2:
    stx L906D
    rts
L81A6:
    txa
    sta L906E
    cpx #$04
    bne L81B8
    lda #$EC
    sta $AA53
    lda #$81
    adc $AA54
L81B8:
    rts
L81B9:
    sty L9070
    stx VARX
    lda L906D
    cmp #$01
    bne L81D2
    jsr L810C
    php
    ldy L9070
    ldx VARX
    plp
    rts
L81D2:
    ldy L9070
    rts
L81D6:
    sty L9070
    sta L906F
    lda L906E
    cmp #$02
    bne L8201
    lda L906F
    jsr L8123
    jmp L81D2
L81EC:
    sta L906F
    cmp #$8D
    bne L81F5
    lda #$0A
L81F5:
    sta PRNTR
L81F8:
    lda PRNTRDN
    bmi L81F8
    lda L906F
    rts
L8201:
    lda L906E
    cmp #$04
    bne L8211
    lda L906F
    jsr L81EC
    jmp L81D2
L8211:
    lda L906F
    ora #$80
    jsr LOUT
    jmp L81D2
L821C:
    lda #$00
    sta L906E
    sta L906D
    lda #$F0
    sta $AA53
    lda #$FD
    sta $AA54
    rts
L822F:
    lda $C000
    cmp #$83
    rts
L8235:
    cmp #$01
    bne L823C
    jmp L8132
L823C:
    cmp #$02
    bne L8243
    jmp L8148
L8243:
    jmp L815E
    sta L906F
    lda #$00
    cmp $BB
    bne L826A
    lda #$02
    cmp $B9
    bne L826A
    ldy #$00
L8257:
    lda ($BB),Y
    cmp #$20
    bne L8262
    inc TXTPTR
    jmp L8257
L8262:
    cmp #$2F
    bcc L826A
    cmp #$3A
    bcc L82BD
L826A:
    lda BABUF
    cmp #$41
    bne L82A8
    lda $0201
    cmp #$53
    bne L82A8
    lda $0202
    cmp #$4D
    bne L82A8
    lda $0203
    cmp #$20
    bne L82A8
    ldy #$00
L8288:
    lda $0204,Y
    cmp #$00
    beq L8298
    ora #$80
    sta SCREEN,Y
    iny
    jmp L8288
L8298:
    lda #$A0
    sta SCREEN,Y
    sta $0401,Y
    sta $0402,Y
    pla
    pla
    jmp START
L82A8:
    lda L906F
    cmp #$3A
    bcs L82BC
    cmp #$20
    bne L82B6
    jmp a:CHRGET
L82B6:
    sec
    sbc #$30
    sec
    sbc #$D0
L82BC:
    rts
L82BD:
    ldx PRGEND
    stx VARTAB
    ldx $B0
    stx $6A
    clc
    jsr LINGET
    jsr L82D1
    pla
    pla
    jmp LININS
L82D1:
    ldy #$00
    sty HIGHDS
    lda #$02
    sta $95
L82D9:
    lda ($BB),Y
    sta (HIGHDS),Y
    iny
    cmp #$00
    bne L82D9
    dey
L82E3:
    dey
    lda (HIGHDS),Y
    cmp #$20
    beq L82E3
    iny
    lda #$00
    sta (HIGHDS),Y
    iny
    iny
    .byte $CB
    iny
    iny
    rts
STLINK:
    lda #$46
    sta $BB
    lda #$82
    sta $BC
    lda #$4C
    sta $BA
    lda #$FC
    sta $73
    lda #$79
    sta $74
    rts
FINDMN:
    ldy #$00
    ldx #$FF
LOOP:
    inx
    lda MNEMONICS,Y
    cmp LABEL
    beq MORE
    iny
    iny
    iny
    cpx #$39
    bne LOOP
NOMATCH:
    jmp EQLABEL
MORE:
    iny
    lda MNEMONICS,Y
    cmp L8DF2
    beq MORE1
    .byte $CB
    .byte $CB
    bne LOOP
    beq NOMATCH
MORE1:
    iny
    lda MNEMONICS,Y
    cmp L8DF3
    beq FOUND
    iny
    bne LOOP
    beq NOMATCH
FOUND:
    lda L8DF4
    cmp #$20
    beq FO1
    cmp #$00
    bne NOMATCH
FO1:
    lda TYPES,X
    sta TP
    ldy OPS,X
    ldy OP,X
    jmp EVAR
GETSA:
    ldx #$01
    jsr L81A2
    ldx #$06
L835F:
    stx VARX
    jsr L81B9
    ldx VARX
    dex
    bne L835F
    jsr L81B9
    cmp #$2A
    beq MSA
    lda #$12
    sta TEMP
    lda #$8F
    sta $FC
    jsr PRNTMESS
    jmp FIN
MSA:
    rts
VALDEC:
    ldy #$00
VGETZERO:
    lda (TEMP),Y
    beq VZERO
    iny
    jmp VGETZERO
VZERO:
    sty VREND
    dey
    lda #$00
    sta RESULT
    lda L8FD8,X
    ldx #$01
    ldx VARX,Y
VALLOOP:
    lda (TEMP),Y
    and #$0F
    sta RADD
    sta TSTORE
    lda #$00
    sta L8F0E
    sta L8F11
VLOOP:
    dex
    beq VGOON
    jsr TEN
    lda RADD
    sta TSTORE
    lda L8F0E
    lda L8F11,X
    jmp VLOOP
VGOON:
    inc VARX
    ldx VARX
    jsr VALADD
    dey
    dec VREND
    bne VALLOOP
    rts
TEN:
    clc
    asl RADD
    rol L8F0E
    asl RADD
    rol L8F0E
    clc
    lda TSTORE
    adc RADD
    sta RADD
    lda L8F11
    adc L8F0E
    sta L8F0E
    asl RADD
    rol L8F0E
    rts
VALADD:
    clc
    lda RADD
    adc RESULT
    lda RESULT,X
    lda L8F0E
    adc L8FD8
    sta L8FD8
    rts
INDISK:
    jsr CLEANLAB
    ldy #$00
    sty HEXFLAG
    ldy BABFLAG,X
    ldy BYTFLAG,X
    sty PLUSFLAG
    lda COLFLAG
    bne NOBLANKS
    jsr L81B9
    sta LINEN
    jsr L81B9
    sta L8FD3
NOBLANKS:
    jsr L81B9
    cmp #$20
    bne L843F
    jsr ENDPRO
    pla
    pla
    jmp STARTLINE
L843F:
    cmp #$20
    jmp MOI1
STINDISK:
    jsr L81B9
MOINDI:
    bne MOI1
    jmp ENDPRO
MOI1:
    cmp #$3A
    bne XMO1
    jmp COLON
XMO1:
    cmp #$3B
    bne COMOA
    sty L8FEB
    lda PRINTFLAG
    beq PULLRX
    sta BABFLAG
    lda VARA
    beq PUX
    jsr PULLREST
    jmp MPULL
PUX:
    jsr L81B9
    beq PUX1
    cmp #$7F
    bcc PUX2
    jsr KEYWORD
PUX2:
    sta LABEL,Y
    iny
    jmp PUX
PUX1:
    jsr PRNTLINE
    jsr PRNTSPACE
    jsr PRNTINPUT
    jsr PRNTCR
    lda #$00
    sta VARA
    jmp MPULL
PULLREST:
    sta BABFLAG
    sta VARA
    ldy #$00
PAX1:
    jsr L81B9
    bne PAX
    sta BABUF,Y
    ldy VARA
    rts
PAX:
    bpl PAXA
    jsr KEYWAD
PAXA:
    sta BABUF,Y
    .byte $CB
    jmp PAX1
PULLRX:
    jsr L81B9
    beq MPULL
    jmp PULLRX
MPULL:
    jsr ENDPRO
    lda VARA
    bne MPULL1
    pla
    pla
    jmp STARTLINE
MPULL1:
    rts
COMOA:
    cmp #$3E
    beq HI
    cmp #$3C
    beq LO
    cmp #$2B
    bne COMO
    inc PLUSFLAG
COMO:
    cmp #$2A
    bne COM01
    jmp STAR
COM01:
    cmp #$2E
    beq L84FA
    cmp #$24
    beq L84FD
    cmp #$7F
    bcc ADDLAB
    jsr KEYWORD
ADDLAB:
    sta LABEL,Y
    .byte $CB
    jmp STINDISK
COLON:
    sta COLFLAG
    rts
L84FA:
    jmp PSEUDOJ
L84FD:
    sta LABEL,Y
    .byte $CB
    jmp HEX
KEYWORD:
    sec
    sbc #$7F
    sta KEYNUM
    ldx #$FF
SKEY:
    dec KEYNUM
    beq FKEY
KSX:
    inx
    lda KEYWDS,X
    bpl KSX
    bmi SKEY
FKEY:
    .byte $EB
    lda KEYWDS,X
    bmi KSET
    sta LABEL,Y
    iny
    jmp FKEY
KSET:
    and #$7F
    rts
HI:
    lda #$02
    sta ADDNUM
    jmp STINDISK
LO:
    lda #$01
    sta BYTFLAG
    jmp STINDISK
STAR:
    lda BYTFLAG
    beq L855E
    lda #$2A
    sta LABEL,Y
    iny
    inc HEXFLAG
    lda BYTFLAG
    cmp #$01
    beq L8556
    lda $FE
    sta RESULT
    jmp STINDISK
L8556:
    lda SA
    sta RESULT
    jmp STINDISK
L855E:
    jsr STINDISK
    lda PASS
    beq STARN
    lda #$2A
    jsr L81D6
    jsr PRNTINPUT
    jsr PRNTCR
STARN:
    lda HEXFLAG
    bne STARR
    ldy #$00
STAF:
    lda LABEL,Y
    cmp #$20
    beq STAF1
    iny
    jmp STAF
STAF1:
    iny
    sty TEMP
    lda #$F1
    clc
    adc TEMP
    sta TEMP
    lda #$8D
    adc #$00
    sta $FC
    jsr VALDEC
STARR:
    lda PASS
    beq STARRX
    lda DISKFLAG
    beq STARRX
    jsr FILLDISK
STARRX:
    lda RESULT
    sta SA
    lda L8FD8
    sta $FE
    pla
    pla
    jmp STARTLINE
ENDPRO:
    sta LABEL,Y
    .byte $CB
    cpy #$FF
    bne ENDPRO
    sta LABEL,Y
    jsr L81B9
    jsr L81B9
    beq INEND
    lda #$00
    sta COLFLAG
    rts
INEND:
    lda #$01
    sta ENDFLAG
    rts
HEX:
    ldx #$00
H1:
    jsr L81B9
    beq DECI
    cmp #$3A
    beq DECI
    cmp #$20
    beq H1
    cmp #$3B
    beq DECI
    cmp #$2C
    beq DECIT
    cmp #$29
    beq DECIT
    sta HEXBUF,X
    .byte $EB
    sta LABEL,Y
    iny
    jmp H1
DECIT:
    stx HEXLEN
    sta LABEL,Y
    iny
    jsr STARTHEX
    jmp STINDISK
DECI:
    sta L8FEB
    lda #$00
    ldx HEXLEN,Y
    sta LABEL,Y
    jsr STARTHEX
    lda VARA
    jmp MOINDI
STARTHEX:
    lda #$00
    sta $3FD7
    sta L8FD8
    tax
HXLOOP:
    asl RESULT
    rol L8FD8
    asl RESULT
    rol ARGSIZE
    asl RESULT
    rol L8FD8
    asl RESULT
    rol L8FD8
    lda HEXBUF,X
    cmp #$41
    bcc HXMORE
    sbc #$07
HXMORE:
    and #$0F
    ora RESULT
    sta RESULT
    inx
    cpx HEXLEN
    bne HXLOOP
    inc HEXFLAG
    lda #$01
    rts
PSEUDOJ:
    cpy #$00
    beq PSE2
    ldx PASS
    bne PSE2
    pha
    tya
    pha
    jsr EQUATE
    pla
    tay
    pla
PSE2:
    sta LABEL,Y
    iny
    jsr L81B9
    sta LABEL,Y
    iny
    cmp #$42
    bne PSEUD1
    lda #$00
    sta BNUMFLAG
    lda PASS
    beq CLB
    sty VARY
    lda SFLAG
    beq CLB
    jsr PRNTLINE
    jsr $690A
    jsr PRNTSA
    jsr PRNTSPACE
    ldy $0FEA
CLB:
    jsr $61B9
    sta LABEL,Y
    iny
    cmp #$20
    bne CLB
    jsr L81B9
    sta LABEL,Y
    iny
    cmp #$22
    bne L86F3
BY1:
    jsr L81B9
    bne BY2
    jmp BENDPRO
BY2:
    cmp #$3A
    bne BY2X
    jmp BEN1
BY2X:
    cmp #$3B
    bne BY3
    jsr PULLREST
    ldx PRINTFLAG
    ldx BABFLAG,Y
    jmp BENDPRO
BY3:
    cmp #$22
    bne BY3X
    jmp BY1
BY3X:
    ldx PASS
    bne PSLOOP
    jsr INCSA
    jmp BY1
PSEUD1:
    jmp PSEUDO
PSLOOP:
    sta $BDF1,Y
    tax
    ldy VARY,X
    jsr POKEIT
    ldy VARY
    iny
    jmp BY1
L86F3:
    ldx #$00
    ldx BFLAG,Y
    sta NUBUF,X
    inx
WERK1:
    lda BFLAG
    bne BBEND
WK0:
    jsr L81B9
    beq BSFLAG
    cmp #$3A
    beq BSFLAG
    cmp #$3B
    bne WK1
    jsr PULLREST
    ldx PRINTFLAG
    ldx BABFLAG,Y
    jmp BSFLAG
WK1:
    sta BUFM
    lda $0FE7
    bne WERK5
    lda $BE80
    cmp #$20
    bne WERK1
    jsr INCSA
    jmp WERK1
WERK5:
    lda BUFM
    sta LABEL,Y
    iny
    cmp #$20
    beq WERK2
    cmp #$00
    beq WERK2
    cmp #$3A
    beq WERK2
    sta NUBUF,X
    inx
    jmp WERK1
BSFLAG:
    inc BFLAG
    sta $BE81
    jmp WK1
WERK2:
    lda #$06
    sta TEMP
    lda #$8F
    sta $FC
    sty $0FEA
    jsr VALDEC
    ldx RESULT
    jsr POKEIT
    ldy VARY
    lda #$00
    ldx #$05
CLEX:
    sta NUBUF,X
    dex
    bne CLEX
    jmp WERK1
BBEND:
    lda $0FE7
    bne BBEND1
    jsr INCSA
BBEND1:
    lda L8E81
    cmp #$3A
    beq BEN1
BENDPRO:
    jsr ENDPRO
BEN1:
    sta COLFLAG
    inc LOCFLAG
    pla
    pla
    lda PASS
    beq NOPR
    lda SFLAG
    beq NOPR
    jmp PRMMFIN
NOPR:
    jmp STARTLINE
FILLDISK:
    lda PASS
    cmp #$02
    bne FILLX
    rts
FILLX:
    jsr L821C
    ldx #$02
    jsr L81A6
    sec
    lda RESULT
    sbc SA
    lda WORK,X
    lda L8FD8
    sbc $FE
    sta L8FD6
PUTSPCR:
    lda #$00
    jsr L81D6
    lda WORK
    bne DECWORKX
    dec L8FD6
DECWORKX:
    dec WORK
    bne PUTSPCR
    lda L8FD6
    bne PUTSPCR
RESFILL:
    jsr L821C
    ldx #$01
    jsr L81A2
    rts
KEYWAD:
    sec
    sbc #$7F
    sta KEYNUM
    ldx #$FF
SKEX:
    dec KEYNUM
    beq L87F6
KSXX:
    inx
    lda KEYWDS,X
    bpl KSXX
    bmi SKEX
L87F6:
    .byte $EB
    lda KEYWDS,X
    bmi KSEX
    sta BABUF,Y
    iny
    jmp FKEX
KSEX:
    and #$7F
    rts
MATH:
    ldy #$00
    ldx #$00
MATH1:
    lda LABEL,Y
    cmp #$2B
    beq MATH2
    iny
    jmp MATH1
MATH2:
    iny
    lda LABEL,Y
    jsr RANGECK
    .byte $80
    .byte $12
    sta L8EDE,X
    .byte $EB
    jmp MATH2
RANGECK:
    cmp #$3A
    bcs MATH3
    sec
    sbc #$30
    sec
    sbc #$D0
MATH3:
    rts
VALIT:
    lda #$00
    sta HEXBUF,X
    lda #$DE
    sta TEMP
    lda #$8E
    sta $FC
    jsr VALDEC
    lda RESULT
    sta ADDNUM
    lda L8FD8
    sta L8FF1
    rts
FORMAT:
    lda PASS
    bne PRM
    jsr INCSA
    rts
PRM:
    lda SFLAG
    beq PRMX
    jsr L821C
    ldx #$01
    jsr L81A2
    ldx OP
    jsr PRNTNUM
    jsr PRNTSPACE
PRMX:
    ldx OP
    jsr POKEIT
    rts
PRINT2:
    lda PASS
    bne P2M
    jsr INCSA
    rts
P2M:
    lda SFLAG
    beq P2MX
    ldx RESULT
    jsr PRNTNUM
P2MX:
    ldx RESULT
    jmp POKEIT
    lda PASS
    bne P3M
    jsr INCSA
    jsr INCSA
    rts
P3M:
    lda SFLAG
    beq P3MX
    ldx RESULT
    jsr PRNTNUM
P3MX:
    ldx RESULT
    jsr POKEIT
    lda SFLAG
    beq PRINT3
    lda HXFLAG
    beq P3MX2
    jsr PRNTSPACE
P3MX2:
    ldx L8FD8
    jsr PRNTNUM
PRINT3:
    ldx L8FD8
    jmp POKEIT
POKEIT:
    stx L8FD6
    lda POKEFLAG
    beq DISP
    ldy #$00
    txa
    sta (SA),Y
DISP:
    lda DISKFLAG
    beq INCSA
    jsr L821C
    ldx #$02
    jsr L81A6
    lda L8FD6
    jsr L81D6
    jsr L821C
    ldx #$01
    jsr L81A2
INCSA:
    clc
    lda #$01
    adc SA
    sta SA
    lda #$00
    adc $FE
    sta $FE
    rts
PRNTMESS:
    ldy #$00
MESSLOOP:
    lda (TEMP),Y
    beq MESSDONE
    jsr L81D6
    jsr PTP
    iny
    jmp MESSLOOP
MESSDONE:
    rts
PRNTSPACE:
    lda #$20
    jsr L81D6
    jsr PTP
    rts
PRNTNUM:
    stx VARX
    lda HXFLAG
    beq PRNTNUMD
    tsx
    jsr HEXPRINT
    jsr PTPNU
    ldx VARX
    rts
PRNTNUMD:
    lda #$00
    jsr OUTNUM
    jsr PTPNU
    ldx VARX
    rts
PRNTSA:
    lda HXFLAG
    beq PRNTSAD
    lda $FE
    jsr HEXPRINT
    lda SA
    jsr HEXPRINT
    jsr PTPSA
    rts
PRNTSAD:
    ldx SA
    lda $FE
    jsr OUTNUM
    jsr PTPSA
    rts
PRNTCR:
    lda #$0D
    jsr L81D6
    jsr PTP
    rts
PRNTLINE:
    ldx LINEN
    lda L8FD3
    jsr OUTNUM
    jsr PTPLI
    rts
PRNTINPUT:
    lda #$F1
    sta TEMP
    lda #$8D
    sta $FC
    jsr PRNTMESS
    rts
ERRING:
    lda #$07
    jsr L81D6
    lda #$12
    jsr L81D6
    jsr PRNTINPUT
    lda #$0D
    jsr L81D6
    rts
PTP:
    ldx PASS
    bne PTP1
    rts
PTP1:
    ldx PRINTFLAG
    bne MPTP
    rts
MPTP:
    sta L8FEB
    jsr L821C
    ldx #$04
    jsr L81A6
    lda VARA
    jsr L81D6
    jsr L821C
    ldx #$01
    jsr L81A2
RETT:
    lda VARA
    rts
PTPNU:
    ldx PASS
    bne PTPN1
    rts
PTPN1:
    ldx PRINTFLAG
    bne MPTPN
    rts
MPTPN:
    jsr $B21C
    ldx #$04
    jsr L81A6
    lda HXFLAG
    beq MPTPND
    lda VARX
    jsr HEXPRINT
    jmp FINPTP
MPTPND:
    lda #$00
    ldx VARX
    jsr OUTNUM
FINPTP:
    jsr L821C
    ldx #$01
    jsr L81A2
    rts
PTPSA:
    ldx PASS
    bne PTPS1
    rts
PTPS1:
    ldx PRINTFLAG
    bne MPTPSA
    rts
MPTPSA:
    jsr L821C
    ldx #$04
    jsr L81A6
    ldx HXFLAG
    beq MPTPSAD
    lda $FE
    jsr $BA3D
    lda SA
    jsr $BA3D
    jmp FINPTPSA
MPTPSAD:
    lda $FE
    ldx SA
    jsr OUTNUM
FINPTPSA:
    jsr L821C
    ldx #$01
    jsr L81A2
    rts
PTPLI:
    ldx PASS
    bne PTPL1
    rts
PTPL1:
    ldx PRINTFLAG
    bne MPTPL
    rts
MPTPL:
    jsr L821C
    ldx #$04
    jsr L81A6
    lda L8FD3
    ldx LINEN
    jsr OUTNUM
    jsr L821C
    ldx #$01
    jsr $61A2
    rts
HEXPRINT:
    pha
    and #$0F
    tay
    lda HEXA,Y
    tax
    pla
    lsr A
    lsr A
    lsr A
    lsr A
    tay
    lda HEXA,Y
    jsr L81D6
    txa
    jsr L81D6
    rts
PSEUDO:
    cmp #$46
    bne PSE1
    jsr FILE
GOBACK:
    pla
    pla
    jmp STARTLINE
PSE1:
    cmp #$45
    bne PSEE
    jsr PEND
    jmp GOBACK
PSEE:
    cmp #$44
    bne PSEE1
    jmp PDISK
PSEE1:
    cmp #$50
    bne PSEE2
    jmp PRINTER
PSEE2:
    cmp #$4E
    bne PSEE3
    jmp NIX
PSEE3:
    cmp #$4F
    bne PSEE4
    jmp OPON
PSEE4:
    cmp #$53
    bne PSEE5
    jmp SCRNOP
PSEE5:
    cmp #$48
    bne PSE9
    jmp HEXIT
PSE9:
    sta LABEL,Y
    jsr PRNTLINE
    jsr PRNTSPACE
    jsr PRNTSA
    jsr ERRING
    jsr PRNTINPUT
    lda #$B4
    sta TEMP
    lda #$8F
    sta $FC
    jsr PRNTMESS
    jsr PRNTCR
    jmp $BBD4
FILE:
    jsr L81B9
    cmp #$20
    beq FIO
    jmp $BAB9
FIO:
    ldy #$00
FI1:
    jsr L81B9
    cmp #$00
    beq FI2
    cmp #$7F
    bcc FII1
    jsr KEYWORD
FII1:
    sta LABEL,Y
    iny
    jmp FI1
FI2:
    sty FNAMELEN
    ldy #$00
FILO:
    lda LABEL,Y
    beq FIL01
    sta FILEN,Y
    iny
    jmp FILO
FIL01:
    lda PASS
    bne FI5
    jsr PRNTSA
    jsr PRNTSPACE
FI5:
    jsr PRNTINPUT
    jsr PRNTCR
    jsr OPEN1
    ldx #$01
    jsr L81A2
    jsr L81B9
    jsr L81B9
    jsr ENDPRO
    ldx #$00
    ldx ENDFLAG,Y
    rts
PEND:
    lda #$2E
    jsr L81D6
    lda #$45
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$44
    jsr L81D6
    lda #$20
    jsr L81D6
    jsr L81B9
    jsr FILE
    lda PASS
    beq PEND1
    inc ENDFLAG
PEND1:
    inc PASS
    sec
    lda SA
    sbc TA
    lda L8FFD,X
    lda $FE
    sbc L8FD1
    sta L8FFE
    lda TA
    sta SA
    lda L8FD1
    sta $FE
    jsr INDISK
    rts
PDISK:
    lda PASS
    beq PULLJ
    jsr L81B9
    sta LABEL,Y
    ldy #$00
PDLOOP:
    jsr L81B9
    beq L8B81
    cmp #$7F
    bcc PDIX
    jsr KEYWORD
PDIX:
    sta LABEL,Y
    sta FILEN,Y
    iny
    jmp PDLOOP
PULLJ:
    jmp PULLINE
L8B81:
    sty FNAMELEN
    jsr PRNTINPUT
    jsr PRNTCR
    inc DISKFLAG
    jsr L80FC
    ldx #$02
    jsr L81A6
    lda TA
    jsr L81D6
    lda L8FD1
    jsr L81D6
    lda L8FFD
    jsr L81D6
    lda L8FFE
    jsr L81D6
EDISK:
    jsr L821C
    ldx #$01
    jsr L81A2
    jsr ENDPRO
    pla
    pla
    ldx #$00
    stx ENDFLAG
    jmp STARTLINE
PRINTER:
    lda PASS
    beq PULLINE
    jsr OPEN4
    inc PRINTFLAG
    jsr L821C
    ldx #$01
    jsr L81A2
PULLINE:
    jsr L81B9
    beq ENDPULL
    cmp #$3A
    beq ENDPULR
    jmp PULLINE
ENDPULL:
    jsr ENDPRO
ENDPULR:
    pla
    ror $A2
    brk
    stx ENDFLAG
    jmp STARTLINE
OPON:
    lda #$2E
    jsr L81D6
    lda #$4F
    jsr L81D6
    jsr PRNTCR
    lda #$01
    sta POKEFLAG
    jmp PULLINE
NIX:
    lda PASS
    beq PULLINE
    jsr L81B9
    cmp #$50
    beq NIXPRINT
    cmp #$4F
    beq NIXOP
    cmp #$53
    beq NIXSCREEN
    cmp #$48
    beq NIXHEX
NIXPRINT:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$50
    jsr L81D6
    jsr PRNTCR
    dec PRINTFLAG
    jsr L821C
    ldx #$04
    jsr L81A6
    lda #$0D
    jsr L81D6
    lda #$04
    jsr L8235
    jsr L821C
    ldx #$01
    jsr L81A2
    jmp PULLINE
NIXOP:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$4F
    jsr L81D6
    jsr PRNTCR
    lda #$00
    sta POKEFLAG
    jmp PULLINE
NIXHEX:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$48
    jsr L81D6
    jsr PRNTCR
    lda #$00
    sta HXFLAG
    jmp PULLINE
NIXSCREEN:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$53
    jsr L81D6
    jsr PRNTCR
    lda #$00
    sta SFLAG
    jmp PULLINE
    lda #$2E
    jsr L81D6
    lda #$53
    jsr L81D6
    jsr PRNTCR
    lda PASS
    beq SCREX
    lda #$01
    sta SFLAG
SCREX:
    jmp PULLINE
HEXIT:
    lda #$2E
    jsr L81D6
    lda #$48
    jsr L81D6
    jsr PRNTCR
    lda #$01
    sta HXFLAG
    jmp PULLINE
; ---- data / tables / variables ----
MNEMONICS:
    .byte $4C,$44,$41,$4C,$44,$59,$4A,$53
    .byte $52,$52,$54,$53,$42,$43,$53,$42
    .byte $45,$51,$42,$43,$43,$43,$4D,$50
    .byte $42,$4E,$45,$4C,$44,$58,$4A,$4D
    .byte $50,$53,$54,$41,$53,$54,$59,$53
    .byte $54,$58,$49,$4E,$59,$44,$45,$59
    .byte $44,$45,$58,$44,$45,$43,$49,$4E
    .byte $58,$49,$4E,$43,$43,$50,$59,$43
    .byte $50,$58,$53,$42,$43,$53,$45,$43
    .byte $41,$44,$43,$43,$4C,$43,$54,$41
    .byte $58,$54,$41,$59,$54,$58,$41,$54
    .byte $59,$41,$50,$48,$41,$50,$4C,$41
    .byte $42,$52,$4B,$42,$4D,$49,$42,$50
    .byte $4C,$41,$4E,$44,$4F,$52,$41,$45
    .byte $4F,$52,$42,$49,$54,$42,$56,$43
    .byte $42,$56,$53,$52,$4F,$4C,$52,$4F
    .byte $52,$4C,$53,$52,$43,$4C,$44,$43
    .byte $4C,$49,$41,$53,$4C,$50,$48,$50
    .byte $50,$4C,$50,$52,$54,$49,$53,$45
    .byte $44,$53,$45,$49,$54,$53,$58,$54
    .byte $56,$53,$43,$4C,$56,$4E,$4F,$50
TYPES:
    .byte $01,$05,$09,$00,$08,$08,$08,$01
    .byte $08,$05,$06,$01,$02,$02,$00,$00
    .byte $00,$02,$00,$02,$04,$04,$01,$00
    .byte $01,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$08,$08,$01,$01,$01,$07,$08
    .byte $08,$03,$03,$03,$00,$00,$03,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
OPS:
    .byte $A1,$A0,$20,$60,$B0,$F0,$90,$C1
    .byte $D0,$A2,$4C,$81,$84,$86,$C8,$88
    .byte $CA,$C6,$E8,$E6,$C0,$E0,$E1,$38
    .byte $61,$18,$AA,$A8,$8A,$98,$48,$68
    .byte $00,$30,$10,$21,$01,$41,$24,$50
    .byte $70,$22,$62,$42,$D8,$58,$02,$08
    .byte $28,$40,$F8,$78,$BA,$9A,$B8,$EA
HEXA:
    .byte $30,$31,$32,$33,$34,$35,$36,$37
    .byte $38,$39,$41,$42,$43,$44,$45,$46
LABEL:
    .byte $00
L8DF2:
    .byte $00
L8DF3:
    .byte $00
L8DF4:
    .byte $00
L8DF5:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00
BUFFER:
    .byte $00
L8E39:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00
BUFM:
    .byte $00
L8E81:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00
L8EDE:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00
FILEN:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00
NUBUF:
    .byte $00,$00,$00,$00,$00,$00,$00
RADD:
    .byte $00
L8F0E:
    .byte $00
VREND:
    .byte $00
TSTORE:
    .byte $00
L8F11:
    .byte $00,$4E,$4F,$20,$53,$54,$41,$52
    .byte $54,$20,$41,$44,$44,$52,$45,$53
    .byte $53,$00,$2D,$2D,$2D,$2D,$2D,$2D
    .byte $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
    .byte $2D,$2D,$2D,$2D,$2D,$2D,$20,$42
    .byte $52,$41,$4E,$43,$48,$20,$4F,$55
    .byte $54,$20,$4F,$46,$20,$52,$41,$4E
    .byte $47,$45,$00,$55,$4E,$44,$45,$46
    .byte $49,$4E,$45,$44,$20,$4C,$41,$42
    .byte $45,$4C,$00,$1D,$1D,$1D,$1D,$1D
    .byte $1D,$1D,$1D,$1D,$20,$4E,$41,$4B
    .byte $45,$44,$20,$4C,$41,$42,$45,$4C
    .byte $00,$1D,$1D,$1D,$1D,$1D,$20,$3C
    .byte $3C,$3C,$3C,$3C,$3C,$3C,$3C,$20
    .byte $44,$49,$53,$4B,$20,$45,$52,$52
    .byte $4F,$52,$20,$3E,$3E,$3E,$3E,$3E
    .byte $3E,$3E,$3E,$20,$00,$1D,$1D,$1D
    .byte $1D,$1D,$20,$2D,$2D,$20,$44,$55
    .byte $50,$4C,$49,$43,$41,$54,$45,$44
    .byte $20,$4C,$41,$42,$45,$4C,$20,$2D
    .byte $2D,$20,$00,$1D,$1D,$1D,$1D,$1D
    .byte $20,$2D,$2D,$20,$53,$59,$4E,$54
    .byte $41,$58,$20,$45,$52,$52,$4F,$52
    .byte $20,$2D,$2D,$20,$00
OP:
    .byte $00
TP:
    .byte $00
TA:
    .byte $00
L8FD1:
    .byte $00
LINEN:
    .byte $00
L8FD3:
    .byte $00
ENDFLAG:
    .byte $00
WORK:
    .byte $00
L8FD6:
    .byte $00
RESULT:
    .byte $00
L8FD8:
    .byte $00,$00,$00
ARGSIZE:
    .byte $00
EXPRESSF:
    .byte $00
HEXFLAG:
    .byte $00
HEXLEN:
    .byte $00,$00
KEYNUM:
    .byte $00
LABSIZE:
    .byte $00
LABPTR:
    .byte $00,$00
ARRAYTOP:
    .byte $00
L8FE5:
    .byte $00
BUFLAG:
    .byte $00
PASS:
    .byte $00
VARA:
    .byte $00
VARX:
    .byte $00
VARY:
    .byte $00
L8FEB:
    .byte $00
L8FEC:
    .byte $00
BNUMFLAG:
    .byte $00
BFLAG:
    .byte $00,$00
ADDNUM:
    .byte $00
L8FF1:
    .byte $00
PLUSFLAG:
    .byte $00
BYTFLAG:
    .byte $00
DISKFLAG:
    .byte $00
PRINTFLAG:
    .byte $00
POKEFLAG:
    .byte $00
COLFLAG:
    .byte $00
FOUNDFLAG:
    .byte $00
SFLAG:
    .byte $00
HXFLAG:
    .byte $00
LOCFLAG:
    .byte $00
BABFLAG:
    .byte $00
L8FFD:
    .byte $00
L8FFE:
    .byte $00
L8FFF:
    .byte $00
L9000:
    .byte $00,$01,$00,$01,$00,$00,$01,$06
    .byte $02,$2D,$93,$00,$00,$00,$93,$00
    .byte $92,$00,$00,$01,$00,$01,$00,$00
    .byte $01,$06,$04,$80,$95,$00,$00,$53
    .byte $95,$53,$94,$00,$00,$03,$01,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$93,$00,$92,$00,$91,$04
    .byte $01,$00,$00,$00,$00,$00,$00
L903F:
    .byte $00,$00,$00,$00,$53,$95,$53,$94
    .byte $53,$93,$02,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$93
    .byte $00,$92,$00,$91,$02,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $53,$95,$53,$94,$53,$93
L906D:
    .byte $00
L906E:
    .byte $00
L906F:
    .byte $00
L9070:
    .byte $00,$01
