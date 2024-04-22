function [u,v] = gradient(x,z,t,phi)
% Calcul le gradient d'un champs phi scalaire
% x : la discrétisation en x
% z : la discrétisation en z
% t : la discrétisation en temps t
% phi : le champs dont on veut le gradient
% u : les valeurs de grad(phi).ex
% v : les valeurs de grad(phi).ez
   
    Nx = size(x,2);
    Nz = size(x,1);
    hx = x(1,2)-x(1,1);
    hz = z(2,1)-z(1,1);
    
    u = zeros(numel(x),numel(t));
    v = zeros(numel(x),numel(t));

    for i=2:Nx-1
        u(index(i,1:Nz,Nz),:) = (phi(index(i,1:Nz,Nz),:) - phi(index(i-1,1:Nz,Nz),:))/hx;
    end
    u(index(1,1:Nz,Nz),:) = 0.1*(1-z(:,1)/1)*cos(2*pi/2*t(:))';
    u(index(Nx,1:Nz,Nz),:) = 0*z(:,1)*t(:)';
    
    for j=2:Nz
        v(index(1:Nx,j,Nz),:) = (phi(index(1:Nx,j,Nz),:) - phi(index(1:Nx,j-1,Nz),:))/hz;
    end
end