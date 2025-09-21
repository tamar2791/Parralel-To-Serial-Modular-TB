module tb ();
   reg clk;
   reg load;
   reg [7:0] parallel_in;
   wire	     serial_out;
   
   localparam NUM_ITEMS = 10;




   


   
   parallel_to_serial
     dut
       (.clk (clk),
	.load (load),
	.parallel_in (parallel_in),
	.serial_out (serial_out));
   

endmodule














