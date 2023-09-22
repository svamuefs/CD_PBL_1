//same_code_verify 6 in 1 out


module same_code (
    input [2:0] code_1 , code_2 ,
    output output_bit
);

    wire [2:0] not_code_1 , not_code_2;

        not not_code_1_1 [2:0] (not_code_1 , code_1);
        not not_code_2_1 [2:0] (not_code_2 , code_2);

    wire T1 , T2 , T3 , T4 , T5 , T6 , T7;

//abc = code 1 bits , a = [2] ... c = [0]
//def = code 2 bits , d = [2] ... f  = [0]

//~a~bc~d~ef + ~ab~c~de~f + ~abc~def + a~b~cd~e~f + a~bcd~ef + ab~cde~f + abcdef

//~a~bc~d~ef

    and and_term_1 (T1 , 
    not_code_1[2] , not_code_1[1] , code_1[0] , 
    not_code_2[2] , not_code_2[1] , code_2[0] ); 

//~ab~c~de~f

    and and_term_2 (T2 , 
    not_code_1[2] , code_1[1] , not_code_1[0] , 
    not_code_2[2] , code_2[1] , not_code_2[0] ); 

//~abc~def

    and and_term_3 (T3 , 
    not_code_1[2] , code_1[1] , code_1[0] , 
    not_code_2[2] , code_2[1] , code_2[0] ); 

//a~b~cd~e~f

    and and_term_4 (T4 , 
    code_1[2] , not_code_1[1] , not_code_1[0] , 
    code_2[2] , not_code_2[1] , not_code_2[0] );

//a~bcd~ef

    and and_term_5 (T5 , 
    code_1[2] , not_code_1[1] , code_1[0] , 
    code_2[2] , not_code_2[1] , code_2[0] );

//ab~cde~f

    and and_term_6 (T6 , 
    code_1[2] , code_1[1] , not_code_1[0] , 
    code_2[2] , code_2[1] , not_code_2[0] );

//abcdef

    and and_term_7 (T7 , 
    code_1[2] , code_1[1] , code_1[0] , 
    code_2[2] , code_2[1] , code_2[0] );

    or or_terms (output_bit , T1 , T2 , T3 , T4 , T5 , T6 , T7);

endmodule