//same_user_verify 6 in 1 out


module same_user (
    input [2:0] ie1_user , ie2_user , 
    output output_bit
);

    wire [2:0] not_ie1_user , not_ie2_user;

        not not_ie1_user_1 [2:0] (not_ie1_user , ie1_user);
        not not_ie2_user_1 [2:0] (not_ie2_user , ie2_user);

    wire T1 , T2 , T3 , T4 , T5 , T6;
    
//abc = user ie1 bits , a = [2] ... c = [0]
//def = user ie2 bits , d = [2] ... f  = [0]

//~be + ~ad + b~e + a~d + ~a~c + ~a~f

//~be
    and and_term_1 (T1 , not_ie1_user[1] , ie2_user[1] );     
//~ad
    and and_term_2 (T2 , not_ie1_user[2] , ie2_user[2] );     
//b~e
    and and_term_3 (T3 , ie1_user[1] , not_ie2_user[1] );     
//a~d
    and and_term_4 (T4 , ie1_user[2] , not_ie2_user[2] );     
//~a~c
    and and_term_5 (T5 , not_ie1_user[2] , not_ie1_user[0] ); 
//~a~f
    and and_term_6 (T6 , not_ie1_user[2] , not_ie2_user[0] ); 
    or or_terms (output_bit , T1 , T2 , T3 , T4 , T5 , T6);  

endmodule
