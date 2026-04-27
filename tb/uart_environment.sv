class uart_environment extends uvm_env;
     `uvm_component_utils(uart_environment)

     virtual ahb_if ahb_vif;
     virtual uart_if uart_vif;

     uart_scoreboard     uart_sb;
     uart_agent          uart_agt;
     ahb_agent           ahb_agt;
     uart_configuration  uart_config;

     uart_reg_block       regmodel;
     uart_reg2ahb_adapter ahb_adapter;

     uvm_reg_predictor #(ahb_transaction) ahb_predictor;

     function new(string name = "uart_environment", uvm_component parent);
          super.new(name, parent);
     endfunction:new

     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          
          if (!uvm_config_db#(virtual ahb_if)::get(this,"","ahb_vif", ahb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get ahb_vif from uvm_config_db"))
          if (!uvm_config_db#(virtual uart_if)::get(this,"","uart_vif", uart_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_vif from uvm_config_db"))
          if (!uvm_config_db#(uart_configuration)::get(this,"", "uart_config", uart_config))
               `uvm_fatal(get_type_name(), $sformatf("Failed to get uart_configuration from uvm_config_db"))

          uart_sb  = uart_scoreboard::type_id::create("uart_sb", this);
          uart_agt = uart_agent::type_id::create("uart_agt", this);
          ahb_agt  = ahb_agent::type_id::create("ahb_agt", this);

          ahb_adapter = uart_reg2ahb_adapter::type_id::create("ahb_adapter");
          regmodel    = uart_reg_block::type_id::create("regmodel", this);
          regmodel.build();

          ahb_predictor = uvm_reg_predictor#(ahb_transaction)::type_id::create("ahb_predictor", this);

          uvm_config_db#(virtual ahb_if)::set(this, "ahb_agt", "ahb_vif", ahb_vif);
          uvm_config_db#(virtual uart_if)::set(this, "uart_agt", "uart_vif", uart_vif);
          uvm_config_db#(uart_configuration)::set(this, "uart_agt", "uart_config", uart_config);
          uvm_config_db#(uart_configuration)::set(this, "uart_sb", "uart_config", uart_config);
          `uvm_info("build_phase", "Exiting...", UVM_HIGH);
     endfunction:build_phase

     virtual function void connect_phase (uvm_phase phase);
          super.connect_phase(phase);
          `uvm_info("connect_phase", "Entered...", UVM_HIGH)

          if (regmodel.get_parent() == null)
               regmodel.ahb_map.set_sequencer(ahb_agt.sequencer, ahb_adapter);

          ahb_predictor.map = regmodel.ahb_map;
          ahb_predictor.adapter = ahb_adapter;
          ahb_agt.monitor.item_observed_port.connect(ahb_predictor.bus_in);

          uart_agt.uart_mni.monitor_tx.connect(uart_sb.uart_tx_monitor_exp_tx);
          uart_agt.uart_mni.monitor_rx.connect(uart_sb.uart_rx_monitor_exp_rx);
          ahb_agt.monitor.item_observed_port.connect(uart_sb.ahb_monitor_exp);

          `uvm_info("connect_phase", "Exiting...", UVM_HIGH)
     endfunction:connect_phase
endclass:uart_environment

          
