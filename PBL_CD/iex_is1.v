//is1_or_is2
//define em qual interface de saida a função deve ser mostrada baseada no usuario que requisitou a função
//1 = IS1, 0 = IS2


module iex_is1(

	input [2:0] user ,
	output output_bit
	
);

    wire [2:0] not_user;

        not not_user_1 [2:0] (not_user , user);

	wire T1 , T2;

//abc = user bits , a = [2] ... c = [0]


//~abc + a~bc

//~abc
    and and_term_1 (T1 , not_user[2] , user[1] , user[0] );
//a~bc
    and and_term_2 (T2 , user[2] , not_user[1] , user[0] );
    or or_terms (output_bit , T1 , T2);

endmodule
