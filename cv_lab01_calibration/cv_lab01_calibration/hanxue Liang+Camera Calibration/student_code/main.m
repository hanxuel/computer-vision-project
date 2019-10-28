% main
% clc;
% clear all;
% 
%IMG_NAME = 'image/image4.jpg';

%This function displays the calibration image and allows the user to click
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You can also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as input for your algorithms.
% [xy XYZ] = getpoints(IMG_NAME);


% === Task 2 DLT algorithm ===
[P,K_dlt_norm, R, t, error_dlt_norm] = runDLT(xy, XYZ);
[P,K_dlt, R, t, error_dlt] = runDLT_denorm(xy, XYZ);

% === Task 3 Gold Standard algorithm ===
[K_goldstandard, R, t, error_goldstandard] = runGoldStandard(xy, XYZ);

% === Bonus: Gold Standard algorithm with radial distortion estimation ===
rad=zeros(1,2);%initial radiao distortion
[Kn, Rn, tn, error_goldstandardrad,rad] = runGoldStandardRadial(xy, XYZ,rad)
%===image undistortion===
[pxy] = imageundistortion(xy, XYZ, Kn,Rn,tn,rad)

