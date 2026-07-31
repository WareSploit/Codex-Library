--!strict
-- ============================================================
--  CODEX LIBRARY v1.2.0
--  Splash Screen + Advanced Configs
--  https://github.com/WareSploit/Codex-Library
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

local function writeFile(path, content)
    if writefile then
        pcall(function() writefile(path, content) end)
    end
end

local function readFile(path)
    if readfile and isfile and isfile(path) then
        local ok, data = pcall(function() return readfile(path) end)
        if ok then return data end
    end
    return nil
end

local function makeFolder(path)
    if makefolder and not isfolder(path) then
        pcall(function() makefolder(path) end)
    end
end

-- ===================== LIBRARY =====================
local Codex = {}
Codex.__index = Codex
Codex._config = {}
Codex._notifContainer = nil
Codex._watermark = nil

-- ===================== SPLASH SCREEN =====================
local function showSplash(title, duration)
    duration = duration or 2
    
    local splashGui = create("ScreenGui", {
        Name = "CodexSplash",
        ResetOnSpawn = false,
        DisplayOrder = 999,
        Parent = playerGui
    })
    
    local bg = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = THEME.BG,
        BorderSizePixel = 0,
        Parent = splashGui
    })
    
    local titleText = create("TextLabel", {
        Size = UDim2.new(0, 400, 0, 100),
        Position = UDim2.new(0.5, -200, 0.5, -50),
        BackgroundTransparency = 1,
        Text = title or "Codex",
        TextColor3 = THEME.TEXT,
        TextSize = 64,
        Font = FONT_MED,
        TextTransparency = 1,
        Parent = bg
    })
    
    local subtitle = create("TextLabel", {
        Size = UDim2.new(0, 400, 0, 30),
        Position = UDim2.new(0.5, -200, 0.5, 60),
        BackgroundTransparency = 1,
        Text = "Loading...",
        TextColor3 = THEME.TEXT_DIM,
        TextSize = 16,
        Font = FONT,
        TextTransparency = 1,
        Parent = bg
    })
    
    -- Animate in
    tween(titleText, 0.5, {TextTransparency = 0}):Play()
    task.wait(0.3)
    tween(subtitle, 0.5, {TextTransparency = 0}):Play()
    
    -- Wait
    task.wait(duration)
    
    -- Animate out
    tween(titleText, 0.4, {TextTransparency = 1}):Play()
    tween(subtitle, 0.4, {TextTransparency = 1}):Play()
    tween(bg, 0.4, {BackgroundTransparency = 1}):Play()
    
    task.wait(0.4)
    splashGui:Destroy()
end

-- ===================== NOTIFICATIONS =====================
local function initNotifContainer()
    if Codex._notifContainer then return end
    
    local notifGui = create("ScreenGui", {
        Name = "CodexNotifications",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = playerGui
    })
    
    local container = create("Frame", {
        Name = "Container",
        Size = UDim2.new(0, 300, 1, -40),
        Position = UDim2.new(1, -320, 0, 20),
        BackgroundTransparency = 1,
        Parent = notifGui
    })
    
    local layout = create("UIListLayout", {
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container
    })
    
    Codex._notifContainer = container
end

