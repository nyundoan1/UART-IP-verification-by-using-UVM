class read_data_underfine_test extends uart_base_test;
     `uvm_component_utils(read_data_underfine_test)

     uart_configuration uart_config;

     function new(string name = "read_data_underfine_test", uvm_component parent);
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
          bit [31:0] division;
          bit [4:0] rdata;
          bit [7:0] rdata_fifo;
          uvm_status_e status;
               division = 100*10**6/(uart_config.baud_rate*13);

          `uvm_info(get_type_name(), $sformatf("Division: %d. Baud rate: %d", division, uart_config.baud_rate), UVM_LOW)
          phase.raise_objection(this);
               regmodel.MDR.write(status, {31'h00, 1'b1});
               regmodel.DLL.write(status, division[7:0]);
               regmodel.DLH.write(status, division[15:8]);
               regmodel.IER.write(status, 5'b0_1000);
               regmodel.FSR.read(status, rdata);
               if (rdata[3] == 1)
               begin 
                    regmodel.RBR.read(status, rdata_fifo);
                    if (rdata_fifo == 8'h00)
                         `uvm_info(get_type_name(), $sformatf("Read data will be underfine"), UVM_LOW)
                    else
                         `uvm_error(get_type_name(), $sformatf("Read data won't be underfine. Exp: %0h. Act: %0h", 8'h00, rdata_fifo))
               end
          #10ms;
          phase.drop_objection(this);
     endtask:run_phase

endclass: read_data_underfine_test

