%% Tire Models

%% Hoosier 18x7.5-10 R25B (8 in Rim)

% % Input Front and Rear Tire Data
% % Front
% filename_P1F = 'A1654run24.mat';
% [latTrainingData_P1F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P1F);
% 
% filename_P2F = 'A1654run25.mat';
% [latTrainingData_P2F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P2F);
% 
% totDataF = cat(1,latTrainingData_P1F,latTrainingData_P2F);
% trainDataF = totDataF;
% 
% % Rear
% filename_P1R = 'A1654run24.mat';
% [latTrainingData_P1R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P1R);
% 
% filename_P2R = 'A1654run25.mat';
% [latTrainingData_P2R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P2R);
% 
% totDataR = cat(1,latTrainingData_P1R,latTrainingData_P2R);
% trainDataR = totDataR;
% 
% % Front tires
% disp([tire.IDF, ', Front Tire Model is being trained.  Standby...'])
% t1 = tic;
% [model.FxFront, validationRMSE.FxFront] = Trainer_Fx(trainDataF);
% [model.FyFront, validationRMSE.FyFront] = Trainer_Fy(trainDataF);
% [model.MzFront, validationRMSE.MzFront] = Trainer_Mz(trainDataF);
% [model.muyFront, validation.RMSE_muyFront] = Trainer_muy(trainDataF);
% toc(t1)
% 
% disp('Training completed')
% 
% % Rear tires
% disp([tire.IDR, ', Rear Tire Model is being trained.  Standby...'])
% t1 = tic;
% [model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainDataR);
% [model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainDataR);
% [model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainDataR);
% [model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainDataR);
% toc(t1)
% 
% disp('Training completed')

%% Hoosier 16x7.5-10 R20 (8 in Rim)

% % Input Front and Rear Tire Data
% % Front
% filename_P1F = 'A2356run8.mat';
% [latTrainingData_P1F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P1F);
% 
% filename_P2F = 'A2356run9.mat';
% [latTrainingData_P2F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P2F);
% 
% totDataF = cat(1,latTrainingData_P1F,latTrainingData_P2F);
% trainDataF = totDataF;
% 
% % Rear
% filename_P1R = 'A2356run8.mat';
% [latTrainingData_P1R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P1R);
% 
% filename_P2R = 'A2356run9.mat';
% [latTrainingData_P2R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P2R);
% 
% totDataR = cat(1,latTrainingData_P1R,latTrainingData_P2R);
% trainDataR = totDataR;
% 
% % Front tires
% disp([tire.IDF, ', Front Tire Model is being trained.  Standby...'])
% t1 = tic;
% [model.FxFront, validationRMSE.FxFront] = Trainer_Fx(trainDataF);
% [model.FyFront, validationRMSE.FyFront] = Trainer_Fy(trainDataF);
% [model.MzFront, validationRMSE.MzFront] = Trainer_Mz(trainDataF);
% [model.muyFront, validation.RMSE_muyFront] = Trainer_muy(trainDataF);
% toc(t1)
% 
% disp('Training completed')
% 
% % Rear tires
% disp([tire.IDR, ', Rear Tire Model is being trained.  Standby...'])
% t1 = tic;
% [model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainDataR);
% [model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainDataR);
% [model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainDataR);
% [model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainDataR);
% toc(t1)
% 
% disp('Training completed')

%% Hoosier 16x7.5-10 LC0 (8 in Rim)

% % Input Front and Rear Tire Data
% % Front
% filename_P1F = 'A1965run18.mat';
% [latTrainingData_P1F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P1F);
% 
% filename_P2F = 'A1965run19.mat';
% [latTrainingData_P2F,tire.IDF,test.IDF] = createLatTrngDataCalc(filename_P2F);
% 
% totDataF = cat(1,latTrainingData_P1F,latTrainingData_P2F);
% trainDataF = totDataF;
% 
% % Rear
% filename_P1R = 'A1965run18.mat';
% [latTrainingData_P1R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P1R);
% 
% filename_P2R = 'A1965run19.mat';
% [latTrainingData_P2R,tire.IDR,test.IDR] = createLatTrngDataCalc(filename_P2R);
% 
% totDataR = cat(1,latTrainingData_P1R,latTrainingData_P2R);
% trainDataR = totDataR;
% 
% % Front tires
% disp([tire.IDF, ', Front Tire Model is being trained.  Standby...'])
% t1 = tic;
% [model.FxFront, validationRMSE.FxFront] = Trainer_Fx(trainDataF);
% [model.FyFront, validationRMSE.FyFront] = Trainer_Fy(trainDataF);
% [model.MzFront, validationRMSE.MzFront] = Trainer_Mz(trainDataF);
% [model.muyFront, validation.RMSE_muyFront] = Trainer_muy(trainDataF);
% toc(t1)
% 
% disp('Training completed')
% 
% % Rear tires
% disp([tire.IDR, ', Rear Tire Model is being trained.  Standby...'])
% t1 = tic;
% [model.FxRear, validationRMSE.FxRear] = Trainer_Fx(trainDataR);
% [model.FyRear, validationRMSE.FyRear] = Trainer_Fy(trainDataR);
% [model.MzRear, validationRMSE.MzRear] = Trainer_Mz(trainDataR);
% [model.muyRear, validation.RMSE_muyRear] = Trainer_muy(trainDataR);
% toc(t1)
% 
% disp('Training completed')