//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Hyunho Song
//
// Create Date:   12:00:00 0/00/2023
// Design Name:   lcd_controller
// Module Name:   lcd_controller.v
// Project Name:  
// Target Devices: 
// Tool versions: 
// Dependencies:
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`timescale  1ns/1ns

module lcd_controller(/*AUTOARG*/
   // Outputs
   scl,
   // Inouts
   sda,
   // Inputs
   clk_156, reset_n
   ); 
   
   /////////////////////////////////////////////////////////////////////////////////
   /////////////////////////////////////////////////////////////////////////////////
   // Start of External Port Definition
   input        clk;
   input 	reset_n;
   
   output 	scl;
   inout 	sda;

   wire 	sda;
   wire 	scl;
   reg 		sda_int = 1'b1;
   reg 		sda_t = 1'b1;

   assign sda = sda_t ? sda_int : 1'bz;

   parameter [7:0] I2C_DEVICE_ID = 8'h50;
   parameter [7:0] I2C_DATA1 = 8'b0100_1010; // J
   parameter [7:0] I2C_DATA2 = 8'b0100_1010; // J

   parameter [7:0] I2C_DATA3 = 8'b0010_0000; // Blank

   parameter [7:0] I2C_DATA4 = 8'b0100_0101; // E
   parameter [7:0] I2C_DATA5 = 8'b0100_1100; // L
   parameter [7:0] I2C_DATA6 = 8'b0100_0101; // E
   parameter [7:0] I2C_DATA7 = 8'b0100_0011; // C
   parameter [7:0] I2C_DATA8 = 8'b0101_0100; // T
   parameter [7:0] I2C_DATA9 = 8'b0101_0010; // R
   parameter [7:0] I2C_DATA10 = 8'b0100_1111; // O
   parameter [7:0] I2C_DATA11 = 8'b0100_1110; // N
   parameter [7:0] I2C_DATA12 = 8'b0100_1001; // I
   parameter [7:0] I2C_DATA13 = 8'b0100_0011; // C
   parameter [7:0] I2C_DATA14 = 8'b0101_0011; // S


   // for sim
//   parameter [31:0] SEC_3_2ms = 32'd5;
//   parameter [31:0] SEC_6_4ms = 32'd10;
//   parameter [31:0] SEC_12_8ms = 32'd20;


   parameter [31:0] SEC_3_2ms = 32'd100000;
   parameter [31:0] SEC_6_4ms = 32'd200000;
   parameter [31:0] SEC_12_8ms = 32'd400000;
   

   
   reg [31:0] 	clk_cnt1;
   reg [31:0] 	clk_cnt2;
   reg [31:0] 	clk_cnt3;

   reg 		scl_div1;
   reg 		scl_div2;
   reg 		scl_div3;
   
   assign scl = (scl_div2_cnt > 10'd2) ? scl_div3 : 1'b1;
   
   always @(posedge clk) begin
      if(~reset_n) begin
	 clk_cnt1 <= 32'd1;
	 clk_cnt2 <= 32'd1;
	 clk_cnt3 <= 32'd1;

 	 scl_div1 <= 1'b1;
 	 scl_div2 <= 1'b1;
 	 scl_div3 <= 1'b1;

      end
      else begin
	 if(clk_cnt1 == SEC_3_2ms) begin
	    clk_cnt1 <= 32'd1;
	    scl_div1 <= ~scl_div1;
	 end
	 else begin
	    clk_cnt1 <= clk_cnt1 + 1'b1;
	 end

	 if(clk_cnt2 == SEC_6_4ms) begin
	    clk_cnt2 <= 32'd1;
	    scl_div2 <= ~scl_div2;
	 end
	 else begin
	    clk_cnt2 <= clk_cnt2 + 1'b1;
	 end

	 if(clk_cnt3 == SEC_12_8ms) begin
	    clk_cnt3 <= 32'd1;
	    scl_div3 <= ~scl_div3;
	 end
	 else begin
	    clk_cnt3 <= clk_cnt3 + 1'b1;
	 end
      end
   end

   reg [9:0] scl_div1_cnt = 10'd1;
   reg [9:0] scl_div2_cnt = 10'd1;
   reg [9:0] scl_div3_cnt = 10'd1;

   always @(posedge scl_div1) begin 
      if(scl_div1_cnt == 10'd554) begin
	 scl_div1_cnt <= 10'd1;
      end
      else begin
	 scl_div1_cnt <= scl_div1_cnt + 1'b1;
      end
   end
   
   always @(posedge scl_div2) begin
      if(scl_div2_cnt == 10'd277) begin
	 scl_div2_cnt <= scl_div2_cnt;
      end
      else begin
	 scl_div2_cnt <= scl_div2_cnt + 1'b1;
      end
   end
   
   always @(posedge scl_div3) begin
      if(scl_div3_cnt == 10'd139) begin
	 scl_div3_cnt <= scl_div3_cnt;
      end
      else begin
	 scl_div3_cnt <= scl_div3_cnt + 1'b1;
      end
   end


   always @(negedge scl_div2) begin
      if(scl_div2_cnt == 10'd2) begin  // start
	 sda_t <= 1'b1;
	 sda_int <= 1'b0;
      end
      else if(scl_div2_cnt == 10'd3) begin
	 sda_int <= I2C_DEVICE_ID[7];
      end
      else if(scl_div2_cnt == 10'd5) begin
	 sda_int <= I2C_DEVICE_ID[6];
      end
      else if(scl_div2_cnt == 10'd7) begin
	 sda_int <= I2C_DEVICE_ID[5];
      end
      else if(scl_div2_cnt == 10'd9) begin
	 sda_int <= I2C_DEVICE_ID[4];
      end
      else if(scl_div2_cnt == 10'd11) begin
	 sda_int <= I2C_DEVICE_ID[3];
      end
      else if(scl_div2_cnt == 10'd13) begin
	 sda_int <= I2C_DEVICE_ID[2];
      end
      else if(scl_div2_cnt == 10'd15) begin
	 sda_int <= I2C_DEVICE_ID[1];
      end
      else if(scl_div2_cnt == 10'd17) begin
	 sda_int <= I2C_DEVICE_ID[0];
      end
      else if(scl_div2_cnt == 10'd19) begin // ack1
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd21) begin // J
	 sda_int <= I2C_DATA1[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd23) begin // 
	 sda_int <= I2C_DATA1[6];
      end
      else if(scl_div2_cnt == 10'd25) begin //
	 sda_int <= I2C_DATA1[5];
      end
      else if(scl_div2_cnt == 10'd27) begin //
	 sda_int <= I2C_DATA1[4];
      end
      else if(scl_div2_cnt == 10'd29) begin //
	 sda_int <= I2C_DATA1[3];
      end
      else if(scl_div2_cnt == 10'd31) begin //
	 sda_int <= I2C_DATA1[2];
      end
      else if(scl_div2_cnt == 10'd33) begin //
	 sda_int <= I2C_DATA1[1];
      end
      else if(scl_div2_cnt == 10'd35) begin //
	 sda_int <= I2C_DATA1[0];
      end
      else if(scl_div2_cnt == 10'd37) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd39) begin // J
	 sda_int <= I2C_DATA2[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd41) begin // 
	 sda_int <= I2C_DATA2[6];
      end
      else if(scl_div2_cnt == 10'd43) begin // 
	 sda_int <= I2C_DATA2[5];
      end
      else if(scl_div2_cnt == 10'd45) begin //
	 sda_int <= I2C_DATA2[4];
      end
      else if(scl_div2_cnt == 10'd47) begin // 
	 sda_int <= I2C_DATA2[3];
      end
      else if(scl_div2_cnt == 10'd49) begin // 
	 sda_int <= I2C_DATA2[2];
      end
      else if(scl_div2_cnt == 10'd51) begin // 
	 sda_int <= I2C_DATA2[1];
      end
      else if(scl_div2_cnt == 10'd53) begin //
	 sda_int <= I2C_DATA2[0];
      end
      else if(scl_div2_cnt == 10'd55) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd57) begin // Blank
	 sda_int <= I2C_DATA3[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd59) begin // 
	 sda_int <= I2C_DATA3[6];
      end
      else if(scl_div2_cnt == 10'd61) begin // 
	 sda_int <= I2C_DATA3[5];
      end
      else if(scl_div2_cnt == 10'd63) begin //
	 sda_int <= I2C_DATA3[4];
      end
      else if(scl_div2_cnt == 10'd65) begin // 
	 sda_int <= I2C_DATA3[3];
      end
      else if(scl_div2_cnt == 10'd67) begin // 
	 sda_int <= I2C_DATA3[2];
      end
      else if(scl_div2_cnt == 10'd69) begin // 
	 sda_int <= I2C_DATA3[1];
      end
      else if(scl_div2_cnt == 10'd71) begin //
	 sda_int <= I2C_DATA3[0];
      end
      else if(scl_div2_cnt == 10'd73) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end


      else if(scl_div2_cnt == 10'd75) begin // E
	 sda_int <= I2C_DATA4[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd77) begin // 
	 sda_int <= I2C_DATA4[6];
      end
      else if(scl_div2_cnt == 10'd79) begin // 
	 sda_int <= I2C_DATA4[5];
      end
      else if(scl_div2_cnt == 10'd81) begin //
	 sda_int <= I2C_DATA4[4];
      end
      else if(scl_div2_cnt == 10'd83) begin // 
	 sda_int <= I2C_DATA4[3];
      end
      else if(scl_div2_cnt == 10'd85) begin // 
	 sda_int <= I2C_DATA4[2];
      end
      else if(scl_div2_cnt == 10'd87) begin // 
	 sda_int <= I2C_DATA4[1];
      end
      else if(scl_div2_cnt == 10'd89) begin //
	 sda_int <= I2C_DATA4[0];
      end
      else if(scl_div2_cnt == 10'd91) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd93) begin // L
	 sda_int <= I2C_DATA5[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd95) begin // 
	 sda_int <= I2C_DATA5[6];
      end
      else if(scl_div2_cnt == 10'd97) begin // 
	 sda_int <= I2C_DATA5[5];
      end
      else if(scl_div2_cnt == 10'd99) begin //
	 sda_int <= I2C_DATA5[4];
      end
      else if(scl_div2_cnt == 10'd101) begin // 
	 sda_int <= I2C_DATA5[3];
      end
      else if(scl_div2_cnt == 10'd103) begin // 
	 sda_int <= I2C_DATA5[2];
      end
      else if(scl_div2_cnt == 10'd105) begin // 
	 sda_int <= I2C_DATA5[1];
      end
      else if(scl_div2_cnt == 10'd107) begin //
	 sda_int <= I2C_DATA5[0];
      end
      else if(scl_div2_cnt == 10'd109) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd111) begin // E
	 sda_int <= I2C_DATA6[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd113) begin // 
	 sda_int <= I2C_DATA6[6];
      end
      else if(scl_div2_cnt == 10'd115) begin // 
	 sda_int <= I2C_DATA6[5];
      end
      else if(scl_div2_cnt == 10'd117) begin //
	 sda_int <= I2C_DATA6[4];
      end
      else if(scl_div2_cnt == 10'd119) begin // 
	 sda_int <= I2C_DATA6[3];
      end
      else if(scl_div2_cnt == 10'd121) begin // 
	 sda_int <= I2C_DATA6[2];
      end
      else if(scl_div2_cnt == 10'd123) begin // 
	 sda_int <= I2C_DATA6[1];
      end
      else if(scl_div2_cnt == 10'd125) begin //
	 sda_int <= I2C_DATA6[0];
      end
      else if(scl_div2_cnt == 10'd127) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd129) begin // C
	 sda_int <= I2C_DATA7[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd131) begin // 
	 sda_int <= I2C_DATA7[6];
      end
      else if(scl_div2_cnt == 10'd133) begin // 
	 sda_int <= I2C_DATA7[5];
      end
      else if(scl_div2_cnt == 10'd135) begin //
	 sda_int <= I2C_DATA7[4];
      end
      else if(scl_div2_cnt == 10'd137) begin // 
	 sda_int <= I2C_DATA7[3];
      end
      else if(scl_div2_cnt == 10'd139) begin // 
	 sda_int <= I2C_DATA7[2];
      end
      else if(scl_div2_cnt == 10'd141) begin // 
	 sda_int <= I2C_DATA7[1];
      end
      else if(scl_div2_cnt == 10'd143) begin //
	 sda_int <= I2C_DATA7[0];
      end
      else if(scl_div2_cnt == 10'd145) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end


      else if(scl_div2_cnt == 10'd147) begin // T
	 sda_int <= I2C_DATA8[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd149) begin // 
	 sda_int <= I2C_DATA8[6];
      end
      else if(scl_div2_cnt == 10'd151) begin // 
	 sda_int <= I2C_DATA8[5];
      end
      else if(scl_div2_cnt == 10'd153) begin //
	 sda_int <= I2C_DATA8[4];
      end
      else if(scl_div2_cnt == 10'd155) begin // 
	 sda_int <= I2C_DATA8[3];
      end
      else if(scl_div2_cnt == 10'd157) begin // 
	 sda_int <= I2C_DATA8[2];
      end
      else if(scl_div2_cnt == 10'd159) begin // 
	 sda_int <= I2C_DATA8[1];
      end
      else if(scl_div2_cnt == 10'd161) begin //
	 sda_int <= I2C_DATA8[0];
      end
      else if(scl_div2_cnt == 10'd163) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd165) begin // R
	 sda_int <= I2C_DATA9[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd167) begin // 
	 sda_int <= I2C_DATA9[6];
      end
      else if(scl_div2_cnt == 10'd169) begin // 
	 sda_int <= I2C_DATA9[5];
      end
      else if(scl_div2_cnt == 10'd171) begin //
	 sda_int <= I2C_DATA9[4];
      end
      else if(scl_div2_cnt == 10'd173) begin // 
	 sda_int <= I2C_DATA9[3];
      end
      else if(scl_div2_cnt == 10'd175) begin // 
	 sda_int <= I2C_DATA9[2];
      end
      else if(scl_div2_cnt == 10'd177) begin // 
	 sda_int <= I2C_DATA9[1];
      end
      else if(scl_div2_cnt == 10'd179) begin //
	 sda_int <= I2C_DATA9[0];
      end
      else if(scl_div2_cnt == 10'd181) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd183) begin // O
	 sda_int <= I2C_DATA10[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd185) begin // 
	 sda_int <= I2C_DATA10[6];
      end
      else if(scl_div2_cnt == 10'd187) begin // 
	 sda_int <= I2C_DATA10[5];
      end
      else if(scl_div2_cnt == 10'd189) begin //
	 sda_int <= I2C_DATA10[4];
      end
      else if(scl_div2_cnt == 10'd191) begin // 
	 sda_int <= I2C_DATA10[3];
      end
      else if(scl_div2_cnt == 10'd193) begin // 
	 sda_int <= I2C_DATA10[2];
      end
      else if(scl_div2_cnt == 10'd195) begin // 
	 sda_int <= I2C_DATA10[1];
      end
      else if(scl_div2_cnt == 10'd197) begin //
	 sda_int <= I2C_DATA10[0];
      end
      else if(scl_div2_cnt == 10'd199) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end


      else if(scl_div2_cnt == 10'd201) begin // N
	 sda_int <= I2C_DATA11[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd203) begin // 
	 sda_int <= I2C_DATA11[6];
      end
      else if(scl_div2_cnt == 10'd205) begin // 
	 sda_int <= I2C_DATA11[5];
      end
      else if(scl_div2_cnt == 10'd207) begin //
	 sda_int <= I2C_DATA11[4];
      end
      else if(scl_div2_cnt == 10'd209) begin // 
	 sda_int <= I2C_DATA11[3];
      end
      else if(scl_div2_cnt == 10'd211) begin // 
	 sda_int <= I2C_DATA11[2];
      end
      else if(scl_div2_cnt == 10'd213) begin // 
	 sda_int <= I2C_DATA11[1];
      end
      else if(scl_div2_cnt == 10'd215) begin //
	 sda_int <= I2C_DATA11[0];
      end
      else if(scl_div2_cnt == 10'd217) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end


      else if(scl_div2_cnt == 10'd219) begin // I
	 sda_int <= I2C_DATA12[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd221) begin // 
	 sda_int <= I2C_DATA12[6];
      end
      else if(scl_div2_cnt == 10'd223) begin // 
	 sda_int <= I2C_DATA12[5];
      end
      else if(scl_div2_cnt == 10'd225) begin //
	 sda_int <= I2C_DATA12[4];
      end
      else if(scl_div2_cnt == 10'd227) begin // 
	 sda_int <= I2C_DATA12[3];
      end
      else if(scl_div2_cnt == 10'd229) begin // 
	 sda_int <= I2C_DATA12[2];
      end
      else if(scl_div2_cnt == 10'd231) begin // 
	 sda_int <= I2C_DATA12[1];
      end
      else if(scl_div2_cnt == 10'd233) begin //
	 sda_int <= I2C_DATA12[0];
      end
      else if(scl_div2_cnt == 10'd235) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd237) begin // C
	 sda_int <= I2C_DATA13[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd239) begin // 
	 sda_int <= I2C_DATA13[6];
      end
      else if(scl_div2_cnt == 10'd241) begin // 
	 sda_int <= I2C_DATA13[5];
      end
      else if(scl_div2_cnt == 10'd243) begin //
	 sda_int <= I2C_DATA13[4];
      end
      else if(scl_div2_cnt == 10'd245) begin // 
	 sda_int <= I2C_DATA13[3];
      end
      else if(scl_div2_cnt == 10'd247) begin // 
	 sda_int <= I2C_DATA13[2];
      end
      else if(scl_div2_cnt == 10'd249) begin // 
	 sda_int <= I2C_DATA13[1];
      end
      else if(scl_div2_cnt == 10'd251) begin //
	 sda_int <= I2C_DATA13[0];
      end
      else if(scl_div2_cnt == 10'd253) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end

      else if(scl_div2_cnt == 10'd255) begin // S
	 sda_int <= I2C_DATA14[7];
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd257) begin // 
	 sda_int <= I2C_DATA14[6];
      end
      else if(scl_div2_cnt == 10'd259) begin // 
	 sda_int <= I2C_DATA14[5];
      end
      else if(scl_div2_cnt == 10'd261) begin //
	 sda_int <= I2C_DATA14[4];
      end
      else if(scl_div2_cnt == 10'd263) begin // 
	 sda_int <= I2C_DATA14[3];
      end
      else if(scl_div2_cnt == 10'd265) begin // 
	 sda_int <= I2C_DATA14[2];
      end
      else if(scl_div2_cnt == 10'd267) begin // 
	 sda_int <= I2C_DATA14[1];
      end
      else if(scl_div2_cnt == 10'd269) begin //
	 sda_int <= I2C_DATA14[0];
      end
      else if(scl_div2_cnt == 10'd271) begin //
	 sda_int <= 1'b0;
	 sda_t <= 1'b0;
      end
      
      else if(scl_div2_cnt == 10'd273) begin // stop
	 sda_int <= 1'b0;
	 sda_t <= 1'b1;
      end
      else if(scl_div2_cnt == 10'd274) begin // stop
	 sda_int <= 1'b1;
	 sda_t <= 1'b1;
      end

      else if(scl_div2_cnt == 10'd277) begin
	 sda_int <= 1'b1;
	 sda_t <= 1'b1;
      end
   end // always @ (negedge scl_div2)
   
   
endmodule

