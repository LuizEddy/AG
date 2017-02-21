%     Este programa é um software livre; você pode redistribuí-lo e/ou 
%     modificá-lo sob os termos da Licença Pública Geral GNU como publicada
%     pela Fundação do Software Livre (FSF); na versão 3 da Licença,
%     ou (a seu critério) qualquer versão posterior.
% 
%     Este programa é distribuído na esperança de que possa ser útil, 
%     mas SEM NENHUMA GARANTIA; sem uma garantia implícita de ADEQUAÇÃO
%     a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a
%     Licença Pública Geral GNU para mais detalhes.
% 
%     Você deve ter recebido uma cópia da Licença Pública Geral GNU junto
%     com este programa. Se não, veja <http://www.gnu.org/licenses/>.

clear all;
clc;

load ('pot_font1.mat');
load ('pot_inter1.mat');
load ('individuo_final_convergido.mat');

densidade = 0.5;
branco_variancia = 10^(-80.97/10);

n_femtocelulas = 15; %número de femtocélulas na rede
n_subbandas = 3; %número de subbandas da rede
femtos_por_cluster = n_femtocelulas/n_subbandas; %deve ser uma divisão inteira

x1 = reshape(individuo_final_convergido,[femtos_por_cluster,n_subbandas]); %re-arranja o vetor individuo em uma matriz
x2 = x1'; %x2 transforma o vetor individuo em uma matriz, onde cada linha sera um cluster

for loop0 = 1:n_subbandas
    
    x3 = x2(loop0,:); %x3 armazena um cluster por vez
    
    for loop1 = 1:femtos_por_cluster
        
        femto_atual = x3(loop1);
        potencia_fonte = Pot_fonte(femto_atual); 
        
        soma_potencias_interferentes = 0;
        
        for loop2 = 1:femtos_por_cluster
            
            soma_potencias_interferentes = soma_potencias_interferentes + Pot_inter(femto_atual,x3(loop2));
            
        end
        
        
        SINR_aux = potencia_fonte / ((soma_potencias_interferentes*densidade) + branco_variancia);
        SINR_DEPOIS_TEMPORARIO(loop0,loop1) = SINR_aux;
    end
    
end


y1 = SINR_DEPOIS_TEMPORARIO';
y2 = y1(:)';

[y3,y4] = sort(individuo_final_convergido);

SINR_DEPOIS = y2(y4);


bar(SINR_DEPOIS,'DisplayName','SINR_DEPOIS');figure(gcf)