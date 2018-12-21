  class uart_gen;
   
   rand uart_trans trans;
   mailbox gen2driv;
   int repeat_count;
   event ended;
   
   function new(mailbox gen2driv,event ended);
     this.gen2driv = gen2driv;
     this.ended = ended;
   endfunction
   
   task main;
     repeat(repeat_count) begin
       trans = new();
       if(!trans.randomize()) $fatal("Randomization failed");
         gen2driv.put(trans);
       end
       -> ended;
     endtask
     
   endclass
