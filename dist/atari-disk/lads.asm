; disassembled from lads_atari.bin by dis2src.py -- reassembles byte-exact
.setcpu "6502"

; ---- equates: zero-page variables & ROM routines ----
ST           = $01
CURPOS       = $55
SAVMSC       = $58
FNAMELEN     = $80
FNAMEPTR     = $81
FNUM         = $83
FSECOND      = $84
FDEV         = $85
TEMP         = $86
SA           = $88
MEMTOP       = $8A
PARRAY       = $8C
INFILE       = $8E
OUTFILE      = $8F
PMEM         = $A0
RAMFLAG      = $A2
BABUF        = $0500
TP           = $9AB8
TA           = $9AB9
LINEN        = $9ABB
ENDFLAG      = $9ABD
WORK         = $9ABE
RESULT       = $9AC0
ARGSIZE      = $9AC4
EXPRESSF     = $9AC5
HEXFLAG      = $9AC6
HEXLEN       = $9AC7
LABSIZE      = $9ACA
LABPTR       = $9ACB
ARRAYTOP     = $9ACD
BUFLAG       = $9ACF
PASS         = $9AD0
VARA         = $9AD1
VARX         = $9AD2
VARY         = $9AD3
PT           = $9AD4
BNUMFLAG     = $9AD6
BFLAG        = $9AD7
ADDNUM       = $9AD9
PLUSFLAG     = $9ADB
BYTFLAG      = $9ADC
DISKFLAG     = $9ADD
PRINTFLAG    = $9ADE
POKEFLAG     = $9ADF
COLFLAG      = $9AE0
SFLAG        = $9AE2
HXFLAG       = $9AE3
LOCFLAG      = $9AE4
BABFLAG      = $9AE5

.org $8000

    jmp EDIT
START:
    lda #$00
    sta $52
    ldy #$30
STRTLP:
    sta OP,Y
    dey
    bne STRTLP
    lda #$00
    sta MEMTOP
    sta ARRAYTOP
    lda #$80
    sta $8B
    sta $9ACE
    lda #$01
    sta HXFLAG
    jsr CLRCHN
    lda RAMFLAG
    bne STORE
    ldy #$00
    ldx ARGPOS
    inx
L802F:
    lda BABUF,X
    cmp #$9B
    beq L803E
    sta FILEN,Y
    iny
    inx
    jmp L802F
L803E:
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
    lda #$A0
    jsr L9124
    lda #$4C
    jsr L9124
    lda #$41
    jsr L9124
    lda #$44
    jsr L9124
    lda #$53
    jsr L9124
    jsr PRNTCR
CKHEX:
    lda HEXFLAG
    bne STAR1
    lda #$90
    sta TEMP
    lda #$99
    sta $87
    jsr VALDEC
STAR1:
    lda RESULT
    sta SA
    sta TA
    lda $9AC1
    sta $89
    sta $9ABA
STARTLINE:
    jsr L91AF
    lda ENDFLAG
    beq EVIND
    jmp FINI
EVIND:
    jsr INDISK
    lda #$00
    sta EXPRESSF
    sta BUFLAG
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
    lda L9993
    bne EVGO
    lda #$08
    clc
    adc OP
    sta OP
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
    sta FILEN,Y
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
    lda L99A6
    inc BUFLAG
EVE1:
    eor #$80
    sta WORK
    jsr ARRAY
    jmp L340
EVGO:
    ldy #$00
    sty EXPRESSF
    lda L9993
    cmp #$20
    beq GVEG
    jmp L700
GVEG:
    lda L9994,Y
    cmp #$41
    bcc EVM02A
    inc EXPRESSF
EVM02A:
    sta BUFFER,Y
    iny
    lda L9994,Y
    beq EVM03
    sta BUFFER,Y
    cmp #$41
    bcc EVM02
    inc EXPRESSF
EVM02:
    iny
    lda L9994,Y
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
    lda #$A5
    sta TEMP
    lda #$99
    sta $87
    ldy #$00
    lda BUFFER
    cmp #$30
    bcs MCAL
    clc
    inc TEMP
    bcc MCAL
    inc $87
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
    tay
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
    lda BUFFER,Y
    cmp #$29
    beq MINDIR
    lda TP
    cmp #$01
    bne MINDIR
    lda #$10
    clc
    adc OP
    sta OP
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
    lda RESULT
    sbc SA
    pha
    lda $9AC1
    sbc $89
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
    sta RESULT
    lda #$00
    sta $9AC1
    jmp TWOS
EVM05:
    ldy ARGSIZE
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
    lda $9AC1
    bne PREPTHREES
    lda TP
    cmp #$06
    bcs TWOS
    cmp #$02
    beq TWOS
    lda #$04
    clc
    adc OP
    sta OP
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
    sta OP
JUMO:
    jmp THREES
IMMED:
    lda L99A6
    cmp #$22
    bne IMMEDX
    lda L99A7
    sta RESULT
IMMEDX:
    lda TP
    cmp #$01
    bne TWOS
    lda #$08
    clc
    adc OP
    sta OP
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
    lda LOCFLAG
    bne PRMMX1
    lda PRINTFLAG
    beq PRMM
    lda #$14
    sec
    sbc CURPOS
    sta VARA
    jsr CLRCHN
    ldx #$04
    jsr L910B
    ldy VARA
    bpl PRXM1
    ldy #$02
    jmp PRMLOP
PRXM1:
    lda #$20
PRMLOP:
    jsr L9124
    dey
    bne PRMLOP
    jsr CLRCHN
    ldx #$01
    jsr L9108
PRMM:
    lda #$14
    sta CURPOS
    lda #$E2
    sta TEMP
    lda #$99
    sta $87
    jsr PRNTMESS
PRMMX1:
    lda #$1E
    sec
    sbc CURPOS
    sta VARX
    lda #$1E
    sta CURPOS
    lda PRINTFLAG
    beq PRMMFIN
    jsr CLRCHN
    ldx #$04
    jsr L910B
    ldy VARX
    beq PXMX
    bmi PXMX
    lda #$20
