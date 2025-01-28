function faceAlignment(dataFolder, targetFolder)
run('CLASS_facepipe_VJ_29-Sep-08b/init.m');
doFaceAlignment(opts, dataFolder, targetFolder);
end

function doFaceAlignment(opts, dataFolder, targetFolder)
if ~exist(targetFolder)
    mkdir(targetFolder)
end

database = dir(dataFolder);


faceDetector = vision.CascadeObjectDetector();
for i = 1:size(database)
    if strcmp(database(i).name, '.') || strcmp(database(i).name, '..')
        continue
    end
    
    img = imread(sprintf('%s/%s', dataFolder, database(i).name));

    fbox = step(faceDetector, img);
    
    %only keep faces that are at least 30 pixels in size
    fbox = fbox(find(fbox(:,3) >= 30), :);
    numFaces = size(fbox,1);
    if numFaces > 1
       %  select largest face if more than 1 face is detected
        selFace = find(fbox(:,3) == max(fbox(:,3)));
        fbox = fbox(selFace, :);
    end
    
    % Format detected faces to DET structure which will be used in detecting
    % facial landmarks. DET(:, [1 2]) are the x,y centers of detected face,
    % DET(:, 3) is the half width
    P = [];
    if isempty(fbox)
        DET(1) = mean([1, size(img, 2)]);
        DET(2) = mean([1, size(img, 1)]);
        DET(3) = 0.7*DET(1);
    else
        DET = zeros(size(fbox,1), 3);
        DET(1) = fbox(1) + fbox(3)/2;
        DET(2) = fbox(2) + fbox(4)/2;
        DET(3) = DET(1) - fbox(1);
    end
        
    P=findparts(opts.model,img,DET');
    
    if ~isempty(P)
        FaceEyes = [mean(P(1,1:2)) mean(P(2,1:2)) mean(P(1,3:4)) mean(P(2,3:4))];
%         figure; imshow(img); hold on; plot(FaceEyes([1,3]), FaceEyes([2,4]), 'r*'); hold off
        faceIm_aligned = uint8(cropPersonRotate(double(img),FaceEyes, 50, 2));
    else
        faceIm_aligned = img;
    end
    
    imwrite(faceIm_aligned, sprintf('%s/%s', targetFolder, database(i).name), 'quality', 100);
end
end