function Codex:Notify(message, notifType, duration)
    initNotifContainer()
    
    notifType = notifType or "info"
    duration = duration or 3
    
    local typeColors = {
        success = Color3.fromRGB(60, 200, 100),
        error = Color3.fromRGB(220, 60, 60),
        warning = Color3.fromRGB(240, 180, 60),
        info = THEME.ACCENT,
    }
    
    local accentColor = typeColors[notifType] or typeColors.info
    
    local notif = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = THEME.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = Codex._notifContainer
    })
    addStroke(notif, THEME.BORDER, 1)
    
    local bar = create("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = notif
    })
    
    local label = create("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = THEME.TEXT,
        TextSize = 13,
        Font = FONT_MED,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    notif.Position = UDim2.new(1, 0, 0, 0)
    tween(notif, 0.3, {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.delay(duration, function()
        tween(notif, 0.3, {Position = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- ===================== WATERMARK =====================
function Codex:SetWatermark(enabled, customText)
    if Codex._watermark then
        Codex._watermark:Destroy()
        Codex._watermark = nil
    end
    
    if not enabled then return end
    
    local wmGui = create("ScreenGui", {
        Name = "CodexWatermark",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = playerGui
    })
    
    local wm = create("Frame", {
        Size = UDim2.new(0, 200, 0, 24),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = THEME.BG,
        BorderSizePixel = 0,
        Parent = wmGui
    })
    addStroke(wm, THEME.BORDER, 1)
    
    local accent = create("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = THEME.ACCENT,
        BorderSizePixel = 0,
        Parent = wm
    })
    
    local label = create("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = customText or "Codex",
        TextColor3 = THEME.TEXT,
        TextSize = 12,
        Font = FONT_MED,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = wm
    })
    
    local fps = 60
    local lastTime = tick()
    local frameCount = 0
    
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastTime >= 0.5 then
            fps = math.floor(frameCount / (now - lastTime))
            frameCount = 0
            lastTime = now
        end
        label.Text = (customText or "Codex") .. " | FPS: " .. fps
    end)
    
    Codex._watermark = wmGui
end

-- ===================== CREATE WINDOW =====================
function Codex:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Codex"
    local version = config.Version or "v1.2.0"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightShift
    local watermarkEnabled = config.Watermark ~= false
    local splashEnabled = config.Splash ~= false
    local splashDuration = config.SplashDuration or 2
    
    -- Show splash screen
    if splashEnabled then
        showSplash(title, splashDuration)
    end
    
    local old = playerGui:FindFirstChild("CodexUI")
    if old then old:Destroy() end
    
    if watermarkEnabled then
        Codex:SetWatermark(true, title .. " " .. version)
    end
    
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
    closeBtn.MouseButton1Click:Connect(function() 
        tween(main, 0.2, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        screenGui.Enabled = false
        Codex:Notify("Window closed", "info")
    end)
    
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
        Tab._name = name
        Tab._elements = {}
        
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
            btn.MouseButton1Click:Connect(function() 
                if callback then callback() end 
            end)
            return btn
        end
        
        function Tab:AddToggle(text, default, callback, configId)
            configId = configId or (name .. "_" .. text)
            
            local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, Parent = page})
            addStroke(holder, THEME.BORDER, 2)
            
            create("TextLabel", {
                Size = UDim2.new(1, -80, 1, 0), 
                Position = UDim2.new(0, 12, 0, 0), 
                BackgroundTransparency = 1, 
                Text = text, 
                TextColor3 = THEME.TEXT, 
                TextSize = 14, 
                Font = FONT_MED, 
                TextXAlignment = Enum.TextXAlignment.Left, 
                Parent = holder
            })
            
            local switchBg = create("Frame", {Size = UDim2.new(0, 40, 0, 22), Position = UDim2.new(1, -52, 0.5, -11), BackgroundColor3 = THEME.BORDER, BorderSizePixel = 0, Parent = holder})
            addStroke(switchBg, THEME.BORDER, 1)
            local knob = create("Frame", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = switchBg})
            
            local state = default or false
            
            local clickArea = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = holder})
            
            local function toggle(newState)
                if newState ~= nil then
                    state = newState
                else
                    state = not state
                end
                tween(switchBg, 0.15, {BackgroundColor3 = state and THEME.ACCENT or THEME.BORDER}):Play()
                tween(knob, 0.15, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
                if callback then callback(state) end
                Codex._config[configId] = {type = "toggle", value = state}
            end
            
            if state then
                switchBg.BackgroundColor3 = THEME.ACCENT
                knob.Position = UDim2.new(1, -19, 0.5, -8)
            end
            Codex._config[configId] = {type = "toggle", value = state}
            
            clickArea.MouseButton1Click:Connect(function() toggle() end)
            
            return {
                SetState = function(newState) toggle(newState) end,
                GetState = function() return state end
            }
        end
        
        function Tab:AddSlider(text, min, max, default, callback, configId)
            configId = configId or (name .. "_" .. text)
            
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
                Codex._config[configId] = {type = "slider", value = val}
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
            
            Codex._config[configId] = {type = "slider", value = default}
            
            task.spawn(function()
                task.wait()
                local p = (default - min) / (max - min)
                fill.Size = UDim2.new(p, 0, 1, 0)
                knob.Position = UDim2.new(p, -7, 0.5, -7)
            end)
            return holder
        end
        
        function Tab:AddDropdown(text, options, callback, configId)
            configId = configId or (name .. "_" .. text)
            
            local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, ClipsDescendants = true, Parent = page})
            addStroke(holder, THEME.BORDER, 2)
            
            local header = create("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, Text = "  " .. text .. ": " .. options[1], TextColor3 = THEME.TEXT, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, AutoButtonColor = false, Parent = holder})
            local arrow = create("TextLabel", {Size = UDim2.new(0, 24, 0, 38), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Text = "v", TextColor3 = THEME.ACCENT, TextSize = 14, Font = FONT_MED, Parent = header})
            local optionsContainer = create("Frame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, ClipsDescendants = true, Parent = holder})
            create("UIListLayout", {Parent = optionsContainer})
            
            local isOpen = false
            local optH = 34
            Codex._config[configId] = {type = "dropdown", value = options[1]}
            
            for _, opt in ipairs(options) do
                local optBtn = create("TextButton", {Size = UDim2.new(1, 0, 0, optH), BackgroundColor3 = THEME.CONTROL, Text = "  " .. opt, TextColor3 = THEME.TEXT_DIM, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, AutoButtonColor = false, Parent = optionsContainer})
                optBtn.MouseEnter:Connect(function() tween(optBtn, 0.08, {BackgroundColor3 = THEME.CONTROL_HOVER, TextColor3 = THEME.TEXT}):Play() end)
                optBtn.MouseLeave:Connect(function() tween(optBtn, 0.08, {BackgroundColor3 = THEME.CONTROL, TextColor3 = THEME.TEXT_DIM}):Play() end)
                optBtn.MouseButton1Click:Connect(function()
                    header.Text = "  " .. text .. ": " .. opt
                    if callback then callback(opt) end
                    Codex._config[configId] = {type = "dropdown", value = opt}
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
        
        function Tab:AddColorPicker(text, defaultColor, callback, configId)
            configId = configId or (name .. "_" .. text)
            defaultColor = defaultColor or THEME.ACCENT
            
            local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, ClipsDescendants = true, Parent = page})
            addStroke(holder, THEME.BORDER, 2)
            
            create("TextLabel", {Size = UDim2.new(1, -130, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = THEME.TEXT, TextSize = 14, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder})
            
            local preview = create("Frame", {Size = UDim2.new(0, 50, 0, 22), Position = UDim2.new(1, -60, 0.5, -11), BackgroundColor3 = defaultColor, BorderSizePixel = 0, Parent = holder})
            addStroke(preview, THEME.BORDER, 1)
            
            local pickerContainer = create("Frame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 38), BackgroundColor3 = THEME.CONTROL, BorderSizePixel = 0, ClipsDescendants = true, Parent = holder})
            create("UIListLayout", {Padding = UDim.new(0, 6), Parent = pickerContainer})
            create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = pickerContainer})
            
            local isOpen = false
            local currentColor = defaultColor
            local r, g, b = currentColor.R * 255, currentColor.G * 255, currentColor.B * 255
            
            Codex._config[configId] = {type = "color", value = {r, g, b}}
            
            local function createRGBSlider(labelText, initialValue, onChange)
                local frame = create("Frame", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Parent = pickerContainer})
                create("TextLabel", {Size = UDim2.new(0, 20, 1, 0), BackgroundTransparency = 1, Text = labelText, TextColor3 = THEME.TEXT_DIM, TextSize = 12, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame})
                local valLabel = create("TextLabel", {Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(1, -30, 0, 0), BackgroundTransparency = 1, Text = tostring(math.floor(initialValue)), TextColor3 = THEME.TEXT, TextSize = 12, Font = FONT_MED, TextXAlignment = Enum.TextXAlignment.Right, Parent = frame})
                local track = create("Frame", {Size = UDim2.new(1, -60, 0, 4), Position = UDim2.new(0, 25, 0.5, -2), BackgroundColor3 = THEME.BORDER, BorderSizePixel = 0, Parent = frame})
                local fill = create("Frame", {Size = UDim2.new(initialValue/255, 0, 1, 0), BackgroundColor3 = THEME.ACCENT, BorderSizePixel = 0, Parent = track})
                local knob = create("Frame", {Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(initialValue/255, -5, 0.5, -5), BackgroundColor3 = THEME.TEXT, BorderSizePixel = 0, Parent = track})
                
                local dragging = false
                local function update(x)
                    local w = track.AbsoluteSize.X
                    local relX = math.clamp(x - track.AbsolutePosition.X, 0, w)
                    local p = relX / w
                    local v = math.floor(p * 255)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -5, 0.5, -5)
                    valLabel.Text = tostring(v)
                    onChange(v)
                end
                
                local ca = create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = frame})
                ca.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input.Position.X) end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input.Position.X) end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                
                return {SetValue = function(v)
                    local p = v / 255
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -5, 0.5, -5)
                    valLabel.Text = tostring(v)
                end}
            end
            
            local function updateColor()
                currentColor = Color3.fromRGB(r, g, b)
                preview.BackgroundColor3 = currentColor
                Codex._config[configId] = {type = "color", value = {r, g, b}}
                if callback then callback(currentColor) end
            end
            
            local rSlider = createRGBSlider("R", r, function(v) r = v; updateColor() end)
            local gSlider = createRGBSlider("G", g, function(v) g = v; updateColor() end)
            local bSlider = createRGBSlider("B", b, function(v) b = v; updateColor() end)
            
            local clickArea = create("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Text = "", Parent = holder})
            clickArea.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local h = isOpen and 96 or 0
                tween(holder, 0.25, {Size = UDim2.new(1, 0, 0, 38 + h)}):Play()
                tween(pickerContainer, 0.25, {Size = UDim2.new(1, 0, 0, h)}):Play()
            end)
            
            return {
                SetColor = function(color)
                    r, g, b = math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)
                    rSlider.SetValue(r); gSlider.SetValue(g); bSlider.SetValue(b)
                    updateColor()
                end,
                GetColor = function() return currentColor end
            }
        end
        
        return Tab
    end
    
    -- ===================== ADVANCED CONFIG SYSTEM =====================
    function Window:SaveConfig(name)
        name = name or "default"
        makeFolder("CodexConfigs")
        local path = "CodexConfigs/" .. name .. ".json"
        local data = HttpService:JSONEncode(Codex._config)
        writeFile(path, data)
        Codex:Notify("Config saved: " .. name, "success")
        return true
    end
    
    function Window:LoadConfig(name)
        name = name or "default"
        local path = "CodexConfigs/" .. name .. ".json"
        local data = readFile(path)
        if not data then
            Codex:Notify("Config not found: " .. name, "error")
            return false
        end
        local ok, parsed = pcall(function() return HttpService:JSONDecode(data) end)
        if not ok then
            Codex:Notify("Failed to parse config", "error")
            return false
        end
        Codex:Notify("Config loaded: " .. name, "success")
        return parsed
    end
    
    function Window:GetConfigList()
        if not listfiles then
            Codex:Notify("File system not supported", "error")
            return {}
        end
        local ok, files = pcall(function() return listfiles("CodexConfigs") end)
        if not ok then return {} end
        
        local configs = {}
        for _, file in ipairs(files) do
            if file:match("%.json$") then
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
        return configs
    end
    
    function Window:DeleteConfig(name)
        if not delfile then
            Codex:Notify("File system not supported", "error")
            return false
        end
        local path = "CodexConfigs/" .. name .. ".json"
        local ok = pcall(function() delfile(path) end)
        if ok then
            Codex:Notify("Config deleted: " .. name, "success")
            return true
        else
            Codex:Notify("Failed to delete config", "error")
            return false
        end
    end
    
    return Window
end

return Codex
