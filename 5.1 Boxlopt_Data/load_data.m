    k = 9;
    X = [];
    for D = 1:8
        A = [];
        for i = k
            for j = 1:20
                s1 = 'D:\experiment\SCDP_Code\Boxlopt_Data\MetricData_Platemo\';
                if D == 1
                    s2 = 'NSGAII';
                elseif D == 2
                    s2 = 'CMOEA_MS';
                elseif D == 3
                    s2 = 'CTAEA';
                elseif D == 4
                    s2 = 'CCMO';
                elseif D == 5
                    s2 = 'C3M';
                elseif D == 6
                    s2 = 'URCMO';
                elseif D == 7
                    s2 = 'MOEADLCDP';
                elseif D == 8
                    s2 = 'SCDP';
                end
                s3 = '_LIRCMOP';
                s4 = num2str(i);
                s5 = '_';
                s6 = num2str(j);
                s7 = '.mat';
                s8 = [s1 s2 s3 s4 s5 s6 s7];
                B = load(s8);
                C = B.metric.IGDp;
%                 C = -C;
                A = [A C];
            end
        end
        A = A'
        X = [X A];
    end
    ss = 'IGDp_LIR';
    ss2 = num2str(k);
    sss = '.xlsx'
    ss3 = [ss ss2 sss]
    xlswrite(ss3,X);


results =  xlsread('D:\experiment\SCDP_Code\Boxlopt_Data\HV_DC2_DTLZ_M10.xlsx','Sheet1');
Names = {'NSGA-II','CMOEA_MS','CTAEA','CCMO','C3M','URCMO','MOEADLCDP','SCDP'};
boxplot(results,Names)
ylim([0,0.15]);


