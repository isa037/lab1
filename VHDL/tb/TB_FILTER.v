//`timescale 1ns

module tb_fir ();

   wire CLK_i;
   wire RST_n_i;
   wire [7:0] DIN0_i;
   wire [7:0] DIN1_i;
   wire [7:0] DIN2_i;
   wire VIN_i;
   wire [7:0] DOUT0_i;
   wire [7:0] DOUT1_i;
   wire [7:0] DOUT2_i;
   wire VOUT_i;
   wire END_SIM_i;
   wire [7:0] b0_i;
   wire [7:0] b1_i;
   wire [7:0] b2_i;
   wire [7:0] b3_i;
   wire [7:0] b4_i;
   wire [7:0] b5_i;
   wire [7:0] b6_i;
   wire [7:0] b7_i;
   wire [7:0] b8_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   tb_input_data_maker DM(	.CLK(CLK_i),
							.RST_n(RST_n_i),
							.VOUT(VIN_i),
							.DOUT0(DIN0_i),
							.DOUT1(DIN1_i),
							.DOUT2(DIN2_i),
							.END_SIM(END_SIM_i),
							.b0(b0_i),
							.b1(b1_i),
							.b2(b2_i),
							.b3(b3_i),
							.b4(b4_i),
							.b5(b5_i),
							.b6(b6_i),
							.b7(b7_i),
							.b8(b8_i));


   full_FIR UUT(.CLK(CLK_i),
			 .RST_n(RST_n_i),
			 .DIN0(DIN0_i),
			 .DIN1(DIN1_i),
			 .DIN2(DIN2_i),
			 .VIN(VIN_i),
			 .DOUT0(DOUT0_i),
			 .DOUT1(DOUT1_i),
			 .DOUT2(DOUT2_i),
			 .VOUT(VOUT_i),
			 .b0(b0_i),
			.b1(b1_i),
			.b2(b2_i),
			.b3(b3_i),
			.b4(b4_i),
			.b5(b5_i),
			.b6(b6_i),
			.b7(b7_i),
			.b8(b8_i));

   tb_output_data_checker DS(.CLK(CLK_i),
							 .RST_n(RST_n_i),
							 .VIN(VOUT_i),
							 .DIN0(DOUT0_i),
							 .DIN1(DOUT1_i),
							 .DIN2(DOUT2_i),
							.END_SIM(END_SIM_i));   

endmodule

		   
