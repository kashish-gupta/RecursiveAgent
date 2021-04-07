function Idx = state2Idx(state, gridSize)

row = state(1);
col = state(2);

Idx = (row-1)*gridSize + col;
end