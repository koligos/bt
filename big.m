clear;

vertices = 100;
pocetIteraci = 30;

G = WattsStrogatz(vertices,10,0.8);
L=full(laplacian(G));

degreeMAX= max(max(L));


IT=eye(size(L))-(1/degreeMAX)*L;

for i = 1:vertices
pocatecniHodnotaUzlu(i)=i; %inicializace pocatecich hodnot (na kterych maji uzly provest konsensus) mezivysledky(i+1,j)=prubeznaHodnota(j);
mezivysledky(1,i)=pocatecniHodnotaUzlu(i);
chybaPrubezneHodnoty(1,i)=-pocatecniHodnotaUzlu(i)+mean(pocatecniHodnotaUzlu);
end
for i=1:vertices
vyslednaHodnota(i)=mean(pocatecniHodnotaUzlu); %ocekavany vysledek, tj. prumer pocatecnich hodnot
end

prubeznaHodnota=pocatecniHodnotaUzlu; 


for i=1:pocetIteraci+1
casovaSouradnice(i)= i-1;
end



for i = 1:pocetIteraci
    prubeznaHodnota= prubeznaHodnota* IT ;
    for j=1:vertices
            mezivysledky(i+1,j)=prubeznaHodnota(j);
            chybaPrubezneHodnoty(i+1,j)=vyslednaHodnota(j)-prubeznaHodnota(j);
    %prubeznaHodnota(5)=3; vlozeni konstantni hodnoty- k te pak bude
    %vysledek konvergovat

    end
    %prubeznaHodnota(5)=3;
end


figure;

subplot(2, 1, 1);
plot(casovaSouradnice, mezivysledky(:,:));
title('Convergence to mean of initial values');
subplot(2, 1, 2);
grid on
plot(casovaSouradnice, chybaPrubezneHodnoty(:,:));
title('shrinking of error');

grid on
