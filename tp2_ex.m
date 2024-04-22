%% Methodes Numériques MSX03 (M1 - ENS CACHAN)
%  TP2 - Génération de vagues dans un canal - Houle - théorie

L = 5; % Longueur en x [m]
H = 1; % longueur en y [m]

rho = 1000; % Masse volumique [kg/m^3]
g = 9.81; % gravité [m/s^2]

h = 0.2; % Hauteur de crête [m]
T = 2; % periode de la houle [s]

%% Calculs
w = 2*pi/T;
k = fzero(@(k) g*k*tanh(k*H)-w^2,[0 w^2+w^2/g]);

% CL et CI solution exacte
vg = @(x,t) h*g*k*cosh(k*(z+H))/cos(k*H)*cos(-w*t);
vd = @(x,t) h*g*k*cosh(k*(z+H))/cos(k*H)*cos(k*x-w*t);
phi0 = @(x,z) h*g/2/w*cosh(k*(z+H))/cos(k*H).*sin(k*x);
phi1 = @(x,z) -h*g/2*cosh(k*(z+H))/cos(k*H).*cos(k*x);

% Relations exactes (x,z sont des vecteurs et t un réel)
eta = @(x,t) h/2*cos(k*x-w*t);
phi = @(x,z,t) h*g/2/w*cosh(k*(z+H))/cosh(k*H).*sin(k*x-w*t);
p = @(x,z,t) rho*h*g/2*cosh(k*(z+H))/cosh(k*H).*cos(k*x-w*t);
u = @(x,z,t) h*g*k/2/w*cosh(k*(z+H))/cosh(k*H).*cos(k*x-w*t);
v = @(x,z,t) h*g*k/2/w*sinh(k*(z+H))/cosh(k*H).*sin(k*x-w*t);
x1 = @(x,z,t) -h*g*k/2/w^2*cosh(k*(z+H))/cosh(k*H).*sin(k*x-w*t);
z1 = @(x,z,t) h*g*k/2/w^2*sinh(k*(z+H))/cosh(k*H).*cos(k*x-w*t);

%% visualisation
Nx = 50;
Nz = 10;
Nt = 100;

[x0h,z0h] = meshgrid(0:L/(Nx-1):L,-H:H/(Nz-1):0);

for t=0:T/(Nt-1):T
    
    visualisation(x0h,z0h,'t',t,'pression',p(x0h(:),z0h(:),t), ...
                          'eta',eta(x0h(end,:),t), ...
                          'vitesses',u(x0h(:),z0h(:),t),v(x0h(:),z0h(:),t), ...
                          'positions',x1(x0h(:),z0h(:),t),z1(x0h(:),z0h(:),t));
end