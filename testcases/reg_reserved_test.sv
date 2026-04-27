class reg_reserved_test extends uart_base_test;
     `uvm_component_utils(reg_reserved_test)

     ahb_rw_sequence rw_seq;

     function new(string name="reg_reserved_test", uvm_component parent);
          super.new(name, parent);
     endfunction: new

     virtual task run_phase(uvm_phase phase);
          phase.raise_objection(this);

          rw_seq = ahb_rw_sequence::type_id::create("rw_seq");
          rw_seq.start(uart_env.ahb_agt.sequencer);

          phase.drop_objection(this);
     endtask
endclass

