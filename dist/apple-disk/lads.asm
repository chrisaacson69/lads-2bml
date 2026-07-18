; disassembled from lads_apple.bin by dis2src.py -- reassembles byte-exact
.setcpu "6502"
.org $79FD

    jmp L82F5
L7A00:
    lda #$00
    ldy #$32
L7A04:
    sta L8FCE,Y
    dey
    bne L7A04
    lda #$00
    sta $EB
    sta $4C
    sta L8FE4
    lda #$7A
    sta $EC
    sta $4D
    sta L8FE5
    lda #$01
    sta L8FFA
L7A21:
    lda $0400,Y
    cmp #$A0
    beq L7A2F
    sta L8EF3,Y
    iny
    jmp L7A21
L7A2F:
    sta $BEF3,Y
    iny
    lda $0400,Y
    cmp #$A0
    bne L7A21
    dey
    sty $F9
    jsr L80E5
L7A40:
    jsr L8358
    lda #$00
    sta L8FD4
    jsr L840E
    lda L8FE7
    bne L7A8F
    jsr L8950
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
    jsr L8950
    lda L8FDD
    bne L7A7F
    lda #$F1
    sta $FB
    lda #$8D
    sta $FC
    jsr L8381
L7A7F:
    lda L8FD7
    sta $FD
    lda L8FD0,X
    lda L8FDB
    sta $FE
    sta L8FD1
L7A8F:
    jsr L822F
    lda L8FD4
    beq L7A9A
    jmp L7DA1
L7A9A:
    jsr L840E
    lda #$00
    sta L8FDC
    lda L8FE6,X
    ldy L8FE7
    bne L7AAD
    jmp L7AC9
L7AAD:
    sty L8FFB
    lda L8FF9
    beq L7AC1
    jsr L8959
    jsr L890A
    jsr L8932
    jsr L890A
L7AC1:
    lda L8FF2
    beq L7AC9
    jsr L8806
L7AC9:
    jmp L830A
L7ACC:
    lda L8FCF
    beq L7AE8
    cmp #$03
    bne L7B47
    lda #$01
    sta L8FCF
    lda L8DF4
    bne L7B47
    lda #$08
    clc
    adc L8FCE
    lda L8FCE,X
L7AE8:
    jmp L7CB2
L7AEB:
    lda L8FE7
    beq L7B29
    ldy #$FF
L7AF2:
    iny
    lda L8DF1,Y
    beq L7B26
    sta $BEF3,Y
    cmp #$20
    bne L7AF2
    iny
    lda L8DF1,Y
    cmp #$3D
    bne L7B0A
    jmp L7CE2
L7B0A:
    ldx #$00
    stx L8FFB
    txa
    sta L8EF3,Y
L7B13:
    lda L8DF1,Y
    beq L7B20
    sta L8DF1,X
    inx
    iny
    jmp L7B13
L7B20:
    sta L8DF1,X
    jmp L7AC9
L7B26:
    jsr L7F78
L7B29:
    jsr L7F1A
    jmp L7AC9
L7B2F:
    lda L8E38
    cmp #$40
    bcs L7B3C
    lda L8E39
    inc L8FE6
L7B3C:
    eor #$80
    sta L8FD5
    jsr L7FBC
    jmp L7BBE
L7B47:
    ldy #$00
    sty L8FDC
    lda L8DF5,Y
    cmp #$41
    bcc L7B56
    inc L8FDC
L7B56:
    sta L8E38,Y
    .byte $CB
    lda L8DF5,Y
    beq L7B75
    sta L8E38,Y
    cmp #$41
    bcc L7B69
    inc L8FDC
L7B69:
    iny
    lda L8DF5,Y
    beq L7B75
    sta L8E38,Y
    jmp L7B69
L7B75:
    dey
    sty L8FDB
    lda L8FDD
    bne L7BBE
    lda L8FDC
    bne L7B2F
    lda #$38
    sta $FB
    lda #$8E
    sta $FC
    ldy #$00
    lda $BE38
    cmp #$30
    bcs L7B9B
    clc
    inc $FB
    bcc L7B9B
    inc $FC
L7B9B:
    lda ($FB),Y
    beq L7BAF
    cmp #$29
    beq L7BAF
    cmp #$2C
    beq L7BAF
    cmp #$20
    beq L7BAF
    iny
    jmp L7B9B
L7BAF:
    pha
    tya
    pha
    lda #$00
    sta ($FB),Y
    jsr L8381
    pla
    .byte $AB
    pla
    sta ($FB),Y
L7BBE:
    lda L8E38
    cmp #$23
    beq L7C04
    cmp #$28
    beq L7BE0
    lda L8FCF
    cmp #$08
    beq L7C07
    cmp #$03
    bne L7C45
    lda #$08
    clc
    adc L8FCE
    sta L8FCE
    jmp L7CB2
L7BE0:
    ldy L8FDB
    lda $BE38,Y
    cmp #$29
    beq L7BFA
    lda L8FCF
    cmp #$01
    bne L7BFA
    lda #$10
    clc
    adc L8FCE
    lda L8FCE,X
L7BFA:
    lda L8FCF
    cmp #$06
    beq L7C54
    jmp L7C77
L7C04:
    jmp L7C92
L7C07:
    lda L8FE7
    bne L7C0F
    jmp L7C77
L7C0F:
    sec
    lda $0FD7
    sbc $FD
    pha
    lda $0FD8
    sbc $FE
    bcs L7C2B
    cmp #$FF
    beq L7C25
    pla
    jmp L7F00
L7C25:
    pla
    bpl L7C34
    jmp L7C37
L7C2B:
    beq L7C31
    pla
    jmp L7F00
L7C31:
    pla
    bpl L7C37
L7C34:
    jmp L7F00
