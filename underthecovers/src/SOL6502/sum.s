	;; We place things in memory locations by hand 
	;; Fill memory 0x0000 - 0xE000 with zeros
	.repeat $E000
	.byte $00
	.endrep

	;; Put our data at 0xE000 
	.byte 10      		; 0xE000 Array length
	.byte 1                 ; Array[0] = 1
	.byte 2			; Array[1] = 2
	.byte 3			; Array[2] = 3
	.byte 4			; Array[3] = 4
	.byte 5			; Array[4] = 5
	.byte 6			; Array[5] = 6
	.byte 7			; Array[6] = 7
	.byte 8			; Array[7] = 8
	.byte 9			; Array[8] = 9
	.byte 10		; Array[9] = 10

	;; Fill memory from end of data to 0xF000 with zero
	.repeat $1000-11
	.byte $00
	.endrep
	
	;; Put our code at 0xF000
	;; Set address to F000 (this is where our code will live)
	.ORG $F000    		
	LDA #0        ; load A register with 0
	LDX #0	      ; load X register with 0
LOOP:
	CPX $E000     ; compare value in X register with value at E000 (length of Array)
	BEQ DONE      ; if equal then jump to done
	ADC $E001,X   ; add value in memory  at M[0xE001 + X register] : A = A + Array[X]
	INX           ; X=X+1
	JMP LOOP      
DONE:
	BRK    
