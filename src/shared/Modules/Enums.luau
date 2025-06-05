--!strict
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("General"))

local enums = {}

enums.SeedRarities = {
    Common = {
        name = "Common",
        color = Color3.fromRGB(0, 89, 255)
    };

    Rainbow = {
        name = "Rainbow";
        color = function()
            local time = tick()
            
            local cycleDuration = 10
            local hue = (time % cycleDuration) / cycleDuration 
            
            local function hsvToRgb(h: number)
                local r, g, b
                local i = math.floor(h * 6)
                local f = h * 6 - i
                local q = 1 - f
                local t = f
                
                if i % 6 == 0 then
                    r, g, b = 1, t, 0
                elseif i % 6 == 1 then
                    r, g, b = q, 1, 0
                elseif i % 6 == 2 then
                    r, g, b = 0, 1, t
                elseif i % 6 == 3 then
                    r, g, b = 0, q, 1
                elseif i % 6 == 4 then
                    r, g, b = t, 0, 1
                else
                    r, g, b = 1, 0, q
                end

                return Color3.fromRGB(r * 255, g * 255, b * 255)
            end
            
            return hsvToRgb(hue)
        end;
    }
} :: {[string]: types.Rarity}

enums.FruitTypes = {
    Common = {
        name = "Common",
        color = Color3.fromRGB(0, 89, 255)
    };
}

return enums