L7C37:
    sec
    sbc #$02
    lda L8FD7,X
    lda #$00
    sta L8FD8
    jmp L7C77
L7C45:
    ldy $0FDB
    dey
    lda L8E38,Y
    cmp #$2C
    bne L7C54
    iny
    jmp L7DFC
L7C54:
    lda L8FCE
    cmp #$4C
    bne L7C5E
    jmp L7C80
L7C5E:
    lda L8FD8
    bne L7CB8
    lda L8FCF
    cmp #$06
    bcs L7C77
    cmp #$02
    beq L7C77
    lda #$04
    clc
    adc L8FCE
    lda $0FCE,X
L7C77:
    jsr L884D
    jsr L8873
    jmp L7CE2
L7C80:
    ldy L8FDB
    lda L8E38,Y
    cmp #$29
    bne L7C8F
    lda #$6C
    lda L8FCE,X
L7C8F:
    jmp L7CDC
L7C92:
    lda L8E39
    cmp #$22
    bne L7C9F
    lda $BE3A
    sta L8FD7
L7C9F:
    lda L8FCF
    cmp #$01
    bne L7C77
    lda #$08
    clc
    adc L8FCE
    lda L8FCE,X
    jmp L7C77
L7CB2:
    jsr L884D
    jmp L7CE2
L7CB8:
    lda L8FCF
    cmp #$02
    beq L7CC3
    cmp #$07
    bne L7CCF
L7CC3:
    lda L8FCE
    clc
    adc #$08
    sta L8FCE
    jmp L7CDC
L7CCF:
    cmp #$06
    bcs L7CDC
    lda L8FCE
    clc
    adc #$0C
    sta L8FCE
L7CDC:
    jsr L884D
    jsr L88BD
L7CE2:
    lda L8FE7
    bne L7CEA
    jmp L7D9E
L7CEA:
    lda L8FF9
    bne L7CF2
    jmp L7D9E
L7CF2:
    lda $0FFB
    bne L7D35
    lda L8FF5
    beq L7D26
    lda #$14
    sec
    sbc $24
    lda L8FEB,X
    jsr L821C
    ldx #$04
    jsr L81A6
    ldy L8FE8
    bpl L7D16
    ldy #$02
    jmp L7D18
L7D16:
    lda #$20
L7D18:
    jsr L81D6
    dey
    bne L7D18
    jsr L821C
    ldx #$01
    jsr $61A2
L7D26:
    lda #$14
    sta $24
    lda #$F3
    sta $FB
    lda #$8E
    sta $FC
    jsr L88F9
L7D35:
    lda #$1E
    sec
    sbc $24
    sta $0FE9
    lda #$1E
    sta $24
    lda L8FF5
    beq L7D65
    jsr L821C
    ldx #$04
    jsr L81A6
    ldy L8FE9
    beq L7D5D
    bmi L7D5D
    lda #$20
L7D57:
    jsr L81D6
    dey
    bne L7D57
L7D5D:
    jsr L821C
    ldx #$01
    jsr L81A2
L7D65:
    jsr L8966
    lda L8FF3
    beq L7D7E
    cmp #$01
    bne L7D76
    lda #$3C
    jmp L7D78
L7D76:
    lda #$3E
L7D78:
    jsr L81D6
    jsr L898B
L7D7E:
    lda L8FFC
    beq L7D96
    jsr L890A
    lda #$3B
    jsr L81D6
    lda #$00
    sta $FB
    lda #$02
    sta $FC
    jsr L88F9
L7D96:
    jsr L8950
    lda L8FD4
    bne L7DA1
L7D9E:
    jmp L7A8F
L7DA1:
    lda L8FE7
    bne L7DD2
    inc L8FE7
    sec
    lda $FD
    sbc L8FD0
    sta L8FFD
    lda $FE
    sbc L8FD1
    lda L8FFE,X
    lda L8FD0
    sta $FD
    lda L8FD1
    sta $FE
    jsr L821C
    lda #$01
    jsr L8235
    jsr L80E5
    jmp L7A40
L7DD2:
    jsr L821C
    lda #$01
    jsr L8235
    lda #$02
    jsr L8235
    lda L8FF5
    beq L7DF9
    jsr L821C
    ldx #$04
    jsr L81A6
    lda #$0D
    jsr L81D6
    jsr L821C
    lda #$04
    jsr L8235
L7DF9:
    jmp $03D0
L7DFC:
    lda $BE38,Y
    cmp #$58
    beq L7E65
    dey
    dey
    lda L8E38,Y
    cmp #$29
    bne L7E0F
    jmp L7BE0
L7E0F:
    lda L8FDB
    bne L7E23
    lda L8FCF
    cmp #$02
    beq L7E6A
    cmp #$05
    beq L7E6A
    cmp #$01
    beq L7E9A
L7E23:
    lda L8FCF
    cmp #$01
    bne L7E36
    lda L8FCE
    clc
    adc #$18
    sta L8FCE
    jmp L7CDC
L7E36:
    lda L8FCF
    cmp #$05
    beq L7E45
    lda #$31
    jsr L7ED0
    jmp L7E51
L7E45:
    lda L8FCE
    clc
    adc #$1C
    sta L8FCE
    jmp L7CDC
L7E51:
    jsr L8972
    jsr L8959
    lda #$B4
    sta $FB
    lda #$8F
    sta $FC
    jsr $B8F9
    jmp L7CE2
L7E65:
    lda L8FD8
    bne L7E9D
L7E6A:
    lda L8FCF
    cmp #$02
    bne L7E7D
    lda #$10
    clc
    adc L8FCE
    sta L8FCE
    jmp L7C77
L7E7D:
    cmp #$01
    beq L7E91
    cmp #$03
    beq L7E91
    cmp #$05
    beq L7E91
    lda #$32
    jsr L7ED0
    jmp L7E51
