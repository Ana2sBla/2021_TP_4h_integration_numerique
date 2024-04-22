function eta = elevation(dphi,N)
% Calcule l'élévation de la surface libre eta à partir du champs phi et du pas
% de temps dt. Eta ne doit être calculé que sur la surface libre, ie pour
% z=0.
    g = 9.81; % gravité [m/s^2]
    eta = -(1/g)*dphi(  index((1:N(2)) ,N(1) ,N )   ,:)
end