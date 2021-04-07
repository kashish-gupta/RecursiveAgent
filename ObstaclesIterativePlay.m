% global envVariables agentEnvVariables
%% Agent and Environment
global envVariables agentEnvVariables
agent = load(pwd+"/ObsDataLogs/FlatState_Obs_Size_4_DyEnd_1_DyStart_1.mat",'agent');

% Environment Definition and Variables

agentEnvSize = 4;
ROIFactor = 0;
agentStartState = [4,1];
agentEndState = [4,4];
agentEnvVariables = defEnv(agentEnvSize, ROIFactor, agentStartState, agentEndState);


envSize = 16;
startState = [1,1];
endState= [envSize, envSize]; % Ultimate Goal
envVariables = defEnv(envSize, ROIFactor, startState, endState);

%%
Obstaclelog.Obs = zeros(envSize^2*3,1);
Obstaclelog.agentObs = zeros(agentEnvSize^2*3,1);

ultSteps = 0;
agentSteps = 0;
agentIsDone = false;
ultIsDone = false;

[InitialObservation, LoggedSignals] = ObsGWResetFunction();
[agentInitialObservation, agentLoggedSignals] = agentObsGWResetFunction();

Obstaclelog.Obs(:,1) = InitialObservation;
Obstaclelog.agentObs(:,1) = agentInitialObservation;

level = 1;
agentObs = InitialObservation;
Obs = InitialObservation;
while ~ultIsDone
    agentIsDone = false;
    agentSteps = 0;
    neighbourhoodStateIdxs = [];
    otherVertexIdxs = [];
    possibleEndStates = [];
    errorList = [];
    m = 0;
%     agentPosIdx = agentPosFromEnv(Obs, agentEnvVariables, envVariables);
    onesInObs = find(Obs==1);
    agentPosIdx = onesInObs(1);
    [agentEnvVariables.ObstacleStates, agentEnvVariables.CheckObstacle] = obstacleStatesFromEnv(Obs, agentEnvVariables, envVariables);
%     onesInAgentObs = find(agentObs == 1);
%     agentPosIdx = onesInAgentObs(1);
    if isVertex(agentPosIdx, agentEnvVariables.Size, envVariables.Size)
        neighbourhoodStateIdxs = [agentPosIdx-envVariables.Size;
                                  agentPosIdx+1;
                                  agentPosIdx+envVariables.Size;
                                  agentPosIdx-1]
        otherVertexIdxs = otherVertices(idx2State(agentPosIdx,envVariables.Size), agentEnvVariables.Size, envVariables.Size)
        
        for i = 1:4
            if validIdx(neighbourhoodStateIdxs(i), envVariables.Size) && isVertex(neighbourhoodStateIdxs(i), agentEnvVariables.Size, envVariables.Size) && ~isObstacle(idx2State(neighbourhoodStateIdxs(i), envVariables.Size),envVariables)
                m=m+1;
                possibleEndStates(m) = neighbourhoodStateIdxs(i);
            end
        end
        for i = 1:length(otherVertexIdxs) 
            if validIdx(otherVertexIdxs(i), envVariables.Size) && ~isObstacle(idx2State(neighbourhoodStateIdxs(i), envVariables.Size),envVariables)
                m=m+1;
                possibleEndStates(m) = otherVertexIdxs(i);
            end
        end
            possibleEndStates
            for i = 1:length(possibleEndStates)
            errorList(i) = sum(abs(endState-idx2State(possibleEndStates(i),envVariables.Size)));
            end
            errorList
            [M I] = min(errorList)
            endStateIdx = possibleEndStates(I);
     end
    
    if sum(endStateIdx == neighbourhoodStateIdxs)
    agentPosIdx = recursiveMap(agentPosIdx,agentEnvVariables.Size,envVariables.Size);
    endStateIdx = recursiveMap(endStateIdx,agentEnvVariables.Size,envVariables.Size);
    disp("jump");
    
    else
    agentPosIdx = linearMap(agentPosIdx,agentEnvVariables.Size,envVariables.Size);
    endStateIdx = linearMap(endStateIdx,agentEnvVariables.Size,envVariables.Size);
    end
    agentObs = flattenState(agentPosIdx, endStateIdx, agentEnvVariables);
    
%     agentObs = [agentObs(1);endStateIdx;sum(abs(idx2State(agentObs(1),agentEnvVariables.Size)-idx2State(endStateIdx,agentEnvVariables.Size)))];
    agentLoggedSignals.State = agentObs;
%     ultSteps = ultSteps+1;
%     log.agentObs(:,ultSteps+1) = agentObs;
while ~agentIsDone %|| agentSteps <=20
    agentAction = getAction(agent.agent,agentObs);
    agentSteps = agentSteps+1;
    ultSteps = ultSteps+1;
    %agentLoggedSignals.State = agentObs;
    [agentNextObs, agentReward, agentIsDone, agentLoggedSignals] = agentObsGWStepFunction(agentAction,agentLoggedSignals,agentEnvVariables);
    [NextObs, Reward, ultIsDone, LoggedSignals] = ObsGWStepFunction(agentAction,LoggedSignals,envVariables);
    
    
    agentObs = agentNextObs;
    findOnesAgentObs = find(agentObs ==1);
    Obs = NextObs;
    findOnesObs = find(Obs ==1);
    findOnesAgentObs(1)
    findOnesAgentObs(2)-agentEnvVariables.Size^2
     findOnesObs(1)
     findOnesObs(2) -envVariables.Size^2
    
    
pause
    Obstaclelog.Obs(:,ultSteps+1) = Obs;
    Obstaclelog.agentObs(:,ultSteps+1) = agentObs;
end
%    agentObs = createObsIterative(agentObs, Obs, agentEnvVariables, envVariables);
%    agentObs = createObsIterative(Obs, agentObs, envVariables, agentEnvVariables);
%     agentObs = [1;16;6];
%     agentLoggedSignals.State = agentObs;
%     [NextObs, Reward, ultIsDone, LoggedSignals] = GWStepFunction(3,LoggedSignals,envVariables);
%     ultSteps = ultSteps+1;
%     log.Obs(:,ultSteps+1) = NextObs;
% 
%     [NextObs, Reward, ultIsDone, LoggedSignals] = GWStepFunction(2,LoggedSignals,envVariables);
%     ultSteps = ultSteps+1;
%     log.Obs(:,ultSteps+1) = NextObs;


end