L7E91:
    lda #$14
    clc
    adc L8FCE
    lda L8FCE,X
L7E9A:
    jmp L7C77
L7E9D:
    lda L8FCF
    cmp #$02
    bne L7EB0
    lda #$18
    clc
    adc L8FCE
    sta L8FCE
    jmp L7CDC
L7EB0:
    cmp #$01
    beq L7EC4
    cmp #$03
    beq L7EC4
    cmp #$05
    beq L7EC4
    lda #$33
    jsr L7ED0
    jmp L7E51
L7EC4:
    lda #$1C
    clc
    adc L8FCE
    lda L8FCE,X
    jmp L7CDC
L7ED0:
    sta L8FEB
    sty L8FEA
    stx L8FE9
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
    jsr $ED24
    lda L8FE8
    ldy L8FEA
    ldx L8FE9
    rts
L7EF4:
    ldy #$00
    tya
L7EF7:
    sta L8DF1,Y
    iny
    cpy #$FF
    bne L7EF7
    rts
L7F00:
    jsr L8950
    jsr L8972
    jsr L8959
    lda #$23
    sta $FB
    lda #$8F
    sta $FC
    jsr L88F9
    jsr L8950
    jmp L7C77
L7F1A:
    ldy #$FF
L7F1C:
    iny
    lda L8DF1,Y
    beq L7F78
    cmp #$20
    bne L7F1C
    iny
    iny
    sty L8FE1
    sec
    lda $EB
    sbc L8FE1
    sta $EB
    lda $EC
    sbc #$00
    sta $EC
    ldy #$00
    lda L8DF1,Y
    eor #$80
    sta ($EB),Y
L7F42:
    .byte $CB
    lda L8DF1,Y
    cmp #$20
    beq L7F4F
    sta ($EB),Y
    jmp L7F42
L7F4F:
    iny
    lda L8DF1,Y
    cmp #$3D
    beq L7F89
    dey
    lda $FD
    sta ($EB),Y
    iny
    lda $FE
    sta ($EB),Y
    ldx L8FE1
    dex
    ldy #$00
L7F67:
    lda L8DF1,X
    beq L7F74
    sta L8DF1,Y
    inx
    .byte $CB
    jmp L7F67
L7F74:
    sta L8DF1,Y
    rts
L7F78:
    jsr L8972
    lda #$5C
    sta $FB
    lda #$8F
    sta $FC
    jsr L88F9
    jmp L7FB7
L7F89:
    dey
    sty L8FE2
    lda L8FDD
    bne L7FA9
    iny
    iny
    iny
    sty L8FD6
    lda #$F1
    clc
    adc L8FD6
    sta $FB
    lda #$8D
    adc #$00
    sta $FC
    jsr L8381
L7FA9:
    ldy L8FE2
    lda L8FD7
    sta ($EB),Y
    lda L8FD8
    iny
    sta ($EB),Y
L7FB7:
    pla
    pla
    jmp L7CE2
L7FBC:
    lda L8FE4
    sta $ED
    lda L8FE5
    sta $EE
    jsr L80CA
    lda #$FF
    sta L8FF8
L7FCE:
    sec
    lda $EB
    sbc $ED
    lda $EC
    sbc $EE
    bcs L803C
    ldx #$00
    sec
    lda $ED
    sbc #$02
    sta $ED
    lda $EE
    sbc #$00
    sta $EE
    ldy #$00
L7FEA:
    lda ($ED),Y
    bmi L7FFA
    lda $ED
    bne L7FF4
    dec $EE
L7FF4:
    dec $ED
    inx
    jmp L7FEA
L7FFA:
    lda $ED
    lda L8FEB,X
    lda $EE
    sta L8FEC
    lda ($ED),Y
    cmp L8FD5
    beq L800E
    jmp L802C
L800E:
    inx
    stx L8FD6
    ldx #$01
    lda L8FE6
    beq L801D
    iny
    jsr L80CA
L801D:
    iny
    lda $BE38,Y
    beq L8076
    cmp #$30
    bcc L8076
    inx
    cmp ($ED),Y
    beq L801D
L802C:
    lda L8FEB
    sta $ED
    lda L8FEC
    sta $EE
    jsr L80CA
    jmp L7FCE
L803C:
    lda L8FF8
    bmi L8042
    rts
L8042:
    lda L8FE7
    bne L8049
    beq L8060
L8049:
    jsr L8972
    jsr L8959
    jsr L890A
    lda #$4C
    sta $FB
    lda #$8F
    sta $FC
    jsr L88F9
    jsr L8950
L8060:
    pla
    pla
    lda L8FCE
    and #$1F
    cmp #$10
    beq L8073
    lda L8FF3
    bne L8073
    jmp L7CDC
L8073:
    jmp L7C77
L8076:
    cpx L8FD6
    beq L807E
    jmp L802C
L807E:
    inc L8FF8
    beq L8086
    jsr L80D3
L8086:
    ldy L8FD6
    lda L8FE6
    beq L808F
    iny
L808F:
    lda ($ED),Y
    sta L8FD7
    iny
    lda ($ED),Y
    sta L8FDB
    lda L8FF3
    beq L80A9
    cmp #$02
    bne L80C1
    lda L8FD8
    lda L8FD7,X
L80A9:
    lda L8FF2
    beq L80C1
    clc
    lda L8FF0
    adc L8FD7
    sta L8FD7
    lda L8FF1
    adc L8FD8
    sta L8FDB
L80C1:
    lda L8FE7
    beq L80C7
    rts
L80C7:
    jmp L802C
L80CA:
    lda $ED
    bne L80D0
    dec $EE
L80D0:
    dec $ED
    rts
L80D3:
    jsr L8972
    lda #$96
    sta $FB
    lda #$8F
    sta $FC
    jsr L88F9
    jsr L8950
    rts
