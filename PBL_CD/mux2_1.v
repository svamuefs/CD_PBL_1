module mux2_1 ( 
    input [2:0] data_1 , data_2 , 
    input control , 
    output [2:0] output_data
);

    wire [2:0] and_1_w , and_2_w;

not notControl (notControl_w , control);

and and_1 [2:0] (and_1_w , data_1 , control);

and and_2 [2:0] (and_2_w , data_2 , notControl_w);

or or_out [2:0] (output_data , and_1_w , and_2_w);
endmodule