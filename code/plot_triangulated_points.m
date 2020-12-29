function plot_triangulated_points(triangulated_points, camera1, camera2)
%   Given a set of triangulated 3D points and two camera matrices, create a
%   3D scatterplot of all the points.
%
%   Parameters: 
%       triangulated_points: 4-by-n array of world points (in homogeneous
%       coordinates with w=1)
%       camera1:  3-by-4 camera matrix for the camera corresponding to the
%       first image.
%       camera2:  3-by-4 camera matrix for the camera corresponding to the
%       second image.

    % Find the camera center as the last column of the V matrix in the camera
    % matrix's SVD decompositions.
    [U1, S1, V1] = svd(camera1);
    [U2, S2, V2] = svd(camera2);
    camera_centre1 = V1(:, 4);
    camera_centre2 = V2(:, 4);

    % The centres are in homogeneous coordinates, so we need to divide by their
    % last component.
    camera_centre1 = camera_centre1 ./ camera_centre1(4);
    camera_centre2 = camera_centre2 ./ camera_centre2(4);

    % Create the 3D plot of the triangulated points and the two camerae
    % centres.
    figure;
    scatter3(triangulated_points(1,:), triangulated_points(3,:), triangulated_points(2,:))
    hold on;
    scatter3(camera_centre1(1), camera_centre1(3), camera_centre1(2));
    scatter3(camera_centre2(1), camera_centre2(3), camera_centre2(2));
    legend("Triangulated points", "Camera 1", "Camera 2");
    axis equal;
    hold off;
end

