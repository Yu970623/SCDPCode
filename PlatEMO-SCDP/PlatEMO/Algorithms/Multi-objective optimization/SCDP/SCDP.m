classdef SCDP< ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained>
% Multi-population coevolutionary constrained multi-objective optimization

%------------------------------- Reference --------------------------------
% J. Zou, R. Sun, Y. Liu, Y. Hu, S. Yang, J. Zheng, and K. Li, A
% multi-population evolutionary algorithm using new cooperative mechanism
% for solving multi-objective problems with multi-constraint, IEEE
% Transactions on Evolutionary Computation, 2023.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            Pop0 = Problem.Initialization();
            Fit0 = CalFitness(Pop0.objs);
            totalcon = size(Pop0(1,1).con,2);
            Obj0(1) = sum(sum(Pop0.objs,1));
            Pops = [];
            gen = 2;
            change_threshold = 1e-2;
            constant = 1;
%             color = [0,0,1;1,0,0;0,1,0;1,0,1;1,1,0;0,1,1;1,1,1;0.5,0.3,0.2;0.7,0.8,0.1;0.4,0.3,0.9;1,0.1,0.5;0.2,0.8,1;0.55,0.28,0.81;0.1,0.8,0.3;0.5,0.3,0.7];
            dw  = 0;
            Off = Pop0;
            index = 1;
            r = 1/Problem.N^(1/Problem.M);
            for i = 1:totalcon
                Pops{1,i} = Problem.Initialization();
                Pops{2,i} = CalFitness(Pops{1,i}.objs);  %适应度值
                Pops{3,i}(1) = sum(sum(Pops{1,i}.objs,1)); %整体目标函数值
                Pops{4,i} = i;  %序列
                Pops{5,i} = 0;  %是否完成收敛
                processedcon{index} = i;
                index = index+1;
                if dw
                    Pops{6,i} = [rand(1),rand(1),rand(1)];  %子种群颜色
                end
                Pops{7,i} = 1;  %是否休眠
                Off = [Off,Pops{1,i}];
            end
            processedcon{index} = totalcon+1;
            index = index+1;
            UPF = 0;
            reinit = 0;
            arch = [];
            [arch,Fit_arch] = EnvironmentalSelection([arch,Off],Problem.N,totalcon+1,totalcon,r);
            dUPF = 0;
            FE = 0;
            I = [];
            S = IGD( arch,Problem.optimum);
            I = [I,S];
            gene = [20,30,40,60,80,100,150,300,600,1000];
            k = 1;
            %% Optimization
            while Algorithm.NotTerminated(arch)
                S = IGD(arch,Problem.optimum);
                I = [I,S];
                Off = [];
                Offtemp = [];
                if Problem.FE/Problem.N >= gene(k) || Problem.FE >= Problem.maxFE-3*Problem.N
                    pop_gen = gene(k); % 获取类名
                    pop = arch.objs;
                    fileName1 = sprintf('D:\\experiment\\PlatEMO-EPDCMO\\Gen\\SCDP_LIR9_%d.mat', pop_gen);
                    save(fileName1, 'pop', '-V7.3'); % 保存第一个文件
                    k = k+1;
                end

                if contains( class(Problem),'RWMOP') || contains(class(Problem),'LIRCMOP') || contains(class(Problem),'DOC') || contains(class(Problem),'DASCMOP')
                    if ~UPF || ~dUPF   %第一阶段无约束收敛
                        MatingPool2 = TournamentSelection(2,Problem.N,Fit0);
                        Offtemp = OperatorDE(Problem,Pop0(1:end/2),Pop0(MatingPool2(1:end/2)),Pop0(MatingPool2(end/2+1:end))); %从  无约束种群  里面产生子代
                        Off = [Off,Offtemp];
                    elseif dUPF && reinit   %第二阶段，无约束种群仍有可行解
                        P = Pops;
                        MatingPool1 = TournamentSelection(2,Problem.N/2,Fit_arch);
                        MatingPool2 = TournamentSelection(2,Problem.N/2,Fit0);
                        Offtemp = OperatorDE(Problem,Pop0(1:end/2),Pop0(MatingPool2),arch(MatingPool1));  %从  无约束种群+主种群  里面产生子代
                        Off = [Off,Offtemp];
                    end
                    MatingPool1 = TournamentSelection(2,2*Problem.N,Fit_arch);
                    Offtemp = OperatorDE(Problem,arch,arch(MatingPool1(1:end/2)),arch(MatingPool1(end/2+1:end)));  %从  主种群  里面产生子代
                    Off = [Off,Offtemp];
                else   %别的测试套件
                    for i = 1:size(Pops,2)
                        if size(Pops,2) > 1 && ~Pops{7,i}
                            MatingPool = TournamentSelection(2,floor(Problem.N),Pops{2,i});
                            Offtemp  = OperatorGAhalf(Problem,Pops{1,i}(MatingPool));
                        end
                        Off = [Off,Offtemp];
                    end
                    if ~UPF || ~dUPF
                        MatingPool2 = TournamentSelection(2,Problem.N,Fit0);
                        Offtemp  = OperatorGAhalf(Problem,Pop0(MatingPool2));
                        Off = [Off,Offtemp];
                    elseif dUPF && reinit
                        P = Pops;
                        MatingPool1 = TournamentSelection(2,Problem.N/2,Fit_arch);
                        MatingPool2 = TournamentSelection(2,Problem.N/2,Fit0);
                        Offtemp  = OperatorGAhalf(Problem,[Pop0(MatingPool2),arch(MatingPool1)]);
                        Off = [Off,Offtemp];
                    end
                    MatingPool1 = TournamentSelection(2,Problem.N,Fit_arch);
                    Offtemp  = OperatorGA(Problem,arch(MatingPool1));
                    Off = [Off,Offtemp];
                end

                [arch,Fit_arch,~] = EnvironmentalSelection([Off,arch],Problem.N,totalcon+1,totalcon,r);  %更新主种群
                [Pop0,Fit0] = EnvironmentalSelection([Pop0,Off],Problem.N,0,totalcon,r);   %更新无约束种群
                
                [FrontNo,~] = NDSort(Pop0.objs,inf);
                FirstNo = Pop0(FrontNo == min(FrontNo));
                Obj0(gen) = sum(sum(abs(FirstNo.objs),1));  %检测无约束种群变化尺度
                if (dw && reinit) || (dw && ~dUPF)  %无约束种群仍在进化的话
                    Draw(Pop0.objs,'sk','Markeredgecolor',[.0 .9 .0],'Markerfacecolor',[.0 .9 .0]);
                else
                    P = Pops;
                end
                if size(Pops,2) > 1
                    for i = 1:size(Pops,2)
                        if dw
                            Draw(Pops{1,i}.objs,'o','Markeredgecolor','black','Markerfacecolor',Pops{6,i});  %绘制所有单约束种群
                        end
                        [Pops{1,i},Pops{2,i}] = EnvironmentalSelection([Pops{1,i},Off],Problem.N,Pops{4,i},totalcon,r);  %对所有单约束种群环境选择
                        Pops{3,i}(gen) = sum(sum(Pops{1,i}.objs,1));    %更新单约束种群目标函数值
                        if size(Pops,2) > 1
                            Pops{5,i} = is_stable(Pops{3,i},gen,Pops{1,i},Problem.N,change_threshold,constant,Problem.M,~Pops{7,i});    %判断是否完成收敛
                        else
                            Pops{5,i} = 1;
                        end
                        if Pops{5,i} && Pops{7,i}  %收敛过后，标记为已处理
                            Pops{7,i} = 0;
                            Pops{5,i} = 0;
                        end
                    end
                end
                
                if UPF == 0  %未收敛至无约束PF
                    UPF = is_stable(Obj0,gen,Pop0,Problem.N,change_threshold,constant,Problem.M,0);  %无约束种群第一次是否已收敛
                else
                    dUPF = is_stable(Obj0,gen,Pop0,Problem.N,change_threshold,constant,Problem.M,0);    %无约束种群第二次是否已收敛
                end
                if dUPF
                    
                    pop_cons = Pop0.cons;
                    cv = overall_cv(pop_cons);
                    FR = size(find(cv <= 0),1) / Problem.N;  %全部都是可行解
                    if FR  %无约束种群存在可行解
                        reinit = 1;  
                    else    %无约束种群不存在可行解
                        reinit = 0;
                    end
                end

                AllPops0 = [];
                for j = 1:size(Pops,2)
                    AllPops0 = [AllPops0,Pops{1,j}];
                end
                if UPF && dUPF  %完成了第二次收敛
                    
                    AllPops0 = [AllPops0,arch];  %合并归档集
                end
                [FrontNo,~] = NDSort(AllPops0.objs,inf);
                if UPF && dUPF  %完成最终的收敛
                    Maxindex = max(FrontNo(size(Pops,2)*Problem.N+1:end));
                    for j = 1:size(Pops,2)
                        if min(FrontNo((j-1)*Problem.N+1:j*Problem.N)) == Maxindex
                            Pops{5,j} = 1;   %标记非支配的约束
                        end
                    end
                end
                while i <= size(Pops,2)
                    if Pops{5,i}
                        Minindex = min(FrontNo((i-1)*Problem.N+1:i*Problem.N));
                        for j = 1:size(Pops,2)
                            if i ~= j
                                if max(FrontNo((j-1)*Problem.N+1:j*Problem.N))< Minindex
                                    Pops{5,j} = 2; %标记被非支配约束支配的约束
                                end
                            end
                        end
                    end
                    i = i+1;
                end
                merge_index = [];
                merge_pop = [];
                merge_con = [];
                for p = 1:size(Pops,2)
                    if Pops{5,p} == 1
                        conp =  Pops{1,p}.cons;
                        conp = max(0,conp(:,Pops{4,p}));
                        if size(find(conp <= 0),1)
                            merge_pop = [merge_pop,Pops{1,p}];
                            merge_index = [merge_index,p];
                            merge_con = [merge_con,Pops{4,p}];
                        else
                            Pops{1,p} = Problem.Initialization();
                            Pops{2,p} = CalFitness(Pops{1,p}.objs,Pops{1,p}.cons,Pops{4,p});
                        end
                    end
                end
                if size(merge_index,2) > 1
                    selected = merge_index(1);
                    Pops{4,selected} = merge_con;
                    [Pops{1,selected},Pops{2,selected}] = EnvironmentalSelection([AllPops0,arch],Problem.N,Pops{4,selected},totalcon,r);
                    Pops{5,selected} = 0;
                    Pops{3,selected}(gen) = sum(sum(Pops{1,selected}.objs,1));
                    Pops{7,selected} = 0;
                    Pops{8,selected} = index;
                    processedcon{index} = merge_con;
                    index = index+1;
                    k = size(Pops,2);
                    while k
                        if Pops{5,k} == 1 || Pops{5,k} == 2
                            Pops(:,k) = [];
                        end
                        k = k-1;
                    end
                end
                Problem.FE
                if size(Pops,2) == 1
                    [arch,Fit_arch] = EnvironmentalSelection([arch,Pops{1,1}],Problem.N,totalcon+1,totalcon,r);
                end
                gen = gen+1;
                if Problem.FE >= Problem.maxFE
                    Pop = arch.objs();
                    Data = I;
                end
            end
        end
    end
end

function result = overall_cv(cv)
    cv(cv <= 0) = 0;cv = abs(cv);
    result = sum(cv,2);
end

function result = is_stable(Objvalues,gen,Population,N,change_threshold,constant,M,isND)
    result = 0;
    if isND
        [FrontNo,~]=NDSort(Population.objs,size(Population.objs,1));
        NC=size(find(FrontNo==1),2);
    else
        NC =N;
    end
    max_change = abs(Objvalues(gen)-Objvalues(gen-1));

    if NC == N
        chth = change_threshold * abs((Objvalues(gen) )/( N* M))*10^(M-2);
        if max_change <= chth
            result = 1;
        end
    end
end