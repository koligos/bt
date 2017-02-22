G = graph([1 1 2   4 4 5 5],[2 3 3 5 6 6 7]);
h = plot(G);
c = h.EdgeColor;
h.EdgeColor = 'k';
h.LineWidth=3;
h.MarkerSize=10;
A=adjacency(G);
T=full(A);
L2=full(laplacian(G));
h.EdgeAlpha=1;
charpol=charpoly(L2);
charpol_1=charpoly(L2(1:3,1:3));
charpol_2=charpoly(L2(4:7,4:7));


w= conv(charpol_1, charpol_2);
