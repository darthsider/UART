
class uart_cov extends uvm_subscriber #(uart_trans);
  
  `uvm_component_utils(uart_cov)
  uart_trans trans;
	

  covergroup cov_inst;
  RX:coverpoint trans.rx {option.auto_bin_max = 1;}
  TX_DIN:coverpoint trans.tx_data_in {option.auto_bin_max = 8;}
  START:coverpoint trans.start {option.auto_bin_max = 1;}
  TX:coverpoint trans.tx {option.auto_bin_max = 1;}
  RX_DOUT:coverpoint trans.rx_data_out {option.auto_bin_max = 8;}
  TX_ACT:coverpoint trans.tx_active {option.auto_bin_max = 1;}
  DONE:coverpoint trans.done_tx {option.auto_bin_max = 1;}
  
  RXxRX_DOUT: cross RX,RX_DOUT;
  TXxTX_DINxTX_ACTxDONE: cross TX,TX_DIN,TX_ACT,DONE;
  STARTxTX_DIN: cross START,TX_DIN;
  endgroup 
  
  
  function new(string name="", uvm_component parent);
		super.new(name, parent);
		cov_inst = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction


  	virtual function void write(uart_trans t);
  	$cast(trans, t);
	 cov_inst.sample();
	 endfunction

endclass

