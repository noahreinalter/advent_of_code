local file = fs.open("../input", "r")

local horizontalPosition = 0
local depth = 0

local depth2 = 0
local aim = 0

while true do
    local line = file.readLine()

    if not line then
        break
    end

    local command = ""
    local parsedInt = 0
    local index = 0

    for part in string.gmatch(line, "[A-Za-z0-9]+") do
        print(part)
        if index == 0 then
            command = part
        else
            parsedInt = tonumber(part, 10)
        end
        index = 1
    end

    if command == "forward" then
        horizontalPosition = horizontalPosition + parsedInt
        depth2 = depth2 + aim * parsedInt
    elseif command == "up" then
        depth = depth - parsedInt
        aim = aim - parsedInt
    elseif command == "down" then
        depth = depth + parsedInt
        aim = aim + parsedInt
    end
end

print("Horizontal position: " .. tostring(horizontalPosition))
print("Depth: " .. tostring(depth))
print("Aufgabe 1: " .. tostring(horizontalPosition * depth))

print("Depth2: " .. tostring(depth2))
print("Aim: " .. tostring(aim))
print("Aufgabe 2: " .. tostring(horizontalPosition * depth2))

file.close()
