`timescale 1ns/1ps
import p2s_pkg::*;

class p2s_scoreboard;

   mailbox #(p2s_txn_t) mbx_mon2sb;
   int unsigned serial_len = P2S_SERIAL_LEN;
   int unsigned num_items = 0;
   bit stop_when_done = 1;

   int unsigned seen = 0;
   int errors = 0;

   function new(mailbox #(p2s_txn_t) mbx,
         int unsigned num_items = 0,
         int unsigned serial_len = P2S_SERIAL_LEN,
         bit stop_when_done = 1);
      this.mbx_mon2sb = mbx;
      this.num_items = num_items;
      this.serial_len = serial_len;
      this.stop_when_done = stop_when_done;
   endfunction

   function void check_one(p2s_txn_t tr, int unsigned idx);
      if (tr.par !== tr.ser)
      begin
         errors++;
         for(int i = 0; i < serial_len; i++)
         begin
            if(tr.par[i] !== tr.ser[i])
            begin
               $error("SB: item %d bit %d mismatch: EXP=%b ACT=%b (par=0x%02h ser=0x%02h)",idx, i, tr.par[i], tr.ser[i], tr.par, tr.ser);
            end
         end
      end
   endfunction

   task automatic run();
      p2s_txn_t tr;
      if(num_items > 0)
      begin
         for(int unsigned i = 0; i < num_items; i++)
         begin
            mbx_mon2sb.get(tr);
            check_one(tr,i);
            seen++;
         end
         if(stop_when_done)
            report();
      end
      else
      begin
         int unsigned i = 0;
         forever begin
            mbx_mon2sb.get(tr);
            check_one(tr,i);
            i++;
            seen++;
         end
      end
   endtask

   function void report();
      $display("\n================ SCOREBOARD REPORT ================");
      $display("Checked items: %0d   Errors: %0d", seen, errors);
      if (errors == 0) $display("TEST PASS");
      else             $display("TEST FAIL (errors=%0d)", errors);
      $display("===================================================\n");
   endfunction

endclass