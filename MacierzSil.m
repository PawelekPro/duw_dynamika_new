function [ Q ] = MacierzSil( NB, Bezwladnosci, NS, Sprezyny, NF, Sily, q, qdot )

g=9.80665;


Q = zeros(3*NB,1);

%grawitacja

for iter=1:NB
    Q(3*iter-1, 1) = - Bezwladnosci(iter).m * g;
end

%sprezyny i tlumienie

for iter=1:NS
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

% zewnetrzne

for iter=1:NF
    if(Sily(iter).bodyi>0)
        Q((3*Sily(iter).bodyi-2):(3*Sily(iter).bodyi), 1) = ...
            Q((3*Sily(iter).bodyi-2):(3*Sily(iter).bodyi), 1) + ...
            [1, 0; 0, 1; ...
            (Omega() * rot(q_phi(q, Sily(iter).bodyi)) * Sily(iter).sA)'] * ...
            Sily(iter).F;
    end
end

end


