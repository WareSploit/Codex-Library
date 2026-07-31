--!strict
-- ============================================================
--  CODEX LIBRARY v1.0.2 | GitHub Edition
--  Brutal Dark Theme, Sharp Edges, Purple Accent
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===================== THEME =====================
local THEME = {
	BG = Color3.fromRGB(8, 8, 10),
	TITLEBAR = Color3.fromRGB(5, 5, 7),
	CONTROL = Color3.fromRGB(15, 15, 18),
	CONTROL_HOVER = Color3.fromRGB(25, 25, 30),
	ACCENT = Color3.fromRGB(140, 60, 255),
	BORDER = Color3.fromRGB(40, 40, 45),
	TEXT = Color3.fromRGB(240, 240, 245),
	TEXT_DIM = Color3.fromRGB(100, 100, 110),
}

local FONT = Enum.Font.Code
local FONT_MED = Enum.Font.Code

-- ===================== HELPERS =====================
local function create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do inst[k] = v end
	return inst
end

local function addStroke(parent, color, thickness)
	return create("UIStroke", {Color = color or THEME.BORDER, Thickness = thickness or 1, Parent = parent})
end

local function tween(obj, time, props)
	return TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
end

-- ===================== LIBRARY MODULE =====================
local Codex = {}
Codex.__index = Codex

