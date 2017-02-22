s=[1  1 2  2 3  3 4  6 6 6 ];%pocatecni vrcholy
t=[4  3 4  5 2  5 5  1 3 4];%koncove vrcholy
G = graph(s,t); %vytvor graf G s parametry s, t, w
   set( findobj(gca,'type','line'), 'LineWidth', 5);


p = plot(G)