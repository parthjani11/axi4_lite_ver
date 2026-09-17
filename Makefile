SHELL        := /bin/csh

VCS          := vcs
SIMV         := ./simv
URG          := urg

VCS_FLAGS    := -sverilog -ntb_opts uvm -full64 +v2k -debug_access+all -timescale=1ns/100ps
CM_FLAGS     := -cm line+cond+fsm+tgl+branch

TOP          := tb_top.sv
TEST         := axi_base_test

RUN_DIR      := results
SIM_LOG      := $(RUN_DIR)/axi_sim.log
COMPILE_LOG  := $(RUN_DIR)/compile.log
COV_REPORT   := $(RUN_DIR)/covReport

.PHONY: all compile run coverage clean git

all: compile run coverage

compile:
	mkdir -p $(RUN_DIR)
	source /fetools/synopsys/source/source.sh; $(VCS) $(VCS_FLAGS) $(CM_FLAGS) -l $(COMPILE_LOG) $(TOP)

run:
	source /fetools/synopsys/source/source.sh; $(SIMV) +UVM_TESTNAME=$(TEST) $(CM_FLAGS) -l $(SIM_LOG)

coverage:
	source /fetools/synopsys/source/source.sh; $(URG) -full64 -dir simv.vdb -report $(COV_REPORT)

clean:
	rm -rf csrc simv simv.daidir simv.vdb ucli.key DVEfiles $(RUN_DIR) covReport

git:
	git add .
	git commit -m "Update AXI4-Lite verification"
	git push
