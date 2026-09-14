package axi_pkg;
  `include "axi_defines.svh"
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  `uvm_analysis_imp_decl(_out)
  `include "axi_item.sv"
  `include "axi_sequencer.sv"
  `include "axi_base_seq.sv"
  `include "axi_driver.sv"
  `include "axi_monitor.sv"
  `include "axi_agent.sv"
  `include "axi_coverage.sv"
  `include "axi_scoreboard.sv"
  `include "axi_env.sv"
  `include "axi_base_test.sv"
endpackage