L80E5:
    jsr L821C
    lda #$01
    jsr L8235
    lda #$01
    sta $2C
    lda #$90
    sta $2D
    jsr L815F
    inc L8FFF
    rts
L80FC:
    lda #$13
    sta $2C
    lda #$90
    sta $2D
    jsr L815F
    inc L9000
    rts
L810B:
    rts
L810C:
    lda #$25
    sta $2C
    lda #$90
    sta $2D
    jsr L818A
    jsr $03DC
    sta $2B
    sty $2A
    ldy #$08
    lda ($2A),Y
    rts
L8123:
    sta L903F
    lda #$37
    sta $2C
    lda #$90
    sta $2D
    jsr L818A
    rts
L8132:
    lda L8FFF
    beq L815E
    lda #$49
    sta $2C
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
    sta $2C
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
    lda ($2C),Y
    sta $2A
    iny
    lda ($2C),Y
    sta $2B
    lda #$F3
    sta $FB
    lda #$8E
    sta $FC
    ldy #$00
    lda #$A0
L8176:
    sta ($2A),Y
    iny
    cpy #$1F
    bne L8176
    ldy #$00
L817F:
    lda ($FB),Y
    ora #$60
    sta ($2A),Y
    iny
    cpy $F9
    bne L817F
L818A:
    jsr $03DC
    sta $2B
    sty $2A
    ldy #$00
L8193:
    lda ($2C),Y
    sta ($2A),Y
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
    stx L8FE9
    lda L906D
    cmp #$01
    bne L81D2
    jsr L810C
    php
    ldy L9070
    ldx L8FE9
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
    sta $C090
L81F8:
    lda $C1C1
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
    jsr $FDF0
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
    inc $B8
    jmp L8257
L8262:
    cmp #$2F
    bcc L826A
    cmp #$3A
    bcc L82BD
L826A:
    lda $0200
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
    sta $0400,Y
    iny
    jmp L8288
L8298:
    lda #$A0
    sta $0400,Y
    sta $0401,Y
    sta $0402,Y
    pla
    pla
    jmp L7A00
L82A8:
    lda L906F
    cmp #$3A
    bcs L82BC
    cmp #$20
    bne L82B6
    jmp a:$00B1
L82B6:
    sec
    sbc #$30
    sec
    sbc #$D0
L82BC:
    rts
L82BD:
    ldx $AF
    stx $69
    ldx $B0
    stx $6A
    clc
    jsr $DA0C
    jsr L82D1
    pla
    pla
    jmp $D46A
L82D1:
    ldy #$00
    sty $94
    lda #$02
    sta $95
L82D9:
    lda ($BB),Y
    sta ($94),Y
    iny
    cmp #$00
    bne L82D9
    dey
L82E3:
    dey
    lda ($94),Y
    cmp #$20
    beq L82E3
    iny
    lda #$00
    sta ($94),Y
    iny
    iny
    .byte $CB
    iny
    iny
    rts
L82F5:
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
L830A:
    ldy #$00
    ldx #$FF
L830E:
    inx
    lda L8CC9,Y
    cmp L8DF1
    beq L8321
    iny
    iny
    iny
    cpx #$39
    bne L830E
L831E:
    jmp L7AEB
L8321:
    iny
    lda L8CC9,Y
    cmp L8DF2
    beq L8330
    .byte $CB
    .byte $CB
    bne L830E
    beq L831E
L8330:
    iny
    lda L8CC9,Y
    cmp L8DF3
    beq L833E
    iny
    bne L830E
    beq L831E
L833E:
    lda L8DF4
    cmp #$20
    beq L8349
    cmp #$00
    bne L831E
L8349:
    lda L8D71,X
    sta L8FCF
    ldy L8DA9,X
    ldy L8FCE,X
    jmp L7ACC
L8358:
    ldx #$01
    jsr L81A2
    ldx #$06
L835F:
    stx L8FE9
    jsr L81B9
    ldx L8FE9
    dex
    bne L835F
    jsr L81B9
    cmp #$2A
    beq L8380
    lda #$12
    sta $FB
    lda #$8F
    sta $FC
    jsr L88F9
    jmp L7DD2
L8380:
    rts
L8381:
    ldy #$00
L8383:
    lda ($FB),Y
    beq L838B
    iny
    jmp L8383
L838B:
    sty L8F0F
    dey
    lda #$00
    sta L8FD7
    lda L8FD8,X
    ldx #$01
    ldx L8FE9,Y
L839C:
    lda ($FB),Y
    and #$0F
    sta L8F0D
    sta L8F10
    lda #$00
    sta L8F0E
    sta L8F11
L83AE:
    dex
    beq L83C3
    jsr L83D3
    lda L8F0D
    sta L8F10
    lda L8F0E
    lda L8F11,X
    jmp L83AE
L83C3:
    inc L8FE9
    ldx L8FE9
    jsr L83FA
    dey
    dec L8F0F
    bne L839C
    rts
L83D3:
    clc
    asl L8F0D
    rol L8F0E
    asl L8F0D
    rol L8F0E
    clc
    lda L8F10
    adc L8F0D
    sta L8F0D
    lda L8F11
    adc L8F0E
    sta L8F0E
    asl L8F0D
    rol L8F0E
    rts
L83FA:
    clc
    lda L8F0D
    adc L8FD7
    lda L8FD7,X
    lda L8F0E
    adc L8FD8
    sta L8FD8
    rts
L840E:
    jsr L7EF4
    ldy #$00
    sty L8FDD
    ldy L8FFC,X
    ldy L8FF3,X
    sty L8FF2
    lda L8FF7
    bne L8430
    jsr L81B9
    sta L8FD2
    jsr L81B9
    sta L8FD3
L8430:
    jsr L81B9
    cmp #$20
    bne L843F
    jsr L85B2
    pla
    pla
    jmp L7A8F
