% You do not need to modify anything in this function
function [ h ] = plot_correspondence(imgA, imgB, X1, Y1, X2, Y2)

if(max(max(imgA)) > 1)
    imgA = im2single(imgA);
end

if(max(max(imgB)) > 1)
    imgB = im2single(imgB);
end

h = figure;
Height = max(size(imgA,1),size(imgB,1));
Width = size(imgA,2)+size(imgB,2);
numColors = size(imgA, 3);
newImg = zeros(Height, Width, numColors);
newImg(1:size(imgA,1),1:size(imgA,2),:) = imgA;
newImg(1:size(imgB,1),1+size(imgA,2):end,:) = imgB;
imshow(newImg, 'Border', 'tight')
shiftX = size(imgA,2);
hold on
% set(h, 'Position', [100 100 900 700])
for i = 1:size(X1,1)
    cur_color = rand(3,1);
    plot([X1(i) shiftX+X2(i)],[Y1(i) Y2(i)],'*-','Color', cur_color, 'LineWidth',2)
end
hold off