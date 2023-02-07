function [f_nom, E_nom, rm, rdm] = createMeasurement(mue, orb_nom, t, xhis, tm)
% creates measurement for a given orbit at a given time and adjust it to be
% between [0 2pi]

[f_nom, E_nom] = getfEnom(mue, orb_nom, tm);

brvm = interp1(t, xhis, tm); %getmeas(t);
rm = norm(brvm(1:3)) + randn*50;

if f_nom < 0
    f_nom = 2*pi+f_nom;
    rdm = -1;
else
    rdm = 1;
end

end