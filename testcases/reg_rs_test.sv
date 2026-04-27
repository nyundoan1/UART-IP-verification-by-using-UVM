class reg_rs_test extends uart_base_test;
     `uvm_component_utils(reg_rs_test)

     virtual ahb_if ahb_vif;

     function new(string name = "reg_rs_test", uvm_component parent);
          super.new(name, parent);
     endfunction: new
     
     virtual function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          `uvm_info("build_phase", "Entered...", UVM_HIGH)

          if (!uvm_config_db#(virtual ahb_if)::get(this,"", "ahb_vif", ahb_vif))
               `uvm_fatal(get_type_name(), $sformatf("Failded to get ahb_vif from uvm_config_db"))
          
          `uvm_info("build_phase", "Exiting...", UVM_HIGH)
     endfunction:build_phase

     virtual task run_phase(uvm_phase phase);
          bit [7:0]      rdata;
          bit [7:0]      wdata;
          uvm_status_e   status;
          
          uvm_reg_hw_reset_seq default_register_seq = uvm_reg_hw_reset_seq::type_id::create("default_register_seq");
          uvm_reg_bit_bash_seq bit_bash_seq         = uvm_reg_bit_bash_seq::type_id::create("bit_bash_seq");

          phase.raise_objection(this);
          
          wdata = $random();
          regmodel.MDR.OSM_SEL.set(wdata[0]);
          regmodel.MDR.update(status);

          wdata = $random();
          regmodel.DLL.DLL.set(wdata);
          regmodel.DLL.update(status);

          wdata = $random();
          regmodel.DLH.DLH.set(wdata);
          regmodel.DLH.update(status);

          wdata = $random();
          regmodel.LCR.WLS.set(wdata[1:0]);
          regmodel.LCR.STB.set(wdata[2]);
          regmodel.LCR.PEN.set(wdata[3]);
          regmodel.LCR.EPS.set(wdata[4]);
          regmodel.LCR.BGE.set(wdata[5]);
          regmodel.LCR.update(status);

          wdata = $random();
          regmodel.IER.en_parity_error.set(wdata[4]);
          regmodel.IER.en_rx_fifo_empty.set(wdata[3]);
          regmodel.IER.en_rx_fifo_full.set(wdata[2]);
          regmodel.IER.en_tx_fifo_empty.set(wdata[1]);
          regmodel.IER.en_tx_fifo_full.set(wdata[0]);
          regmodel.IER.update(status);

          wdata = $random();
          regmodel.TBR.tx_data.set(wdata);  
          regmodel.TBR.update(status);
          
          @(posedge ahb_vif.HCLK);
          ahb_vif.HRESETn = 1'b0;
          @(posedge ahb_vif.HCLK);
          ahb_vif.HRESETn = 1'b1;

          default_register_seq.model = regmodel;
          bit_bash_seq.model         = regmodel;

          default_register_seq.start(null);
          bit_bash_seq.start(null);

          phase.drop_objection(this);
     endtask
endclass
