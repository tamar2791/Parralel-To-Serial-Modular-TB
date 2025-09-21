module driver;
   
   //-----
   // Signal driver
   //----
   int item_cntr = 0;
   
   initial begin
      // Give legal initial state to all inputs at time = 0
      load = '0;
      parallel_in = '0; // not strictly required. But cleaner
      // @ (posedge rstn); // wait for reset to be raised
      repeat (5) @ (posedge clk); 

      repeat (NUM_ITEMS) begin
	 @ (posedge clk); // Good to ensure that drive at a clock edge. 
	 #1; // We won't discuss this here, but is required 
	 load = '1;
	 parallel_in = parallel_in_gen [item_cntr++];
	 @ (posedge clk);
	 #1 load = '0;	 
	 
	 // Design assumption is that no new parallel data while is being serialized
	 repeat (8) @ (posedge clk);
	 
      end // repeat (NUM_ITEMS)

      repeat (10) @ (posedge clk);  // flush time for design
      $finish ();      // End the simulation when stimuli are done
   end // initial begin
endmodule
