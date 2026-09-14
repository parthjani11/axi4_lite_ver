class axi_driver extends uvm_driver #(axi_item, axi_item);
  `uvm_component_utils(axi_driver)
  virtual axi_bus_if vif;

  function new(string name, uvm_component parent); super.new(name,parent); endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual axi_bus_if)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF","axi_bus_if was not supplied to driver")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done(rsp);
    end
  endtask

  task drive_item(axi_item tr);
    @(vif.cb_drv);
    fork
      put_write_address(tr);
      put_write_data(tr);
      put_read_address(tr);
      put_bready(tr);
      put_rready(tr);
      sample_ready_response(tr);
    join
  endtask

  task put_write_address(axi_item tr);
    vif.cb_drv.AWADDR <= tr.AWADDR;
    vif.cb_drv.AWPROT <= tr.AWPROT;
    vif.cb_drv.AWVALID <= tr.AWVALID;
  endtask
  task put_write_data(axi_item tr);
    vif.cb_drv.WDATA <= tr.WDATA;
    vif.cb_drv.WSTRB <= tr.WSTRB;
    vif.cb_drv.WVALID <= tr.WVALID;
  endtask
  task put_read_address(axi_item tr);
    vif.cb_drv.ARADDR <= tr.ARADDR;
    vif.cb_drv.ARPROT <= tr.ARPROT;
    vif.cb_drv.ARVALID <= tr.ARVALID;
  endtask
  task put_bready(axi_item tr); vif.cb_drv.BREADY <= tr.BREADY; endtask
  task put_rready(axi_item tr); vif.cb_drv.RREADY <= tr.RREADY; endtask

  task sample_ready_response(axi_item tr);
    $cast(rsp,tr.clone());
    rsp.set_id_info(tr);
    rsp.AWREADY = vif.cb_drv.AWREADY;
    rsp.WREADY  = vif.cb_drv.WREADY;
    rsp.BVALID  = vif.cb_drv.BVALID;
    rsp.ARREADY = vif.cb_drv.ARREADY;
    rsp.RVALID  = vif.cb_drv.RVALID;
  endtask
endclass
