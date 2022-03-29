clc
clear

%Parâmetros do sistema

Xd = 1.38;
Xq = 0.92;
Veq = 1.0;
Xeq = 0.12;

n = 1:101;
P = (n-1)/100;

% Como o gerador é conectado a um sistema externo, serão aplicadas  
% equações características de ângulo de carga das máquinas de pólos 
% salientes. Deste modo:

%         Eaf * Va * sen(deltat)     Va^2 * (Xd - Xq) * sen (2 * deltat)
%   P = - ----------------------  - ------------------------------------
%                  Xd                           2 * Xd * Xq

% Assim como descrito no livro de Máquinas Elétricas de Stephen D. Umans,
% os geradores síncronos são em geral conectados a um sistema externo que 
% pode ser representado por um barramento infinito de tensão Veq em série 
% com uma impedância equivalente de reatância Xeq, como no enunciado da 
% questão.
% Então, pode ser aplicada diretamente a essa configuração apenas 
% substituindo Xd por Xd + Xeq, Xq por Xq + Xeq e Va por Veq.

Xd = Xd + Xeq;
Xq = Xq + Xeq;
Va = Veq;

% Observe que a referência de fasor está em Va, como habitual para esse
% esse tipo de análise.

% Para continuar a resolução, faz-se necessário o cálculo de deltat.
% Como seu valor está em função da potência do gerador, então será criado,
% como foi para potência, uma lista de valores de deltat de modo a
% corresponder com a lista de valores de Potência. 
% Para tanto, sabendo que o P = Re[Va x Ia*] (utilizei "x" como produto
% para * significar complexo conjugado), logo |Ia| = P/Va. Assim:

Ia = P / Va;

% Visto que deltat = - arctg(Ia*Xq/Va),
deltat = - atand(Ia * Xq / Va);

% Logo, colocando Eaf em evidência na primeira equação:
Eaf = -(P + (Va^2 * (Xd - Xq) * sind(2 * deltat)) / (2 * Xd * Xq))* Xd ;
Eaf = Eaf ./ (Va * sind(deltat));

% Plot dos resultados
plot(P,Eaf)
xlabel('Potência [por unidade]')
ylabel('Eaf [por unidade]')

% Tabela com os valores
P = P(1:5:101);
Eaf = Eaf(1:5:101);
table = table(P', Eaf', 'VariableNames', {'Potência' 'Tensão de Excitação'})