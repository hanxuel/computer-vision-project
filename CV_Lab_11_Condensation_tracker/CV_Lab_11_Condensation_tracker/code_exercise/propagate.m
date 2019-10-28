function particles = propagate(particles,sizeFrame,params)
model = params.model;
sigma_pos = params.sigma_position;
sigma_vel = params.sigma_velocity;
H = sizeFrame(1);
W = sizeFrame(2);
w = zeros(size(particles));
% If no motion, state length = 2, A is 2x2 matrix
if model == 0
    A = eye(2);
elseif model == 1
    A = eye(4);
    A(1,3) = 1;
    A(2,4) = 1;
end
for i = 1:size(particles,1)
    w(i,1:2) = normrnd(0,sigma_pos,[1,2]);
    if model == 1
        w(i,3:4) = normrnd(0,sigma_vel,[1,2]);
    end
    prediction = (A * particles(i,:)' + w(i,:)')';
    if prediction(1,1) > W
        prediction(1,1) = W;
    end
    if prediction(1,1) < 1
        prediction(1,1) = 1;
    end
    if prediction(1,2) > H
        prediction(1,2) = H;
    end
    if prediction(1,2) < 1
        prediction(1,2) = 1;
    end
    particles(i,:) = prediction;
end
end

    