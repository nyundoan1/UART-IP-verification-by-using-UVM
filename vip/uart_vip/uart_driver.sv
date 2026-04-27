class uart_driver extends uvm_driver #(uart_transaction);
     `uvm_component_utils(uart_driver)

     virtual uart_if uart_vif;
     uart_configuration  uart_config;

     function new (string name="uart_driver", uvm_component parent);
          super.new(name,parent);
     endfunction: new

     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);

          if (!uvm_config_db#(virtual uart_if)::get(this, "", "uart_vif", uart_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_vif from uvm_config_db"))

          if (!uvm_config_db#(uart_configuration)::get(this, "", "uart_config", uart_config))
              `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_config from uvm_config_db"))

      endfunction:build_phase

      virtual task run_phase(uvm_phase phase);
          `uvm_info(get_type_name(), $sformatf("[Driver] UART Configuartion\n %s", uart_config.sprint()), UVM_LOW);
          forever begin
               uart_vif.tx = 1'b1;
               seq_item_port.get(req);
               drive(req);
               $cast(rsp, req.clone());
               rsp.set_id_info(req);
               seq_item_port.put(rsp);

          end
      endtask: run_phase

      task drive (uart_transaction req);
          int baud_rate_tmp;
          bit parity;
          bit [1:0] stop_bit;
          `uvm_info(get_type_name(), $sformatf("[Driver] Transmit data: %b", req.data[5:0]), UVM_LOW)
          baud_rate_tmp = (10**6)/uart_config.baud_rate;
          `uvm_info(get_type_name(), $sformatf("[Driver] Baud_rade_tmp: %d. Baud_rate configuration: %d", baud_rate_tmp, uart_config.baud_rate ), UVM_LOW)
          uart_vif.tx = 1'b0;
          #(baud_rate_tmp);
          for (int i = 0; i < uart_config.data_width; i = i + 1) begin
               uart_vif.tx = req.data[i];
              `uvm_info(get_type_name(), $sformatf("[Driver] Transmitting: %b", uart_vif.tx), UVM_LOW)
               parity = parity ^ req.data[i];
               #(baud_rate_tmp);
          end
          `uvm_info(get_type_name(), $sformatf("[Driver] Start of Parity bit. Parity: %p", uart_config.parity_mode), UVM_LOW)
          if (uart_config.parity_mode == uart_configuration::NONE)
          begin
               uart_vif.tx = 1'b1;
               #(uart_config.num_of_stop_bit * baud_rate_tmp);
          end
          else if (uart_config.parity_mode == uart_configuration::EVEN) begin
               uart_vif.tx = parity;
                #(baud_rate_tmp);
                uart_vif.tx = 1'b1;
                `uvm_info(get_type_name(), $sformatf("[Driver] Parity: %b. Num of stop bit: %2d", uart_vif.tx, uart_config.num_of_stop_bit), UVM_LOW)
                #(uart_config.num_of_stop_bit * baud_rate_tmp);
          end
          else if (uart_config.parity_mode == uart_configuration::ODD) begin
               uart_vif.tx = ~parity;
               #(baud_rate_tmp);
               uart_vif.tx = 1'b1;
               `uvm_info(get_type_name(), $sformatf("[Driver] Parity: %b. Num of stop bit: %2d", uart_vif.tx, uart_config.num_of_stop_bit), UVM_LOW)
               #(uart_config.num_of_stop_bit * baud_rate_tmp);
          end
          else
          `uvm_fatal(get_type_name(), $sformatf("[Driver] Failed to transmit parity and stop bit"))
          `uvm_info(get_type_name(), $sformatf("[Driver] End of transmit data"), UVM_LOW)
               
     endtask
endclass:uart_driver
