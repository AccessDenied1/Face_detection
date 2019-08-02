%Detection of Face on the basis of skin color
tic
%for i=20:30
 %clear all;
%close all;
%clc
    %ratio=zeros(3,0);
I=imresize(imread('image/path'),[300,300]);
%imshow(I)
s=size(I);
%%%%%%%%%Convert RGB image to L*a*b*%%%%%%%%%%
cform = makecform('srgb2lab');
J = applycform(I,cform);
%figure;imshow(J);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=J(:,:,2);
%figure;imshow(K);
L=graythresh(J(:,:,2));%getting threshold value for binary converting
BW1=imbinarize(J(:,:,2),L);
%figure;imshow(BW1);
M=graythresh(J(:,:,3));
%figure;imshow(J(:,:,3));
BW2=imbinarize(J(:,:,3),M);
%figure;imshow(BW2);
O=BW1.*BW2;
%figure,imshow(O),title('Skin');
%%%%%%%%%%%%%%%% Patching %%%%%%%%%%%%%%%%%%%%%%%
skin3=O*255;
SN=zeros(s(1),s(2));
for i=1:s(1)-4
    for j=1:s(2)-4
        localSum=sum(sum(skin3(i:i+3, j:j+3)));
        SN(i:i+5, j:j+5)=(localSum>12);
    end
end
 % figure,imshow(SN),title('Removed noise');
Iout=bwareaopen (SN,1920);
%figure,imshow(Iout)
Iout2=imfill(Iout,'holes');
%figure,imshow(Iout2),title('after holes filling and area<1000');
Iout3 = bwperim(Iout2);
st = regionprops(Iout3, 'BoundingBox','Eccentricity');
for i=1:length(st)
ratio(i)=st(i).BoundingBox(4)/st(i).BoundingBox(3);
end
 for i=1:length(st)
 while(ratio(i)>2&&ratio(i)<3.5)
    st(i).BoundingBox(4)=st(i).BoundingBox(4)-(70*(ratio(i)-2));
 ratio(i)=st(i).BoundingBox(4)/st(i).BoundingBox(3);
 end
 while(ratio(i)<=1.1&&ratio(i)>0.8)
   q=(100*(ratio(i)-0.8));
   st(i).BoundingBox(3)=st(i).BoundingBox(3)-q;
  st(i).BoundingBox(1)=st(i).BoundingBox(1)+q/2;
 ratio(i)=st(i).BoundingBox(4)/st(i).BoundingBox(3);
 end
 end
figure;
imshow(I);
hold on;
for i=1:length(st)
if((ratio(i)<=2&&ratio(i)>=0.8)&&(st(i).Eccentricity<1.1&&st(i).Eccentricity>0.4)&&(st(i).BoundingBox(4)>50||st(i).BoundingBox(3)>50))
    val=st(i).BoundingBox;
    rectangle('Position',val, 'EdgeColor','b','LineWidth',2 )
end
end
hold off;
%end
toc