PRMLOPX:
    jsr L9124
    dey
    bne PRMLOPX
PXMX:
    jsr CLRCHN
    ldx #$01
    jsr L9108
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
    jsr L9124
    jsr PTP1
PRXM:
    lda BABFLAG
    beq RETTX
    jsr PRNTSPACE
    lda #$3B
    jsr L9124
    lda #$00
    sta TEMP
    lda #$05
    sta $87
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
    lda SA
    sta $9AE6
    lda $89
    sta $9AE7
    lda TA
    sta SA
    lda $9ABA
    sta $89
    jsr CLRCHN
    lda #$01
    jsr L9119
    lda RAMFLAG
    bne L83D9
    jsr OPEN1
L83D9:
    jmp STORE
FIN:
    jsr CLRCHN
    lda #$01
    jsr L9119
    ldx #$02
    jsr L910B
    lda #$00
    jsr L9124
    jsr CLRCHN
    lda #$02
    jsr L9119
    lda PRINTFLAG
    beq FINFIN
    jsr CLRCHN
    ldx #$04
    jsr L910B
    lda #$0D
    jsr L9124
    jsr CLRCHN
    lda #$04
    jsr L9119
FINFIN:
    jmp L91B6
XYTYPE:
    lda BUFFER,Y
    cmp #$58
    beq L720
    dey
    dey
    lda BUFFER,Y
    cmp #$29
    bne ZEROY
    jmp INDIR
ZEROY:
    lda $9AC1
    bne L680
    lda TP
    cmp #$02
    beq L730
    cmp #$05
    beq L730
    cmp #$01
    beq L760
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
    lda #$9D
    sta TEMP
    lda #$9A
    sta $87
    jsr PRNTMESS
    jmp INLINE
L720:
    lda $9AC1
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
    sta OP
L760:
    lda L99A7,Y
    cmp #$59
    bne ML760
    lda OP
    cmp #$B6
    beq ML760
    jmp L700
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
    sta OP
    jmp THREES
P:
    sta VARA
    sty VARY
    stx VARX
    lda #$A0
    jsr L9124
    pla
    tax
    pla
    tay
    tya
    pha
    txa
    pha
    tya
    jsr L91CF
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
    cpy #$50
    bne CLEMORE
    rts
DOBERR:
    jsr PRNTCR
    jsr ERRING
    jsr PRNTLINE
    lda #$12
    sta TEMP
    lda #$9A
    sta $87
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
    lda $8B
    sbc #$00
    sta $8B
    ldy #$00
    lda LABEL,Y
    eor #$80
    sta (MEMTOP),Y
EQ3:
    iny
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
    lda $89
    sta (MEMTOP),Y
    ldx LABSIZE
    dex
    ldy #$00
EQ5:
    lda LABEL,X
    beq EQ4
    sta LABEL,Y
    inx
    iny
    jmp EQ5
EQ4:
    sta LABEL,Y
    rts
NOAR:
    jsr ERRING
    lda #$46
    sta TEMP
    lda #$9A
    sta $87
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
    sty $9ABF
    lda #$90
    clc
    adc $9ABF
    sta TEMP
    lda #$99
    adc #$00
    sta $87
    jsr VALDEC
FINEQ:
    ldy LABPTR
    lda RESULT
    sta (MEMTOP),Y
    lda $9AC1
    iny
    sta (MEMTOP),Y
EQRET:
    pla
    pla
    jmp INLINE
ARRAY:
    lda ARRAYTOP
    sta PARRAY
    lda $9ACE
    sta $8D
    jsr DECPAR
    lda #$FF
    sta FOUNDFLAG
STARTLK:
    sec
    lda MEMTOP
    sbc PARRAY
    lda $8B
    sbc $8D
    bcs ADONE
    ldx #$00
    sec
    lda PARRAY
    sbc #$02
    sta PARRAY
    lda $8D
    sbc #$00
    sta $8D
    ldy #$00
LPAR:
    lda (PARRAY),Y
    bmi FOUNDONE
    lda PARRAY
    bne MDECX
    dec $8D
MDECX:
    dec PARRAY
    inx
    jmp LPAR
FOUNDONE:
    lda PARRAY
    sta PT
    lda $8D
    sta $9AD5
    lda (PARRAY),Y
    cmp WORK
    beq LKMORE
    jmp STARTOVER
LKMORE:
    inx
    stx $9ABF
    ldx #$01
    lda BUFLAG
    beq LKM1
    iny
    jsr DECPAR
LKM1:
    iny
    lda BUFFER,Y
    beq FOUNDIT
    cmp #$30
    bcc FOUNDIT
    inx
    cmp (PARRAY),Y
    beq LKM1
STARTOVER:
    lda PT
    sta PARRAY
    lda $9AD5
    sta $8D
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
    lda #$36
    sta TEMP
    lda #$9A
    sta $87
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
    cpx $9ABF
    beq FOUNDF
    jmp STARTOVER
FOUNDF:
    inc FOUNDFLAG
    beq FOFX
    jsr DUPLAB
FOFX:
    ldy $9ABF
    lda BUFLAG
    beq FOF
    iny
FOF:
    lda (PARRAY),Y
    sta RESULT
    iny
    lda (PARRAY),Y
    sta $9AC1
    lda BYTFLAG
    beq CMPMO
    cmp #$02
    bne AREND
    lda $9AC1
    sta RESULT
CMPMO:
    lda PLUSFLAG
    beq AREND
    clc
    lda ADDNUM
    adc RESULT
    sta RESULT
    lda $9ADA
    adc $9AC1
    sta $9AC1
AREND:
    lda PASS
    beq ARENX
    rts
ARENX:
    jmp STARTOVER
DECPAR:
    lda PARRAY
    bne MDEC
    dec $8D
MDEC:
    dec PARRAY
    rts
DUPLAB:
    jsr ERRING
    lda #$7F
    sta TEMP
    lda #$9A
    sta $87
    jsr PRNTMESS
    jsr PRNTCR
    rts
