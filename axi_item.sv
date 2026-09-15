class axi_item extends uvm_sequence_item;
  rand logic [`AXI_ADDR_W-1:0] AWADDR;
  bit [2:0] AWPROT;
  rand logic AWVALID;
  logic AWREADY;

  rand logic [`AXI_DATA_W-1:0] WDATA;
  rand logic [(`AXI_DATA_W/8)-1:0] WSTRB;
  rand logic WVALID;
  logic WREADY;

  logic [1:0] BRESP;
  logic BVALID;
  rand logic BREADY;

  rand logic [`AXI_ADDR_W-1:0] ARADDR;
  bit [2:0] ARPROT;
  rand logic ARVALID;
  logic ARREADY;

  logic [`AXI_DATA_W-1:0] RDATA;
  logic [1:0] RRESP;
  logic RVALID;
  rand logic RREADY;

  bit rst;

  function new(string name="axi_item");
    super.new(name);
  endfunction

  constraint write_addr_range {
    AWADDR inside {[0:63]};
    AWADDR[1:0] == 2'b00;
  }

  constraint read_addr_range {
    ARADDR inside {[0:63]};
    ARADDR[1:0] == 2'b00;
  }

  `uvm_object_utils_begin(axi_item)
    `uvm_field_int(rst,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(AWADDR,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(AWPROT,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(AWVALID,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(AWREADY,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(WDATA,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(WSTRB,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(WVALID,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(WREADY,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(BRESP,UVM_ALL_ON)
    `uvm_field_int(BVALID,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(BREADY,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(ARADDR,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(ARPROT,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(ARVALID,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(ARREADY,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(RDATA,UVM_ALL_ON)
    `uvm_field_int(RRESP,UVM_ALL_ON)
    `uvm_field_int(RVALID,UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(RREADY,UVM_ALL_ON|UVM_NOCOMPARE)
  `uvm_object_utils_end
endclass

class axi_out_of_bound_addr extends axi_item;
  function new(string name="axi_out_of_bound_addr");
    super.new(name);
  endfunction

  `uvm_object_utils(axi_out_of_bound_addr)

  constraint write_addr_range {
    AWADDR inside {[64:(2**(`AXI_ADDR_W)-1)]};
  }

  constraint read_addr_range {
    ARADDR inside {[64:(2**(`AXI_ADDR_W)-1)]};
  }
endclass

class axi_inv_addr extends axi_item;
  function new(string name="axi_inv_addr");
    super.new(name);
  endfunction

  `uvm_object_utils(axi_inv_addr)

  constraint write_addr_range {
    AWADDR inside {[0:63]};
    AWADDR[1:0] != 2'b00;
  }

  constraint read_addr_range {
    ARADDR inside {[0:63]};
    ARADDR[1:0] != 2'b00;
  }
endclass

