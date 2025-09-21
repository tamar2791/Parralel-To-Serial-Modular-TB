import p2s_pkg::*;

class p2s_generator;

   mailbox #(p2s_item_t) mbx_gen2drv;
   int unsigned num_items = P2S_DEFAULT_NUM_ITEMS;
   int unsigned seed = 32'hC0FF_EE01;

   function new(mailbox #(p2s_item_t)mbx,
         int unsigned num_items = P2S_DEFAULT_NUM_ITEMS,
         int unsigned seed);
      this.mbx_gen2drv = mbx;
      this.num_items = num_items;
      this.seed = seed;
   endfunction

   task automatic run();
      p2s_item_t item;
      byte tmp;

      procces::self().srandom(seed);

      for(int i = 0; i < num_items; i++)
      begin
         void'(std::randomize(tmp));
         item.data = tmp;
         mbx_gen2drv.put(item);
      end
   endtask
endclass