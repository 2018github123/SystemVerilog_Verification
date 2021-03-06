// test defines the test scenario for the testbench

class mem_model_test extends uvm_test;
	`uvm_component_utils(mem_model_test)
	
	mem_model_env env;
	mem_sequence  seq;
	
	function new(string name = "mem_model_test", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		env= mem_model_env::type_id::create("env",this);
		seq= mem_sequence::type_id::create("seq");
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(env.in_agent.sequencer);
		seq.start(env.out_agent.sequencer);
		phase.drop_objection(this);
	endtask
	
    function void report_phase(uvm_phase phase);
        uvm_report_server server;
        int err_num;
        super.report_phase(phase);
        
        server = get_report_server();
        err_num = server.get_severity_count(UVM_ERROR);
        
        if(err_num != 0) begin
            $display("TEST CASE FAILED");
        end
        else begin
            $display("TEST CASE PASSED");
        end
    endfunction

endclass

