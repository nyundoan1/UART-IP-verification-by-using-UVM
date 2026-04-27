class ahb_rw_sequence extends uvm_sequence #(ahb_transaction);
  `uvm_object_utils(ahb_rw_sequence)

  function new(string name="ahb_rw_sequence");
    super.new(name);
  endfunction

  virtual task body();
    bit [31:0] wdata;
    bit [31:0] addr_tmp;
      
      req = ahb_transaction::type_id::create("req");
      start_item(req);
      wdata = $urandom;
      addr_tmp = $urandom_range(32'h20, 32'h3FF);
      req.randomize() with {addr        == addr_tmp;
                            data        == wdata;
                            xact_type   == ahb_transaction::WRITE;
                            burst_type  == ahb_transaction::SINGLE;
                            xfer_size   == ahb_transaction::SIZE_32BIT;};
      `uvm_info(get_type_name(),$sformatf("Send req to driver: \n %s",req.sprint()),UVM_LOW);
      finish_item(req);
      get_response(rsp);

      //Read transfer
      req = ahb_transaction::type_id::create("req");
      start_item(req);
      req.randomize() with {addr        == addr_tmp;
                            xact_type   == ahb_transaction::READ;
                            burst_type  == ahb_transaction::SINGLE;
                            xfer_size   == ahb_transaction::SIZE_32BIT;};
      `uvm_info(get_type_name(),$sformatf("Send req to driver: \n %s",req.sprint()),UVM_LOW);
      finish_item(req);
      get_response(rsp);
    #1us;
    `uvm_info(get_type_name(),$sformatf("Recevied rsp to driver: \n %s",rsp.sprint()),UVM_LOW);
  endtask

endclass

