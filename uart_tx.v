module uart_tx(clk,rst,start,tx_data_in,tx,tx_active,done_tx);

parameter clk_freq = 32000000; //MHz
parameter baud_rate = 19200; //bits per second
input clk,rst;
input start;
input [7:0] tx_data_in;
output tx;
output tx_active;
output reg done_tx;

localparam clock_divide = (clk_freq/baud_rate);

parameter [2:0] tx_IDLE = 3'b000,
                tx_START = 3'b001,
					 tx_DATA = 3'b010,
					 tx_STOP = 3'b011,
					 tx_DONE = 3'b100;
					 
reg [2:0] tx_STATE, tx_NEXT;
reg [11:0] clk_div_reg,clk_div_next;
reg [7:0] tx_data_reg, tx_data_next;
reg tx_out_reg,tx_out_next;
reg [2:0] index_bit_reg,index_bit_next;

assign tx_active = (tx_STATE == tx_DATA);
assign tx = tx_out_reg;

always @(posedge clk) begin
if(rst) begin
tx_STATE <= tx_IDLE;
clk_div_reg <= 0;
tx_out_reg <= 0;
tx_data_reg <= 0;
index_bit_reg <= 0;
end
else begin
tx_STATE <= tx_NEXT;
clk_div_reg <= clk_div_next;
tx_out_reg <= tx_out_next;
tx_data_reg <= tx_data_next;
index_bit_reg <= index_bit_next;
end
end

always @(*) begin
tx_NEXT = tx_STATE;
clk_div_next = clk_div_reg;
tx_out_next = tx_out_reg;
tx_data_next = tx_data_reg;
index_bit_next = index_bit_reg;
done_tx = 0;

case(tx_STATE)

tx_IDLE: begin
tx_out_next = 1;
clk_div_next = 0;
index_bit_next = 0;
if(start == 1) begin
tx_data_next = tx_data_in;
tx_NEXT = tx_START;
end
else begin
tx_NEXT = tx_IDLE;
end
end

tx_START: begin
tx_out_next = 0;
if(clk_div_reg < clock_divide-1) begin
clk_div_next = clk_div_reg + 1;
tx_NEXT = tx_START;
end
else begin
clk_div_next = 0;
tx_NEXT = tx_DATA;
end
end

tx_DATA: begin
tx_out_next = tx_data_reg[index_bit_reg];
if(clk_div_reg < clock_divide-1) begin
clk_div_next = clk_div_reg + 1'b1;
tx_NEXT = tx_DATA;
end
else begin
clk_div_next = 0;
if(index_bit_reg < 7) begin
index_bit_next = index_bit_reg + 1'b1;
tx_NEXT = tx_DATA;
end
else begin
index_bit_next = 0;
tx_NEXT = tx_STOP; 
end
end
end

tx_STOP: begin
tx_out_next = 1;
if(clk_div_reg < clock_divide-1) begin
clk_div_next = clk_div_reg + 1'b1;
tx_NEXT = tx_STOP;
end
else begin
clk_div_next = 0;
tx_NEXT = tx_DONE;
end
end

tx_DONE: begin
done_tx = 1;
tx_NEXT = tx_IDLE;
end

default: tx_NEXT = tx_IDLE;
endcase
end

endmodule 