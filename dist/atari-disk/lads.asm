; disassembled from lads_atari.bin by dis2src.py -- reassembles byte-exact
.setcpu "6502"
.org $8000

    jmp L92CB
L8003:
    lda #$00
    sta $52
    ldy #$30
L8009:
    sta L9AB7,Y
    dey
    bne L8009
    lda #$00
    sta $8A
    sta $9ACD
    lda #$80
    sta $8B
    sta $9ACE
    lda #$01
    sta $9AE3
    jsr L910E
    lda $A2
    bne L8043
    ldy #$00
    ldx L923E
    inx
L802F:
    lda $0500,X
    cmp #$9B
    beq L803E
    sta L99E2,Y
    iny
    inx
    jmp L802F
L803E:
    sty $80
    jsr L870D
L8043:
    jsr L8805
    lda #$00
    sta $9ABD
    jsr L88BE
    lda $9AD0
    bne L8092
    jsr L8D79
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
    jsr L8D79
    lda $9AC6
    bne L8082
    lda #$90
    sta $86
    lda #$99
    sta $87
    jsr L882B
L8082:
    lda $9AC0
    sta $88
    sta $9AB9
    lda $9AC1
    sta $89
    sta $9ABA
L8092:
    jsr L91AF
    lda $9ABD
    beq L809D
    jmp L83AE
L809D:
    jsr L88BE
    lda #$00
    sta $9AC5
    sta $9ACF
    ldy $9AD0
    bne L80B0
    jmp L80CC
L80B0:
    sty $9AE4
    lda $9AE2
    beq L80C4
    jsr L8D82
    jsr L8D33
    jsr L8D5B
    jsr L8D33
L80C4:
    lda $9ADB
    beq L80CC
    jsr L8C2F
L80CC:
    jmp L87B7
L80CF:
    lda $9AB8
    beq L80EB
    cmp #$03
    bne L814A
    lda #$01
    sta $9AB8
    lda L9993
    bne L814A
    lda #$08
    clc
    adc L9AB7
    sta L9AB7
L80EB:
    jmp L82BF
L80EE:
    lda $9AD0
    beq L812C
    ldy #$FF
L80F5:
    iny
    lda L9990,Y
    beq L8129
    sta L99E2,Y
    cmp #$20
    bne L80F5
    iny
    lda L9990,Y
    cmp #$3D
    bne L810D
    jmp L82EF
L810D:
    ldx #$00
    stx $9AE4
    txa
    sta L99E2,Y
L8116:
    lda L9990,Y
    beq L8123
    sta L9990,X
    inx
    iny
    jmp L8116
L8123:
    sta L9990,X
    jmp L80CC
L8129:
    jsr L85A0
L812C:
    jsr L8542
    jmp L80CC
L8132:
    lda L99A5
    cmp #$40
    bcs L813F
    lda L99A6
    inc $9ACF
L813F:
    eor #$80
    sta $9ABE
    jsr L85E4
    jmp L81CB
L814A:
    ldy #$00
    sty $9AC5
    lda L9993
    cmp #$20
    beq L8159
    jmp L8468
L8159:
    lda L9994,Y
    cmp #$41
    bcc L8163
    inc $9AC5
L8163:
    sta L99A5,Y
    iny
    lda L9994,Y
    beq L8182
    sta L99A5,Y
    cmp #$41
    bcc L8176
    inc $9AC5
L8176:
    iny
    lda L9994,Y
    beq L8182
    sta L99A5,Y
    jmp L8176
L8182:
    dey
    sty $9AC4
    lda $9AC6
    bne L81CB
    lda $9AC5
    bne L8132
    lda #$A5
    sta $86
    lda #$99
    sta $87
    ldy #$00
    lda L99A5
    cmp #$30
    bcs L81A8
    clc
    inc $86
    bcc L81A8
    inc $87
L81A8:
    lda ($86),Y
    beq L81BC
    cmp #$29
    beq L81BC
    cmp #$2C
    beq L81BC
    cmp #$20
    beq L81BC
    iny
    jmp L81A8
L81BC:
    pha
    tya
    pha
    lda #$00
    sta ($86),Y
    jsr L882B
    pla
    tay
    pla
    sta ($86),Y
L81CB:
    lda L99A5
    cmp #$23
    beq L8211
    cmp #$28
    beq L81ED
    lda $9AB8
    cmp #$08
    beq L8214
    cmp #$03
    bne L8252
    lda #$08
    clc
    adc L9AB7
    sta L9AB7
    jmp L82BF
L81ED:
    ldy $9AC4
    lda L99A5,Y
    cmp #$29
    beq L8207
    lda $9AB8
    cmp #$01
    bne L8207
    lda #$10
    clc
    adc L9AB7
    sta L9AB7
L8207:
    lda $9AB8
    cmp #$06
    beq L8261
    jmp L8284
L8211:
    jmp L829F
L8214:
    lda $9AD0
    bne L821C
    jmp L8284
L821C:
    sec
    lda $9AC0
    sbc $88
    pha
    lda $9AC1
    sbc $89
    bcs L8238
    cmp #$FF
    beq L8232
    pla
    jmp L8528
L8232:
    pla
    bpl L8241
    jmp L8244
L8238:
    beq L823E
    pla
    jmp L8528
L823E:
    pla
    bpl L8244
L8241:
    jmp L8528
L8244:
    sec
    sbc #$02
    sta $9AC0
    lda #$00
    sta $9AC1
    jmp L8284
L8252:
    ldy $9AC4
    dey
    lda L99A5,Y
    cmp #$2C
    bne L8261
    iny
    jmp L8413
L8261:
    lda L9AB7
    cmp #$4C
    bne L826B
    jmp L828D
