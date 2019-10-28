function coords = generatePointCloudFromDisps(disps,PL, PR)
    
% for each pixel (x,y) find the corresponding 3D point

coords = zeros([size(disps) 3]);
for y=1:size(disps,1)
    for x=1:size(disps,2)
        %problem
        coords(y,x,1:3) = linTriang([x,y],[x+disps(y,x),y],PL,PR) ;
    end
end