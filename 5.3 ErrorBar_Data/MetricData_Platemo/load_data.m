for k = 1:14
    X = [];
    for D = 1:4
        A = [];
        for i = k
            for j = 1:24
                s1 = 'D:\experiment\SCDP_Code\ErrorBar_Data\MetricData_Platemo';
                if D == 1
                    s2 = 'SCDP';
                elseif D == 2
                    s2 = 'SCDP2';
                elseif D == 3
                    s2 = 'SCDP3';
                elseif D == 4
                    s2 = 'SCDP4';
                end
                s3 = '_LIRCMOP';
                s4 = num2str(i);
                s5 = '_';
                s6 = num2str(j);
                s7 = '.mat';
                s8 = [s1 s2 s3 s4 s5 s6 s7];
                B = load(s8);
                C = B.metric.IGD_plus;
                A = [A C];
            end
        end
        A = A'
        X = [X A];
    end
    ss = 'LIR';
    ss2 = num2str(k);
    sss = '.xlsx'
    ss3 = [ss ss2 sss]
    xlswrite(ss3,X);
end

