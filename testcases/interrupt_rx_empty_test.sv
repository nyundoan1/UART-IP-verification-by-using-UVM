class interrupt_rx_empty_test extends uart_base_test;
     `uvm_component_utils(interrupt_rx_empty_test)

     uart_configuration uart_config;

     function new(string name = "interrupt_rx_empty_test", uvm_component parent);
          super.new(name, parent);
     endfunction

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);

          uart_config = uart_configuration::type_id::create("uart_config");

          uart_config.randomize() with { direction_mode == uart_configuration::REV;};

          `uvm_info(get_type_name(), $sformatf("Baud rate in uart configuration: %d", uart_config.sprint()), UVM_LOW)
          uvm_config_db#(uart_configuration)::set(this, "uart_env", "uart_config", uart_config);
     endfunction: build_phase

     virtual task run_phase(uvm_phase phase);
          bit [4:0] rdata;
          uvm_status_e status;

          phase.raise_objection(this);
               regmodel.IER.write(status, 5'b0_1000);
               regmodel.FSR.read(status, rdata);
               if (rdata != 5'b0_1010)
                    `uvm_error(get_type_name(), $sformatf("Interrupt rx fifo empty is not assert"))
          #10ms;
          phase.drop_objection(this);
     endtask:run_phase

endclass: interrupt_rx_empty_test