L826B:
    lda $9AC1
    bne L82C5
    lda $9AB8
    cmp #$06
    bcs L8284
    cmp #$02
    beq L8284
    lda #$04
    clc
    adc L9AB7
    sta L9AB7
L8284:
    jsr L8C76
    jsr L8C9C
    jmp L82EF
L828D:
    ldy $9AC4
    lda L99A5,Y
    cmp #$29
    bne L829C
    lda #$6C
    sta L9AB7
L829C:
    jmp L82E9
L829F:
    lda L99A6
    cmp #$22
    bne L82AC
    lda L99A7
    sta $9AC0
L82AC:
    lda $9AB8
    cmp #$01
    bne L8284
    lda #$08
    clc
    adc L9AB7
    sta L9AB7
    jmp L8284
L82BF:
    jsr L8C76
    jmp L82EF
L82C5:
    lda $9AB8
    cmp #$02
    beq L82D0
    cmp #$07
    bne L82DC
L82D0:
    lda L9AB7
    clc
    adc #$08
    sta L9AB7
    jmp L82E9
L82DC:
    cmp #$06
    bcs L82E9
    lda L9AB7
    clc
    adc #$0C
    sta L9AB7
L82E9:
    jsr L8C76
    jsr L8CB6
L82EF:
    lda $9AD0
    bne L82F7
    jmp L83AB
L82F7:
    lda $9AE2
    bne L82FF
    jmp L83AB
L82FF:
    lda $9AE4
    bne L8342
    lda $9ADE
    beq L8333
    lda #$14
    sec
    sbc $55
    sta $9AD1
    jsr L910E
    ldx #$04
    jsr L910B
    ldy $9AD1
    bpl L8323
    ldy #$02
    jmp L8325
L8323:
    lda #$20
L8325:
    jsr L9124
    dey
    bne L8325
    jsr L910E
    ldx #$01
    jsr L9108
L8333:
    lda #$14
    sta $55
    lda #$E2
    sta $86
    lda #$99
    sta $87
    jsr L8D22
L8342:
    lda #$1E
    sec
    sbc $55
    sta $9AD2
    lda #$1E
    sta $55
    lda $9ADE
    beq L8372
    jsr L910E
    ldx #$04
    jsr L910B
    ldy $9AD2
    beq L836A
    bmi L836A
    lda #$20
L8364:
    jsr L9124
    dey
    bne L8364
L836A:
    jsr L910E
    ldx #$01
    jsr L9108
L8372:
    jsr L8D8F
    lda $9ADC
    beq L838B
    cmp #$01
    bne L8383
    lda #$3C
    jmp L8385
L8383:
    lda #$3E
L8385:
    jsr L9124
    jsr L8DAF
L838B:
    lda $9AE5
    beq L83A3
    jsr L8D33
    lda #$3B
    jsr L9124
    lda #$00
    sta $86
    lda #$05
    sta $87
    jsr L8D22
L83A3:
    jsr L8D79
    lda $9ABD
    bne L83AE
L83AB:
    jmp L8092
L83AE:
    lda $9AD0
    bne L83DC
    inc $9AD0
    lda $88
    sta $9AE6
    lda $89
    sta $9AE7
    lda $9AB9
    sta $88
    lda $9ABA
    sta $89
    jsr L910E
    lda #$01
    jsr L9119
    lda $A2
    bne L83D9
    jsr L870D
L83D9:
    jmp L8043
L83DC:
    jsr L910E
    lda #$01
    jsr L9119
    ldx #$02
    jsr L910B
    lda #$00
    jsr L9124
    jsr L910E
    lda #$02
    jsr L9119
    lda $9ADE
    beq L8410
    jsr L910E
    ldx #$04
    jsr L910B
    lda #$0D
    jsr L9124
    jsr L910E
    lda #$04
    jsr L9119
L8410:
    jmp L91B6
L8413:
    lda L99A5,Y
    cmp #$58
    beq L847C
    dey
    dey
    lda L99A5,Y
    cmp #$29
    bne L8426
    jmp L81ED
L8426:
    lda $9AC1
    bne L843A
    lda $9AB8
    cmp #$02
    beq L8481
    cmp #$05
    beq L8481
    cmp #$01
    beq L84B1
L843A:
    lda $9AB8
    cmp #$01
    bne L844D
    lda L9AB7
    clc
    adc #$18
    sta L9AB7
    jmp L82E9
L844D:
    lda $9AB8
    cmp #$05
    beq L845C
    lda #$31
    jsr L84F8
    jmp L8468
L845C:
    lda L9AB7
    clc
    adc #$1C
    sta L9AB7
    jmp L82E9
L8468:
    jsr L8D9B
    jsr L8D82
    lda #$9D
    sta $86
    lda #$9A
    sta $87
    jsr L8D22
    jmp L82EF
L847C:
    lda $9AC1
    bne L84C5
L8481:
    lda $9AB8
    cmp #$02
    bne L8494
    lda #$10
    clc
    adc L9AB7
    sta L9AB7
    jmp L8284
L8494:
    cmp #$01
    beq L84A8
    cmp #$03
    beq L84A8
    cmp #$05
    beq L84A8
    lda #$32
    jsr L84F8
    jmp L8468
L84A8:
    lda #$14
    clc
    adc L9AB7
    sta L9AB7
L84B1:
    lda L99A7,Y
    cmp #$59
    bne L84C2
    lda L9AB7
    cmp #$B6
    beq L84C2
    jmp L8468
L84C2:
    jmp L8284
L84C5:
    lda $9AB8
    cmp #$02
    bne L84D8
    lda #$18
    clc
    adc L9AB7
    sta L9AB7
    jmp L82E9
L84D8:
    cmp #$01
    beq L84EC
    cmp #$03
    beq L84EC
    cmp #$05
    beq L84EC
    lda #$33
    jsr L84F8
    jmp L8468
