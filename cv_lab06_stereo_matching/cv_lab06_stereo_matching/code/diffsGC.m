function diffs = diffsGC(img1, img2, dispRange,winsize)

% get data costs for graph cut
img1=im2double(img1);
img2=im2double(img2);
[w h]=size(img1);
diffs=zeros(w,h,length(dispRange));
for i=1:length(dispRange)
    d=dispRange(i);
    Imgshifted=shiftImage(img1,d);
    sdd=(img2-Imgshifted).^2;
    f=fspecial('average',winsize);
    sdd=conv2(sdd,f,'same');
    diffs(:,:,i)=sdd;
end
end