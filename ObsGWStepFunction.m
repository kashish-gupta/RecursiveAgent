function [NextObs,Reward,IsDone,LoggedSignals] = ObsGWStepFunction(Action,LoggedSignals, envVariables)
 global envVariables

% This function applies the given action to the environment and evaluates
% the system dynamics for one simulation step.

% Check if the given action is valid.
if ~ismember(Action,[envVariables.PossibleActions])
    error('Invalid Action');
end


% Unpack the state vector from the logged signals.
flatState = LoggedSignals.State;
onesInFlatState = find(flatState == 1);
% threeInFlatState = find(flatState == 3);
% twosInFlatState = find(flatState == 2);

currentStateIdx = onesInFlatState(1);
endStateIdx = onesInFlatState(2) - envVariables.Size^2;

% currentStateIdx = State(1);
% endStateIdx = State(2);
% cellError = State(3);

ranIntoEdge = false;

if Action == 1
    nextStateIdx = currentStateIdx-envVariables.Size;
    if nextStateIdx < 1 
        nextStateIdx = currentStateIdx;
        ranIntoEdge = true;
    end
elseif Action == 2
    nextStateIdx = currentStateIdx+1;
    if mod(nextStateIdx, envVariables.Size)==1 
        nextStateIdx = currentStateIdx; 
        ranIntoEdge = true;
    end
elseif Action == 3
    nextStateIdx = currentStateIdx+envVariables.Size;
    if nextStateIdx > envVariables.Size^2 
        nextStateIdx = currentStateIdx;
        ranIntoEdge = true;
    end
elseif Action == 4
    nextStateIdx = currentStateIdx-1;
    if mod(nextStateIdx, envVariables.Size)==0
        nextStateIdx = currentStateIdx;
        ranIntoEdge = true;
    end
end

bumpedIntoObstacle = false;
if isObstacle(idx2State(nextStateIdx, envVariables.Size), envVariables)
    nextStateIdx = currentStateIdx;
    bumpedIntoObstacle = true;
end
%newCellError = sum(abs(idx2State(nextStateIdx, envVariables.Size)-idx2State(endStateIdx, envVariables.Size)));

LoggedSignals.State = flattenState(nextStateIdx, endStateIdx, envVariables);

% Transform state to observation.
NextObs = LoggedSignals.State;

% Check terminal condition.

IsDone = endStateIdx-nextStateIdx == 0;

% Get reward.
if IsDone
    Reward = envVariables.RewardToReachEnd;
elseif bumpedIntoObstacle
    Reward = envVariables.RewardForBumping;
elseif ranIntoEdge
    Reward = envVariables.RewardForRunningIntoEdge;
else
    Reward = envVariables.RewardPerStep;
end

end