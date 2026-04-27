//=============================================================================
// Project       : UART VIP
//=============================================================================
// Filename      : test_pkg.sv
// Author        : Huy Nguyen
// Company       : NO
// Date          : 20-Dec-2021
//=============================================================================
// Description   : 
//
//
//
//=============================================================================
`ifndef GUARD_UART_TEST_PKG__SV
`define GUARD_UART_TEST_PKG__SV

package test_pkg;
  import uvm_pkg::*;
  import ahb_pkg::*;
  import uart_pkg::*;
  import seq_pkg::*;
  import env_pkg::*;
  import uart_regmodel_pkg::*;

  `include "uart_base_test.sv"
  
  `include "reg_def_test.sv"
  `include "reg_rw_test.sv"
  `include "reg_rs_test.sv"
  `include "reg_reserved_test.sv"

  `include "mode_13_tx_test.sv"
  `include "mode_13_rx_test.sv"
  `include "mode_16_tx_test.sv"
  `include "mode_16_rx_test.sv"

  `include "tx_5_bit_no_parity_1_stop_test.sv"
  `include "tx_5_bit_no_parity_2_stop_test.sv"
  `include "tx_5_bit_even_parity_1_stop_test.sv"
  `include "tx_5_bit_even_parity_2_stop_test.sv"
  `include "tx_5_bit_odd_parity_1_stop_test.sv"
  `include "tx_5_bit_odd_parity_2_stop_test.sv"

  `include "tx_6_bit_no_parity_1_stop_test.sv"
  `include "tx_6_bit_no_parity_2_stop_test.sv"
  `include "tx_6_bit_even_parity_1_stop_test.sv"
  `include "tx_6_bit_even_parity_2_stop_test.sv"
  `include "tx_6_bit_odd_parity_1_stop_test.sv"
  `include "tx_6_bit_odd_parity_2_stop_test.sv"

  `include "tx_7_bit_no_parity_1_stop_test.sv"
  `include "tx_7_bit_no_parity_2_stop_test.sv"
  `include "tx_7_bit_even_parity_1_stop_test.sv"
  `include "tx_7_bit_even_parity_2_stop_test.sv"
  `include "tx_7_bit_odd_parity_1_stop_test.sv"
  `include "tx_7_bit_odd_parity_2_stop_test.sv"

  `include "tx_8_bit_no_parity_1_stop_test.sv"
  `include "tx_8_bit_no_parity_2_stop_test.sv"
  `include "tx_8_bit_even_parity_1_stop_test.sv"
  `include "tx_8_bit_even_parity_2_stop_test.sv"
  `include "tx_8_bit_odd_parity_1_stop_test.sv"
  `include "tx_8_bit_odd_parity_2_stop_test.sv"
  `include "tx_multiple_random_all_test.sv"

  `include "rx_5_bit_no_parity_1_stop_test.sv"
  `include "rx_5_bit_no_parity_2_stop_test.sv"
  `include "rx_5_bit_even_parity_1_stop_test.sv"
  `include "rx_5_bit_even_parity_2_stop_test.sv"
  `include "rx_5_bit_odd_parity_1_stop_test.sv"
  `include "rx_5_bit_odd_parity_2_stop_test.sv"

  `include "rx_6_bit_no_parity_1_stop_test.sv"
  `include "rx_6_bit_no_parity_2_stop_test.sv"
  `include "rx_6_bit_even_parity_1_stop_test.sv"
  `include "rx_6_bit_even_parity_2_stop_test.sv"
  `include "rx_6_bit_odd_parity_1_stop_test.sv"
  `include "rx_6_bit_odd_parity_2_stop_test.sv"

  `include "rx_7_bit_no_parity_1_stop_test.sv"
  `include "rx_7_bit_no_parity_2_stop_test.sv"
  `include "rx_7_bit_even_parity_1_stop_test.sv"
  `include "rx_7_bit_even_parity_2_stop_test.sv"
  `include "rx_7_bit_odd_parity_1_stop_test.sv"
  `include "rx_7_bit_odd_parity_2_stop_test.sv"

  `include "rx_8_bit_no_parity_1_stop_test.sv"
  `include "rx_8_bit_no_parity_2_stop_test.sv"
  `include "rx_8_bit_even_parity_1_stop_test.sv"
  `include "rx_8_bit_even_parity_2_stop_test.sv"
  `include "rx_8_bit_odd_parity_1_stop_test.sv"
  `include "rx_8_bit_odd_parity_2_stop_test.sv"
  `include "rx_multiple_random_all_test.sv"

  `include "full_5_bit_no_parity_1_stop_test.sv"
  `include "full_5_bit_no_parity_2_stop_test.sv"
  `include "full_5_bit_even_parity_1_stop_test.sv"
  `include "full_5_bit_even_parity_2_stop_test.sv"
  `include "full_5_bit_odd_parity_1_stop_test.sv"
  `include "full_5_bit_odd_parity_2_stop_test.sv"

  `include "full_6_bit_no_parity_1_stop_test.sv"
  `include "full_6_bit_no_parity_2_stop_test.sv"
  `include "full_6_bit_even_parity_1_stop_test.sv"
  `include "full_6_bit_even_parity_2_stop_test.sv"
  `include "full_6_bit_odd_parity_1_stop_test.sv"
  `include "full_6_bit_odd_parity_2_stop_test.sv"

  `include "full_7_bit_no_parity_1_stop_test.sv"
  `include "full_7_bit_no_parity_2_stop_test.sv"
  `include "full_7_bit_even_parity_1_stop_test.sv"
  `include "full_7_bit_even_parity_2_stop_test.sv"
  `include "full_7_bit_odd_parity_1_stop_test.sv"
  `include "full_7_bit_odd_parity_2_stop_test.sv"

  `include "full_8_bit_no_parity_1_stop_test.sv"
  `include "full_8_bit_no_parity_2_stop_test.sv"
  `include "full_8_bit_even_parity_1_stop_test.sv"
  `include "full_8_bit_even_parity_2_stop_test.sv"
  `include "full_8_bit_odd_parity_1_stop_test.sv"
  `include "full_8_bit_odd_parity_2_stop_test.sv"
  `include "full_multiple_random_all_test.sv"

  `include "interrupt_tx_full_test.sv"
  `include "interrupt_tx_empty_test.sv"
  `include "interrupt_rx_full_test.sv"
  `include "interrupt_rx_empty_test.sv"
  `include "interrupt_parity_error_test.sv"

  `include "write_data_ignore_test.sv"
  `include "read_data_underfine_test.sv"
endpackage: test_pkg

`endif


