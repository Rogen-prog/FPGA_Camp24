module Cordic_atan
(
	input 						clk_50M,
	input 						rst_n,
	input 		[31:0]     		x,
	input 		[31:0]     		y,
	input               		start,

	output            			finished,
	output		[31:0] 			atan
);



`define angle_0  32'd2949120   //45째*2^16
`define angle_1  32'd1740992 //26.5651째*2^16
`define angle_2  32'd919872  //14.0362째*2^16
`define angle_3  32'd466944   //7.1250째*2^16
`define angle_4  32'd234368   //3.5763째*2^16
`define angle_5  32'd117312   //1.7899째*2^16
`define angle_6  32'd58688   //0.8952째*2^16
`define angle_7  32'd29312   //0.4476째*2^16
`define angle_8  32'd14656   //0.2238째*2^16
`define angle_9  32'd7360    //0.1119째*2^16
`define angle_10 32'd3648    //0.0560째*2^16
`define angle_11 32'd1856	//0.0280째*2^16
`define angle_12 32'd896    //0.0140째*2^16
`define angle_13 32'd448    //0.0070째*2^16
`define angle_14 32'd256    //0.0035째*2^16
`define angle_15 32'd128    //0.0018째*2^16

parameter Pipeline = 16;
parameter K = 32'h09b74;	//K=0.607253*2^16,32'h09b74,

reg signed 	[31:0] 		atan;
reg signed 	[31:0] 		x0=0,y0=0,z0=0;
reg signed 	[31:0] 		x1=0,y1=0,z1=0;
reg signed 	[31:0] 		x2=0,y2=0,z2=0;
reg signed 	[31:0] 		x3=0,y3=0,z3=0;
reg signed 	[31:0] 		x4=0,y4=0,z4=0;
reg signed 	[31:0] 		x5=0,y5=0,z5=0;
reg signed 	[31:0] 		x6=0,y6=0,z6=0;
reg signed 	[31:0] 		x7=0,y7=0,z7=0;
reg signed 	[31:0] 		x8=0,y8=0,z8=0;
reg signed 	[31:0] 		x9=0,y9=0,z9=0;
reg signed 	[31:0] 		x10=0,y10=0,z10=0;
reg signed 	[31:0] 		x11=0,y11=0,z11=0;
reg signed 	[31:0] 		x12=0,y12=0,z12=0;
reg signed 	[31:0] 		x13=0,y13=0,z13=0;
reg signed 	[31:0] 		x14=0,y14=0,z14=0;
reg signed 	[31:0] 		x15=0,y15=0,z15=0;
reg signed 	[31:0] 		/*x16=0,y16=0,*/z16=0;
               
reg  [4:0]           count;