L843F:
    cmp #$20
    jmp L844C
L8444:
    jsr L81B9
L8447:
    bne L844C
    jmp L85B2
L844C:
    cmp #$3A
    bne L8453
    jmp L84F6
L8453:
    cmp #$3B
    bne L84CA
    sty L8FEB
    lda L8FF5
    beq L84B4
    sta L8FFC
    lda L8FE8
    beq L846D
    jsr L8494
    jmp L84BC
L846D:
    jsr L81B9
    beq L8480
    cmp #$7F
    bcc L8479
    jsr L8504
L8479:
    sta L8DF1,Y
    iny
    jmp L846D
L8480:
    jsr L8959
    jsr L890A
    jsr L8966
    jsr L8950
    lda #$00
    sta L8FE8
    jmp L84BC
L8494:
    sta L8FFC
    sta L8FE8
    ldy #$00
L849C:
    jsr L81B9
    bne L84A8
    sta $0200,Y
    ldy L8FE8
    rts
L84A8:
    bpl L84AD
    jsr L87E1
L84AD:
    sta $0200,Y
    .byte $CB
    jmp L849C
L84B4:
    jsr L81B9
    beq L84BC
    jmp L84B4
L84BC:
    jsr L85B2
    lda L8FE8
    bne L84C9
    pla
    pla
    jmp L7A8F
L84C9:
    rts
L84CA:
    cmp #$3E
    beq L8529
    cmp #$3C
    beq L8531
    cmp #$2B
    bne L84D9
    inc L8FF2
L84D9:
    cmp #$2A
    bne L84E0
    jmp L8539
L84E0:
    cmp #$2E
    beq L84FA
    cmp #$24
    beq L84FD
    cmp #$7F
    bcc L84EF
    jsr L8504
L84EF:
    sta L8DF1,Y
    .byte $CB
    jmp L8444
L84F6:
    sta L8FF7
    rts
L84FA:
    jmp L8656
L84FD:
    sta L8DF1,Y
    .byte $CB
    jmp L85D1
L8504:
    sec
    sbc #$7F
    sta L8FE0
    ldx #$FF
L850C:
    dec L8FE0
    beq L8519
L8511:
    inx
    lda $D0D0,X
    bpl L8511
    bmi L850C
L8519:
    .byte $EB
    lda $D0D0,X
    bmi L8526
    sta L8DF1,Y
    iny
    jmp L8519
L8526:
    and #$7F
    rts
L8529:
    lda #$02
    sta L8FF0
    jmp L8444
L8531:
    lda #$01
    sta L8FF3
    jmp L8444
L8539:
    lda L8FF3
    beq L855E
    lda #$2A
    sta L8DF1,Y
    iny
    inc L8FDD
    lda L8FF3
    cmp #$01
    beq L8556
    lda $FE
    sta L8FD7
    jmp L8444
L8556:
    lda $FD
    sta L8FD7
    jmp L8444
L855E:
    jsr L8444
    lda L8FE7
    beq L8571
    lda #$2A
    jsr L81D6
    jsr L8966
    jsr L8950
L8571:
    lda L8FDD
    bne L8596
    ldy #$00
L8578:
    lda L8DF1,Y
    cmp #$20
    beq L8583
    iny
    jmp L8578
L8583:
    iny
    sty $FB
    lda #$F1
    clc
    adc $FB
    sta $FB
    lda #$8D
    adc #$00
    sta $FC
    jsr L8381
L8596:
    lda L8FE7
    beq L85A3
    lda L8FF4
    beq L85A3
    jsr L87A0
L85A3:
    lda L8FD7
    sta $FD
    lda L8FD8
    sta $FE
    pla
    pla
    jmp L7A8F
L85B2:
    sta L8DF1,Y
    .byte $CB
    cpy #$FF
    bne L85B2
    sta L8DF1,Y
    jsr L81B9
    jsr L81B9
    beq L85CB
    lda #$00
    sta L8FF7
    rts
L85CB:
    lda #$01
    sta L8FD4
    rts
L85D1:
    ldx #$00
L85D3:
    jsr L81B9
    beq L8604
    cmp #$3A
    beq L8604
    cmp #$20
    beq L85D3
    cmp #$3B
    beq L8604
    cmp #$2C
    beq L85F7
    cmp #$29
    beq L85F7
    sta $BEDE,X
    .byte $EB
    sta L8DF1,Y
    iny
    jmp L85D3
L85F7:
    stx L8FDE
    sta L8DF1,Y
    iny
    jsr L8618
    jmp L8444
L8604:
    sta L8FEB
    lda #$00
    ldx L8FDE,Y
    sta L8DF1,Y
    jsr L8618
    lda L8FE8
    jmp L8447
L8618:
    lda #$00
    sta $3FD7
    sta L8FD8
    tax
L8621:
    asl L8FD7
    rol L8FD8
    asl L8FD7
    rol L8FDB
    asl L8FD7
    rol L8FD8
    asl L8FD7
    rol L8FD8
    lda $BEDE,X
    cmp #$41
    bcc L8642
    sbc #$07
L8642:
    and #$0F
    ora L8FD7
    sta L8FD7
    inx
    cpx L8FDE
    bne L8621
    inc L8FDD
    lda #$01
    rts
L8656:
    cpy #$00
    beq L8668
    ldx L8FE7
    bne L8668
    pha
    tya
    pha
    jsr L7F1A
    pla
    tay
    pla
L8668:
    sta L8DF1,Y
    iny
    jsr L81B9
    sta L8DF1,Y
    iny
    cmp #$42
    bne L86DF
    lda #$00
    sta L8FED
    lda L8FE7
    beq L8698
    sty L8FEA
    lda L8FF9
    beq L8698
    jsr L8959
    jsr $690A
    jsr L8932
    jsr L890A
    ldy $0FEA
