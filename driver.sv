import p2s_pkg::*;

class p2s_driver;

   virtual interface par_to_ser_if.DRV vif;
   mailbox #(p2s_item_t) mbx_gen2drv;

   int unsigned num_items = P2S_DEFAULT_NUM_ITEMS;

   int unsigned serial_len;

   function new(virtual interface par_to_ser_if.DRV vif,
         mailbox #(p2s_item_t) mbx,
         int unsigned num_items = 10);
      this.vif = vif;
      this.mbx_gen2drv = mbx;
      this.num_items = num_items;
      this.serial_len = vif.SERIAL_LEN;
   endfunction

   task automatic reset_phase();
      vif.cb_drv.load        <= '0;
      vif.cb_drv.parallel_in <= '0;
      if (!vif.rst_n) begin
         wait (vif.rst_n == 1'b1);
         repeat (2) @(vif.cb_drv);
      end
   endtask

   task automatic run();
      p2s_item_t item;
      int i;
      reset_phase();
      repeat(3) @(vif.cb_drv);
      for (i = 0; i < num_items; i++) 
      begin
         mbx_gen2drv.get(item);
         @(vif.cb_drv);
         vif.cb_drv.parallel_in <= item.data;
         vif.cb_drv.load        <= '1;
         @(vif.cb_drv);
         vif.cb_drv.load        <= '0;
         repeat (serial_len) @(vif.cb_drv);  
      end
   endtask
   
endclass