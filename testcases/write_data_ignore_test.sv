class write_data_ignore_test extends uart_base_test;
     `uvm_component_utils(write_data_ignore_test)

     uart_configuration uart_config;

     function new(string name = "write_data_ignore_test", uvm_component parent);
          super.new(name, parent);
     endfunction

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);

          uart_config = uart_configuration::type_id::create("uart_config");

          uart_config.randomize() with { direction_mode == uart_configuration::TRANS;
                                         data_width     == 4'd8;
                                         parity_mode    == uart_configuration::EVEN;
                                         num_of_stop_bit == 2'd1;
                                         baud_rate      == 2401;};

          `uvm_info(get_type_name(), $sformatf("Baud rate in uart configuration: %d", uart_config.sprint()), UVM_LOW)
          uvm_config_db#(uart_configuration)::set(this, "uart_env", "uart_config", uart_config);
     endfunction: build_phase

     virtual task run_phase(uvm_phase phase);
          bit [31:0] division;
          bit [7:0] wdata1;
          bit [7:0] wdata;
          bit [4:0] rdata;
          bit [7:0] rdata_fifo;
          uvm_status_e status;
          if (wdata[0])
               division = 100*10**6/(uart_config.baud_rate*13);
          else
               division = 100*10**6/(uart_config.baud_rate*16);

          `uvm_info(get_type_name(), $sformatf("Division: %d. Baud rate: %d", division, uart_config.baud_rate), UVM_LOW)
          phase.raise_objection(this);
               regmodel.MDR.write(status, {31'h00, wdata[0]});
               regmodel.DLL.write(status, division[7:0]);
               regmodel.DLH.write(status, division[15:8]);
               regmodel.IER.write(status, 5'b0_0001);
               wdata1 = 8'hFF;
               regmodel.TBR.write(status, wdata1);
               `uvm_info(get_type_name(), $sformatf("Write data in TBR register: %0h", wdata1), UVM_LOW);
               for (int i = 0; i <= 16; i++)
               begin
                    wdata = $urandom_range(0,8'hFE);
                    regmodel.TBR.write(status, wdata);
                    `uvm_info(get_type_name(), $sformatf("Write data in TBR register: %0h", wdata), UVM_LOW);
               end 
               regmodel.LCR.write(status, {26'b0, 1'b1, 1'b1, 1'b1, 1'b0, 2'b11});
          #10ms;
          phase.drop_objection(this);
     endtask:run_phase

endclass: write_data_ignore_test

