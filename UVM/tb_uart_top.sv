`timescale 1 ps/ 1 ps

`include "uart_trans.sv"
`include "uart_sequence.sv"
`include "uart_intf.sv"
`include "uart_driver.sv"
`include "uart_agent.sv"
`include "uart_env.sv"
`include "uart_test.sv"

module tb_uart_top;
  
  
  bit clk;
  bit rst;
  
  uart_intf intf();
  
  uart    dut(
              .clk(intf.clk),
              .rst(intf.rst),
              .rx(intf.rx),
              .tx_data_in(intf.tx_data_in),
              .start(intf.start),
              .rx_data_out(intf.rx_data_out),
              .tx(intf.tx),
              .tx_active(intf.tx_active),
              .done_tx(intf.done_tx)
              );

  // Clock generator
  initial
  begin
    intf.clk = 0;
    forever #5 intf.clk = ~intf.clk;
  end
  
  initial
  begin
    intf.rst = 1;
    #1000;
    intf.rst = 0;
  end



  initial
  begin
    uvm_config_db #(virtual uart_intf)::set(null, "*", "uart_intf", intf);
    void'(uvm_config_db #(int)::set(null,"*","no_of_transactions",10));
    
    uvm_top.finish_on_completion = 1;
    
    run_test("uart_test");
  end

endmodule: tb_uart_top


