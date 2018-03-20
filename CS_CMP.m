function [theta] = CS_CMP(y,A)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
[y_rows,y_columns] = size(y);
if y_rows<y_columns
    y = y';%y should be a column vector
end
[M,N] = size(A);%���о���AΪM*N����
theta = zeros(N,1);%�����洢�ָ���theta(������)
r_n = y;%��ʼ���в�(residual)Ϊy
temp = (A*A')^(-1);
f = @ (x) (x'*temp*x).^(-0.5);
for ii = 1:N
    diagEle(ii) = f(A(:,ii));
end
delta = diag(diagEle);
while norm(r_n)>1e-1
    g = delta*A'*temp*r_n;
    [~,pos] = max(abs(g));
    c = delta(pos,pos)*g(pos);
    theta(pos) = theta(pos) + c;
    r_n = y - A*theta;
end