L8698:
    jsr $61B9
    sta L8DF1,Y
    iny
    cmp #$20
    bne L8698
    jsr L81B9
    sta L8DF1,Y
    iny
    cmp #$22
    bne L86F3
L86AE:
    jsr L81B9
    bne L86B6
    jmp L8785
L86B6:
    cmp #$3A
    bne L86BD
    jmp L8788
L86BD:
    cmp #$3B
    bne L86CD
    jsr L8494
    ldx L8FF5
    ldx L8FFC,Y
    jmp L8785
L86CD:
    cmp #$22
    bne L86D4
    jmp L86AE
L86D4:
    ldx L8FE7
    bne L86E2
    jsr L88EB
    jmp L86AE
L86DF:
    jmp L8A56
L86E2:
    sta $BDF1,Y
    tax
    ldy L8FEA,X
    jsr L88C3
    ldy L8FEA
    iny
    jmp L86AE
L86F3:
    ldx #$00
    ldx L8FEE,Y
    sta L8F06,X
    inx
L86FC:
    lda L8FEE
    bne L8776
    jsr L81B9
    beq L8749
    cmp #$3A
    beq L8749
    cmp #$3B
    bne L871A
    jsr L8494
    ldx L8FF5
    ldx L8FFC,Y
    jmp L8749
L871A:
    sta L8E80
    lda $0FE7
    bne L872F
    lda $BE80
    cmp #$20
    bne L86FC
    jsr L88EB
    jmp L86FC
L872F:
    lda L8E80
    sta L8DF1,Y
    iny
    cmp #$20
    beq L8752
    cmp #$00
    beq L8752
    cmp #$3A
    beq L8752
    sta L8F06,X
    inx
    jmp L86FC
L8749:
    inc L8FEE
    sta $BE81
    jmp L871A
L8752:
    lda #$06
    sta $FB
    lda #$8F
    sta $FC
    sty $0FEA
    jsr L8381
    ldx L8FD7
    jsr L88C3
    ldy L8FEA
    lda #$00
    ldx #$05
L876D:
    sta L8F06,X
    dex
    bne L876D
    jmp L86FC
L8776:
    lda $0FE7
    bne L877E
    jsr L88EB
L877E:
    lda L8E81
    cmp #$3A
    beq L8788
L8785:
    jsr L85B2
L8788:
    sta L8FF7
    inc L8FFB
    pla
    pla
    lda L8FE7
    beq L879D
    lda L8FF9
    beq L879D
    jmp L7D65
L879D:
    jmp L7A8F
L87A0:
    lda L8FE7
    cmp #$02
    bne L87A8
    rts
L87A8:
    jsr L821C
    ldx #$02
    jsr L81A6
    sec
    lda L8FD7
    sbc $FD
    lda L8FD5,X
    lda L8FD8
    sbc $FE
    sta L8FD6
L87C1:
    lda #$00
    jsr L81D6
    lda L8FD5
    bne L87CE
    dec L8FD6
L87CE:
    dec L8FD5
    bne L87C1
    lda L8FD6
    bne L87C1
    jsr L821C
    ldx #$01
    jsr L81A2
    rts
L87E1:
    sec
    sbc #$7F
    sta L8FE0
    ldx #$FF
L87E9:
    dec L8FE0
    beq L87F6
L87EE:
    inx
    lda $D0D0,X
    bpl L87EE
    bmi L87E9
L87F6:
    .byte $EB
    lda $D0D0,X
    bmi L8803
    sta $0200,Y
    iny
    jmp $67F6
L8803:
    and #$7F
    rts
L8806:
    ldy #$00
    ldx #$00
L880A:
    lda L8DF1,Y
    cmp #$2B
    beq L8815
    iny
    jmp L880A
L8815:
    iny
    lda L8DF1,Y
    jsr L8825
    .byte $80
    .byte $12
    sta L8EDE,X
    .byte $EB
    jmp L8815
L8825:
    cmp #$3A
    bcs L882F
    sec
    sbc #$30
    sec
    sbc #$D0
L882F:
    rts
    lda #$00
    sta $BEDE,X
    lda #$DE
    sta $FB
    lda #$8E
    sta $FC
    jsr L8381
    lda L8FD7
    sta L8FF0
    lda L8FD8
    sta L8FF1
    rts
L884D:
    lda L8FE7
    bne L8856
    jsr L88EB
    rts
L8856:
    lda L8FF9
    beq L886C
    jsr L821C
    ldx #$01
    jsr L81A2
    ldx L8FCE
    jsr L8913
    jsr L890A
L886C:
    ldx L8FCE
    jsr L88C3
    rts
L8873:
    lda L8FE7
    bne L887C
    jsr L88EB
    rts
L887C:
    lda L8FF9
    beq L8887
    ldx L8FD7
    jsr L8913
L8887:
    ldx L8FD7
    jmp L88C3
    lda L8FE7
    bne L8899
    jsr L88EB
    jsr L88EB
    rts
L8899:
    lda L8FF9
    beq L88A4
    ldx L8FD7
    jsr L8913
L88A4:
    ldx L8FD7
    jsr L88C3
    lda L8FF9
    beq L88BD
    lda L8FFA
    beq L88B7
    jsr L890A
L88B7:
    ldx L8FD8
    jsr L8913
L88BD:
    ldx L8FD8
    jmp L88C3
L88C3:
    stx L8FD6
    lda L8FF6
    beq L88D0
    ldy #$00
    txa
    sta ($FD),Y
L88D0:
    lda L8FF4
    beq L88EB
    jsr L821C
    ldx #$02
    jsr L81A6
    lda L8FD6
    jsr L81D6
    jsr L821C
    ldx #$01
    jsr L81A2
