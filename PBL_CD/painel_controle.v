module painel_controle(

	input [2:0] ie1_user , ie2_user , ie1_func , ie2_func ,
	output [6:0] final_matriz , display ,
	output [3:0] final_leds ,
    output display_on , auto_ie1 , auto_ie2 ,
    output [4:0] high_out
);

    //------------------------------------------------------------
    //Gerando saidas de valor alto
    //"poderia fazer assign pra cada uma? poderia..." ~sinval
    wire low_out_w;
    not not_low_out [4:0](high_out , low_out_w);
    //------------------------------------------------------------


    //ESTRUTURA DOS COMENTÁRIOS:
    //"//---..." = Linha de delimitação.
    //*NOME EXPLICATIVO.
    //*DESCRIÇÃO.
    //*ENTRADAS.
    //*FUNCIONAMENTO(se necessário).
    //*SAIDAS.
    //*MAIS EXPLICAÇÃO(se necessário).
    //*NOME EXPLICATIVO.
    //"//---...

    //------------------------------------------------------------
    //MODULOS DE VALIDAÇÃO DE USUÁRIO E FUNÇÃO:

    //Esse modulo verifica se: 
    //1 - O código de usuário e função são códigos válidos.
    //2 - O usuário tem permissão de usar aquela função.

    //ENTRADAS:
    //1 - Código do usuário e o complemento deste código. (6 bits)
    //2 - Código da função e o complemento deste código. (6 bits)

    //SAIDAS:
    //saida_bit. (1 bit):{
    //      1 = Quando os códigos são validos *E* o usuário pode usar a função requisitada.
    //      0 = Quando os códigos não são validos *OU* o usuário não pode usar a função requisitada.
    //}

    //Essas saidas serão utilizadas para controlar os primeiros buffersif(declarados logo abaixo desse modulo).

	valid_user_func valid_user_func_ie1 (
    .output_bit (valid_user_func_ie1_w) , //OUT.
    .user       (ie1_user) ,              //código do usuário.
    .func       (ie1_func));              //código da função.

	valid_user_func valid_user_func_ie2 (
    .output_bit (valid_user_func_ie2_w) , 
    .user       (ie2_user) , 
    .func       (ie2_func));

    not not_auto_ie1 (auto_ie1 , valid_user_func_ie1_w);
    not not_auto_ie2 (auto_ie2 , valid_user_func_ie2_w);


	//MODULOS DE VALIDAÇÃO DE USUÁRIO E FUNÇÃO
    //------------------------------------------------------------



    //------------------------------------------------------------
    //BUFFERSIF:
    //Tem como função controlar as entradas permitidas no circuito
    //Recebem um vetor de 3bits como input e retornam, como output,
    //um vetor de 3bits

    //ENTRADAS:
    //1 - Qualquer input de 3 bits(normalmente códigos de usuário ou função).
    //2 - Variável de controle. (1 bit)

    //SAIDA:
    //Caso sua variável de controle seja:
    //      0 = Flipa todos os bits do vetor de entrada para "0". Ex: {
    //              Vetor = 101 , Variável controle = 0:    
    //              Saida = 000.
    //}
    //      1 = Mantem todos os bits do vetor de entrada, e passa como output. Ex: {
    //              Vetor = 101 , Variável controle = 1:    
    //              Saida = 101.
    //}

    wire [2:0] bufif_ie1_user_w , bufif_ie2_user_w , bufif_ie1_func_w , bufif_ie2_func_w;

	//bufferif ie1 user

	bufferif_3bit bufif_ie1_user (
    .bufout  (bufif_ie1_user_w) ,      //Output: Vetor. (3 bits) 
    .bufin   (ie1_user) ,              //Input: Vetor. (3 bits)
    .control (valid_user_func_ie1_w)); //Variável controle. (1 bit)
	
    //bufferif ie1 func
	
	bufferif_3bit bufif_ie1_func (
    .bufout  (bufif_ie1_func_w) , 
    .bufin   (ie1_func) , 
    .control (valid_user_func_ie1_w));

	//bufferif ie2 user
	
	bufferif_3bit bufif_ie2_user (
    .bufout  (bufif_ie2_user_w) , 
    .bufin   (ie2_user) , 
    .control (valid_user_func_ie2_w));
	
	//bufferif ie2 func
	
	bufferif_3bit bufif_ie2_func (
    .bufout  (bufif_ie2_func_w) , 
    .bufin   (ie2_func) , 
    .control (valid_user_func_ie2_w));

    //BUFFERSIF
    //------------------------------------------------------------


    
    //------------------------------------------------------------
    //COMPARAÇÕES E PRIORIDADE.
    //Abaixo, alguns modulos fazem comparações entre as IE. 
    //O resultado dessas comparações serão usadas para validar o...
    //uso ou não da prioridade.

    //Quando usar a prioridade:{
    //      1-Usuário diferentes, e ...
    //      2-Funções Iguais, e ...
    //      3-Ambas IEs tiverem entradas válidas.
    //}

    //Caso qualquer um desses pontos não seja contemplado, não há...
    //necessecidade do uso da prioridade.

    //ENTRADAS E SAIDAS:{
    //      same_user:[
    //          Input: Vetores, de 3 bits, contendo os códigos dos usuários da IE1 e IE2. (Total, 6 bits) 
    //          Output: Um bit de saida:(
    //              1 = Usuários são iguais.
    //              0 = Usuários NÃO são iguais.
    //          )
    //      ]
    //      same_func:[
    //          Input: Vetores, de 3 bits, contendo os códigos das funções da IE1 e IE2. (Total, 6 bits) 
    //          Output: Um bit de saida:(
    //              1 = Funções são iguais.
    //              0 = Funções NÃO são iguais.
    //          )
    //      ]
    //      priority:[
    //          Input: Vetores, de 3 bits, contendo os códigos dos usuários da IE1 e IE2. (Total, 6 bits) 
    //          Output: Um bit de saida:(
    //              1 = IE1 tem prioridade acima da IE2.
    //              0 = IE2 tem prioridade acima da IE1.
    //          )
    //      ]
    //}
    //FUNCIONAMENTO:{
    //       priority:[
    //       Levando em consideração a ordem de prioridade: ADMIN -> TESTER -> USER -> GUEST. 
    //       O modulo irá indicar qual IE tem o usuário com maior prioridade.
    //       ]
    //}

	same_code same_user_1 (
    .output_bit (same_user_w) , 
    .code_1     (bufif_ie1_user_w) ,  
    .code_2     (bufif_ie2_user_w)); 

    not not_same_user (not_same_user_w , same_user_w);

	same_code same_func_1 (
    .output_bit (same_func_w) , 
    .code_1     (bufif_ie1_func_w) ,  
    .code_2     (bufif_ie2_func_w)); 

    priority priority_1 (
    .output_bit   (priority_w) , 
    .ie1_user     (bufif_ie1_user_w) ,  
    .ie2_user     (bufif_ie2_user_w)); 

    
    //COMPARAÇÕES E PRIORIDADE.
    //------------------------------------------------------------

    //------------------------------------------------------------
    //CONTROLE DOS BUFFERS DE PRIORIDADE
    //Aqui serão geradas as variáveis de controle dos buffers de prioridade.
    //Levando em consideração a prioridade e se esta deve ser usada.
    //ENTRADAS E SAIDAS:{

    //        and_use_priority:[
    //            inputs:(
    //                1 - Bits dos modulos valid_user_func ie1 e ie2.
    //                2 - Bit do modulo diferent_user.
    //                3 - Bit do modulo same_func.
    //            )
    //            output:(
    //                1 = A prioridade se aplica.
    //                0 = A prioridade NÃO se aplica.
    //            )
    //        ]

    //        priority_iex:[
    //            inputs(
    //                1 - Bit do modulo priority.
    //                2 - Bit do and_use_priority.
    //            )
    //            outputs:(
    //                priority_ie1
    //                priority_ie2
    //                //Esses outputs serão usados para controlar os buffers de prioridade.
    //            )

    //            Quando use_priority = 0:(
    //                priority_ie1 e priority_ie2 = 1
    //            )
    //            ... = 1:(
    //                priority_ie1 e priority_ie2 = dependem do bit de prioridade
    //            )
    //        ]  
    //          
    //}

	and and_use_priority (
    use_priority_w , //OUT
    valid_user_func_ie1_w ,
    valid_user_func_ie2_w ,
    not_same_user_w ,
    same_func_w);	 
	 
    wire priority_ie1_w , priority_ie2_w; 

	priority_iex priority_iex_1 (
	.priority_ie1 (priority_ie1_w) , 
    .priority_ie2 (priority_ie2_w) , 
	.priority     (priority_w) , 
	.use_priority (use_priority_w));

    //CONTROLE DOS BUFFERS DE PRIORIDADE
    //------------------------------------------------------------

    //------------------------------------------------------------
    //BUFFERS DE PRIORIDADE

    wire [2:0] bufif_ie1_func_prio_w , bufif_ie2_func_prio_w; //Código da função.
	 
	//buffers prioridade ie1	

	bufferif_3bit bufif_ie1_func_prio (
    .bufout  (bufif_ie1_func_prio_w) , 
    .bufin   (bufif_ie1_func_w) , 
    .control (priority_ie1_w));
 
	//buffers prioridade ie2
	 
	bufferif_3bit bufif_ie2_func_prio (
    .bufout  (bufif_ie2_func_prio_w) , 
    .bufin   (bufif_ie2_func_w) , 
    .control (priority_ie2_w));

    //O output desses buffers está conectado aos proximos buffers que definem...
    //a saida a ser utilizada.

    //BUFFERS DE PRIORIDADE
    //------------------------------------------------------------

    //------------------------------------------------------------
    //CONTROLE DOS BUFFERS DA INTERFACE DE SAIDA(IS)
    //Levando em consideração o usuário que requisitou a função, os modulos abaixo...
    //definem a saida a ser utilizada, através do buffers.

    iex_is1 ie1_is1 (
    .output_bit (ie1_is1_w) , 
    .user       (bufif_ie1_user_w)); 

    iex_is1 ie2_is1 (
    .output_bit (ie2_is1_w) , 
    .user       (bufif_ie2_user_w));

    //Invertendo para apenas uma saida ser utilizada.
	 
    not ie1_is2 (ie1_is2_w , ie1_is1_w); 

    not ie2_is2 (ie2_is2_w , ie2_is1_w);


    //CONTROLE DOS BUFFERS DA INTERFACE DE SAIDA(IS)
    //-----------------------------------------------------------
    
    
    //------------------------------------------------------------
    //BUFFERS DA INTERFACE DE SAIDA(IS)
    //Estes buffers transportam as funções passadas pelos buffers de prioridade...
    //até a saida correta.

    wire [2:0] bufif_ie1_func_is1_w , bufif_ie1_func_is2_w , bufif_ie2_func_is1_w , bufif_ie2_func_is2_w;

    //buf ie1 is1

    bufferif_3bit bufif_ie1_func_is1 (
    .bufout  (bufif_ie1_func_is1_w) , 
    .bufin   (bufif_ie1_func_prio_w) , 
    .control (ie1_is1_w));


    //buf ie1 is2

    bufferif_3bit bufif_ie1_func_is2 (
    .bufout  (bufif_ie1_func_is2_w) , 
    .bufin   (bufif_ie1_func_prio_w) , 
    .control (ie1_is2_w));

    //buf ie2 is1 

    bufferif_3bit bufif_ie2_func_is1 (
    .bufout  (bufif_ie2_func_is1_w) , 
    .bufin   (bufif_ie2_func_prio_w) , 
    .control (ie2_is1_w));

    //buf ie2 is2

    bufferif_3bit bufif_ie2_func_is2 (
    .bufout  (bufif_ie2_func_is2_w) , 
    .bufin   (bufif_ie2_func_prio_w) ,
    .control (ie2_is2_w));

    //BUFFERS DA INTERFACE DE SAIDA(IS)
    //------------------------------------------------------------

    //------------------------------------------------------------
    //SAIDA 1, MATRIZ DE LEDS
    //Cada modulo gera uma matriz para cada IE.
    //A duas matriz geradas então são juntas por um and.
    //Essa etapa serve o proposito de ter dois usuarios utilizando...
    //duas funções diferentes na mesma IS.

    wire [6:0] matriz_ie1_w , matriz_ie2_w;

    matriz_iex matriz_ie1 (
    .output_matriz (matriz_ie1_w) , 
    .func          (bufif_ie1_func_is1_w));

    matriz_iex matriz_ie2 (
    .output_matriz (matriz_ie2_w) , 
    .func          (bufif_ie2_func_is1_w));
	 

    and and_final_matriz [6:0] (final_matriz , matriz_ie1_w , matriz_ie2_w);

    //SAIDA 1, MATRIZ DE LEDS
    //------------------------------------------------------------

    //------------------------------------------------------------
    //SAIDA 2, BARRA DE LEDS
    //Mesmo funcionamento da saida 1, exceto que aqui as barras de leds...
    //são juntas através de um or.

    wire [3:0] leds_ie1_w , leds_ie2_w;

    leds_iex leds_ie1 (
    .output_leds (leds_ie1_w) , 
    .func        (bufif_ie1_func_is2_w));

    leds_iex leds_ie2 (
    .output_leds (leds_ie2_w) , 
    .func        (bufif_ie2_func_is2_w));

    or or_final_leds [3:0] (final_leds , leds_ie1_w , leds_ie2_w);

    //SAIDA 2, BARRA DE LEDS
    //------------------------------------------------------------

    //------------------------------------------------------------
    //SAIDA 3, DISPLAY DE 7 SEGMENTOS

    

    //func2:{
    //    inputs:[
    //        1 - Funções de cada IE.
    //        2 - Prioridade.
    //    ]
    //    outputs:[
    //        mux_control_w:(
    //            '1' : O usuário da IE1 deve ser mostrado no display ,
    //            '0' : O usuário da IE2 deve ser mostrado no display.
    //        )       
    //        display_on: (
    //            '0' : Display ligado ,
    //            '1' : Display desligado.
    //        )
    //
    //    ]
    //}

    wire [2:0] mux_user_display_w;

    func2 func2_1 (
    .mux_control (mux_control_w) ,
    .display_on  (display_on) ,
    .func_ie1 (bufif_ie1_func_w) , 
    .func_ie2 (bufif_ie2_func_w) ,
    .priority (priority_w));

    //Multiplexador para controlar a entrada do código de usuário no display.

    mux2_1 mux2_1_display (
    .output_data (mux_user_display_w) ,
    .data_1      (bufif_ie1_user_w) , 
    .data_2      (bufif_ie2_user_w) ,
    .control     (mux_control_w));

    //Decodificador do display

    display display_1 (
    .output_segments (display) ,
    .user (mux_user_display_w)
    );

    //SAIDA 3, DISPLAY DE 7 SEGMENTOS
    //------------------------------------------------------------


endmodule