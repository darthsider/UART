class uart_agent extends uvm_agent;
	
 `uvm_component_utils(uart_agent)
	  
	  uart_sequencer seqr;
    uart_driver    driv;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
      seqr = uart_sequencer::type_id::create("seqr", this);
      driv = uart_driver::type_id::create("driv", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
      driv.seq_item_port.connect( seqr.seq_item_export );
    endfunction
    

endclass
