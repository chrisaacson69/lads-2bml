#!/usr/bin/env python3
"""dis6502.py -- minimal complete NMOS 6502 disassembler. Usage:
   py -3 dis6502.py <binfile> <origin_hex> <start_hex> <count>"""
import sys

# opcode -> (mnemonic, addressing mode)
OPS = {}
def _add(base, mnem, modes):
    for op, m in modes: OPS[op] = (mnem, m)
# addressing modes: imp, acc, imm, zp, zpx, zpy, izx, izy, abs, abx, aby, ind, rel
_add(0,'BRK',[(0x00,'imp')]); _add(0,'RTI',[(0x40,'imp')]); _add(0,'RTS',[(0x60,'imp')])
_add(0,'PHP',[(0x08,'imp')]); _add(0,'PLP',[(0x28,'imp')]); _add(0,'PHA',[(0x48,'imp')])
_add(0,'PLA',[(0x68,'imp')]); _add(0,'DEY',[(0x88,'imp')]); _add(0,'TAY',[(0xA8,'imp')])
_add(0,'INY',[(0xC8,'imp')]); _add(0,'INX',[(0xE8,'imp')]); _add(0,'CLC',[(0x18,'imp')])
_add(0,'SEC',[(0x38,'imp')]); _add(0,'CLI',[(0x58,'imp')]); _add(0,'SEI',[(0x78,'imp')])
_add(0,'TYA',[(0x98,'imp')]); _add(0,'CLV',[(0xB8,'imp')]); _add(0,'CLD',[(0xD8,'imp')])
_add(0,'SED',[(0xF8,'imp')]); _add(0,'TXA',[(0x8A,'imp')]); _add(0,'TXS',[(0x9A,'imp')])
_add(0,'TAX',[(0xAA,'imp')]); _add(0,'TSX',[(0xBA,'imp')]); _add(0,'DEX',[(0xCA,'imp')])
_add(0,'NOP',[(0xEA,'imp')])
for op in (0x0A,0x2A,0x4A,0x6A): OPS[op]=({0x0A:'ASL',0x2A:'ROL',0x4A:'LSR',0x6A:'ROR'}[op],'acc')
_add(0,'JMP',[(0x4C,'abs'),(0x6C,'ind')]); _add(0,'JSR',[(0x20,'abs')])
def grp(mn, base, has_imm=True):
    OPS[base|0x09]=(mn,'imm') if has_imm else (mn,'imm')
    OPS[base|0x05]=(mn,'zp'); OPS[base|0x15]=(mn,'zpx'); OPS[base|0x0D]=(mn,'abs')
    OPS[base|0x1D]=(mn,'abx'); OPS[base|0x19]=(mn,'aby'); OPS[base|0x01]=(mn,'izx'); OPS[base|0x11]=(mn,'izy')
grp('ORA',0x00); grp('AND',0x20); grp('EOR',0x40); grp('ADC',0x60)
grp('STA',0x80,has_imm=False); del OPS[0x89]
grp('LDA',0xA0); grp('CMP',0xC0); grp('SBC',0xE0)
for op,md in [(0xE6,'zp'),(0xF6,'zpx'),(0xEE,'abs'),(0xFE,'abx')]: OPS[op]=('INC',md)
for op,md in [(0xC6,'zp'),(0xD6,'zpx'),(0xCE,'abs'),(0xDE,'abx')]: OPS[op]=('DEC',md)
for op,md in [(0x06,'zp'),(0x16,'zpx'),(0x0E,'abs'),(0x1E,'abx')]: OPS[op]=('ASL',md)
for op,md in [(0x26,'zp'),(0x36,'zpx'),(0x2E,'abs'),(0x3E,'abx')]: OPS[op]=('ROL',md)
for op,md in [(0x46,'zp'),(0x56,'zpx'),(0x4E,'abs'),(0x5E,'abx')]: OPS[op]=('LSR',md)
for op,md in [(0x66,'zp'),(0x76,'zpx'),(0x6E,'abs'),(0x7E,'abx')]: OPS[op]=('ROR',md)
for op,md in [(0xA2,'imm'),(0xA6,'zp'),(0xB6,'zpy'),(0xAE,'abs'),(0xBE,'aby')]: OPS[op]=('LDX',md)
for op,md in [(0xA0,'imm'),(0xA4,'zp'),(0xB4,'zpx'),(0xAC,'abs'),(0xBC,'abx')]: OPS[op]=('LDY',md)
for op,md in [(0x86,'zp'),(0x96,'zpy'),(0x8E,'abs')]: OPS[op]=('STX',md)
for op,md in [(0x84,'zp'),(0x94,'zpx'),(0x8C,'abs')]: OPS[op]=('STY',md)
for op,md in [(0xE0,'imm'),(0xE4,'zp'),(0xEC,'abs')]: OPS[op]=('CPX',md)
for op,md in [(0xC0,'imm'),(0xC4,'zp'),(0xCC,'abs')]: OPS[op]=('CPY',md)
for op,md in [(0x24,'zp'),(0x2C,'abs')]: OPS[op]=('BIT',md)
for op,mn in [(0x10,'BPL'),(0x30,'BMI'),(0x50,'BVC'),(0x70,'BVS'),(0x90,'BCC'),(0xB0,'BCS'),(0xD0,'BNE'),(0xF0,'BEQ')]:
    OPS[op]=(mn,'rel')
SZ={'imp':1,'acc':1,'imm':2,'zp':2,'zpx':2,'zpy':2,'izx':2,'izy':2,'abs':3,'abx':3,'aby':3,'ind':3,'rel':2}

def dis1(mem, addr, origin):
    op = mem[addr-origin]
    mn, md = OPS.get(op, ('.byte', 'imp'))
    n = SZ[md]; raw = mem[addr-origin:addr-origin+n]
    a = raw[1] if n>1 else 0; w = (raw[2]<<8|raw[1]) if n>2 else 0
    txt = {'imp':'','acc':'A','imm':f'#${a:02X}','zp':f'${a:02X}','zpx':f'${a:02X},X',
           'zpy':f'${a:02X},Y','izx':f'(${a:02X},X)','izy':f'(${a:02X}),Y','abs':f'${w:04X}',
           'abx':f'${w:04X},X','aby':f'${w:04X},Y','ind':f'(${w:04X})',
           'rel':f'${addr+2+((a^0x80)-0x80):04X}'}[md]
    if mn=='.byte': txt=f'${op:02X}'
    return n, mn, txt, raw

def main():
    mem = open(sys.argv[1],'rb').read(); origin=int(sys.argv[2],16)
    addr=int(sys.argv[3],16); count=int(sys.argv[4])
    end=addr+count
    while addr < end and addr-origin < len(mem):
        n,mn,txt,raw = dis1(mem, addr, origin)
        print(f'  ${addr:04X}: {" ".join(f"{x:02X}" for x in raw):<9} {mn} {txt}')
        addr += n

if __name__=='__main__': main()
