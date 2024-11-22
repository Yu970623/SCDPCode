classdef CCMO < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <constrained>
% Coevolutionary constrained multi-objective optimization framework
% type --- 1 --- Type of operator (1. GA 2. DE)

%------------------------------- Reference --------------------------------
% Y. Tian, T. Zhang, J. Xiao, X. Zhang, and Y. Jin, A coevolutionary
% framework for constrained multi-objective optimization problems, IEEE
% Transactions on Evolutionary Computation, 2021, 25(1): 102-116.
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
            %% Parameter setting
            type = Algorithm.ParameterSet(1);

            %% Generate random population
            Population1 = Problem.Initialization();
            Population2 = Problem.Initialization();
            Fitness1    = CalFitness(Population1.objs,Population1.cons);
            Fitness2    = CalFitness(Population2.objs);
            gen = [20,30,40,60,80,100,150,300,600,1000];
            k = 1;
            I = [];
            S = IGD(Population1,Problem.optimum);
            I = [I,S];
            %% Optimization
            while Algorithm.NotTerminated(Population1)
                if mod(Problem.FE,floor(Problem.maxFE/1000))==0
                    S = IGD( Population1,Problem.optimum);
                    I = [I,S];
                end
                if Problem.FE/Problem.N == gen(k) || Problem.FE > Problem.maxFE-2*Problem.N
                    pop_gen = gen(k); % 获取类名
                    pop = Population1.objs;
                    fileName1 = sprintf('D:\\experiment\\PlatEMO-EPDCMO\\Gen\\CCMO_LIR9_%d.mat', pop_gen);
                    save(fileName1, 'pop', '-V7.3'); % 保存第一个文件
                    k = k+1;
                end
                if type == 1
                    MatingPool1 = TournamentSelection(2,Problem.N,Fitness1);
                    MatingPool2 = TournamentSelection(2,Problem.N,Fitness2);
                    Offspring1  = OperatorGAhalf(Problem,Population1(MatingPool1));
                    Offspring2  = OperatorGAhalf(Problem,Population2(MatingPool2));
                elseif type == 2
                    MatingPool1 = TournamentSelection(2,2*Problem.N,Fitness1);
                    MatingPool2 = TournamentSelection(2,2*Problem.N,Fitness2);
                    Offspring1  = OperatorDE(Problem,Population1,Population1(MatingPool1(1:end/2)),Population1(MatingPool1(end/2+1:end)));
                    Offspring2  = OperatorDE(Problem,Population2,Population2(MatingPool2(1:end/2)),Population2(MatingPool2(end/2+1:end)));
                end
                [Population1,Fitness1] = EnvironmentalSelection([Population1,Offspring1,Offspring2],Problem.N,true);
                [Population2,Fitness2] = EnvironmentalSelection([Population2,Offspring1,Offspring2],Problem.N,false);
                if Problem.FE >= Problem.maxFE
                    Pop = Population1.objs();
                    Data = I;
                end
            end
        end
    end
end