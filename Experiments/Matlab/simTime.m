n=100000; 
[G,Y]=simGenerate(21,n,3,1);
tic
A=GraphEncoderOld(G,Y);
toc
tic
B=GraphEncoder(G,Y);
toc
norm(A-B{1,1})