OPEN1:
    jsr CLRCHN
    lda #$01
    jsr L9119
    lda #$01
    sta FNUM
    lda #$04
    sta FDEV
    lda #$00
    sta FSECOND
NAMEAD:
    lda #$E2
    sta FNAMEPTR
    lda #$99
    sta $82
    jsr L90DA
    lda ST
    bmi L8740
    lda RAMFLAG
    beq L873F
    jsr L9803
    lda #$00
    sta PMEM
    lda #$20
    sta $A1
L873F:
    rts
L8740:
    jsr L9673
    jmp L91B6
L8746:
    lda #$02
    sta FNUM
    lda #$08
    sta FDEV
    lda #$00
    sta FSECOND
    lda #$E2
    sta FNAMEPTR
    lda #$99
    sta $82
    lda #$02
    jsr L9119
    lda ST
    bmi L8740
    jsr L90DA
    ldx #$02
    jsr L910B
    lda #$FF
    jsr L9124
    jsr L9124
    lda TA
    jsr L9124
    lda $9ABA
    jsr L9124
    lda $9AE6
    jsr L9124
    lda $9AE7
    jsr L9124
    jsr CLRCHN
    rts
OPEN4:
    lda #$04
    sta FNUM
    jsr L9119
    lda #$08
    sta FDEV
    lda #$00
    sta FSECOND
    lda #$02
    sta FNAMELEN
    lda #$B5
    sta FNAMEPTR
    lda #$87
    sta $82
    jsr L90DA
    lda ST
    bmi L8740
    jsr CLRCHN
    rts
    bvc $87F1
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
    cmp L9991
    beq MORE1
    iny
    iny
    bne LOOP
    beq NOMATCH
MORE1:
    iny
    lda MNEMONICS,Y
    cmp L9992
    beq FOUND
    iny
    bne LOOP
    beq NOMATCH
FOUND:
    lda L9993
    cmp #$20
    beq FO1
    cmp #$00
    bne NOMATCH
FO1:
    lda TYPES,X
    sta TP
    ldy OPS,X
    sty OP
END:
    jmp EVAR
GETSA:
    lda #$00
    sta PMEM
    lda #$20
    sta $A1
    ldx #$01
    jsr L9108
    jsr L91F1
    jsr L9155
    cmp #$2A
    beq MSA
    lda #$01
    sta TEMP
    lda #$9A
    sta $87
    jsr PRNTMESS
    jmp FIN
MSA:
    rts
VALDEC:
    ldy #$00
VGETZERO:
    lda (TEMP),Y
    cmp #$30
    bcc VZERO
    cmp #$3A
    bcs VZERO
    iny
    jmp VGETZERO
VZERO:
    sty VREND
    dey
    lda #$00
    sta RESULT
    sta $9AC1
    ldx #$01
    stx VARX
VALLOOP:
    lda (TEMP),Y
    and #$0F
    sta RADD
    sta TSTORE
    lda #$00
    sta L99FD
    sta L9A00
VLOOP:
    dex
    beq VGOON
    jsr TEN
    lda RADD
    sta TSTORE
    lda L99FD
    sta L9A00
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
    rol L99FD
    asl RADD
    rol L99FD
    clc
    lda TSTORE
    adc RADD
    sta RADD
    lda L9A00
    adc L99FD
    sta L99FD
    asl RADD
    rol L99FD
    rts
VALADD:
    clc
    lda RADD
    adc RESULT
    sta RESULT
    lda L99FD
    adc $9AC1
    sta $9AC1
    rts
INDISK:
    jsr CLEANLAB
    ldy #$00
    sty HEXFLAG
    sty BABFLAG
    sty BYTFLAG
    sty PLUSFLAG
    lda COLFLAG
    bne NOBLANKS
    jsr L91F1
NOBLANKS:
    jsr L9155
    bne COOLOOK
    jsr ENDPRO
    pla
    pla
    jmp STARTLINE
COOLOOK:
    cmp #$20
    beq NOBLANKS
    jmp MOI1
STINDISK:
    jsr L9155
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
    sty VARA
    lda PRINTFLAG
    beq PULLRX
    sta BABFLAG
    lda VARA
    beq PUX
    jsr PULLREST
    jmp MPULL
PUX:
    jsr L9155
    beq PUX1
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
    jsr L9155
    bne L8948
    sta BABUF,Y
    ldy VARA
    rts
L8948:
    nop
PAXA:
    sta BABUF,Y
    iny
    jmp PAX1
PULLRX:
    jsr L9155
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
    beq PSEUDOO
    cmp #$24
    beq HEXX
ADDLAB:
    sta LABEL,Y
    iny
    jmp STINDISK
COLON:
    sta COLFLAG
    rts
PSEUDOO:
    jmp PSEUDOJ
HEXX:
    sta LABEL,Y
    iny
    jmp HEX
HI:
    lda #$02
    sta BYTFLAG
    jmp STINDISK
LO:
    lda #$01
    sta BYTFLAG
    jmp STINDISK
STAR:
    jsr STINDISK
    lda PASS
    beq STARN
    lda #$2A
    jsr L9124
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
    lda #$90
    clc
    adc TEMP
    sta TEMP
    lda #$99
    adc #$00
    sta $87
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
    lda $9AC1
    sta $89
    pla
    pla
    jmp STARTLINE
ENDPRO:
    sta LABEL,Y
    iny
    cpy #$50
    bne ENDPRO
    sta LABEL,Y
    lda $0353
    cmp #$03
    beq INEND
    cmp #$88
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
    jsr L9155
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
    inx
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
    sta VARA
    lda #$00
    stx HEXLEN
    sta LABEL,Y
    jsr STARTHEX
    lda VARA
    jmp MOINDI
STARTHEX:
    lda #$00
    sta RESULT
    sta $9AC1
    tax
