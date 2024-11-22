function CV = FDVOperator_CV(CV,i)
% Step=[0 0.6 0.8 0.8];
%normalization
if i==0%stage 1 ºöÊÓÔ¼Êø
    [m,n]=size(CV);
    CV=zeros(m,n);
else
%     lower    %     upper
    v_min=min(CV);%min(min(CV));
    v_max=max(CV);%max(max(CV));
    v_t=(CV-v_min)./(v_max-v_min+1e-8); %v_t=[0,1]
    
    lower=0;%min(v_t);%fuzzy  v_t
    upper=1;%max(v_t);
    R=upper-lower;
    gamma_a = R*10^-i.*floor(10^i*R.^-1.*(v_t-lower)) + lower;
    gamma_b = R*10^-i.*ceil(10^i*R.^-1.*(v_t-lower)) + lower;
    miu1    = 1./(v_t-gamma_a);
    miu2    = 1./(gamma_b-v_t);
    logical = miu1-miu2>0;
    CV  = gamma_b;%CV
    CV(find(logical)) = gamma_a(find(logical));%CV
    
end

end