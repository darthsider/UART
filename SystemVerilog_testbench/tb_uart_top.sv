module tb_uart_top;

parameter clk_freq = 50000000; //MHz
parameter baud_rate = 19200; //bits per second


  bit clk;
  bit rst;
		
  uart_intf vif(clk,rst);
  uart_test t1(vif);
  	
	uart #(.clk_freq(clk_freq),.baud_rate(baud_rate))
	       dut( .clk(vif.clk),
	            .rst(vif.rst),
	            .rx(vif.rx),
	            .tx_data_in(vif.tx_data_in),
	            .start(vif.start),
	            .rx_data_out(vif.rx_data_out),
	            .tx(vif.tx),
	            .tx_active(vif.tx_active),
	            .done_tx(vif.done_tx));
	       
	       
	always #50 clk = ~clk;
	
	initial begin
	rst = 1;
	repeat(2) @(posedge clk);
	rst = 0;
	end
	
	
	endmodule  
