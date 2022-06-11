clear all;
global epsilon
epsilon= 1e-6;
global grav
grav= 9.80665;
% Dane z polecenia
alpha = 315;
P = 500;

%wczytywanie współrzędnych punktów z polecenia
A = [0; 0];
B = [0.3; 0];
D = [0.2; 0.6];
E = [-0.1; 0.7];
F = [-0.2; 0.8];
G = [0; 1.2];
H = [0.5; 0.8];
I = [0.5; -0.1];
J = [0.7; 0.3];
K = [0.8; 0.6];
L = [1; -0.5];
M = [1.3; -0.3];
N = [1.3; 0];

%wczytywanie współrzędnych środków ciężkości z polecenia
c1 = [0; 0.85];
c2 = [0.4; 0.75];
c3 = [0.15; 0.45];
c4 = [0.05; 0.15];
c5 = [0.45; 0.6];
c6 = [0.35; 0.2];
c7 = [0.4; 0.1];
c8 = [0.65; 0.25];
c9 = [1.05; 0.3];
c10 = [1.2; -0.25];

q(1,:) = [c1; 0];
q(2,:) = [c2; 0];
q(3,:) = [c3; 0];
q(4,:) = [c4; 0];
q(5,:) = [c5; 0];
q(6,:) = [c6; 0];
q(7,:) = [c7; 0];
q(8,:) = [c8; 0];
q(9,:) = [c9; 0];
q(10,:) = [c10; 0];
q(11,:) = [0; 0; 0];
q = [q, zeros(size(q,1),6)];

% macierz Omega
omega = [0 -1; 1 0];

%deklaracja struktury
Wiezy = struct('typ',{},...
    'klasa',{},... % jak to para? para postepowa czy obrotowa 
    'bodyi',{},... %  nr pierwszego ciala
    'bodyj',{},... % nr drugiego ciala
    'sA',{},... % wektor sA w i-tym ukladzie (cialo i)
    'sB',{},... % wektor sB w j-tym ukladzie (cialo j)
    'phi0',{},... % kat phi0 (gdy pary postepowa)
    'perp',{},... % wersor prostopadly do osi ruchu w ukladzie j-tym (gdy pary postepowa)
    'fodt',{},... % funkcja od czasu dla wiezow dopisanych
    'dotfodt',{},... % pochodna funkcji od czasu dla wiezow dopisanych
    'ddotfodt',{},... % druga pochodna funkcji od czasu dla wiezow dopisanych
    'point_name',{});

ilosc_cial = 10;
ilosc_sprezyn = 2;
ilosc_sil = 1;

