function [u,v,a] = newmark(M,K,F,un,vn,an,dt)
% Résolution du problème à l'aide d'un schéma de Newmark
%   M,K,F : matrices du système M*ü+K*u=F
%   un : les valeurs de u à l'instant précédent
%   vn : les valeurs de la dérivée 1er en temps de u à l'instant précédent
%   an : les valeurs de la dérivée 2nd en temps de u à l'instant précédent
%   u : les valeurs de u au nouvel instant
%   v : les valeurs de la dérivée 1er en temps de u au nouvel instant
%   a : les valeurs de la dérivée 2nd en temps de u au nouvel instant

    % Paramètres du schéma de Newmark
    beta = 1/4;
    gamma = 1/2;
    
    % Calculs
    a = zeros(size(K,2),1); % TODO calcul de la dérivée 2nd
    v = zeros(size(K,2),1); % TODO calcul de la dérivée 1er
    u = zeros(size(K,2),1); % TODO calcul du champs
    a = inv(M + K*beta*dt^2 +gamma*dt^2*K)*(F -K*(dt^2*(1.5-beta-gamma)*an+dt*vn+un));
    v = vn + dt*((1-gamma)*an+gamma*a);
    u = inv(K)*(F - M*a);
end