
class uart_driv;
  
parameter clk_freq = 50000000; //MHz
parameter baud_rate = 19200; //bits per second

  
  uart_trans trans;
  virtual uart_intf vif;
  mailbox gen2driv;
  int no_transactions;
  reg [7:0] data;
  
localparam clock_divide = (clk_freq/baud_rate);
  
  function new(virtual uart_intf vif,mailbox gen2driv);
    this.vif = vif;
    this.gen2driv = gen2driv;
  endfunction
  
  task reset;
    $display("RESET INITIATED, time in ns = %0d",$time);
    wait(vif.rst);
    vif.rx <= 0;
    vif.tx_data_in <= 0;
    vif.start <= 0;
    wait(!vif.rst);
    $display("RESET TERMINATED, time in ns= %0d",$time);
  endtask
  
  
  task main;
    forever begin
      gen2driv.get(trans);
      $display("---------------------------------------------");
      $display("\t Transaction no. = %0d",no_transactions);
      //Test tx
      vif.start <= 1;
      @(posedge vif.clk);
      vif.tx_data_in <= trans.tx_data_in;
      @(posedge vif.clk);
      wait(vif.done_tx == 1);
      if(vif.done_tx == 1) begin
      $display("\t start = %0b, \t tx_data_in = %0h,\t done_tx = %0b",vif.start,trans.tx_data_in,vif.done_tx);
      $display("[TRANSACTION]::TX PASS");
      end
      else begin
      $display("\t start = %0b, \t tx_data_in = %0h,\t done_tx = %0b",vif.start,trans.tx_data_in,vif.done_tx);
      $display("[TRANSACTION]::TX FAIL");
      end  
      repeat(100) @(posedge vif.clk);
      //Test rx
	    @(posedge vif.clk);
	    data = $random;
	    vif.rx <= 1'b0;
	    repeat(clock_divide) @(posedge vif.clk);
	    for(int i=0;i<8;i++) begin
	    vif.rx <= data[i];
	    repeat(clock_divide) @(posedge vif.clk);
	    end
	    vif.rx <= 1'b1;
	    repeat(clock_divide) @(posedge vif.clk);
	    repeat(100) @(posedge vif.clk);
	    $display("\t Expected data = %0h, \t Obtained data = %0h", data,vif.rx_data_out);
	    begin
	    if(vif.rx_data_out == data) begin
	    $display("[TRANSACTION]::RX PASS");
	    $display("---------------------------------------------");
	    end
	    else begin 
	    $display("[TRANSACTION]::RX FAIL");
	    $display("---------------------------------------------");
	  end
  end
	 no_transactions++;
	end
	endtask
	
	endclass
	
