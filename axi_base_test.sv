class axi_base_test extends uvm_test;
  `uvm_component_utils(axi_base_test)

  axi_env env;
  axi_base_seq main_seq;
  axi_wr_rd_always_simul wr_rd;
  axi_wr_only_always_simul wr;
  axi_wr_only_always_1_by_1 wr1;
  axi_rd_only_always rd;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.wr_agt","is_active",UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"env.mn_agt","is_active",UVM_PASSIVE);
    env=axi_env::type_id::create("env",this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    run();
    phase.phase_done.set_drain_time(this,20);
    phase.drop_objection(this);
  endtask

  task run();
    test_cases();

    axi_item::type_id::set_type_override(axi_out_of_bound_addr::get_type());
    test_cases();

    axi_item::type_id::set_type_override(axi_inv_addr::get_type());
    test_cases();
  endtask

  task test_cases();
    fork
      begin
        wr=axi_wr_only_always_simul::type_id::create("wr");
        wr.start(env.wr_agt.sqr);
      end
      begin
        rd=axi_rd_only_always::type_id::create("rd");
        rd.start(env.wr_agt.sqr);
      end
      begin
        wr1=axi_wr_only_always_1_by_1::type_id::create("wr1");
        wr1.start(env.wr_agt.sqr);
      end
      begin
        rd=axi_rd_only_always::type_id::create("rd");
        rd.start(env.wr_agt.sqr);
      end
      begin
        wr_rd=axi_wr_rd_always_simul::type_id::create("wr_rd");
        wr_rd.start(env.wr_agt.sqr);
      end
      begin
        main_seq=axi_base_seq::type_id::create("main_seq");
        main_seq.start(env.wr_agt.sqr);
      end
    join
  endtask
endclass