function Codex:CreateWindow(config)
	config = config or {}
	local title = config.Title or "Codex"
	local version = config.Version or "v1.0.2"
	local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift

	local old = playerGui:FindFirstChild("CodexUI")
	if old then old:Destroy() end

	local screenGui = create("ScreenGui", {
		Name = "CodexUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = playerGui
	})

	local main = create("Frame", {
		Name = "Main",
		Size = UDim2.new(0, 440, 0, 480),
		Position = UDim2.new(0.5, -220, 0.5, -240),
		BackgroundColor3 = THEME.BG,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = screenGui
	})
	addStroke(main, THEME.BORDER, 2)

	local titleBar = create("Frame", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = THEME.TITLEBAR,
		BorderSizePixel = 0,
		Parent = main
	})

	create("TextLabel", {
		Size = UDim2.new(0, 200, 1, 0),
		Position = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1,
		Text = title .. " " .. version,
		TextColor3 = THEME.TEXT,
		TextSize = 15,
		Font = FONT_MED,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = titleBar
	})

	local closeBtn = create("TextButton", {
		Size = UDim2.new(0, 30, 0, 28),
		Position = UDim2.new(1, -36, 0, 5),
		BackgroundColor3 = THEME.TITLEBAR,
		Text = "X",
		TextColor3 = THEME.TEXT_DIM,
		TextSize = 18,
		Font = FONT_MED,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Parent = titleBar
	})
	addStroke(closeBtn, THEME.BORDER, 2)

	closeBtn.MouseEnter:Connect(function() tween(closeBtn, 0.1, {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play() end)
	closeBtn.MouseLeave:Connect(function() tween(closeBtn, 0.1, {BackgroundColor3 = THEME.TITLEBAR}):Play() end)
	closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

	local dragging, dragStart, startPos = false, nil, nil
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local uiVisible = true
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == toggleKey then
			uiVisible = not uiVisible
			screenGui.Enabled = uiVisible
		end
	end)

	local tabBar = create("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		Position = UDim2.new(0, 0, 0, 38),
		BackgroundColor3 = THEME.TITLEBAR,
		BorderSizePixel = 0,
		Parent = main
	})
	create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Parent = tabBar})

	local pages = {}
	local activeTab = nil

	local Window = { ScreenGui = screenGui, Main = main, Tabs = {} }

	function Window:CreateTab(name, isDefault)
		local tabBtn = create("TextButton", {
			Name = name,
			Size = UDim2.new(0, 110, 1, 0),
			BackgroundColor3 = THEME.TITLEBAR,
			BackgroundTransparency = isDefault and 0 or 1,
			Text = name,
			TextColor3 = isDefault and THEME.TEXT or THEME.TEXT_DIM,
			TextSize = 14,
			Font = FONT_MED,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Parent = tabBar
		})
		addStroke(tabBtn, THEME.BORDER, 1)

		local indicator = create("Frame", {
			Name = "Indicator",
			Size = UDim2.new(1, 0, 0, 3),
			Position = UDim2.new(0, 0, 1, -3),
			BackgroundColor3 = THEME.ACCENT,
			BorderSizePixel = 0,
			Visible = isDefault,
			Parent = tabBtn
		})

		local page = create("Frame", {
			Size = UDim2.new(1, -24, 1, -86),
			Position = UDim2.new(0, 12, 0, 84),
			BackgroundTransparency = 1,
			Visible = isDefault,
			Parent = main
		})
		create("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})

		tabBtn.MouseButton1Click:Connect(function()
			if activeTab == tabBtn then return end
			if activeTab then
				tween(activeTab, 0.15, {BackgroundTransparency = 1, TextColor3 = THEME.TEXT_DIM}):Play()
				activeTab:FindFirstChild("Indicator").Visible = false
				pages[activeTab.Name].Visible = false
			end
			activeTab = tabBtn
			tween(tabBtn, 0.15, {BackgroundTransparency = 0, TextColor3 = THEME.TEXT}):Play()
			indicator.Visible = true
			page.Visible = true
		end)

		pages[name] = page
		if isDefault then activeTab = tabBtn end

		local Tab = {}

		function Tab:AddButton(text, callback)
			local btn = create("TextButton", {
				Size = UDim2.new(1, 0, 0, 38),
				BackgroundColor3 = THEME.CONTROL,
				Text = text,
				TextColor3 = THEME.TEXT,
				TextSize = 14,
				Font = FONT_MED,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Parent = page
			})
			addStroke(btn, THEME.BORDER, 2)
			btn.MouseEnter:Connect(function() tween(btn, 0.1, {BackgroundColor3 = THEME.CONTROL_HOVER}):Play() end)
			btn.MouseLeave:Connect(function() tween(btn, 0.1, {BackgroundColor3 = THEME.CONTROL}):Play() end)
			btn.MouseButton1Click:Connect(function() if callback then callback() end end)
			return btn
		end

		function Tab:AddToggle(text, default, callback)
			local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, Parent = page})
			addStroke(holder, THEME.BORDER, 2)
			create("TextLabel", {Size = UDim2.new(1, -120, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = THEME.TEXT, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder})

			local switchBg = create("Frame", {Size = UDim2.new(0, 40, 0, 22), Position = UDim2.new(1, -110, 0.5, -11), BackgroundColor3 = THEME.BORDER, BorderSizePixel = 0, Parent = holder})
			addStroke(switchBg, THEME.BORDER, 1)
			local knob = create("Frame", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = switchBg})

			local state = default or false
			local boundKey = nil
			local listeningForKey = false

			local keybindBtn = create("TextButton", {
				Size = UDim2.new(0, 50, 0, 24),
				Position = UDim2.new(1, -56, 0.5, -12),
				BackgroundColor3 = THEME.BORDER,
				Text = "None",
				TextColor3 = THEME.TEXT_DIM,
				TextSize = 12,
				Font = FONT_MED,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Parent = holder
			})
			addStroke(keybindBtn, THEME.BORDER, 1)

			local clickArea = create("TextButton", {Size = UDim2.new(0, 60, 1, 0), Position = UDim2.new(1, -60, 0, 0), BackgroundTransparency = 1, Text = "", Parent = holder})

			local function toggle()
				state = not state
				tween(switchBg, 0.15, {BackgroundColor3 = state and THEME.ACCENT or THEME.BORDER}):Play()
				tween(knob, 0.15, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
				if callback then callback(state) end
			end

			if state then
				switchBg.BackgroundColor3 = THEME.ACCENT
				knob.Position = UDim2.new(1, -19, 0.5, -8)
			end

			clickArea.MouseButton1Click:Connect(toggle)

			keybindBtn.MouseButton1Click:Connect(function()
				listeningForKey = true
				keybindBtn.Text = "..."
				keybindBtn.TextColor3 = THEME.ACCENT
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end
				if listeningForKey then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						boundKey = input.KeyCode
						keybindBtn.Text = input.KeyCode.Name:sub(1, 4)
						keybindBtn.TextColor3 = THEME.TEXT
						listeningForKey = false
					end
				elseif boundKey and input.KeyCode == boundKey then
					toggle()
				end
			end)

			keybindBtn.MouseEnter:Connect(function() tween(keybindBtn, 0.1, {BackgroundColor3 = THEME.CONTROL_HOVER}):Play() end)
			keybindBtn.MouseLeave:Connect(function() tween(keybindBtn, 0.1, {BackgroundColor3 = THEME.BORDER}):Play() end)

			return {
				SetState = function(newState) if newState ~= state then toggle() end end,
				GetState = function() return state end
			}
		end

		function Tab:AddSlider(text, min, max, default, callback)
			local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, Parent = page})
			addStroke(holder, THEME.BORDER, 2)
			create("TextLabel", {Size = UDim2.new(1, -60, 0, 20), Position = UDim2.new(0, 12, 0, 6), BackgroundTransparency = 1, Text = text, TextColor3 = THEME.TEXT, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder})
			local valueLabel = create("TextLabel", {Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(1, -60, 0, 6), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = THEME.ACCENT, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Right, Parent = holder})

			local track = create("Frame", {Size = UDim2.new(1, -24, 0, 8), Position = UDim2.new(0, 12, 0, 30), BackgroundColor3 = THEME.BORDER, BorderSizePixel = 0, Parent = holder})
			addStroke(track, THEME.BORDER, 1)
			local fill = create("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = THEME.ACCENT, BorderSizePixel = 0, Parent = track})
			local knob = create("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, -7, 0.5, -7), BackgroundColor3 = THEME.TEXT, BorderSizePixel = 0, Parent = track})
			addStroke(knob, THEME.BORDER, 2)

			local draggingSlider = false
			local function update(inputX)
				local w = track.AbsoluteSize.X
				local relX = math.clamp(inputX - track.AbsolutePosition.X, 0, w)
				local p = relX / w
				local val = math.floor(min + (max - min) * p)
				fill.Size = UDim2.new(p, 0, 1, 0)
				knob.Position = UDim2.new(p, -7, 0.5, -7)
				valueLabel.Text = tostring(val)
				if callback then callback(val) end
			end

			local clickArea = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = holder})
			clickArea.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true; update(input.Position.X) end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then update(input.Position.X) end
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
			end)

			task.spawn(function()
				task.wait()
				local p = (default - min) / (max - min)
				fill.Size = UDim2.new(p, 0, 1, 0)
				knob.Position = UDim2.new(p, -7, 0.5, -7)
			end)
			return holder
		end

		function Tab:AddDropdown(text, options, callback)
			local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, ClipsDescendants = true, Parent = page})
			addStroke(holder, THEME.BORDER, 2)
			local header = create("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, Text = "  " .. text .. ": " .. options[1], TextColor3 = THEME.TEXT, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, AutoButtonColor = false, Parent = holder})
			local arrow = create("TextLabel", {Size = UDim2.new(0, 24, 0, 38), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Text = "▼", TextColor3 = THEME.ACCENT, TextSize = 14, Font = FONT_MED, Parent = header})
			local optionsContainer = create("Frame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, ClipsDescendants = true, Parent = holder})
			create("UIListLayout", {Parent = optionsContainer})

			local isOpen = false
			local optH = 34
			for _, opt in ipairs(options) do
				local optBtn = create("TextButton", {Size = UDim2.new(1, 0, 0, optH), BackgroundColor3 = THEME.CONTROL, Text = "  " .. opt, TextColor3 = THEME.TEXT_DIM, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, AutoButtonColor = false, Parent = optionsContainer})
				optBtn.MouseEnter:Connect(function() tween(optBtn, 0.08, {BackgroundColor3 = THEME.CONTROL_HOVER, TextColor3 = THEME.TEXT}):Play() end)
				optBtn.MouseLeave:Connect(function() tween(optBtn, 0.08, {BackgroundColor3 = THEME.CONTROL, TextColor3 = THEME.TEXT_DIM}):Play() end)
				optBtn.MouseButton1Click:Connect(function()
					header.Text = "  " .. text .. ": " .. opt
					if callback then callback(opt) end
					isOpen = false
					tween(holder, 0.2, {Size = UDim2.new(1, 0, 0, 38)}):Play()
					tween(optionsContainer, 0.2, {Size = UDim2.new(1, 0, 0, 0)}):Play()
					tween(arrow, 0.2, {Rotation = 0}):Play()
				end)
			end
			header.MouseButton1Click:Connect(function()
				isOpen = not isOpen
				local h = isOpen and (#options * optH) or 0
				tween(holder, 0.25, {Size = UDim2.new(1, 0, 0, 38 + h)}):Play()
				tween(optionsContainer, 0.25, {Size = UDim2.new(1, 0, 0, h)}):Play()
				tween(arrow, 0.25, {Rotation = isOpen and 180 or 0}):Play()
			end)
			return holder
		end

		function Tab:AddTextBox(placeholder, callback)
			local box = create("TextBox", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, PlaceholderText = placeholder, PlaceholderColor3 = THEME.TEXT_DIM, Text = "", TextColor3 = THEME.TEXT, TextSize = 14, Font = FONT_MED, ClearTextOnFocus = false, BorderSizePixel = 0, Parent = page})
			local stroke = addStroke(box, THEME.BORDER, 2)
			create("UIPadding", {PaddingLeft = UDim.new(0, 12), Parent = box})
			box.Focused:Connect(function() tween(stroke, 0.1, {Color = THEME.ACCENT}):Play() end)
			box.FocusLost:Connect(function() tween(stroke, 0.1, {Color = THEME.BORDER}):Play(); if callback then callback(box.Text) end end)
			return box
		end

		return Tab
	end

	return Window
end

return Codex
