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

clc;
clear all;

no_de_femtocelulas = 300;
no_de_individuos = 1;

%gera 'no_de_individuos' iniciais aleatoriamente mas sem repetir as femtocelulas
%que eles contem dentro de si

for i = 1:no_de_individuos
    
    j = randperm(no_de_femtocelulas);
    
    geracao_inicial(i,:) = j;
    
    i
    
end
geracao_inicial = geracao_inicial';
