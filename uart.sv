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

parameter clk_freq = 50000000;                  // Hz
parameter baud_rate = 19200;                    // bits per second
parameter data_bits = 8;                        // Range:5-9
parameter parity_type = 0;                      // Range:0=None,1=Odd,2=Even
parameter stop_bits = 1;                        // Range:1-2

input clk,rst; 
input rx;
input [data_bits-1:0] tx_data_in;
input start;
output tx; 
output [data_bits-1:0] rx_data_out;
output tx_active;
output done_tx;

// Receiver
uart_rx #(
    .clk_freq(clk_freq),
    .baud_rate(baud_rate))
    receiver(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rx_data_out(rx_data_out)
);

// Transmitter
uart_tx #(
    .clk_freq(clk_freq),
    .baud_rate(baud_rate))
    transmitter(               
    .clk(clk),
    .rst(rst),
    .start(start),
    .tx_data_in(tx_data_in),
    .tx(tx),
    .tx_active(tx_active),
    .done_tx(done_tx)
);

endmodule

