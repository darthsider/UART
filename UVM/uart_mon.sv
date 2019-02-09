class uart_mon extends uvm_monitor;
	
	virtual uart_intf intf;
	uart_trans trans;
	uvm_analysis_port #(uart_trans) ap_port;
	`uvm_component_utils(uart_mon)
	
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction


	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  ap_port = new("ap_port",this);
	  trans = uart_trans::type_id::create("trans");
		if(!uvm_config_db #(virtual uart_intf)::get(this, "", "uart_intf", intf)) 
		   begin
		    `uvm_error("ERROR::", "UVM_CONFIG_DB FAILED in uart_mon")
		    end
		//ap_port = new("ap_port", this);
	endfunction

  
  task run_phase(uvm_phase phase);
    while(1) begin
      @(posedge intf.clk);
      trans = uart_trans::type_id::create("trans");
      trans.start = intf.start;
      trans.tx_active = intf.tx_active;
      trans.done_tx = intf.done_tx;
      trans.tx_data_in = intf.tx_data_in;
      trans.rx = intf.rx;
      trans.rx_data_out = intf.rx_data_out;
      trans.tx = intf.tx;
      ap_port.write(trans);
    end
  endtask
  
  
endclass
