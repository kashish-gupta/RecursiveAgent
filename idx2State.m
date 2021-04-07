function State = idx2State(stateIdx, gridSize)

row = fix(stateIdx/gridSize)+1;
col = mod(stateIdx, gridSize);

if col == 0
    row = row-1;
    col = col+gridSize;
end

State = [row, col];
end