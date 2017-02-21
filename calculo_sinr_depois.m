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

load ('pot_font1.mat');
load ('pot_inter1.mat');
load ('individuo_final_convergido.mat');

densidade = 0.5;
branco_variancia = 10^(-80.97/10);

n_femtocelulas = 15; %n�mero de femtoc�lulas na rede
n_subbandas = 3; %n�mero de subbandas da rede
femtos_por_cluster = n_femtocelulas/n_subbandas; %deve ser uma divis�o inteira

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