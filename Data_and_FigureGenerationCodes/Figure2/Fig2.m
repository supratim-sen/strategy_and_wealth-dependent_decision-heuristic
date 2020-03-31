% Plotting data for figure 2 of the paper from .txt file produced from "main_env_update.m" and "main_fermi.m"

beta = '01';
gini = 2;
filext = ['beta_',num2str(beta),'_gini_',num2str(gini)];

C_0 = dlmread(num2str(['Cooperation1_gini_',num2str(gini),'.txt']));
%W_2 = dlmread('Wealth_gini_f0.txt');
G_0 = dlmread(num2str(['GINI1_gini_',num2str(gini),'.txt']));
Deg_0 = dlmread(num2str(['Degree1_gini_',num2str(gini),'.txt']));

C_2 = dlmread(num2str(['Cooperation_gini_f',num2str(gini),'_beta',num2str(beta),'.txt']));
%W_2 = dlmread('Wealth_gini_f0.txt');
G_2 = dlmread(num2str(['GINI_gini_f',num2str(gini),'_beta',num2str(beta),'.txt']));
Deg_2 = dlmread(num2str(['Degree_gini_f',num2str(gini),'_beta',num2str(beta),'.txt']));

n = size(C_0);
iterations = n(1);
rounds = n(2);
M = 30;

% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Arial')
set(0,'DefaultAxesFontSize', 18)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Arial')
set(0,'DefaultTextFontSize', 18)

%% Cooperation
upper_dr = mean(C_0) + std(C_0);
lower_dr = mean(C_0) - std(C_0); 
upper_res = mean(C_2) + std(C_2);
lower_res = mean(C_2) - std(C_2);

figure()
plot(1:rounds,mean(C_0),'-s','LineWidth',2.0,'MarkerSize',5,'Color',[0 0 1],'MarkerFaceColor',[0 0 1]);
hold on
plot(1:rounds,mean(C_2),'-s','LineWidth',2.0,'MarkerSize',5,'Color',[0.8 0.2 0.2],'MarkerFaceColor',[0.8 0.2 0.2]);
fill([1:rounds fliplr(1:rounds)],[upper_dr fliplr(lower_dr)],'b','EdgeColor','none')
alpha(0.2)
fill([1:rounds fliplr(1:rounds)],[upper_res fliplr(lower_res)],'r','EdgeColor','none')
alpha(0.2)
xlabel('Number of rounds')
ylabel('Fraction of cooperators')
axis([1,M+1,0,1])
legend('Environment dependent update', 'Fermi update')
title(num2str(['GINI = 0.',num2str(gini)]))
grid on
print(num2str(['fraction_C_fermi',filext,'.eps']),'-depsc')
print(num2str(['fraction_C_fermi',filext,'.png']),'-dpng','-r300')
hold off

%% GINI
upper_dr = mean(G_0) + std(G_0);
lower_dr = mean(G_0) - std(G_0); 
upper_res = mean(G_2) + std(G_2);
lower_res = mean(G_2) - std(G_2);

figure()
plot(1:rounds,mean(G_0),'-s','LineWidth',2.0,'MarkerSize',5,'Color',[0 0 1],'MarkerFaceColor',[0 0 1]);
hold on
plot(1:rounds,mean(G_2),'-s','LineWidth',2.0,'MarkerSize',5,'Color',[0.8 0.2 0.2],'MarkerFaceColor',[0.8 0.2 0.2]);
fill([1:rounds fliplr(1:rounds)],[upper_dr fliplr(lower_dr)],'b','EdgeColor','none')
alpha(0.2)
fill([1:rounds fliplr(1:rounds)],[upper_res fliplr(lower_res)],'r','EdgeColor','none')
alpha(0.2)
xlabel('Number of rounds')
ylabel('GINI coefficient')
axis([1,M+1,0,0.5])
legend('Environment dependent update', 'Fermi update')
title(num2str(['GINI = 0.',num2str(gini)]))
grid on
print(num2str(['gini_fermi',filext,'.eps']),'-depsc')
print(num2str(['gini_fermi',filext,'.png']),'-dpng','-r300')
hold off

%% Degree
upper_dr = mean(Deg_0) + std(Deg_0);
lower_dr = mean(Deg_0) - std(Deg_0); 
upper_res = mean(Deg_2) + std(Deg_2);
lower_res = mean(Deg_2) - std(Deg_2);

figure()
plot(1:rounds,mean(Deg_0),'-s','LineWidth',2.0,'MarkerSize',5,'Color',[0 0 1],'MarkerFaceColor',[0 0 1]);
hold on
plot(1:rounds,mean(Deg_2),'-s','LineWidth',2.0,'MarkerSize',5,'Color',[0.8 0.2 0.2],'MarkerFaceColor',[0.8 0.2 0.2]);
fill([1:rounds fliplr(1:rounds)],[upper_dr fliplr(lower_dr)],'b','EdgeColor','none')
alpha(0.2)
fill([1:rounds fliplr(1:rounds)],[upper_res fliplr(lower_res)],'r','EdgeColor','none')
alpha(0.2)
xlabel('Number of rounds')
ylabel('Average Degree')
axis([1,M+1,0,35])
legend('Environment dependent update', 'Fermi update')
title(num2str(['GINI = 0.',num2str(gini)]))
grid on
print(num2str(['fraction_C_fermi',filext,'.eps']),'-depsc')
print(num2str(['Deg_fermi',filext,'.png']),'-dpng','-r300')
hold off