`include "traffic_light_pkg.sv"

module traffic_light 
	#(

	)
    (
       input			clk			,
	   input			rstn		,
	   input			en_i		,
	   output	tll		tl	
    );
	
	//import traffic_light_pkg::CNT_LED	;

	enum logic [1:0] {OFF, YELLOW, GREEN, RED}	state_tl;

	reg	[3:0]	cnt_tl			;
	reg	[1:0]	r_prev_state_tl	;

	always @(posedge clk) 
		if (!rstn)
			begin 
				tl.green		<=	'0	;
				tl.red			<=	'0	;
				tl.yellow		<=	'0	;
				state_tl		<=	OFF	;
				cnt_tl			<=	'0	;
				r_prev_state_tl	<=	OFF	;
			end
		else
			begin
				case(state_tl)
					OFF		:	
						begin
							tl.green	<=	1'b0					;
							tl.red		<=	1'b0					;
							tl.yellow	<=	1'b0					;
							state_tl	<=	en_i	?	RED	:	OFF	;
						end
					YELLOW	:	
						begin
							if(cnt_tl != CNT_LED)
								cnt_tl	<=	cnt_tl + 1	;
							else
								begin
									state_tl	<=	(r_prev_state_tl == GREEN) ?	RED : GREEN	;
									cnt_tl		<=	4'd0	;
									tl.red		<=	1'b0	;
								end
							
							if(cnt_tl < CNT_LED/2)
								tl.yellow	<=	1'b1		;
							else if (cnt_tl < CNT_LED)
								tl.yellow	<=	!tl.yellow	;
						end
					GREEN	:	
						begin
							if(cnt_tl != CNT_LED)
								cnt_tl	<=	cnt_tl + 1	;
							else
								begin
									state_tl		<=	YELLOW	;
									cnt_tl			<=	4'd0	;
									tl.green			<=	1'b0	;
									tl.yellow		<=	1'b1	;
									r_prev_state_tl	<=	GREEN	;
								end
							
							if(cnt_tl < CNT_LED/2)
								tl.green	<=	1'b1		;
							else if (cnt_tl < CNT_LED)
								tl.green	<=	!tl.green	;
						end
					RED		:	
						begin
							if(cnt_tl != CNT_LED)
								cnt_tl	<=	cnt_tl + 1	;
							else
								begin
									state_tl		<=	YELLOW	;
									cnt_tl			<=	4'd0	;
									tl.red			<=	1'b0	;
									tl.yellow		<=	1'b1	;
									r_prev_state_tl	<=	RED		;
								end
							
							if(cnt_tl < CNT_LED/2)
								tl.red	<=	1'b1	;
							else if (cnt_tl < CNT_LED)
								tl.red	<=	!tl.red	;
						end
					default	:	
						begin
							state_tl	<=	OFF			;
						end
				endcase
			end



endmodule