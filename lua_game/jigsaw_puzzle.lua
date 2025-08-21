-- 拼图游戏示例

-- 定义游戏板
local board = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 0}
}

-- 随机打乱游戏板
math.randomseed(os.time())
for i = 1, 100 do
    local row, col = 0, 0
    -- 找到空格的位置
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == 0 then
                row, col = i, j
                break
            end
        end
        if row ~= 0 then
            break
        end
    end

    -- 随机移动空格的位置
    local directions = {
        {1, 0},  -- 下
        {-1, 0}, -- 上
        {0, 1},  -- 右
        {0, -1}  -- 左
    }
    local validMoves = {}
    for _, dir in ipairs(directions) do
        local newRow, newCol = row + dir[1], col + dir[2]
        if newRow >= 1 and newRow <= 3 and newCol >= 1 and newCol <= 3 then
            table.insert(validMoves, {newRow, newCol})
        end
    end

    local move = validMoves[math.random(#validMoves)]
    board[row][col], board[move[1]][move[2]] = board[move[1]][move[2]], board[row][col]
end

-- 打印游戏板
function printBoard()
    print("------------")
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == 0 then
                io.write("|  ")
            else
                io.write("| " .. board[i][j] .. " ")
            end
        end
        print("|\n------------")
    end
end

-- 判断是否完成拼图
function isSolved()
    local count = 1
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] ~= count % 9 then
                return false
            end
            count = count + 1
        end
    end
    return true
end

-- 游戏循环
while true do
    printBoard()

    -- 提示用户输入移动方向
    print("Enter direction (w/a/s/d) to move, or 'q' to quit:")
    local input = io.read()
    local row, col = 0, 0
    if input == "q" then
        print("Game over!")
        break
    end
    -- 找到空格的位置
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == 0 then
                row, col = i, j
                break
            end
        end
        if row ~= 0 then
            break
        end
    end
    -- 根据用户输入进行移动
    if input == "w" and row <  1 then
        board[row][col], board[row - 1][col] = board[row - 1][col], board[row][col]
    elseif input == "s" and row < 3 then
        board[row][col], board[row + 1][col] = board[row + 1][col], board[row][col]
    elseif input == "a" and col > 1 then
        board[row][col], board[row][col - 1] = board[row][col - 1], board[row][col]
    elseif input == "d" and col < 3 then
        board[row][col], board[row][col + 1] = board[row][col + 1], board[row][col]
    else
        print("Invalid move!")
    end
    
    -- 判断是否完成拼图
    if isSolved() then
        print("Congratulations! You solved the puzzle!")
        break
    end
end