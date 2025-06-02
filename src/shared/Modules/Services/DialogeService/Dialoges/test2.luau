--!strict
local player = game:GetService("Players").LocalPlayer
local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("DialogueService"))

local dialogue = {} :: types.DialogeConfig

-- Termination dialogue
dialogue.Goodbye = {
    npcAnswer = "Farewell, traveler!",
    options = "END"
}

-- Quest completion dialogue
dialogue.QuestComplete = {
    npcAnswer = "You've completed the quest! Well done!",
    options = "END"
}

-- Quest in progress dialogue
dialogue.QuestInProgress = {
    npcAnswer = "You're still working on that quest. Keep going!",
    options = "END"
}

-- Quest offer dialogue
dialogue.QuestOffer = {
    npcAnswer = "I have a task for you. Will you accept the quest?",
    options = {
        {
            content = "Yes, I'll take it!",
            onSelect = function(_)
                -- Simulate setting a quest flag
                player:SetAttribute("QuestActive", true)
                return {
                    npcAnswer = "Great! Return when you've finished.",
                    options = "END"
                }
            end :: any
        },
        {
            content = "No, maybe later.",
            onSelect = dialogue.Goodbye
        }
    }
}

-- Quest status check dialogue
dialogue.CheckQuestStatus = {
    npcAnswer = "Have you completed the quest yet?",
    options = {
        {
            content = "Yes, I finished it!",
            onSelect = function(_)
                if player:GetAttribute("QuestActive") and player:GetAttribute("QuestProgress") == 100 then
                    return dialogue.QuestComplete
                else
                    return {
                        npcAnswer = "It doesn't look like you're done yet.",
                        options = "END"
                    }
                end
            end :: any
        },
        {
            content = "Not yet.",
            onSelect = dialogue.QuestInProgress
        },
        {
            content = "Goodbye.",
            onSelect = dialogue.Goodbye
        }
    }
}

-- Inventory check dialogue
dialogue.CheckInventory = {
    npcAnswer = "Let me see what you're carrying.",
    options = {
        {
            content = "Check my tool.",
            onSelect = function(_)
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if not tool then
                    return {
                        npcAnswer = "You're not holding anything!",
                        options = "END"
                    }
                end
                return {
                    npcAnswer = `You're holding a {tool.Name}.`,
                    options = {
                        {
                            content = "Is it valuable?",
                            onSelect = function(_)
                                local worth = tool:GetAttribute("value") or 0
                                if worth > 0 then
                                    return {
                                        npcAnswer = "It's worth about $" .. worth .. ".",
                                        options = "END"
                                    }
                                else
                                    return {
                                        npcAnswer = "That doesn't seem very valuable.",
                                        options = "END"
                                    }
                                end
                            end :: any
                        },
                        {
                            content = "Thanks!",
                            onSelect = dialogue.Goodbye
                        }
                    }
                } :: any
            end :: any
        },
        {
            content = "Nevermind.",
            onSelect = dialogue.Goodbye
        }
    }
}

-- Recursive dialogue for a fun interaction
dialogue.RiddleLoop = {
    npcAnswer = "Answer my riddle: What has keys but can't open locks?",
    options = {
        {
            content = "A piano!",
            onSelect = {
                npcAnswer = "Correct! Want another riddle?",
                options = {
                    {
                        content = "Sure, hit me!",
                        onSelect = dialogue.RiddleLoop
                    },
                    {
                        content = "No thanks.",
                        onSelect = dialogue.Goodbye
                    }
                }
            }
        },
        {
            content = "I don't know.",
            onSelect = {
                npcAnswer = "It's a piano! Try another?",
                options = {
                    {
                        content = "Yes, try again.",
                        onSelect = dialogue.RiddleLoop
                    },
                    {
                        content = "No, I'm done.",
                        onSelect = dialogue.Goodbye
                    }
                }
            }
        }
    }
}

-- Edge case: No options provided
dialogue.NoOptions = {
    npcAnswer = "I have nothing more to say.",
    options = "END"
}

-- Edge case: Dynamic response with missing attribute
dialogue.CheckPlayerLevel = {
    npcAnswer = "What is your level?",
    options = {
        {
            content = "Tell you my level.",
            onSelect = function(_)
                local level = player:GetAttribute("Level")
                if not level then
                    return {
                        npcAnswer = "You don't seem to have a level set!",
                        options = "END"
                    }
                end
                return {
                    npcAnswer = "You're level " .. level .. "! That's impressive!",
                    options = "END"
                }
            end :: any
        },
        {
            content = "I won't tell you.",
            onSelect = dialogue.Goodbye
        }
    }
}

-- Main entrypoint dialogue
dialogue.Entrypoint = {
    npcAnswer = "Greetings, adventurer! What brings you here?",
    options = {
        {
            content = "I have a quest question.",
            onSelect = function(_)
                if player:GetAttribute("QuestActive") then
                    return dialogue.CheckQuestStatus
                else
                    return dialogue.QuestOffer
                end
            end :: any
        },
        {
            content = "What's in my inventory?",
            onSelect = dialogue.CheckInventory
        },
        {
            content = "Tell me a riddle!",
            onSelect = dialogue.RiddleLoop
        },
        {
            content = "What's my level?",
            onSelect = dialogue.CheckPlayerLevel
        },
        {
            content = "Nothing, just passing by.",
            onSelect = dialogue.NoOptions
        },
        {
            content = "Goodbye.",
            onSelect = dialogue.Goodbye
        }
    }
}

return dialogue