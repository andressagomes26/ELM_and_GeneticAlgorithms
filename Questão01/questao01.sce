/* Andressa Gomes Moreira - 402305
   Trabalho 03 - Questão 01
   Inteligência Computacional
*/

clear; 
clc;

// Carregando a base de dados
data = fscanfMat("two_classes.dat");

entrada = data(:, 1:2)'      // Dados de entrada: 1° e 2° coluna
rotulos = data(:, 3)'        // Rótulos: 3° coluna

// Variáveis necessárias 
p = 2;                         // p = Quantidade de atributos em um vetor
q = 40;                        // q = Número de neurônios da camada oculta.
amostra = length(entrada)/2;   // Amostra = 1000

x = [(-1)*ones(1,amostra); entrada];        // Adicionar o bias = -1

// Fase 1: Iniciar aleatóriamente os pesos da camada oculta
W = rand(q, p+1,'normal');      // W = Matriz de pesos da camada oculta

// Fase 2: Acúmulo da saída dos neurônios
u = W * x;                      // u(t) = Vetor de ativação 

//Cálculo da função de ativação (Logística)
z = 1./(1+(exp(-u)))            // Vetores produzidos pela camada oculta
z = [(-1)*ones(1,amostra); z];  // Adicionar o bias = -1

//Fase 3: Cálculo dos Pesos dos Neurônios de saída
M = rotulos*z'*((z*z'))^(-1) ;         // Método dos mínimos quadrados

/* Plotagem do gráfico */

// Configurações
clf; 
title('Superfície de decisão obtida por meio da rede neural ELM com ' + string(q) + ' neurônios ocultos.' )

// Separando as classes 
classe1 = data(1:500,1:2)       // Classe 1: Rótulo = 1
classe2 = data(501:1000,1:2)    // Classe 2: Rótulo = -1

plot(classe1(:,1),classe1(:,2), 'b*')   // Plotagem dos dados da classe 1: Cor Azul
plot(classe2(:,1),classe2(:,2), 'g*')   // Plotagem dos dados da classe 2: Cor Verde

// Determinar 1000 pontos para compor o plano    
intervalo_x1 = linspace(0, 5, 1000);
intervalo_x2 = linspace(0, 5, 1000);
    
for aux1=1:1000
    for aux2=1:1000
        x_new = [-1 intervalo_x1(aux1) intervalo_x2(aux2)]' // Nova matriz de pontos 
        u_new = W * x_new                                 // u(t) = Vetor de ativação 
        z_new  = 1./(1+exp(-u_new))                       // Função de ativação (Logística)
        z_new  = [(-1)*ones(1,1); z_new];                 // Adicionar o bias = -1
        a_new = M*z_new                                   // Vetor de saídas
       
        // Superfície inconclusiva em que será traçada a superfície de decisão separando as duas classes
        if a_new < 0.001 & a_new > -0.001 then
             plot(intervalo_x1(aux1), intervalo_x2(aux2),'redd') // Plotagem da superfície de decisão
        end
   end 
end
