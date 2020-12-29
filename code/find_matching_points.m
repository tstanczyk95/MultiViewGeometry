function [ Points_2D_pic_a, Points_2D_pic_b ] = find_matching_points( pic_a, pic_b )
    pic_a = single(rgb2gray(pic_a));
    pic_b = single(rgb2gray(pic_b));

    % Calculate the SIFT features and matching
    [fleft,dleft]   = vl_sift(pic_a); 
    fprintf('found %d SIFT descriptors in pic a\n',size(fleft,2))
    [fright,dright] = vl_sift(pic_b);     
    fprintf('found %d SIFT descriptors in pic b\n',size(fright,2))
    
    matches = vl_ubcmatch(dleft, dright, 3);

    % Remove scale and orientation information for the matches points
    LeftMatches = fleft(1:2,matches(1,:))';
    RightMatches = fright(1:2,matches(2,:))';

    % Remove duplicate matching pairs
    CombineReduce = unique([LeftMatches RightMatches],'rows');
    Points_2D_pic_a = CombineReduce(:,1:2);
    Points_2D_pic_b = CombineReduce(:,3:4);

end

