class uart_random_sequence extends uvm_sequence #(uart_transaction);
     `uvm_object_utils(uart_random_sequence)

     function new(string name = "uart_random_sequence");
          super.new(name);
     endfunction: new

     virtual task body();
          req = uart_transaction::type_id::create("req");
          start_item(req);
          req.randomize() with {data == 8'b1001_1101;};
          `uvm_info(get_type_name(), $sformatf("Send req to driver: \n %s", req.sprint()), UVM_LOW);
          finish_item(req);
          get_response(rsp);
          #1us;
          //`uvm_info(get_type_name(), $sformatf("Received rsp to driver: \n %s", rsp.sprint()), UVM_LOW);
     endtask
endclass
