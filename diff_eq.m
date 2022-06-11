function [Ydot] = diff_eq(t,Y,Wiezy,rows,M, NoB, Bezwladnosci, NoS, Sprezyny, NoF, Sily)
%RHS Wektor prawych stron w równaniu liniowym dynamiki

alpha = 10;
beta = 10;

% Pierwsza połowa wektora Y to położenia, druga połowa to prędkości
middle = uint16(length(Y)/2);

q = Y(1:middle,1);
qdot = Y((middle+1):(2*middle),1);

% Odpowiednie macierze są wyznaczane przez funkcje:
% Macierz masowa -> [ M ] = MacierzMasowa( Bezwladnosci, NoB )
% Macierz Jacobiego -> [ Jacob ] = MacierzJacobiego( q, t, Wiezy, rows )
% Wektor sił uogólnionych -> [ Q ] = SilyUogolnione( NoB, Bezwladnosci, NoS, Sprezyny, NoF, Sily, q, qdot )
% Wektor Gamma -> [ Gamma ] = WektorGamma( q, qdot, t, Wiezy, rows )
% Wektor równan więzów -> [ Phi ] = WektorPhi( q, t, Wiezy, rows )

F = WektorPhi(q,t,Wiezy,rows);
Fdot = MacierzJacobiego(q,t,Wiezy,rows)*qdot;

Jacob = MacierzJacobiego( q, t, Wiezy, rows );
A = [M, Jacob'; Jacob, zeros(rows)];
b = [SilyUogolnione( NoB, Bezwladnosci, NoS, Sprezyny, NoF, Sily, q, qdot );...
    Gamma( q, qdot, t, Wiezy, rows ) - 2*alpha*Fdot - beta*beta*F];

x = A\b;

Ydot(1:middle,1) = qdot;
Ydot((middle+1):(2*middle),1) = x(1:middle,1);

end

