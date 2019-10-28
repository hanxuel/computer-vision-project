function vPoints = grid_points(img,nPointsX,nPointsY,border)
    [height,width,~]=size(img);
    h=height-2*border;
    w=width-2*border;
    len_y=ceil(h/nPointsY);
    len_x=ceil(w/nPointsX);
    x=border+1:len_x:width-border;
    y=border+1:len_y:height-border;
    
    [X,Y]=meshgrid(x,y);
    c=cat(2,Y,X);
    vPoints=reshape(c,[],2);
end
