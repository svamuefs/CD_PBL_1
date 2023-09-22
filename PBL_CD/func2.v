module func2 (
    input [2:0] func_ie1 , func_ie2 ,
    input priority ,  
    output mux_control , display_on
);

not not_1 (not_func_ie1_1_w , func_ie1[1]);
not not_2 (not_func_ie2_1_w , func_ie2[1]);

//~b + c + a  
//verifica se os usuarios estão usando a função 2
//0 = usando função 2

    or or_func2_ie1 (func2_ie1_w , not_func_ie1_1_w , func_ie1[0] , func_ie1[2]);

    or or_func2_ie2 (func2_ie2_w , not_func_ie2_1_w , func_ie2[0] , func_ie2[2]);

and and_display_on (display_on , func2_ie2_w , func2_ie1_w);

not not_3 (not_priority , priority);


//----------------------
//CONTROLE DO MUX DO DISPLAY

//~b~c + a 
//controle do mux do display

    nor nor_1 (nor_1_w , func2_ie2_w , priority);

    or or_1 (mux_control , nor_1_w , func2_ie1_w);

endmodule