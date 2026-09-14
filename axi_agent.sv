class axi_agent extends uvm_agent;
  `uvm_component_utils(axi_agent)
  axi_driver drv;
  axi_sequencer sqr;
  axi_monitor mon;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon=axi_monitor::type_id::create("mon",this);
    if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active))
      is_active=UVM_ACTIVE;
    if(is_active==UVM_ACTIVE) begin
      drv=axi_driver::type_id::create("drv",this);
      sqr=axi_sequencer::type_id::create("sqr",this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if(is_active==UVM_ACTIVE) drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass
