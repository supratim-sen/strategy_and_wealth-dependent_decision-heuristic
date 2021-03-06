close all; clear; clc;
%% Pairwise Comparison rule
% Cooperation rules affecting wealth distribution in dynamical social networks

%% Initializing
s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s); % seeds the random number generator so that matlab produce a predictable sequence of numbers. 

% Paramenters
n =  50;           % Number of nodes
rich_W = 700;      % Wealth value of rich
poor_W = 300;      % Wealth value of poor
p_rich = 0.5;      % Probability of being rich
M = 50;            % Number of rounds
c = 50;            % Unitary Cost of co-operation
b = 100;           % Unitary Benefit of co-operation
p_rewire = 0.3;    % Rewiring probability
itrs = 100;        % Number of iterations
bias = 0.1;        % bias factor in probability of cooperation term
beta = 0.01;       % selection pressure

% Empty matrix for storing results
C_array = zeros(itrs,M); % Stores number of cooperators in every round over iteration
W_array = zeros(itrs,M+1); % Stores average wealth in every round over iteration 
Deg_array = zeros(itrs,M+1); % Stores degree of each node in every round over iteration
GINI_array = zeros(itrs,M+1); % Stores degree of each node in every round over iteration

% Initial Graph
[Adj_initial,n_edges_initial] = Erdos_Renyi_Graph(n,p_rewire); % Function generates Adjacency matrix for Erdos Renyi Graph

