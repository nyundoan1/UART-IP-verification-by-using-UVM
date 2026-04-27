class reg_def_test extends uart_base_test;
  `uvm_component_utils(reg_def_test)

  function new(string name="reg_def_test", uvm_component parent);
    super.new(name,parent);
  endfunction: new 

  virtual task run_phase(uvm_phase phase);
     uvm_reg_hw_reset_seq default_register_seq = uvm_reg_hw_reset_seq::type_id::create("default_register_seq");
     uvm_reg_bit_bash_seq bit_bash_seq         = uvm_reg_bit_bash_seq::type_id::create("bit_bash_seq");

     phase.raise_objection(this);
     default_register_seq.model    = regmodel;
     bit_bash_seq.model            = regmodel;

     default_register_seq.start(null);
     bit_bash_seq.start(null);

     phase.drop_objection(this);
  endtask

endclass

