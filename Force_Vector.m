function [ Q ] = Force_Vector( NoB, Bezwladnosci, NoS, Sprezyny, NoF, Sily, q, qdot )
%SILYUOGOLNIONE Funkcja zwracająca wektor sił uogólnionych w zależności od
%aktualnej konfiguracji mechanizmu
grav= 9.80665;
% Czyszczenie wektora Q
    Q = zeros(3*NoB,1);

% Siły grawitacyjne to jest git
for iter=1:NoB
    Q(3*iter-1, 1) = - Bezwladnosci(iter).m * grav;
end

%Si?y od sprŕ?yn to jest git

for iter=1:NoS
    d = q_r(q, Sprezyny(iter).bodyj) - q_r(q, Sprezyny(iter).bodyi) + ...
        rot(q_phi(q, Sprezyny(iter).bodyj))*Sprezyny(iter).sB - ...
        rot(q_phi(q, Sprezyny(iter).bodyi))*Sprezyny(iter).sA;
    u = d/norm(d);
    
    Fk = Sprezyny(iter).k*(norm(d) - Sprezyny(iter).d0);
    Fc = Sprezyny(iter).c * u' * ( q_r(qdot, Sprezyny(iter).bodyj) - q_r(qdot, Sprezyny(iter).bodyi) + ...
        Omega() * rot(q_phi(q, Sprezyny(iter).bodyj)) * Sprezyny(iter).sB * q_phi(qdot, Sprezyny(iter).bodyj) - ...
        Omega() * rot(q_phi(q, Sprezyny(iter).bodyi)) * Sprezyny(iter).sA * q_phi(qdot, Sprezyny(iter).bodyi) );
    
    if(Sprezyny(iter).bodyi>0)
        Q((3*Sprezyny(iter).bodyi-2):(3*Sprezyny(iter).bodyi),1) = ...
            Q((3*Sprezyny(iter).bodyi-2):(3*Sprezyny(iter).bodyi),1) + ...
            [1, 0; 0, 1; ...
            (Omega() * rot(q_phi(q, Sprezyny(iter).bodyi)) * Sprezyny(iter).sA)'] * ...
            u * (Fc+Fk);
    end
    if(Sprezyny(iter).bodyj>0)
        Q((3*Sprezyny(iter).bodyj-2):(3*Sprezyny(iter).bodyj),1) = ...
            Q((3*Sprezyny(iter).bodyj-2):(3*Sprezyny(iter).bodyj),1) + ...
            [1, 0; 0, 1; ...
            (Omega() * rot(q_phi(q, Sprezyny(iter).bodyj)) * Sprezyny(iter).sB)'] * ...
            (-u) * (Fc+Fk);
    end
end

% Si?y zewnŕtrzne to jest git

for iter=1:NoF
    if(Sily(iter).bodyi>0)
        Q((3*Sily(iter).bodyi-2):(3*Sily(iter).bodyi), 1) = ...
            Q((3*Sily(iter).bodyi-2):(3*Sily(iter).bodyi), 1) + ...
            [1, 0; 0, 1; ...
            (Omega() * rot(q_phi(q, Sily(iter).bodyi)) * Sily(iter).sA)'] * ...
            Sily(iter).F;
    end
end

end


