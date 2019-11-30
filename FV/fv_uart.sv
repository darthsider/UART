/*
    Formal testbench for UART module
    Copyright (C) 2019 Rijurekh Bose

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

`include "fv_uart.svh"

module fv_uart #(
    // Parameters
    parameter clk_freq 	  = `CLK_FREQ,      // Hz
    parameter baud_rate   = `BAUD_RATE,     // bits per second
    parameter data_bits   = `DATA_BITS,     // Range:5-9
    parameter parity_type = `PARITY_TYPE,   // Range:0=None,1=Odd,2=Even
    parameter stop_bits   = `STOP_BITS      // Range:1-2
    )(
    input                  rst,
    input                  clk
);

localparam clock_divide = (clk_freq/baud_rate);

// Declaring variables
logic rx_tx, rx_tx;
logic [data_bits-1:0] tx_data_in, rx_data_out;
logic tx_data_vld, rx_data_vld;
logic rx_parity_err;
logic [clock_divide:0] tx_data_ref;
logic tx_active;

logic [$clog2(data_bits):0] sym_data_bit;
logic [$clog2(clock_divide):0] tx_count, rx_count;

// Instantiate UART
// Connect TX to RX
uart #(
    .clk_freq(clk_freq),
    .baud_rate(baud_rate),
    .data_bits(data_bits),
    .parity_type(parity_type),
    .stop_bits(stop_bits))
    uart_inst(
    .rx_data_vld(rx_data_vld),
    .rx_data_out(rx_data_out),
    .rx_parity_err(rx_parity_err),
    .tx(rx_tx),
    .tx_active(tx_active),
    .rx(rx_tx),
    .tx_data_in(tx_data_in),
    .tx_data_vld(tx_data_vld),
    .clk(clk),
    .rst(rst)
);

`ifdef FORMAL

reg init = 1'b1;

always @(*) begin
    // No data input during active
    assume(!(tx_data_vld && tx_active));

    // No data transmitted if max count reached
    assume(!(tx_data_vld && (tx_count > clock_divide)));

    // No data inputs during reset
    assume(!(tx_data_vld && rst));
end

always_ff @(posedge clk) begin
    // For Symbiyosys, to initiate reset states correctly
    // TODO: prove mode not setting reset state correctly
    if(init) begin
        assume(rst);
    end
    init <= 1'b0;

    if(tx_data_vld) begin
        tx_data_ref <= tx_data_in[sym_data_bit];
    end

    // RX counter logic
    if(rst) begin
        rx_count <= {$clog2(clock_divide)+1{1'b0}};
    end else if(rx_data_vld) begin
        rx_count <= rx_count + 1'b1;
    end

    // TX counter logic
    if(rst) begin
        tx_count <= {$clog2(clock_divide)+1{1'b0}};
    end else if(tx_data_vld) begin
        tx_count <= tx_count + 1'b1;
    end

    if(!rst) begin
        // Symbolic variables
        assume((sym_data_bit < data_bits) &&
               (sym_data_bit == $past(sym_data_bit)));

        // Reference data bits are symbolic
        assume(tx_data_ref == $past(tx_data_ref));

        // When transmitting data, fix sym data bit as per tx_count
        if(tx_data_vld) begin
            assume(tx_data_in[sym_data_bit] == tx_data_ref[tx_count]);
        end

        // Data integrity checker
        if(rx_data_vld) begin
            assert(rx_data_out[sym_data_bit] == tx_data_ref[rx_count]);
        end
    end
end

`endif

endmodule
