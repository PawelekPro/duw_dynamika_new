function q=NewtonRaphson(q0,t, Wiezy, rows)
% q=NewRaph(q0,t)
%   Rozwiązanie układu równań metodą Newtona-Raphsona.
% Wejście:
%   q0 - przybliżenie startowe,
%   t - chwila, dla której poszukiwane jest rozwiązanie.
% Wyjście:
%   q - uzyskane rozwiązanie.
%
% Układ równań musi być wpisany w pliku Wiezy.m.
% Macierz Jacobiego układu równań musi być wpisana w pliku Jakobian.m.
%
%*************************************************************
%   Program stanowi załącznik do książki:
%   Frączek J., Wojtyra M.: Kinematyka układów wieloczłonowych.
%                           Metody obliczeniowe. WNT 2007.
%   Wersja 1.0
%*************************************************************

q=q0;

F=Fi(q,t, Wiezy, rows);
iter=1; % Licznik iteracji
while ( (norm(F)>epsilon()) && (iter < 200) )
    F=Fi(q,t, Wiezy, rows);
    Fq=MacierzJacobiego(q,t,Wiezy,rows);
    q=q-Fq\F;  % Fq\F jest równoważne inv(Fq)*F, ale mniej kosztowne numerycznie
    iter=iter+1;
end
if iter >= 200
    error('BŁĄD: Po 200 iteracjach Newtona-Raphsona nie uzyskano zbieżności ');
    norm(F)
    q=q0;
end

