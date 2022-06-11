function [p_q, p_dq, p_ddq] = TrackPoint(q,w, Point)
    
    for i=1:size(w,2)
        if (w(i).point_name(1) == Point)
           p_q = q(w(i).bodyi,1:2) + (rot(q(w(i).bodyi,3))*w(i).sA)';
           wxr = cross([0,0,q(w(i).bodyi,6)]', [(rot(q(w(i).bodyi,3))*w(i).sA)',0]);
           p_dq = q(w(i).bodyi,4:5) + wxr(1:2);
           wxwxr = cross([0,0,q(w(i).bodyi,6)]', wxr);
           axr = cross([0,0,q(w(i).bodyi,9)]', [(rot(q(w(i).bodyi,3))*w(i).sA)',0]);
           p_ddq = q(w(i).bodyi,7:8) + axr(1:2)+wxwxr(1:2);
        end
    end
    
    if (Point == 'M')
        sA = [1.3; -0.3] - [1.2; -0.25];
           p_q = q(w(10).bodyj,1:2) + (rot(q(w(10).bodyj,3))*sA)';
           wxr = cross([0,0,q(w(10).bodyj,6)]', [(rot(q(w(10).bodyj,3))*sA)',0]);
           p_dq = q(w(10).bodyj,4:5) + wxr(1:2);
           wxwxr = cross([0,0,q(w(10).bodyj,6)]', wxr);
           axr = cross([0,0,q(w(10).bodyj,9)]', [(rot(q(w(10).bodyj,3))*sA)',0]);
           p_ddq = q(w(10).bodyj,7:8) + axr(1:2)+wxwxr(1:2);
    end
end


