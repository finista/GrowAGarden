--!strict
local runService = game:GetService("RunService")

local shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local types = require(shared:WaitForChild("Types"):WaitForChild("General"))

local viewportPrefabs =
	game:GetService("ReplicatedStorage"):WaitForChild("Prefabs"):WaitForChild("UI"):WaitForChild("Viewport")

return function(viewport: ViewportFrame, viewportName: string, secondaryViewportName: string?)
	local viewportCamera = Instance.new("Camera")
	viewportCamera.Name = "ViewportCamera"
	viewportCamera.Parent = viewport
	viewport.CurrentCamera = viewportCamera

	local config = {
		currentModel = nil :: any,
		orbitTarget = nil :: any,
		orbitAngle = 0,
		orbitRadius = 0,
		speed = 1,
		angle = 0,
	}

	local function loadModel(model: Model)
		local configModule = model:FindFirstChild("Config")
		assert(configModule, `{model.Name} is missing a configuration module.`)

		local configData = require(configModule) :: types.SeedViewportConfig

        if config.currentModel then
            config.currentModel.Parent = nil
        end

		model.Parent = viewport

		config = {
			currentModel = model,
            orbitOffset = configData.offset,
			orbitTarget = configData.basePart or model.PrimaryPart,
			orbitAngle = configData.animationAngle,
			orbitRadius = configData.distance,
			speed = configData.animationSpeed,
            loop = configData.mainLoop,
			angle = 0,
		}
	end

	local primaryModel = viewportPrefabs:FindFirstChild(viewportName)
	assert(primaryModel, `{viewportName} doesn't exist.`)
    
	local secondaryModel: Model? = (secondaryViewportName and viewportPrefabs:FindFirstChild(secondaryViewportName))
    or nil
    
    primaryModel = primaryModel:Clone()
    if secondaryModel then
        secondaryModel = secondaryModel:Clone()
    end

	local renderConnection = runService.RenderStepped:Connect(function(delta: number)
        if not config.orbitTarget or not config.currentModel then
            return
        end

		local center = config.orbitTarget.Position
        if config.orbitOffset then
            center += config.orbitOffset
        end

		local offset = Vector3.new(
			math.cos(config.angle) * config.orbitRadius,
			math.sin(config.orbitAngle) * config.orbitRadius,
			math.sin(config.angle) * config.orbitRadius
		)

		viewportCamera.CFrame = CFrame.new(center + offset, center)
		config.angle += config.speed * delta

        if config.loop then
            config.loop(delta, config.currentModel)
        end
	end)

    loadModel(primaryModel)

    if secondaryModel then
        local transition: thread = nil

        viewport.MouseEnter:Connect(function()
            if transition then
                task.cancel(transition)
            end

            transition = task.spawn(function()
                local decrement = config.orbitRadius * .2 / 20
                for _=1, 20 do
                    viewport.ImageTransparency += 1 / 20
                    config.orbitRadius -= decrement

                    task.wait(.5 / 20)
                end

                loadModel(secondaryModel)

                for _=1, 20 do
                    viewport.ImageTransparency -= 1 / 20
                    task.wait(.5 / 20)
                end
            end)
        end)

        viewport.MouseLeave:Connect(function()
            if transition then
                task.cancel(transition)
            end

            viewport.ImageTransparency = 0
            loadModel(primaryModel)
        end)
    end

	viewport.Destroying:Connect(function()
		renderConnection:Disconnect()
	end)
end
