clear all;
%%pobranie danych o punktach
ilosc_pktow=0;
ilosc_cial=0;
dane=fopen('dane.txt','r');
ilosc_pktow=str2num(fgetl(dane));
punkty=zeros(ilosc_pktow,2);
ktore_cialo=zeros(ilosc_pktow,1);
for i=1:ilosc_pktow
    temp=str2num(fgetl(dane));
    ktore_cialo(i)=temp(1);
    punkty(i,:)=temp(2:3);
end
ilosc_cial=str2num(fgetl(dane));
srodki_ciezkosci=zeros(ilosc_cial,2);
for i=1:ilosc_cial
   srodki_ciezkosci(i,:)=str2num(fgetl(dane));
end
fclose(dane);
%% Więzy
wiezy=fopen('wiezy.txt','r');
ilosc_obr=0;
ilosc_post=0;
ilosc_obr=str2num(fgetl(wiezy));
obrotowe=zeros(ilosc_obr,3);
for i=1:ilosc_obr
    obrotowe(i,:)=str2num(fgetl(wiezy));
end
ilosc_post=str2num(fgetl(wiezy));
postepowe=zeros(ilosc_post,5);
for i=1:ilosc_post
    postepowe(i,:)=str2num(fgetl(wiezy));
end
fclose(wiezy);
% %% Wymuszenia
% wymuszenie=fopen('wymuszenie.txt','r');
% for i=1:8
%    eval(fgetl(wymuszenie)); 
% end
% 
% ilosc_wym_obr=0;
% ilosc_wym_post=0;
% ilosc_wym_obr=str2num(fgetl(wymuszenie));
% for i=1:ilosc_wym_obr
%     wym_obr(i,:)=textscan(wymuszenie,'%d %s %s %s\n');
% end
% ilosc_wym_post=textscan(wymuszenie,'%d\n');
% for i=1:2%ilosc_wym_post{1}
%     wym_post(i,:)=textscan(wymuszenie,'%d %s %s %s\n');
% end
% fclose(wymuszenie);

%% masy i momenty to jest dobrze
masymomenty=fopen('masymomenty.txt','r');
ilosc_cial=0;
ilosc_cial=str2num(fgetl(masymomenty));
masy_i_momenty=zeros(ilosc_cial,2);
for i=1:ilosc_cial
    temp=str2num(fgetl(masymomenty));
    masy_i_momenty(i,:)=temp(1:2);
end
fclose(masymomenty);

%% siła obciazajaca
sila =fopen('sila.txt','r');
ilosc_sil=0;
ilosc_sil=str2num(fgetl(sila));
sily=zeros(ilosc_sil,3);
for i=1:ilosc_sil
    sily=str2num(fgetl(sila));
end
fclose(sila);
%% sprezyny
sprezyny=fopen("sprezyny.txt","r");
ilosc_sprezyn=0;
ilosc_sprezyn=str2num(fgetl(sprezyny));
tab_sprezyny=zeros(ilosc_sprezyn,6);
for i=1:ilosc_sprezyn
    temp=str2num(fgetl(sprezyny));
    tab_sprezyny(i,:)=temp;
end

%% Stałe zadania typu grawitacja error itp
global epsilon
epsilon= 1e-6;
global grav
grav= 9.80665;
%% przypisanie do struktury Wiezy Bezwladnosc sprezyny sily
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
    'ddotfodt',{}); % druga pochodna funkcji od czasu dla wiezow dopisanych

Bezwladnosci = struct('m',{},... % masa członu (m)
    'Iz',{}); % moment bezwładności członu względem osi z (I_z)

Sprezyny = struct('k',{},... % sztywnosc sprezyny
    'c',{},... % tlumienie w sprezynie
    'bodyi',{},... % numer pierwszego ciala przylozenia sprezyny
    'bodyj',{},... % numer drugiego ciala przylozenia sprezyny
    'sA',{},... % punkt przylozenia sprezyny do ciala i w i-tym ukladzie lokalnym
    'sB',{},... % punkt przylozenia sprezyny do ciala j w j-tym ukladzie lokalnym
    'd0',{}); % dlugosc swobodna sprezyny

Sily = struct('F',{},... % wektor przylozonej sily
    'bodyi',{},... % numer ciala, do ktorego przylozono sile
    'sA',{}); % punkt przylozenia sily do ciala i w i-tym ukladzie lokalnym


