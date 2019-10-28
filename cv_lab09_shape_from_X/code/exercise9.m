%
% Use these variables to enable/disable different parts of the script.
%
clear all;
close all;
loadImages           = true;  % also displays silhouettes
displayVolumeCorners = true;
computeVisualHull    = false;
displayVolumeSlices  = true;
displayIsoSurface    = true;
load('volume.mat')
%
% Adjust these variables, one at a time, to get a good visual hull.
%

% Task 9.1 silhouette threshold
silhouetteThreshold = 110; 

% Task 9.2 define bounding box
% bbox = [0.25 -0.25 -2; 2.25 1.25 2.5]; % [minX minY minZ; maxX maxY maxZ];
bbox = [0.25 -0.2 -1.8; 2.1 1.1 2.5]; 
volumeX = 64;
volumeY = 64;
volumeZ = 128;

volumeThreshold = 17;

home;
numCameras = 18;

if loadImages
    % Load silhouette images and projection matrices
    for n=1:numCameras
        Ps{n} = textread(sprintf('../data/david_%02d.pa',n-1));
        Ps{n} = [eye(3,2) [1 1 1]']*Ps{n};  % add 1 for one-based indices
        ims{n} = imread(sprintf('../data/david_%02d.jpg',n-1));
        sils{n} = rgb2gray(ims{n})>silhouetteThreshold;
        
        figure(1);
        subplot(1,2,1);
        imshow(sils{n});
        subplot(1,2,2);
        imshow(double(rgb2gray(ims{n}))/255.*sils{n});
        drawnow;
    end
end

% Define transformation from volume to world coordinates.
T = [eye(4,3) [bbox(1,:) 1]'] * ...
    diag([(bbox(2,1)-bbox(1,1))/volumeX ...
          (bbox(2,2)-bbox(1,2))/volumeY ...
          (bbox(2,3)-bbox(1,3))/volumeZ ...
          1]);
T = [1  0 0 0; ...
     0  0 1 0; ...  % flip y and z axes for better display in matlab figure (isosurface)
     0 -1 0 0; ...
     0  0 0 1] * T;
T = T*[eye(4,3) [-[1 1 1] 1]'];  % subtract 1 for one-based indices

if displayVolumeCorners
    % Draw projection of volume corners.
    for n=1:numCameras
        figure(2);
        hold off;
        imshow(ims{n});
        hold on;
        corners = [[      0       0       0 1]' ...
                   [      0       0 volumeZ 1]' ...
                   [      0 volumeY       0 1]' ...
                   [      0 volumeY volumeZ 1]' ...
                   [volumeX       0       0 1]' ...
                   [volumeX       0 volumeZ 1]' ...
                   [volumeX volumeY       0 1]' ...
                   [volumeX volumeY volumeZ 1]'];
        pcorners = Ps{n}*T*corners;
        pcorners = pcorners./repmat(pcorners(3,:),3,1);
        plot(pcorners(1,:),pcorners(2,:),'g*');
        drawnow;
        pause(0.1);
    end
end

if computeVisualHull
    % Define volume.
    volume = zeros(volumeX,volumeY,volumeZ);
    
    % Visual hull computation    
    % Task 9.3 Visual hull computation
    %   - add one to volume if projection is within silhouette region
    for n=1:numCameras
        for x=1:volumeX
            for y=1:volumeY
                for z=1:volumeZ
                    point=Ps{n}*T*[x,y,z,1]';
                    point=ceil(point./point(3));
                    [height,width] = size(sils{n});
                    volume(x,y,z) = volume(x,y,z) +sils{n}(point(2),point(1));                  
                end
            end
        end
    end
    %OPTIMIZED
%     [i,j,w] = meshgrid(1:volumeX, 1:volumeY, 1:volumeZ);
%     m = volumeX*volumeY*volumeZ;
%     i = i(:); j = j(:); w = w(:);
%     index = sub2ind(size(volume), i, j, w);
%     worldCoords = T*[[i,j,w],ones(m,1)]';
%     for n=1:numCameras
%        tmp = Ps{n}*worldCoords;
%        tmp=ceil(tmp./tmp(3));
% %        tmp(find(tmp<1)) = 1;
%        tmpSils = sils{n};
%        volume(index) = volume(index) + sils{n}(sub2ind(size(sils{n}), tmp(2,:), tmp(1,:)))';
%     end
end

if displayVolumeSlices
    figure(3);
    hold off;
    for n=1:size(volume,3)
        imagesc(volume(:,:,n));
        drawnow;
        pause(0.1);
    end
end

if displayIsoSurface
    % display result
    figure(4);
    clf;
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold on;
    [xMesh yMesh zMesh] = meshgrid(1:volumeY,1:volumeX,1:volumeZ);
    pt = patch(isosurface(yMesh, xMesh, zMesh, volume, volumeThreshold));
    set(pt,'FaceColor','red','EdgeColor','none');
    axis equal;
    daspect([volumeX/(bbox(2,1)-bbox(1,1)) volumeY/(bbox(2,2)-bbox(1,2)) volumeZ/(bbox(2,3)-bbox(1,3))]);
    camlight(0,0);
    camlight(180,0);
    camlight(0,90);
    camlight(0,-90);
    lighting phong;
    view(30,30);
end


