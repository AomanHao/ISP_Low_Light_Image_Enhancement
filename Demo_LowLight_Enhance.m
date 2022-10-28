clc
clear
close all
%% 低照度增强 测试程序
addpath('./algorithms/');

conf.name = '2.jpg';
img = imread(['./data/',conf.name]);
conf.savepath = './result/';
if ~exist(conf.savepath,'var')
    mkdir(conf.savepath)
end

%% bypass
algo_type = 'dong_enh_lite';
%% 低照度增强
tic;
switch algo_type
    case  'Ying_2017_CAIP' 
        img = im2double(img);
        alpha=0.6;
        enhan_img = Ying_2017_CAIP(img,alpha).*255;
        
    case 'darklight'
        img = im2double(img);
        img_dark = TooDark(img,0.5,0.38);
        [img_light,W] = TooLight(img_dark,0.5);
        enhan_img = (img_dark.*W+img_light.*(1-W)).*255;
             
    case 'LIME'
        img = im2double(img);
        para.alpha = 0.5;
        para.sigma = 2;
        para.gamma = 0.5;
        [enhan_img, T_ini,T_ref] = LIME(img,para);
        enhan_img = enhan_img.*255;
    case 'RBMP'
        % Mohammad Abid Al-Hashim and Zohair Al-Ameen.
        % "Retinex-Based Multiphase Algorithm for Low-Light Image Enhancement."
        % Traitement du Signal, vol. 37, no. 5, (2020): pp. 733-743.
        % DOI: 10.18280/ts.370505
        img = im2double(img);
        delta=0.25;
        out = RBMP(img, delta);
        enhan_img = out.*255;
        
    case 'IBA'
        %% When you use this code or any part of it, please cite the following article:
        % Zohair Al-Ameen.
        % "Nighttime Image Enhancement Using a New Illumination Boost Algorithm."
        % IET Image Processing, vol. 13, no. 8, (2019): pp. 1314-1320. DOI: 10.1049/iet-ipr.2018.6585
        
        img = im2double(img);
        Lambda = 4;
        out = IBA(img, Lambda);
        enhan_img = out.*255;
        %容易过曝，参数设置
    case 'luminup'
        a=(im2double(img));
        r = a(:,:,1);
        g = a(:,:,2);
        b = a(:,:,3);
        l=0.29;
        %% l is value for luminance. Useful values are limited to pixel value..usually workss better bellow 0.5 and sometimes 0.9 is enough.
        r1=luminup(r,l);       g1=luminup(g,l);        b1=luminup(b,l);
        out=  (cat(3, r1, g1, b1));%.^0.80
        enhan_img = out.*255;
        
    case 'dong'
        img=(im2double(img));
        w=0.8;
        out = dong( img ,w );
        enhan_img = out.*255;

    case 'dong_enh_lite'
        img=(im2double(img));
        w=0.8;
        out = dong_enh_lite( img ,w );
        enhan_img = out.*255;

end
toc;
t=toc;
figure;imshow(uint8(enhan_img));
imwrite(uint8(enhan_img),strcat(conf.savepath,conf.name,'_',algo_type,'-',num2str(t),'.png'));



