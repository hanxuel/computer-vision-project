function[w_x w_y E] = tps_model(X,Y,lambda)
%points in the template shape,X
%corresponding points in the target shape,Y
%regularization parameter,lambda
N=size(X,1);
for i=1:1:N
    for j=1:1:i
        K(i,j)=U(norm(X(i,:)-X(j,:)));
        K(j,i)=K(i,j);
    end
end
P=[ones(N,1) X];
A=[K+eye(N)*lambda P;P' zeros(3)];
x=[Y(:,1);zeros(3,1)];
y=[Y(:,2);zeros(3,1)];
w_x=A\x;
w_y=A\y;
E=w_x(1:end-3)'*K*w_x(1:end-3) + w_y(1:end-3)'*K*w_y(1:end-3);

end
function u=U(x)
    if x == 0
        u = 0;
    else
        u = x.^2.*log(x.^2);
    end
end