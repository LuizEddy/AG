%     Este programa � um software livre; voc� pode redistribu�-lo e/ou 
%     modific�-lo sob os termos da Licen�a P�blica Geral GNU como publicada
%     pela Funda��o do Software Livre (FSF); na vers�o 3 da Licen�a,
%     ou (a seu crit�rio) qualquer vers�o posterior.
% 
%     Este programa � distribu�do na esperan�a de que possa ser �til, 
%     mas SEM NENHUMA GARANTIA; sem uma garantia impl�cita de ADEQUA��O
%     a qualquer MERCADO ou APLICA��O EM PARTICULAR. Veja a
%     Licen�a P�blica Geral GNU para mais detalhes.
% 
%     Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral GNU junto
%     com este programa. Se n�o, veja <http://www.gnu.org/licenses/>.


clear all;
clc;

load ('geracao_inicial_50.mat'); %carrega matriz com a gera��o inicial
n_subbandas = 5; %definido pelo modelo de Wei Li
n_individuos_populacao = size(geracao_inicial,1); %verifica quantos indiv�duos existem na gera��o incial
n_femtocelulas_individuo = size(geracao_inicial,2); %verifica quantas small cells existem
n_saltos = n_femtocelulas_individuo/n_subbandas; %verifica quantas small cells existem por cluster
taxa_mutacao = 0.05; %5 por cento de chance de mutacao
epocas = 1000; %numero de epocas que o AG ira rodar
load ('pot_font1.mat'); %carrega os valores de potencia de interesse do modelo de Araujo
load ('pot_inter1.mat'); %carrega os valores de potencia interferente do modelo de Araujo
densidade = 0.5; %lambda do modelo de Wei Li = 50% das small cells em stand by
branco_variancia = 10^(-80.97/10); %ruido branco do canal, levado em conta na SINR


%NOTA: Deve-se manter a relacao de exatidao da divisao 
% n_saltos = n_femtocelulas_individuo/n_subbandas;
%para que todos os individuos sejam distribuidos igualitariamente nos
%clusters e para facilitar as operacoes intrisecas do algoritmo

%No caso deste exemplo, o numero de small cells no individuo � de 120
%o numero de subbandas � de 5, o que gera uma divisao exata de 24
%(n_saltos)femtocelulas por cluster

%geracao atual recebe a primeira geracao
geracao_atual = geracao_inicial;

for loop0 = 1:epocas

%-------------------------------------------%
%-----------------AVALIA��O-----------------%
%-------------------------------------------%

%avaliacao de toda a popula��o atual
for loop1 = 1:n_individuos_populacao;
    %individuo que sera avaliado a cada iteracao
    individuo_atual = geracao_atual(loop1,:);
    
    %somando as interferencias entre as femtocelulas de mesmo cluster
    %no caso deste exemplo, sao 5 clusters/subbandas cada uma com 24 femt.
    
    interferencia_atual = 0;
    
    %loop que quebra as femt do individuo atual (120) nas suas subbandas (de 24 em 24) para calculo da
    %interferencia daquele cluster
    
    for loop2=0:n_saltos:n_femtocelulas_individuo-n_saltos
        
        individuo_atual_fragmentado = individuo_atual(loop2+1:loop2+n_saltos);
        
        for loop3 = 1:n_saltos-1
            
            for loop4=loop3+1:n_saltos
                
                %soma a interferencia de todas as small cells que estao num
                %determinado cluster
                interferencia_atual = interferencia_atual + Pot_inter(individuo_atual_fragmentado(loop3),individuo_atual_fragmentado(loop4));
                
            end
            
        end
        
    end
    
    %atualiza as inteferencias para a popula��o atual
    interferencia_geracao_atual(loop1) = interferencia_atual;
    %a avaliacao nesse caso � a interferencia (menor = melhor)
    avaliacao = interferencia_geracao_atual;
    
end

for loop1a = 1:n_individuos_populacao;
    
    SINR_ANTES(loop1a) = Pot_fonte(loop1a)/((sum(Pot_inter(loop1a,:))*densidade + branco_variancia));
    
end

fitness = SINR_ANTES; %AQUI EST� A UNIDADE DE INTERESSE!

%-------------------------------------------%
%------------SELE��O POR ROLETA-------------%
%-------------------------------------------%

%quanto maior o fitness (SINR_ANTES), maior a fatia que um dado individuo possuir� na
%roleta

soma = sum(fitness);

for loop5 = 1:n_individuos_populacao
    
    aux1 = fitness(1);
    aux2 = (soma).*rand(1,1);
    
    for loop6 = 1:n_individuos_populacao
        
        
        
        if aux1 >= aux2
            
            selecionados(loop5,:) = geracao_atual(loop6,:);
            indice_selecionados(loop5) = loop6;
            
            break
            
        else
            
            aux1 = aux1 + fitness(loop6+1);
            
        end
        
    end
    
end

%-------------------------------------------%
%--------------CRUZAMENTO PMX---------------%
%--------(PARTIALLY MAPPED CROSSOVER)-------%
%-------------------------------------------%

%http://www.rubicite.com/Tutorials/GeneticAlgorithms/CrossoverOperators/PMXCrossoverOperator.aspx

%algoritmo implementado segundo a p�gina acima
%para melhor implementacao, o algoritmo de cruzamento foi posto em um
%script a parte, contido neste mesmo diretorio ("cruzamentoPMX.m")

cruzamento_resultado = zeros(n_individuos_populacao,n_femtocelulas_individuo);

for loop7 = 1:2:n_individuos_populacao-1

    pai1 = selecionados(loop7,:);
    pai2 = selecionados(loop7+1,:);
    
    %chamada da funcao cruzamentoPMX

    cruzamento_resultado(loop7,:) = cruzamentoPMX(pai1,pai2,n_femtocelulas_individuo);
    cruzamento_resultado(loop7+1,:) = cruzamentoPMX(pai2,pai1,n_femtocelulas_individuo); 
    
end

%-------------------------------------------%
%------------------MUTACAO------------------%
%-------------------------------------------%

%se iniciada, a mutacao troca aleatoriamente de posicao dois genes de um individuo

for loop8 = 1:n_individuos_populacao
    
    %checa se a taxa de mutacao permite por sorte inciar o processo
    if rand(1)<=taxa_mutacao
        
        mutante = cruzamento_resultado(loop8,:);
        
        %posicao do gene 1 a ser trocado
        mut1 = randi([1,n_femtocelulas_individuo],1);
        %posicao do gene 2 a ser trocado
        mut2 = randi([1,n_femtocelulas_individuo],1);
        
        %checa se mut1 e mut2 sao iguais, o que nao � desejado
        while (mut2 == mut1)
            
            mut2 = randi([1,n_femtocelulas_individuo],1);
            
        end
        
        cruzamento_resultado(loop8,mut1) = mutante(1,mut2);
        cruzamento_resultado(loop8,mut2) = mutante(1,mut1);
        
    end
    
end

geracao_atual = cruzamento_resultado;
loop0

end

%plota a relacao individuo x interferencia da primeira e da ultima geracao
if loop0 == epocas
    
    figure(1) 
    %plot (interferencia_geracao_atual);
    plot (fitness);
    title('Indiv�duos da 1a gera��o')
    xlabel('Indiv�duo') % x-axis label
    ylabel('SINR INICIAL') % y-axis label
    drawnow
    
end