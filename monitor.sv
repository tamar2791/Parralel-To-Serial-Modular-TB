import p2s_pkg::*;

class p2s_monitor;

	virtual interface par_to_ser_if.MON vif;
	mailbox #(p2s_txn_t) mbx_mon2sb;
	int unsigned serial_len;

	function new(virtual interface par_to_ser_if.MON vif,
			mailbox #(p2s_txn_t) mbx);
		this.vif = vif;
		this.mbx_mon2sb = mbx;
		this.serial_len = vif.SERIAL_LEN;
	endfunction

	task automatic reset_phase();
		if(!vif.rst_n)
		begin
			wait(vif.rst_n == 1'b1);
			repeat (2) @(vif.cb_mon);
		end
	endtask


	task automatic run();
		p2s_txn_t tr;

		reset_phase();

		forever begin
			@(vif.cb_mon);

			if(vif.cb_mon.load)
			begin
				tr.par = vif.cb_mon.parallel_in;
				@(vif.cb_mon);
				for(int i = 0; i < serial_len; i++)
				begin
					tr.ser[i] = vif.cb_mon.serial_out;
					@(vif.cb_mon);
				end
				mbx_mon2sb.put(tr);
			end
		end
	endtask

endclass