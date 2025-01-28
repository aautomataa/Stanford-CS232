% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen, Huizhong Chen, Matt Yu 
% Gender recognition using eigenfaces and fisherfaces

clc; clear all;

%% Get images

alignLabel = '_aligned';
% alignLabel = '';
alignCropY = 11:190;
alignCropX = 34:173;
normalizeStd = 0;
targetStd = 0.3;
imageFiles = cell(1, 2);
dataFolders = {['Data' alignLabel '/Male'], ['Data' alignLabel '/Female']};
for nClass = 1:2
    imageFiles{nClass} = list_dir(dataFolders{nClass}, '.jpg');
end % nClass
trainingIndices = 1:2:length(imageFiles{1});
testingIndices = 2:2:length(imageFiles{2});

%% Compute mean faces
disp('Mean faces');

meanFaces = cell(1, 2);
meanSamples{1} = trainingIndices;
meanSamples{2} = trainingIndices;
for nClass = 1:2
    numSamples = 0;
    for nImage = meanSamples{nClass};
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        if nImage == meanSamples{nClass}(1)
            meanFaces{nClass} = img;
        else
            meanFaces{nClass} = meanFaces{nClass} + img;
        end
        numSamples = numSamples + 1;
    end % nImage
    meanFaces{nClass} = meanFaces{nClass} / numSamples;
end % nClass
meanFace = 0.5*(meanFaces{1} + meanFaces{2});
figure(1); clf;
subplot(1,3,1); imshow(meanFace);
subplot(1,3,2); imshow(meanFaces{1});
subplot(1,3,3); imshow(meanFaces{2});
imwrite(meanFaces{1}, 'Results/mean_face_1.jpg');
imwrite(meanFaces{2}, 'Results/mean_face_2.jpg');
imwrite(meanFace, 'Results/mean_face.jpg');
imgSize = size(meanFace);

%% Compute eigenfaces
disp('Eigenfaces');

S = [];
for nClass = 1:2
    for nImage = trainingIndices
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        imgZeroMean = img - meanFace;
        S = [S im2vec(imgZeroMean)];
    end % nImage