%struktura wiezow
wszystkie_wiezy=ilosc_obr+ilosc_post;%+ilosc_wym_obr+ilosc_wym_post{1};
for i=1:ilosc_obr
        if (obrotowe(i,2)~=0 && obrotowe(i,3)~=0)
        Wiezy(i)=cell2struct({'kinematyczny','obrotowy',obrotowe(i,2),obrotowe(i,3),(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,2),:))',(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,3),:))',[],[],[],[],[]}',fieldnames(Wiezy));
        elseif (obrotowe(i,2)==0)
            Wiezy(i)=cell2struct({'kinematyczny','obrotowy',obrotowe(i,2),obrotowe(i,3),(punkty(obrotowe(i,1),:))',(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,3),:))',[],[],[],[],[]}',fieldnames(Wiezy));
        elseif (obrotowe(i,3)==0)
            Wiezy(i)=cell2struct({'kinematyczny','obrotowy',obrotowe(i,2),obrotowe(i,3),(punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,2),:))',(punkty(obrotowe(i,1),:))',[],[],[],[],[]}',fieldnames(Wiezy));
        end
end
for i=1:ilosc_post
    if ( i<=ilosc_post)
        pom=punkty(postepowe(i,2),:)-punkty(postepowe(i,1),:);
        pom=[-pom(2) pom(1)];
        Wiezy(i+ilosc_obr)=cell2struct({'kinematyczny','postepowy',postepowe(i,3),postepowe(i,4),(punkty(postepowe(i,1),:)-srodki_ciezkosci(postepowe(i,3),:))',(punkty(postepowe(i,2),:)-srodki_ciezkosci(postepowe(i,4),:))',0,pom'/norm(pom),[],[],[]}',fieldnames(Wiezy));
    end
end

% wym_post = ["1" "l1+a1*sin(omega1*t+phi1)" "omega1*a1*cos(omega1*t+phi1)" "-omega1*omega1*a1*sin(omega1*t+phi1)" ; "2" "l2+a2*sin(omega2*t+phi2)" "omega2*a2*cos(omega2*t+phi2)" "-omega2*omega2*a2*sin(omega2*t+phi2)" ];
% for i=1:double(ilosc_wym_post{1,1})
%    pom=punkty(postepowe(i,2),:)-punkty(postepowe(i,1),:);
%    Wiezy(i+ilosc_obr+ilosc_post)=cell2struct({'dopisany','postepowy',postepowe(i,3),postepowe(i,4),(punkty(postepowe(i,1),:)-srodki_ciezkosci(postepowe(i,3),:))',(punkty(postepowe(i,2),:)-srodki_ciezkosci(postepowe(i,4),:))',0,pom'/norm(pom),string(wym_post(i,2)),string(wym_post(i,3)),string(wym_post(i,4))}',fieldnames(Wiezy));
% end
% 
% for i=1:ilosc_wym_obr
%    Wiezy(i+ilosc_obr+ilosc_post+ilosc_wym_post{1})=cell2struct({'dopisany','obrotowy',obrotowe(i,2),obrotowe(i,3),punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,2),:),punkty(obrotowe(i,1),:)-srodki_ciezkosci(obrotowe(i,3),:),[],[],wym_obr(i,2),wym_obr(i,3),wym_obr(i,4)}',fieldnames(Wiezy));
% end

%struktura sil
for i=1:ilosc_sil
    Sily(1) = cell2struct({[sily(i,1)*cosd(sily(i,2)); sily(i,1)*sind(sily(i,2))], ktore_cialo(sily(i,3)), (punkty(sily(i,3),:)-srodki_ciezkosci(ktore_cialo(sily(i,3)),:))'}', fieldnames(Sily));
end

%struktura sprezyny
for i=1:ilosc_sprezyn
    Sprezyny(i) = cell2struct({tab_sprezyny(i,1), tab_sprezyny(i,2), tab_sprezyny(i,3), tab_sprezyny(i,4), (punkty(tab_sprezyny(i,5),:)-srodki_ciezkosci(tab_sprezyny(i,3),:))', (punkty(tab_sprezyny(i,6),:)-srodki_ciezkosci(tab_sprezyny(i,4),:))', norm(punkty(tab_sprezyny(i,5),:)-punkty(tab_sprezyny(i,6),:))}', fieldnames(Sprezyny)); 
end

%structura bezwladnosci

for i=1:ilosc_cial
    Bezwladnosci(i)=cell2struct({masy_i_momenty(i,1),masy_i_momenty(i,2)}', fieldnames(Bezwladnosci));
end





