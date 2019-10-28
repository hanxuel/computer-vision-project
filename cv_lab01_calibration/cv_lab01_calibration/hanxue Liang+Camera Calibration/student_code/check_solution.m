clear all;
clc;

%% create file for solution check summary 
fid = fopen('summary.txt', 'wt');
fprintf(fid, '****************************************************\n');
fprintf(fid, 'THIS IS AN AUTOMATICALLY GENERATED FILE TO SUMMARIZE\n');
fprintf(fid, 'THE CORRECTNESS OF YOUR ALGORITHM IMPLEMENTATION FOR\n');
fprintf(fid, '  COMPUTER VISION CLASS LAB01: CAMERA CALIBRATION   \n');
fprintf(fid, '****************************************************\n');

total_points_to_deduct = 0;
         
%% this section is used to check the implementation of data normalization
% use my own data
load('xy.mat'); 
load('XYZ.mat');

xy = xy(:,1:6);
XYZ = XYZ(:,1:6);
[dummy, npoints] = size(xy);
Ones = ones(1, npoints);
xy = cat(1, xy, Ones);
XYZ = cat(1, XYZ, Ones);

[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% verification of the normalization
xy_centroid_verif = [mean(xy_normalized(1,:)) mean(xy_normalized(2,:))]
XYZ_centroid_verif = [mean(XYZ_normalized(1,:)) mean(XYZ_normalized(2,:)) mean(XYZ_normalized(3,:))]

dmean_xyn = mean(sqrt(sum(xy_normalized(1:2,:).^2)))
dmean_XYZn = mean(sqrt(sum(XYZ_normalized(1:3,:).^2)))

% assert failure if the function is not properly implemented
fprintf(fid, '\n******* Summary for data normalization *******\n');
if norm(xy_centroid_verif) > 1e-4
    fprintf(fid, 'DN: 2D centroid check failed... -4\n');
    total_points_to_deduct = total_points_to_deduct + 4;
else
    fprintf(fid, 'DN: 2D centroid check passed...\n');
end
    
if norm(XYZ_centroid_verif) > 1e-4
    fprintf(fid, 'DN: 3D centroid check failed... -4\n');
    total_points_to_deduct = total_points_to_deduct + 4;
else
    fprintf(fid, 'DN: 3D centroid check passed...\n');
end
    
if abs(dmean_xyn - sqrt(2)) > 1e-4
    fprintf(fid, 'DN: 2D scale check failed... -4\n');
    total_points_to_deduct = total_points_to_deduct + 4;
else
    fprintf(fid, 'DN: 2D scale check passed\n');
end

if abs(dmean_XYZn - sqrt(3)) > 1e-4
    fprintf(fid, 'DN: 3D scale check failed... -4\n');
    total_points_to_deduct = total_points_to_deduct + 4;
else
    fprintf(fid, 'DN: 2D scale check passed...\n');
end

xy_normalized = load('xy_normalized');
xy_normalized = xy_normalized.xy_normalized;

xy_normalized = xy_normalized(:,1:6);
XYZ_normalized = load('XYZ_normalized');
XYZ_normalized = XYZ_normalized.XYZ_normalized;

XYZ_normalized = XYZ_normalized(:,1:6);
t = load('t.mat');
t = t.T;
T = load('T.mat');
T = T.T;
U = load('U.mat');
U = U.U;
%% this section is used to check the implementation of DLT algorithm
% Check normalized P
[P_normalized] = dlt(xy_normalized, XYZ_normalized);
P_normalized = P_normalized / P_normalized(3, 4);
sol_P_normalized = [-0.5967,    0.5770,    0.0081,    0.0041;
                    -0.1010,   -0.0979,   -0.8706,   -0.0361;
                    -0.1076,   -0.1101,    0.0259,    1.0000];
                
fprintf(fid, '\n******* Summary for DLT *******\n');
if norm(P_normalized - sol_P_normalized) < 1e-4
    fprintf(fid, 'DLT: P_normalized check passed...\n');
else
    fprintf(fid, 'DLT: P_normalized check failed... -10\n');
    total_points_to_deduct = total_points_to_deduct + 10;
end

% Check K, R, t
[P,K, R, t, error] = runDLT(xy, XYZ);
K = K / K(3, 3);

K_sol = [575.4464,   -2.5424,  321.7325;
         0,         611.4182,  238.5066;
         0,                0,    1.0000];
R_sol = [-0.7149,    0.6993,    0.0044;
         -0.1190,   -0.1155,   -0.9861;
         -0.6891,   -0.7055,    0.1658];

if norm(K - K_sol) < 1e-4
    fprintf(fid, 'DLT: K check passed...\n');
else
    fprintf(fid, 'DLT: K check failed... -6\n');
    total_points_to_deduct = total_points_to_deduct + 6;
end
    
if norm(R - R_sol) < 1e-4
    fprintf(fid, 'DLT: R check passed...\n');
else
    fprintf(fid, 'DLT: R check failed... -6\n');
    total_points_to_deduct = total_points_to_deduct + 6;
end

%% This section is used to check the implementation of GSA
% Check K, R
[K, R, t, error] = runGoldStandard(xy, XYZ);
K = K / K(3, 3);

K_sol_1 = [575.7582,   -2.9763,  322.1192;
         0,         611.9594,  238.4315;
         0,         0,         1.0000];
R_sol_1 = [-0.7148,    0.6993,    0.0042;
         -0.1185,   -0.1153,   -0.9862;
         -0.6892,   -0.7055,    0.1653];
     
K_sol_2 = [584.5012,   -4.3675,  321.7724;
                  0,  621.8122,  236.6273;
                  0,         0,    1.0000];
R_sol_2 = [-0.7153,    0.6988,    0.0036;
           -0.1195,   -0.1173,   -0.9859;
           -0.6885,   -0.7056,    0.1674];
     
fprintf(fid, '\n******* Summary for GSA *******\n');
if norm(K - K_sol_1) < 5e-1 || norm(K - K_sol_2) < 5e-1
    fprintf(fid, 'GSA: K check passed...\n');
else
    fprintf(fid, 'GSA: K check failed... -10\n');
    total_points_to_deduct = total_points_to_deduct + 10;
end

if norm(R - R_sol_1) < 1e-1 || norm(R - R_sol_2) < 1e-1
    fprintf(fid, 'GSA: R check passed...\n');
else
    fprintf(fid, 'GSA: R check failed... -10\n');
    total_points_to_deduct = total_points_to_deduct + 10;
end

%% End 
fprintf(fid, '\n************* END OF THE SUMMARY **************\n');
fprintf(fid, '        You lost %d points in total\n', total_points_to_deduct);
fprintf(fid, '***********************************************\n');
    
    
    
