--[[
  ____  ____   ____     ____                  _ 
 | __ )| __ ) / ___|   |  _ \ __ _ _ __   ___| |
 |  _ \|  _ \| |  _    | |_) / _` | '_ \ / _ \ |
 | |_) | |_) | |_| |   |  __/ (_| | | | |  __/ |
 |____/|____/ \____|   |_|   \__,_|_| |_|\___|_|

Author: BBG's Art | BBG Panel Owner
Discord: https://discord.gg/cSthtkp5dD
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

-- Crimson theme 
local C = {
    bg              = Color3.fromHex("1c0606"),
    bgTransparency  = 0.15,
    rowColor        = Color3.fromHex("fef2f2"),
    rowTransparency = 0.93,
    toggleOn        = Color3.fromHex("dc2626"),
    toggleOff       = Color3.fromHex("991b1b"),
    handle          = Color3.new(1, 1, 1),
    text            = Color3.fromHex("fef2f2"),
    placeholder     = Color3.fromHex("d95353"),
    borderColor     = Color3.fromHex("ef4444"),
    borderAlpha     = 0.75,
}

-- Dimensions 
local UI = {
    corner     = 14,
    padding    = 9,
    toggleRowH = 30,
    inputRowH  = 32,
    rowGap     = 3,
    titleH     = 26,
    panelW     = 200,
}

-- Helpers 
local function mkCorner(parent, px)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, px)
    c.Parent = parent
end

local function tween(obj, t, props, style, dir)
    style = style or Enum.EasingStyle.Quint
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
end

-- Main Builder 
local function CreateMiniToggle(opts)
    opts        = opts  or {}
    local title = opts.title  or "BBG"
    local tOpts = opts.toggle or {}
    local iOpts = opts.input  or nil

    -- Panel height
    local contentH = UI.toggleRowH
                   + (iOpts and (UI.rowGap + UI.inputRowH) or 0)
    local panelH   = UI.titleH + UI.padding + contentH + UI.padding

    -- ScreenGui 
    local sg = Instance.new("ScreenGui")
    sg.Name           = "BBGMiniToggleUI"
    sg.ResetOnSpawn   = false
    sg.DisplayOrder   = 1002
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if not pcall(function() sg.Parent = CoreGui end) then
        sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Logo button 
    local logo = Instance.new("ImageButton", sg)
    logo.Size                   = UDim2.new(0, 38, 0, 38)
    logo.Position               = UDim2.new(0, 20, 0.5, -19)
    logo.BackgroundTransparency = 1
    logo.Image                  = "rbxassetid://104418583710842"
    logo.Active                 = true
    logo.Draggable              = true
    mkCorner(logo, 12)

    -- Main panel 
    local panel = Instance.new("Frame", sg)
    panel.Name                   = "MiniTogglePanel"
    panel.Size                   = UDim2.new(0, UI.panelW, 0, panelH)
    panel.Position               = UDim2.new(0, 80, 0.5, -(panelH / 2))
    panel.BackgroundColor3       = C.bg
    panel.BackgroundTransparency = C.bgTransparency
    panel.Active                 = true
    panel.Draggable              = true
    mkCorner(panel, UI.corner)

    -- Border
    local outerStroke = Instance.new("UIStroke", panel)
    outerStroke.Color           = C.borderColor
    outerStroke.Thickness       = 1.2
    outerStroke.Transparency    = C.borderAlpha
    outerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Gradient
    local grad = Instance.new("UIGradient", panel)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("2c0808")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("110303")),
    })
    grad.Rotation    = 140
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(1, 0.0),
    })

    -- Title 
    local titleLbl = Instance.new("TextLabel", panel)
    titleLbl.Size                   = UDim2.new(1, -(UI.padding * 2), 0, UI.titleH)
    titleLbl.Position               = UDim2.new(0, UI.padding, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text                   = title
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 11
    titleLbl.TextColor3             = C.text
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left

    -- Toggle row 
    local toggleOn = tOpts.default or false
    local rowY1    = UI.titleH + UI.padding

    local tRow = Instance.new("Frame", panel)
    tRow.Name                   = "ToggleRow"
    tRow.Size                   = UDim2.new(1, -(UI.padding * 2), 0, UI.toggleRowH)
    tRow.Position               = UDim2.new(0, UI.padding, 0, rowY1)
    tRow.BackgroundColor3       = C.rowColor
    tRow.BackgroundTransparency = C.rowTransparency
    mkCorner(tRow, UI.corner)

    local tLabel = Instance.new("TextLabel", tRow)
    tLabel.Size                   = UDim2.new(0.65, 0, 1, 0)
    tLabel.Position               = UDim2.new(0, 12, 0, 0)
    tLabel.BackgroundTransparency = 1
    tLabel.Text                   = tOpts.label or "Enable"
    tLabel.Font                   = Enum.Font.Gotham
    tLabel.TextSize               = 11
    tLabel.TextColor3             = C.text
    tLabel.TextXAlignment         = Enum.TextXAlignment.Left

    local track = Instance.new("Frame", tRow)
    track.Name             = "Track"
    track.Size             = UDim2.new(0, 36, 0, 18)
    track.Position         = UDim2.new(1, -44, 0.5, -9)
    track.BackgroundColor3 = toggleOn and C.toggleOn or C.toggleOff
    mkCorner(track, 9)

    local handle = Instance.new("Frame", track)
    handle.Name             = "Handle"
    handle.Size             = UDim2.new(0, 14, 0, 14)
    handle.Position         = toggleOn
        and UDim2.new(1, -16, 0.5, -7)
        or  UDim2.new(0,  2,  0.5, -7)
    handle.BackgroundColor3 = C.handle
    mkCorner(handle, 7)

    local handleGlow = Instance.new("ImageLabel", handle)
    handleGlow.Size                   = UDim2.new(1, 2, 1, 2)
    handleGlow.Position               = UDim2.new(0, -1, 0, -1)
    handleGlow.BackgroundTransparency = 1
    handleGlow.Image                  = "rbxassetid://89641024074289"
    handleGlow.ImageColor3            = Color3.new(1, 1, 1)
    handleGlow.ImageTransparency      = 0.7

    local trackBtn = Instance.new("TextButton", tRow)
    trackBtn.Size                   = UDim2.new(1, 0, 1, 0)
    trackBtn.BackgroundTransparency = 1
    trackBtn.Text                   = ""
    trackBtn.ZIndex                 = 10

    local function setToggle(state, skipCallback)
        toggleOn = state
        tween(track, 0.1, { BackgroundColor3 = state and C.toggleOn or C.toggleOff }):Play()
        tween(
            handle, 0.35,
            { Position = state
                and UDim2.new(1, -16, 0.5, -7)
                or  UDim2.new(0,  2,  0.5, -7) },
            Enum.EasingStyle.Back, Enum.EasingDirection.Out
        ):Play()
        if not skipCallback and tOpts.callback then
            pcall(tOpts.callback, state)
        end
    end

    trackBtn.MouseButton1Click:Connect(function()
        setToggle(not toggleOn)
    end)

    -- Input row 
    if iOpts then
        local rowY2 = rowY1 + UI.toggleRowH + UI.rowGap

        local iRow = Instance.new("Frame", panel)
        iRow.Name                   = "InputRow"
        iRow.Size                   = UDim2.new(1, -(UI.padding * 2), 0, UI.inputRowH)
        iRow.Position               = UDim2.new(0, UI.padding, 0, rowY2)
        iRow.BackgroundColor3       = C.rowColor
        iRow.BackgroundTransparency = C.rowTransparency
        mkCorner(iRow, UI.corner)

        local iLabel = Instance.new("TextLabel", iRow)
        iLabel.Size                   = UDim2.new(0.52, 0, 1, 0)
        iLabel.Position               = UDim2.new(0, 12, 0, 0)
        iLabel.BackgroundTransparency = 1
        iLabel.Text                   = iOpts.label or "Value"
        iLabel.Font                   = Enum.Font.Gotham
        iLabel.TextSize               = 11
        iLabel.TextColor3             = C.text
        iLabel.TextXAlignment         = Enum.TextXAlignment.Left

        local iBoxBg = Instance.new("Frame", iRow)
        iBoxBg.Name                   = "InputBg"
        iBoxBg.Size                   = UDim2.new(0, 64, 0, 22)
        iBoxBg.Position               = UDim2.new(1, -72, 0.5, -11)
        iBoxBg.BackgroundColor3       = C.rowColor
        iBoxBg.BackgroundTransparency = 0.95
        mkCorner(iBoxBg, UI.corner)

        local iBox = Instance.new("TextBox", iBoxBg)
        iBox.Size                   = UDim2.new(1, -12, 1, 0)
        iBox.Position               = UDim2.new(0, 6, 0, 0)
        iBox.BackgroundTransparency = 1
        iBox.Text                   = iOpts.default     or ""
        iBox.PlaceholderText        = iOpts.placeholder or "..."
        iBox.PlaceholderColor3      = C.placeholder
        iBox.Font                   = Enum.Font.GothamBold
        iBox.TextSize               = 11
        iBox.TextColor3             = C.text
        iBox.TextXAlignment         = Enum.TextXAlignment.Center
        iBox.ClearTextOnFocus       = false

        iBox.FocusLost:Connect(function()
            if iOpts.callback then
                pcall(iOpts.callback, iBox.Text)
            end
        end)
    end

    -- Logo toggles panel 
    logo.MouseButton1Click:Connect(function()
        panel.Visible = not panel.Visible
    end)

    -- Drag support 
    local dragging, dragStart, panelStart = false, nil, nil
    local cam = workspace.CurrentCamera

    panel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging   = true
            dragStart  = input.Position
            panelStart = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    panel.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            local d  = input.Position - dragStart
            local vp = cam.ViewportSize
            panel.Position = UDim2.new(0,
                math.clamp(panelStart.X.Offset + d.X, 0, vp.X - panel.AbsoluteSize.X),
                0,
                math.clamp(panelStart.Y.Offset + d.Y, 0, vp.Y - panel.AbsoluteSize.Y)
            )
        end
    end)

    -- Public API 
    return {
        ScreenGui = sg,
        Panel     = panel,
        Logo      = logo,
        SetToggle = setToggle,
        Destroy   = function() sg:Destroy() end,
    }
end

return CreateMiniToggle
