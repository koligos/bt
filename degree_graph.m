G = digraph([  2 3  3 4 4 3 3 3 ],[  5 2  3 4 1 1 4  5]);
h = plot(G);
c = h.EdgeColor;
h.EdgeColor = 'k';
h.LineWidth=3;
h.MarkerSize=10;
h.EdgeAlpha=1;
h.ArrowSize=20;
A=adjacency(G);
T=full(A);
A=T;
D = diag(A);
A = A - diag(D);
colors = get(gca,'colororder');
circle = exp(2*pi*i*(0:32)/32);
for k = 1:size(A,1)
   disc = D(k) + norm(A(k,:),1)*circle;
   c = colors(mod(k,length(colors))+1,:);
   plot(real(D(k)),imag(D(k)),'*','color',c)
   plot(real(disc),imag(disc),'-','color',c);
end