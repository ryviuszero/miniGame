-- 这个游戏没有完全实现，大致看看意思就行
-- 初始化游戏地图
local function initMap(rows, cols, mines)
    local map = {}
    for i = 1, rows do
        map[i] = {}
        for j = 1, cols do
            map[i][j] = {
                isMine = false,
                isRevealed = false,
                surroundingMines = 0
            }
        end
    end

    -- 随机放置地雷
    local count = 0
    while count < mines do
        local x = math.random(1, rows)
        local y = math.random(1, cols)
        if not map[x][y].isMine then
            map[x][y].isMine = true
            count = count + 1
        end
    end

    return map
end

-- 计算指定位置周围地雷数量
local function calculateSurroundingMines(map, row, col)
    local count = 0
    local rows = #map
    local cols = #map[1]

    for dx = -1, 1 do
        for dy = -1, 1 do
            local newRow = row + dx
            local newCol = col + dy

            if newRow >= 1 and newRow <= rows and newCol >= 1 and
                newCol <= cols then
                    if map[newRow][newCol].isMine then
                        count = count + 1
                    end
            end
        end
    end
    return count
end

-- 揭示指定位置
local function revealPosition(map, row, col)
    if map[row][col].isRevealed then
        return
    end

    map[row][col].isRevealed = true

    if map[row][col].isMine then
        print("Game Over! You hit a mine!")
        -- 这里可以进行游戏结束的处理逻辑
    else
        local surroundingMines = map[row][col].surroundingMines
        print("周围地雷数量: " .. surroundingMines)
        -- 这里可以进行其他处理逻辑，比如根据周围地雷数量显示不同的提示
    end
end

-- 自动扫雷逻辑，看看扫雷到底是不是也需要运气？
-- local function autoSweep()
--     for i = 1, rows do
--         for j = 1, cols do
--             if not map[i][j].isRevealed then
--                 revealPosition(map, i, j)
--             end
--         end
--     end
-- end

local function main()
    local rows = 10
    local cols = 10
    local mines = 10

    local map = initMap(rows, cols, mines)

    -- 游戏逻辑循环
    while true do
        -- 获取玩家输入， 比如指定要揭示的位置
        print("请输入要揭示的位置 (行 列): ")
        local row = tonumber(io.read())
        local col = tonumber(io.read())

        if row < 1 or row > rows or col < 1 or col > cols then
            print("无效的位置，请重新输入。")
        else
            revealPosition(map, row, col)
        end
    end
end

main()