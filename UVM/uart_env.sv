`timescale 1 ps/ 1 ps
  
  class uart_env extends uvm_env;

  `uvm_component_utils(uart_env)
    
   uart_agent agent;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
    agent = uart_agent::type_id::create("agent",this);  
    endfunction
    
    
  endclass: uart_env
  
 