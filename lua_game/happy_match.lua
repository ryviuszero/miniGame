-- 游戏设置
local gridSize = 8 -- 网格大小
local symbols = { -- 可用的符号
  "A", "B", "C", "D", "E", "F", "G", "H"
}

-- 初始化游戏网格
local grid = {}
for row = 1, gridSize do
  grid[row] = {}
  for col = 1, gridSize do
    grid[row][col] = symbols[math.random(#symbols)]
  end
end

-- 打印游戏网格
function printGrid()
  io.write(string.rep("-", gridSize * 4 + 1), "\n")
  for row = 1, gridSize do
    for col = 1, gridSize do
      io.write("| ", grid[row][col], " ")
    end
    io.write("|\n", string.rep("-", gridSize * 4 + 1), "\n")
  end
end

-- 判断是否存在可消除的连续符号
-- 其实需要所有的交换都遍历
function canMatch()
  for row = 1, gridSize do
    for col = 1, gridSize do
      local symbol = grid[row][col]
      local symbol_down = nil
      local symbol_next = nil
      if row < gridSize then
        symbol_next = grid[row + 1][col]
      end
      if col < gridSize then
        symbol_down = grid[row][col + 1]
      end
      for _, sym in ipairs({symbol, symbol_next, symbol_down}) do
        if sym then
            -- 判断横向连续符号
            if col <= gridSize - 2 and grid[row][col + 1] == sym and grid[row][col + 2] == sym then
                return true
            end
            -- 判断纵向连续符号
            if row <= gridSize - 2 and grid[row + 1][col] == sym and grid[row + 2][col] == sym then
                return true
            end
        end
      end
    end
  end
  return false
end

-- 交换两个符号的位置
function swapSymbols(row1, col1, row2, col2)
  local temp = grid[row1][col1]
  grid[row1][col1] = grid[row2][col2]
  grid[row2][col2] = temp
end

-- 消除连续符号
function eliminateMatches()
  local matched = false
  for row = 1, gridSize do
    for col = 1, gridSize do
      local symbol = grid[row][col]
      -- 判断横向连续符号
      if col <= gridSize - 2 and grid[row][col + 1] == symbol and grid[row][col + 2] == symbol then
        grid[row][col] = ""
        grid[row][col + 1] = ""
        grid[row][col + 2] = ""
        matched = true
      end
      -- 判断纵向连续符号
      if row <= gridSize - 2 and grid[row + 1][col] == symbol and grid[row + 2][col] == symbol then
        grid[row][col] = ""
        grid[row + 1][col] = ""
        grid[row + 2][col] = ""
        matched = true
      end
    end
  end
  return matched
end

-- 下落符号
function dropSymbols()
  for col = 1, gridSize do
    local emptyCount = 0
    for row = gridSize, 1, -1 do
      if grid[row][col] == "" then
        emptyCount = emptyCount + 1
      else
        grid[row + emptyCount][col] = grid[row][col]
        grid[row][col] = ""
      end
    end
    for i = 1, emptyCount do
      grid[i][col] = symbols[math.random(#symbols)]
    end
  end
end

-- 游戏循环
while true do
  -- 打印游戏网格
  printGrid()

  -- 判断是否存在可消除的连续符号
  if not canMatch() then
    print("No more matches. Game over!")
    break
  end

  -- 提示玩家输入
  io.write("Enter symbol position to swap (row col): ")

  -- 获取用户输入
  local input = io.read()

  local row1, col1, row2, col2 = input:match("(%d+) (%d+) (%d+) (%d+)")
  row1, col1, row2, col2 = tonumber(row1), tonumber(col1), tonumber(row2), tonumber(col2)

  -- 验证输入的符号位置是否有效
  if row1 and col1 and row2 and col2 and
      row1 >= 1 and row1 <= gridSize and
      col1 >= 1 and col1 <= gridSize and
      row2 >= 1 and row2 <= gridSize and
      col2 >= 1 and col2 <= gridSize then
    -- 交换符号位置
    swapSymbols(row1, col1, row2, col2)
    printGrid()

    -- 消除连续符号并下落符号
    while eliminateMatches() do
      dropSymbols()
    end
  else
    print("Invalid symbol positions. Please try again!")
  end
end