L84EC:
    lda #$1C
    clc
    adc L9AB7
    sta L9AB7
    jmp L82E9
L84F8:
    sta $9AD1
    sty $9AD3
    stx $9AD2
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
    lda $9AD1
    ldy $9AD3
    ldx $9AD2
    rts
L851C:
    ldy #$00
    tya
L851F:
    sta L9990,Y
    iny
    cpy #$50
    bne L851F
    rts
L8528:
    jsr L8D79
    jsr L8D9B
    jsr L8D82
    lda #$12
    sta $86
    lda #$9A
    sta $87
    jsr L8D22
    jsr L8D79
    jmp L8284
L8542:
    ldy #$FF
L8544:
    iny
    lda L9990,Y
    beq L85A0
    cmp #$20
    bne L8544
    iny
    iny
    sty $9ACA
    sec
    lda $8A
    sbc $9ACA
    sta $8A
    lda $8B
    sbc #$00
    sta $8B
    ldy #$00
    lda L9990,Y
    eor #$80
    sta ($8A),Y
L856A:
    iny
    lda L9990,Y
    cmp #$20
    beq L8577
    sta ($8A),Y
    jmp L856A
L8577:
    iny
    lda L9990,Y
    cmp #$3D
    beq L85B1
    dey
    lda $88
    sta ($8A),Y
    iny
    lda $89
    sta ($8A),Y
    ldx $9ACA
    dex
    ldy #$00
L858F:
    lda L9990,X
    beq L859C
    sta L9990,Y
    inx
    iny
    jmp L858F
L859C:
    sta L9990,Y
    rts
L85A0:
    jsr L8D9B
    lda #$46
    sta $86
    lda #$9A
    sta $87
    jsr L8D22
    jmp L85DF
L85B1:
    dey
    sty $9ACB
    lda $9AC6
    bne L85D1
    iny
    iny
    iny
    sty $9ABF
    lda #$90
    clc
    adc $9ABF
    sta $86
    lda #$99
    adc #$00
    sta $87
    jsr L882B
L85D1:
    ldy $9ACB
    lda $9AC0
    sta ($8A),Y
    lda $9AC1
    iny
    sta ($8A),Y
L85DF:
    pla
    pla
    jmp L82EF
L85E4:
    lda $9ACD
    sta $8C
    lda $9ACE
    sta $8D
    jsr L86F2
    lda #$FF
    sta L9237
L85F6:
    sec
    lda $8A
    sbc $8C
    lda $8B
    sbc $8D
    bcs L8664
    ldx #$00
    sec
    lda $8C
    sbc #$02
    sta $8C
    lda $8D
    sbc #$00
    sta $8D
    ldy #$00
L8612:
    lda ($8C),Y
    bmi L8622
    lda $8C
    bne L861C
    dec $8D
L861C:
    dec $8C
    inx
    jmp L8612
L8622:
    lda $8C
    sta $9AD4
    lda $8D
    sta $9AD5
    lda ($8C),Y
    cmp $9ABE
    beq L8636
    jmp L8654
L8636:
    inx
    stx $9ABF
    ldx #$01
    lda $9ACF
    beq L8645
    iny
    jsr L86F2
L8645:
    iny
    lda L99A5,Y
    beq L869E
    cmp #$30
    bcc L869E
    inx
    cmp ($8C),Y
    beq L8645
L8654:
    lda $9AD4
    sta $8C
    lda $9AD5
    sta $8D
    jsr L86F2
    jmp L85F6
L8664:
    lda L9237
    bmi L866A
    rts
L866A:
    lda $9AD0
    bne L8671
    beq L8688
L8671:
    jsr L8D9B
    jsr L8D82
    jsr L8D33
    lda #$36
    sta $86
    lda #$9A
    sta $87
    jsr L8D22
    jsr L8D79
L8688:
    pla
    pla
    lda L9AB7
    and #$1F
    cmp #$10
    beq L869B
    lda $9ADC
    bne L869B
    jmp L82E9
L869B:
    jmp L8284
L869E:
    cpx $9ABF
    beq L86A6
    jmp L8654
L86A6:
    inc L9237
    beq L86AE
    jsr L86FB
L86AE:
    ldy $9ABF
    lda $9ACF
    beq L86B7
    iny
L86B7:
    lda ($8C),Y
    sta $9AC0
    iny
    lda ($8C),Y
    sta $9AC1
    lda $9ADC
    beq L86D1
    cmp #$02
    bne L86E9
    lda $9AC1
    sta $9AC0
L86D1:
    lda $9ADB
    beq L86E9
    clc
    lda $9AD9
    adc $9AC0
    sta $9AC0
    lda $9ADA
    adc $9AC1
    sta $9AC1
L86E9:
    lda $9AD0
    beq L86EF
    rts
L86EF:
    jmp L8654
L86F2:
    lda $8C
    bne L86F8
    dec $8D
L86F8:
    dec $8C
    rts
L86FB:
    jsr L8D9B
    lda #$7F
    sta $86
    lda #$9A
    sta $87
    jsr L8D22
    jsr L8D79
    rts
L870D:
    jsr L910E
    lda #$01
    jsr L9119
    lda #$01
    sta $83
    lda #$04
    sta $85
    lda #$00
    sta $84
    lda #$E2
    sta $81
    lda #$99
    sta $82
    jsr L90DA
    lda $01
    bmi L8740
    lda $A2
    beq L873F
    jsr L9803
    lda #$00
    sta $A0
    lda #$20
    sta $A1
L873F:
    rts
L8740:
    jsr L9673
    jmp L91B6
