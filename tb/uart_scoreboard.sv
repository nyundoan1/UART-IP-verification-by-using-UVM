`uvm_analysis_imp_decl(_uart_tx)
`uvm_analysis_imp_decl(_uart_rx)
`uvm_analysis_imp_decl(_ahb)

class uart_scoreboard extends uvm_scoreboard;
     `uvm_component_utils (uart_scoreboard)
     
     uvm_analysis_imp_uart_tx #(uart_transaction, uart_scoreboard) uart_tx_monitor_exp_tx;
     uvm_analysis_imp_uart_rx #(uart_transaction, uart_scoreboard) uart_rx_monitor_exp_rx;
     uvm_analysis_imp_ahb     #(ahb_transaction, uart_scoreboard) ahb_monitor_exp;
     
     uart_transaction uart_tx_queue[$];
     uart_transaction uart_rx_queue[$];
     ahb_transaction  ahb_tx_queue[$];
     ahb_transaction  ahb_rx_queue [$];

     uart_configuration  uart_config;

     `include "uart_coverage.sv" 
    // UART_IP uart_cov;
     function new (string name = "uart_scoreboard", uvm_component parent);
          super.new (name, parent);
          //uart_cov   = new();
          UART_IP = new();
     endfunction:new

     virtual function void build_phase (uvm_phase phase);
          super.build_phase (phase);

          if (!uvm_config_db#(uart_configuration)::get(this, "", "uart_config", uart_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_config from uvm_config_db"))

          uart_tx_monitor_exp_tx = new("uart_tx_monitor_exp_tx", this);
          uart_rx_monitor_exp_rx = new("uart_rx_monitor_exp_rx", this);
          ahb_monitor_exp = new("ahb_monitor_exp", this);
          `uvm_info(get_type_name(), $sformatf("Build_phase done!"), UVM_LOW)
     endfunction:build_phase
          
     virtual task run_phase(uvm_phase phase);
          
     endtask: run_phase

     virtual function void write_uart_tx (uart_transaction trans);
          `uvm_info(get_type_name(), $sformatf("Transmit data = %0h", trans.data), UVM_LOW)
          uart_tx_queue.push_back(trans);

     endfunction: write_uart_tx
     
     virtual function void write_ahb (ahb_transaction ahb_trans);
          uart_transaction tx_trans;
          ahb_transaction  ahb_tx_trans;
          bit [4:0] error = 0;
          `uvm_info(get_type_name(), $sformatf("AHB data = %0h", ahb_trans.data), UVM_LOW)
          if (ahb_trans.addr == 32'h18) 
               ahb_tx_queue.push_back(ahb_trans);
          else if (ahb_trans.addr == 32'h1C)
               ahb_rx_queue.push_back(ahb_trans);
          if (ahb_tx_trans != null)
               UART_IP.sample(ahb_tx_trans);
               //uart_cov.sample(ahb_tx_trans);
          if ((uart_tx_queue.size() > 0) && (ahb_rx_queue.size() >0)) begin
               tx_trans = uart_tx_queue.pop_front();
               ahb_tx_trans = ahb_rx_queue.pop_front();
               for (int i = 0; i < uart_config.data_width; i = i + 1)
                    if (tx_trans.data[i] != ahb_tx_trans.data[i]) 
                    begin
                         error +=1;
                         `uvm_error(get_type_name(), $sformatf("Received data not matching!. Exp: %0b. Act: %0b. Index: %0d", ahb_tx_trans.data, tx_trans.data, i))
                    end
               if (error != 0)
                    `uvm_info(get_type_name(), $sformatf("Data matching!"), UVM_LOW)
          end
     endfunction: write_ahb

     virtual function void write_uart_rx (uart_transaction trans);
          uart_transaction rx_trans;
          ahb_transaction  ahb_rx_trans;
          bit [4:0] error = 0;
          `uvm_info(get_type_name(), $sformatf("Received data = %0h", trans.data), UVM_HIGH)
          uart_rx_queue.push_back(trans);
          if ((uart_rx_queue.size() > 0) && (ahb_tx_queue.size() >0)) begin
               rx_trans = uart_rx_queue.pop_front();
               ahb_rx_trans = ahb_tx_queue.pop_front();
               for (int i = 0; i < uart_config.data_width; i = i + 1)
               if (rx_trans.data[i] != ahb_rx_trans.data[i])
               begin
                    error+=1;
                    `uvm_error(get_type_name(), $sformatf("Transmit data not matching! Exp: %0b. Act: %0b. Index: %0d", ahb_rx_trans.data, rx_trans.data, i))
               end
               if (error != 0)
                    `uvm_info(get_type_name(), $sformatf("Data matching!"), UVM_LOW)
          end 

     endfunction: write_uart_rx
     
endclass:uart_scoreboard
