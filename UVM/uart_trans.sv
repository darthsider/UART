`timescale 1 ps/ 1 ps

`include "uvm_macros.svh"
import uvm_pkg::*;

  class uart_trans extends uvm_sequence_item;
   
  
    `uvm_object_utils(uart_trans)
         
     bit rx;
	   rand bit [7:0] tx_data_in;
	   bit start;
	   bit tx;
	   bit [7:0] rx_data_out;
	   bit tx_active;
	   bit done_tx;
  
   
    function new (string name = "");
      super.new(name);
    endfunction
    
    function string convert2string;
      return $sformatf("\t start = %0b, \t tx_data_in = %0h,\t done_tx = %0b",start,tx_data_in,done_tx);
      return $sformatf("\t tx_active = %0b, \t rx_data_out = %0b",tx_active, rx_data_out);
    
    endfunction

    function void do_copy(uvm_object rhs);
      uart_trans trans;
      $cast(trans, rhs);
      rx = trans.rx;
	    tx_data_in = trans.tx_data_in;
	    start = trans.start;
	    tx = trans.tx;
	    rx_data_out = trans.rx_data_out;
	    tx_active = trans.tx_active;
	    done_tx = trans.done_tx;
    endfunction
    
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      uart_trans trans;
      bit status = 1;
      $cast(trans, rhs);
      status &= (rx == trans.rx);
	    status &= (tx_data_in == trans.tx_data_in);
	    status &= (start == trans.start);
	    status &= (tx == trans.tx);
	    status &= (rx_data_out == trans.rx_data_out);
	    status &= (tx_active == trans.tx_active);
	    status &= (done_tx == trans.done_tx);
      return status;
    endfunction

  endclass: uart_trans