L8746:
    lda #$02
    sta $83
    lda #$08
    sta $85
    lda #$00
    sta $84
    lda #$E2
    sta $81
    lda #$99
    sta $82
    lda #$02
    jsr L9119
    lda $01
    bmi L8740
    jsr L90DA
    ldx #$02
    jsr L910B
    lda #$FF
    jsr L9124
    jsr L9124
    lda $9AB9
    jsr L9124
    lda $9ABA
    jsr L9124
    lda $9AE6
    jsr L9124
    lda $9AE7
    jsr L9124
    jsr L910E
    rts
L878F:
    lda #$04
    sta $83
    jsr L9119
    lda #$08
    sta $85
    lda #$00
    sta $84
    lda #$02
    sta $80
    lda #$B5
    sta $81
    lda #$87
    sta $82
    jsr L90DA
    lda $01
    bmi L8740
    jsr L910E
    rts
    bvc $87F1
L87B7:
    ldy #$00
    ldx #$FF
L87BB:
    inx
    lda L9868,Y
    cmp L9990
    beq L87CE
    iny
    iny
    iny
    cpx #$39
    bne L87BB
L87CB:
    jmp L80EE
L87CE:
    iny
    lda L9868,Y
    cmp L9991
    beq L87DD
    iny
    iny
    bne L87BB
    beq L87CB
L87DD:
    iny
    lda L9868,Y
    cmp L9992
    beq L87EB
    iny
    bne L87BB
    beq L87CB
L87EB:
    lda L9993
    cmp #$20
    beq L87F6
    cmp #$00
    bne L87CB
L87F6:
    lda L9910,X
    sta $9AB8
    ldy L9948,X
    sty L9AB7
    jmp L80CF
L8805:
    lda #$00
    sta $A0
    lda #$20
    sta $A1
    ldx #$01
    jsr L9108
    jsr L91F1
    jsr L9155
    cmp #$2A
    beq L882A
    lda #$01
    sta $86
    lda #$9A
    sta $87
    jsr L8D22
    jmp L83DC
L882A:
    rts
L882B:
    ldy #$00
L882D:
    lda ($86),Y
    cmp #$30
    bcc L883B
    cmp #$3A
    bcs L883B
    iny
    jmp L882D
L883B:
    sty L99FE
    dey
    lda #$00
    sta $9AC0
    sta $9AC1
    ldx #$01
    stx $9AD2
L884C:
    lda ($86),Y
    and #$0F
    sta L99FC
    sta L99FF
    lda #$00
    sta L99FD
    sta L9A00
L885E:
    dex
    beq L8873
    jsr L8883
    lda L99FC
    sta L99FF
    lda L99FD
    sta L9A00
    jmp L885E
L8873:
    inc $9AD2
    ldx $9AD2
    jsr L88AA
    dey
    dec L99FE
    bne L884C
    rts
L8883:
    clc
    asl L99FC
    rol L99FD
    asl L99FC
    rol L99FD
    clc
    lda L99FF
    adc L99FC
    sta L99FC
    lda L9A00
    adc L99FD
    sta L99FD
    asl L99FC
    rol L99FD
    rts
L88AA:
    clc
    lda L99FC
    adc $9AC0
    sta $9AC0
    lda L99FD
    adc $9AC1
    sta $9AC1
    rts
L88BE:
    jsr L851C
    ldy #$00
    sty $9AC6
    sty $9AE5
    sty $9ADC
    sty $9ADB
    lda $9AE0
    bne L88D7
    jsr L91F1
L88D7:
    jsr L9155
    bne L88E4
    jsr L89FD
    pla
    pla
    jmp L8092
L88E4:
    cmp #$20
    beq L88D7
    jmp L88F3
L88EB:
    jsr L9155
L88EE:
    bne L88F3
    jmp L89FD
L88F3:
    cmp #$3A
    bne L88FA
    jmp L898B
L88FA:
    cmp #$3B
    bne L8966
    sty $9AD1
    lda $9ADE
    beq L8950
    sta $9AE5
    lda $9AD1
    beq L8914
    jsr L8934
    jmp L8958
L8914:
    jsr L9155
    beq L8920
    sta L9990,Y
    iny
    jmp L8914
L8920:
    jsr L8D82
    jsr L8D33
    jsr L8D8F
    jsr L8D79
    lda #$00
    sta $9AD1
    jmp L8958
L8934:
    sta $9AE5
    sta $9AD1
    ldy #$00
L893C:
    jsr L9155
    bne L8948
    sta $0500,Y
    ldy $9AD1
    rts
L8948:
    nop
    sta $0500,Y
    iny
    jmp L893C
L8950:
    jsr L9155
    beq L8958
    jmp L8950
L8958:
    jsr L89FD
    lda $9AD1
    bne L8965
    pla
    pla
    jmp L8092
L8965:
    rts
L8966:
    cmp #$3E
    beq L8999
    cmp #$3C
    beq L89A1
    cmp #$2B
    bne L8975
    inc $9ADB
L8975:
    cmp #$2A
    bne L897C
    jmp L89A9
L897C:
    cmp #$2E
    beq L898F
    cmp #$24
    beq L8992
    sta L9990,Y
    iny
    jmp L88EB
L898B:
    sta $9AE0
    rts
L898F:
    jmp L8AA4
L8992:
    sta L9990,Y
    iny
    jmp L8A1F
L8999:
    lda #$02
    sta $9ADC
    jmp L88EB
L89A1:
    lda #$01
    sta $9ADC
    jmp L88EB
L89A9:
    jsr L88EB
    lda $9AD0
    beq L89BC
    lda #$2A
    jsr L9124
    jsr L8D8F
    jsr L8D79
L89BC:
    lda $9AC6
    bne L89E1
    ldy #$00
L89C3:
    lda L9990,Y
    cmp #$20
    beq L89CE
    iny
    jmp L89C3
