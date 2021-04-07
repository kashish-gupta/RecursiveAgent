function mappedIdx = recursiveMap(stateIdx,gridSizeLocal,gridSizeGlobal);

state = idx2State(stateIdx,gridSizeGlobal);

mappedState(1) = fix(state(1)/gridSizeLocal)+1;
mappedState(2) = fix(state(2)/gridSizeLocal)+1;

if mod(state(1),gridSizeLocal) == 0
    mappedState(1) = mappedState(1)-1;
end
if mod(state(2),gridSizeLocal) == 0
    mappedState(2) = mappedState(2)-1;
end
mappedIdx = state2Idx(mappedState,gridSizeLocal);
end