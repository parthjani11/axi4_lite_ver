class axi_coverage extends uvm_subscriber #(axi_item);
  `uvm_component_utils(axi_coverage)
  uvm_analysis_imp_out #(axi_item,axi_coverage) out_mon;
  axi_item input_item, output_item;
  covergroup input_cg; endgroup
  covergroup output_cg; endgroup

  function new(string name, uvm_component parent);
    super.new(name,parent); input_cg=new(); output_cg=new();
  endfunction
  function void build_phase(uvm_phase phase); super.build_phase(phase); out_mon=new("out_mon",this); endfunction
  function void write(axi_item t); input_item=t; input_cg.sample(); endfunction
  function void write_out(axi_item t); output_item=t; output_cg.sample(); endfunction
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AXI_COV",$sformatf("INPUT COVERAGE=%0f OUTPUT COVERAGE=%0f",input_cg.get_coverage(),output_cg.get_coverage()),UVM_NONE);
  endfunction
endclass
