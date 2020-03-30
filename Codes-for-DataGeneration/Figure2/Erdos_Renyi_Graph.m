function [Adj,n_edges] = Erdos_Renyi_Graph(n,p)
Adj = sparse(n,n);
V = randsample([0 1],n*(n-1)/2,true,[1-p p]);
Adj(triu(true(n),1)) = V;
Adj = Adj + Adj';
n_edges = sum(V);
end