module uart_rx(clk,rst,rx,rx_data_out);

parameter clk_freq = 32000000; //MHz
parameter baud_rate = 19200; //bits per second
input clk;
input rst;
input rx;
output [7:0] rx_data_out;

localparam clock_divide = (clk_freq/baud_rate);

parameter [2:0] rx_IDLE = 3'b000,
               rx_START = 3'b001,
					 rx_DATA = 3'b010,
					 rx_STOP = 3'b011,
					 rx_DONE = 3'b100;
					 
reg [2:0] rx_STATE, rx_NEXT;
reg [11:0] clk_div_reg,clk_div_next;
reg [7:0] rx_data_reg,rx_data_next;
reg [2:0] index_bit_reg,index_bit_next;


always @(posedge clk) begin
if(rst) begin
rx_STATE <= rx_IDLE;
clk_div_reg <= 0;
rx_data_reg <= 0;
index_bit_reg <= 0;
end
else begin
rx_STATE <= rx_NEXT;
clk_div_reg <= clk_div_next;
rx_data_reg <= rx_data_next;
index_bit_reg <= index_bit_next;
end
end

always @(*) begin
rx_NEXT = rx_STATE;
clk_div_next = clk_div_reg;
rx_data_next = rx_data_reg;
index_bit_next = index_bit_reg;

case(rx_STATE)					 

rx_IDLE: begin
clk_div_next = 0;
index_bit_next = 0;
if(rx == 0) begin
rx_NEXT = rx_START;
end
else begin
rx_NEXT = rx_IDLE;
end
end

rx_START: begin
if(clk_div_reg == (clock_divide-1)/2) begin
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
if(clk_div_reg < clock_divide-1) begin
clk_div_next = clk_div_reg + 1'b1;
rx_NEXT = rx_DATA;
end
else begin
clk_div_next = 0;
rx_data_next[index_bit_reg] = rx;
if(index_bit_reg < 7) begin
index_bit_next = index_bit_reg + 1'b1;
rx_NEXT = rx_DATA;
end
else begin
index_bit_next = 0;
rx_NEXT = rx_STOP;
end
end
end

rx_STOP: begin
if(clk_div_reg < clock_divide - 1) begin
clk_div_next = clk_div_reg + 1'b1;
rx_NEXT = rx_STOP;
end
else begin
clk_div_next = 0;
rx_NEXT = rx_DONE;
end
end

rx_DONE: begin
rx_NEXT = rx_IDLE;
end

default: rx_NEXT = rx_IDLE;
endcase
end

assign rx_data_out = rx_data_reg;

endmodule