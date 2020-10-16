/* Andressa Gomes Moreira - 402305
   Trabalho 03 - Questão 02
   Inteligência Computacional
*/

clear; 
clc;

//Variáveiz auxiliares
qnt_individuos = 100;       // Quantidade de indivíduos
qnt_participantes = 4;      // Quantidade de participantes no método do torneio
num_bit = 20;               // Quantidade de bits para compor 1 indivíduo  
epocas = 50;                // Quantidade de gerações
inf = -5                    // Limite inferior do intervalo [-5 5]
sup = 5                     // Limite superior do intervalo [-5 5]

/* Criando uma matriz de indivíduos gerados aleatóriamente
        -> Temos 100 indivíduos 
        -> cada indivíduo da população é um vetor binário de 20 bits
*/
matriz_individuos1 = [ones(qnt_individuos, num_bit/2)];         // Cria uma matriz composta de 1's
matriz_individuos2 = [zeros(qnt_individuos, num_bit/2)];        // Cria uma matriz composta de 0's
matriz_individuos = [matriz_individuos1 matriz_individuos2];    // Cria uma matriz para agrupar os bits 0's e 1's
matriz_individuos = grand(1,'prm', matriz_individuos);          // Embaralha os bits para criar a matriz contendo os 100 indivíduos e 20 bits

for epoca = 1:epocas
    for i = 1:qnt_individuos 
        
        /**************************** CONVERSÃO BINÁRIO - DECIMAL - REAL *************************************/
        
        /* Conversão dos números binários para decimais
            -> Os 10 primeiros bits (Colunas) da matriz de indivíduoes = representam x  
            -> Os 10 últimos bits (Colunas) da matriz de indivíduoes = representam y.
        */
        
        individuos_x = matriz_individuos(i, 1:10);      // Composto pelos 10 primeiros bits da matriz de indivíduos
        x_str = strcat(string(individuos_x))            // Concatenando e convertendo os bits para string
        
        individuos_y = matriz_individuos(i, 11:20);     // Composto pelos 10 últimos bits da matriz de indivíduos
        y_str = strcat(string( individuos_y))           // Concatenando e convertendo os bits para string
         
        x(i) =bin2dec(x_str)                            // Converte de binário para decimal
        y(i)= bin2dec(y_str)                            // Converte de binário para decimal 
        
        /* Convertendo bits para números, na qual x e y pertencem ao intervalo [-5 5]*/
        x_real(i) = inf+(sup - inf)/((2^10)-1)*x(i)     // Representação de x em real entre o intervalo [-5 5]
        y_real(i) = inf+(sup - inf)/((2^10)-1)*y(i)     // Representação de y em real entre o intervalo [-5 5]
        

        /********************************* CÁLCULO DA FUNÇÃO DE AVALIAÇÃO - NOTAS ******************************************************/
        
        /* Cálculo da função de avaliação -
            -> Utilizada para determinar a qualidade de um indivíduo || É uma nota dada ao indivíduo.
            -> Função de Rosenbrock: f(x, y) =(1 – x)^2 + 100(y – x^2)^2 
        */
        nota(i) = (1 - x_real(i))^2 + 100*(y_real(i) - x_real(i)^2)^2         // Notas dos indivíduos 
    end
    
        /***************************************** SELEÇÃO DOS PAIS - MÉTODO DO TORNEIO ************************************************/
        
    // Vamos selecionar "n" indivíduos que irão participar do torneio:
    participantes = matriz_individuos(1:qnt_participantes, 1:20);   // Dimensionando a matriz "participantes"
    nota_part = nota(1:qnt_participantes, :);                       // Dimensionando a matriz para notas dos participantes
        
    for i = 1:qnt_individuos
        
        for p = 1:qnt_participantes
            pos_indiv_aleat = ceil(rand()*qnt_individuos)                       // Gera uma posição aleatórias.
            participantes(p, :) = matriz_individuos(pos_indiv_aleat, 1:20);     // Seleciona aleatoriamente "n" indivíduos para participar do torneio.
        end
        
        for j = 1:qnt_participantes
            x1_partic1 = participantes(j, 1:10);             // Composto pelos 10 primeiros bits da matriz de participantes
            x_partic_str = strcat(string(x1_partic1))        // Concatenando e convertendo os bits para string
            
            y1_partic1 = participantes(j, 11:20);            // Composto pelos 10 últimos bits da matriz de participantes
            y_partic_str = strcat(string(y1_partic1))        // Concatenando e convertendo os bits para string
             
            x1_partcl_decimal(j) = bin2dec(x_partic_str)     // Converte de binário para decimal (x)
            y1_partcl_decimal(j) = bin2dec(y_partic_str)     // Converte de binário para decimal (y)
            
            x1_real(j) = inf+(sup - inf)/((2^10)-1)*x1_partcl_decimal(j);   // Representação de x em real entre o intervalo [-5 5]  
            y1_real(j) = inf+(sup - inf)/((2^10)-1)*y1_partcl_decimal(j);   // Representação de y em real entre o intervalo [-5 5]
            
            nota_part(j, :) = (1 - x1_real(j))^2 + 100*(y1_real(j) - x1_real(j)^2)^2  // Notas dos participantes do torneio 
        end
        
        [valor indice] = min(nota_part)                           // Recebe os valores e os índices das menores notas
        matriz_individuos_pais(i, :) = participantes(indice, :)   // Recebe os pais que foram selecionados
    end
    
     /******************************************************* CROSSOVER **************************************************************/
    
    /*  Crossover 
            -> Selecionar um ponto de corte = posição entre dois genes de um cromossomo.
            -> Separ os pais em duas partes: uma à esquerda do ponto de corte e outra à direita
            -> O primeiro filho = parte esquerda do primeiro pai + parte direita do segundo pai.
            -> O segundo filho = parte esquerda do segundo pai + parte direita do primeiro pai.
    */
    
    pontoCorte = int(rand()*linspace(1,19, 1))  // Seleciona um ponto de corte

    for aux = 1:2:qnt_individuos
        pontoCorte1 = pontoCorte + 1  // Ponto de corte: Vai separ os pais em duas partes
       
        // Para o filho 1:
        pos1_filho1 =  matriz_individuos_pais(aux, 1:pontoCorte);      // Parte esquerda do primeiro pai
        pos2_filho1 =  matriz_individuos_pais(aux+1, pontoCorte1:20);  // Parte direita do segundo pai.
    
        // Para o filho 2:    
        pos1_filho2 =  matriz_individuos_pais(aux+1, 1:pontoCorte);    // Parte esquerda do segundo pai
        pos2_filho2 =  matriz_individuos_pais(aux, pontoCorte1:20);    // Parte direita do primeiro pai.
    
        filhosn(aux, :) = [pos1_filho1, pos2_filho1];       // Filho 1
        filhosn(aux+1, :) = [pos1_filho2, pos2_filho2];     // Filho 2
    end
    
     /******************************************************* MUTAÇÃO *******************************************************/

    filhos_mut  = [ones(qnt_individuos, num_bit)];      // Variável que irá receber a mutação
    filhos_mut = filhosn                                // Recebe os filhos 

     for i = 1:qnt_individuos
            num_sort = rand(1, 'uniform')               // Sorteio de um número entre 0 e 1  -> Valor que será comparado à probabilidade
            colun_sort =(ceil(rand()*num_bit));         // Sorteio de um número entre 1 e 20 -> Coluna que irá ocorrer a mutação
            
            if num_sort <= 0.005 then                   // Se o número sorteado for menor do que a probabilidade (0.5%) então ocorre a mutação
                 filhos_mut(i, colun_sort) =  ~(filhos_mut(i, colun_sort));     // O bit 0 será alterado para 1 e o bit 1 será alterado para 0
            end
    end
    matriz_individuos = filhos_mut;     // A matriz de indivíduos recebe a nova população || Os filhos geram a nova população
