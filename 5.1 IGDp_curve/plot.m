problem_name = 'DAS3_cov';  
Metric = 'IGDp'; 
algorithms = {'NSGAII', 'CMOEAMS', 'CTAEA', 'CCMO', 'C3M', 'URCMO', 'MOEADLCDP', 'SCDP'}; 
A = zeros(8,1000);
for alg_idx = 1:length(algorithms)
    algorithm_name = algorithms{alg_idx};
    mat_file = sprintf('D:\\experiment\\PlatEMO-EPDCMO\\Cov\\%s_%s.mat', algorithm_name,problem_name);
    load(mat_file);
    A(alg_idx,:) = I;
end
figure
x = 1:1000;
plot(x,log(A(1,:)),'--','LineWidth',1.5,'color',[.0,.75,.9]);
hold on
plot(x,log(A(2,:)),':','LineWidth',1.5,'color',[.9,.0,.0]);
plot(x,log(A(3,:)),'-','LineWidth',1.5,'color',[.0,.9,.0]);
plot(x,log(A(4,:)),'-.','LineWidth',1.5,'color',[.5,.9,.85]);
plot(x,log(A(5,:)),':','LineWidth',1.5,'color',[.0,.0,.9]);
plot(x,log(A(6,:)),'--','LineWidth',1.5,'color',[.7,.0,.7]);
plot(x,log(A(7,:)),'-','LineWidth',1.5,'color',[.9,.7,.0]);
plot(x,log(A(8,:)),'-.','LineWidth',1.5,'color',[.5,.7,0]);
hold off
legend('NSGAII','CMOEA\_MS','C-TAEA','CCMO','C3M', 'URCMO', 'MOEA/D-LCDP', 'SCDP');
xlabel('Generation');
ylabel('IGD^+');
xticks(linspace(0, 0.2, 100));
set(gca,'FontSize',10); 
set(gca,'XTick',0:200:1100); 
set(gca,'XTickLabel',{'0','200','400','600','800','1000'}); 