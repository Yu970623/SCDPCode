classdef CTAEA < ALGORITHM
% <multi/many> <real/integer/label/binary/permutation> <constrained>
% Two-archive evolutionary algorithm for constrained MOPs

%------------------------------- Reference --------------------------------
% K. Li, R. Chen, G. Fu, and X. Yao, Two-archive evolutionary algorithm for
% constrained multi-objective optimization, IEEE Transactions on
% Evolutionary Computation, 2018, 23(2): 303-315.
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
            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);

            %% Generate random population
            Population = Problem.Initialization();
            CA = UpdateCA([],Population,W);
            DA = UpdateDA(CA,[],Population,W);
            gen = [20,30,40,60,80,100,150,300,600,1000];
            k = 1;
            I = [];
            S = IGD(CA,Problem.optimum);
            I = [I,S];
            %% Optimization
            while Algorithm.NotTerminated(CA)
                if mod(Problem.FE,floor(Problem.maxFE/1000))==0
                    S = IGD( CA,Problem.optimum);
                    I = [I,S];
                end
                if Problem.FE/Problem.N == gen(k) || Problem.FE > Problem.maxFE-2*Problem.N
                    pop_gen = gen(k); % 获取类名
                    pop = CA.objs;
                    fileName1 = sprintf('D:\\experiment\\PlatEMO-EPDCMO\\Gen\\CTAEA_LIR9_%d.mat', pop_gen);
                    save(fileName1, 'pop', '-V7.3'); % 保存第一个文件
                    k = k+1;
                end
                %% mating pool choosing
                % calculate the ratio of non-dominated solutions of CA and DA in Hm
                Hm = [CA,DA];                         
                [FrontNo,~] = NDSort(Hm.objs,inf);
                FrontNo_C   = FrontNo(1:ceil(length(Hm)/2));
                Nc = size(find(FrontNo_C==1),2);      
                Pc = Nc/length(Hm);
                FrontNo_D = FrontNo(ceil(length(Hm)/2)+1:length(Hm));
                Nd = size(find(FrontNo_D==1),2);      
                Pd = Nd/length(Hm);

                % calculate the proportion of non-dominated solutions in CA
                [FrontNo,~] = NDSort(CA.objs,inf);
                NC = size(find(FrontNo==1),2);         
                PC = NC/length(CA);                     % PC denotes the proportion of non-dominated solutions in CA,it is different from Pc

                %reproduction
                Q = [];
                for i = 1 : size(W,1)
                    if Pc > Pd
                        P1 = MatingSelection(CA); 
                    else
                        P1 = MatingSelection(DA);
                    end
                    pf = rand();
                    if pf < PC
                        P2 = MatingSelection(CA);
                    else
                        P2 = MatingSelection(DA);
                    end
                    MatingPool = [P1,P2];
                    Offspring  = OperatorGAhalf(Problem,MatingPool);
                    Q = [Q,Offspring];
                end
                if Problem.FE >= Problem.maxFE
                    Pop = CA.objs();
                    Data = I;
                end
               %% update CA and DA
                CA = UpdateCA(CA,Q,W);
                DA = UpdateDA(CA,DA,Q,W);
            end
        end
    end
end