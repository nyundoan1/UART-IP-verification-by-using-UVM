class reg_rw_test extends uart_base_test;
     `uvm_component_utils(reg_rw_test)

     function new(string name = "reg_rw_test", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual task run_phase(uvm_phase phase);
          bit [7:0]      rdata;
          bit [7:0]      wdata;
          uvm_status_e   status;
          
          phase.raise_objection(this);
          
          wdata = $random();
          regmodel.MDR.OSM_SEL.set(wdata[0]);
          regmodel.MDR.update(status);
          regmodel.MDR.read(status,rdata);
          if (rdata[0] != wdata[0])
               `uvm_error(get_type_name(), $sformatf( "The MDR register is update error! Exp: %h. Act: %h", wdata, rdata))

          wdata = $random();
          regmodel.DLL.DLL.set(wdata);
          regmodel.DLL.update(status);
          regmodel.DLL.read(status,rdata);
          if (rdata != wdata)
               `uvm_error(get_type_name(), $sformatf( "The DLL register is update error! Exp: %h. Act: %h", wdata, rdata))

          wdata = $random();
          regmodel.DLH.DLH.set(wdata);
          regmodel.DLH.update(status);
          regmodel.DLH.read(status,rdata);
          if (rdata != wdata)
               `uvm_error(get_type_name(), $sformatf( "The DLH register is update error! Exp: %h. Act: %h", wdata, rdata))

          wdata = $random();
          regmodel.LCR.WLS.set(wdata[1:0]);
          regmodel.LCR.STB.set(wdata[2]);
          regmodel.LCR.PEN.set(wdata[3]);
          regmodel.LCR.EPS.set(wdata[4]);
          regmodel.LCR.BGE.set(wdata[5]);
          regmodel.LCR.update(status);
          regmodel.LCR.read(status,rdata);
          if (rdata[5:0] != wdata[5:0])
               `uvm_error(get_type_name(), $sformatf( "The LCR register is update error! Exp: %h. Act: %h", wdata, rdata))

          wdata = $random();
          regmodel.IER.en_parity_error.set(wdata[4]);
          regmodel.IER.en_rx_fifo_empty.set(wdata[3]);
          regmodel.IER.en_rx_fifo_full.set(wdata[2]);
          regmodel.IER.en_tx_fifo_empty.set(wdata[1]);
          regmodel.IER.en_tx_fifo_full.set(wdata[0]);
          regmodel.IER.update(status);
          regmodel.IER.read(status,rdata);
          if (rdata[4:0] != wdata[4:0])
               `uvm_error(get_type_name(), $sformatf( "The IER register is update error! Exp: %h. Act: %h", wdata, rdata))

          wdata = $random();
          regmodel.TBR.tx_data.set(wdata);  
          regmodel.TBR.update(status);
          regmodel.TBR.read(status,rdata);
          if (rdata != 8'h00)
               `uvm_error(get_type_name(), $sformatf( "The TBR register is update error! Exp: %h. Act: %h", wdata, rdata))

          phase.drop_objection(this);
     endtask
endclass
