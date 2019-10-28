function disp = stereoDisparity(img1, img2, dispRange,winsize)

% dispRange: range of possible disparity values
% --> not all values need to be checked
img1=im2double(img1);
img2=im2double(img2);
[w h]=size(img1);
SDD=zeros(w,h,length(dispRange));
for i=1:length(dispRange)
    d=dispRange(i);
    Imgshifted=shiftImage(img1,d);
    sdd=(img2-Imgshifted).^2;
    f=fspecial('average',winsize);
    sdd=conv2(sdd,f,'same');
    SDD(:,:,i)=sdd;
end
[value index]=min(SDD,[],3);
disp=reshape(dispRange(index(:)),w,h);
end