function linearIdx = linearMap(stateIdx,gridSizeLocal,gridSizeGlobal);

state = idx2State(stateIdx,gridSizeGlobal);

linearState(1) = mod(state(1),gridSizeLocal);
linearState(2) = mod(state(2),gridSizeLocal);

if mod(state(1),gridSizeLocal) == 0
    linearState(1) = gridSizeLocal;
end
if mod(state(2),gridSizeLocal) == 0
    linearState(2) = gridSizeLocal;
end
linearIdx = state2Idx(linearState,gridSizeLocal);
end