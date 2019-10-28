function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor in the positive and negative sets
  % and decide based on this neighbor
  [~,distPos] = findnn(histogram,vBoWPos);
  [~,distNeg] = findnn(histogram,vBoWNeg);
  
  if (distPos<distNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
