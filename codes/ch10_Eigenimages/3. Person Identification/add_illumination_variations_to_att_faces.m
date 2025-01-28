% add_illumination_variations_to_att_faces

for i = 1:40
    for j = 1:10
        img = im2double(imread(sprintf('att_faces_aligned/s%d/%d.pgm', i, j)));
        img = addIllumination(img);
        imwrite(img, sprintf('att_faces_aligned_lighting/s%d/%d.pgm', i, j));
        imwrite(img, sprintf('att_faces_aligned_lighting/s%d/%d.jpg', i, j));
    end % j
end % i