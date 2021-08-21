import numpy as np

class SLS6502:
    """The Secrect Life of Software 6502 Simulated Computer"""
    class CPU:
        """ The CPU """
        class Pin:
            def __init__(self,v):
                self._value = v
                
            def set(self, v):
                self._value = v
            
            def get(self):
                return self._value
            
        class Register: 
            def get(self):
                    return self._value
            def set(self, v):
                    self._value = v
                    
        class Register8Bit (Register):
            def __init__(self):
                _value = np.uint8(0)
        
        class Register16Bit (Register):
            def __init_(self):
                _value = np.uint16(0)
        
        class RegisterProcessorStatus(Register8Bit):
            # b_0 : C  
            def setZero(self,z=True): 
                x = self.get()
          
        def __init__(self):
            # ISA Registers
            self._A  = self.Register8Bit()  # Accumulator A
            self._X  = self.Register8Bit()  # Index Register X 
            self._Y  = self.Register8Bit()  # Index Register Y
            self._PC = self.Register16Bit() # Program Counter PC
            self._S  = self.Register8Bit()  # Stack Pointer S
            self._P  = self.RegisterProcessorStatus() # Processor Status Register P
            
            # internal Registers used to connect
            # to address bus and DataBus
            self._DBR = self.Register8Bit()
            self._ABB = self.Register16Bit()
            
            # Pins -- we do not simulate a clock
            #         so the only pins we care about
            #         are those for inputs other than data
            self.RESB = self.Pin(False)    # Reset  Bar 
            self.IRQB = self.Pin(True)     # Interrupt Request Bar
            self.NMIB = self.Pin(True)     # Non-maskable Interrupt Bar

            
 
        def reset(self):
            print("reset")
            
        
        def loop(self, count=1):
            # process input pins
            
            # fetch
            self.fetch()
            
            # decode
            self.decode()
            
            # execute
            
    class MemoryObject:
        """ Memory """
        def read(self):
            
    class MemmoryController:
        """ Memory Controller """
        def attach(self, addrTuple, memObject):
            
        def read(addr):
        
        def write(addr,v):
            
    # constructor
    def __init__(self):
        self.cpu        = self.CPU()
        self.memCtlr    = self.MemoryController()
        

