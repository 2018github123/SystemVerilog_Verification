`timescale 1 ns / 1 ps

`include "uvm_macros.svh"
import uvm_pkg::*;


module tb_top;

//-----------------------clock and reset -------------
	bit clk;
	bit reset;
	
	always #5 clk = ~clk;
	
	initial begin
		reset = 1;
		#5 reset = 0;
	end
	
	mem_if intf(clk,reset);
	
	memory DUT(.clk(intf.clk),
				.reset(intf.reset),
				.addr(intf.addr),
				.wr_en(intf.wr_en),
				.rd_en(intf.rd_en),
				.wdata(intf.wdata),
				.rdata(intf.rdata));
	//config
	initial begin
		uvm_config_db#(virtual mem_if)::set(null,"uvm_test_top.env.in_agent.driver","vif",intf);
		uvm_config_db#(virtual mem_if)::set(null,"uvm_test_top.env.in_agent.monitor","vif",intf);
		uvm_config_db#(virtual mem_if)::set(null,"mem_model_test.env.out_agent.monitor","vif",intf);
	end

	initial begin
		run_test();
	end

endmodule
