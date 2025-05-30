--!strict
local player = game:GetService("Players").LocalPlayer

local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("DialogueService"))

local dialoge = {} :: types.DialogeConfig

dialoge.Goodbye = {
    npcAnswer = "Goodbye.",
    options = "END"
}

dialoge.AnswerGood = {
    npcAnswer = "Thats great to hear!",
    options = "END"
}

dialoge.AnswerHRU = {
    npcAnswer = "Im good, what about you?",
    options = {
        {
            content = "Im good too!",
            onSelect = dialoge.AnswerGood
        };

        {
            content = "Goodbye.",
            onSelect = dialoge.Goodbye
        };
    }
}

dialoge.AnswerMeow = {
    npcAnswer = "Meow! :3",
    options = {
        {
            content = "Meow!",
            onSelect = dialoge.AnswerMeow
        };

        {
            content = "Goodbye.",
            onSelect = dialoge.Goodbye
        };
    }
}

(dialoge.AnswerMeow :: any).options[1].onSelect = dialoge.AnswerMeow

dialoge.Entrypoint = {
    npcAnswer = "Hello!",
    options = {
        {
            content = "How are you?",
            onSelect = dialoge.AnswerHRU
        };

        {
            content = "What am I holding?",
            onSelect = function(_)
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if not tool then
                    return {
                        npcAnswer = "You're not holding anything..",
                        options = "END"
                    }
                end

                return {
                    npcAnswer = `You're holding {tool.Name}!`,
                    options = "END"
                }   
            end :: any
        };

        {
            content = "How much is this worth?",
            onSelect = function(_)
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if not tool then
                    return {
                        npcAnswer = "You're not holding anything..",
                        options = "END"
                    }
                end

                local worth = tool:GetAttribute("value")
                if not worth then
                    return {
                        npcAnswer = "I don't know.",
                        options = "END"
                    }
                end

                return {
                        npcAnswer = `I'd value it around ${worth}`,
                        options = "END"
                    }
            end :: any
        };

        {
            content = "Meow!",
            onSelect = dialoge.AnswerMeow
        };

        {
            content = "Goodbye.",
            onSelect = dialoge.Goodbye
        };
    }
}

return dialoge