L89CE:
    iny
    sty $86
    lda #$90
    clc
    adc $86
    sta $86
    lda #$99
    adc #$00
    sta $87
    jsr L882B
L89E1:
    lda $9AD0
    beq L89EE
    lda $9ADD
    beq L89EE
    jsr L8BEE
L89EE:
    lda $9AC0
    sta $88
    lda $9AC1
    sta $89
    pla
    pla
    jmp L8092
L89FD:
    sta L9990,Y
    iny
    cpy #$50
    bne L89FD
    sta L9990,Y
    lda $0353
    cmp #$03
    beq L8A19
    cmp #$88
    beq L8A19
    lda #$00
    sta $9AE0
    rts
L8A19:
    lda #$01
    sta $9ABD
    rts
L8A1F:
    ldx #$00
L8A21:
    jsr L9155
    beq L8A52
    cmp #$3A
    beq L8A52
    cmp #$20
    beq L8A21
    cmp #$3B
    beq L8A52
    cmp #$2C
    beq L8A45
    cmp #$29
    beq L8A45
    sta L99CD,X
    inx
    sta L9990,Y
    iny
    jmp L8A21
L8A45:
    stx $9AC7
    sta L9990,Y
    iny
    jsr L8A66
    jmp L88EB
L8A52:
    sta $9AD1
    lda #$00
    stx $9AC7
    sta L9990,Y
    jsr L8A66
    lda $9AD1
    jmp L88EE
L8A66:
    lda #$00
    sta $9AC0
    sta $9AC1
    tax
L8A6F:
    asl $9AC0
    rol $9AC1
    asl $9AC0
    rol $9AC1
    asl $9AC0
    rol $9AC1
    asl $9AC0
    rol $9AC1
    lda L99CD,X
    cmp #$41
    bcc L8A90
    sbc #$07
L8A90:
    and #$0F
    ora $9AC0
    sta $9AC0
    inx
    cpx $9AC7
    bne L8A6F
    inc $9AC6
    lda #$01
    rts
L8AA4:
    cpy #$00
    beq L8AB6
    ldx $9AD0
    bne L8AB6
    pha
    tya
    pha
    jsr L8542
    pla
    tay
    pla
L8AB6:
    sta L9990,Y
    iny
    jsr L9155
    sta L9990,Y
    iny
    cmp #$42
    bne L8B2D
    lda #$00
    sta $9AD6
    lda $9AD0
    beq L8AE6
    sty $9AD3
    lda $9AE2
    beq L8AE6
    jsr L8D82
    jsr L8D33
    jsr L8D5B
    jsr L8D33
    ldy $9AD3
L8AE6:
    jsr L9155
    sta L9990,Y
    iny
    cmp #$20
    bne L8AE6
    jsr L9155
    sta L9990,Y
    iny
    cmp #$22
    bne L8B41
L8AFC:
    jsr L9155
    bne L8B04
    jmp L8BD3
L8B04:
    cmp #$3A
    bne L8B0B
    jmp L8BD6
L8B0B:
    cmp #$3B
    bne L8B1B
    jsr L8934
    ldx $9ADE
    stx $9AE5
    jmp L8BD3
L8B1B:
    cmp #$22
    bne L8B22
    jmp L8AFC
L8B22:
    ldx $9AD0
    bne L8B30
    jsr L8D14
    jmp L8AFC
L8B2D:
    jmp L8E7A
L8B30:
    sta L9990,Y
    tax
    sty $9AD3
    jsr L8CEC
    ldy $9AD3
    iny
    jmp L8AFC
L8B41:
    ldx #$00
    stx $9AD7
    sta L99F5,X
    inx
L8B4A:
    lda $9AD7
    bne L8BC4
    jsr L9155
    beq L8B97
    cmp #$3A
    beq L8B97
    cmp #$3B
    bne L8B68
    jsr L8934
    ldx $9ADE
    stx $9AE5
    jmp L8B97
L8B68:
    sta L99B9
    lda $9AD0
    bne L8B7D
    brk
    sta $20C9,Y
    bne L8B76
L8B76:
    .byte $D3
    jsr L8D14
    jmp L8B4A
L8B7D:
    lda L99B9
    sta L9990,Y
    iny
    cmp #$20
    beq L8BA0
    cmp #$00
    beq L8BA0
    cmp #$3A
    beq L8BA0
    sta L99F5,X
    inx
    jmp L8B4A
L8B97:
    inc $9AD7
    sta L99BA
    jmp L8B68
L8BA0:
    lda #$F5
    sta $86
    lda #$99
    sta $87
    sty $9AD3
    jsr L882B
    ldx $9AC0
    jsr L8CEC
    ldy $9AD3
    lda #$00
    ldx #$05
L8BBB:
    sta L99F5,X
    dex
    bne L8BBB
    jmp L8B4A
L8BC4:
    lda $9AD0
    bne L8BCC
    jsr L8D14
L8BCC:
    lda L99BA
    cmp #$3A
    beq L8BD6
L8BD3:
    jsr L89FD
L8BD6:
    sta $9AE0
    inc $9AE4
    pla
    pla
    lda $9AD0
    beq L8BEB
    lda $9AE2
    beq L8BEB
    jmp L8372
L8BEB:
    jmp L8092
L8BEE:
    lda $9AD0
    cmp #$02
    bne L8BF6
    rts
L8BF6:
    jsr L910E
    ldx #$02
    jsr L910B
    sec
    lda $9AC0
    sbc $88
    sta $9ABE
    lda $9AC1
    sbc $89
    sta $9ABF
L8C0F:
    lda #$00
    jsr L9124
    lda $9ABE
    bne L8C1C
    dec $9ABF
