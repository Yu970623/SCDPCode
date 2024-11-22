% 给定的维度
num_problems = 9;  % 问题数量
num_algorithms = 4;  % 算法数量
num_runs = 24;  % 每个算法每个问题的运行次数

% 初始化按问题存储的 IGD_data 矩阵
IGD_data = zeros(num_runs, num_algorithms, num_problems);

% 循环读取每个问题的文件
for problem = 1:num_problems
    % 构造每个问题对应的 Excel 文件名
    file_name = sprintf('D:/experiment/DAS%d.xlsx', problem);
    
    % 从 Excel 文件中读取数据
    data_matrix = xlsread(file_name);
    
    % 假设 data_matrix 已经按算法列和运行行组织好了数据
    % 将数据分配到 IGD_data 的对应位置
    IGD_data(:, :, problem) = data_matrix;
end

% 计算平均 IGD 和标准误差
mean_IGD_data = mean(IGD_data, 1);  % 计算每个算法在所有问题上的平均 IGD，结果为 1 x num_algorithms x num_problems
std_error_data = std(IGD_data, 0, 1) / sqrt(num_runs);  % 计算每个算法在所有问题上的标准误差

% 算法颜色设置
colors = lines(num_algorithms);  % MATLAB 默认颜色序列

% 绘图
figure;
hold on;

% 循环绘制每个算法的平均 IGD 和置信区间
for alg = 1:num_algorithms
    % 绘制平均 IGD
    h_line = plot(1:num_problems, squeeze(mean_IGD_data(1, alg, :)), '-o', 'Color', colors(alg, :), 'MarkerSize', 5);
    
    % 使用 t 分布计算置信区间
    t_critical = tinv(0.975, num_runs - 1);  % 95% 置信水平，双侧
    error_range = squeeze(t_critical * std_error_data(1, alg, :));  % 置信区间
    
    % 绘制置信区间
    for i = 1:num_problems
        % 上下界
        line([i, i], [squeeze(mean_IGD_data(1, alg, i)) - error_range(i), squeeze(mean_IGD_data(1, alg, i)) + error_range(i)], ...
            'Color', colors(alg, :), 'LineWidth', 2);
        
        % 横线
        plot([i-0.1, i+0.1], [squeeze(mean_IGD_data(1, alg, i)) - error_range(i), squeeze(mean_IGD_data(1, alg, i)) - error_range(i)], ...
            'Color', colors(alg, :), 'LineWidth', 2);
        plot([i-0.1, i+0.1], [squeeze(mean_IGD_data(1, alg, i)) + error_range(i), squeeze(mean_IGD_data(1, alg, i)) + error_range(i)], ...
            'Color', colors(alg, :), 'LineWidth', 2);
    end
end

% 自定义图形属性
ylabel('IGD^+');
set(gca,'XTick',1:1:9);
set(gca,'XTickLabel',{'DASCMOP1','DASCMOP2','DASCMOP3','DASCMOP4','DASCMOP5','DASCMOP6','DASCMOP7','DASCMOP8','DASCMOP9'});

% set(gca,'XTick',1:1:14);
% set(gca,'XTickLabel',{'LIRCMOP1','LIRCMOP2','LIRCMOP3','LIRCMOP4','LIRCMOP5','LIRCMOP6','LIRCMOP7','LIRCMOP8','LIRCMOP9','LIRCMOP10','LIRCMOP11','LIRCMOP12','LIRCMOP13','LIRCMOP14'});
legend('SCDP^1', 'SCDP^2', 'SCDP^3', 'SCDP', 'Location', 'best');
grid on;
hold off;