HXLOOP:
    asl RESULT
    rol $9AC1
    asl RESULT
    rol $9AC1
    asl RESULT
    rol $9AC1
    asl RESULT
    rol $9AC1
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
    jsr L9155
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
    jsr PRNTSPACE
    jsr PRNTSA
    jsr PRNTSPACE
    ldy VARY
CLB:
    jsr L9155
    sta LABEL,Y
    iny
    cmp #$20
    bne CLB
    jsr L9155
    sta LABEL,Y
    iny
    cmp #$22
    bne BNUMWERK
BY1:
    jsr L9155
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
    stx BABFLAG
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
    sta LABEL,Y
    tax
    sty VARY
    jsr POKEIT
    ldy VARY
    iny
    jmp BY1
BNUMWERK:
    ldx #$00
    stx BFLAG
    sta NUBUF,X
    inx
WERK1:
    lda BFLAG
    bne BBEND
WK0:
    jsr L9155
    beq BSFLAG
    cmp #$3A
    beq BSFLAG
    cmp #$3B
    bne WK1
    jsr PULLREST
    ldx PRINTFLAG
    stx BABFLAG
    jmp BSFLAG
WK1:
    sta BUFM
    lda PASS
    bne WERK5
    lda BUFM
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
    sta L99BA
    jmp WK1
WERK2:
    lda #$F5
    sta TEMP
    lda #$99
    sta $87
    sty VARY
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
    lda PASS
    bne BBEND1
    jsr INCSA
BBEND1:
    lda L99BA
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
    jsr CLRCHN
    ldx #$02
    jsr L910B
    sec
    lda RESULT
    sbc SA
    sta WORK
    lda $9AC1
    sbc $89
    sta $9ABF
PUTSPCR:
    lda #$00
    jsr L9124
    lda WORK
    bne DECWORKX
    dec $9ABF
DECWORKX:
    dec WORK
    bne PUTSPCR
    lda $9ABF
    bne PUTSPCR
RESFILL:
    jsr CLRCHN
    ldx #$01
    jsr L9108
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
    bcs VALIT
    sta HEXBUF,X
    inx
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
    lda #$CD
    sta TEMP
    lda #$99
    sta $87
    jsr VALDEC
    lda RESULT
    sta ADDNUM
    lda $9AC1
    sta $9ADA
    rts
FORMAT:
    lda PASS
    bne PRM
    jsr INCSA
    rts
PRM:
    lda SFLAG
    beq PRMX
    jsr CLRCHN
    ldx #$01
    jsr L9108
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
PRINT3:
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
    beq P3MXX
    lda HXFLAG
    beq P3MX2
    jsr PRNTSPACE
P3MX2:
    ldx $9AC1
    jsr PRNTNUM
P3MXX:
    ldx $9AC1
    jmp POKEIT
POKEIT:
    stx $9ABF
    lda POKEFLAG
    beq DISP
    ldy #$00
    txa
    sta (SA),Y
DISP:
    lda DISKFLAG
    beq INCSA
    jsr CLRCHN
    ldx #$02
    jsr L910B
    lda $9ABF
    jsr L912A
    jsr CLRCHN
    ldx #$01
    jsr L9108
INCSA:
    clc
    lda #$01
    adc SA
    sta SA
    lda #$00
    adc $89
    sta $89
    rts
PRNTMESS:
    ldy #$00
MESSLOOP:
    lda (TEMP),Y
    beq MESSDONE
    jsr L9124
    jsr PTP
    iny
    jmp MESSLOOP
MESSDONE:
    rts
PRNTSPACE:
    lda #$20
    jsr L9124
    jsr PTP
    rts
PRNTNUM:
    stx VARX
    lda HXFLAG
    beq PRNTNUMD
    txa
    jsr HEXPRINT
    jsr PTPNU
    ldx VARX
    rts
PRNTNUMD:
    lda #$00
    jsr L91CF
    jsr PTPNU
    ldx VARX
    rts
PRNTSA:
    lda HXFLAG
    beq PRNTSAD
    lda $89
    jsr HEXPRINT
    lda SA
    jsr HEXPRINT
    jsr PTPSA
    rts
PRNTSAD:
    ldx SA
    lda $89
    jsr L91CF
    jsr PTPSA
    rts
PRNTCR:
    lda #$0D
    jsr L9124
    jsr PTP
    rts
PRNTLINE:
    ldx LINEN
    lda $9ABC
    jsr L91CF
    jsr PTPLI
    rts
PRNTINPUT:
    lda #$90
    sta TEMP
    lda #$99
    sta $87
    jsr PRNTMESS
    rts
ERRING:
    lda #$FD
    jsr L9124
    jsr PRNTINPUT
    lda #$0D
    jsr L9124
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
    sta VARA
    jsr CLRCHN
    ldx #$04
    jsr L910B
    lda VARA
    jsr L9124
    jsr CLRCHN
    ldx #$01
    jsr L9108
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
    jsr CLRCHN
    ldx #$04
    jsr L910B
    lda HXFLAG
    beq MPTPND
    lda VARX
    jsr HEXPRINT
    jmp FINPTP
MPTPND:
    lda #$00
    ldx VARX
    jsr L91CF
FINPTP:
    jsr CLRCHN
    ldx #$01
    jsr L9108
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
    jsr CLRCHN
    ldx #$04
    jsr L910B
    ldx HXFLAG
    beq MPTPSAD
    lda $89
    jsr HEXPRINT
    lda SA
    jsr HEXPRINT
    jmp FINPTPSA
MPTPSAD:
    lda $89
    ldx SA
    jsr L91CF
FINPTPSA:
    jsr CLRCHN
    ldx #$01
    jsr L9108
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
    jsr CLRCHN
    ldx #$04
    jsr L910B
    lda $9ABC
    ldx LINEN
    jsr L91CF
    jsr CLRCHN
    ldx #$01
    jsr L9108
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
    jsr L9124
    txa
    jsr L9124
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
    lda #$9D
    sta TEMP
    lda #$9A
    sta $87
    jsr PRNTMESS
    jsr PRNTCR
    jmp PULLINE
