local utils = {}

function utils.formatDecimal(number: number, n: number)
    -- Leaves only n amount of digits after the comma
    local multiplier = 10^n
    return math.floor(number * multiplier + 0.5) / multiplier
end

return utils