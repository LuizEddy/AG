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
    
function [filho] = cruzamentoPMX (pai1, pai2, n_femtocelulas_individuo)

filho = pai1;

r1 = randi([1,n_femtocelulas_individuo],1);
r2 = randi([1,n_femtocelulas_individuo],1);

while (r2 == r1 || abs (r2-r1) == n_femtocelulas_individuo-1)
    
    r2 = randi([1,n_femtocelulas_individuo],1);
    
end

pc1 = r1;
pc2 = r2;



if r2 < r1
    
    pc1 = r2;
    pc2 = r1;
    
end

%pc1 = 2;
%pc2 = 8;

for i = 1:pc1-1
    
    filho(i) = 0;
    
end

if pc2 ~= 120
    
    
    for j = pc2+1:n_femtocelulas_individuo
        
        filho(j) = 0;
        
    end
    
end

swath = filho(pc1:pc2);

j = 1;
flag2 = 0;

for i = pc1:pc2
    
    if ~(any (swath == pai2(i)))
        
        selecionados_(j) = pai2(i); %4 e 7
        indices(j) = i; %indices dos selecionados(do 4 = 5 e do 7 = 8)
        j = j+1;
        flag2 = 1;
    end
    
end

if (flag2 == 1)
    
    comprimento = length(selecionados_);
    checagem = pc1:pc2;
    
    
    
    for i = 1:comprimento
        
        atual = selecionados_(i); %o valor atual do sem casa (comeca com 4)
        flag = 1;
        
        while flag ~=0
            
            indice_pai2 = find(pai2 == atual); %indice do 4 (5)
            temp1 = pai1(indice_pai2); %comeca com 6
            indice_pai1 = find(pai2 == temp1); %vai dar 7, que eh a posicao do 6
            
            if any (checagem == indice_pai1)
                
                atual = temp1;
                
            end
            
            if ~any (checagem == indice_pai1)
                
                filho(indice_pai1) = selecionados_(i);
                
                flag = 0;
                
            end
        end
        
    end
    
end


for i = 1:length(filho)
    
    if (filho(i) == 0)
        
        filho(i) = pai2(i);
    end
end