FILE:
    jsr L9155
    cmp #$20
    beq FIO
    jmp FILE
FIO:
    ldy #$00
FI1:
    jsr L9155
    cmp #$00
    beq FI2
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
    cpy FNAMELEN
    bne FILO
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
    jsr L9108
    ldx #$00
    stx ENDFLAG
    rts
PEND:
    lda #$2E
    jsr L9124
    lda #$45
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$44
    jsr L9124
    lda #$20
    jsr L9124
    jsr FILE
    lda PASS
    beq L8F4B
    inc ENDFLAG
L8F4B:
    inc PASS
    lda SA
    sta $9AE6
    lda $89
    sta $9AE7
    lda TA
    sta SA
    lda $9ABA
    sta $89
    jsr INDISK
    rts
PDISK:
    lda PASS
    beq L8F82
    jsr L9155
    sta LABEL,Y
    ldy #$00
PDLOOP:
    jsr L9155
    beq L8F85
    sta LABEL,Y
    sta FILEN,Y
    iny
    jmp PDLOOP
L8F82:
    jmp PULLINE
L8F85:
    sty FNAMELEN
    jsr PRNTINPUT
    jsr PRNTCR
    inc DISKFLAG
    jsr L8746
EDISK:
    jsr CLRCHN
    ldx #$01
    jsr L9108
    jsr DISERR
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
    jsr CLRCHN
    ldx #$01
    jsr L9108
PULLINE:
    jsr L9155
    beq ENDPULL
    cmp #$3A
    beq ENDPULR
    jmp PULLINE
ENDPULL:
    jsr ENDPRO
ENDPULR:
    pla
    pla
    ldx #$00
    stx ENDFLAG
    jmp STARTLINE
OPON:
    lda #$2E
    jsr L9124
    lda #$4F
    jsr L9124
    jsr PRNTCR
    lda #$01
    sta POKEFLAG
    jmp PULLINE
NIX:
    lda PASS
    beq PULLINE
    jsr L9155
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
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$50
    jsr L9124
    jsr PRNTCR
    dec PRINTFLAG
    jsr CLRCHN
    ldx #$04
    jsr L910B
    lda #$0D
    jsr L9124
    lda #$04
    jsr L9119
    jsr CLRCHN
    ldx #$01
    jsr L9108
    jmp PULLINE
NIXOP:
    lda #$2E
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$4F
    jsr L9124
    jsr PRNTCR
    lda #$00
    sta POKEFLAG
    jmp PULLINE
NIXHEX:
    lda #$2E
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$48
    jsr L9124
    jsr PRNTCR
    lda #$00
    sta HXFLAG
    jmp PULLINE
NIXSCREEN:
    lda #$2E
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$53
    .byte $34
    bpl $900A
    jsr PRNTCR
    lda #$00
    sta SFLAG
    jmp PULLINE
DISERR:
    ldx a:$0063
    brk
    brk
    brk
    brk
    brk
    jsr PRNTNUM
    jsr PRNTSPACE
    lda #$5C
    sta TEMP
    lda #$9A
    sta $87
    jsr ERRING
    jsr PRNTMESS
    pla
    pla
    jmp FIN
SCRNOP:
    lda #$2E
    jsr L9124
    lda #$53
    jsr L9124
    jsr PRNTCR
    lda PASS
    beq SCREX
    lda #$01
    sta SFLAG
SCREX:
    jmp PULLINE
HEXIT:
    lda #$2E
    jsr L9124
    lda #$48
    jsr L9124
    jsr PRNTCR
    lda #$01
    sta HXFLAG
    jmp PULLINE
L90D4:
    asl A
    asl A
    asl A
    asl A
    tax
    rts
L90DA:
    lda FNUM
    jsr L90D4
    lda FNAMEPTR
    sta $0344,X
    lda $82
    sta $0345,X
    lda FNAMELEN
    sta $0348,X
    lda #$00
    sta $0349,X
    lda FDEV
    sta $034A,X
    lda FSECOND
    sta $034B,X
    lda #$03
    sta $0342,X
L9102:
    jsr $E456
    sty ST
    rts
L9108:
    stx INFILE
    rts
L910B:
    stx OUTFILE
    rts
CLRCHN:
    ldx #$00
    stx INFILE
    stx OUTFILE
    stx FNUM
    stx ST
    rts
L9119:
    jsr L90D4
    lda #$0C
    sta $0342,X
    jmp L9102
L9124:
    cmp #$0D
    bne L912A
    lda #$9B
L912A:
    sta L91CB
    sty L91CC
    stx L91CD
    lda OUTFILE
    jsr L90D4
    lda #$00
    sta $0348,X
    sta $0349,X
    lda #$0B
    sta $0342,X
    lda L91CB
    jsr L9102
    ldy L91CC
    ldx L91CD
    lda L91CB
    rts
L9155:
    sty L91CC
    stx L91CD
    lda RAMFLAG
    beq L918D
    ldy #$00
    lda (PMEM),Y
    pha
    inc PMEM
    bne L916A
    inc $A1
L916A:
    clc
    lda PMEM
    sbc L922F
    sta L91CE
    lda $A1
    sbc L9230
    ora L91CE
    bcc L9182
    beq L9182
    jmp FINI
L9182:
    lda #$00
    sta ST
    sta $0353
    pla
    jmp L91A2
L918D:
    lda INFILE
    jsr L90D4
    lda #$00
    sta $0348,X
    sta $0349,X
    lda #$07
    sta $0342,X
    jsr L9102
L91A2:
    ldy L91CC
    ldx L91CD
    cmp #$9B
    bne L91AE
    lda #$00
L91AE:
    rts
L91AF:
    pha
    lda $11
    beq L91B6
    pla
    rts
L91B6:
    jmp EDIT
L91B9:
    ldx #$07
L91BB:
    stx L91CE
    txa
    jsr L9119
    ldx L91CE
    dex
    bne L91BB
    jmp CLRCHN
L91CB:
    brk
L91CC:
    brk
L91CD:
    brk
