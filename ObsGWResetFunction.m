function [InitialObservation, LoggedSignal] = ObsGWResetFunction()
global envVariables

ROIFactor = envVariables.ROIFactor;

gridSize = envVariables.Size;
% envVariables.ObstacleStates = [];
if envVariables.DynamicObstacles == true
totalObstacles = randi([2,round(0.3*envVariables.Size^2)]);
if totalObstacles==0
    envVariables.ObstacleStates = [];
    envVariables.CheckObstacle = false;
else
envVariables.ObstacleStates = randi(envVariables.Size, [totalObstacles,2]);
% envVariables.ObstacleStates = [2,2; 2,3; 4,1; 4,4; 1,1];
envVariables.CheckObstacle = true;
end
else
    envVariables.ObstacleStates =  [15,1;
                                    12,4;
                                    16,14;
                                    3,9;
                                    15,14;
                                    12,2;
                                    2,5;
                                    13,10;
                                    13,15;
                                    15,9;
                                    12,1;
                                    2,13;
                                    1,4;
                                    7,8;
                                    8,7;
                                    10,14;
                                    10,12;
                                    6,14;
                                    6,9];
    envVariables.CheckObstacle = true;
end

cellOverlapCheck = true;
if envVariables.DynamicStartState == true
    while cellOverlapCheck == true
     rowStartCell = randi(gridSize);
     colStartCell = randi(gridSize);
     startCell = [rowStartCell, colStartCell];
    
     cellOverlapCheck = isObstacle(startCell,envVariables);
    end
else
    startCell = envVariables.StartState;
end


cellOverlapCheck = true;
if envVariables.DynamicEndState == true
while cellOverlapCheck == true
    if ROIFactor > 0
     rowEndCell = randi([max(1,rowStartCell-ROIFactor), min(gridSize,rowStartCell+ROIFactor)]);
     colEndCell = randi([max(1,colStartCell-ROIFactor), min(gridSize,colStartCell+ROIFactor)]);
    else
     rowEndCell = randi(gridSize);
     colEndCell = randi(gridSize);
    end

endCell = [rowEndCell, colEndCell];
cellOverlapCheck = startCell==endCell | isObstacle(endCell,envVariables);
end
else
    endCell = envVariables.EndState;
end

if isObstacle(endCell,envVariables) || isObstacle(startCell,envVariables)
    disp("Error: endCell or startCell overlaps with an obstacle");
end

startCellIdx = state2Idx(startCell, gridSize);
endCellIdx = state2Idx(endCell, gridSize);
% cellError = sum(abs(endCell-startCell));

% Return initial environment state variables as logged signals.
% if envVariables.Type == 1
% LoggedSignal.State = [cellError];
% elseif envVariables.Type == 2
% LoggedSignal.State = [endCellIdx; cellError];
% elseif envVariables.Type == 3
% LoggedSignal.State = [startCellIdx; endCellIdx; cellError];
% end
LoggedSignal.State = flattenState(startCellIdx, endCellIdx, envVariables);

InitialObservation = LoggedSignal.State;

end
