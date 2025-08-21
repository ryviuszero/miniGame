-- 网格地图
-- 随机生成蛇的位置 和 食物的位置

-- 游戏设置
local width = 20
local height = 10

-- 初始化蛇的位置
local snake = {
    {x = 3, y = 1}
}

local direction = "right"

-- 初始化食物
-- 这里没有考虑食物和蛇重合的情况
local food = {
    x = math.random(1, width),
    y = math.random(1, height)
}

-- 游戏结束标志
local gameOver = false

-- 游戏循环
while not gameOver do
    -- 打印游戏区域
    for y = 1, height do
        for x = 1, width do
            local isSnake = false
            for _, segment in ipairs(snake) do
                if segment.x == x and segment.y == y then
                    isSnake = true
                    break
                end
            end
            if isSnake then
                io.write("#")
            elseif food.x == x and food.y == y then
                io.write("*")
            else
                io.write(" ")
            end
        end
        io.write("\n")
    end

    -- 获取用户输入
    local input = io.read()
    if input == "w" and direction ~= "down" then
        direction = "up"
    elseif input == "s" and direction ~= "up" then
        direction = "down"
    elseif input == "a" and direction ~= "right" then
        direction = "left"
    elseif input == "d" and direction ~= "left" then
        direction = "right"
    elseif input == "q"  then
        gameOver = true
        break
    end

    -- 更新蛇的位置
    local head = {x = snake[1].x, y = snake[1].y}
    if direction == "up" then
        head.y = head.y - 1
    elseif direction == "down" then
        head.y = head.y + 1
    elseif direction == "left" then
        head.x = head.x - 1
    elseif direction == "right" then
        head.x = head.x + 1
    end
    table.insert(snake, 1, head)

    -- 检查是否吃到食物
    if head.x == food.x and head.y == food.y then
        food = {
            x = math.random(1, width),
            y = math.random(1, height)
        }
    else
        -- 移动蛇尾
        table.remove(snake)
    end

    -- 检查游戏是否结束
    if head.x < 1 or head.x > width or head.y < 1 or head.y > height then
        gameOver = true
    else
        for i = 2, #snake do
            if head.x == snake[i].x and head.y == snake[i].y then
                gameOver = true
                break
            end
        end
    end
end

-- 游戏结束
print("Game over!")