L91CE:
    brk
L91CF:
    stx $D4
    sta $D5
    jsr $D9AA
    jsr $D8E6
    ldy #$00
L91DB:
    sty L91F0
    lda ($F3),Y
    pha
    and #$7F
    jsr L9124
    pla
    bmi L91EF
    ldy L91F0
    iny
    bne L91DB
L91EF:
    rts
L91F0:
    brk
L91F1:
    ldy #$00
L91F3:
    jsr L9155
    cmp #$20
    beq L9201
    sta BABUF,Y
    iny
    jmp L91F3
L9201:
    lda #$00
    sta BABUF,Y
    lda #$00
    sta TEMP
    lda #$05
    sta $87
    jsr VALDEC
    lda RESULT
    sta LINEN
    lda $9AC1
    sta $9ABC
    ldy #$00
    rts
    jmp EDIT
L9223:
    brk
L9224:
    brk
L9225:
    brk
L9226:
    brk
L9227:
    brk
L9228:
    brk
L9229:
    brk
L922A:
    brk
L922B:
    brk
L922C:
    brk
L922D:
    brk
L922E:
    brk
L922F:
    brk
L9230:
    brk
L9231:
    brk
L9232:
    brk
L9233:
    brk
L9234:
    brk
L9235:
    brk
L9236:
    brk
FOUNDFLAG:
    brk
L9238:
    brk
L9239:
    brk
L923A:
    brk
L923B:
    brk
L923C:
    brk
L923D:
    brk
ARGPOS:
    brk
L923F:
    brk
L9240:
    brk
L9241:
    brk
L9242:
    brk
L9243:
    lda L9223
    sta $9268
    lda L9224
    sta $9269
    lda L9225
    sta $926B
    lda L9226
    sta $926C
    ldx L9228
    beq L9280
L9260:
    lda #$00
L9262:
    sta L9229
    ldy #$00
L9267:
    lda $FFFF,Y
    sta $FFFF,Y
    iny
    cpy L9229
    bne L9267
    inc $9269
    inc $926C
    cpx #$00
    beq L9285
    dex
    bne L9260
L9280:
    lda L9227
    bne L9262
L9285:
    rts
L9286:
    lda L9228
    tax
    ora L9227
    bne L9290
    rts
L9290:
    clc
    txa
    adc L9224
    sta $92B8
    lda L9223
    sta $92B7
    clc
    txa
    adc L9226
    sta $92BB
    lda L9225
    sta $92BA
    inx
    ldy L9227
    bne L92B6
    beq L92C1
L92B4:
    ldy #$FF
L92B6:
    lda $FFFF,Y
    sta $FFFF,Y
    dey
    cpy #$FF
    bne L92B6
L92C1:
    dec $92B8
    dec $92BB
    dex
    bne L92B4
    rts
EDIT:
    ldx #$FF
    txs
    jsr L91B9
    lda #$00
    sta RAMFLAG
    lda #$02
    sta $52
    jsr PRNTCR
    lda #$F0
    sta L947C
    lda #$96
    sta L947D
    lda #$E4
    sta L947E
    lda #$94
    sta L947F
    lda #$54
    sta L9480
    lda #$93
    sta L9481
    lda #$AF
    sta L9482
    lda #$97
    sta L9483
    lda #$F6
    sta L9484
    lda #$97
    sta L9485
    lda #$C4
    sta L9486
    lda #$97
    sta L9487
    lda #$D3
    sta L9488
    lda #$97
    sta L9489
    lda #$E0
    sta L948A
    lda #$97
    sta L948B
    lda #$4A
    sta $0206
    lda #$98
    sta $0207
    lda L9241
    beq L933E
    jmp L9357
L933E:
    lda #$CB
    sta L9241
    jmp L9354
L9346:
    lda #$00
    sta L922F
    lda #$20
    sta L9230
    jsr CLRCHN
    rts
L9354:
    jsr L9346
L9357:
    lda #$8E
    ldy #$96
    jsr L9592
L935E:
    ldy #$00
    sty L923F
    sty L9240
L9366:
    jsr L9155
    ldx ST
    bpl L937E
    cpx #$88
    beq L9378
    cpx #$80
    beq L9378
    jsr L9673
L9378:
    jsr L9668
    jmp L9357
L937E:
    cmp #$22
    bne L938C
    pha
    lda L9240
    eor #$01
    sta L9240
    pla
L938C:
    cmp #$30
    bne L9395
    ldx L923F
    beq L9366
L9395:
    inc L923F
    cmp #$3B
    bne L939F
    inc L9240
L939F:
    ldx L9240
    bne L93B0
    and #$7F
    cmp #$61
    bcc L93B0
    cmp #$7B
    bcs L93B0
    and #$5F
L93B0:
    sta BABUF,Y
    iny
    cmp #$00
    bne L9366
    dey
    lda #$9B
    sta BABUF,Y
    sty L922A
    cpy #$00
    beq L935E
    lda BABUF
    cmp #$3A
    bcs L93F3
    cmp #$30
    bcs L93D3
    jmp L93F3
L93D3:
    lda #$FF
    jsr L96DF
    lda $D0
    sta L922D
    lda FOUNDFLAG
    bne L93E5
    jsr L95A3
L93E5:
    ldy L922D
    cpy L922A
    beq L93F0
    jsr L95FF
L93F0:
    jmp L935E
L93F3:
    lda #$52
    sta $CB
    lda #$94
    sta $CC
    ldy #$00
    sty L922E
    ldx #$00
L9402:
    lda ($CB),Y
    beq L9436
    cmp #$FF
    beq L942C
    cmp BABUF,X
    bne L9418
    inx
L9410:
    iny
    bne L9402
    inc $CC
    jmp L9402
L9418:
    lda ($CB),Y
    beq L9424
    iny
    bne L9418
    inc $CC
    jmp L9418
L9424:
    inc L922E
    ldx #$00
    jmp L9410
L942C:
    lda #$9C
    ldy #$96
    jsr L9592
    jmp L9357
