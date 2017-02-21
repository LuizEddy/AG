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
