function [rows] = no_equations(Wiezy)
rows = 0;
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
        end
    end
end
end

