class uart_monitor extends uvm_monitor;
`uvm_component_utils(uart_monitor)

     virtual uart_if uart_vif ;
     uart_configuration  uart_config;

     uart_transaction trans_tx;
     uart_transaction trans_rx;
     uvm_analysis_port #(uart_transaction) monitor_tx;
     uvm_analysis_port #(uart_transaction) monitor_rx;

     function new (string name="uart_monitor", uvm_component parent);
          super.new(name,parent);
          monitor_tx = new("monitor_tx", this);
          monitor_rx = new("monitor_rx", this);

          trans_tx = new();
          trans_rx = new();
     endfunction: new

     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);

          if (!uvm_config_db#(virtual uart_if)::get(this, "", "uart_vif", uart_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_vif from uvm_config_db"))
          
          if (!uvm_config_db#(uart_configuration)::get(this, "", "uart_config", uart_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_config from uvm_config_db"))
     endfunction: build_phase

     virtual task run_phase(uvm_phase phase);
          fork  
               capture_tx();
               capture_rx();
          join
     endtask:run_phase

     task capture_tx();
          int baud_rate_tmp;
          bit parity_check;

          forever begin
          parity_check = 1'b0;
          baud_rate_tmp = (10**9)/uart_config.baud_rate;
          `uvm_info(get_type_name(), $sformatf("uart configuaration: \n%s", uart_config.sprint()), UVM_LOW)
          wait (uart_vif.tx == 0);
          #(3*baud_rate_tmp/2);
          `uvm_info(get_type_name(), $sformatf("[MONITOR] Capture data in TX"), UVM_LOW)
          for (int i = 0; i < uart_config.data_width; i = i + 1) begin     
               trans_tx.data[i] = uart_vif.tx;
               parity_check = parity_check ^ uart_vif.tx;
               #(baud_rate_tmp);
               `uvm_info(get_type_name(), $sformatf("[Monitor] Capture data in TX at index [%1d]: %p", i, trans_tx.data[i]), UVM_LOW)
          end
          if (uart_config.parity_mode == uart_configuration::EVEN)
          begin
               if (parity_check == uart_vif.tx)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Parity is corrected!"), UVM_LOW)
               else
                    `uvm_error(get_type_name(), $sformatf("[Monitor] EVEN Parity is not corrected! Data: %0b. Parity: %0b. uart_vif.tx: %0b", trans_tx.data, parity_check, uart_vif.tx))
               #(baud_rate_tmp);
          end
          else if (uart_config.parity_mode == uart_configuration::ODD) begin
               if (parity_check != uart_vif.tx)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Parity is corrected!"), UVM_LOW)
               else
                    `uvm_error(get_type_name(), $sformatf("[Monitor] ODD Parity is not corrected! Data: %b. Parity: %0b. uart_vif.tx: %0b", trans_tx.data, parity_check, uart_vif.tx))
               #(baud_rate_tmp);
         end
          if (uart_vif.tx == 1'b0)
               `uvm_error(get_type_name(), $sformatf("[Monitor] Stop bit is not corrected!"))
          else 
               if (uart_config.num_of_stop_bit == 1'd1)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Stop bit is corrected!"), UVM_LOW)
          if (uart_config.num_of_stop_bit == 2'd2)
          begin
               #(baud_rate_tmp);
               if (uart_vif.tx == 1'b1)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Stop bit is corrected!"), UVM_LOW)
               else
                    `uvm_error(get_type_name(), $sformatf("[Monitor] Stop bit is not corrected!"))
          end
          `uvm_info(get_type_name(), $sformatf("[MONITOR] Capture data in TX: %b", trans_tx.data), UVM_LOW)
          monitor_tx.write(trans_tx);
          end
    endtask
    task capture_rx();
          int baud_rate_tmp   ;
          bit parity_check    ;
          
          forever begin 
          parity_check = 1'b0;
          baud_rate_tmp = (10**9)/uart_config.baud_rate ;
          wait(uart_vif.rx == 0);
          `uvm_info(get_type_name(), $sformatf("uart configuaration: \n%s", uart_config.sprint()), UVM_LOW)
          //`uvm_info(get_type_name(), $sformatf("Baud rate tmp : %0d. Baud rate: %0d", baud_rate_tmp, uart_config.baud_rate), UVM_LOW)
          #(3*baud_rate_tmp/2);
          
          `uvm_info(get_type_name(), $sformatf("[MONITOR] Capture data in RX"), UVM_LOW)
          for (int i = 0; i < uart_config.data_width; i = i + 1) begin
               trans_rx.data[i] = uart_vif.rx;
               parity_check = parity_check ^ uart_vif.rx;
               `uvm_info(get_type_name(), $sformatf("[Monitor] Capture data in RX at index [%1d]: %p", i, trans_rx.data[i]), UVM_LOW)
               #(baud_rate_tmp);
          end
          if ((trans_rx.data == 8'hFF) && (uart_config.parity_mode == uart_configuration::EVEN) && (uart_config.data_width == 4'd8) && (uart_config.num_of_stop_bit == 2'd1) && (uart_config.baud_rate == 2401))
               `uvm_info(get_type_name(), $sformatf("[Monitor] Write data will be ignore!"), UVM_LOW) 
          else
               `uvm_error(get_type_name(), $sformatf("[Monitor] Write data won't be ignore!"))
          if (uart_config.parity_mode == uart_configuration::EVEN)
          begin
               if (parity_check == uart_vif.rx)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Parity is corrected!"), UVM_LOW)
               else
                    `uvm_error(get_type_name(), $sformatf("[Monitor] EVEN Parity is not corrected! Data: %b. Parity: %0b. uart_vif.rx = %0b", trans_rx.data, parity_check, uart_vif.rx))
               #(baud_rate_tmp);
          end
          else if (uart_config.parity_mode == uart_configuration::ODD) begin
               if (parity_check != uart_vif.rx)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Parity is corrected!"), UVM_LOW)
               else
                    `uvm_error(get_type_name(), $sformatf("[Monitor] ODD Parity is not corrected! Data: %b. Parity: %0b. uart_vif.rx = %0b", trans_rx.data, parity_check, uart_vif.rx))
               #(baud_rate_tmp);
          end
          if (uart_vif.tx == 1'b0)
               `uvm_error(get_type_name(), $sformatf("[Monitor] Stop bit is not corrected!"))
          else
               if (uart_config.num_of_stop_bit == 1'd1)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Stop bit is corrected!"), UVM_LOW)

          if (uart_config.num_of_stop_bit == 2'd2)
          begin
               #(baud_rate_tmp);
               if (uart_vif.rx == 1'b1)
                    `uvm_info(get_type_name(), $sformatf("[Monitor] Stop bit is corrected!"), UVM_LOW)
               else
                    `uvm_error(get_type_name(), $sformatf("[Monitor] Stop bit is not corrected!"))
          end
          monitor_rx.write(trans_rx);
          `uvm_info(get_type_name(), $sformatf("[MONITOR] Capture data in RX: %b", trans_rx.data), UVM_LOW)
          `uvm_info(get_type_name(), $sformatf("[MONITOR] End of Capture RX"), UVM_LOW)
          end
  endtask
endclass:uart_monitor
