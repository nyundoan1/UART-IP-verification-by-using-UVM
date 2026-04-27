class uart_base_test extends uvm_test;
     `uvm_component_utils(uart_base_test)

     uvm_report_server  svr;
     uart_reg_block      regmodel;
     time usr_timeout = 1s;

     virtual uart_if uart_vif;
     virtual ahb_if  ahb_vif;

     uart_environment uart_env;
     uart_configuration  uart_config;

     function new(string name="uart_base_test", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          `uvm_info("build_phase", "Entered...", UVM_HIGH)

          //Get lhs_if config db from testbench
          if (!uvm_config_db#(virtual uart_if)::get(this, "", "uart_vif", uart_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_vif from uvm_config_db"))
          if (!uvm_config_db#(virtual ahb_if)::get(this, "", "ahb_vif", ahb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get ahb_vif from uvm_config_db"))

          uvm_reg::include_coverage("uart_DLL_reg", UVM_CVR_ALL);
          uart_config = uart_configuration::type_id::create("uart_config");
          uart_env    = uart_environment::type_id::create("uart_env", this);
      
          if (!uart_config.randomize) 
               `uvm_fatal(get_type_name(), $sformatf("Fatal to randomize uart.config"))

          //Interface passed from base_test to environment
          uvm_config_db#(virtual uart_if)::set(this, "uart_env", "uart_vif", uart_vif);
          uvm_config_db#(virtual ahb_if)::set(this, "uart_env", "ahb_vif", ahb_vif);

          //Configuration DB passed from base_test to agent
          uvm_config_db#(uart_configuration)::set(this, "uart_env", "uart_config", uart_config);
          uvm_top.set_timeout(usr_timeout);
          
          `uvm_info("build_phase", "Exiting...", UVM_HIGH)
     endfunction: build_phase
     
     virtual function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          this.regmodel = uart_env.regmodel;
     endfunction: connect_phase 

     virtual function void end_of_elaboration_phase(uvm_phase phase);
          `uvm_info("end_of_elaboration_phase", "Entered...", UVM_HIGH)
          super.end_of_elaboration_phase(phase);
          uvm_top.print_topology();
          `uvm_info("end_of_elaboration_phase", "Exiting...", UVM_HIGH)
     endfunction: end_of_elaboration_phase

     virtual function void final_phase(uvm_phase phase);
          super.final_phase(phase);
          `uvm_info("final_phase", "Entered...", UVM_HIGH)
          svr = uvm_report_server::get_server();
          if (svr.get_severity_count(UVM_FATAL)+
               svr.get_severity_count(UVM_ERROR)) begin
               `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
               `uvm_info(get_type_name(), "----           TEST FAILED         ----", UVM_NONE)
               `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          end 
          else begin
               `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
               `uvm_info(get_type_name(), "----           TEST PASSED         ----", UVM_NONE)
               `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
          end 
          `uvm_info("final_phase","Exiting...",UVM_HIGH)
  endfunction: final_phase
endclass:uart_base_test
          

