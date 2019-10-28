function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
    particles_w = zeros(size(particles,1),1);
    
    sizeFrame = size(frame);
    h_frame = sizeFrame(1);
    w_frame = sizeFrame(2);
    
    for i = 1:size(particles,1)
        % Compute color histogram for each particle
        xMin = round(min(max(1,particles(i,1)-0.5*W),w_frame));
        xMax = round(min(max(1,particles(i,1)+0.5*W),w_frame));
        yMin = round(min(max(1,particles(i,2)-0.5*H),h_frame));
        yMax = round(min(max(1,particles(i,2)+0.5*H),h_frame));
        hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin);
        
        % Update particle weights
        dist = chi2_cost(hist,hist_target);
        particles_w(i) = 1/(sqrt(2*pi) * sigma_observe) * exp(-dist/(2*sigma_observe*sigma_observe));
        if isnan(particles_w(i))
            particles_w(i) = 0;
        end
    end
    particles_w(:)=particles_w(:)/sum(particles_w);
end
