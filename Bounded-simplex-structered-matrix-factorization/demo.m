clear
clc
load('mnist.mat');
addpath(genpath('src/.'));

r = 12;
[m,n] = size(X);
ub = max(max(X));
lb = min(min(X));
W = rand(m,r)*(ub-lb)+lb;
H = SimplexColProj(rand(r,n));

options.maxiter = 200;
options.W = W;
options.H = H;

[Wb1,Hb1,err1,err_time1] = mdSSMF(X,r,options);
[Wb2,Hb2,err2,err_time2] = boundedSSMF(X,r,options);

figure(1)
subplot(1,3,1);
imshow(imresize(Wb1*Hb1,8));
title('BG');
subplot(1,3,2);
imshow(imresize(Wb2*Hb2,8));
title('PG');
subplot(1,3,3);
imshow(imresize(X,8));
title('Original');


% figure(2)
% plot(1:size(err1,2),err1,'b','LineWidth',2)
% hold on
% plot(1:size(err2,2),err2,'r','LineWidth',2)
% legend('BG','PG')
% title('Error')

figure(3)
plot(1:size(err_time1,2),err_time1,'b','LineWidth',2)
hold on
plot(1:size(err_time2,2),err_time2,'r','LineWidth',2)
legend('BG','PG')
xlabel('Iteration')
ylabel('Running time')
title('MNIST')

figure(4)
subplot(1,2,1)
imagesc(Wb1)
colormap(gray)
colorbar
title('X')
subplot(1,2,2)
imagesc(Hb1)
colormap(gray)
colorbar
title('Y')

figure(5)
subplot(1,2,1)
imagesc(Wb1)
colormap(gray)
colorbar
title('X')
subplot(1,2,2)
imagesc(Hb1)
colormap(gray)
colorbar
title('Y')













