temp = load('dataset.mat');
objects = temp.objects;

nbObjects = length(objects);
nsamp = 100;
x=get_samples(objects(6).X,nsamp);
y=get_samples(objects(7).X,nsamp);
shape_matching(x,y,1);