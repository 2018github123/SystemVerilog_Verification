.PHONY: clean all

TB_DIR = ./tb
RTL_DIR = ./rtl
INCLUDE_DIR = ./include



TIMESCALE = $(INCLUDE_DIR)/timescale.sv
TEST_TB = $(TB_DIR)/*.sv
RTL = $(RTL_DIR)/*.v
TOP = $(TB_DIR)/*.v

all: clean run

run: comp sim

comp:
	@#vcs source.v -cm fsm -o mysimv
	@#vcs -cm tgl -cm_dir /net/designl/mycm source.v
	@vcs -sverilog  $(TIMESCALE) $(TEST_TB) $(RTL) $(TOP) -l comp.log -full64  

sim: 
	@./simv -l run.log 
   
	@if [ -d simv.vdb ] ; then \
	 (urg -dir simv.vdb -report text ; ) \
	 fi


clean:
	@rm -rf simv* csrc* *.log urgReport  text  ucli.key 



