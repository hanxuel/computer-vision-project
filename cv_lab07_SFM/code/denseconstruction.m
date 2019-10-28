function denseconstruction(imgNameL,imgNameR,K,PL,PR)
path(path, 'sift');
path(path, 'GCmex1.3');
path(path,'rectification');

scale = 0.5^2; % try this scale first
%scale = 0.5^3; % if it takes too long switch to this one

imgL = imresize(imread(imgNameL), scale);
imgR = imresize(imread(imgNameR), scale);

figure(1);
subplot(121); imshow(imgL);
subplot(122); imshow(imgR);

imgL=cat(3,imgL,imgL,imgL);
imgR=cat(3,imgR,imgR,imgR);
[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

figure(2);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);


se = strel('square', 15);
maskL = imerode(maskL, se);
maskR = imerode(maskR, se);
%%
winsize=20;
%% compute disparities, winner-takes-all
% for now try these fixed ranges
%dispRange = -15:15;
% dispRange = -30:30;
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
% close all;
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

imwrite(imgRectL, 'imgRectL.png');
imwrite(imgRectR, 'imgRectR.png');

coordsGC = generatePointCloudFromDisps(dispsGCL,Hleft*S*PL,Hright*S*PR);
generateObjFile('gc-model3d','imgRectL.png',coordsGC,maskGCL);

% coordsWTA = generatePointCloudFromDisps(dispStereoL,Hleft*S*PL,Hright*S*PR);
% generateObjFile('mta-model3d','imgRectL.png',coordsWTA,maskStereoL);



