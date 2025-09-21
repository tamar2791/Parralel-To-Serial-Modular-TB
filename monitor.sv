module monitor;
   //-----
   // Signal monitor
   //----
   reg [NUM_ITEMS-1:0] [7:0] parallel_in_mon;
   int			     mon_item_cnt = 0;
   
   reg [NUM_ITEMS-1:0] [7:0] serial_in_mon;
   int			     mon_cycle_cnt = 0;   
   
   initial begin
      forever begin // monitor is always on. Never controls simulation execution
	 @ (posedge clk);
	 if (load == 1'b1) begin
	    parallel_in_mon [mon_item_cnt] <= parallel_in;
	 
`ifdef MONITOR_LOG_ON
	 $display ("TIME [%0t] : ITEM %0d : Received parallel in: %h", $time (), mon_item_cnt, parallel_in);	 
`endif
	 
	    @ (posedge clk); // According to design spec, serial output starts on next cycle
	    mon_cycle_cnt = 0;	 
	    repeat (8) begin
	       serial_in_mon [mon_item_cnt] [mon_cycle_cnt++] <= serial_out;
`ifdef MONITOR_LOG_ON	        
	       $display ("TIME [%0t] : Received serial out [%0d] = %b", $time (), (mon_cycle_cnt - 1),serial_out );	    
`endif	    
	       @ (posedge clk); // move to next serial output	    
	    end
	    ++mon_item_cnt;
	 end // if (load == 1'b1)	 	 
      end // forever begin      
   end // initial begin   
endmodule