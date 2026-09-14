class axi_base_seq extends uvm_sequence #(axi_item,axi_item);
  `uvm_object_utils(axi_base_seq)
  bit aw_seen, w_seen, ar_seen;

  function new(string name="axi_base_seq"); super.new(name); endfunction

  task body();
    repeat(`AXI_NUM_TXNS) begin
      req=axi_item::type_id::create("req");
      start_item(req);
      if(rsp==null) begin
        if(!req.randomize()) `uvm_error("SEQ","Initial transaction randomization failed");
      end else begin
        update_progress();
        randomize_next(req);
      end
      finish_item(req);
      get_response(rsp);
    end
  endtask

  task update_progress();
    if(rsp.AWREADY && rsp.AWVALID) aw_seen=1;
    if(rsp.WREADY  && rsp.WVALID)  w_seen=1;
    if(rsp.ARREADY && rsp.ARVALID) ar_seen=1;
    else ar_seen=0;
  endtask

  task randomize_next(axi_item item);
    bit ok;
    // Keep any channel that is currently stalled/partially accepted stable;
    // independent channels remain randomized. This preserves the reference
    // environment's response-dependent protocol-stressing behavior.
    if(aw_seen && w_seen && ar_seen) begin
      ok=item.randomize();
    end else if(aw_seen && w_seen) begin
      if(rsp.ARVALID) ok=item.randomize() with {ARADDR==rsp.ARADDR; ARVALID==rsp.ARVALID;};
      else ok=item.randomize() with {ARADDR==rsp.ARADDR;};
    end else if(aw_seen && ar_seen) begin
      if(rsp.WVALID) ok=item.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; WVALID==rsp.WVALID;};
      else ok=item.randomize() with {WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;};
    end else if(w_seen && ar_seen) begin
      if(rsp.AWVALID) ok=item.randomize() with {AWADDR==rsp.AWADDR; AWVALID==rsp.AWVALID;};
      else ok=item.randomize() with {AWADDR==rsp.AWADDR;};
    end else if(aw_seen) begin
      ok=item.randomize() with {ARADDR==rsp.ARADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;};
    end else if(w_seen) begin
      ok=item.randomize() with {AWADDR==rsp.AWADDR; ARADDR==rsp.ARADDR;};
    end else if(ar_seen) begin
      ok=item.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB;};
    end else begin
      ok=item.randomize() with {AWADDR==rsp.AWADDR; WDATA==rsp.WDATA; WSTRB==rsp.WSTRB; ARADDR==rsp.ARADDR;};
    end
    if(!ok) `uvm_error("SEQ","Response-dependent randomization failed");
  endtask
endclass
