module exp_golomb_code(
	input clk,
	input reset_n,
//	input logic input_enable,
	input [2:0] k,

	//本当は19bitで足りるが、本関数の処理上桁溢れする可能性があるので、
	//1bit多く用意しておく。
	input [19:0] input_data,
	output reg [23:0] output_enable,//mask
	output reg [23:0] sum,
	output wire [31:0] Q,
	output wire [5:0] CODEWORD_LENGTH

);
assign Q = q;
assign CODEWORD_LENGTH  = codeword_length;

function [31:0] getfloorclog2;
	input [19:0] val;
	begin
		reg [19:0] in_val;
		in_val = val;
		for (getfloorclog2=0; in_val>0; getfloorclog2=getfloorclog2+1) begin
			in_val = in_val>>1;
		end
		getfloorclog2 = getfloorclog2 - 1;
	end
endfunction
function [23:0] bitmask;
	input [5:0] val;
	reg [5:0] index = 6'h0;
	begin
		bitmask = 24'h1;
		for(index=1;index<val;index=index+1) begin
			bitmask = (bitmask<<1) | 1;
		end
	end
endfunction

logic [31:0] q = 32'h0;
logic [5:0] codeword_length = 6'h0;


always @(posedge clk, negedge reset_n) begin
	if (!reset_n) begin
		output_enable = 24'h0;
		sum = 24'h0;
	end else begin
		q = getfloorclog2((input_data + (1<<(k)))) - k;
		//q =  input_data + 16'h1;
		sum[19:0] = input_data + (1<<k);
		codeword_length = (2 * q) + k + 1;
		output_enable = bitmask(codeword_length);
	end
end

endmodule;
