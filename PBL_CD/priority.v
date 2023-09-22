//priority_verify 6 in 1 out

module priority(
    input [2:0] ie1_user , ie2_user ,
    output output_bit
);

    wire [2:0] not_ie1_user , not_ie2_user;

        not not_ie1_user_1 [2:0] (not_ie1_user , ie1_user);
        not not_ie2_user_2 [2:0] (not_ie2_user , ie2_user);

    wire T1 , T2 , T3 , T4;

//abc = user ie1 bits , a = [2] ... c = [0]
//def = user ie2 bits , d = [2] ... f  = [0]

//c~d~e + cde + a~b + ~d~f


//c~d~e
    and and_term_1 (T1 , ie1_user[0] , not_ie2_user[2] , not_ie2_user[1] );      
//cde
    and and_term_2 (T2 , ie1_user[0] , ie2_user[2] , ie2_user[1] );
//a~b
    and and_term_3 (T3 , ie1_user[2] , not_ie1_user[1] );
//~d~f
    and and_term_4 (T4 , not_ie2_user[2] , not_ie2_user[0] );
    or or_terms (output_bit , T1 , T2 , T3 , T4);

endmodule