L8C1C:
    dec $9ABE
    bne L8C0F
    lda $9ABF
    bne L8C0F
    jsr L910E
    ldx #$01
    jsr L9108
    rts
L8C2F:
    ldy #$00
    ldx #$00
L8C33:
    lda L9990,Y
    cmp #$2B
    beq L8C3E
    iny
    jmp L8C33
L8C3E:
    iny
    lda L9990,Y
    jsr L8C4E
    bcs L8C59
    sta L99CD,X
    inx
    jmp L8C3E
L8C4E:
    cmp #$3A
    bcs L8C58
    sec
    sbc #$30
    sec
    sbc #$D0
L8C58:
    rts
L8C59:
    lda #$00
    sta L99CD,X
    lda #$CD
    sta $86
    lda #$99
    sta $87
    jsr L882B
    lda $9AC0
    sta $9AD9
    lda $9AC1
    sta $9ADA
    rts
L8C76:
    lda $9AD0
    bne L8C7F
    jsr L8D14
    rts
L8C7F:
    lda $9AE2
    beq L8C95
    jsr L910E
    ldx #$01
    jsr L9108
    ldx L9AB7
    jsr L8D3C
    jsr L8D33
L8C95:
    ldx L9AB7
    jsr L8CEC
    rts
L8C9C:
    lda $9AD0
    bne L8CA5
    jsr L8D14
    rts
L8CA5:
    lda $9AE2
    beq L8CB0
    ldx $9AC0
    jsr L8D3C
L8CB0:
    ldx $9AC0
    jmp L8CEC
L8CB6:
    lda $9AD0
    bne L8CC2
    jsr L8D14
    jsr L8D14
    rts
L8CC2:
    lda $9AE2
    beq L8CCD
    ldx $9AC0
    jsr L8D3C
L8CCD:
    ldx $9AC0
    jsr L8CEC
    lda $9AE2
    beq L8CE6
    lda $9AE3
    beq L8CE0
    jsr L8D33
L8CE0:
    ldx $9AC1
    jsr L8D3C
L8CE6:
    ldx $9AC1
    jmp L8CEC
L8CEC:
    stx $9ABF
    lda $9ADF
    beq L8CF9
    ldy #$00
    txa
    sta ($88),Y
L8CF9:
    lda $9ADD
    beq L8D14
    jsr L910E
    ldx #$02
    jsr L910B
    lda $9ABF
    jsr L912A
    jsr L910E
    ldx #$01
    jsr L9108
L8D14:
    clc
    lda #$01
    adc $88
    sta $88
    lda #$00
    adc $89
    sta $89
    rts
L8D22:
    ldy #$00
L8D24:
    lda ($86),Y
    beq L8D32
    jsr L9124
    jsr L8DA9
    iny
    jmp L8D24
L8D32:
    rts
L8D33:
    lda #$20
    jsr L9124
    jsr L8DA9
    rts
L8D3C:
    stx $9AD2
    lda $9AE3
    beq L8D4F
    txa
    jsr L8E61
    jsr L8DD2
    ldx $9AD2
    rts
L8D4F:
    lda #$00
    jsr L91CF
    jsr L8DD2
    ldx $9AD2
    rts
L8D5B:
    lda $9AE3
    beq L8D6E
    lda $89
    jsr L8E61
    lda $88
    jsr L8E61
    jsr L8E05
    rts
L8D6E:
    ldx $88
    lda $89
    jsr L91CF
    jsr L8E05
    rts
L8D79:
    lda #$0D
    jsr L9124
    jsr L8DA9
    rts
L8D82:
    ldx $9ABB
    lda $9ABC
    jsr L91CF
    jsr L8E3B
    rts
L8D8F:
    lda #$90
    sta $86
    lda #$99
    sta $87
    jsr L8D22
    rts
L8D9B:
    lda #$FD
    jsr L9124
    jsr L8D8F
    lda #$0D
    jsr L9124
    rts
L8DA9:
    ldx $9AD0
    bne L8DAF
    rts
L8DAF:
    ldx $9ADE
    bne L8DB5
    rts
L8DB5:
    sta $9AD1
    jsr L910E
    ldx #$04
    jsr L910B
    lda $9AD1
    jsr L9124
    jsr L910E
    ldx #$01
    jsr L9108
    lda $9AD1
    rts
L8DD2:
    ldx $9AD0
    bne L8DD8
    rts
L8DD8:
    ldx $9ADE
    bne L8DDE
    rts
L8DDE:
    jsr L910E
    ldx #$04
    jsr L910B
    lda $9AE3
    beq L8DF4
    lda $9AD2
    jsr L8E61
    jmp L8DFC
L8DF4:
    lda #$00
    ldx $9AD2
    jsr L91CF
L8DFC:
    jsr L910E
    ldx #$01
    jsr L9108
    rts
L8E05:
    ldx $9AD0
    bne L8E0B
    rts
L8E0B:
    ldx $9ADE
    bne L8E11
    rts
L8E11:
    jsr L910E
    ldx #$04
    jsr L910B
    ldx $9AE3
    beq L8E2B
    lda $89
    jsr L8E61
    lda $88
    jsr L8E61
    jmp L8E32
L8E2B:
    lda $89
    ldx $88
    jsr L91CF
L8E32:
    jsr L910E
    ldx #$01
    jsr L9108
    rts
L8E3B:
    ldx $9AD0
    bne L8E41
    rts
L8E41:
    ldx $9ADE
    bne L8E47
    rts
L8E47:
    jsr L910E
    ldx #$04
    jsr L910B
    lda $9ABC
    ldx $9ABB
    jsr L91CF
    jsr L910E
    ldx #$01
    jsr L9108
    rts
