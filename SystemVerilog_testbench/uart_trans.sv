
 class uart_trans;
   
	bit rx;
	rand bit [7:0] tx_data_in;
	bit start;
	bit tx;
	bit [7:0] rx_data_out;
	bit tx_active;
	bit done_tx;
	
endclass
