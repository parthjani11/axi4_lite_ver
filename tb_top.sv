`include "DUT.sv"
`include "axi_pkg.sv"
`include "axi_bus_if.sv"

module tb_top;
  import uvm_pkg::*;
  import axi_pkg::*;

  bit clk, rst;
  always #5 clk=~clk;

  axi_bus_if bus_if(.clk(clk),.rst(rst));

  axi4_lite_slave #(
    .DATA_WIDTH(`AXI_DATA_W), .ADDR_WIDTH(`AXI_ADDR_W),
    .MEM_DEPTH(`AXI_MEM_D), .DEFAULT_PROT(3'b000)
  ) dut0 (
    .ACLK(clk), .ARESETn(rst),
    .AWADDR(bus_if.AWADDR), .AWPROT(bus_if.AWPROT), .AWVALID(bus_if.AWVALID), .AWREADY(bus_if.AWREADY),
    .WDATA(bus_if.WDATA), .WSTRB(bus_if.WSTRB), .WVALID(bus_if.WVALID), .WREADY(bus_if.WREADY),
    .BRESP(bus_if.BRESP), .BVALID(bus_if.BVALID), .BREADY(bus_if.BREADY),
    .ARADDR(bus_if.ARADDR), .ARPROT(bus_if.ARPROT), .ARVALID(bus_if.ARVALID), .ARREADY(bus_if.ARREADY),
    .RDATA(bus_if.RDATA), .RRESP(bus_if.RRESP), .RVALID(bus_if.RVALID), .RREADY(bus_if.RREADY)
  );

  initial begin
    rst=1;
    #1 rst=0;
    repeat(3) @(posedge clk);
    #1 rst=1;
  end

  initial begin
    uvm_config_db#(virtual axi_bus_if)::set(null,"*","vif",bus_if);
    run_test("axi_base_test");
  end
endmodule
