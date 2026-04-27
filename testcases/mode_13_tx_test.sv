class mode_13_tx_test extends uart_base_test;
     `uvm_component_utils(mode_13_tx_test)

     uart_configuration uart_config;

     function new(string name = "mode_13_tx_test", uvm_component parent);
          super.new(name, parent);
     endfunction

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);

          uart_config = uart_configuration::type_id::create("uart_config");

          uart_config.randomize() with { direction_mode == uart_configuration::TRANS;
                                         parity_mode    == uart_configuration::EVEN;
                                         num_of_stop_bit == 2'd2;
                                         data_width      == 4'd8;};

          `uvm_info(get_type_name(), $sformatf("Baud rate in uart configuration: %d", uart_config.sprint()), UVM_LOW)
          uvm_config_db#(uart_configuration)::set(this, "uart_env", "uart_config", uart_config);
     endfunction: build_phase

     virtual task run_phase(uvm_phase phase);
          bit [31:0] division;
          bit [7:0] wdata;
          uvm_status_e status;
          division = 100*10**6/(uart_config.baud_rate*13);
          `uvm_info(get_type_name(), $sformatf("Division: %d. Baud rate: %d", division, uart_config.baud_rate), UVM_LOW)
          phase.raise_objection(this);
          wdata = $random;
          regmodel.MDR.write(status,32'h1);
          regmodel.DLL.write(status, division[7:0]);
          regmodel.DLH.write(status, division[15:8]);
          regmodel.LCR.write(status, 32'h3F);
          regmodel.TBR.write(status, wdata);

          #10ms;
          phase.drop_objection(this);
     endtask:run_phase

endclass: mode_13_tx_test