L9436:
    stx ARGPOS
    lda L922E
    asl A
    tax
    lda L947C,X
    sec
    sbc #$01
    sta L9242
    lda L947D,X
    sbc #$00
    pha
    lda L9242
    pha
    rts
    jmp $5349
    .byte $54
    brk
    .byte $44
    .byte $4F
    .byte $53
    brk
    lsr $5745
    brk
    .byte $53
    eor ($56,X)
    eor $20
    brk
    jmp $414F
    .byte $44
    jsr $4D00
    eor $52
    .byte $47
    eor $20
    brk
    jmp $4441
    .byte $53
    brk
    .byte $53
    eor a:$0053,Y
    .byte $FF
L947C:
    brk
L947D:
    brk
L947E:
    brk
L947F:
    brk
L9480:
    brk
L9481:
    brk
L9482:
    brk
L9483:
    brk
L9484:
    brk
L9485:
    brk
L9486:
    brk
L9487:
    brk
L9488:
    brk
L9489:
    brk
L948A:
    brk
L948B:
    brk
L948C:
    lda #$00
    sta $CB
    sec
    lda L922F
    sbc $CB
    sta L9227
    lda #$20
    sta $CC
    lda L9230
    sbc $CC
    sta L9228
L94A5:
    lda L9228
    tax
    ora L9227
    bne L94AF
    rts
L94AF:
    lda #$01
    sta $02FE
    cpx #$00
    beq L94D5
    lda #$00
    sta L9231
L94BD:
    ldy #$00
L94BF:
    lda ($CB),Y
    jsr L9124
    lda ST
    bmi L94DE
    iny
    cpy L9231
    bne L94BF
    inc $CC
    dex
    bmi L94DE
    bne L94BF
L94D5:
    lda L9227
    sta L9231
    jmp L94BD
L94DE:
    lda #$00
    sta $02FE
    rts
    jmp ($000A)
L94E7:
    lda #$00
    sta $CB
    lda #$20
    sta $CC
    lda #$00
    sta FOUNDFLAG
    tay
    sty L9232
    tya
    clc
    adc $CB
    sta TEMP
    sta L9233
    sta L9235
    lda $CC
    adc #$00
    sta $87
    sta L9234
    sta L9236
    sec
    lda L9233
    sbc L922F
    sta L9242
    lda L9234
    sbc L9230
    ora L9242
    bcc L9528
    jmp L9561
L9528:
    jsr VALDEC
    sec
    lda RESULT
    sbc L922B
    sta L9242
    lda $9AC1
    sbc L922C
    ora L9242
    beq L954D
    bcs L9550
    jsr L9580
    iny
    bne L954A
    brk
    brk
L954A:
    brk
    brk
    brk
L954D:
    brk
    .byte $37
    .byte $92
L9550:
    jsr L9580
    clc
    tya
    adc $CB
    sta L9235
    lda #$00
    adc $CC
    sta L9236
L9561:
    inc FOUNDFLAG
    sec
    lda L9235
    sbc L9233
    sta L9238
    lda L9236
    sbc L9234
    sta L9239
    inc L9238
    bne L957F
    inc L9239
L957F:
    rts
L9580:
    ldy L9232
L9583:
    lda ($CB),Y
    cmp #$9B
    beq L9591
    iny
    bne L9583
    inc $CC
    jmp L9583
L9591:
    rts
L9592:
    sta $CB
    sty $CC
    ldy #$00
L9598:
    lda ($CB),Y
    beq L95A2
    jsr L9124
    iny
    bne L9598
L95A2:
    rts
L95A3:
    lda L9235
    clc
    adc #$01
    sta L9223
    lda L9236
    adc #$00
    sta L9224
    lda L9233
    sta L9225
    lda L9234
    sta L9226
    sec
    lda L922F
    sbc L9235
    sta L9227
    lda L9230
    sbc L9236
    bcs L95E0
    lda L922F
    beq L95DA
    dec L9230
L95DA:
    dec L922F
    jmp L95EB
L95E0:
    sta L9228
    ora L9227
    beq L95FE
    jsr L9243
L95EB:
    sec
    lda L922F
    sbc L9238
    sta L922F
    lda L9230
    sbc L9239
    sta L9230
L95FE:
    rts
L95FF:
    lda L9233
    sta $CB
    sta L9223
    sec
    adc L922A
    sta L9225
    lda L9234
    sta $CC
    sta L9224
    adc #$00
    sta L9226
    sec
    lda L922F
    sbc L9233
    sta L9227
    lda L9230
    sbc L9234
    sta L9228
    bcs L963E
    lda L922F
    bne L9638
    dec L9230
L9638:
    dec L922F
    jmp L9646
L963E:
    ora L9227
    beq L9646
    jsr L9286
L9646:
    sec
    lda L922F
    adc L922A
    sta L922F
    lda L9230
    adc #$00
    sta L9230
    ldy #$00
L965A:
    lda BABUF,Y
    sta ($CB),Y
    iny
    cpy L922A
    bcc L965A
    beq L965A
    rts
L9668:
    lda FNUM
    beq L966F
    jsr L9119
L966F:
    jsr CLRCHN
    rts
L9673:
    lda ST
    sta L9242
    jsr L91B9
    lda #$AB
    ldy #$96
    jsr L9592
    ldx L9242
    lda #$00
    jsr L91CF
    jsr PRNTCR
    rts
    .byte $9B
    jmp $4441
    .byte $53
    jsr $6552
    adc ($64,X)
    adc $9B2E,Y
    brk
    sbc $7953,X
    ror $6174
    sei
    jsr $7245
    .byte $72
    .byte $6F
    .byte $72
    .byte $9B
    brk
    sbc $7245,X
    .byte $72
    .byte $6F
    .byte $72
    jsr $202D
    brk
    .byte $42
    .byte $52
    .byte $4B
    jsr $7266
    .byte $6F
    adc a:$0020
