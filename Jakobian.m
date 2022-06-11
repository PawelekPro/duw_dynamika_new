% ta funcja generuje macierz Jacobiego mechanizmu

function [ Jacob ] = Jakobian( q, t, Wiezy, rows )

% aktualny numer wiersza macierzy
m = 1;

% wype³nienie macierzy samymi zerami
Jacob = zeros(rows, size(q,1));

% macierz Omega
Omega = [0 -1; 1 0];

% wype³nienie macierzy niezerowymi elementami 

for l=1:length(Wiezy)
    if(lower(Wiezy(l).typ) == "dopisany")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            if(Wiezy(l).bodyi>0)
                Jacob(m, 3*Wiezy(l).bodyi) = 1;
            end
            if(Wiezy(l).bodyj>0)
                Jacob(m, 3*Wiezy(l).bodyj) = - 1;
            end
            m = m+1;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            tmp = (rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).perp )';
            if(Wiezy(l).bodyi>0)
                Jacob(m, (3*Wiezy(l).bodyi - 2):(3*Wiezy(l).bodyi - 1)) = - tmp;
                Jacob(m, 3*Wiezy(l).bodyi) = -tmp * Omega() * ...
                    rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA;
            end
            if(Wiezy(l).bodyj>0)
                Jacob(m, (3*Wiezy(l).bodyj - 2):(3*Wiezy(l).bodyj - 1)) = tmp;
                Jacob(m, 3*Wiezy(l).bodyj) = -tmp * Omega() * ...
                    (q_r(q, Wiezy(l).bodyj) - q_r(q, Wiezy(l).bodyi) - ...
                    rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA);
            end
            m = m+1;
        else
            error(['Blad: zle podana klasa wiezu nr:', num2str(l)]);
        end
    elseif(lower(Wiezy(l).typ) == "kinematyczny")
        if(lower(Wiezy(l).klasa) == "obrotowy")
            if(Wiezy(l).bodyi>0)
                Jacob(m:(m+1), (3*Wiezy(l).bodyi - 2):(3*Wiezy(l).bodyi - 1)) = eye(2);
                Jacob(m:m+1, 3*Wiezy(l).bodyi) = Omega()*...
                    rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA;
            end
            if(Wiezy(l).bodyj>0)
                Jacob(m:m+1, (3*Wiezy(l).bodyj - 2):(3*Wiezy(l).bodyj - 1)) = -eye(2);
                Jacob(m:m+1, 3*Wiezy(l).bodyj) = - Omega()*...
                    rot(q_phi(q, Wiezy(l).bodyj))*Wiezy(l).sB;
            end
            m = m+2;
        elseif(lower(Wiezy(l).klasa) == "postepowy")
            if(Wiezy(l).bodyi>0)
                Jacob(m, 3*Wiezy(l).bodyi) = 1;
            end
            if(Wiezy(l).bodyj>0)
                Jacob(m, 3*Wiezy(l).bodyj) = - 1;
            end
            m = m+1;
            
            tmp = (rot(q_phi(q, Wiezy(l).bodyj)) * Wiezy(l).perp )';
            if(Wiezy(l).bodyi>0)
                Jacob(m, (3*Wiezy(l).bodyi - 2):(3*Wiezy(l).bodyi - 1)) = - tmp;
                Jacob(m, 3*Wiezy(l).bodyi) = -tmp * Omega() * ...
                    rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA;
            end
            if(Wiezy(l).bodyj>0)
                Jacob(m, (3*Wiezy(l).bodyj - 2):(3*Wiezy(l).bodyj - 1)) = tmp;
                Jacob(m, 3*Wiezy(l).bodyj) = -tmp * Omega() * ...
                    (q_r(q, Wiezy(l).bodyj) - q_r(q, Wiezy(l).bodyi) - ...
                    rot(q_phi(q, Wiezy(l).bodyi))*Wiezy(l).sA);
            end
            m = m+1;
        else
            error(['Blad: zle podana klasa wiezu nr:', num2str(l)]);
        end
    else
        error(['Blad: zle podany typ wiezu nr:', num2str(l)]);
    end
end

wspolczynnik_uwarunkowania = cond(Jacob);
if (wspolczynnik_uwarunkowania > (1/1e-10))
    error('UWAGA: Macierz Jacobiego jest osobliwa');
end


end