always@ (posedge clk_50M or negedge rst_n) begin
	if(!rst_n)
	  count <= 4'b00;
	else if( start ) begin
		if( count!=5'd18 )
	    count <= count+1'b1;
	  else if( count == 5'd18 )
	    count <= 0;
	end
	else
	  count <= 5'h00;
end

assign finished = (count == 5'd18)?1'b1:1'b0;

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x0 <= 1'b0; 						
		y0 <= 1'b0;
		z0 <= 1'b0;
	end
	else
	begin
		x0 <= x;
		y0 <= y;
		z0 <= 0;
	end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x1 <= 1'b0; 						
		y1 <= 1'b0;
		z1 <= 1'b0;
	end
	else if(x0[31] == y0[31])//Di is -1竊?
	begin
      x1 <= x0 + y0;
      y1 <= y0 - x0;
      z1 <= z0 + `angle_0;
	end
	else
	begin  //Di is 1竊?
      x1 <= x0 - y0;
      y1 <= y0 + x0;
      z1 <= z0 - `angle_0;
	end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x2 <= 1'b0; 						
		y2 <= 1'b0;
		z2 <= 1'b0;
	end
	else if(x1[31] == y1[31])
   begin
        x2 <= x1 + (y1 >>> 1);
        y2 <= y1 - (x1 >>> 1);
        z2 <= z1 + `angle_1;
   end
   else
   begin
       x2 <= x1 - (y1 >>> 1);
       y2 <= y1 + (x1 >>> 1);
       z2 <= z1 - `angle_1;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x3 <= 1'b0; 						
		y3 <= 1'b0;
		z3 <= 1'b0;
	end
	else if(x2[31] == y2[31])
   begin
       x3 <= x2 + (y2 >>> 2);
       y3 <= y2 - (x2 >>> 2);
       z3 <= z2 + `angle_2;
   end
   else
   begin
       x3 <= x2 - (y2 >>> 2);
       y3 <= y2 + (x2 >>> 2);
       z3 <= z2 - `angle_2;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x4 <= 1'b0; 						
		y4 <= 1'b0;
		z4 <= 1'b0;
	end
	else if(x3[31] == y3[31])
   begin
       x4 <= x3 + (y3 >>> 3);
       y4 <= y3 - (x3 >>> 3);
       z4 <= z3 + `angle_3;
   end
   else
   begin
       x4 <= x3 - (y3 >>> 3);
       y4 <= y3 + (x3 >>> 3);
       z4 <= z3 - `angle_3;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x5 <= 1'b0; 						
		y5 <= 1'b0;
		z5 <= 1'b0;
	end
	else if(x4[31] == y4[31])
   begin
       x5 <= x4 + (y4 >>> 4);
       y5 <= y4 - (x4 >>> 4);
       z5 <= z4 + `angle_4;
   end
   else
   begin
       x5 <= x4 - (y4 >>> 4);
       y5 <= y4 + (x4 >>> 4);
       z5 <= z4 - `angle_4;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x6 <= 1'b0; 						
		y6 <= 1'b0;
		z6 <= 1'b0;
	end
	else if(x5[31] == y5[31])
   begin
       x6 <= x5 + (y5 >>> 5);
       y6 <= y5 - (x5 >>> 5);
       z6 <= z5 + `angle_5;
   end
   else
   begin
       x6 <= x5 - (y5 >>> 5);
       y6 <= y5 + (x5 >>> 5);
       z6 <= z5 - `angle_5;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x7 <= 1'b0; 						
		y7 <= 1'b0;
		z7 <= 1'b0;
	end
	else if(x6[31] == y6[31])
   begin
       x7 <= x6 + (y6 >>> 6);
       y7 <= y6 - (x6 >>> 6);
       z7 <= z6 + `angle_6;
   end
   else
   begin
       x7 <= x6 - (y6 >>> 6);
       y7 <= y6 + (x6 >>> 6);
       z7 <= z6 - `angle_6;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x8 <= 1'b0; 						
		y8 <= 1'b0;
		z8 <= 1'b0;
	end
	else if(x7[31] == y7[31])
   begin
       x8 <= x7 + (y7 >>> 7);
       y8 <= y7 - (x7 >>> 7);
       z8 <= z7 + `angle_7;
   end
   else
   begin
       x8 <= x7 - (y7 >>> 7);
       y8 <= y7 + (x7 >>> 7);
       z8 <= z7 - `angle_7;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x9 <= 1'b0; 						
		y9 <= 1'b0;
		z9 <= 1'b0;
	end
	else if(x8[31] == y8[31])
   begin
       x9 <= x8 + (y8 >>> 8);
       y9 <= y8 - (x8 >>> 8);
       z9 <= z8 + `angle_8;
   end
   else
   begin
       x9 <= x8 - (y8 >>> 8);
       y9 <= y8 + (x8 >>> 8);
       z9 <= z8 - `angle_8;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x10 <= 1'b0; 						
		y10 <= 1'b0;
		z10 <= 1'b0;
	end
	else if(x9[31] == y9[31])
   begin
       x10 <= x9 + (y9 >>> 9);
       y10 <= y9 - (x9 >>> 9);
       z10 <= z9 + `angle_9;
   end
   else
   begin
       x10 <= x9 - (y9 >>> 9);
       y10 <= y9 + (x9 >>> 9);
       z10 <= z9 - `angle_9;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x11 <= 1'b0; 						
		y11 <= 1'b0;
		z11 <= 1'b0;
	end
	else if(x1[31] == y10[31])
   begin
       x11 <= x10 + (y10 >>> 10);
       y11 <= y10 - (x10 >>> 10);
       z11 <= z10 + `angle_10;
   end
   else
   begin
       x11 <= x10 - (y10 >>> 10);
       y11 <= y10 + (x10 >>> 10);
       z11 <= z10 - `angle_10;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x12 <= 1'b0; 						
		y12 <= 1'b0;
		z12 <= 1'b0;
	end
	else if(x11[31] == y11[31])
   begin
       x12 <= x11 + (y11 >>> 11);
       y12 <= y11 - (x11 >>> 11);
       z12 <= z11 + `angle_11;
   end
   else
   begin
       x12 <= x11 - (y11 >>> 11);
       y12 <= y11 + (x11 >>> 11);
       z12 <= z11 - `angle_11;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x13 <= 1'b0; 						
		y13 <= 1'b0;
		z13 <= 1'b0;
	end
	else if(x12[31] == y12[31])
   begin
       x13 <= x12 + (y12 >>> 12);
       y13 <= y12 - (x12 >>> 12);
       z13 <= z12 + `angle_12;
   end
   else
   begin
       x13 <= x12 - (y12 >>> 12);
       y13 <= y12 + (x12 >>> 12);
       z13 <= z12 - `angle_12;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x14 <= 1'b0; 						
		y14 <= 1'b0;
		z14 <= 1'b0;
	end
	else if(x13[31] == y13[31])
   begin
       x14 <= x13 + (y13 >>> 13);
       y14 <= y13 - (x13 >>> 13);
       z14 <= z13 + `angle_13;
   end
   else
   begin
       x14 <= x13 - (y13 >>> 13);
       y14 <= y13 + (x13 >>> 13);
       z14 <= z13 - `angle_13;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		x15 <= 1'b0; 						
		y15 <= 1'b0;
		z15 <= 1'b0;
	end
	else if(x14[31] == y14[31])
   begin
       x15 <= x14 + (y14 >>> 14);
       y15 <= y14 - (x14 >>> 14);
       z15 <= z14 + `angle_14;
   end
   else
   begin
       x15 <= x14 - (y14 >>> 14);
       y15 <= y14 + (x14 >>> 14);
       z15 <= z14 - `angle_14;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n)
	begin
		z16 <= 1'b0;
	end
	else if(x15[31] == y15[31])
   begin
//       x16 <= x15 + (y15 >>> 15);
//       y16 <= y15 - (x15 >>> 15);
       z16 <= z15 + `angle_15;
   end
   else
   begin
//       x16 <= x15 - (y15 >>> 15);
//       y16 <= y15 + (x15 >>> 15);
       z16 <= z15 - `angle_15;
   end
end

always @ (posedge clk_50M or negedge rst_n)
begin
	if(!rst_n) begin
		atan <= 1'b0;
	end
	else if(finished)begin
		atan <= z16>>16;
	end
end

endmodule
