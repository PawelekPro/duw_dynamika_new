%% Postprocessor - wyswietla animacje ukłądu - w założeniu dowolneg ukłądu płaskiego
wektory_do_sc=zeros(ilosc_pktow,2);
for i=1:ilosc_pktow
    if(ktore_cialo(i)~=0)
        wektory_do_sc(i,:)=punkty(i,:)-srodki_ciezkosci(ktore_cialo(i),:);
    else
        wektory_do_sc(i,:)=punkty(i,:)-[0 0];
    end
end
nowe_punkty=zeros(2*ilosc_pktow,length(Q));
Omega=[0 -1;1 0];
nowe_predkosci=zeros(2*ilosc_pktow,length(Q));
nowe_przyspieszenia=zeros(2*ilosc_pktow,length(Q));
for i=0:ilosc_pktow-1
    for j=1:length(Q)
    if ktore_cialo(i+1)~=0 %jezeli punkt jest na ciele innym niz utwierdzenie to zmienia swoja pozycje
        R=RotMat(Q(3*ktore_cialo(i+1),j));
        nowe_punkty(2*i+1:2*i+2,j)=R*wektory_do_sc(i+1,:)'+[Q(3*ktore_cialo(i+1)-2,j),Q(3*ktore_cialo(i+1)-1,j)]';
        nowe_predkosci(2*i+1:2*i+2,j)=Omega*R*DQ(3*ktore_cialo(i+1),j)*wektory_do_sc(i+1,:)'+[DQ(3*ktore_cialo(i+1)-2,j),DQ(3*ktore_cialo(i+1)-1,j)]';
        nowe_przyspieszenia(2*i+1:2*i+2,j)=-eye(2)*R*(DQ(3*ktore_cialo(i+1),j))^2*wektory_do_sc(i+1,:)'+Omega*R*D2Q(3*ktore_cialo(i+1),j)*wektory_do_sc(i+1,:)'+[D2Q(3*ktore_cialo(i+1)-2,j),D2Q(3*ktore_cialo(i+1)-1,j)]';
    else %jesli jest na utwierdzeniu to nie zmienia
        nowe_punkty(2*i+1:2*i+2,j)=punkty(i+1,:);
    end
    end
end
% for i=0:ilosc_pktow-1
%     if ktore_cialo(i+1)~=0 %jezeli punkt jest na ciele innym niz utwierdzenie to zmienia swoja pozycje
%         nowe_punkty(2*i+2,:)=wektory_do_sc(i+1,2)+Q(3*ktore_cialo(i+1)-1,:);
%     else %jesli jest na utwierdzeniu to nie zmienia
%         nowe_punkty(2*i+2,:)=punkty(i+1,2);
%     end
% end

% %wykrycie ktore ciała sie lacza w parach obrotowych
% ciala=zeros(ilosc_cial,10);
% for i=1:length(obrotowe)
%     
%     ciala(obrotowe(i,2),end+1)=obrotowe(i,1);
%     ciala(obrotowe(i,3),end+1)=obrotowe(i,1);
% end
% 
% figure
% for i=1:length(nowe_punkty)
% title("Animacja")
% %silowniki
% for j=1:ilosc_post
%     line([nowe_punkty(2*postepowe(j,1)-1,i),nowe_punkty(2*postepowe(j,2)-1,i)],[nowe_punkty(2*postepowe(j,1),i),nowe_punkty(2*postepowe(j,2),i)],'Color','red');
%     grid on;
%     axis([-1.4,1.2,-0.5,1.2]);
% end

ktory_punkt=input("Dane na temat któego punktu chcesz zobaczy? (px - punkt, cx - środek cięzkości): ",'s');

if ktory_punkt(1)=='c'
    if length(ktory_punkt)==2
        temp=str2num(ktory_punkt(2));
    elseif length(ktory_punkt)==3
        temp=str2num(ktory_punkt(2:3));
    end
figure
plot(T(:,1),Q(3*temp-2,:));
grid on
legend("x");
title("Przemieszczenie punktu w osi x");
xlabel("Czas [s]")
ylabel("Przemieszczenie [m]")

