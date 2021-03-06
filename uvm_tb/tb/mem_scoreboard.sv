// Scoreboard

//compare reference output and monitor output

class mem_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(mem_scoreboard)
	
	mem_transaction expect_queue[$];
	//get transactio from refence and monitor
	uvm_blocking_get_port #(mem_transaction) exp_port;//reference 
	uvm_blocking_get_port #(mem_transaction) act_port;//out_agent monitor
	
	//uvm_analysis_imp#(mem_transaction,mem_scoreboard) item_collected_export;
	
	function new(string name, uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//item_collected_export=new("item_collected_export",this);
		exp_port = new("exp_port",this);
		act_port = new("act_port",this);
	endfunction
	
	virtual function void write(mem_transaction pkt);
		$display("SCB::Pkt recived");
		pkt.print();
	endfunction
	
	virtual task run_phase(uvm_phase phase);
	    mem_transaction  get_expect;
	    mem_transaction  get_actual;
	    mem_transaction  tmp_tran;
	    bit result;
	    
	    super.main_phase(phase);
		//comparision logic
		fork
		    //get transaction from reference
		    while(1) begin
		        exp_port.get(get_expect);
		        expect_queue.push_back(get_expect);
		    end //end-while
		    //get transaction from out-agent-monitor
		    while(1) begin
		        act_port.get(get_actual);
		        if(expect_queue.size() > 0) begin
		            tmp_tran = expect_queue.pop_front();
		            result = get_actual.mem_compare(tmp_tran);
		            if(result) begin
		                `uvm_info("mem_scoreboard","compare successfully",UVM_LOW);
		            end
		            else begin
		                `uvm_error("mem_scoreboard","compare failed");
		                $display("the expect pkt is ");
		                tmp_tran.mem_print();
		                $display("the actual pkt is ");
		                get_actual.mem_print();
		            end
		        end
		        else begin
		            `uvm_error("mem_scoreboard","Received from DUT,while Expect queue is empty");
		            $display("the unexpected pkt is");
		            get_actual.mem_print();
		        end
		        
		    end // end-while
		join
		
	endtask
endclass
