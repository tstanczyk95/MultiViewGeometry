function triangulated_points = triangulate_points(matches1, matches2, camera1, camera2)
%   Given a set of matching image points and camera matrices, determine
%   for each point the corresponding 3D point through algebraic
%   triangulation.
%
%   Parameters: 
%       matches1: n-by-2 array of image points extracted from the first
%       image.
%       matches2: n-by-2 array of image points extracted from the second
%       image.
%       camera1:  3-by-4 camera matrix for the camera corresponding to the
%       first image.
%       camera2:  3-by-4 camera matrix for the camera corresponding to the
%       second image.
%   Output:
%       triangulated_points: 4-by-n array of world points (in homogeneous
%       coordinates with w=1) corresponding to the original image points.

    triangulated_points = [];
    for i = 1:size(matches1,1)
        % For each point, build the homogeneous system minimizing the algebraic
        % error.
        p1 = matches1(i, :);
        p2 = matches2(i, :);
        A = [p1(2) * camera1(3,:) - camera1(2,:);
         p1(1) * camera1(3,:) - camera1(1,:);
         p2(2) * camera2(3,:) - camera2(2,:);
         p2(1) * camera2(3,:) - camera2(1,:)];

        % Solve the system by performing SVD decomposition and taking the last
        % column of V.
        [U, S, V] = svd(A);
        point = V(:, 4);

        % Divide the point by its last component (as it's in homogeneous
        % coordinates).
        point = point ./ point(4);
        triangulated_points = [triangulated_points point];
    end

end

