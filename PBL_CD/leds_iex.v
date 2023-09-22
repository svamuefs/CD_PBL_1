//leds_bar 3 in 4 out

module leds_iex (

	input [2:0] func ,
	output [3:0] output_leds
	
);

    wire [2:0] not_func;

        not not_func_1 [2:0] (not_func , func);


//abc = func bits , a = [2] ... c = [0]


//~a~bc func 1

    and and_led_0 (output_leds[0] , not_func[2] , not_func[1] , func[0]);

//~abc func 3

    and and_led_1 (output_leds[1] , not_func[2] , func[1] , func[0]);

//a~b~c func 4

    and and_led_2 (output_leds[2] , func[2] , not_func[1] , not_func[0]);

//ab~c func 6

    and and_led_3 (output_leds[3] , func[2] , func[1] , not_func[0]);

endmodule
