
 
 program uart_test(uart_intf vif);
   
   uart_env env;
   
    
   initial begin
     env = new(vif);
     env.gen.repeat_count = 10;
     env.run();
   end
  
   
 endprogram
