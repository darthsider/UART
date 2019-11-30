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

module uart_rx #(
    // Parameters
    parameter clk_freq = 50000000,             // Hz
    parameter baud_rate = 19200,               // bits per second
    parameter data_bits = 8,                   // Range:5-9
    parameter parity_type = 0,                 // Range:0=None,1=Odd,2=Even
    parameter stop_bits = 1                    // Range:1-2
    )(
    // Outputs
    output [data_bits-1:0] rx_data_out,
    output logic           rx_data_vld,
    output logic           rx_parity_err,
    // Inputs
    input                  rx,
    input                  rst,
    input                  clk
);

localparam clock_divide = (clk_freq/baud_rate);

// Yosys doesn't support enum :(
`ifndef FORMAL
enum bit [2:0] {
    rx_IDLE = 3'b000,
    rx_START = 3'b001,
    rx_DATA = 3'b010,
    rx_STOP = 3'b011,
    rx_PARITY = 3'b100 } rx_STATE, rx_NEXT;
`else
localparam rx_IDLE = 3'b000;
localparam rx_START = 3'b001;
localparam rx_DATA = 3'b010;
localparam rx_STOP = 3'b011;
localparam rx_PARITY = 3'b100;
logic [2:0] rx_STATE, rx_NEXT;
`endif

logic [$clog2(clock_divide):0] clk_div_reg,clk_div_next;
logic [data_bits-1:0] rx_data_reg,rx_data_next;
logic [$clog2(data_bits):0] index_bit_reg,index_bit_next;
logic rx_data_vld_next, parity_err_next;
logic [1:0] stop_bits_remaining, stop_bits_remaining_next;

always_ff @(posedge clk) begin
    if(rst) begin
        rx_STATE <= rx_IDLE;
        clk_div_reg <= 0;
        rx_data_reg <= 0;
        index_bit_reg <= 0;
        rx_data_vld <= 1'b0;
        rx_parity_err <= 1'b0;
        stop_bits_remaining <= stop_bits;
    end
    else begin
        rx_STATE <= rx_NEXT;
        clk_div_reg <= clk_div_next;
        rx_data_reg <= rx_data_next;
        index_bit_reg <= index_bit_next;
        rx_data_vld <= rx_data_vld_next;
        rx_parity_err <= parity_err_next;
        stop_bits_remaining <= stop_bits_remaining_next;
    end
end

always_comb begin
    rx_NEXT = rx_STATE;
    clk_div_next = clk_div_reg;
    rx_data_next = rx_data_reg;
    index_bit_next = index_bit_reg;
    rx_data_vld_next = rx_data_vld;
    parity_err_next = rx_parity_err;
    stop_bits_remaining_next = stop_bits_remaining;

    case(rx_STATE)

        rx_IDLE: begin
            clk_div_next = 0;
            index_bit_next = 0;
            parity_err_next = 1'b0;
            rx_data_vld_next = 1'b0;
            stop_bits_remaining_next = stop_bits;
            if(rx == 0) begin
                rx_NEXT = rx_START;
            end
            else begin
                rx_NEXT = rx_IDLE;
            end
        end

        rx_START: begin
            if(clk_div_reg == (clock_divide-1'b1)/2) begin
                if(rx == 0) begin
                    clk_div_next = 0;
                    rx_NEXT = rx_DATA;
                end
                else begin
                rx_NEXT = rx_IDLE;
                end
            end
            else begin
                clk_div_next = clk_div_reg + 1'b1;
                rx_NEXT = rx_START;
            end
        end

        rx_DATA: begin
            if(clk_div_reg < clock_divide[$clog2(clock_divide):0]-1'b1) begin
                clk_div_next = clk_div_reg + 1'b1;
                rx_NEXT = rx_DATA;
            end
            else begin
                clk_div_next = 0;
                rx_data_next[index_bit_reg] = rx;
                if(index_bit_reg < (data_bits-1)) begin
                    index_bit_next = index_bit_reg + 1'b1;
                    rx_NEXT = rx_DATA;
                end
                else begin
                    index_bit_next = 0;
                    if(parity_type == 0) begin
                        rx_NEXT = rx_STOP;
                    end
                    else begin
                        rx_NEXT = rx_PARITY;
                    end
                end
            end
        end

        rx_PARITY: begin
            if(clk_div_reg < clock_divide[$clog2(clock_divide):0]-1'b1) begin
                clk_div_next = clk_div_reg + 1'b1;
                rx_NEXT = rx_PARITY;
            end
            else begin
                clk_div_next = 0;
                rx_NEXT = rx_STOP;
                if(parity_type == 1) begin
                    parity_err_next = (rx == ^rx_data_reg);
                end
                else if(parity_type == 2) begin
                    parity_err_next = (rx == ~^rx_data_reg);
                end
            end
        end

        rx_STOP: begin
            if(clk_div_reg < clock_divide[$clog2(clock_divide):0]-1'b1) begin
                clk_div_next = clk_div_reg + 1'b1;
                rx_NEXT = rx_STOP;
            end
            else begin
                clk_div_next = 0;
                stop_bits_remaining_next = stop_bits_remaining - 1'b1;
                if(stop_bits_remaining_next == 2'd0) begin
                    rx_NEXT = rx_IDLE;
                    rx_data_vld_next = 1'b1;
                end
                else begin
                    rx_NEXT = rx_STOP;
                end
            end
        end

        default: rx_NEXT = rx_IDLE;
    endcase
end

assign rx_data_out = rx_data_reg;

endmodule

