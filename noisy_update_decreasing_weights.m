clear all;
clc;
variance_noise=1;

nodes=60;
G=graph(bucky);
% s=[1 1 2 2 3 3 3 4 4 4 5 6 7 8 8 9 9 10 11 11 12 12  13 13 14 14 15 15 16 16 17  ];%source vertices
% t=[2 3 4 5 7 10 5 5 6 7 6 7 5 1 2 10 7 8 2 3 4 5 6 7 8 9 10 11 12 13 14 ];%destination vertices.
% nodes=max(s);
% G = graph(s,t); %create graph G with parameters s, t, w
% 

figure;
plot(G)
deg=degree(G);
diad_D=zeros(nodes);
for p=1:nodes
   diag_D(p,p)=deg(p); 
end
iterations =10000;

for i=1:nodes    
x_0(i)=(10+wgn(1,1,0));    %initialize measurement
end

x_estimate_running_basic(1,:) = x_0;
e(1,:)= (x_0(1)-mean(x_0(1)));

MSE_act(1)= sum((x_0-mean(x_0)).^2);
MSE_ave(1)=MSE_act(1);
VAR(1)=var(x_0);
A=adjacency(G); %adjacency matrix
L=laplacian(G); %laplacian matrix

eig_L=eig(L);
gamma=2/(eig_L(2)+eig_L(nodes));%the best possible coefficient

mean_0=mean(x_0);
for i=1:iterations
    if i>1
        for pp=1:nodes
             e(i,pp)= (x_estimate_running_basic(i,pp))-mean(x_0);
        end
        R=e(i,:)'*e(i,:);
     % gamma=trace(R*L)/trace(L*R*L+variance_noise*diag_D);
     %  gamaaa(i)=gamma; %logging gamma
      gamma=trace(R*L+R*L')/2/trace(L*R*L'+variance_noise*diag_D);
     %gamma=trace(R*L+R*L')/trace(L*R*L'+variance_noise*diag_D); %first way
     %to decay coefficient \gammma
    end   
    %gamma=1/i^0.75; another way
   P=eye(nodes)- gamma* L;
   for j=1:nodes
  %
  noise_matrix=zeros(nodes);
  noise_matrix(j,:)=sqrt(variance_noise)*wgn(nodes,1,0) ;
  %noise_matrix=zeros(nodes); 
  noise_matrix(j,j)=0 ;
   end
   equiv_noise_matrix= P*noise_matrix;
   for j=1:nodes
     equiv_noise_vector(j)= equiv_noise_matrix(j,j);
   end
   x=P*x_estimate_running_basic(i,:)'+equiv_noise_vector'  ; 
   x_estimate_running_basic(i+1,:)=x; %classical linear consensus without noise
   
   MSE_ave(i+1)= sum((x_estimate_running_basic(i+1,:)   -mean(x_0)).^2)/nodes;
   MSE_act(i+1)= sum((x_estimate_running_basic(i+1,:)   -mean(  x_estimate_running_basic(i+1,:)    )).^2)/nodes;   
   VAR(i+1)= var(x_estimate_running_basic(i+1,:)  );

   
%   if i>10 %heuristic way to decrease coeffiecient
%        gamma=1/(1+i); %condition to prevent initial divergence
%   end
end

figure;
plot(0:iterations, x_estimate_running_basic(:,:));
ttl1=title( 'Values in nodes'  )
ttl1=set(ttl1,'Interpreter','latex','FontSize', 15);
xlbl1=xlabel('Iterations [-]');
xlbl1=set(xlbl1,'Interpreter','latex');
ylbl1=ylabel('Value [-]');
ylbl1=set(ylbl1,'Interpreter','latex');
grid;

figure;
loglog(0:iterations, MSE_ave(:));
ttl1=title( 'Mean square error w.r.t. initial average '  )
ttl1=set(ttl1,'Interpreter','latex','FontSize', 15);
xlbl1=xlabel('Iterations [-]');
xlbl1=set(xlbl1,'Interpreter','latex');
ylbl1=ylabel('Value [-]');
ylbl1=set(ylbl1,'Interpreter','latex');
grid;

figure;
loglog(0:iterations, MSE_act(:));
ttl1=title( 'Mean square error w.r.t moving average '  )
ttl1=set(ttl1,'Interpreter','latex','FontSize', 15);
xlbl1=xlabel('Iterations [-]');
xlbl1=set(xlbl1,'Interpreter','latex');
ylbl1=ylabel('Value [-]');
ylbl1=set(ylbl1,'Interpreter','latex');
grid;

figure;
loglog(0:iterations, VAR(:));
ttl1=title( 'Variance '  );
ttl1=set(ttl1,'Interpreter','latex','FontSize', 15);
xlbl1=xlabel('Iterations [-]');
xlbl1=set(xlbl1,'Interpreter','latex');
ylbl1=ylabel('Value [-]');
ylbl1=set(ylbl1,'Interpreter','latex');
grid;
