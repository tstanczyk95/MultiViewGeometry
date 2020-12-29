% This script 
% (1) Loads the pair images and their matched points
% (2) Draw the matching points
% (3) Fit the fundamental matrix 
% (4) Draws the epipolar lines on images and corresponding matches
%% load images and match files for the first example
%%
I1 = imread('../data/library/library1.jpg');
I2 = imread('../data/library/library2.jpg');
matches = load('../data/library/library_matches.txt'); 

N = size(matches,1);
%% display two images side-by-side with matches
%% this code is to help you visualize the matches, you don't need
%% to use it to produce the results for the assignment
%%
plot_correspondence(I1, I2, matches(:,1), matches(:,2), matches(:,3),matches(:,4));
%%

%% first, fit fundamental matrix to the matches ()
F_matrix = estimate_fundamental_matrix(matches(:, 1:2), matches(:, 3:4)); % this is a function that you should implement

%% Draw the epipolar lines on the images and corresponding matches
%%
draw_epipolar_lines(F_matrix, I1, I2, matches(:, 1:2), matches(:, 3:4));

%% Report the residuals from xp * F * x' (the diagonal of 'values' below).
values = ...
        [matches(:, 3:4) ones(size(matches,1), 1)] * ...
        F_matrix * ...
        [matches(:, 1:2) ones(size(matches,1), 1)]';
sprintf("Mean squared value of residuals: %.4f", mean(diag(values) .^ 2))