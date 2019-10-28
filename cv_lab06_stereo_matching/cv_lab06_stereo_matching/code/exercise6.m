% intro
close all
clear all
path(path, 'sift');
path(path, 'GCmex1.3');
path(path,'rectification');

imgNameL = 'images/0018.png';
imgNameR = 'images/0019.png';
camNameL = 'images/0018.camera';
camNameR = 'images/0019.camera';

scale = 0.5^2; % try this scale first
%scale = 0.5^3; % if it takes too long switch to this one

imgL = imresize(imread(imgNameL), scale);
imgR = imresize(imread(imgNameR), scale);

figure(1);
subplot(121); imshow(imgL);
subplot(122); imshow(imgR);

[K R C] = readCamera(camNameL);
PL = K * [R, -R*C];
[K R C] = readCamera(camNameR);
PR = K * [R, -R*C];

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

figure(2);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);
%close all;

se = strel('square', 15);
maskL = imerode(maskL, se);
maskR = imerode(maskR, se);
%%
% set disparity range
%% exercise 5.4 (10% bonus if done automatically)
% % %1)extract SIFT features and match
% % ransac_threshold=0.3;
% % [fa, da] = extractSIFT(rgb2gray(imgRectL));
% % [fb, db] = extractSIFT(rgb2gray(imgRectR));
% % [matches, scores] = siftmatch(da, db);
% % save('sift_results.mat','fa','fb','matches', 'ransac_threshold');
% load('sift_results.mat','fa','fb','matches', 'ransac_threshold');
% 
% % figure(7),
% % showFeatureMatches(imgRectL, fa(1:2, matches(1,:)), imgRectR, fb(1:2, matches(2,:)), 1);
% siftx1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
% siftx2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
% [~,inliers]=fundamentalMatrixRANSAC(siftx1s,siftx2s);
% inliers1=siftx1s(:,inliers);
% inliers2=siftx2s(:,inliers);
% range=abs(inliers2-inliers1);
% range=range(:,range(2,:)<3);
% dispRangeLR=-round(min(15,max(range(1,:)))):1:round(min(15,max(range(1,:))))
% dispRangeRL=dispRangeLR;
    
%2)set disparity range (i.e. using x1s and x2s)
%     %[x1s, x2s] = getClickedPoints(imgRectL, imgRectR); 
%     load('x1s');
%     load('x2s');
%     min_dist = min(-40,vecnorm(x1s - x2s));
%     max_dist = max(40,vecnorm(x1s - x2s));
% 
%     dispRangeLR = min_dist:max_dist
%     dispRangeRL = -max_dist:-min_dist
winsize=7;
%% compute disparities, winner-takes-all
% for now try these fixed ranges
%  dispRange = -15:15;
% %dispRange = -40:40;
% % exercise 5.1
% dispStereoL = ...
%     stereoDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRange,winsize);
% dispStereoR = ...
%     stereoDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRange,winsize);
% 
% figure(3);
% subplot(121); imshow(dispStereoL, [dispRange(1) dispRange(end)]);
% subplot(122); imshow(dispStereoR, [dispRange(1) dispRange(end)]);
% % 
% thresh = 8;
% 
% maskLRcheck = leftRightCheck(dispStereoL, dispStereoR, thresh);
% maskRLcheck = leftRightCheck(dispStereoR, dispStereoL, thresh);
% 
% maskStereoL = double(maskL).*maskLRcheck;
% maskStereoR = double(maskR).*maskRLcheck;
% 
% figure(4);
% subplot(121); imshow(maskStereoL);
% subplot(122); imshow(maskStereoR);
% % close all;
% %
%% compute disparities using graphcut
dispRangeLR = -15:15;
dispRangeRL = dispRangeLR;
% exercise 5.2
Labels = ...
    gcDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRangeLR,winsize);
dispsGCL = double(Labels + dispRangeLR(1));
Labels = ...
    gcDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRangeRL,winsize);
dispsGCR = double(Labels + dispRangeRL(1));

thresh=7;
maskLRcheck = leftRightCheck(dispsGCL, dispsGCR, thresh);
maskRLcheck = leftRightCheck(dispsGCR, dispsGCL, thresh);

maskGCL = double(maskL).*maskLRcheck;
maskGCR = double(maskR).*maskRLcheck;

figure(5);
subplot(121),imshow(mat2gray(dispsGCL));
subplot(122),imshow(mat2gray(dispsGCR));
figure(6);
subplot(121); imshow(maskGCL);
subplot(122); imshow(maskGCR);
%close all;
%%
% dispStereoL = double(dispStereoL);
% dispStereoR = double(dispStereoR);
dispsGCL = double(dispsGCL);
dispsGCR = double(dispsGCR);

S = [scale 0 0; 0 scale 0; 0 0 1];

% for each pixel (x,y), compute the corresponding 3D point 
% use S for computing the rescaled points with the projection 
% matrices PL PR
% exercise 5.3

imwrite(imgRectL, 'imgRectL.png');
imwrite(imgRectR, 'imgRectR.png');

coordsGC = generatePointCloudFromDisps(dispsGCL,Hleft*S*PL,Hright*S*PR);
generateObjFile('gc-model3d','imgRectL.png',coordsGC,maskGCL);

% coordsWTA = generatePointCloudFromDisps(dispsGCL,Hleft*S*PL,Hright*S*PR);
% generateObjFile('mta-model3d','imgRectL.png',coordsWTA,maskStereoL);

% coordsGC = generatePointCloudFromDisps(dispsGCL,Hleft*S*PL,Hright*S*PR);
% generateObjFile('automaticgc-model3d','imgRectL.png',coordsGC,maskGCL);


