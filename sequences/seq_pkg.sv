package seq_pkg;
     import uvm_pkg::*;
     import ahb_pkg::*;
     import uart_pkg::*;

     `include "ahb_rw_sequence.sv"
     `include "ahb_write_sequence.sv"
     `include "uart_data_sequence.sv"
     `include "uart_random_sequence.sv"
endpackage: seq_pkg
