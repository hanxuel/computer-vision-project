function [particles particles_w] = resample(particles,particles_w)
    idxs = randsample(1:size(particles),size(particles,1),true,particles_w);
    particles = particles(idxs,:);
    particles_w = particles_w(idxs,:);
    particles_w=particles_w/sum(particles_w);
end