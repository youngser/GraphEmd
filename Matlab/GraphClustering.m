%% Do AEE k-means clustering
%%
%% @param X is either n*n adjacency, or s*2 edge list.
%%        Adjacency matrix can be weighted or unweighted, directed or undirected.
%%        If X is edge list, it shall be unweighted.
%% @param k is desired number of clusters
%% @param maxIter is maximum number of iteration
%%
%% @return The n*1 cluster index ind
%% @return The n*k Encoder Embedding Z
%% @return The n*k Encoder Transformation W
%%
%% @export
%% 
function [ind,Z,W]=GraphClustering(X,k,maxIter)

%%% if necessary, use the following code to remove any zero row and column from X:
%tmp=vecnorm(X); idx=(tmp>0); X=X(idx,idx);

%%% default parameter
if nargin<2
    k=2;
end
if nargin<3
    maxIter=20;
end

if size(X,2)==2
%     X=X-min(X)+1;
    n=max(max(X));
else
    n=size(X,1);
end
ind=randi([1,k],[n,1]);
warning ('off','all');
reseed=0;
for r=1:maxIter
    Z=GraphEncoder(X,ind);
    try 
       indNew = kmeans(Z, k);
    catch
       %%% when a graph is very sparse, sometimes Z can have many repeated entries from a random initialization, and kmeans will fail
       %warning('Re-initialize index due to graph being too sparse')
       reseed=1;
    end
    
    if reseed==1 %|| sum(isnan(indNew))>0
       reseed=0;
       r=r+1; 
       indNew=randi([1,k],[n,1]); %%% re-initialize 
    end
    
    if RandIndex(ind,indNew)==1 && reseed==0
        break;
    else
        ind=indNew;
    end
end
[Z,W]=GraphEncoder(X,indNew);