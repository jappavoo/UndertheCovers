|Binary Value| 6502 Operation|
|------------|---------------|
| $00000000$ | interrupt - impl: Implied i |
| $00000001$ | or with accumulator - X,ind: Zero Page Indexed Indirect (zp,x) |
| $00000101$ | or with accumulator - zpg: Zero Page zp |
| $00000110$ | arithmetic shift left - zpg: Zero Page zp |
| $00001000$ | push processor status (SR) - impl: Implied i |
| $00001001$ | or with accumulator - #: Immediate # |
| $00001010$ | arithmetic shift left - A: Accumulator A |
| $00001101$ | or with accumulator - abs: Absolute a |
| $00001110$ | arithmetic shift left - abs: Absolute a |
| $00010000$ | branch on plus (negative clear) - rel: Program Counter Relative r |
| $00010001$ | or with accumulator - ind,Y: Zero Page Indirect Indexed with Y (zp),y |
| $00010101$ | or with accumulator - zpg,X: Zero Page Index with X |
| $00010110$ | arithmetic shift left - zpg,X: Zero Page Index with X |
| $00011000$ | clear carry - impl: Implied i |
| $00011001$ | or with accumulator - abs,Y: Absolute Indexed with Y a,y |
| $00011101$ | or with accumulator - abs,X: Absolute Indexed with X a,x |
| $00011110$ | arithmetic shift left - abs,X: Absolute Indexed with X a,x |
| $00100000$ | jump subroutine - abs: Absolute a |
| $00100001$ | and (with accumulator) - X,ind: Zero Page Indexed Indirect (zp,x) |
| $00100100$ | bit test - zpg: Zero Page zp |
