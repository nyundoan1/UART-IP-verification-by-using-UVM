class uart_data_sequence extends uvm_sequence #(uart_transaction);
     `uvm_object_utils(uart_data_sequence)

     function new(string name = "uart_data_sequence");
          super.new(name);
     endfunction: new

     virtual task body();
          req = uart_transaction::type_id::create("req");
          start_item(req);
          if (!req.randomize())
               `uvm_fatal(get_type_name(), $sformatf("Fatal to randomize req"))
          `uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
          finish_item(req);
          get_response(rsp);
          #1us;
          //`uvm_info(get_type_name(), $sformatf("Received rsp to driver: \n %s", rsp.sprint()), UVM_LOW);
     endtask
endclass
