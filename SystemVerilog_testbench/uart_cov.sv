class uart_cov;
  
  uart_trans trans = new();
  
  covergroup cov_inst;
  option.per_instance = 1;
  RX:coverpoint trans.rx {bins rx_c = {0,1};}
  TX_DIN:coverpoint trans.tx_data_in {bins tx_din_c = {[0:255]};}
  START:coverpoint trans.start {bins str = {0,1};}
  TX:coverpoint trans.tx {bins tx_c = {0,1};}
  RX_DOUT:coverpoint trans.rx_data_out {bins rx_dout_c = {[0:255]};}
  TX_ACT:coverpoint trans.tx_active {bins tx_act_c = {0,1};}
  DONE:coverpoint trans.done_tx {bins dtx_c = {0,1};}
  endgroup 

  function new();
    cov_inst = new;
  endfunction
  
  task main;
    cov_inst.sample();
  endtask

endclass

