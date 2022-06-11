%GŁÓWNY RDZEŃ PROGRAMU
close all;
clc;
clear
tic

load_data;
rows = no_equations(Wiezy);

% T to tablica do zapisu kolejnych chwil
% Q to tablica do zapisu rozwiazan zadania o polozeniu w kolejnych chwilach
% DQ to tablica do zapisu rozwiazan zadania o predkosci w kolejnych chwilach
% D2Q to tablica do zapisu rozwiazan zadania o przyspieszeniu w kolejnych chwilach

tstart = 0;
tstop = 1;
timestep = 0.001; % Paramtery czasu całkowania
timespan = tstart:timestep:tstop;

M = MacierzMasowa(Bezwladnosci, ilosc_cial);

q0 = reshape(q(1:length(q)-1,1:3)',[3*(length(q)-1),1]);
qdot0 = zeros(size(q0)); % Początkowe prędkości


disp("INFO: Rozpoczeto obliczenia");
Y0 = [q0; qdot0]; % Wektor, który będzie całkowany
OPTIONS = odeset('RelTol', 1e-6, 'AbsTol', 1e-9);
[T,Y]=ode45(@(t,Y) diff_eq(t,Y,Wiezy,rows,M, ilosc_cial, Bezwladnosci, ilosc_sprezyn, Sprezyny, ilosc_sil, Sily),timespan,Y0,OPTIONS);


koniec = num2str(toc);
dispp = ['Czas trwania obliczen: ', koniec];
disp('INFO: Pomyslnie wykonano obliczenia')
disp(dispp)

Y = Y';    
    
timepoints = 1:(length(T));
Ydot = zeros(size(Y));
for i=timepoints
	Ydot(:,i) = diff_eq( T(i), Y(:,i), Wiezy,rows,M, ilosc_cial, Bezwladnosci, ilosc_sprezyn, Sprezyny, ilosc_sil, Sily );
end

%Wektor położeń:
Q = [Y( 1:3*ilosc_cial , : )];

%Wektor predkosci
DQ = [Y( 3*ilosc_cial+1:6*ilosc_cial , : )];

%Wektor przyspieszen
D2Q = [Ydot( 3*ilosc_cial+1:6*ilosc_cial , : )];


%Wskazanie czlonu, dla ktorego wyznaczone zostaną predkosci i przyspieszenia katowe 
body_number = 10;
Point = 'H';

plot(T,180/pi*D2Q(24,:))

sz = size(Q);
q_new = zeros(2,sz(2));
dq_new = zeros(2,sz(2));
ddq_new = zeros(2,sz(2));
for i=1:sz(2)
    tmp = [(reshape(Q(:,i),[3,10]))',(reshape(DQ(:,i),[3,10]))',(reshape(D2Q(:,i),[3,10]))'];
    [pq,pdq,pddq] = TrackPoint(tmp,Wiezy,Point);
    q_new(:,i) = pq';
    dq_new(:,i) = pdq';
    ddq_new(:,i) = pddq';
end

figure
plot(T(:,1),q_new(1,:));
grid on
legend("x");
title("Polożenie x");
xlabel("Czas [s]")
ylabel("x[m]")

figure
plot(T(:,1),q_new(2,:));
grid on
legend("y");
title("Polożenie y");
xlabel("Czas [s]")
ylabel("y[m]")

figure
plot(T(:,1),dq_new(1,:));
grid on
legend("vx");
title("Predkosc x");
xlabel("Czas [s]")
ylabel("vx[m]")

figure
plot(T(:,1),dq_new(2,:));
grid on
legend("vy");
title("Polożenie y");
xlabel("Czas [s]")
ylabel("cy[m]")

figure
plot(T(:,1),ddq_new(1,:));
grid on
legend("ax");
title("Przyspieszenie x");
xlabel("Czas [s]")
ylabel("ax[m]")

figure
plot(T(:,1),ddq_new(2,:));
grid on
legend("ay");
title("Przyspieszenie y");
xlabel("Czas [s]")
ylabel("ay[m]")








    