end % nClass
[V,D] = eig(S'*S);
V = V(:,end:-1:1);
eigenfaces = S*V;
for n = 1:size(eigenfaces,2)
    eigenfaces(:,n) = eigenfaces(:,n) / norm(eigenfaces(:,n));
end % n
figure(2); clf;
for n = 1:20
    subplot(4,5,n);
    eigenface = reshape(eigenfaces(:,n), imgSize);
    imshow(eigenface,[]);
    minVal = min(eigenface(:));
    maxVal = max(eigenface(:));
    range = maxVal - minVal;
    imwrite((eigenface-minVal)/range,sprintf('Results/eigenface_%02d.jpg', n));
end % n
clear S V D;

%% Compute recognition scores for single eigenface

disp('Testing accuracy');
eigenface = reshape(eigenfaces(:,1), imgSize);
scores = cell(1,2);
for nClass = 1:2
    scores{nClass} = [];
    for nImage = testingIndices
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        imgZeroMean = img - meanFace;
        scores{nClass}(end+1) = sum(sum( imgZeroMean .* eigenface ));
    end % nImage
end % nClass
histBins = linspace(-50, 50, 100);
histMale = hist(scores{1}, histBins);
histFemale = hist(scores{2}, histBins);
pmfMale = histMale / sum(histMale);
pmfFemale = histFemale / sum(histFemale);
cdfMale = cumsum(pmfMale);
cdfFemale = cumsum(pmfFemale);
[minDist, minIdx] = min(abs(1 - cdfFemale - cdfMale));
eigenfaceThreshold = histBins(minIdx);
EER = 0.5*(cdfMale(minIdx) + 1 - cdfFemale(minIdx));
if dot(pmfMale,histBins) < dot(pmfFemale,histBins)
    EER = 1 - EER;
end
EER
figure(4); clf; set(gcf, 'Color', 'w');
h = plot(histBins, pmfMale, 'b-', ...
    histBins, pmfFemale, 'r--', ...
    histBins(minIdx)*ones(1,100), linspace(0,max(pmfMale)), 'k--');
set(h, 'LineWidth', 2);
set(gca, 'FontSize', 12);
xlabel('Projection Score'); ylabel('Probability');
legend('Male', 'Female');
pause

disp('Training accuracy');
scores = cell(1,2);
for nClass = 1:2
    scores{nClass} = [];
    for nImage = trainingIndices
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        imgZeroMean = img - meanFace;
        scores{nClass}(end+1) = sum(sum( imgZeroMean .* eigenface ));
    end % nImage
end % nClass
histMale = hist(scores{1}, histBins);
histFemale = hist(scores{2}, histBins);
pmfMale = histMale / sum(histMale);
pmfFemale = histFemale / sum(histFemale);
cdfMale = cumsum(pmfMale);
cdfFemale = cumsum(pmfFemale);
[minDist, minIdx] = min(abs(1 - cdfFemale - cdfMale));
EER = 0.5*(cdfMale(minIdx) + 1 - cdfFemale(minIdx));
if dot(pmfMale,histBins) < dot(pmfFemale,histBins)
    EER = 1 - EER;
end
EER
figure(4); clf;
h = plot(histBins, pmfMale, 'b-', ...
    histBins, pmfFemale, 'r--', ...
    histBins(minIdx)*ones(1,100), linspace(0,max(pmfMale)), 'k--');
set(h, 'LineWidth', 2);
set(gca, 'FontSize', 12);
xlabel('Projection Score'); ylabel('Probability');
legend('Male', 'Female');

%% Compute recognition score for multiple eigenfaces

disp('Generating training coefficients');
trainingCoeff = cell(1,2);
numEigenfaces = size(eigenfaces,2);
for nClass = 1:2
    trainingCoeff{nClass} = [];
    for nImage = trainingIndices
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        imgZeroMean = img - meanFace;
        coeff = zeros(numEigenfaces, 1);
        for nEig = 1:length(coeff)
            coeff(nEig) = dot(imgZeroMean(:), eigenfaces(:,nEig));
        end % nEig
        trainingCoeff{nClass}(:,end+1) = coeff;
    end % nImage
end % nClass

numEigVec = 1 : 8;
% numEigVec = 1 : 10 : 81;
accuracies1NN = [];
for numEig = numEigVec
    numCorrect1NN = 0;
    numCorrectKNN = 0;
    k = 3;
    numQueried = 0;
    for nClass = 1:2
        for nImage = testingIndices
            imageFile = imageFiles{nClass}{nImage};
            img = im2double(imread(imageFile));
            if strcmp(alignLabel, '_aligned')
                img = img(alignCropY, alignCropX);
            end
            if normalizeStd == 1
                img = img * targetStd / std2(img);
            end
            imgZeroMean = img - meanFace;
            coeff = zeros(numEigenfaces, 1);
            for nEig = 1:length(coeff)
                coeff(nEig) = dot(imgZeroMean(:), eigenfaces(:,nEig));
            end
            distances = [];
            labels = [];
            for nOtherClass = 1:2
                for nOtherSample = 1:size(trainingCoeff{nOtherClass},2)
                    range = 1:numEig;
                    v1 = coeff(range);
                    v2 = trainingCoeff{nOtherClass}(range,nOtherSample);
                    distances(end+1) = norm(v1 - v2);
                    labels(end+1) = nOtherClass;
                end % nOtherSample
            end % nOtherClass
            [distances,sortIdx] = sort(distances, 'ascend');
            numQueried = numQueried + 1;
            if numEig == 1
                if coeff(1) > eigenfaceThreshold
                    label1NN = 1;
                else
                    label1NN = 2;
                end
            else
                label1NN = labels(sortIdx(1));
            end
            if label1NN == nClass
                numCorrect1NN = numCorrect1NN + 1;
            end
        end % nImage
    end % nClass
    disp(sprintf('Eigenvectors %d, Correct 1NN %d/%d (%.2f)', ...
        numEig, numCorrect1NN, numQueried, numCorrect1NN/numQueried));
    accuracies1NN(end+1) = numCorrect1NN / numQueried;
end % numEig
figure(5); clf; set(gcf, 'Color', 'w');
h = plot(numEigVec, accuracies1NN*100, 'b-o'); grid on;
set(h, 'LineWidth', 2);
set(gca, 'FontSize', 14);
xlabel('Number of Eigenfaces'); ylabel('Recognition Rate');
axis([min(numEigVec) max(numEigVec) 40 100]);

%% Compute Fisher faces
disp('Fisherfaces');

ds = 0.25;
deltaMean1 = im2vec( imresize(meanFaces{1},ds) - imresize(meanFace,ds) );
RB = length(imageFiles{1}) * deltaMean1*deltaMean1';
deltaMean2 = im2vec( imresize(meanFaces{2},ds) - imresize(meanFace,ds) );
RB = RB + length(imageFiles{2}) * deltaMean2*deltaMean2';
RW = 0;
for nClass = 1:2
    for nImage = trainingIndices
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        imgZeroMean = img;
        delta = im2vec( imresize(imgZeroMean - meanFaces{nClass},ds) );
        RW = RW + delta*delta';
    end % nImage
end % nClass
RW = clipMatrix(RW);
[V,D] = eigs(RB, RW, 1);
fisherfaces = V;
fisherfaces = fisherfaces / norm(fisherfaces);
figure(3); clf;
for n = 1
    fisherface = reshape(fisherfaces(:,n), imgSize*ds);
    fisherface = imresize(fisherface, 1/ds);
    fisherface = fisherface / norm(fisherface(:));
    imshow(fisherface,[]); colorbar;
    minVal = min(fisherface(:));
    maxVal = max(fisherface(:));
    range = maxVal - minVal;
    imwrite((fisherface-minVal)/range,sprintf('Results/fisherface_%02d.jpg', n));
end % n
save('Results/fisherface.mat', 'fisherface');

%% Compute recognition scores for single Fisherface

disp('Testing accuracy');
scores = cell(1,2);
for nClass = 1:2
    scores{nClass} = [];
    for nImage = testingIndices
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        imgZeroMean = img  - meanFace;
        scores{nClass}(end+1) = sum(sum( imgZeroMean .* fisherface ));
    end % nImage
end % nClass
histBins = linspace(-30, 30, 100);
histMale = hist(scores{1}, histBins);
histFemale = hist(scores{2}, histBins);
pmfMale = histMale / sum(histMale);
pmfFemale = histFemale / sum(histFemale);
cdfMale = cumsum(pmfMale);
cdfFemale = cumsum(pmfFemale);
[minDist, minIdx] = min(abs(1 - cdfMale - cdfFemale));
EER = 0.5*(cdfFemale(minIdx) + 1 - cdfMale(minIdx))
figure(4); clf;
h = plot(histBins, pmfMale, 'b-', ...
    histBins, pmfFemale, 'r--', ...
    histBins(minIdx)*ones(1,100), linspace(0,max(pmfMale)), 'k--');
set(h, 'LineWidth', 2);
set(gca, 'FontSize', 12);
xlabel('Projection Score'); ylabel('Probability');
legend('Male', 'Female');
pause

disp('Training accuracy');
scores = cell(1,2);
for nClass = 1:2
    scores{nClass} = [];
    for nImage = trainingIndices
        imageFile = imageFiles{nClass}{nImage};
        img = im2double(imread(imageFile));
        if strcmp(alignLabel, '_aligned')
            img = img(alignCropY, alignCropX);
        end
        if normalizeStd == 1
            img = img * targetStd / std2(img);
        end
        imgZeroMean = img  - meanFace;
        scores{nClass}(end+1) = sum(sum( imgZeroMean .* fisherface ));
    end % nImage
end % nClass
histMale = hist(scores{1}, histBins);
histFemale = hist(scores{2}, histBins);
pmfMale = histMale / sum(histMale);
pmfFemale = histFemale / sum(histFemale);
cdfMale = cumsum(pmfMale);
cdfFemale = cumsum(pmfFemale);
[minDist, minIdx] = min(abs(1 - cdfMale - cdfFemale));
EER = 0.5*(cdfFemale(minIdx) + 1 - cdfMale(minIdx))
figure(4); clf;
h = plot(histBins, pmfMale, 'b-', ...
    histBins, pmfFemale, 'r--', ...
    histBins(minIdx)*ones(1,100), linspace(0,max(pmfMale)), 'k--');
set(h, 'LineWidth', 2);
set(gca, 'FontSize', 12);
xlabel('Projection Score'); ylabel('Probability');
legend('Male', 'Female');