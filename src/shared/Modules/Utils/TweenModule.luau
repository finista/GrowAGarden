local module = {}
local TweenService = game:GetService("TweenService")

function module.MultiTween(Inst, Type, To, Time, Direction, Style)
	local Table = {}
	Table[Type] = To
	local Info = TweenInfo.new(Time, Style, Direction)
	local Tween = TweenService:Create(Inst, Info, Table)
	Tween:Play()
	return Tween
end

function module.TweenModel(Model, CFrame, Time, Style, Direction)
	local Info = TweenInfo.new(Time, Style, Direction)
	local CFrameValue = Instance.new("CFrameValue")
	CFrameValue.Value = Model:GetPrimaryPartCFrame()

	CFrameValue:GetPropertyChangedSignal("Value"):connect(function()
		if Model and Model.PrimaryPart then
			Model:SetPrimaryPartCFrame(CFrameValue.Value)
		end
	end)

	local Tween = TweenService:Create(CFrameValue, Info, { Value = CFrame })
	Tween:Play()

	return Tween
end

return module
