function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight; 
    anglerange=180/nBins;

    descriptors = zeros(0,nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(0,4*w*4*h); % image patches stored in rows    
    %img=sqrt(img);%%%Ù¤ÂíÐ£Õý
    [grad_x,grad_y]=gradient(img);    
    
    for i = [1:size(vPoints,1)] % for all local feature points
        vPoint=vPoints(i,:);
        xindex=[vPoint(1)-2*w:vPoint(1)-1,vPoint(1)+1:vPoint(1)+2*w];
        yindex=[vPoint(2)-2*h:vPoint(2)-1,vPoint(2)+1:vPoint(2)+2*h];
        patch1=img(xindex,yindex);
        patch=reshape(patch1,[1,4*w*4*h]);
        
        xindex1=vPoint(1)-2*w:vPoint(1)+2*w;
        yindex1=vPoint(2)-2*h:vPoint(2)+2*h;
        angles=atan2(grad_y(xindex1,yindex1),grad_x(xindex1,yindex1));
        magnitude=sqrt(grad_x(xindex1,yindex1).^2 + grad_y(xindex1,yindex1).^2);

        descriptor=[];
        for j = 1:4:16
            for k = 1:4:16
                tempdescriptor=zeros(1,nBins);
                tepmag=magnitude(j:j+3,k:k+3);
%                 tepmag=tepmag/sum(sum(tepmag));
                tepangle=angles(j:j+3,k:k+3);
                tepangle=mod(tepangle*180/pi,180)+0.0000001;
                bin_id=ceil(tepangle./anglerange);
                for m=1:nBins
                    tempdescriptor(m)=sum(tepmag(find(bin_id==m)));
                end
                descriptor=[descriptor,tempdescriptor];
            end
        end
        patches=[patches;patch];
        descriptors=[descriptors;descriptor];
    end % for all local feature points
    
end
