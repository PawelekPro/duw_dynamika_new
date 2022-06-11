%GŁÓWNY RDZEŃ PROGRAMU
close all;
clc;
clear

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
timestep = 0.001; % Paramtery czasu całkowania
timespan = tstart:timestep:tstop;

M = MacierzMasowa(Bezwladnosci, ilosc_cial);

q0 = reshape(q(1:length(q)-1,1:3)',[3*(length(q)-1),1]);
qdot0 = zeros(size(q0)); % Początkowe prędkości


disp("INFO: Rozpoczeto obliczenia");
Y0 = [q0; qdot0]; % Wektor, który będzie całkowany
OPTIONS = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[T,Y]=ode45(@(t,Y) RHS(t,Y,Wiezy,rows,M, ilosc_cial, Bezwladnosci, ilosc_sprezyn, Sprezyny, ilosc_sil, Sily),timespan,Y0,OPTIONS);


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

plot(T,180/pi*D2Q(30,:))








    