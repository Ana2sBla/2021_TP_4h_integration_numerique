function x = trajectoire(u,dt)
% Calcule les trajectoires discr�te x � partir de la vitesse associ� u et le pas de temps dt 
    x = cumsum(dt*u,2);
end