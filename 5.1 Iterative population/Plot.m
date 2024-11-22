load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_20.mat')
scatter(pop(:,1),pop(:,2),10,'o','Markerfacecolor',[.0,.0,.9062],'Markeredgecolor',[.0,.0,.9062])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_30.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[.0,.2969,1],'Markeredgecolor',[.0,.2969,1])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_40.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[.0,.7031,1],'Markeredgecolor',[.0,.7031,1])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_60.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[.0938,1,0.9062],'Markeredgecolor',[.0938,1,0.9062])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_80.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[.5,1,.5],'Markeredgecolor',[.5,1,.5])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_100.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[.9062,1,.0938],'Markeredgecolor',[.9062,1,.0938])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_150.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[1,.7031,0],'Markeredgecolor',[1,.7031,0])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_300.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[1,.2969,0],'Markeredgecolor',[1,.2969,0])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_600.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[.9062,0,0],'Markeredgecolor',[.9062,0,0])
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DAS3_1000.mat')
scatter(pop(:,1),pop(:,2), 10,'o','Markerfacecolor',[.5,0,0],'Markeredgecolor',[.5,0,0])

colormap jet;
colorbar;      
caxis([1 10]); 

color_ticks = [20,30,40,60,80,100,150,300,600,1000];  
colorbar('Ticks', linspace(1, 10, length(color_ticks)), ... 
         'TickLabels', arrayfun(@(x) num2str(x), color_ticks, 'UniformOutput', false));


fig = gcf;

new_position = [fig.Position(1), fig.Position(2), 550, 400];  

set(fig, 'Position', new_position);


load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_20.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.0,.0,.9062], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_30.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.0,.2969,1], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_40.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.0,.7031,1], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_60.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.0938,1,0.9062], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_80.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.5,1,.5], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_100.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.9062,1,.0938], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_150.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[1,.7031,0], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_300.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[1,.2969,0], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_600.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.9062,0,0], 'LineWidth',0.75)
load('D:\experiment\PlatEMO-EPDCMO\Gen\NSGAII_DC2_DTZL3_1000.mat')
scatter3(pop(:,1),pop(:,2),pop(:,3),'Markeredgecolor',[.5,0,0], 'LineWidth',0.75)