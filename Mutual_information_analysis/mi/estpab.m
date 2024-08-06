function [p12, p1, p2] = estpab(vec1, vec2)
    % Calculate joint probability matrix
    jointTable = accumarray([vec1, vec2], 1);
    p12 = jointTable / sum(jointTable, 'all');
    
    % Calculate marginal probabilities
    p1 = sum(jointTable, 2) / sum(jointTable, 'all');
    p2 = sum(jointTable, 1) / sum(jointTable, 'all');
end
