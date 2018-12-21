
 interface uart_intf(input logic clk,rst);
 
  logic rx;
	logic [7:0] tx_data_in;
	logic start;
  logic tx;
	logic [7:0] rx_data_out;
	logic tx_active;
	logic done_tx; 

 clocking driver_cb @(posedge clk);
   default input #1 output #1;
   output rx;
   output tx_data_in;
   output start;
   input tx;
   input rx_data_out;
   input tx_active;
   input done_tx;
endclocking

modport DRIVER (clocking driver_cb,input clk,rst);

 
endinterface
