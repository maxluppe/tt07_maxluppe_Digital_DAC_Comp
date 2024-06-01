/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_maxluppe_digital_analog (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    /* verilator lint_off UNUSEDSIGNAL */
    input  wire [7:0] uio_in,   // IOs: Input path
    /* verilator lint_on UNUSEDSIGNAL */
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in[5], ui_in[6], ui_in[7], 1'b0};

  (* keep_hierarchy = "yes" *) Digital_Analog u0 (
      .CLK_CNT0(ui_in[0]),
      .CLK_CNT1(ui_in[1]),
      .CLK_COMP(clk),
      .RSTN(rst_n),
      .EN0(ui_in[2]),
      .EN1(ui_in[3]),
      .SEL(ui_in[4]),
      .VinP(uo_out[0]),
      .VinM(uo_out[1]),
      .VoutP_NAND(uo_out[2]),
      .VoutM_NAND(uo_out[3]),
      .VoutP_AO22(uo_out[4]),
      .VoutM_AO22(uo_out[5]),
      .VoutP_MX21(uo_out[6]),
      .VoutM_MX21(uo_out[7])
  );

endmodule
