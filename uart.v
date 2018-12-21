module uart(clk,rst,rx,tx_data_in,start,rx_data_out,tx,tx_active,done_tx);

parameter clk_freq = 32000000; //MHz
parameter baud_rate = 19200; //bits per second
parameter clock_divide = (clk_freq/baud_rate);

  input clk,rst;
	input rx;
	input [7:0] tx_data_in;
	input start;
	output tx;
	output [7:0] rx_data_out;
	output tx_active;
	output done_tx;
	
	
uart_rx 
              #(.clk_freq(clk_freq),
				    .baud_rate(baud_rate)
					 )
      receiver
               (
                .clk(clk),
					 .rst(rst),
					 .rx(rx),
					 .rx_data_out(rx_data_out)
               );


uart_tx 
               #(.clk_freq(clk_freq),
				    .baud_rate(baud_rate)
					 )
	transmitter			 
               (               
                .clk(clk),
					 .rst(rst),
					 .start(start),
					 .tx_data_in(tx_data_in),
					 .tx(tx),
					 .tx_active(tx_active),
					 .done_tx(done_tx)
               );

endmodule
