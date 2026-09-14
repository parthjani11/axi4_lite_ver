class axi_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(axi_scoreboard)
  uvm_analysis_imp #(axi_item,axi_scoreboard) in_mon;
  uvm_analysis_imp_out #(axi_item,axi_scoreboard) out_mon;
  axi_item in_q[$], out_q[$];
  axi_item held;
  int total_checks, mismatches, match_count;
  bit [7:0] model_mem [0:63];
  bit got_aw, got_w, write_count;

  function new(string name, uvm_component parent);
    super.new(name,parent); in_mon=new("in_mon",this); out_mon=new("out_mon",this);
  endfunction
  function void write(axi_item t); in_q.push_back(t); endfunction
  function void write_out(axi_item t); out_q.push_back(t); endfunction

  task run_phase(uvm_phase phase);
    axi_item expected, actual;
    held=axi_item::type_id::create("held");
    forever begin
      wait(in_q.size()!=0 && out_q.size()!=0);
      if(expected==null) begin
        expected=in_q.pop_front(); void'(out_q.pop_front());
      end else begin
        actual=out_q.pop_front(); predict(expected); compare_result(expected,actual);
        expected=in_q.pop_front();
      end
    end
  endtask

  task predict(axi_item t);
    if(!t.rst) begin
      foreach(model_mem[i]) model_mem[i]=0;
      held.RDATA=0; held.RRESP=0; held.BRESP=0;
      got_aw=0; got_w=0; write_count=0;
      load_held(t);
    end else begin
      load_held(t); predict_read(t); predict_write(t);
    end
  endtask

  task load_held(axi_item t);
    t.RDATA=held.RDATA; t.RRESP=held.RRESP; t.BRESP=held.BRESP;
  endtask

  task predict_write(axi_item t);
    if(t.AWREADY && t.AWVALID) begin held.AWADDR=t.AWADDR; held.AWPROT=t.AWPROT; got_aw=1; end
    if(t.WREADY && t.WVALID) begin held.WDATA=t.WDATA; held.WSTRB=t.WSTRB; got_w=1; end
    if(got_aw && got_w) begin
      if(write_count) begin
        generate_write(t); got_aw=0; got_w=0; write_count=0;
      end else write_count=1;
    end
  endtask

  task predict_read(axi_item t);
    if(t.ARREADY && t.ARVALID) begin
      held.ARADDR=t.ARADDR; held.ARPROT=t.ARPROT; generate_read(t);
    end
  endtask

  task generate_write(axi_item t);
    if(held.AWADDR >= 64) begin
      t.BRESP=2'b11;
    end else if(((held.AWADDR >= 40) && (held.AWADDR <= 51)) || held.AWADDR[1:0]!=0) begin
      t.BRESP=2'b10;
    end else begin
      t.BRESP=2'b00;
      if(held.AWPROT==3'b000) begin
        if(held.WSTRB[0]) model_mem[held.AWADDR+0]=held.WDATA[7:0];
        if(held.WSTRB[1]) model_mem[held.AWADDR+1]=held.WDATA[15:8];
        if(held.WSTRB[2]) model_mem[held.AWADDR+2]=held.WDATA[23:16];
        if(held.WSTRB[3]) model_mem[held.AWADDR+3]=held.WDATA[31:24];
      end
    end
    held.BRESP=t.BRESP;
  endtask

  task generate_read(axi_item t);
    if(held.ARADDR >= 64) begin
      t.RRESP=2'b11; t.RDATA=0;
    end else if(((held.ARADDR >= 52) && (held.ARADDR <= 59)) || held.ARADDR[1:0]!=0) begin
      t.RRESP=2'b10; t.RDATA=0;
    end else begin
      t.RRESP=2'b00; t.RDATA=0;
      if(held.ARPROT==3'b000) begin
        t.RDATA[7:0]=model_mem[held.ARADDR+0];
        t.RDATA[15:8]=model_mem[held.ARADDR+1];
        t.RDATA[23:16]=model_mem[held.ARADDR+2];
        t.RDATA[31:24]=model_mem[held.ARADDR+3];
      end
    end
    held.RRESP=t.RRESP; held.RDATA=t.RDATA;
  endtask

  task compare_result(axi_item exp, axi_item act);
    total_checks++;
    if(exp.compare(act)) begin match_count++; `uvm_info("AXI_SB","CHECK PASS",UVM_LOW); end
    else begin
      mismatches++;
      `uvm_error("AXI_SB",$sformatf("Mismatch: DUT BRESP=%0h RDATA=%0h RRESP=%0h; REF BRESP=%0h RDATA=%0h RRESP=%0h",act.BRESP,act.RDATA,act.RRESP,exp.BRESP,exp.RDATA,exp.RRESP));
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("AXI_SB",$sformatf("Checks=%0d Matches=%0d Mismatches=%0d",total_checks,match_count,mismatches),UVM_NONE);
  endfunction
endclass
