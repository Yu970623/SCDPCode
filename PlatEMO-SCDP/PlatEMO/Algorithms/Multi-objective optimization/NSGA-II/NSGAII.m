classdef NSGAII < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained/none>
% Nondominated sorting genetic algorithm II

%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
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
            %% Generate random population
            Population = Problem.Initialization();
            [~,FrontNo,CrowdDis] = EnvironmentalSelection(Population,Problem.N);
            gen = [20,30,40,60,80,100,150,300,600,1000];
            k = 1;
            I = [];
            S = IGD(Population,Problem.optimum);
            I = [I,S];
            %% Optimization
            while Algorithm.NotTerminated(Population)
                if mod(Problem.FE,floor(Problem.maxFE/1000))==0
                    S = IGD( Population,Problem.optimum);
                    I = [I,S];
                end
                if Problem.FE/Problem.N == gen(k) || Problem.FE > Problem.maxFE-2*Problem.N
                    pop_gen = gen(k); % 获取类名
                    pop = Population.objs;
                    fileName1 = sprintf('D:\\experiment\\PlatEMO-EPDCMO\\Gen\\NSGAII_DAS3_%d.mat', pop_gen);
                    save(fileName1, 'pop', '-V7.3'); % 保存第一个文件
                    k = k+1;
                end
                if Problem.FE >= Problem.maxFE-Problem.N
                    fileName2 = sprintf('D:\\experiment\\PlatEMO-EPDCMO\\Cov\\NSGAII_DAS3_cov.mat');
                    save(fileName2, 'I', '-V7.3'); % 保存第一个文件  
                end
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
                Offspring  = OperatorGA(Problem,Population(MatingPool));
                [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);
            end
        end
    end
end