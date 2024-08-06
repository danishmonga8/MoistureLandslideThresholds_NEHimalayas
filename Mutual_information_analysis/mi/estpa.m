function p = estpa(data)
    % Unique values and their corresponding counts
    [unique_vals, ~, idx] = unique(data);
    counts = accumarray(idx, 1);
    % Probability of each unique value
    p = counts / sum(counts);
end
