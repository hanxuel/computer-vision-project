function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words
p_car=0.5;
p_noncar=0.5;

p_hist_car=exp(nansum(log(normpdf(histogram,muPos,sigmaPos))));
p_hist_noncar=exp(nansum(log(normpdf(histogram,muNeg,sigmaNeg))));

if p_car*p_hist_car>p_noncar*p_hist_noncar
    label=1;
else
    label=0;
end

end