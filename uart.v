/*
 *  Copyright (C) 2018  Siddharth J <www.siddharth.pro>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

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