figure
plot(T(:,1),Q(3*temp-1,:))
grid on
legend("y");
title("Przemieszczenie punktu w osi y");
xlabel("Czas [s]")
ylabel("Przemieszczenie [m]")

figure
plot(Q(3*temp-2,:),Q(3*temp-1,:))
title("Trajektoria punktu")
grid on
xlabel("Przemieszczenie w osi x [m]")
ylabel("Przemieszczenie w osi y[m]")

figure
plot(T(:,1),DQ(3*temp-2,:));
title("Predkość w osi x")
grid on
legend("x");
xlabel("Czas [s]")
ylabel("Predkosc [m/s]")
figure
plot(T(:,1),DQ(3*temp-1,:))
title("Predkość w osi y")
grid on
legend("y");
xlabel("Czas [s]")
ylabel("Predkosc [m/s]")

figure
plot(T(:,1),D2Q(3*temp-2,:));
grid on
title("Przyspieszenie w osi x")
legend("x");
xlabel("Czas [s]")
ylabel("Przyspieszenie [m/s^2]")
figure
plot(T(:,1),D2Q(3*temp-1,:))
grid on
legend("y");
title("Przyspieszenie w osi y")
xlabel("Czas [s]")
ylabel("Przyspieszenie [m/s^2]")

figure
plot(T(:,1),180*DQ(3*temp,:)/pi);
grid on
title("Predkosc katowa członu")
legend("x");
xlabel("Czas [s]")
ylabel("Prędkosć kątowa [stopnie/s]")
figure
plot(T(:,1),180*D2Q(3*temp,:)/pi)
grid on
legend("y");
title("Przyspieszenie katowe członu")
xlabel("Czas [s]")
ylabel("Przyspieszeni kątowa [stopnie/s^2]")
end

if ktory_punkt(1)=='p'
    if length(ktory_punkt)==2
        temp=str2num(ktory_punkt(2));
    elseif length(ktory_punkt)==3
        temp=str2num(ktory_punkt(2:3));
    end
figure
plot(T(:,1),nowe_punkty(2*temp-1,:));
grid on
legend("x");
title("Przemieszczenie punktu w osi x");
xlabel("Czas [s]")
ylabel("Przemieszczenie [m]")

figure
plot(T(:,1),nowe_punkty(2*temp,:))
grid on
legend("y");
title("Przemieszczenie punktu w osi y");
xlabel("Czas [s]")
ylabel("Przemieszczenie [m]")

figure
plot(nowe_punkty(2*temp-1,:),nowe_punkty(2*temp,:))
title("Trajektoria punktu")
grid on
xlabel("Przemieszczenie w osi x [m]")
ylabel("Przemieszczenie w osi y[m]")


figure
plot(T(:,1),nowe_predkosci(2*temp-1,:));
title("Predkość w osi x")
grid on
legend("x");
xlabel("Czas [s]")
ylabel("Predkosc [m/s]")
figure
plot(T(:,1),nowe_predkosci(2*temp,:))
title("Predkość w osi y")
grid on
legend("y");
xlabel("Czas [s]")
ylabel("Predkosc [m/s]")

figure
plot(T(:,1),nowe_przyspieszenia(2*temp-1,:));
grid on
title("Przyspieszenie w osi x")
legend("x");
xlabel("Czas [s]")
ylabel("Przyspieszenie [m/s^2]")
figure
plot(T(:,1),nowe_przyspieszenia(2*temp,:))
grid on
legend("y");
title("Przyspieszenie w osi y")
xlabel("Czas [s]")
ylabel("Przyspieszenie [m/s^2]")

figure
plot(T(:,1),180*DQ(3*ktore_cialo(temp),:)/pi);
grid on
title("Predkosc katowa członu")
legend("x");
xlabel("Czas [s]")
ylabel("Prędkosć kątowa [stopnie/s]")
figure
plot(T(:,1),180*D2Q(3*ktore_cialo(temp),:)/pi)
grid on
legend("y");
title("Przyspieszenie katowe członu")
xlabel("Czas [s]")
ylabel("Przyspieszeni kątowa [stopnie/s^2]")
end