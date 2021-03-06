// Driver

class mem_driver extends uvm_driver #(mem_transaction);
	//
	virtual mem_if vif;
	
	`uvm_component_utils(mem_driver)
	
	//constructor
	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction
	
	//build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//
		if(!uvm_config_db#(virtual mem_if)::get(this,"","vif",vif)) begin
			`uvm_fatal("NO_VIF",{"Virtual interface must be set for:",get_full_name(),"vif"});
		end
	endfunction
	// run phase
	extern virtual task run_phase(uvm_phase phase);// why is virtual task?
	extern task drive();	
	
endclass

task mem_driver::run_phase(uvm_phase phase);
	//phase.raise_objection(this);

	// driver request transaction from sequencer
		forever begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end

	//phase.drop_objection(this);
endtask

task mem_driver::drive();
    req.print();
      vif.DRIVER.driver_cb.wr_en <= 0;
      vif.DRIVER.driver_cb.rd_en <= 0;
      @(posedge vif.DRIVER.clk);
      vif.DRIVER.driver_cb.addr <= req.addr;
    if(req.wr_en) begin
        vif.DRIVER.driver_cb.wr_en <= req.wr_en;
        vif.DRIVER.driver_cb.wdata <= req.wdata;
        @(posedge vif.DRIVER.clk);
      end
    if(req.rd_en) begin
        vif.DRIVER.driver_cb.rd_en <= req.rd_en;
        @(posedge vif.DRIVER.clk);
        vif.DRIVER.driver_cb.rd_en <= 0;
        @(posedge vif.DRIVER.clk);
        req.rdata = vif.DRIVER.driver_cb.rdata;
      end
      $display("-----------------------------------------");
endtask
