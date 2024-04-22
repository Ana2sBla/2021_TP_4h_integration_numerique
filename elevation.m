function eta = elevation(dphi,N)
% Calcule l'�l�vation de la surface libre eta � partir du champs phi et du pas
% de temps dt. Eta ne doit �tre calcul� que sur la surface libre, ie pour
% z=0.
    g = 9.81; % gravit� [m/s^2]
    eta = -(1/g)*dphi(  index((1:N(2)) ,N(1) ,N )   ,:)
end