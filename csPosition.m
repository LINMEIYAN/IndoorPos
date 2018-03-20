function csRe = csPosition(coaRe,X_train_mean,X_train_var,Y_train,X_test,Y_test)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
fineRe = coaRe;
FPindex = 1:size(X_train_mean,1);
RPindex = 1:size(X_train_mean,2);
% X_train_mean = X_train_mean(FP_index,:);
% X_train_var  = X_train_var(FP_index,:);
% X_test = X_test(FP_index,:);
for i = 1:size(X_test,2)
%     RPindex = RPselect(coaRe(4).pos(:,i),Y_train);
%      FPindex = FPselect(X_train_mean(:,RPindex),X_train_var(:,RPindex));
%     FPindex = 1:200;
    [T,Q] = preOrth(X_train_mean(FPindex,RPindex));
    zM = T * X_test(FPindex,i);
    alpha = CS_SAMP(zM,Q,4);
    [alpha,index] = sort(alpha,'descend') ;
    for j = 1:8
        a = alpha(1:j);
        b = RPindex(index(1:j));
        posProb = a/sum(a);
        posResult = bsxfun(@times,Y_train(:,b),posProb');
        posResult = sum(posResult,2);
        fineRe(j).pos(:,i) = posResult;
        fineRe(j).err(i) = norm(posResult - Y_test(:,i));
    end    
end
csRe = fineRe;
end
%% ���ݴֶ�λ���ȷ������λ����ο���
function RPindex = RPselect(coaPos,Y_train)
dist = bsxfun(@minus,coaPos,Y_train);
dist = dist.^2;
dist = sqrt(sum(dist));
RPindex = find(dist<5);
end
%% ���ݲο���ȷ������λ��λ����Ƶ��
function FPindex = FPselect(X_train_mean,X_train_var)
signalMean = mean(X_train_mean,2);
foundSignal = find(signalMean>-85);
FP = var(X_train_mean(foundSignal,:),0,2);%./var(X_train_var(foundSignal,:),0,2);
[~,FPindex] = maxk(FP,50);
FPindex = foundSignal(FPindex);
end
%% Ԥ������
function [T , Q ] = preOrth(Xn)
R = eye(size(Xn,1))*Xn;
Q = orth(R')';
T = Q*pinv(R);
end