for i = 1:itrs
    % Initiallizing wealth, probability of coooperation
    W_initial = randsample([rich_W, poor_W],n,true,[p_rich,1-p_rich]);
    W_initial = W_initial(randperm(n))';     % random permutation of array and transpose
    GINI_initial = Gini_cal(W_initial);     % GINI Coefficient
    % p0 =  1/(1 + exp(-1*((-1.017021)*GINI_initial + (0.8130213))));  % initial probability of cooperation
    p0 = 0.7;
    % In 1st iteration initial wealth, graph, GINI is same.
    W = W_initial; % Wealth vector in 1st iteration is same for all 1st iterations. 
    GINI = GINI_initial; % initial GINI in 1st iteration
    Adj = Adj_initial; % initail graph in 1st iteration
    n_edges = n_edges_initial; % inital number of edges in the 1st iteration
    
    % Decision of being cooperators in the 1st iteration:
    % 1's means cooperation, 0's means defection. This happen with probability p0 and 1-p0
    C_initial = randsample([1,0],n,true,[p0,1-p0])';   % Cooperation in 1st round
    C = C_initial; % inital cooprations in the 1st iteration
    
    % Storing average wealth, cooperators, GINI, degree in jth round:
    W_array(i,1) = mean(W); % average global wealth of population
    C_array(i,1) = mean(C); % fraction of cooperators
    GINI_array(i,1) = GINI; % GINI of wealth distribution
    Deg_array(i,1) = 2*n_edges/n; % average degree of graph    
    
    for j = 2:M+1
        % Updating Wealth because of playing 'Game' (for j+1 round)
        W = W + b*Adj*C - c*(sum(Adj,2)).*C;
        Payoff = b*Adj*C - c*(sum(Adj,2)).*C;
        GINI = Gini_cal(W);     % GINI Coefficient changes w.r.t. W (for j+1 round)
        
        % Updating Cooperators
        Degree = sum(Adj,2);    % Degree of each node
        focal_vec = randperm(n);
        jj = 1;
        while jj <= n
            focal = focal_vec(jj);
            if Degree(focal) == 0
                jj = jj + 1;
            else        
                role = randsample(find(Adj(focal,:)),1);
                    if rand() < 1/(1+exp(beta*(Payoff(focal)-Payoff(role))))
                        C(focal) = C(role);
                    end
                jj = jj + 1;
            end
        end
        
        % Network rewiring
        % We need to select 'p_rewire' fraction of possible links without
        % replacement from all possible link pairs.
        n_rewire = round(n*(n-1)*p_rewire/2); % total number of links to be chosen
        [r1,c1] = find(triu(ones(n,n),1)); % node index of all possible link pairs without replacement.
        i_perm = randperm(length(r1)); % random selection of possible link pairs
        r1 = r1(i_perm); c1 = c1(i_perm);
        node_select = [r1(1:n_rewire),c1(1:n_rewire)]; % selection only 'n_rewire' number out of all possibility.
        % Rewiring loop which goes through 'n_rewire' link pairing:
        for ii = 1:n_rewire
        node1 = node_select(ii,1); % index of node 1
        node2 = node_select(ii,2); % index of node 2
        nonfocal_node = randsample([1,2],1); % index of non-focal node. Focal node decides to break the link based on the decision of non-focal-node.
        % Breaking Links
            if Adj(node1,node2) == 1 && C(node_select(ii,nonfocal_node)) == 1 && rand() < (1 - 0.87) % && rr <= 0.5
                Adj(node1,node2) = 0; Adj(node2,node1) = 0;
            elseif Adj(node1,node2) == 1 && C(node_select(ii,nonfocal_node)) == 0 && rand() < 0.70 % && rr <= 0.5
                Adj(node1,node2) = 0; Adj(node2,node1) = 0;
            
        % Making Links        
            elseif Adj(node1,node2) == 0 && C(node1) == 1 && C(node2) == 1 && rand() < 0.93
                Adj(node1,node2) = 1; Adj(node2,node1) = 1;    
            elseif Adj(node1,node2) == 0 && C(node1) == 1 && C(node2) == 0 && rand() < (1-0.70)
                Adj(node1,node2) = 1; Adj(node2,node1) = 1;
            elseif Adj(node1,node2) == 0 && C(node1) == 0 && C(node2) == 1 && rand() < (1-0.70)
                Adj(node1,node2) = 1; Adj(node2,node1) = 1;
            elseif Adj(node1,node2) == 0 && C(node1) == 0 && C(node2) == 0 && rand() < (1-0.80)
                Adj(node1,node2) = 1; Adj(node2,node1) = 1;   
            end
        end       
    % Storing average wealth, cooperators, GINI, degree in jth round:
    W_array(i,j) = mean(W); % average global wealth of population
    C_array(i,j) = mean(C); % fraction of cooperators
    GINI_array(i,j) = GINI; % GINI of wealth distribution
    Deg_array(i,j) = sum(sum(full(Adj)))/n; % average degree of graph 
   end
end
% Saving data in txt file:
dlmwrite('Cooperation_gini_f2_beta01.txt',C_array)
% dlmwrite('Wealth_gini_f2.txt',W_array)
dlmwrite('GINI_gini_f2_beta01.txt',GINI_array)
dlmwrite('Degree_gini_f2_beta01.txt',Deg_array)

% figure()
% % % % hold on
%  plot(1:M+1,sum(GINI_array)/itrs,'-o')
%  xlabel('rounds')
%  ylabel('GINI coefficient')
%  axis([1,M+1,0,0.4])
% % %print('gini1_0.jpg','-djpeg','-r300')
% % 
% figure()
% plot(1:M+1,sum(C_array)/itrs,'-o')
% xlabel('rounds')
% ylabel('Fraction of cooperators')
% axis([1,M+1,0,1])
% % %print('fraction_C1.jpg','-djpeg','-r300')
% % 
% figure()
% plot(1:M+1,sum(W_array)/itrs,'-o')
% xlabel('rounds')
% ylabel('Global Average Wealth')
% % %print('wealth1.jpg','-djpeg','-r300')
% % 
% figure()
% plot(1:M+1,sum(Deg_array)/itrs,'-o')
% xlabel('rounds')
% ylabel('Global Average Degree') 
% %print('degree1.jpg','-djpeg','-r300')
