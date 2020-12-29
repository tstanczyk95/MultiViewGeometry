% This script 
% (1) Loads the house and library images, matches and camera matrices.
% (2) Draw the matching points
% (3) Using the algebraic method of triangulation, determine the 3D
% points for the given matches.
% (4) Visualize the 3D points and the camera center, from different points
% of view.
%%
% Load and display the house data.
I1 = imread('../data/house/house1.jpg');
I2 = imread('../data/house/house2.jpg');
matches = load('../data/house/house_matches.txt');
camera1 = load('../data/house/house1_camera.txt');
camera2 = load('../data/house/house2_camera.txt');
plot_correspondence(I1, I2, matches(:,1), matches(:,2), matches(:,3), matches(:,4));
%%
% Compute the triangulated points and camera centres and visualize
% everything (for the house pictures).
triangulated_points_house = triangulate_points(matches(:, 1:2), matches(:, 3:4), camera1, camera2);
plot_triangulated_points(triangulated_points_house, camera1, camera2);
%%
% Load and display the library data.
I1 = imread('../data/library/library1.jpg');
I2 = imread('../data/library/library2.jpg');
matches = load('../data/library/library_matches.txt');
camera1aaa = load('../data/library/library1_camera.txt');
camera2aaa = load('../data/library/library2_camera.txt');
plot_correspondence(I1, I2, matches(:,1), matches(:,2), matches(:,3), matches(:,4));
%%
% Compute the triangulated points and camera centres and visualize
% everything (for the library pictures).
triangulated_points_library = triangulate_points(matches(:, 1:2), matches(:, 3:4), camera1aaa, camera2aaa);
plot_triangulated_points(triangulated_points_library, camera1aaa, camera2aaa);