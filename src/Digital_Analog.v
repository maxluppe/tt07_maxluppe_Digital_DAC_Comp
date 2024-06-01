module Digital_DAC ( D, Vdac );

	input [4:0] D;
	output Vdac;
	
	sky130_fd_sc_hd__nand2_1 ix1 (.Y (Vdac), .A (Vdac), .B (D[0])) ;
	sky130_fd_sc_hd__nand2_2 ix2 (.Y (Vdac), .A (Vdac), .B (D[1])) ;
	sky130_fd_sc_hd__nand2_4 ix4 (.Y (Vdac), .A (Vdac), .B (D[2])) ;
	sky130_fd_sc_hd__nand2_8 ix8 (.Y (Vdac), .A (Vdac), .B (D[3])) ;
	sky130_fd_sc_hd__nand2_8 ix16a (.Y (Vdac), .A (Vdac), .B (D[4])) ;
	sky130_fd_sc_hd__nand2_8 ix16b (.Y (Vdac), .A (Vdac), .B (D[4])) ;

	sky130_fd_sc_hd__nand2_1 ix0 (.Y (Vdac), .A (1'b1), .B (Vdac)) ;

endmodule

module NAND_Comparator_NAND02 ( CLK, VinP, VinM, OutP, OutM ) ;

    input CLK ;
    input VinP ;
    input VinM ;
    output OutP ;
    output OutM ;

    wire C, D, A, B, E, F, CLKn, CLKb;

    sky130_fd_sc_hd__clkbuf_1 ix01 (.X(CLKb), .A(CLK));
    sky130_fd_sc_hd__clkinv_1 ix02 (.Y(CLKn), .A(CLK));

    sky130_fd_sc_hd__nand2_1 ix25 (.Y (OutM), .A (D), .B (OutP)) ;
    sky130_fd_sc_hd__nand2_1 ix31 (.Y (OutP), .A (C), .B (OutM)) ;

    sky130_fd_sc_hd__nand2_1 ix108 (.Y (A), .A (CLKb), .B (VinP)) ;
    sky130_fd_sc_hd__nand2_1 ix21 (.Y (C), .A (E), .B (A)) ;
    sky130_fd_sc_hd__nand2_1 ix11 (.Y (F), .A (CLKn), .B (C)) ;
    sky130_fd_sc_hd__nand2_1 ix5 (.Y (B), .A (CLKb), .B (VinM)) ;
    sky130_fd_sc_hd__nand2_1 ix112 (.Y (D), .A (F), .B (B)) ;
    sky130_fd_sc_hd__nand2_1 ix110 (.Y (E), .A (CLKn), .B (D)) ;
	
endmodule

module NAND_Comparator_AO22 ( CLK, VinP, VinM, OutP, OutM ) ;

	input CLK ;
    	input VinP ;
    	input VinM ;
    	output OutP ;
    	output OutM ;

	wire C, D, CLKn, CLKb;

	sky130_fd_sc_hd__clkbuf_1 ix01 (.X(CLKb), .A(CLK));
	sky130_fd_sc_hd__clkinv_1 ix02 (.Y(CLKn), .A(CLK));

    	sky130_fd_sc_hd__nand2_1 ix25 (.Y (OutM), .A (D), .B (OutP)) ;
    	sky130_fd_sc_hd__nand2_1 ix31 (.Y (OutP), .A (C), .B (OutM)) ;

    	sky130_fd_sc_hd__a22o_1 ix21 (.X (C), .B1 (CLKb), .B2 (VinP), .A1 (CLKn), .A2 (D)) ;
    	sky130_fd_sc_hd__a22o_1 ix108 (.X (D), .B1 (CLKb), .B2 (VinM), .A1 (CLKn), .A2 (C)) ;

endmodule

module NAND_Comparator_MUX21_NI ( CLK, VinP, VinM, OutP, OutM ) ;

	input CLK ;
	input VinP ;
	input VinM ;
	output OutP ;
	output OutM ;

	wire C, D, CLKb;

	sky130_fd_sc_hd__clkbuf_1 ix01 (.X(CLKb), .A(CLK));


    	sky130_fd_sc_hd__nand2_1 ix25 (.Y (OutM), .A (D), .B (OutP)) ;
    	sky130_fd_sc_hd__nand2_1 ix31 (.Y (OutP), .A (C), .B (OutM)) ;

   	sky130_fd_sc_hd__mux2_1 ix21 (.X (C), .A0 (D), .A1 (VinP), .S (CLKb)) ;
    	sky130_fd_sc_hd__mux2_1 ix107 (.X (D), .A0 (C), .A1 (VinM), .S (CLKb)) ;

endmodule

module counter #(parameter SIZE=5) ( CLK, RSTN, EN, Q, COUT ) ;

	input CLK;
	input RSTN;
	input EN;	
	output reg [SIZE-1:0] Q;
	output COUT;
	
	always @(posedge(CLK) or negedge(RSTN))
		begin
			if (~RSTN)
				Q <= 0;
			else
				if (EN)
					Q <= Q + 1;
		end
	
	assign COUT = (&Q) & EN;

endmodule

module Digital_Analog ( CLK_CNT0, CLK_CNT1, CLK_COMP, RSTN, EN0, EN1, SEL, VinP, VinM, VoutP_NAND, VoutM_NAND, VoutP_AO22, VoutM_AO22, VoutP_MX21, VoutM_MX21 ) ;

	input CLK_CNT0, CLK_CNT1, CLK_COMP, RSTN, EN0, EN1, SEL;
	output VinP, VinM;
	output VoutP_NAND, VoutM_NAND;
	output VoutP_AO22, VoutM_AO22;
	output VoutP_MX21, VoutM_MX21;
	
	wire [4:0] D0;
	wire [4:0] D1;
	wire COUT0;
	
	counter #(5) u0 (
		.CLK(CLK_CNT0),
		.RSTN(RSTN),
		.EN(EN0),
		.Q(D0),
		.COUT(COUT0)
	);
	
	counter #(5) u1 (
		.CLK(SEL ? CLK_CNT1 : CLK_CNT0),
		.RSTN(RSTN),
		.EN(SEL ? EN1 : COUT0),
		.Q(D1),
		/* verilator lint_off PINCONNECTEMPTY */
		.COUT()
		/* verilator lint_on PINCONNECTEMPTY */
	);

	(* keep_hierarchy = "yes" *) Digital_DAC DDAC0 (
		.D(D0),
		.Vdac(VinP)
	);

	(* keep_hierarchy = "yes" *) Digital_DAC DDAC1 (
		.D(D1),
		.Vdac(VinM)
	);
	
	(* keep_hierarchy = "yes" *) NAND_Comparator_NAND02 Comp1a (
		.CLK(CLK_COMP),
		.VinP(VinP),
		.VinM(VinM),
		.OutP(VoutP_NAND),
		.OutM(VoutM_NAND)
	) ;
	
	(* keep_hierarchy = "yes" *) NAND_Comparator_AO22 Comp2 (
		.CLK(CLK_COMP),
		.VinP(VinP),
		.VinM(VinM),
		.OutP(VoutP_AO22),
		.OutM(VoutM_AO22)
	) ;
	
	(* keep_hierarchy = "yes" *) NAND_Comparator_MUX21_NI Comp5 (
		.CLK(CLK_COMP),
		.VinP(VinP),
		.VinM(VinM),
		.OutP(VoutP_MX21),
		.OutM(VoutM_MX21)
	) ;
	
endmodule
