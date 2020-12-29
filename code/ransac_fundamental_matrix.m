function [F_matrix, matched_points_a, matched_points_b] = ransac_fundamental_matrix(matches1, matches2)
%   Estimate the fundamental matrix from a set of matching points
%   extracted from two images. RANSAC is used to find a good model and to
%   eliminate outliers from the set.
%
%   Parameters: 
%       matches1: n-by-2 array of image points extracted from the first
%       image.
%       matches2: n-by-2 array of image points extracted from the second
%       image.
%   Output:
%       F_matrix: 3-by-3 rank 2 fundamental matrix derived using the
%       eight-point algorithm on a sample of 8 points from the dataset. The
%       matrix which leads to the highest number of inliers is kept.
%       matched_points_a: k-by-2 array of inliers from the first image.
%       matched_points_b: k-by-2 array of inliers from the second image.

    % Some hyperparameters of the method which can be adjusted.
    N = 250;    % number of RANSAC iterations
    d = 0.01;   % threshold for classifiying inliers/outliers
    s = 8;      % samples used in each RANSAC iteration (minimum 8)
    T = 100;    % minimum acceptable number of inliers (minimum 8)
    
    best_f_matrix = zeros(3,3);
    best_inliers_number = 0;
    best_inliers = [];
    matches_number = size(matches1, 1);
    indices = 1:matches_number;

    % Some number of iterations N
    for i = 1:N
        % s (e.g. 8) correspondeces need to be randomly drawn, based on 
        % which the fundamental matrix will be calculated ("fitting a model 
        % to the sample points")
        random_indices = randsample(indices, s);
        F_matrix = ...
            estimate_fundamental_matrix(matches1(random_indices, :), ...
            matches2(random_indices, :));
        
        % Take all the point correspondences (x, xp) which have NOT been 
        % used to calculate the fundamental matrix
        remaining_indices = setxor(indices, random_indices);
                
        % For each such correspondence:
            % calculate: xp * F * x'  
            % (one is enough, no need to compute x * F' * xp' as well)
            % count correspondence as inlier if the result above is below
            % selected threshold d 
        values = ...
            [matches2(remaining_indices,:) ones(numel(remaining_indices),1)] * ...
            F_matrix * ...
            [matches1(remaining_indices,:) ones(numel(remaining_indices),1)]';
        
        % Result will be (308-s)x(308-s), but we want only relations 
        % between x(j) and xp(j), so only the diagonal values.
        inliers_from_remainders = diag(abs(values) < d);
        inliers_number = sum(inliers_from_remainders);
            
        % The model will be acceptable only if there are T or more inliers.
        if inliers_number < T
            continue;
        end
                
        % Check if current number of inliers is higher than the highest 
        % number of inliers so far
            % If so, then refit the current model using the inliers 
            % (so re-compute the fundamental matrix, this time, use the 
            % inliers found above as the correspondeces)
            % Update the best fundamental matrix and number of inliers.
            
        if inliers_number > best_inliers_number
            inlier_indices = ...
                (remaining_indices .* inliers_from_remainders') ~= 0;
            
            disp("New best number of inliers: ");
            sum(inlier_indices)
            
            best_f_matrix = F_matrix;
            best_inliers_number = inliers_number;
            best_inliers = inlier_indices;
        end
        
    end        
    
    % Return the best fundamental matrix and the set of inliers.
    if isempty(best_f_matrix)
        F_matrix = zeros(3,3);
        matched_points_a = [];
        matched_points_b = [];
        disp("\nNO MATCHING POINTS RETURNED!\n");
    else
        F_matrix = best_f_matrix;
        matched_points_a = matches1(best_inliers, :);
        matched_points_b = matches2(best_inliers, :);
    end
    
end