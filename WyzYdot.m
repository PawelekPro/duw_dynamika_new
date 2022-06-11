function [Ydot] = WyzYdot(t,Y,Wiezy,rows,M, NB, Bezwladnosci, NS, Sprezyny, NF, Sily)


a = 10;
b = 10;

% Pierwsza po³owa wektora Y to po³o¿enia, druga po³owa to prêdkoœci
pol= length(Y)/2;

q = Y(1:pol,1);
qdot = Y((pol+1):(2*pol),1);


F = WektorPhi(q,t,Wiezy,rows);
Fdot = MacierzJacobiego(q,t,Wiezy,rows)*qdot;

Jacob = MacierzJacobiego( q, t, Wiezy, rows );
A = [M, Jacob'; Jacob, zeros(rows)];
b = [MacierzSil( NB, Bezwladnosci, NS, Sprezyny, NF, Sily, q, qdot );...
    WektorGamma( q, qdot, t, Wiezy, rows ) - 2*a*Fdot - b*b*F];

x = A\b;  %Uk³ad równañ wyk³ad 3.58

Ydot(1:pol,1) = qdot;
Ydot((pol+1):(2*pol),1) = x(1:pol,1);

end

