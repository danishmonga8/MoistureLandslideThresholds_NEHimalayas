function [Ixy, lambda, diagnostics] = MutualInfo_danish(X, Y)
    % Estimating Mutual Information with Kernel Density Estimators (KDE)
    % as described by Moon et al., 1995.
    %
    % Inputs:
    %   X, Y - data column vectors (nL*1, nL is the record length)
    %
    % Outputs:
    %   Ixy - Estimated mutual information
    %   lambda - scaled mutual information comparable to cross-correlation coefficient
    %   diagnostics - structure containing diagnostic information about the densities
    %
    % Author:
    %   Taesam Lee, Ph.D., Research Associate, INRS-ETE, Quebec, Hydrologist
    %   Date: October 2010
    %
    % Reference:
    %   Moon, Y. I., B. Rajagopalan, and U. Lall (1995), Estimation of Mutual
    %   Information Using Kernel Density Estimators, Phys Rev E, 52(3), 2318-2321.
    
    % Transpose X and Y to make them row vectors, preparing for KDE
    X = X';
    Y = Y';

    % Dimension for KDE
    d = 2;
    nx = length(X);
    
    % Bandwidth calculation using Silverman's rule of thumb
    hx = (4 / (d + 2))^(1 / (d + 4)) * nx^(-1 / (d + 4));

    % Combined data for joint density estimation
    Xall = [X; Y];

    % Initialize the summation variable for mutual information
    sum1 = 0;
    diagnostics.px = zeros(1, nx);
    diagnostics.py = zeros(1, nx);
    diagnostics.pxy = zeros(1, nx);

    % Calculate mutual information using KDE
    for is = 1:nx
        pxy = p_mkde([X(is), Y(is)]', Xall, hx);
        px = p_mkde([X(is)], X, hx);
        py = p_mkde([Y(is)], Y, hx);

        % Store the densities for diagnostics
        diagnostics.px(is) = max(px, 1e-12); % Avoid log of zero
        diagnostics.py(is) = max(py, 1e-12); % Avoid log of zero
        diagnostics.pxy(is) = max(pxy, 1e-12); % Avoid log of zero

        % Calculate the mutual information component, ensuring no negative values
        mi_component = log2(diagnostics.pxy(is) / (diagnostics.px(is) * diagnostics.py(is)));
        sum1 = sum1 + mi_component;
    end

    % Average the mutual information over all samples
    Ixy = sum1 / nx;

    % Calculate lambda as a scaled version of mutual information
    lambda = sqrt(1 - exp(-2 * Ixy));

    % Diagnostic outputs: individual entropies
    diagnostics.Hx = -sum(log2(diagnostics.px)) / nx;
    diagnostics.Hy = -sum(log2(diagnostics.py)) / nx;
    diagnostics.Hxy = -sum(log2(diagnostics.pxy)) / nx;


% Multivariate kernel density estimate function using a normal kernel
function [pxy] = p_mkde(x, X, h)
    % Input:
    %   x - data point for density estimation (d*1 vector)
    %   X - dataset for KDE (dim * number of records)
    %   h - bandwidth for KDE
    %
    % Output:
    %   pxy - estimated density at point x

    s1 = size(X);
    d = s1(1);
    N = s1(2);

    % Covariance matrix of X and its inverse and determinant
    Sxy = cov(X');
    invS = inv(Sxy);
    detS = det(Sxy);
    sum = 0;

    % Kernel density estimation using Gaussian kernel
    for ix = 1:N
        p2 = (x - X(:, ix))' * invS * (x - X(:, ix));
        sum = sum + exp(-p2 / (2 * h^2));
    end

    % Normalize the KDE result
    pxy = 1 / ((2 * pi)^(d/2) * sqrt(detS) * N * h^d) * sum;
    pxy = max(pxy, 0); 
