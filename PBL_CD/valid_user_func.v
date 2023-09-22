//user_func_verify 6 in 1 out


module valid_user_func (
    input [2:0] user , func ,
    output output_bit
);

    wire [2:0] not_user , not_func;
        not not_user_1 [2:0] (not_user , user);
        not not_func_1 [2:0] (not_func , func);
    
    wire T1 , T2 , T3 , T4 , T5 , T6 , T7 , T8;

//abc = user bits , a = [2] ... c = [0]
//def = func bits , d = [2] ... f  = [0]

//~ac~df + ~acd~f + a~bce + ab~c~d~ef + ab~cde~f + ~abc~de + ~bc~df + a~bcd       

//~ac~df
    and and_term_1 (T1 , not_user[2] , user[0] , not_func[2] , func[0] );
//~acd~f
    and and_term_2 (T2 , not_user[2] , user[0] , func[2] , not_func[0] );
//a~bce
    and and_term_3 (T3 , user[2] , not_user[1] , user[0] , func[1] );
//ab~c~d~ef
    and and_term_4 (T4 , user[2] , user[1] , not_user[0] , not_func[2] , not_func[1] , func[0] );   
//ab~cde~f
    and and_term_5 (T5 , user[2] , user[1] , not_user[0] , func[2] , func[1] , not_func[0] );       
//~abc~de
    and and_term_6 (T6 , not_user[2] , user[1] , user[0] , not_func[2] , func[1] );
//~bc~df
    and and_term_7 (T7 , not_user[1] , user[0] , not_func[2] , func[0] );
//a~bcd
    and and_term_8 (T8 , user[2] , not_user[1] , user[0] , func[2] );
    or or_terms (output_bit , T1 , T2 , T3 , T4 , T5 , T6 , T7 , T8);

endmodule 