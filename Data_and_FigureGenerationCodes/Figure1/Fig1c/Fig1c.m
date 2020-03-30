close all; clear; clc;
%% Generates snapshot of network in Fig1c and also creates a video
% Cooperation rules affecting wealth distribution in dynamical social networks

%% Initializing
s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s); % seeds the random number generator so that matlab produce a predictable sequence of numbers. 

% Parameters
n =  12;           % Number of nodes
%rich_W = 1150;    % Wealth value of rich
%poor_W = 200;     % Wealth value of poor
rich_W = 500;      % Wealth value of rich
poor_W = 500;      % Wealth value of poor
p_rich = 0.5;      % Probability of being rich
M = 50;            % Number of rounds
c = 50;            % Unitary Cost of co-operation
b = 100;           % Unitary Benefit of co-operation
p_rewire = 0.3;    % Rewiring probability
itrs = 1;          % Number of iterations
bias = 0.1;        % bias factor in probability of cooperation term
lamda = 0.000001;
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
    p0 = 0.6;
    
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
        GINI = Gini_cal(W);     % GINI Coefficient changes w.r.t. W (for j+1 round)
        
        % Updating Cooperators
        Degree = sum(Adj,2);    % Degree of each node
        Diff_W = (Adj*W)./Degree - W; % wealth difference required for updating pc
        Enviornment = (Adj*C - Adj*(1-C)); % Required for updating pc
        Enviornment(Enviornment>=0) = 1; % 1 means 'cooperative environment' 
        Enviornment(Enviornment<0) = -1; % % -1 means 'defective environment' 
%       pc = ( p0 + (1-p0)*tanh(0.001*Diff_W.*Enviornment) - bias ) + heaviside(-Enviornment)*(1-2*p0+2*bias);
        pc = heaviside(Enviornment).*( p0 + (1-p0)*tanh(lamda*Diff_W) - bias ) + heaviside(-Enviornment).*( 1 - p0 - (1-p0)*tanh(lamda*Diff_W) + bias );
        C = (rand(n,1)<pc); % Decision of each node in j+1 round
        
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
            if Adj(node1,node2) == 1
                if C(node_select(ii,nonfocal_node)) == 1 && rand() < (1 - 0.87) % && rr <= 0.5
                    Adj(node1,node2) = 0; Adj(node2,node1) = 0;
                elseif C(node_select(ii,nonfocal_node)) == 0 && rand() < 0.70 % && rr <= 0.5
                    Adj(node1,node2) = 0; Adj(node2,node1) = 0;
                else
                    pass = 0;
                end
  
            
        % Making Links        
            else
                if C(node1) == 1 && C(node2) == 1 && rand() < 0.93
                    Adj(node1,node2) = 1; Adj(node2,node1) = 1;    
                elseif C(node1) == 1 && C(node2) == 0 && rand() < (1-0.70)
                    Adj(node1,node2) = 1; Adj(node2,node1) = 1;
                elseif C(node1) == 0 && C(node2) == 1 && rand() < (1-0.70)
                    Adj(node1,node2) = 1; Adj(node2,node1) = 1;
                elseif C(node1) == 0 && C(node2) == 0 && rand() < (1-0.80)
                    Adj(node1,node2) = 1; Adj(node2,node1) = 1;
                else
                    pass = 0;
                end
            end 
        end
    figure(1)       
    G = graph(Adj);
    h = plot(G,'LineWidth',1.5,'MarkerSize',18,'EdgeColor','k','Layout','circle'); 
    highlight(h,find(C==1),'NodeColor',[18,29,80]/127)
    highlight(h,find(C==0),'NodeColor',[100,15,23]/127)
    for ij=1:n
    highlight(h,ij,'MarkerSize',18*W(ij)/mean(W))
    end
    
    title(['Round # ',num2str(j-1)])
    
%     % Remove extra whitespace
%     ax = gca;
%     outerpos = ax.OuterPosition;
%     ti = ax.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     ax.Position = [left bottom ax_width ax_height];
    
    h.NodeLabel = {};  % remove labels
    daspect([1 1 1]) % make aspect ratio 1:1
    % set(gca,'Visible','off')
    F(j-1) = getframe(gcf);
    print(['network_snapshot3_',num2str(j),'.jpg'],'-djpeg','-r150')   
    
    % Storing average wealth, cooperators, GINI, degree in jth round:
    W_array(i,j) = mean(W); % average global wealth of population
    C_array(i,j) = mean(C); % fraction of cooperators
    GINI_array(i,j) = GINI; % GINI of wealth distribution
    Deg_array(i,j) = sum(sum(full(Adj)))/n; % average degree of graph 
    end
end

%% Generate video

%  % create the video writer with 1 fps
%  writerObj = VideoWriter ( 'Video_invisible.avi');
%  writerObj.FrameRate = 2.5;
%  % set the seconds per image
% % open the video writer
% open (writerObj);
% % write the frames to the video
% for i = 1: length (F)
%    % convert the image to a frame
%    frame = F (i);    
%    writeVideo (writerObj, frame);
% end
% % close the writer object
% close (writerObj);