; ---------------------------------------------------------------------------
; crt0.s
; ---------------------------------------------------------------------------
;
; Startup code for cc65 (BU 6502 SIM) based on recommended code in cc65
; customization documentation

.export   _init, _exit
.import   _main, _nmi_int, _irq_int

.export   __STARTUP__ : absolute = 1        ; Mark as startup
.import   __STACKSTART__, __STACKSIZE__
.import    copydata, zerobss, initlib, donelib

.include  "zeropage.inc"

; ---------------------------------------------------------------------------
; Place the startup code in a special segment

.segment  "STARTUP"

; ---------------------------------------------------------------------------
; A little light 6502 housekeeping

_init:    LDX     #$FF                 ; Initialize stack pointer to $01FF
          TXS
          CLD                          ; Clear decimal mode

; ---------------------------------------------------------------------------
; Set cc65 argument stack pointer

          LDA     #<(__STACKSTART__)
          STA     sp
          LDA     #>(__STACKSTART__)
          STA     sp+1

; ---------------------------------------------------------------------------
; Initialize memory storage

          JSR     zerobss              ; Clear BSS segment
          JSR     copydata             ; Initialize DATA segment
          JSR     initlib              ; Run constructors

; ---------------------------------------------------------------------------
; Call main()

          JSR     _main

; ---------------------------------------------------------------------------
; Back from main (this is also the _exit entry):  force a software break

_exit:    JSR     donelib              ; Run destructors
          BRK


.segment "VECTORS"

.addr      _nmi_int    ; NMI vector
.addr      _init       ; Reset vector
.addr      _irq_int    ; IRQ/BRK vector
