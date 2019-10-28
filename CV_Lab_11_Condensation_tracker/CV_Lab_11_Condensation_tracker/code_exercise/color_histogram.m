
function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
    [W,H,~] = size(frame);
    xMin = int32(xMin);
    xMax = int32(xMax);
    yMin = int32(yMin);
    yMax = int32(yMax);
    hist = zeros(hist_bin,hist_bin,hist_bin);
    c = 0;
for x = xMin:xMax
    if x <= H && x >= 1
        for y = yMin:yMax
            if y <= W && y >= 1
                c = c +1;
                h = ceil(double(frame(y,x,:)+uint8(ones(1,1,3))) * double(hist_bin/256));
                hist(h(1), h(2), h(3)) = hist(h(1), h(2), h(3))+1;
            end
        end
    end
end 

if c > 0
    hist = hist./c;
end

end


