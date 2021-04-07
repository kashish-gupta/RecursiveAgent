global envVariables
ROIs = [0];%, 2, 3];
envSize = [4];;
for i = 1:length(envSize)
    for j = 1:length(ROIs)
%% Env through custom functions (rlFunctionEnv)


envVariables.Type = 3; 
envVariables.Size = envSize(i); %Remove k when outside the loop
envVariables.RewardToReachEnd = 10;
envVariables.RewardPerStep = -1;
envVariables.RewardForBumping = -5;
envVariables.RewardForRunningIntoEdge = -2;
envVariables.ROIFactor = 0; %Change it manually, when outside the loop
envVariables.PossibleActions = 1:4;
envVariables.DynamicEndState = true; 
envVariables.DynamicStartState = true; %Initial state always [1,1] when false
envVariables.EndState = [envVariables.Size, envVariables.Size];
envVariables.StartState = [1, 1];
envVariables.DynamicObstacles = true;
%envVariables.ObstacleStates = [2,2; 4,3; 8,5; 8,8; 6,7; 6,8; 3,6; 5,5; 4,5; 6,5; 5,6; 5,7];
% envVariables.ObstacleStates = [envVariables.Size+1 envVariables.Size+1]; 
envVariables.TrainWithObstacles = true; %Change this line for no obstacles.
envVariables.CheckObstacle = false; % This value is internally updated by the reset function and does not depend on .TrainWithObstacles. It will not be used if .TrainWithObstacles is false. 

% Visualzie obstacles
% figure(1)
% plot(envVariables.ObstacleStates(:,1),envVariables.ObstacleStates(:,2),'*')
% axis([1 envVariables.Size 1 envVariables.Size])

run_name = "SMC_FlatState_Obs2_Size_"+num2str(envVariables.Size)+"_DyEnd_"+num2str(envVariables.DynamicEndState)+"_DyStart_"+num2str(envVariables.DynamicStartState);

observationInfo = rlNumericSpec([envVariables.Size^2*3 1]);
observationInfo.Name = 'GWinfo';
observationInfo.Description = '[Start Goal Obstacles] Flattened Array';

actionInfo = rlFiniteSetSpec([1 2 3 4]);
actionInfo.Name = 'GWAction';
actionInfo.Description = 'N, E, S, W';


resetHandle = @()ObsGWResetFunction();
stepHandle = @(Action,LoggedSignals) ObsGWStepFunction(Action,LoggedSignals);

env = rlFunctionEnv(observationInfo,actionInfo,stepHandle,resetHandle);

rng(0);

%% DQN Agent

dnn = [
    featureInputLayer(observationInfo.Dimension(1),'Normalization','none','Name','observation')
    fullyConnectedLayer(100,'Name','CriticStateFC1')
    reluLayer('Name','CriticRelu1')
    fullyConnectedLayer(200,'Name','CriticStateFC1a')
    reluLayer('Name','CriticRelu1a')
    fullyConnectedLayer(100,'Name','CriticStateFC1b')
    reluLayer('Name','CriticRelu1b')
    fullyConnectedLayer(75, 'Name','CriticStateFC2')
    reluLayer('Name','CriticRelu2')
    fullyConnectedLayer(50, 'Name','CriticStateFC3')
    reluLayer('Name','CriticRelu3')
    fullyConnectedLayer(25, 'Name','CriticStateFC4')
    reluLayer('Name','CriticRelu4')
    fullyConnectedLayer(10, 'Name','CriticStateFC5')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(length(actionInfo.Elements),'Name','output')];

%% Agent options

criticOpts = rlRepresentationOptions('LearnRate',0.001,'GradientThreshold',1);
critic = rlQValueRepresentation(dnn,observationInfo,actionInfo,'Observation',{'observation'},criticOpts);

agentOpts = rlDQNAgentOptions(...
    'UseDoubleDQN',true, ...    
    'TargetSmoothFactor',0.1, ...
    'TargetUpdateFrequency',10, ...   
    'ExperienceBufferLength', 10000, ...
    'DiscountFactor',0.9, ...
    'MiniBatchSize',4096);

% agentOpts = rlSARSAAgentOptions('SampleTime',0.5)
agentOpts.EpsilonGreedyExploration.EpsilonDecay = 0.005;
agent = rlDQNAgent(critic,agentOpts);

%% Train Agent

trainOpts = rlTrainingOptions(...
    'MaxEpisodes',3000, ...
    'MaxStepsPerEpisode',4*envVariables.Size, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward', ...
    'StopTrainingValue',envVariables.RewardToReachEnd+1,...
    'ScoreAveragingWindowLength',20, ...
    'SaveAgentDirectory',pwd + "/ObsDataLogs"); 

doTraining = true;
if doTraining    
    % Train the agent.
    trainingStats = train(agent,env,trainOpts);

end

%% Save Agent

save(trainOpts.SaveAgentDirectory + "/"+run_name+".mat",'agent')
save(trainOpts.SaveAgentDirectory + "/"+run_name+"_stats.mat",'trainingStats')
save(trainOpts.SaveAgentDirectory + "/"+run_name+"_envV.mat",'envVariables')

    end
end