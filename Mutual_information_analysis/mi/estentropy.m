function h = estentropy(p)
    % Ensure p contains only valid probability values
    p = p(p > 0);
    % Calculate entropy
    h = -sum(p .* log2(p));
end
