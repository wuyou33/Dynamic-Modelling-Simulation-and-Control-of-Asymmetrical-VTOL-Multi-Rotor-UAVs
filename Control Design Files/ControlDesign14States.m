close all; % close all figures
clear;     % clear workspace variables
clc;       % clear command window

%% Mass of the Multirotor in Kilograms as taken from the CAD

M = 2100/1000; 
g = 9.81;

%% Dimensions of Multirotor

L1 = 22/100; % along X-axis Distance from left and right motor pair to center of mass
L2 = 15/100; % along Y-axis Vertical Distance from left and right motor pair to center of mass
L3 = 30/100; % along Y-axis Distance from motor pair to center of mass

%%  Mass Moment of Inertia as Taken from the CAD

Ixx = 3.094E+05;
Ixy = 45.147;
Ixz = 2.309;
Iyx = 45.147;
Iyy = 4.204E+05;
Iyz = 832.833;
Izx = 2.309;
Izy = 832.833;
Izz = 1.464E+05;

%% Inertia Matrix and Diagolalisation CAD model coordinate system rotated 90 degrees about X

I = [Izx Izy Izz;
     Ixx Ixy Ixz;
     Iyx Iyy Iyz];
 
Idiag = diag(I)/10000;
 
Ixx = Idiag(1);
Iyy = Idiag(2);
Izz = Idiag(3);

%% Motor Thrust and Torque Constants (To be determined experimentally)

Kw = 0.85;
Ktau =  4.46*(10^-8);
Kthrust =  3.7155*(10^-7);
Kthrust2 = -3.7327*(10^-4);
Mtau = (1/44.22);
Ku = 515.5;

%% Air resistance damping coeeficients

Dxx = 0.01212;
Dyy = 0.01212;
Dzz = 0.0648;                          

%% Equilibrium Input 

%U_e = sqrt(((M*g)/(3*(Kthrust+(Kw*Kthrust)))));
U_e = 5900;%((-6*Kthrust2) + sqrt((6*Kthrust2)^2 - (4*(-M*g)*(3*Kw*Kthrust + 3*Kthrust))))/(2*(3*Kw*Kthrust + 3*Kthrust));

%% Define Linear Continuous-Time Multirotor Dynamics: x_dot = Ax + Bu, y = Cx + Du         

% A =  14x14 matrix
A = [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, 2*Kthrust*U_e/M, 2*Kthrust*U_e/M, 2*Kthrust*U_e/M, 2*Kthrust*U_e/M, 2*Kthrust*U_e/M, 2*Kthrust*U_e/M;
     0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, L1*2*Kthrust*U_e/Ixx, L1*2*Kthrust*U_e/Ixx, -L1*2*Kthrust*U_e/Ixx, -L1*2*Kthrust*U_e/Ixx, 0, 0;
     0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, -L2*2*Kthrust*U_e/Iyy, -L2*2*Kthrust*U_e/Iyy, -L2*2*Kthrust*U_e/Iyy, -L2*2*Kthrust*U_e/Iyy, L3*2*Kthrust*U_e/Iyy,L3*2*Kthrust*U_e/Iyy;
     0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, -2*Ktau*U_e/Izz, 2*Ktau*U_e/Izz, 2*Ktau*U_e/Izz, -2*Ktau*U_e/Izz, -2*Ktau*U_e/Izz, 2*Ktau*U_e/Izz;
     0, 0, 0, 0, 0, 0, 0, 0, -1/Mtau, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, 0, -1/Mtau, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/Mtau, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/Mtau, 0, 0;
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/Mtau, 0;
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1/Mtau];
 
% B = 14x6 matrix
B = [0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0;
     Ku, 0, 0, 0, 0, 0;
     0, Ku, 0, 0, 0, 0;
     0, 0, Ku, 0, 0, 0;
     0, 0, 0, Ku, 0, 0;
     0, 0, 0, 0, Ku, 0;
     0, 0, 0, 0, 0, Ku];

% C = 4x14 matrix
C = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0];
     
% D = 4x6 matrix
D = zeros(4,6);

%%
poles = eig(A);

Jpoles = jordan(A);

cntr = rank(ctrb(A,B));
% patially controllable 

obs = rank(obsv(A,C));
% partially observable but fully detectable

%% Define Discrete-Time BeagleBone Dynamics

T = 0.010; % Sample period (s)- 100Hz

%% Discrete-Time Full State-Feedback Control
% State feedback control design (integral control via state augmentation)
% Define augmented system matrices pitch roll and yaw are controlled outputs
% Define LQR weighting matrices

Cr  = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
       0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
       0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
       0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0];    

r = 4;                                % number of reference inputs
n = size(A,2);                        % number of states
q = size(Cr,1);                       % number of controlled outputs
Dr = zeros(q,6);

Aaug = [A zeros(n,r); 
       -Cr zeros(q,r)];
      
Baug = [B; -Dr];
  
Qx = [1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 500000000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
      0, 0, 1500, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50000000000, 0, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 600000, 0, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 600000, 0;
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 600000];
    
%eye(18,18);  % State penalty

Qu = eye(6,6);    % Control penalty

Kdtaug = lqrd(Aaug,Baug,Qx,Qu,T);  % DT State-Feedback Controller Gains

Kdt = Kdtaug(:,1:n); 

Kidt = -Kdtaug(:,n+1:end);

Kr = -1*((Cr*inv(A - B*Kdt)*B).^-1);%eye(6,4);

%% Discrete-Time Kalman Filter Design x_dot = A*x + B*u + G*w, y = C*x + D*u + H*w + v

sysdt = c2d(ss(A,B,C,D),T,'zoh');  % Generate Discrete-Time System

Adt = sysdt.a; 
Bdt = sysdt.b; 
Cdt = sysdt.c; 
Ddt = sysdt.d;

Gdt = 1e-1*eye(n);

Hdt = zeros(size(C,1),size(Gdt,2)); % No process noise on measurements

Rw = eye(14,14);   % Process noise covariance matrix

Rv = eye(4)*1e-5;     % Measurement noise covariance matrix Note: use low gausian noice for Rv

N = zeros(size(Rw,2),size(Rv,2));

sys4kf = ss(Adt,[Bdt Gdt],Cdt,[Ddt Hdt],T);

[kdfilt,Ldt] = kalman(sys4kf,Rw,Rv); 

%% Close-Loop analysis

OpenLoopAugSS  = ss(Aaug,Baug,eye(18),zeros(18,6)); % augmented open loop system assuming  kf full state output

LQRAugSS  = feedback(OpenLoopAugSS,Kdtaug); % closed loop augmented system 

Acl = LQRAugSS.a;
Bcl = [zeros(14,4); eye(4)]; 
Ccl = LQRAugSS.c;
Dcl = zeros(18,4);

ClosedLoopAugSS = ss(Acl,Bcl,Ccl,Dcl); % closed loop augmented system

Cpoles = eig(ClosedLoopAugSS);

%% step outputs
tvec = (0:0.1:20);
rvec = [100*ones(length(tvec),1),zeros(length(tvec),1),zeros(length(tvec),1),zeros(length(tvec),1)];

Y = lsim(ClosedLoopAugSS,rvec,tvec);
%plot(tvec,Y(:,1))