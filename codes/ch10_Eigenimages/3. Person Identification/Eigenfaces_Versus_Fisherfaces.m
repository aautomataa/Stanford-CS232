% EE368/CS232 Digital Image Processing
% Bernd Girod
% Department of Electrical Engineering, Stanford University

% Script by David Chen, Huizhong Chen, Matt Yu
% Eigenfaces versus Fisherfaces

clc; clear all;

width = 92;
height = 112;
numPixels = width*height;
numClasses = 40;
trainingRange = 1:5;
testingRange = 6:10;
allRange = 1:10;
numSamples = 0;

%% Estimate mean vector
meanVector = 0;
S = [];
for nClass = 1:numClasses
    classSamples{nClass} = [];
    for trainingIdx = trainingRange
        img = im2double(imread(sprintf('att_faces_aligned_lighting/s%d/%d.pgm', nClass, trainingIdx)));
        imgVector = img(:);
        meanVector = meanVector + imgVector;
        S = [S imgVector-meanVector];
        classSamples{nClass}(:,end+1) = imgVector - meanVector;
        numSamples = numSamples + 1;
    end % trainingIdx
end % nClass
meanVector = meanVector / numSamples;
figure(1); clf; set(gcf, 'Color', 'white');
imshow(reshape(meanVector, [height width])); title('Mean Face');

%% Estimate PCA eigenvectors by Sirovich-Kirby method
[V,D] = eig(S.' * S);
PCAEigenvectors = S*V(:,end:-1:1);
for n = 1:size(PCAEigenvectors,2)
    PCAEigenvectors(:,n) = PCAEigenvectors(:,n) / norm(PCAEigenvectors(:,n));
end % n
figure(2); clf; set(gcf, 'Color', 'white');
for n = 1:10
    subplot(2,5,n);
    imshow(reshape(PCAEigenvectors(:,n), [height width]),[]); 
    title(sprintf('Eigenface %d', n));
end % n
% set(gcf, 'Position', [50 50 1000 200]);
numPCAEigenvectorsToKeep = 150;
PCAMatrix = PCAEigenvectors(:,1:numPCAEigenvectorsToKeep).';

%% Estimate LDA eigenvectors
for nClass = 1:numClasses
    classPCAMeanVector = 0;
    classNumSamples(nClass) = 0;
    classPCASamples{nClass} = [];
    for trainingIdx = trainingRange
        img = im2double(imread(sprintf('att_faces_aligned_lighting/s%d/%d.pgm', nClass, trainingIdx)));
        imgVector = img(:) - meanVector;
        PCAVector = PCAMatrix * imgVector;
        classPCASamples{nClass}(:,end+1) = PCAVector;
        classPCAMeanVector = classPCAMeanVector + PCAVector;
        classNumSamples(nClass) = classNumSamples(nClass) + 1;
    end % trainingIdx
    classPCAMeanVector = classPCAMeanVector / classNumSamples(nClass);
    classPCAMeanVectors(:,nClass) = classPCAMeanVector;
end % nClass
PCAMeanVector = mean(classPCAMeanVectors,2);
RB = 0;
RW = 0;
for nClass = 1:numClasses
    deltaVector = classPCAMeanVectors(:,nClass) - PCAMeanVector;
    RB = RB + classNumSamples(nClass) * (deltaVector * deltaVector.');
    for nSample = 1:size(classPCASamples{nClass},2)
        deltaVector = classPCASamples{nClass}(:,nSample) - classPCAMeanVectors(:,nClass);
        RW = RW + (deltaVector * deltaVector.');
    end % nSample
end % nClass
% RW = clipMatrix(RW);
[V,D] = eig(RB, RW);
LDAEigenvectors = V(:,end:-1:1);
for n = 1:size(LDAEigenvectors,2)
    LDAEigenvectors(:,n) = LDAEigenvectors(:,n) / norm(LDAEigenvectors(:,n));
end % n
LDAMatrix = LDAEigenvectors.';
for nClass = 1:numClasses
    classLDASamples{nClass} = [];
    for nSample = 1:size(classPCASamples{nClass},2)
        classLDASamples{nClass}(:,end+1) = LDAMatrix * classPCASamples{nClass}(:,nSample);
    end % nSample
end % nClass
figure(3); clf; set(gcf, 'Color', 'white');
for n = 1:10
    fisherImage = PCAMatrix.' * LDAMatrix.' * LDAEigenvectors(:,n);
    subplot(2,5,n);
    imshow(reshape(fisherImage, [height width]),[]); 
    title(sprintf('Fisherface %d', n));
end % n
% set(gcf, 'Position', [100 100 1000 200]);

%% Measure testing accuracy

accuracyPCA = [];
accuracyLDA = [];
dimensionalityVec = [1:39];
for dimensionality = dimensionalityVec
    disp(sprintf('Dimensionality: %d', dimensionality));
    numQueries = 0;
    numQueriesCorrectPCA = 0;
    numQueriesCorrectLDA = 0;
    for nClass = 1:numClasses
        for testingIdx = testingRange
            % Form PCA and LDA vectors
            img = im2double(imread(sprintf('att_faces_aligned_lighting/s%d/%d.pgm', nClass, testingIdx)));
            imgVector = img(:) - meanVector;
            PCAVector = PCAMatrix * imgVector;
            LDAVector = LDAMatrix * PCAVector;
            numQueries = numQueries + 1;

            % Search for closest match with PCA
            minDist = inf;
            minDistClass = -1;
            for nOtherClass = 1:numClasses
                for nSample = 1:size(classPCASamples{nOtherClass},2)
                    dist = norm(classPCASamples{nOtherClass}(1:dimensionality,nSample) - PCAVector(1:dimensionality));
                    if dist < minDist
                        minDist = dist;
                        minDistClass = nOtherClass;
                    end
                end % nSample
            end % nOtherClass
            if minDistClass == nClass
                numQueriesCorrectPCA = numQueriesCorrectPCA + 1;
            end

            % Search for closest match with PCA
            minDist = inf;
            minDistClass = -1;
            for nOtherClass = 1:numClasses
                for nSample = 1:size(classLDASamples{nOtherClass},2)
                    dist = norm(classLDASamples{nOtherClass}(1:dimensionality,nSample) - LDAVector(1:dimensionality));
                    if dist < minDist
                        minDist = dist;
                        minDistClass = nOtherClass;
                    end
                end % nSample
            end % nOtherClass
            if minDistClass == nClass
                numQueriesCorrectLDA = numQueriesCorrectLDA + 1;
            end

        end % testingIdx
    end % nClass
    disp(sprintf('PCA: %d/%d correct', numQueriesCorrectPCA, numQueries));
    disp(sprintf('LDA: %d/%d correct', numQueriesCorrectLDA, numQueries));
    accuracyPCA(end+1) = numQueriesCorrectPCA / numQueries;
    accuracyLDA(end+1) = numQueriesCorrectLDA / numQueries;
end % dimensionality
figure(4); clf; set(gcf, 'Color', 'white');
h = plot(dimensionalityVec, accuracyLDA, 'r-o', ...
    dimensionalityVec, accuracyPCA, 'b-s'); grid on;
set(h, 'LineWidth', 2);
set(gca, 'FontSize', 14);
xlabel('Number of Dimensions'); ylabel('Identification Rate');
legend('Fisherfaces', 'Eigenfaces', 'Location', 'SE');
axis([0 39 0 1]);