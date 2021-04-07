
%% Agent and Environment

agent = load(pwd+"/DataLogs/Size_4_ROI_0_DyEnd_1_DyStart_1.mat",'agent');

% Environment Definition and Variables

agentEnvSize = 4;
ROIFactor = 0;
agentStartState = [4,1];
agentEndState = [4,4];
agentEnvVariables = defEnv(agentEnvSize, ROIFactor, agentStartState, agentEndState);


envSize = 16;
startState = [1,1];
endState= [envSize, envSize-4]; % Ultimate Goal
envVariables = defEnv(envSize, ROIFactor, startState, endState);

%%
log.Obs = [0;0;0];
log.agentObs = [0;0;0];

ultSteps = 0;
agentSteps = 0;
agentIsDone = false;
ultIsDone = false;

[InitialObservation, LoggedSignals] = GWResetFunction(envVariables);
[agentInitialObservation, agentLoggedSignals] = GWResetFunction(agentEnvVariables);

log.Obs(:,1) = InitialObservation;
log.agentObs(:,1) = agentInitialObservation;

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
    agentObs = Obs;
    if isVertex(agentObs(1), agentEnvVariables.Size, envVariables.Size)
        neighbourhoodStateIdxs = [agentObs(1)-envVariables.Size;
                                  agentObs(1)+1;
                                  agentObs(1)+envVariables.Size;
                                  agentObs(1)-1];
        otherVertexIdxs = otherVertices(idx2State(agentObs(1),envVariables.Size), agentEnvVariables.Size, envVariables.Size);
        
        for i = 1:4
            if validIdx(neighbourhoodStateIdxs(i), envVariables.Size) && isVertex(neighbourhoodStateIdxs(i), agentEnvVariables.Size, envVariables.Size)
                m=m+1;
                possibleEndStates(m) = neighbourhoodStateIdxs(i);
            end
        end
        for i = 1:length(otherVertexIdxs)
            if validIdx(otherVertexIdxs(i), envVariables.Size)
                m=m+1;
                possibleEndStates(m) = otherVertexIdxs(i);
            end
        end
  
            for i = 1:length(possibleEndStates)
            errorList(i) = sum(abs(endState-idx2State(possibleEndStates(i),envVariables.Size)));
            end
            [M I] = min(errorList);
            endStateIdx = possibleEndStates(I);
        end
    
    if sum(endStateIdx == neighbourhoodStateIdxs)
    agentObs(1) = recursiveMap(agentObs(1),agentEnvVariables.Size,envVariables.Size);
    endStateIdx = recursiveMap(endStateIdx,agentEnvVariables.Size,envVariables.Size);
    
    else
    agentObs(1) = linearMap(agentObs(1),agentEnvVariables.Size,envVariables.Size);
    endStateIdx = linearMap(endStateIdx,agentEnvVariables.Size,envVariables.Size);
    end
    
    agentObs = [agentObs(1);endStateIdx;sum(abs(idx2State(agentObs(1),agentEnvVariables.Size)-idx2State(endStateIdx,agentEnvVariables.Size)))];
    agentLoggedSignals.State = agentObs;
%     ultSteps = ultSteps+1;
%     log.agentObs(:,ultSteps+1) = agentObs;
while ~agentIsDone %|| agentSteps <=20
    agentAction = getAction(agent.agent,agentObs);
    agentSteps = agentSteps+1;
    ultSteps = ultSteps+1;
    %agentLoggedSignals.State = agentObs;
    [agentNextObs, agentReward, agentIsDone, agentLoggedSignals] = GWStepFunction(agentAction,agentLoggedSignals,agentEnvVariables);
    [NextObs, Reward, ultIsDone, LoggedSignals] = GWStepFunction(agentAction,LoggedSignals,envVariables);
    
    
    agentObs = agentNextObs
 
    Obs = NextObs
pause
    log.Obs(:,ultSteps+1) = Obs;
    log.agentObs(:,ultSteps+1) = agentObs;
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


