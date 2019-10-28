function [imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = getRectifiedImages(imgL,imgR)

path(path, 'sift');

% convert to gray scale image$
imgLgray = rgb2gray(imgL);
imgRgray = rgb2gray(imgR);

% extract features
[x1s, descr1] = extractSIFT(im2double(imgLgray));
[x2s, descr2] = extractSIFT(im2double(imgRgray));
descr1 = single(descr1);
descr2 = single(descr2);

x1s = [x1s(1:2,:); ones(1, size(x1s, 2))];
x2s = [x2s(1:2,:); ones(1, size(x2s, 2))];

% figure, hold on, plot(x1s(1, :), x1s(2, :), 'xr');
% figure, hold on, plot(x2s(1, :), x2s(2, :), 'xr');
% find feature matches
[matches] = siftmatch(descr1, descr2);

% show feature matches
% figure, imshow(imgL);
% hold on, plot(x1s(1, matches(1,:)), x1s(2, matches(1,:)), 'xr');
% hold on, plot(x2s(1, matches(2,:)), x2s(2, matches(2,:)), 'ob');

% compute F
[F, inliers] = fundamentalMatrixRANSAC(x1s(:, matches(1,:)), x2s(:, matches(2,:)));


[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = rectifyImages(imgL, imgR, [x1s(1:2, matches(1, inliers))', x2s(1:2, matches(2, inliers))'], F);
