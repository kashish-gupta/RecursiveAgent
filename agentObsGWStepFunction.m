function [NextObs,Reward,IsDone,LoggedSignals] = agentObsGWStepFunction(Action,LoggedSignals, agentEnvVariables)
 global agentEnvVariables

% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

% Check if the given action is valid.
if ~ismember(Action,[agentEnvVariables.PossibleActions])
    error('Invalid Action');
end


% Unpack the state vector from the logged signals.
flatState = LoggedSignals.State;
onesInFlatState = find(flatState == 1);
% threeInFlatState = find(flatState == 3);
% twosInFlatState = find(flatState == 2);

currentStateIdx = onesInFlatState(1);
endStateIdx = onesInFlatState(2) - agentEnvVariables.Size^2;

% currentStateIdx = State(1);
% endStateIdx = State(2);
% cellError = State(3);

ranIntoEdge = false;

if Action == 1
    nextStateIdx = currentStateIdx-agentEnvVariables.Size;
    if nextStateIdx < 1 
        nextStateIdx = currentStateIdx;
        ranIntoEdge = true;
    end
elseif Action == 2
    nextStateIdx = currentStateIdx+1;
    if mod(nextStateIdx, agentEnvVariables.Size)==1 
        nextStateIdx = currentStateIdx; 
        ranIntoEdge = true;
    end
elseif Action == 3
    nextStateIdx = currentStateIdx+agentEnvVariables.Size;
    if nextStateIdx > agentEnvVariables.Size^2 
        nextStateIdx = currentStateIdx;
        ranIntoEdge = true;
    end
elseif Action == 4
    nextStateIdx = currentStateIdx-1;
    if mod(nextStateIdx, agentEnvVariables.Size)==0
        nextStateIdx = currentStateIdx;
        ranIntoEdge = true;
    end
end

bumpedIntoObstacle = false;
if isObstacle(idx2State(nextStateIdx, agentEnvVariables.Size), agentEnvVariables)
    nextStateIdx = currentStateIdx;
    bumpedIntoObstacle = true;
end
%newCellError = sum(abs(idx2State(nextStateIdx, agentEnvVariables.Size)-idx2State(endStateIdx, agentEnvVariables.Size)));

LoggedSignals.State = flattenState(nextStateIdx, endStateIdx, agentEnvVariables);

% Transform state to observation.
NextObs = LoggedSignals.State;

% Check terminal condition.

IsDone = endStateIdx-nextStateIdx == 0;

% Get reward.
if IsDone
    Reward = agentEnvVariables.RewardToReachEnd;
elseif bumpedIntoObstacle
    Reward = agentEnvVariables.RewardForBumping;
elseif ranIntoEdge
    Reward = agentEnvVariables.RewardForRunningIntoEdge;
else
    Reward = agentEnvVariables.RewardPerStep;
end

end