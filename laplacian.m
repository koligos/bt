s=[1 1 2 2 3 3 3 4 4 4 5 6 7 8 8 9 9 10  ];%pocatecni vrcholy
t=[2 3 4 5 7 10 5 5 6 7 6 7 5 1 2 10 7 8];%koncove vrcholy
w=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; %vahy prislusnych hran
G = graph(s,t,w); %vytvor graf G s parametry s, t, w
figure(3);
plot(G,'EdgeLabel',G.Edges.Weight) %vykresli graf G

for i= 1:length(s)%A = adjacency(A) %A je matice sousednosti A(i,j)=1 <=> existuje hrana (i,j)
   A(s(i),t(i))=1;
   A(t(i),s(i))=1; %dodatek pro neorientovane grafy - zakomentovat pro orientovane
end

checkA=isequal(A, adjacency(G)); %kontrola spravnosti matice incidence

M=0; %M je nejvyssi stupen vrcholu grafu G
for i=1:size(A)
    sumRadek=sum(A(i,:))
    if sumRadek>=M
        M=sumRadek;        
    end
end

eps =1/(2*M);

for i = 1:size(A)
    D(i,i)=sum(A(i,:))%D je diagonalni matice, ktera ma na pozici (i;i) stupen i-teho vrcholu

end

L=D-A; %Laplaceova matice grafu G (z definice 1)

checkLaplacian=isequal(laplacian(G),L); %kontrola Laplacianu s knihovni funkci

for i= 1:length(s) %dalsi vypocet Laplacianu z matice incidence; E je matice incidence grafu G
    E(s(i),i)=1;
    E(t(i),i)=-1;
end
L2=E*transpose(E);

checkLaplacian2=isequal(laplacian(G),L2); %kontrola laplacianu 2 s knihovni funkci

I=L*ones(max(s)); %soucin laplacianu s vektorem (1, 1 , ..., 1) = 0

D = eig(L,'matrix')%diagonalni matice vlastnich cisel Laplacianu

for i = 1:max(s)
pocatecniHodnotaUzlu(i)=i; %inicializace pocatecich hodnot (na kterych maji uzly provest konsensus) mezivysledky(i+1,j)=prubeznaHodnota(j);
mezivysledky(1,i)=pocatecniHodnotaUzlu(i);
end

for i= 1:max(s)
vyslednaHodnota(i)=mean(pocatecniHodnotaUzlu); %ocekavany vysledek, tj. prumer pocatecnich hodnot
end

prubeznaHodnota=pocatecniHodnotaUzlu; %inicializace pocatecnich hodnot uzlu 

pocetIteraci = 50;

for i=1:pocetIteraci+1
casovaSouradnice(i)= i-1
end

for i = 1:pocetIteraci
    prubeznaHodnota=prubeznaHodnota-eps*(prubeznaHodnota*L);
    for j=1:max(s)
            mezivysledky(i+1,j)=prubeznaHodnota(j);
            chybaPrubezneHodnoty(i+1,j)=vyslednaHodnota(j)-prubeznaHodnota(j);
    %prubeznaHodnota(5)=3; vlozeni konstantni hodnoty- k te pak bude
    %vysledek konvergovat

    end
    %prubeznaHodnota(5)=3;
end

subplot(2, 1, 1);
plot(casovaSouradnice, mezivysledky(:,:));
title('Convergence to mean of initial values');
subplot(2, 1, 2);

plot(casovaSouradnice, chybaPrubezneHodnoty(:,:));
title('shrinking of error');



 







