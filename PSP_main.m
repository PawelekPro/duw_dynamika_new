% glowny program - rozwiazuje zadania kinematyki o polozeniu, predkosci i przyspieszeniu 
% struktura do przechowywania wiezow 
% Wiezy = struct('typ',{},...
%     'klasa',{},... % jak to para? para postepowa czy obrotowa 
%     'bodyi',{},... %  nr pierwszego ciala
%     'bodyj',{},... % nr drugiego ciala
%     'sA',{},... % wektor sA w i-tym ukladzie (cialo i)
%     'sB',{},... % wektor sB w j-tym ukladzie (cialo j)
%     'phi0',{},... % kat phi0 (gdy pary postepowa)
%     'perp',{},... % wersor prostopadly do osi ruchu w ukladzie j-tym (gdy pary postepowa)
%     'fodt',{},... % funkcja od czasu dla wiezow dopisanych
%     'dotfodt',{},... % pochodna funkcji od czasu dla wiezow dopisanych
%     'ddotfodt',{}); % druga pochodna funkcji od czasu dla wiezow
%     dopisanych
close all;clc;clear
pobierz_dane;
% zmienna do wyznaczania liczby rownan wiezow 
rows = 0;
tic

for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ) == "dopisany")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            rows = rows + 1;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            rows = rows + 1;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    elseif(lower(Wiezy(l).typ) == "kinematyczny")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            rows = rows + 2;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            rows = rows + 2;
        else
            error(['Blad: zle podana klasa wiezu nr', num2str(l)]);
        end
    else
        error(['Blad: zle podana typ wiezu nr', num2str(l)]);
    end
end


% T to tablica do zapisu kolejnych chwil
% Q to tablica do zapisu rozwiazan zadania o polozeniu w kolejnych chwilach
% DQ to tablica do zapisu rozwiazan zadania o predkosci w kolejnych chwilach
% D2Q to tablica do zapisu rozwiazan zadania o przyspieszeniu w kolejnych chwilach

tstart = 0;
tstop = 5;
timestep = 0.005; % Paramtery czasu całkowania
timespan = tstart:timestep:tstop;

M = MacierzMasowa(Bezwladnosci, ilosc_cial);

q0=zeros(3*length(srodki_ciezkosci),1);
for i=0:length(srodki_ciezkosci)-1
   q0(1+i*3)= srodki_ciezkosci(i+1,1);
   q0(2+i*3)= srodki_ciezkosci(i+1,2);
   q0(3+i*3)= 0;
end
qdot0 = zeros(size(q0)); % Początkowe prędkości

Y0 = [q0; qdot0]; % Wektor, który będzie całkowany

disp("INFO: Rozpoczeto obliczenia");

OPTIONS = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[T,Y]=ode45(@(t,Y) RHS(t,Y,Wiezy,rows,M, ilosc_cial, Bezwladnosci, ilosc_sprezyn, Sprezyny, ilosc_sil, Sily),timespan,Y0,OPTIONS);
    % Ponieważ macierz bezwładności nie zmienia się w czasie, więc aby nie
    % obliczać jej za każdym razem od nowa, jest po prostu przekazywana
    % jako argument funkcji całkowanej

koniec = num2str(toc);
dispp = ['Czas trwania obliczen: ', koniec];
disp('INFO: Pomyslnie wykonano obliczenia')
disp(dispp)

Y = Y';    
    
timepoints = 1:( length(T) );
Ydot = zeros(size(Y));
for iter=timepoints
	Ydot(:,iter) = RHS( T(iter), Y(:,iter), Wiezy,rows,M, ilosc_cial, Bezwladnosci, ilosc_sprezyn, Sprezyny, ilosc_sil, Sily );
end

%Wektor położeń:
Q = [ Y( 1:3*ilosc_cial , : )];

%Wektor predkosci
DQ = [ Y( 3*ilosc_cial+1:6*ilosc_cial , : )];

%Wektor przyspieszen
D2Q = [ Ydot( 3*ilosc_cial+1:6*ilosc_cial , : )];








    