L8E61:
    pha
    and #$0F
    tay
    lda L9980,Y
    tax
    pla
    lsr A
    lsr A
    lsr A
    lsr A
    tay
    lda L9980,Y
    jsr L9124
    txa
    jsr L9124
    rts
L8E7A:
    cmp #$46
    bne L8E86
    jsr L8EDD
L8E81:
    pla
    pla
    jmp L8092
L8E86:
    cmp #$45
    bne L8E90
    jsr L8F27
    jmp L8E81
L8E90:
    cmp #$44
    bne L8E97
    jmp L8F66
L8E97:
    cmp #$50
    bne L8E9E
    jmp L8FAB
L8E9E:
    cmp #$4E
    bne L8EA5
    jmp L8FEC
L8EA5:
    cmp #$4F
    bne L8EAC
    jmp L8FD7
L8EAC:
    cmp #$53
    bne L8EB3
    jmp L90A5
L8EB3:
    cmp #$48
    bne L8EBA
    jmp L90BF
L8EBA:
    sta L9990,Y
    jsr L8D82
    jsr L8D33
    jsr L8D5B
    jsr L8D9B
    jsr L8D8F
    lda #$9D
    sta $86
    lda #$9A
    sta $87
    jsr L8D22
    jsr L8D79
    jmp L8FBE
L8EDD:
    jsr L9155
    cmp #$20
    beq L8EE7
    jmp L8EDD
L8EE7:
    ldy #$00
L8EE9:
    jsr L9155
    cmp #$00
    beq L8EF7
    sta L9990,Y
    iny
    jmp L8EE9
L8EF7:
    sty $80
    ldy #$00
L8EFB:
    lda L9990,Y
    beq L8F08
    sta L99E2,Y
    iny
    cpy $80
    bne L8EFB
L8F08:
    lda $9AD0
    bne L8F13
    jsr L8D5B
    jsr L8D33
L8F13:
    jsr L8D8F
    jsr L8D79
    jsr L870D
    ldx #$01
    jsr L9108
    ldx #$00
    stx $9ABD
    rts
L8F27:
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
    jsr L8EDD
    lda $9AD0
    beq L8F4B
    inc $9ABD
L8F4B:
    inc $9AD0
    lda $88
    sta $9AE6
    lda $89
    sta $9AE7
    lda $9AB9
    sta $88
    lda $9ABA
    sta $89
    jsr L88BE
    rts
L8F66:
    lda $9AD0
    beq L8F82
    jsr L9155
    sta L9990,Y
    ldy #$00
L8F73:
    jsr L9155
    beq L8F85
    sta L9990,Y
    sta L99E2,Y
    iny
    jmp L8F73
L8F82:
    jmp L8FBE
L8F85:
    sty $80
    jsr L8D8F
    jsr L8D79
    inc $9ADD
    jsr L8746
    jsr L910E
    ldx #$01
    jsr L9108
    jsr L9084
    jsr L89FD
    pla
    pla
    ldx #$00
    stx $9ABD
    jmp L8092
L8FAB:
    lda $9AD0
    beq L8FBE
    jsr L878F
    inc $9ADE
    jsr L910E
    ldx #$01
    jsr L9108
L8FBE:
    jsr L9155
    beq L8FCA
    cmp #$3A
    beq L8FCD
    jmp L8FBE
L8FCA:
    jsr L89FD
L8FCD:
    pla
    pla
    ldx #$00
    stx $9ABD
    jmp L8092
L8FD7:
    lda #$2E
    jsr L9124
    lda #$4F
    jsr L9124
    jsr L8D79
    lda #$01
    sta $9ADF
    jmp L8FBE
L8FEC:
    lda $9AD0
    beq L8FBE
    jsr L9155
    cmp #$50
    beq L9004
    cmp #$4F
    beq L9036
    cmp #$53
    beq L906A
    cmp #$48
    beq L9050
L9004:
    lda #$2E
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$50
    jsr L9124
    jsr L8D79
    dec $9ADE
    jsr L910E
    ldx #$04
    jsr L910B
    lda #$0D
    jsr L9124
    lda #$04
    jsr L9119
    jsr L910E
    ldx #$01
    jsr L9108
    jmp L8FBE
L9036:
    lda #$2E
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$4F
    jsr L9124
    jsr L8D79
    lda #$00
    sta $9ADF
    jmp L8FBE
L9050:
    lda #$2E
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$48
    jsr L9124
    jsr L8D79
    lda #$00
    sta $9AE3
    jmp L8FBE
L906A:
    lda #$2E
    jsr L9124
    lda #$4E
    jsr L9124
    lda #$53
    .byte $34
    bpl $900A
    jsr L8D79
    lda #$00
    sta $9AE2
    jmp L8FBE
L9084:
    ldx a:$0063
    brk
    brk
    brk
    brk
    brk
    jsr L8D3C
    jsr L8D33
    lda #$5C
    sta $86
    lda #$9A
    sta $87
    jsr L8D9B
    jsr L8D22
    pla
    pla
    jmp L83DC
L90A5:
    lda #$2E
    jsr L9124
    lda #$53
    jsr L9124
    jsr L8D79
    lda $9AD0
    beq L90BC
    lda #$01
    sta $9AE2
L90BC:
    jmp L8FBE
L90BF:
    lda #$2E
    jsr L9124
    lda #$48
    jsr L9124
    jsr L8D79
    lda #$01
    sta $9AE3
    jmp L8FBE
L90D4:
    asl A
    asl A
    asl A
    asl A
    tax
    rts
L90DA:
    lda $83
    jsr L90D4
    lda $81
    sta $0344,X
    lda $82
    sta $0345,X
    lda $80
    sta $0348,X
    lda #$00
    sta $0349,X
    lda $85
    sta $034A,X
    lda $84
    sta $034B,X
    lda #$03
    sta $0342,X
