
bias = 0.1;
lamda = 0.001;
Diff_W = -3000:0.1:3000;

p0 = 0.55;
pc1 = ( p0 + (1-p0)*tanh(lamda*Diff_W) - bias );

p0 = 0.6;
pc2 = ( p0 + (1-p0)*tanh(lamda*Diff_W) - bias );

p0 = 0.7;
pc3 = ( p0 + (1-p0)*tanh(lamda*Diff_W) - bias );

p0 = 0.8;
pc4 = ( p0 + (1-p0)*tanh(lamda*Diff_W) - bias );

p0 = 0.9;
pc5 = ( p0 + (1-p0)*tanh(lamda*Diff_W) - bias );


% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Arial')
set(0,'DefaultAxesFontSize', 18)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Arial')
set(0,'DefaultTextFontSize', 18)

figure()
plot(Diff_W,pc1,'LineWidth',3,'MarkerSize',5,'Color',[0 0 1],'MarkerFaceColor',[0 0 1])
hold on
plot(Diff_W,pc2,'LineWidth',3,'MarkerSize',5,'Color',[0.3 0.3 1],'MarkerFaceColor',[0 0 1])
plot(Diff_W,pc3,'LineWidth',3,'MarkerSize',5,'Color',[0.6 0.6 1],'MarkerFaceColor',[0 0 1])
plot(Diff_W,pc4,'LineWidth',3,'MarkerSize',5,'Color',[0.8 0.8 1],'MarkerFaceColor',[0 0 1])
plot(Diff_W,pc5,'LineWidth',3,'MarkerSize',5,'Color',[0.9 0.9 1],'MarkerFaceColor',[0 0 1])

plot(Diff_W,1-pc1,'LineWidth',3,'MarkerSize',5,'Color',[0.9 0 0],'MarkerFaceColor',[0.9 0 0])
plot(Diff_W,1-pc2,'LineWidth',3,'MarkerSize',5,'Color',[0.9 0.3 0.3],'MarkerFaceColor',[0.9 0 0])
plot(Diff_W,1-pc3,'LineWidth',3,'MarkerSize',5,'Color',[0.9 0.6 0.6],'MarkerFaceColor',[0.9 0 0])
plot(Diff_W,1-pc4,'LineWidth',3,'MarkerSize',5,'Color',[0.9 0.8 0.8],'MarkerFaceColor',[0.9 0 0])
plot(Diff_W,1-pc5,'LineWidth',3,'MarkerSize',5,'Color',[0.95 0.9 0.9],'MarkerFaceColor',[0.9 0 0])

line([0 1],[-3000 3000],'Color','k','LineStyle','--')
line([-3000 3000],[0.5 0.5],'Color','k','LineStyle','--')

axis([-3000,3000,0,1])
xlabel('Wealth difference')
ylabel('Probability of cooperation')
legend('$p_{0}=0.55$','$p_{0}=0.60$','$p_{0}=0.70$','$p_{0}=0.80$','$p_{0}=0.90$','$p_{0}=0.55$',...
    '$p_{0}=0.60$','$p_{0}=0.70$','$p_{0}=0.80$','$p_{0}=0.90$','Interpreter','latex','Location','northeastoutside')

