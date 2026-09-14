class axi_env extends uvm_env;
  `uvm_component_utils(axi_env)
  axi_agent wr_agt, mn_agt;
  axi_scoreboard sb;
  axi_coverage cov;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wr_agt=axi_agent::type_id::create("wr_agt",this);
    mn_agt=axi_agent::type_id::create("mn_agt",this);
    sb=axi_scoreboard::type_id::create("sb",this);
    cov=axi_coverage::type_id::create("cov",this);
  endfunction
  function void connect_phase(uvm_phase phase);
    wr_agt.mon.ap.connect(sb.in_mon);
    mn_agt.mon.ap.connect(sb.out_mon);
    wr_agt.mon.ap.connect(cov.analysis_export);
    mn_agt.mon.ap.connect(cov.out_mon);
  endfunction
endclass