L88EB:
    clc
    lda #$01
    adc $FD
    sta $FD
    lda #$00
    adc $FE
    sta $FE
    rts
L88F9:
    ldy #$00
L88FB:
    lda ($FB),Y
    beq L8909
    jsr L81D6
    jsr L8985
    iny
    jmp L88FB
L8909:
    rts
L890A:
    lda #$20
    jsr L81D6
    jsr L8985
    rts
L8913:
    stx L8FE9
    lda L8FFA
    beq L8926
    tsx
    jsr L8A3D
    jsr L89AE
    ldx L8FE9
    rts
L8926:
    lda #$00
    jsr $ED24
    jsr L89AE
    ldx L8FE9
    rts
L8932:
    lda L8FFA
    beq L8945
    lda $FE
    jsr L8A3D
    lda $FD
    jsr L8A3D
    jsr L89E1
    rts
L8945:
    ldx $FD
    lda $FE
    jsr $ED24
    jsr L89E1
    rts
L8950:
    lda #$0D
    jsr L81D6
    jsr L8985
    rts
L8959:
    ldx L8FD2
    lda L8FD3
    jsr $ED24
    jsr L8A17
    rts
L8966:
    lda #$F1
    sta $FB
    lda #$8D
    sta $FC
    jsr L88F9
    rts
L8972:
    lda #$07
    jsr L81D6
    lda #$12
    jsr L81D6
    jsr L8966
    lda #$0D
    jsr L81D6
    rts
L8985:
    ldx L8FE7
    bne L898B
    rts
L898B:
    ldx L8FF5
    bne L8991
    rts
L8991:
    sta L8FEB
    jsr L821C
    ldx #$04
    jsr L81A6
    lda L8FE8
    jsr L81D6
    jsr L821C
    ldx #$01
    jsr L81A2
    lda L8FE8
    rts
L89AE:
    ldx L8FE7
    bne L89B4
    rts
L89B4:
    ldx L8FF5
    bne L89BA
    rts
L89BA:
    jsr $B21C
    ldx #$04
    jsr L81A6
    lda L8FFA
    beq L89D0
    lda L8FE9
    jsr L8A3D
    jmp L89D8
L89D0:
    lda #$00
    ldx L8FE9
    jsr $ED24
L89D8:
    jsr L821C
    ldx #$01
    jsr L81A2
    rts
L89E1:
    ldx L8FE7
    bne L89E7
    rts
L89E7:
    ldx L8FF5
    bne L89ED
    rts
L89ED:
    jsr L821C
    ldx #$04
    jsr L81A6
    ldx L8FFA
    beq L8A07
    lda $FE
    jsr $BA3D
    lda $FD
    jsr $BA3D
    jmp L8A0E
L8A07:
    lda $FE
    ldx $FD
    jsr $ED24
L8A0E:
    jsr L821C
    ldx #$01
    jsr L81A2
    rts
L8A17:
    ldx L8FE7
    bne L8A1D
    rts
L8A1D:
    ldx L8FF5
    bne L8A23
    rts
L8A23:
    jsr L821C
    ldx #$04
    jsr L81A6
    lda L8FD3
    ldx L8FD2
    jsr $ED24
    jsr L821C
    ldx #$01
    jsr $61A2
    rts
L8A3D:
    pha
    and #$0F
    tay
    lda L8DE1,Y
    tax
    pla
    lsr A
    lsr A
    lsr A
    lsr A
    tay
    lda L8DE1,Y
    jsr L81D6
    txa
    jsr L81D6
    rts
L8A56:
    cmp #$46
    bne L8A62
    jsr L8AB9
L8A5D:
    pla
    pla
    jmp L7A8F
L8A62:
    cmp #$45
    bne L8A6C
    jsr L8B12
    jmp L8A5D
L8A6C:
    cmp #$44
    bne L8A73
    jmp L8B5B
L8A73:
    cmp #$50
    bne L8A7A
    jmp L8BC1
L8A7A:
    cmp #$4E
    bne L8A81
    jmp L8C02
L8A81:
    cmp #$4F
    bne L8A88
    jmp L8BED
L8A88:
    cmp #$53
    bne L8A8F
    jmp $BC9A
L8A8F:
    cmp #$48
    bne L8A96
    jmp L8CB4
L8A96:
    sta L8DF1,Y
    jsr L8959
    jsr L890A
    jsr L8932
    jsr L8972
    jsr L8966
    lda #$B4
    sta $FB
    lda #$8F
    sta $FC
    jsr L88F9
    jsr L8950
    jmp $BBD4
L8AB9:
    jsr L81B9
    cmp #$20
    beq L8AC3
    jmp $BAB9
L8AC3:
    ldy #$00
L8AC5:
    jsr L81B9
    cmp #$00
    beq L8ADA
    cmp #$7F
    bcc L8AD3
    jsr L8504
L8AD3:
    sta L8DF1,Y
    iny
    jmp L8AC5
L8ADA:
    sty $F9
    ldy #$00
L8ADE:
    lda L8DF1,Y
    beq L8AEA
    sta L8EF3,Y
    iny
    jmp L8ADE
L8AEA:
    lda L8FE7
    bne L8AF5
    jsr L8932
    jsr L890A
L8AF5:
    jsr L8966
    jsr L8950
    jsr L80E5
    ldx #$01
    jsr L81A2
    jsr L81B9
    jsr L81B9
    jsr L85B2
    ldx #$00
    ldx L8FD4,Y
    rts
L8B12:
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
    jsr L8AB9
    lda L8FE7
    beq L8B39
    inc L8FD4
L8B39:
    inc L8FE7
    sec
    lda $FD
    sbc L8FD0
    lda L8FFD,X
    lda $FE
    sbc L8FD1
    sta L8FFE
    lda L8FD0
    sta $FD
    lda L8FD1
    sta $FE
    jsr L840E
    rts
