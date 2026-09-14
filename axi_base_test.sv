class axi_base_test extends uvm_test;
  `uvm_component_utils(axi_base_test)
  axi_env env;
  axi_base_seq main_seq;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.wr_agt","is_active",UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.mn_agt","is_active",UVM_PASSIVE);
    env=axi_env::type_id::create("env",this);
  endfunction
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase); uvm_top.print_topology();
  endfunction
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    main_seq=axi_base_seq::type_id::create("main_seq");
    main_seq.start(env.wr_agt.sqr);
    phase.phase_done.set_drain_time(this,20);
    phase.drop_objection(this);
  endtask
endclass