end

for i = 1:qnt_individuos
    
        // Conversão dos números binários para decimais da nova população gerada*/
        individuos_x = matriz_individuos(i, 1:10);       // Composto pelos 10 primeiros bits da matriz
        x_str = strcat(string(individuos_x))             // Concatenando e convertendo os bits para string
        
        individuos_y = matriz_individuos(i, 11:20);      // Composto pelos 10 últimos bits da matriz
        y_str = strcat(string( individuos_y))            // Concatenando e convertendo os bits para string
         
        x(i) = bin2dec(x_str)                           // Converte de binário para decimal 
        y(i)= bin2dec(y_str)                            // Converte de binário para decimal 
      
        x_real(i) = inf+(sup - inf)/((2^10)-1)*x(i)     // Representação de x em real entre o intervalo [-5 5]    
        y_real(i) = inf+(sup - inf)/((2^10)-1)*y(i)     // Representação de y em real entre o intervalo [-5 5]
        

        // Cálculo da função de avaliação para a nova população
        nota(i) = (1 - x_real(i))^2 + 100*(y_real(i) - x_real(i)^2)^2  // Notas dos indivíduos da nova população
end

[valor_min indice_min]= min(nota)   // Valor e índice que minimizam a função Rosenbrock

// Exibindo os resultados:
disp("Valor mínimo encontrado: " + string(valor_min))
disp('Valor para x que minimiza a função de Rosenbrock: ' + string(x_real(indice_min)))
disp('Valor para y que minimiza a função de Rosenbrock: ' + string(y_real(indice_min)))


/* Gráfico */

// Configurações
clf();
f=gcf(); f.color_map = hotcolormap(7);

xlabel('x'); ylabel('y');
title(' Algoritmo Genético para achar o mínimo da função de Rosenbrock || Geração: ' + string(epocas));

//Determinando a quantidade de pontos para a plotagem da superficie:
intervalo_x1 = linspace(-6,6,num_bit)
intervalo_x2 = linspace(-6,6,num_bit)

for i=1:num_bit
    for j=1:num_bit
        func_avali(i,j) = (1 - intervalo_x1(i))^2 + 100*(intervalo_x2(j) - intervalo_x1(i)^2)^2 
    end    
end

plot3d(intervalo_x1,intervalo_x2,func_avali)    // Plotagem da superficie
scatter3d(x_real,y_real,nota,'fill')            // Plotagem para última geração
