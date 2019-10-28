% =========================================================================
% Exercise 4.5: Feature extraction and matching
% =========================================================================
clear
addpath helpers

%don't forget to initialize VLFeat

%Load images
%dataset = 0;   % Your pictures
%dataset = 1; % ladybug
% dataset = 2; % rect
 dataset = 3; % pumpkin
% image names
if(dataset==0)
    imgName1 = ''; % Add your own images here if you want
    imgName2 = '';
elseif(dataset==1)
    imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png';
    imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
elseif(dataset==2)
    imgName1 = 'images/rect1.jpg';
    imgName2 = 'images/rect2.jpg';
elseif(dataset==3)
    imgName1 = 'images/pumpkin1.jpg';
    imgName2 = 'images/pumpkin2.jpg';
end;

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db,1.5);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];

%show matches
showFeatureMatches(img1, x1s(1:2,:), img2, x2s(1:2,:), 1);
%%
% =========================================================================
% Exercise 4.6: 8-point RANSAC
% =========================================================================

threshold = 3;

% TODO: implement ransac8pF
% [inliers1, inliers2, outliers1, outliers2, F] = ransac8pF(x1s, x2s, threshold);
% 
% showFeatureMatches(img1, inliers1(1:2,:), img2, inliers2(1:2,:), 2);
% showFeatureMatches(img1, outliers1(1:2,:), img2, outliers1(1:2,:), 3);

[inliers1, inliers2, outliers1, outliers2, M, F] = ransac8pF_adp(x1s, x2s, threshold);

showFeatureMatches(img1, inliers1(1:2,:), img2, inliers2(1:2,:), 4);
showFeatureMatches(img1, outliers1(1:2,:), img2, outliers1(1:2,:), 5);
% =========================================================================