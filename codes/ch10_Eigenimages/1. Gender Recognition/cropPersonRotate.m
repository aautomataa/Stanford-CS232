function [pp,invsout] = cropPersonRotate(img, poslxlyrxry, pixelsPerIED, numberIED)
%input is an image img and
% poslxlyrxry, a vector (1x4) of 4 numbers
%indicating the left eye (x and y) and right eye (x and y) 
% positions.
% pp is the cropped version of the person
% (from center of eyes. Left to right is -+ 3 IED
% top to bottom is -3+7 IED
% and invsout shows which pixels to "count". 
% also rotates the resulting face to the upright position. 

ex = poslxlyrxry([1 3]);
ey = poslxlyrxry([2 4]);

 %   [ex,ey] = ginput(2); % left then right eye
  %  eyes(i,:,:) = [ex ey];
    %%crop out the face. 
    cent = [mean(ex) mean(ey)];
    eyeD = sqrt(sum(  [ex(1)-ex(2) ey(1)-ey(2)]   .^2));
    
    % Compute the rotation matrix. 
    Direction = [ex(2)-ex(1);ey(2)-ey(1)];
    Direction = Direction./sqrt(Direction'*Direction);
    PerpDir = flipud(Direction);
    PerpDir(1) =-PerpDir(1); 
    %Compute the Rotation Matrix
    RotMatrix = [ Direction PerpDir];  % this can be used to rotate the face. 
    
    
   % define the crop region:
   esize = eyeD;
   ss = size(img); 
%    faceOval = 1.51;  %ratio of height to width of the face
    faceOval = 1.45;
   
   rrm = max([(cent(2)-numberIED*esize) 1]) ;
   rrx =  min([(cent(2)+numberIED*esize*faceOval) ss(1)]); 
   ccm = max([(cent(1)-numberIED*esize) 1]);
   ccx = min([(cent(1)+numberIED*esize) ss(2)]); 
%   
%   cropped = B(  rrm:rrx,ccm:ccx, :);
   %cropped = imresize(cropped,[75 75]);
 %  figure
 %  imagesc(cropped);
   %obfaces{i} = cropped;
  %%% try explicitly resampling:
   %%  pixelsPerIED = 16; 
     es2 = esize/pixelsPerIED;
     
     %find even int < es2;
     oddint = floor(es2); 
     if(floor(oddint/2)*2 == oddint) oddint = oddint-1; 
     end
     if(oddint<1) oddint=1; 
     end
     fsize = [1 oddint];
     hh = fspecial('average',fsize); 
     img(:,:,1) = imfilter(img(:,:,1),hh,'symmetric');
%      img(:,:,2) = imfilter(img(:,:,2),hh,'symmetric');
%      img(:,:,3) = imfilter(img(:,:,3),hh,'symmetric');
     img(:,:,1) = imfilter(img(:,:,1),hh','symmetric');
%      img(:,:,2) = imfilter(img(:,:,2),hh','symmetric');
%      img(:,:,3) = imfilter(img(:,:,3),hh','symmetric');
     
        %these are the sampling locations.
%    [coli,rowi] = meshgrid([-numberIED*esize:es2:numberIED*esize]+cent(1), [-numberIED*esize:es2:numberIED*esize]+cent(2) ) ;
     [coli,rowi] = meshgrid([-numberIED*esize:es2:numberIED*esize], [-numberIED*esize:es2:numberIED*esize*faceOval] ) ;
     sss = size(coli); %rowi has the same size
     %rotate the grid
     allcoords = [coli(:) rowi(:)];
     allcoords = (RotMatrix*allcoords')';
     coli = reshape(allcoords(:,1),sss);
     rowi = reshape(allcoords(:,2),sss);
     coli = coli+cent(1); 
     rowi = rowi+cent(2); 
     %size(img)
     %ss
   
   %zi = interp2(rr,cc,cim,yi,xi );
   ziR = interp2(1:1:ss(2),[1:1:ss(1)]',double(img(:,:,1)),coli,rowi ,'cubic');
%    ziG = interp2(1:1:ss(2),[1:1:ss(1)]',double(img(:,:,2)),coli,rowi ,'cubic');
%    ziB = interp2(1:1:ss(2),[1:1:ss(1)]',double(img(:,:,3)),coli,rowi ,'cubic');
   pp(:,:,1) = (ziR); 
%    pp(:,:,2) = (ziG); pp(:,:,3) = (ziB); 
   pp( isnan(pp)) = 0; 
   
   img2 = img(:,:,1)*0+1; 
   yiR = interp2(1:1:ss(2),[1:1:ss(1)]',double(img2(:,:)),coli,rowi );
   invsout = yiR==1; 
   pp(:,:,1) =pp(:,:,1).*invsout;  
%    pp(:,:,2) =pp(:,:,2).*invsout;  
%    pp(:,:,3) =pp(:,:,3).*invsout;  
   