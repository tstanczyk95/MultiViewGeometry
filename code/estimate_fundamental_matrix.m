function F_matrix = estimate_fundamental_matrix(matches1, matches2)
%   Estimate the fundamental matrix from a set of matching points
%   extracted from two images.
%
%   Parameters: 
%       matches1: n-by-2 array of image points extracted from the first
%       image.
%       matches2: n-by-2 array of image points extracted from the second
%       image.
%   Output:
%       F_matrix: 3-by-3 rank 2 fundamental matrix derived using the
%       eight-point algorithm on the given matching points.

      % First, set up the Af=0 system. Just need to build the A matrix with all
      % the matches. It should be of size 309 x 9.
      x1 = matches1(:,1);
      y1 = matches1(:,2);
      x1p = matches2(:,1);
      y1p = matches2(:,2);
      A = [x1.*x1p x1.*y1p x1 x1p.*y1 y1.*y1p y1 x1p y1p ones(size(matches1 ,1),1)];
      %%
      % We need the smallest eigenvector of A'*A, but we don't have to compute
      % that. We can perform SVD on A.
      [U, S, V] = svd(A);

      % The lowest singular value is the last one, so we can just take out the
      % corresponding vector and have the solution of the homogeneous system.
      f = V(:, 9);
      %%
      % Now, we need to force f to be of rank 2, and that will give us the final
      % fundamental matrix.
      F_matrix = reshape(f, 3, 3);
      [Uf, Sf, Vf] = svd(F_matrix);

      % Set the smallest singular value to 0 and reconstruct F.
      Sf(3,3) = 0;
      F_matrix = Uf * Sf * Vf';
end