L96BF:
    sta $F2
    inc $F2
    lda #$00
    sta $F3
    lda #$05
    sta $F4
    jsr $D800
    bcs L96D8
    jsr $D9D2
    lda $F2
    sta $D0
    rts
L96D8:
    lda #$00
    sta $D4
    sta $D5
    rts
L96DF:
    jsr L96BF
    lda $D4
    sta L922B
    lda $D5
    sta L922C
    jsr L94E7
    rts
    jsr L96F6
    jmp L9357
L96F6:
    lda ARGPOS
    cmp L922A
    bne L9701
    jmp L948C
L9701:
    jsr L96DF
    lda L9233
    sta L923C
    lda L9234
    sta L923D
    lda L9235
    sta L923A
    lda L9236
    sta L923B
    lda $D0
    cmp L922A
    bne L9737
    lda FOUNDFLAG
    bne L9757
    lda L923A
    sta L9235
    lda L923B
    sta L9236
    jmp L973A
L9737:
    jsr L96DF
L973A:
    lda L923C
    sta $CB
    lda L923D
    sta $CC
    sec
    lda L9235
    sbc $CB
    sta L9227
    lda L9236
    sbc $CC
    sta L9228
    bcs L9758
L9757:
    rts
L9758:
    lda FOUNDFLAG
    bne L9765
    inc L9227
    bne L9765
    inc L9228
L9765:
    jmp L94A5
L9768:
    clc
    lda ARGPOS
    adc #$00
    sta FNAMEPTR
    lda #$00
    adc #$05
    sta $82
    ldy ARGPOS
L9779:
    lda BABUF,Y
    cmp #$9B
    beq L978A
    cmp #$2C
    beq L978A
    iny
    bne L9779
    jmp L942C
L978A:
    tya
    sec
    sbc ARGPOS
    sty ARGPOS
    sta FNAMELEN
    lda #$07
    sta FNUM
    jsr L9119
    lda #$00
    sta FSECOND
    jsr L90DA
    ldx ST
    bmi L97A7
    rts
L97A7:
    pla
    pla
    jsr L9673
    jmp L9357
    lda #$08
    sta FDEV
    jsr L9768
    ldx FNUM
    jsr L910B
    jsr L96F6
    jsr L9668
    jmp L9357
    lda #$04
    sta FDEV
    jsr L9768
    ldx FNUM
    jsr L9108
    jmp L935E
    lda ARGPOS
    cmp L922A
    bne L97DD
    inc RAMFLAG
L97DD:
    jmp START
    lda ARGPOS
    jsr L96BF
    lda $D4
    sta $97F1
    lda $D5
    sta $97F2
    jsr $FFFF
    jmp L9357
    jsr L97FC
    jmp L9357
L97FC:
    lda #$04
    sta FDEV
    jsr L9768
L9803:
    lda FNUM
    jsr L90D4
    lda #$00
    sta $0344,X
    lda #$20
    sta $0345,X
    lda #$00
    sta $0348,X
    lda #$50
    sta $0349,X
    lda #$07
    sta $0342,X
    jsr L9102
    lda FNUM
    jsr L90D4
    clc
    lda $0348,X
    adc #$00
    sta L922F
    lda $0349,X
    adc #$20
    sta L9230
    lda ST
    cmp #$88
    beq L9846
    jsr L9673
    jmp L9357
L9846:
    jsr L9668
    rts
    cli
    lda #$B5
    ldy #$96
    jsr L9592
    pla
    pla
    pla
    sec
    sbc #$02
    tax
    pla
    sbc #$00
    jsr L91CF
    ldx #$FF
    txs
    jsr PRNTCR
    jmp EDIT
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
    .byte $58,$53,$43,$4C,$56,$4E,$4F,$50
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
L9991:
    .byte $00
L9992:
    .byte $00
L9993:
    .byte $00
L9994:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00
BUFFER:
    .byte $00
L99A6:
    .byte $00
L99A7:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00
BUFM:
    .byte $00
L99BA:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00
HEXBUF:
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
L99FD:
    .byte $00
VREND:
    .byte $00
TSTORE:
    .byte $00
L9A00:
    .byte $00,$CE,$EF,$A0,$D3,$F4,$E1,$F2
    .byte $F4,$A0,$C1,$E4,$E4,$F2,$E5,$F3
    .byte $F3,$00,$2D,$2D,$2D,$2D,$2D,$2D
    .byte $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
    .byte $2D,$20,$C2,$F2,$E1,$EE,$E3,$E8
    .byte $A0,$CF,$F5,$F4,$A0,$EF,$E6,$A0
    .byte $D2,$E1,$EE,$E7,$E5,$00,$D5,$EE
    .byte $E4,$E5,$E6,$E9,$EE,$E5,$E4,$A0
    .byte $CC,$E1,$E2,$E5,$EC,$00,$1F,$1F
    .byte $1F,$1F,$1F,$1F,$1F,$1F,$1F,$20
    .byte $CE,$E1,$EB,$E5,$E4,$A0,$EC,$E1
    .byte $E2,$E5,$EC,$00,$1F,$1F,$1F,$1F
    .byte $1F,$20,$BC,$BC,$BC,$BC,$BC,$BC
    .byte $BC,$BC,$A0,$C4,$C9,$D3,$CB,$A0
    .byte $C5,$D2,$D2,$CF,$D2,$A0,$BE,$BE
    .byte $BE,$BE,$BE,$BE,$BE,$BE,$00,$1F
    .byte $1F,$1F,$1F,$1F,$A0,$AD,$AD,$A0
    .byte $C4,$F5,$F0,$EC,$E9,$E3,$E1,$F4
    .byte $E5,$A0,$A0,$CC,$E1,$E2,$E5,$EC
    .byte $A0,$AD,$AD,$A0,$00,$1F,$1F,$1F
    .byte $1F,$1F,$A0,$AD,$AD,$A0,$D3,$F9
    .byte $EE,$F4,$E1,$F8,$A0,$C5,$F2,$F2
    .byte $EF,$F2,$A0,$AD,$AD,$A0,$00
OP:
    .byte $00
