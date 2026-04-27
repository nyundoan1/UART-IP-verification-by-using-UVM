class interrupt_parity_error_test extends uart_base_test;
     `uvm_component_utils(interrupt_parity_error_test)

     uart_configuration uart_config;
     uart_random_sequence  uart_rd_seq;

     function new(string name = "interrupt_parity_error_test", uvm_component parent);
          super.new(name, parent);
     endfunction

     virtual function void build_phase (uvm_phase phase);
          super.build_phase(phase);

          uart_config = uart_configuration::type_id::create("uart_config");

          uart_config.randomize() with { direction_mode == uart_configuration::REV;
                                         parity_mode    == uart_configuration::ODD;
                                         baud_rate      == 32'hFAA2;
                                         data_width     == 32'h7;
                                         num_of_stop_bit == 2'd1;};

          `uvm_info(get_type_name(), $sformatf("Baud rate in uart configuration: %d", uart_config.sprint()), UVM_LOW)
          uvm_config_db#(uart_configuration)::set(this, "uart_env", "uart_config", uart_config);
     endfunction: build_phase

     virtual task run_phase(uvm_phase phase);
          bit [31:0] division;
          bit [7:0] wdata;
          bit set_stop;
          bit [4:0] rdata;
          bit [1:0] set_dataframe;
          uvm_status_e status;
          wdata = $random;
          if (wdata[0])
               division = 100*10**6/(uart_config.baud_rate*13);
          else
               division = 100*10**6/(uart_config.baud_rate*16);
          case (uart_config.data_width)
               4'd5: set_dataframe = 2'b00;
               4'd6: set_dataframe = 2'b01;
               4'd7: set_dataframe = 2'b10;
               4'd8: set_dataframe = 2'b11;
               default: set_dataframe = 2'b00;
          endcase
          case (uart_config.num_of_stop_bit)
               2'd1: set_stop = 1'b0;
               2'd2: set_stop = 1'b1;
               default: set_stop = 1'b0;
          endcase               

          `uvm_info(get_type_name(), $sformatf("Division: %d. Baud rate: %d", division, uart_config.baud_rate), UVM_LOW)
          phase.raise_objection(this);
               regmodel.MDR.write(status, {31'h00, wdata[0]});
               regmodel.DLL.write(status, division[7:0]);
               regmodel.DLH.write(status, division[15:8]);
               regmodel.LCR.write(status, 32'h29);
               regmodel.IER.write(status, 5'b1_0000);
               uart_rd_seq = uart_random_sequence::type_id::create("uart_rd_seq");
               uart_rd_seq.start(uart_env.uart_agt.uart_seq);
               #5ms;

               regmodel.FSR.read(status, rdata);
               if (rdata != 5'b1_1000)
                    `uvm_error(get_type_name(), $sformatf("Interrupt parity error is not assert"))
          #10ms;
          phase.drop_objection(this);
     endtask:run_phase

endclass: interrupt_parity_error_test

