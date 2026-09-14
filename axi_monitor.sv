class axi_monitor extends uvm_monitor;
  `uvm_component_utils(axi_monitor)
  virtual axi_bus_if vif;
  uvm_analysis_port #(axi_item) ap;

  function new(string name, uvm_component parent);
    super.new(name,parent); ap=new("ap",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_bus_if)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF","axi_bus_if was not supplied to monitor")
  endfunction

  task run_phase(uvm_phase phase);
    @(vif.cb_mon);
    forever collect_cycle();
  endtask

  task collect_cycle();
    axi_item tr;
    tr=axi_item::type_id::create("observed_item");
    @(vif.cb_mon);
    tr.rst=vif.cb_mon.rst;
    tr.AWADDR=vif.cb_mon.AWADDR; tr.AWPROT=vif.cb_mon.AWPROT;
    tr.AWVALID=vif.cb_mon.AWVALID; tr.AWREADY=vif.cb_mon.AWREADY;
    tr.WDATA=vif.cb_mon.WDATA; tr.WSTRB=vif.cb_mon.WSTRB;
    tr.WVALID=vif.cb_mon.WVALID; tr.WREADY=vif.cb_mon.WREADY;
    tr.BRESP=vif.cb_mon.BRESP; tr.BVALID=vif.cb_mon.BVALID; tr.BREADY=vif.cb_mon.BREADY;
    tr.ARADDR=vif.cb_mon.ARADDR; tr.ARPROT=vif.cb_mon.ARPROT;
    tr.ARVALID=vif.cb_mon.ARVALID; tr.ARREADY=vif.cb_mon.ARREADY;
    tr.RDATA=vif.cb_mon.RDATA; tr.RRESP=vif.cb_mon.RRESP;
    tr.RVALID=vif.cb_mon.RVALID; tr.RREADY=vif.cb_mon.RREADY;
    ap.write(tr);
  endtask
endclass
