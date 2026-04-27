//ahb_transaction ahb_trans;
covergroup UART_IP with function sample(ahb_transaction ahb_trans);
     option.per_instance = 1;
     option.name = "uart_cov";

     ahb_transfer: coverpoint ahb_trans.xact_type {
          bins ahb_read  = {ahb_transaction::READ};
          bins ahb_write = {ahb_transaction::WRITE};
     }
     ahb_address: coverpoint ahb_trans.addr {
          bins MDR_addr  = {32'h00};
          bins DLL_addr  = {32'h04};
          bins DLH_addr  = {32'h08};
          bins LCR_addr  = {32'h0C};
          bins IER_addr  = {32'h10};
          bins FSR_addr  = {32'h14};
          bins TBR_addr  = {32'h18};
          bins RBR_addr  = {32'h1C};
     }
     ahb_data: coverpoint ahb_trans.data {
          bins osm_sel_mode   = {[0:1]};
          bins dll_div        = {[0:255]};
          bins dlh_div        = {[0:255]};
          bins uart_frame     = {[0:77]};
          bins enable_int     = {1, 2, 4, 5, 8, 10, 12};
          bins fifo_status    = {1, 2, 4, 5, 8, 10, 12};
          bins tx_data        = {[0:255]};
          bins rx_data        = {[0:255]};
     }
     transaction: cross ahb_transfer, ahb_address
     {
          bins trans_1 = binsof(ahb_transfer.ahb_write); //&& binsof(ahb_address.MDR_addr);
          bins trans_2 = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr);
          bins trans_3 = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr);
          bins trans_4 = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr);
          bins trans_5 = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr);
     }
     mode_oversampling: cross ahb_transfer, ahb_address, ahb_data
     {
          bins mode_1         = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins mode_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.dll_div);
          ignore_bins mode_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins mode_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.enable_int);
          ignore_bins mode_6  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins mode_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.tx_data);
          ignore_bins mode_8  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.rx_data);

          bins mode_9          = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins mode_10  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.dll_div);
          ignore_bins mode_11  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.dlh_div);
          ignore_bins mode_12  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins mode_13  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.enable_int);
          ignore_bins mode_14  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins mode_15  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.tx_data);
          ignore_bins mode_16  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.MDR_addr) && binsof(ahb_data.rx_data);
     }
     dll_divisor: cross ahb_transfer, ahb_address, ahb_data
     {
          bins dll_1         = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.dll_div);
          ignore_bins dll_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins dll_3  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.uart_frame);
          ignore_bins dll_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.enable_int);
          ignore_bins dll_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.fifo_status);
          ignore_bins dll_6  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.tx_data);
          ignore_bins dll_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.rx_data);

          ignore_bins dll_8   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins dll_9   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.dll_div);
          ignore_bins dll_10  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.uart_frame);
          ignore_bins dll_11  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.enable_int);
          ignore_bins dll_12  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.fifo_status);
          ignore_bins dll_13  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.tx_data);
          ignore_bins dll_14  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLL_addr) && binsof(ahb_data.rx_data);
     }
     dlh_divisor: cross ahb_transfer, ahb_address, ahb_data
     {
          bins dlh_1         = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.dlh_div);
          ignore_bins dlh_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins dlh_3  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.uart_frame);
          ignore_bins dlh_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.enable_int);
          ignore_bins dlh_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.fifo_status);
          ignore_bins dlh_6  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.tx_data);
          ignore_bins dlh_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.rx_data);

          ignore_bins dlh_8   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins dlh_9   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.dlh_div);
          ignore_bins dlh_10  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.uart_frame);
          ignore_bins dlh_11  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.enable_int);
          ignore_bins dlh_12  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.fifo_status);
          ignore_bins dlh_13  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.tx_data);
          ignore_bins dlh_14  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.DLH_addr) && binsof(ahb_data.rx_data);
     }
     uart_setting: cross ahb_transfer, ahb_address, ahb_data
     {    
          bins uart_1         = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins uart_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.dll_div);
          ignore_bins uart_3  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins uart_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.enable_int);
          ignore_bins uart_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins uart_6  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.tx_data);
          ignore_bins uart_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.rx_data);

          ignore_bins uart_8   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins uart_9   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.dll_div);
          ignore_bins uart_10  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins uart_11  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.enable_int);
          ignore_bins uart_12  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins uart_13  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.tx_data);
          ignore_bins uart_14  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.LCR_addr) && binsof(ahb_data.rx_data);
     }
     interrupt_setting: cross ahb_transfer, ahb_address, ahb_data
     {
          bins int_1         = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.IER_addr) && binsof(ahb_data.enable_int);
          ignore_bins int_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.IER_addr) && binsof(ahb_data.uart_frame);
          ignore_bins int_3  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.IER_addr) && binsof(ahb_data.dll_div);
          ignore_bins int_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.IER_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins int_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.IER_addr) && binsof(ahb_data.fifo_status);
          ignore_bins int_6  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.IER_addr) && binsof(ahb_data.tx_data);
          ignore_bins int_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.IER_addr) && binsof(ahb_data.rx_data);

          ignore_bins int_8   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.IER_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins int_9   = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.IER_addr) && binsof(ahb_data.dll_div);
          ignore_bins int_10  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.IER_addr) && binsof(ahb_data.uart_frame);
          ignore_bins int_11  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.IER_addr) && binsof(ahb_data.enable_int);
          ignore_bins int_12  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.IER_addr) && binsof(ahb_data.fifo_status);
          ignore_bins int_13  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.IER_addr) && binsof(ahb_data.tx_data);
          ignore_bins int_14  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.IER_addr) && binsof(ahb_data.rx_data);
     }
     fifo_status: cross ahb_transfer, ahb_address, ahb_data
     {
          ignore_bins status_1  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.enable_int);
          ignore_bins status_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins status_3  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.dll_div);
          ignore_bins status_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins status_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins status_6  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.tx_data);
          ignore_bins status_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.rx_data);

          bins status_8         = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins status_9  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins status_10 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.dll_div);
          ignore_bins status_11 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins status_12 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.enable_int);
          ignore_bins status_13 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.tx_data);
          ignore_bins status_14 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.FSR_addr) && binsof(ahb_data.rx_data);
     }
     transmit_buffer: cross ahb_transfer, ahb_address, ahb_data
     {
          ignore_bins transmit_1  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.enable_int);
          ignore_bins transmit_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins transmit_3  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.dll_div);
          ignore_bins transmit_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins transmit_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.fifo_status);
          bins transmit_6         = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.tx_data);
          ignore_bins transmit_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.rx_data);

          ignore_bins transmit_8  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins transmit_9  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins transmit_10 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.dll_div);
          ignore_bins transmit_11 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins transmit_12 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.enable_int);
          ignore_bins transmit_13 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.tx_data);
          ignore_bins transmit_14 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.TBR_addr) && binsof(ahb_data.rx_data);
     }
     receiver_buffer: cross ahb_transfer, ahb_address, ahb_data
     {
          ignore_bins receiver_1  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.enable_int);
          ignore_bins receiver_2  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins receiver_3  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.dll_div);
          ignore_bins receiver_4  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins receiver_5  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins receiver_6  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.tx_data);
          ignore_bins receiver_7  = binsof(ahb_transfer.ahb_write) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.rx_data);

          ignore_bins receiver_8  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.fifo_status);
          ignore_bins receiver_9  = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.osm_sel_mode);
          ignore_bins receiver_10 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.dll_div);
          ignore_bins receiver_11 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.uart_frame);
          ignore_bins receiver_12 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.enable_int);
          ignore_bins receiver_13 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.tx_data);
          bins receiver_14 = binsof(ahb_transfer.ahb_read) && binsof(ahb_address.RBR_addr) && binsof(ahb_data.rx_data);
     }
 endgroup     
     
