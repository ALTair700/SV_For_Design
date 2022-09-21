`include "traffic_light_pkg.sv"
`define print(v)	\
	$display(`"variable `\`"v`\`" = %h `", v)

module traffic_light_tb();

	reg			clk		    =   1'b1    ;
	reg			rstn		=   1'b1    ;
	reg			en_i		=   1'b0    ;
	tll			tl						;


    always #10ns clk = !clk;
	
    task rst();    
        rstn    =   1'b0    ;
		#(10*20) 
        rstn    =   1'b1    ;
    endtask

    initial 
        begin
            rst ;
            en_i    =   1'b1    ;
			#2000
			`print(en_i);
            $stop;
        end

	traffic_light test_dev 
	    (
	       .clk			(clk		)  ,
		   .rstn		(rstn	    )  ,
		   .en_i		(en_i	    )  ,
		   .tl			(tl			)
	    );
endmodule