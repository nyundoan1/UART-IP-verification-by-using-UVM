###  Overview
This project verifies a UART IP using UVM methodology based on a given design specification.  
The verification environment is built to validate both control path (AHB register interface) and data path (UART TX/RX communication).  

The goal is to ensure correct functionality, protocol compliance, and robustness of the UART IP under different configurations and scenarios.

---
##  Basic Specification

The UART IP includes the following main features:
<img width="710" height="402" alt="image" src="https://github.com/user-attachments/assets/84b2ee15-f601-43c8-b241-0fa6feb20d01" />


- **AHB-Lite Interface**
  - Supports register read/write access
  - Word transfer only

- **Baud Rate Generator**
  - Programmable divisor (DLL, DLH)
  - Supports 16x / 13x oversampling  

- **UART Protocol**
  - 1 start bit  
  - 5–8 data bits  
  - Optional parity (even/odd)  
  - 1 or 2 stop bits  

- **FIFO**
  - 16-byte TX FIFO  
  - 16-byte RX FIFO  

- **Interrupt**
  - TX FIFO empty/full  
  - RX FIFO empty/full  
  - Parity error  

- **Register Map**
  - MDR, DLL, DLH, LCR, IER, FSR, TBR, RBR  

 (All features derived from specification document)


---
##  Verification Plan (VPlan)

The verification plan is developed based on the UART specification and covers control path, data path, and corner cases.



#### 1. AHB Protocol Check (SVA)
- Use SystemVerilog Assertions (SVA) to verify AHB-Lite protocol:
  - Valid transfer sequence (HTRANS, HREADY)
  - Address and control signal stability
  - Write/read handshake correctness  
- Detect protocol violations automatically  



#### 2. Register Verification
- Read/Write all registers:
  - MDR, DLL, DLH, LCR, IER, FSR, TBR, RBR  
- Check reset values after reset  
- Verify reserved address behavior:
  - Read returns default value (0xFFFF_FFFF)  
  - Write has no effect  



#### 3. Oversampling Mode Verification

##### 3.1 Mode 13x
- TX only  
- RX only  

##### 3.2 Mode 16x
- TX only  
- RX only  

 Verify correct baud generation and sampling behavior in each mode  



#### 4. TX Path Verification (Combined Config)
- Verify transmission with different configurations:
  - Baud rate  
  - Data length (5–8 bits)  
  - Parity (even/odd/none)  
  - Stop bits (1 or 2)  

 Ensure correct frame format and serial output  



#### 5. RX Path Verification (Combined Config)
- Verify reception with different configurations:
  - Baud rate  
  - Data length  
  - Parity  
  - Stop bits  

 Ensure correct data capture and decoding  



#### 6. Concurrent TX/RX Verification (Full-Duplex)
- Verify UART operation when TX and RX occur simultaneously  

- Run TX and RX sequences in parallel using fork-join:
  - TX: continuously send data  
  - RX: simultaneously receive data  

- Check DUT behavior under concurrent conditions:
  - No data corruption  
  - No loss of data  
  - Correct timing handling  

- Scoreboard:
  - Independently track TX and RX streams  
  - Ensure data integrity for both directions  

- Stress scenarios:
  - Back-to-back transmission  
  - Continuous RX while TX active  
  - Mixed configuration (different frame/parity settings if supported)  



#### 7. Interrupt & Error Verification
- Verify interrupt generation:
  - TX FIFO empty/full  
  - RX FIFO empty/full  
  - Parity error  

- Error scenarios:
  - Parity error detection  
  - Invalid access handling  



#### 8. FIFO Behavior Verification
- TX FIFO:
  - Full / Empty conditions  
  - Write when full  

- RX FIFO:
  - Full / Empty conditions  
  - Read when empty  

- Check overflow / underflow behavior  


---
##  Testbench Structure

The verification environment follows UVM architecture:

<img width="2080" height="1136" alt="image" src="https://github.com/user-attachments/assets/e032457c-c270-467e-9ff2-a5b6f5af3d8f" />
