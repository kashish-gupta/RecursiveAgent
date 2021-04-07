function [InitialObservation, LoggedSignal] = agentObsGWResetFunction()
global agentEnvVariables

ROIFactor = agentEnvVariables.ROIFactor;

gridSize = agentEnvVariables.Size;
% agentEnvVariables.ObstacleStates = [];
totalObstacles = randi([2,round(0.3*agentEnvVariables.Size^2)]);
if totalObstacles==0
    agentEnvVariables.ObstacleStates = [];
    agentEnvVariables.CheckObstacle = false;
else
agentEnvVariables.ObstacleStates = randi(agentEnvVariables.Size, [totalObstacles,2]);
% agentEnvVariables.ObstacleStates = [2,2; 2,3; 4,1; 4,4; 1,1];
agentEnvVariables.CheckObstacle = true;
end

cellOverlapCheck = true;
if agentEnvVariables.DynamicStartState == true
    while cellOverlapCheck == true
     rowStartCell = randi(gridSize);
     colStartCell = randi(gridSize);
     startCell = [rowStartCell, colStartCell];
    
     cellOverlapCheck = isObstacle(startCell,agentEnvVariables);
    end
else
    startCell = agentEnvVariables.StartState;
end


cellOverlapCheck = true;
if agentEnvVariables.DynamicEndState == true
while cellOverlapCheck == true
    if ROIFactor > 0
     rowEndCell = randi([max(1,rowStartCell-ROIFactor), min(gridSize,rowStartCell+ROIFactor)]);
     colEndCell = randi([max(1,colStartCell-ROIFactor), min(gridSize,colStartCell+ROIFactor)]);
    else
     rowEndCell = randi(gridSize);
     colEndCell = randi(gridSize);
    end

endCell = [rowEndCell, colEndCell];
cellOverlapCheck = startCell==endCell | isObstacle(endCell,agentEnvVariables);
end
else
    endCell = agentEnvVariables.EndState;
end

if isObstacle(endCell,agentEnvVariables) || isObstacle(startCell,agentEnvVariables)
    disp("Error: endCell or startCell overlaps with an obstacle");
end

startCellIdx = state2Idx(startCell, gridSize);
endCellIdx = state2Idx(endCell, gridSize);
% cellError = sum(abs(endCell-startCell));

% Return initial environment state variables as logged signals.
% if agentEnvVariables.Type == 1
% LoggedSignal.State = [cellError];
% elseif agentEnvVariables.Type == 2
% LoggedSignal.State = [endCellIdx; cellError];
% elseif agentEnvVariables.Type == 3
% LoggedSignal.State = [startCellIdx; endCellIdx; cellError];
% end
LoggedSignal.State = flattenState(startCellIdx, endCellIdx, agentEnvVariables);

InitialObservation = LoggedSignal.State;

end
