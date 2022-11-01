        ;;  manually 
	.repeat $E000
	.byte $00
	.endrep

	.byte 10
	.byte 1
	.byte 2
	.byte 3
	.byte 4
	.byte 5
	.byte 6
	.byte 7
	.byte 8
	.byte 9
	.byte 10

	.repeat $1000-11
	.byte $00
	.endrep
				; set address to F000 (this is where our code will live)
	.ORG $F000    		
	LDA #0        ; load A register with 0
	LDX #0	      ; load X register with 0
LOOP:
	CPX $E000     ; compare value in X register with value at E000 
	BEQ DONE      ; if equal then jump to done
	ADC $E001,X   ; add value in at E001 + X register value
	INX	      ; INCREMENT X
	JMP LOOP      
DONE:
	BRK    