L8B5B:
    lda L8FE7
    beq L8B7E
    jsr L81B9
    sta L8DF1,Y
    ldy #$00
L8B68:
    jsr L81B9
    beq L8B81
    cmp #$7F
    bcc L8B74
    jsr L8504
L8B74:
    sta L8DF1,Y
    sta L8EF3,Y
    iny
    jmp L8B68
L8B7E:
    jmp L8BD4
L8B81:
    sty $F9
    jsr L8966
    jsr L8950
    inc L8FF4
    jsr L80FC
    ldx #$02
    jsr L81A6
    lda L8FD0
    jsr L81D6
    lda L8FD1
    jsr L81D6
    lda L8FFD
    jsr L81D6
    lda L8FFE
    jsr L81D6
    jsr L821C
    ldx #$01
    jsr L81A2
    jsr L85B2
    pla
    pla
    ldx #$00
    stx L8FD4
    jmp L7A8F
L8BC1:
    lda L8FE7
    beq L8BD4
    jsr L810B
    inc L8FF5
    jsr L821C
    ldx #$01
    jsr L81A2
L8BD4:
    jsr L81B9
    beq L8BE0
    cmp #$3A
    beq L8BE3
    jmp L8BD4
L8BE0:
    jsr L85B2
L8BE3:
    pla
    ror $A2
    brk
    stx L8FD4
    jmp L7A8F
L8BED:
    lda #$2E
    jsr L81D6
    lda #$4F
    jsr L81D6
    jsr L8950
    lda #$01
    sta L8FF6
    jmp L8BD4
L8C02:
    lda L8FE7
    beq L8BD4
    jsr L81B9
    cmp #$50
    beq L8C1A
    cmp #$4F
    beq L8C4C
    cmp #$53
    beq L8C80
    cmp #$48
    beq L8C66
L8C1A:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$50
    jsr L81D6
    jsr L8950
    dec L8FF5
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
    jmp L8BD4
L8C4C:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$4F
    jsr L81D6
    jsr L8950
    lda #$00
    sta L8FF6
    jmp L8BD4
L8C66:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$48
    jsr L81D6
    jsr L8950
    lda #$00
    sta L8FFA
    jmp L8BD4
L8C80:
    lda #$2E
    jsr L81D6
    lda #$4E
    jsr L81D6
    lda #$53
    jsr L81D6
    jsr L8950
    lda #$00
    sta L8FF9
    jmp L8BD4
    lda #$2E
    jsr L81D6
    lda #$53
    jsr L81D6
    jsr L8950
    lda L8FE7
    beq L8CB1
    lda #$01
    sta L8FF9
L8CB1:
    jmp L8BD4
L8CB4:
    lda #$2E
    jsr L81D6
    lda #$48
    jsr L81D6
    jsr L8950
    lda #$01
    sta L8FFA
    jmp L8BD4
; ---- data / tables / variables ----
L8CC9:
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
L8D71:
    .byte $01,$05,$09,$00,$08,$08,$08,$01
    .byte $08,$05,$06,$01,$02,$02,$00,$00
    .byte $00,$02,$00,$02,$04,$04,$01,$00
    .byte $01,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$08,$08,$01,$01,$01,$07,$08
    .byte $08,$03,$03,$03,$00,$00,$03,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
L8DA9:
    .byte $A1,$A0,$20,$60,$B0,$F0,$90,$C1
    .byte $D0,$A2,$4C,$81,$84,$86,$C8,$88
    .byte $CA,$C6,$E8,$E6,$C0,$E0,$E1,$38
    .byte $61,$18,$AA,$A8,$8A,$98,$48,$68
    .byte $00,$30,$10,$21,$01,$41,$24,$50
    .byte $70,$22,$62,$42,$D8,$58,$02,$08
    .byte $28,$40,$F8,$78,$BA,$9A,$B8,$EA
L8DE1:
    .byte $30,$31,$32,$33,$34,$35,$36,$37
    .byte $38,$39,$41,$42,$43,$44,$45,$46
L8DF1:
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
L8E38:
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
L8E80:
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
L8EF3:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00
L8F06:
    .byte $00,$00,$00,$00,$00,$00,$00
L8F0D:
    .byte $00
L8F0E:
    .byte $00
L8F0F:
    .byte $00
L8F10:
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
L8FCE:
    .byte $00
L8FCF:
    .byte $00
L8FD0:
    .byte $00
L8FD1:
    .byte $00
L8FD2:
    .byte $00
L8FD3:
    .byte $00
L8FD4:
    .byte $00
L8FD5:
    .byte $00
L8FD6:
    .byte $00
L8FD7:
    .byte $00
L8FD8:
    .byte $00,$00,$00
L8FDB:
    .byte $00
L8FDC:
    .byte $00
L8FDD:
    .byte $00
L8FDE:
    .byte $00,$00
L8FE0:
    .byte $00
L8FE1:
    .byte $00
L8FE2:
    .byte $00,$00
L8FE4:
    .byte $00
L8FE5:
    .byte $00
L8FE6:
    .byte $00
L8FE7:
    .byte $00
L8FE8:
    .byte $00
L8FE9:
    .byte $00
L8FEA:
    .byte $00
L8FEB:
    .byte $00
L8FEC:
    .byte $00
L8FED:
    .byte $00
L8FEE:
    .byte $00,$00
L8FF0:
    .byte $00
L8FF1:
    .byte $00
L8FF2:
    .byte $00
L8FF3:
    .byte $00
L8FF4:
    .byte $00
L8FF5:
    .byte $00
L8FF6:
    .byte $00
L8FF7:
    .byte $00
L8FF8:
    .byte $00
L8FF9:
    .byte $00
L8FFA:
    .byte $00
L8FFB:
    .byte $00
L8FFC:
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
