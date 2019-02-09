`timescale 1 ps/ 1 ps
  
  class uart_test extends uvm_test;
  
    `uvm_component_utils(uart_test)
    
    uart_env env;
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      env = uart_env::type_id::create("env", this);
    endfunction
    
    	function void end_of_elaboration_phase(uvm_phase phase);
			//`uvm_info(uvm_get_fullname(), this.sprint(), UVM_NONE)
			`uvm_info("", this.sprint(), UVM_NONE)
		endfunction
    
    task run_phase(uvm_phase phase);
      uart_sequence seqr;
      seqr = uart_sequence::type_id::create("seqr");
      if( !seqr.randomize() ) 
        `uvm_error("", "Randomize failed")
      seqr.starting_phase = phase;
      seqr.start( env.agent.seqr );
    endtask
     
  endclass: uart_test
  
