//matriz_leds 3 in 6 out

module matriz_iex (

	input [2:0] func ,
	output [6:0] output_matriz

); 

    wire [2:0] not_func;

        not not_func_1 [2:0] (not_func , func);


//abc = func bits , a = [2] ... c = [0]

//~c + b + a func 1
	or or_line_0 (output_matriz[0] , not_func[0] , func[1]     , func[2]);
//~b + c + a func 2
    or or_line_1 (output_matriz[1] , not_func[1] , func[0]     , func[2]);
//~b + ~c + a func 3
	or or_line_2 (output_matriz[2] , not_func[1] , not_func[0] , func[2]);
//~a + c + b func 4
    or or_line_3 (output_matriz[3] , not_func[2] , func[0]     , func[1]);
//~a + ~c + b func 5
	or or_line_4 (output_matriz[4] , not_func[2] , not_func[0] , func[1]);
//~a + ~b + c func 6
    or or_line_5 (output_matriz[5] , not_func[2] , not_func[1] , func[0]);
//~a + ~b + ~c func 7
	or or_line_6 (output_matriz[6] , not_func[2] , not_func[1] , not_func[0]);


endmodule