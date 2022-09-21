`ifndef DEFS_DONE
   `define DEFS_DONE
      package traffic_light_pkg;

         parameter    [3:0] CNT_LED    =  4'd10   ;   

         typedef struct {
            reg   	green 	;
            reg   	red   	;
			reg		yellow	;
         } tll;
      endpackage

	  import traffic_light_pkg::*;

`endif