%przypisanie wszystkich rodzajów więzów do elementów struktury
Wiezy(1)=cell2struct({'kinematyczny', 'obrotowy', 0, 1, E, E-c1, [], [], [], [], [],'E'}',fieldnames(Wiezy));
Wiezy(2)=cell2struct({'kinematyczny', 'obrotowy', 0, 4, A, A-c4, [], [], [], [], [],'A'}',fieldnames(Wiezy));
Wiezy(3)=cell2struct({'kinematyczny', 'obrotowy', 0, 6,  B, B-c6, [], [], [], [], [],'B'}',fieldnames(Wiezy));
Wiezy(4)=cell2struct({'kinematyczny', 'obrotowy', 1, 2, G-c1, G-c2, [], [], [], [], [],'G'}',fieldnames(Wiezy));
Wiezy(5)=cell2struct({'kinematyczny', 'obrotowy', 1, 3, D-c1, D-c3, [], [], [], [], [],'D'}',fieldnames(Wiezy));
Wiezy(6)=cell2struct({'kinematyczny', 'obrotowy', 1, 7,  F-c1, F-c7, [], [], [], [], [],'F'}',fieldnames(Wiezy));
Wiezy(7)=cell2struct({'kinematyczny', 'obrotowy', 2, 8, J-c2, J-c8, [], [], [], [], [],'J'}',fieldnames(Wiezy));
Wiezy(8)=cell2struct({'kinematyczny', 'obrotowy', 2, 5,  H-c2, H-c5, [], [], [], [], [],'H'}',fieldnames(Wiezy));
Wiezy(9)=cell2struct({'kinematyczny', 'obrotowy', 7, 8, I-c7, I-c8, [], [], [], [], [], 'I'}',fieldnames(Wiezy));
Wiezy(10)=cell2struct({'kinematyczny', 'obrotowy', 7, 10, L-c7, L-c10, [], [], [], [], [], 'L'}',fieldnames(Wiezy));
Wiezy(11)=cell2struct({'kinematyczny', 'obrotowy', 8, 9, K-c8, K-c9, [], [], [], [], [], 'K'}',fieldnames(Wiezy));
Wiezy(12)=cell2struct({'kinematyczny', 'obrotowy', 9, 10,  N-c9, N-c10, [], [], [], [], [], 'N'}',fieldnames(Wiezy));
Wiezy(13)=cell2struct({'kinematyczny', 'postepowy', 3, 4,  [-0.15;-0.45], [0.15;0.45], 0, omega*((D-A)/norm(D-A)), 0,0,0,'N'}',fieldnames(Wiezy));
Wiezy(14)=cell2struct({'kinematyczny', 'postepowy', 5, 6, [-0.15;-0.6], [0.15;0.6], 0, omega*((H-B)/norm(H-B)),0, 0,0,'N'}',fieldnames(Wiezy));


Bezwladnosci = struct('m',{},... % masa członu (m)
    'Iz',{}); % moment bezwładności członu względem osi z (I_z)

Sily = struct('F',{}...     % Wartość siły [N]
    ,'bodyi',{}...            % Numer części do której jest przyłożona siła/moment
    ,'sA',{});  

Sprezyny = struct('k',{},... % sztywnosc sprezyny
    'c',{},... % tlumienie w sprezynie
    'bodyi',{},... % numer pierwszego ciala przylozenia sprezyny
    'bodyj',{},... % numer drugiego ciala przylozenia sprezyny
    'sA',{},... % punkt przylozenia sprezyny do ciala i w i-tym ukladzie lokalnym
    'sB',{},... % punkt przylozenia sprezyny do ciala j w j-tym ukladzie lokalnym
    'd0',{}); % dlugosc swobodna sprezyny

Bezwladnosci(1) = cell2struct({22, 0.7}', fieldnames(Bezwladnosci));
Bezwladnosci(2) = cell2struct({21, 1.6}', fieldnames(Bezwladnosci));
Bezwladnosci(3) = cell2struct({2, 0.1}', fieldnames(Bezwladnosci));
Bezwladnosci(4) = cell2struct({2, 0.1}', fieldnames(Bezwladnosci));
Bezwladnosci(5) = cell2struct({3, 0.2}', fieldnames(Bezwladnosci));
Bezwladnosci(6) = cell2struct({3, 0.2}', fieldnames(Bezwladnosci));
Bezwladnosci(7) = cell2struct({25, 5}', fieldnames(Bezwladnosci));
Bezwladnosci(8) = cell2struct({7, 0.4}', fieldnames(Bezwladnosci));
Bezwladnosci(9) = cell2struct({5, 0.3}', fieldnames(Bezwladnosci));
Bezwladnosci(10) = cell2struct({11, 0.3}', fieldnames(Bezwladnosci));


Sily(1) = cell2struct({500*[cosd(315); sind(315)], 10, [0.1; -0.05]}', fieldnames(Sily));


Sprezyny(1) = cell2struct({10000, 500, 4, 3, [0; 0]-[0.05; 0.15], [0.2; 0.6]-[0.15; 0.45], norm([0.2, 0.6])}', fieldnames(Sprezyny));
Sprezyny(2) = cell2struct({14000, 600, 6, 5, [0.3; 0]-[0.35; 0.2], [0.5; 0.8]-[0.45; 0.6], norm([0.2, 0.8])}', fieldnames(Sprezyny));















