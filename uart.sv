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

module uart #(
    // Parameters
    parameter clk_freq = 50000000,             // Hz
    parameter baud_rate = 19200,               // bits per second
    parameter data_bits = 8,                   // Range:5-9
    parameter parity_type = 0,                 // Range:0=None,1=Odd,2=Even
    parameter stop_bits = 1                    // Range:1-2
    )(
    // Outputs
    output                 rx_data_vld,
    output [data_bits-1:0] rx_data_out,
    output                 rx_parity_err,
    output                 tx,
    output                 tx_active,
    // Inputs
    input                  rx,
    input [data_bits-1:0]  tx_data_in,
    input                  tx_data_vld,
    input                  rst,
    input                  clk
);

// Receiver
uart_rx #(
    .clk_freq(clk_freq),
    .baud_rate(baud_rate))
    receiver(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rx_data_out(rx_data_out),
    .rx_data_vld(rx_data_vld),
    .rx_parity_err(rx_parity_err)
);

// Transmitter
uart_tx #(
    .clk_freq(clk_freq),
    .baud_rate(baud_rate))
    transmitter(
    .clk(clk),
    .rst(rst),
    .tx_data_vld(tx_data_vld),
    .tx_data_in(tx_data_in),
    .tx(tx),
    .tx_active(tx_active)
);

endmodule