L9102:
    jsr $E456
    sty $01
    rts
L9108:
    stx $8E
    rts
L910B:
    stx $8F
    rts
L910E:
    ldx #$00
    stx $8E
    stx $8F
    stx $83
    stx $01
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
    lda $8F
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
    lda $A2
    beq L918D
    ldy #$00
    lda ($A0),Y
    pha
    inc $A0
    bne L916A
    inc $A1
L916A:
    clc
    lda $A0
    sbc L922F
    sta L91CE
    lda $A1
    sbc L9230
    ora L91CE
    bcc L9182
    beq L9182
    jmp L83AE
L9182:
    lda #$00
    sta $01
    sta $0353
    pla
    jmp L91A2
L918D:
    lda $8E
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
    jmp L92CB
L91B9:
    ldx #$07
L91BB:
    stx L91CE
    txa
    jsr L9119
    ldx L91CE
    dex
    bne L91BB
    jmp L910E
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
    sta $0500,Y
    iny
    jmp L91F3
L9201:
    lda #$00
    sta $0500,Y
    lda #$00
    sta $86
    lda #$05
    sta $87
    jsr L882B
    lda $9AC0
    sta $9ABB
    lda $9AC1
    sta $9ABC
    ldy #$00
    rts
    jmp L92CB
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
L9237:
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
L923E:
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
L92CB:
    ldx #$FF
    txs
    jsr L91B9
    lda #$00
    sta $A2
    lda #$02
    sta $52
    jsr L8D79
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
    jsr L910E
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
    ldx $01
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
    sta $0500,Y
    iny
    cmp #$00
    bne L9366
    dey
    lda #$9B
    sta $0500,Y
    sty L922A
    cpy #$00
    beq L935E
    lda $0500
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
    lda L9237
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
    cmp $0500,X
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
    stx L923E
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
    lda $01
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
    sta L9237
    tay
    sty L9232
    tya
    clc
    adc $CB
    sta $86
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
    jsr L882B
    sec
    lda $9AC0
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
    inc L9237
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
    lda $0500,Y
    sta ($CB),Y
    iny
    cpy L922A
    bcc L965A
    beq L965A
    rts
L9668:
    lda $83
    beq L966F
    jsr L9119
L966F:
    jsr L910E
    rts
L9673:
    lda $01
    sta L9242
    jsr L91B9
    lda #$AB
    ldy #$96
    jsr L9592
    ldx L9242
    lda #$00
    jsr L91CF
    jsr L8D79
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
    lda L923E
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
    lda L9237
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
    lda L9237
    bne L9765
    inc L9227
    bne L9765
    inc L9228
L9765:
    jmp L94A5
L9768:
    clc
    lda L923E
    adc #$00
    sta $81
    lda #$00
    adc #$05
    sta $82
    ldy L923E
L9779:
    lda $0500,Y
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
    sbc L923E
    sty L923E
    sta $80
    lda #$07
    sta $83
    jsr L9119
    lda #$00
    sta $84
    jsr L90DA
    ldx $01
    bmi L97A7
    rts
L97A7:
    pla
    pla
    jsr L9673
    jmp L9357
    lda #$08
    sta $85
    jsr L9768
    ldx $83
    jsr L910B
    jsr L96F6
    jsr L9668
    jmp L9357
    lda #$04
    sta $85
    jsr L9768
    ldx $83
    jsr L9108
    jmp L935E
    lda L923E
    cmp L922A
    bne L97DD
    inc $A2
L97DD:
    jmp L8003
    lda L923E
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
    sta $85
    jsr L9768
L9803:
    lda $83
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
    lda $83
    jsr L90D4
    clc
    lda $0348,X
    adc #$00
    sta L922F
    lda $0349,X
    adc #$20
    sta L9230
    lda $01
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
    jsr L8D79
    jmp L92CB
; ---- data / tables / variables ----
L9868:
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
L9910:
    .byte $01,$05,$09,$00,$08,$08,$08,$01
    .byte $08,$05,$06,$01,$02,$02,$00,$00
    .byte $00,$02,$00,$02,$04,$04,$01,$00
    .byte $01,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$08,$08,$01,$01,$01,$07,$08
    .byte $08,$03,$03,$03,$00,$00,$03,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
L9948:
    .byte $A1,$A0,$20,$60,$B0,$F0,$90,$C1
    .byte $D0,$A2,$4C,$81,$84,$86,$C8,$88
    .byte $CA,$C6,$E8,$E6,$C0,$E0,$E1,$38
    .byte $61,$18,$AA,$A8,$8A,$98,$48,$68
    .byte $00,$30,$10,$21,$01,$41,$24,$50
    .byte $70,$22,$62,$42,$D8,$58,$02,$08
    .byte $28,$40,$F8,$78,$BA,$9A,$B8,$EA
L9980:
    .byte $30,$31,$32,$33,$34,$35,$36,$37
    .byte $38,$39,$41,$42,$43,$44,$45,$46
L9990:
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
L99A5:
    .byte $00
L99A6:
    .byte $00
L99A7:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00
L99B9:
    .byte $00
L99BA:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00
L99CD:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00
L99E2:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00
L99F5:
    .byte $00,$00,$00,$00,$00,$00,$00
L99FC:
    .byte $00
L99FD:
    .byte $00
L99FE:
    .byte $00
L99FF:
    .byte $00
L9A00:
    .byte $00,$CE,$EF,$A0,$D3,$F4,$E1,$F2
    .byte $F4,$A0,$C1,$E4,$E4,$F2,$E5,$F3
    .byte $F3,$00,$2D,$2D,$2D,$2D,$00,$2D
    .byte $2D,$2D,$2D,$00,$2D,$2D,$2D,$2D
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
L9AB7:
    .byte $00
