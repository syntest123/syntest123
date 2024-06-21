local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'pf.lol | Beta | Made by https://discord.gg/YedBXBG5f4',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--// Defined

local Camera = workspace.CurrentCamera
local Players = workspace.Players
local Ignore = workspace.Ignore
local DeadBodies = workspace.Ignore.DeadBody
local Misc = Ignore.Misc

--// Roblox

local Vector3New = Vector3.new
local CFrameNew = CFrame.new

--// Services

local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

--// Tables

local Tabs = {
    AimbotTab = Window:AddTab('Aimbot'),
    VisualsTab = Window:AddTab('Visuals'),
    MiscTab = Window:AddTab('Misc'),
    Settings = Window:AddTab('Settings'),
}

local Sections = {

    --// Aimbot Tab

    Aimbot = Tabs.AimbotTab:AddLeftGroupbox('Aimbot'),
    AimbotSettings = Tabs.AimbotTab:AddRightGroupbox('Aimbot Settings'),
    
    --// Visuals Tab

    Visuals = Tabs.VisualsTab:AddLeftGroupbox('Visuals'),
    VisualSettings = Tabs.VisualsTab:AddRightGroupbox('Configuration'),

    Grenade = Tabs.VisualsTab:AddLeftGroupbox('Grenades'),
    Misc = Tabs.MiscTab:AddLeftGroupbox('Misc'),
    Player = Tabs.MiscTab:AddLeftGroupbox('Player'),
}

local FeatureTable = {
    Combat = {
        SilentAim = {Enabled = false, Hitchance = 100, DummyRange = 0, DynamicFOV = false},
        WallCheck = false,
        TeamCheck = false,
        Hitpart = "Head", --// 6 = Torso, 7 = Head
    },
    Visuals = {
        --// Features \\--
        Box = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
        Box3D = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Method = "Flat"},
        Tracers = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Origin = "Middle", End = "Head"}, --// 7 = head, 6 = torso (index)
        Chams = {Enabled = false, FillColor = Color3.fromRGB(255, 255, 255), OutlineColor = Color3.fromRGB(255, 255, 255), VisibleOnly = false, FillTransparency = 0, OutlineTransparency = 0},
        Dynamic = true,
        TeamCheck = false,
        UseTeamColor = false, --// Team colors dont apply to chams btw
        --// Other \\--
        Lighting = {
            OverrideAmbient = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
        },
        Grenade = {
            GrenadeESP = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), Transparency = 0},
            TrailModifier = {Enabled = false, Color = Color3.fromRGB(255, 255, 255), TrailLifetime = 0.55},
        },
        ForceFieldArms = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
        ForceFieldWeapons = {Enabled = false, Color = Color3.fromRGB(255, 255, 255)},
    },
    Misc = {
        Player = {
            Fly = {Enabled = false, Speed = 0},
            Bhop = false,
            JumpPowerModifier = {Enabled = false, Power = 50},
            HipHeight = 0,
        },
        Watermark = {
            Enabled = false,
            Color = Color3.fromRGB(255, 255, 255),
            Theme = 'Galaxy Theme',
            X = 0,
            Y = 0
        }
    },
}

local Storage = {
    Identifiers = {
        Head = Vector3.new(1,1,1),
        Torso = Vector3.new(2,2,1),
    },
    BoxIndex = {
        {1, 2}, {2, 3}, {3, 4}, {4, 1},
        {5, 6}, {6, 7}, {7, 8}, {8, 5},
        {1, 5}, {2, 6}, {3, 7}, {4, 8} 
    },
    ESP = {
        Boxes = {},
        Box3D = {},
        Tracers = {},
        Chams = {},
    },
    Other = {
        ViewportSize = Camera.ViewportSize,
        ClosestPlayer = nil,
    },
}

local Functions = {
    Normal = {},
    ESP = {},
}

--// Objects

local FOVCircle = Drawing.new("Circle")
do --// Drawing object properties

    do --// Circle

        FOVCircle.Transparency = 1
        FOVCircle.Visible = false
        FOVCircle.Color = Color3.fromRGB(255, 255, 255)
        FOVCircle.Radius = 0
        
    end
    
end

-- def not in the do

local GalaxyTheme_2
local OneColorTheme
local pflolTheme
local RainbowTheme
local Main

-- Instance
local Watermark = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))

do -- Properties & Rest
    Main = Instance.new("Frame", Watermark)
    local TextLabel = Instance.new("TextLabel", Main)
    local GalaxyTheme = Instance.new("UIStroke", Main)
    RainbowTheme = Instance.new("UIGradient", GalaxyTheme)
    GalaxyTheme_2 = Instance.new("UIGradient", GalaxyTheme)
    OneColorTheme = Instance.new("UIGradient", GalaxyTheme)
    pflolTheme = Instance.new("UIGradient", GalaxyTheme)
    
    do -- Properties

        -- Watermark properties
        Watermark.Enabled = false
        Watermark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Watermark.Name = "Watermark"

        -- Main properties
        Main.Name = "Main"
        Main.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
        Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Main.BorderSizePixel = 0
        Main.Position = UDim2.new(0, 0, 0.147642687, 0)
        Main.Size = UDim2.new(0, 293, 0, 34)

        -- TextLabel properties
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel.BorderSizePixel = 0
        TextLabel.Position = UDim2.new(0, 0, 0, 0)
        TextLabel.Size = UDim2.new(0, 293, 0, 33)
        TextLabel.Font = Enum.Font.RobotoMono
        TextLabel.Text = "pf.lol | Beta"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextScaled = true
        TextLabel.TextSize = 14.000
        TextLabel.TextWrapped = true

        -- GalaxyTheme properties
        GalaxyTheme.Color = Color3.fromRGB(255, 255, 255)
        GalaxyTheme.Thickness = 2.5
        GalaxyTheme.Name = "GalaxyTheme"

        -- RainbowTheme properties
        RainbowTheme.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 165, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 128, 0)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(238, 130, 238))}
        RainbowTheme.Name = "RainbowTheme"

        -- GalaxyTheme_2 properties
        GalaxyTheme_2.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(16, 9, 112)), 
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(60, 24, 144)), 
            ColorSequenceKeypoint.new(0.63, Color3.fromRGB(125, 0, 209)), 
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(51, 24, 159))}
        GalaxyTheme_2.Name = "GalaxyTheme_2"

        -- OneColorTheme properties
        OneColorTheme.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), 
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
        OneColorTheme.Name = "OneColorTheme"

        -- pflolTheme properties
        pflolTheme.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(43, 255, 114)), 
            ColorSequenceKeypoint.new(0.38, Color3.fromRGB(255, 112, 150)), 
            ColorSequenceKeypoint.new(0.51, Color3.fromRGB(85, 170, 255)), 
            ColorSequenceKeypoint.new(0.77, Color3.fromRGB(85, 0, 255)), 
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 139, 44))}
        pflolTheme.Name = "pflolTheme"

        -- Disable non-default themes
        GalaxyTheme_2.Enabled = true
        RainbowTheme.Enabled = false
        OneColorTheme.Enabled = false
        pflolTheme.Enabled = false
    end
end

-- Function to update the theme
local function updateTheme(themeName)
    GalaxyTheme_2.Enabled = themeName == "GalaxyTheme_2"
    RainbowTheme.Enabled = themeName == "RainbowTheme"
    OneColorTheme.Enabled = themeName == "OneColorTheme"
    pflolTheme.Enabled = themeName == "pflolTheme"
end

--// Rest

do --// Main
    Library:Notify("I am aware of the optimization issues, they will be fixed in the near future", 5)

    do --// Elements

        do --// Aimbot Tab

            Sections.Aimbot:AddToggle('SilentAim', {
                Text = 'Silent Aim',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Combat.SilentAim.Enabled = Value
                end
            })

            Sections.Aimbot:AddToggle('VisualiseRange', {
                Text = 'FOV',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FOVCircle.Visible = Value
                end
            }):AddColorPicker('VisualiseRangeColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Range Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FOVCircle.Color = Value
                end
            })


            Sections.Aimbot:AddSlider('AimbotRange', {
                Text = 'Range',
                Default = 0,
                Min = 0,
                Max = 1000,
                Rounding = 1,
                Compact = false,

                Callback = function(Value)
                    FeatureTable.Combat.SilentAim.DummyRange = Value --// im not gonna use flags, but feel free to switch to it :D
                end
            })

            Sections.Aimbot:AddDropdown('Aimpart', {
                Values = { 'Head', 'Torso', 'Random' },
                Default = 1,
                Multi = false,
            
                Text = 'Aim Part',
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Combat.Hitpart = Value
                end
            })

            --// Aimbot Settings

            Sections.AimbotSettings:AddToggle('WallCheck', {
                Text = 'Wall Check',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Combat.WallCheck = Value
                end
            })

            Sections.AimbotSettings:AddToggle('TeamCheck', {
                Text = 'Team Check',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Combat.TeamCheck = Value
                end
            })

            Sections.AimbotSettings:AddSlider('Hitchance', {
                Text = 'Hitchance',
                Default = 100,
                Min = 0,
                Max = 100,
                Rounding = 1,
                Compact = false,
            
                Callback = function(Value)
                    FeatureTable.Combat.SilentAim.Hitchance = Value
                end
            })
    
        end

        do --// Visuals Tab

            Sections.Visuals:AddToggle('Box', {
                Text = 'Box',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Box.Enabled = Value
                end
            }):AddColorPicker('BoxColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Box Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Box.Color = Value
                end
            })

            Sections.Visuals:AddToggle('Tracers', {
                Text = 'Tracers',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Tracers.Enabled = Value
                end
            }):AddColorPicker('TracerColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Tracer Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Tracers.Color = Value
                end
            })



            --// lmao ahah

            local saveFolder
            local toggleStateArms = false
            local toggleStateMain = false
            local forceFieldColorArms = Color3.fromRGB(255, 255, 255)
            local forceFieldColor = Color3.fromRGB(255, 255, 255)
            
            local function moveArmsToSaveFolder()
                saveFolder = game:GetService("ServerStorage"):FindFirstChild("Save")
                if not saveFolder then
                    saveFolder = Instance.new("Folder")
                    saveFolder.Name = "Save"
                    saveFolder.Parent = ServerStorage
                end
            
                local leftArm = game.Workspace.Camera:FindFirstChild("Left Arm")
                local rightArm = game.Workspace.Camera:FindFirstChild("Right Arm")
            
                if leftArm then
                    for _, part in ipairs(leftArm:GetChildren()) do
                        if part.ClassName == "Texture" then
                            part:Destroy()
                        elseif part.Name ~= "SkinTone" and part.Name ~= "Arm" then
                            part.Parent = saveFolder
                        end
                    end
                    leftArm.SkinTone.Material = Enum.Material.ForceField
                    leftArm.SkinTone.Color = forceFieldColorArms
                end
            
                if rightArm then
                    for _, part in ipairs(rightArm:GetChildren()) do
                        if part.ClassName == "Texture" then
                            part:Destroy()
                        elseif part.Name ~= "SkinTone" and part.Name ~= "Arm" then
                            part.Parent = saveFolder
                        end
                    end
                    rightArm.SkinTone.Material = Enum.Material.ForceField
                    rightArm.SkinTone.Color = forceFieldColorArms
                end
            end
            
            local function restoreArmsFromSaveFolder()
                if saveFolder then
                    local leftArm = game.Workspace.Camera:FindFirstChild("Left Arm")
                    local rightArm = game.Workspace.Camera:FindFirstChild("Right Arm")
            
                    if leftArm then
                        for _, part in ipairs(saveFolder:GetChildren()) do
                            if part:IsA("BasePart") and not part:IsDescendantOf(leftArm) then
                                part.Parent = leftArm
                            end
                        end
                        leftArm.SkinTone.Material = Enum.Material.SmoothPlastic
                        leftArm.SkinTone.Color = Color3.fromRGB(255, 204, 153)
                    end
            
                    if rightArm then
                        for _, part in ipairs(saveFolder:GetChildren()) do
                            if part:IsA("BasePart") and not part:IsDescendantOf(rightArm) then
                                part.Parent = rightArm
                            end
                        end
                        rightArm.SkinTone.Material = Enum.Material.SmoothPlastic
                        rightArm.SkinTone.Color = Color3.fromRGB(255, 204, 153)
                    end
                    saveFolder:Destroy()
                end
            end
            
            local function changeMainModelsToForceField()
                for _, model in ipairs(game.Workspace.Camera:GetChildren()) do
                    if model:IsA("Model") and model.Name:find("Main") then
                        for _, part in ipairs(model:GetDescendants()) do
                            if part.ClassName == "Texture" then
                                part:Destroy()
                            elseif part:IsA("BasePart") and part.Name ~= "Sucking" then
                                part:SetAttribute("OriginalMaterial", part.Material)
                                part:SetAttribute("OriginalColor", part.Color)
                                part.Material = Enum.Material.ForceField
                                part.Color = forceFieldColor
                            end
                        end
                    end
                end
            end            
            
            local function restoreMainModels()
                for _, model in ipairs(game.Workspace.Camera:GetChildren()) do
                    if model:IsA("Model") and model.Name:find("Main") then
                        for _, part in ipairs(model:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "Sucking" then
                                local originalMaterial = part:GetAttribute("OriginalMaterial")
                                local originalColor = part:GetAttribute("OriginalColor")
                                if originalMaterial and originalColor then
                                    part.Material = originalMaterial
                                    part.Color = originalColor
                                end
                            end
                        end
                    end
                end
            end            
            
            local function monitorArms()
                game:GetService("RunService").Heartbeat:Connect(function()
                    if toggleStateArms then
                        local leftArm = game.Workspace.Camera:FindFirstChild("Left Arm")
                        local rightArm = game.Workspace.Camera:FindFirstChild("Right Arm")
            
                        if leftArm then
                            for _, part in ipairs(leftArm:GetChildren()) do
                                if part.ClassName == "Texture" then
                                    part:Destroy()
                                end
                            end
                            if leftArm.SkinTone.Material ~= Enum.Material.ForceField then
                                moveArmsToSaveFolder()
                            end
                            leftArm.SkinTone.Color = forceFieldColorArms
                        end
            
                        if rightArm then
                            for _, part in ipairs(rightArm:GetChildren()) do
                                if part.ClassName == "Texture" then
                                    part:Destroy()
                                end
                            end
                            if rightArm.SkinTone.Material ~= Enum.Material.ForceField then
                                moveArmsToSaveFolder()
                            end
                            rightArm.SkinTone.Color = forceFieldColorArms
                        end
                    end
                end)
            end
            
            local function FoundMainName()
                game:GetService("RunService").Heartbeat:Connect(function()
                    if toggleStateMain then
                        for _, model in ipairs(game.Workspace.Camera:GetChildren()) do
                            if model:IsA("Model") and model.Name:find("Main") then
                                for _, part in ipairs(model:GetDescendants()) do
                                    if part.ClassName == "Texture" then
                                        part:Destroy()
                                    elseif part:IsA("BasePart") and part.Name ~= "Sucking" and part.Material ~= Enum.Material.ForceField then
                                        part.Material = Enum.Material.ForceField
                                        part.Color = forceFieldColor
                                    end
                                end
                            end
                        end
                    end
                end)
            end            
            
            Sections.Visuals:AddToggle('ForceFieldArms', {
                Text = 'ForceField Arms',
                Default = false,
                Tooltip = nil,
            
                Callback = function(state)
                    FeatureTable.Visuals.ForceFieldArms.Enabled = state
                    toggleStateArms = state
                    if state then
                        moveArmsToSaveFolder()
                        monitorArms()
                    else
                        restoreArmsFromSaveFolder()
                    end
                end
            }):AddColorPicker('ForceFieldArmsColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'ForceField Color',
                Transparency = 0,
            
                Callback = function(color)
                    FeatureTable.Visuals.ForceFieldArms.Color = color
                    forceFieldColorArms = color
                    local leftArm = game.Workspace.Camera:FindFirstChild("Left Arm")
                    local rightArm = game.Workspace.Camera:FindFirstChild("Right Arm")
            
                    if leftArm then
                        leftArm.SkinTone.Color = forceFieldColorArms
                    end
            
                    if rightArm then
                        rightArm.SkinTone.Color = forceFieldColorArms
                    end
                end
            })
            
            Sections.Visuals:AddToggle('ForceFieldWeapons', {
                Text = 'ForceField Weapons',
                Default = false,
                Tooltip = nil,
            
                Callback = function(state)
                    FeatureTable.Visuals.ForceFieldWeapons.Enabled = state
                    toggleStateMain = state
                    if state then
                        changeMainModelsToForceField()
                        FoundMainName()
                    else
                        restoreMainModels()
                    end
                end
            }):AddColorPicker('ForceFieldWeaponsColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'ForceField Color Weapons',
                Transparency = 0,
            
                Callback = function(color)
                    FeatureTable.Visuals.ForceFieldWeapons.Color = color
                    forceFieldColor = color
                    for _, model in ipairs(game.Workspace.Camera:GetChildren()) do
                        if model:IsA("Model") and model.Name:find("Main") then
                            for _, part in ipairs(model:GetDescendants()) do
                                if part:IsA("BasePart") and part.Name ~= "Sucking" then
                                    part.Color = forceFieldColor
                                end
                            end
                        end
                    end
                end
            })
            
            --// Settings

            Sections.VisualSettings:AddToggle('TeamCheck', {
                Text = 'Team Check',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.TeamCheck = Value
                end
            })

 
            --// Lighting Section



            --// Grenade Section

            Sections.Grenade:AddToggle('Grenade', {
                Text = 'Grenade ESP',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Grenade.GrenadeESP.Enabled = Value
                end
            }):AddColorPicker('GrenadeColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'Grenade Color',
                Transparency = 0,
            
                Callback = function(Value)
                    FeatureTable.Visuals.Grenade.GrenadeESP.Color = Value
                end
            })

        end

        do --// Misc Tab
            
            -- Dropdown for Theme selection
            Sections.Misc:AddToggle('Watermark', {
                Text = 'Watermark',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Misc.Watermark.Enabled = Value
                    Watermark.Enabled = Value
                end
            }):AddColorPicker('OneColor', {
                Default = Color3.fromRGB(255, 255, 255),
                Title = 'One Color Theme Changer',
                Transparency = 0,
            
                Callback = function(Color)
                    FeatureTable.Misc.Watermark.Color = Color
                    if OneColorTheme then
                        OneColorTheme.Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0.00, Color),
                            ColorSequenceKeypoint.new(1.00, Color)
                        }
                    end
                end
            })
            
            Sections.Misc:AddDropdown('ThemeWaterMark', {
                Values = { 'Galaxy Theme', 'One Color Theme', 'pflol Theme', 'Rainbow Theme' },
                Default = 1,
                Multi = false,
            
                Text = 'Theme WaterMark',
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Misc.Watermark.Theme = Value
            
                    -- Disable all themes initially
                    if GalaxyTheme_2 then
                        GalaxyTheme_2.Enabled = false
                    end
                    if OneColorTheme then
                        OneColorTheme.Enabled = false
                    end
                    if pflolTheme then
                        pflolTheme.Enabled = false
                    end
                    if RainbowTheme then
                        RainbowTheme.Enabled = false
                    end
            
                    if currentTween then
                        currentTween:Cancel()
                        currentTween = nil
                    end
            
                    -- Re-enable the selected theme
                    if Value == 'Galaxy Theme' then
                        if GalaxyTheme_2 then
                            GalaxyTheme_2.Enabled = true
                        end
                    elseif Value == 'One Color Theme' then
                        if OneColorTheme then
                            OneColorTheme.Enabled = true
                        end
                    elseif Value == 'pflolTheme Theme' then
                        if pflolTheme then
                            pflolTheme.Enabled = true
                        end
                    elseif Value == 'Rainbow Theme' then
                        if RainbowTheme then
                            RainbowTheme.Enabled = true
                        end
                    end
                end
            })
            
            -- // Take XScreen and YScreen
            local screenWidth = game:GetService("Workspace").CurrentCamera.ViewportSize.X
            local screenHeight = game:GetService("Workspace").CurrentCamera.ViewportSize.Y
            
            Main.Changed:Wait()
            
            --// Take XMainUI and YMainUI
            local mainWidth = Main.Size.X.Offset
            local mainHeight = Main.Size.Y.Offset
            
            Sections.Misc:AddSlider('ChangeXWatermark', {
                Text = 'X',
                Default = 0,
                Min = 0,
                Max = screenWidth,
                Rounding = 1,
                Compact = false,
                Callback = function(value)
                    FeatureTable.Misc.Watermark.X = value
                    local newPositionX = UDim2.new(math.max((value - mainWidth) / screenWidth, 0), 0, Main.Position.Y.Scale, Main.Position.Y.Offset)
                    Main.Position = newPositionX
                end
            })
            
            Sections.Misc:AddSlider('ChangeYWatermark', {
                Text = 'Y',
                Default = 0,
                Min = 0,
                Max = screenHeight - mainHeight,
                Rounding = 1,
                Compact = false,
                Callback = function(value)
                    FeatureTable.Misc.Watermark.Y = value
                    local newPositionY = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, (value - mainHeight) / (screenHeight - mainHeight), 0)
                    Main.Position = newPositionY
                end
            })

            --// Player section

            Sections.Player:AddToggle('Fly', {
                Text = 'Fly',
                Default = false,
                Tooltip = nil,
            
                Callback = function(Value)
                    FeatureTable.Misc.Player.Fly.Enabled = Value
                end
            })

            Sections.Player:AddSlider('FlySpeed', {
                Text = 'Fly Speed',
                Default = 0,
                Min = 0,
                Max = 50,
                Rounding = 1,
                Compact = false,
            
                Callback = function(Value)
                    FeatureTable.Misc.Player.Fly.Speed = Value
                end
            })

        end
        
    end
    
    do --// Logic

        do --// Functions

            do --// Regular

                do --// Lighting

                    function Functions.Normal:SetAmbient(Property, Value)
                        if FeatureTable.Visuals.Lighting.OverrideAmbient.Enabled then
                            Lighting[Property] = Value
                        end
                    end
                    
                end

                do --// Players

                    function Functions.Normal:GetTeam(Player)
                        if Player ~= nil and Player.Parent ~= nil and Player:FindFirstChildOfClass("Folder") then
                            local Helmet = Player:FindFirstChildWhichIsA("Folder"):FindFirstChildOfClass("MeshPart")
                            if Helmet then
                                if Helmet.BrickColor == BrickColor.new("Black") then
                                    return game.Teams.Phantoms
                                end
                                return game.Teams.Ghosts
                            end
                        end
                    end
                    function Functions.Normal:GetPlayerBodyparts(Player)
                        local Head
                        local Torso
                        local Children = Player:GetChildren()
                        local HeadSize = Storage.Identifiers.Head
                        local TorsoSize = Storage.Identifiers.Torso
                    
                        for i = 1, #Children do
                            local Child = Children[i]
                            if Child:IsA("BasePart") then
                                if Child.Size == HeadSize then
                                    Head = Child
                                elseif Child.Size == TorsoSize then
                                    Torso = Child
                                end
                            end
                        end
                    
                        return { Head = Head, Torso = Torso }
                    end                                      

                    function Functions.Normal:GetPlayers()
                        local PlayerList = {}
                        for i,Teams in Players:GetChildren() do
                            for i,Players in Teams:GetChildren() do
                                table.insert(PlayerList, Players)
                            end
                        end
                        return PlayerList
                    end
                    
                end
                
                do --// LocalPlayer
                    function Functions.Normal:GetGun()
                        for i,Viewmodel in Camera:GetChildren() do
                            if Viewmodel:IsA("Model") and not Viewmodel.Name:find("Arm") then
                                return Viewmodel
                            end
                        end
                        return nil
                    end
                end

                do --// Math

                    function Functions.Normal:Measure(Origin, End)
                        return (Origin - End).Magnitude
                    end

                    function Functions.Normal:GetLength(Table) --// This isnt even math btw, but its not related to any of the other sections so whatever lol
                        local Int = 0
                        for WhatTheSigma in Table do
                            Int += 1
                        end
                        return Int
                    end

                end
    
            end
    
            do --// Aimbot
                
                function Functions.Normal:getClosestPlayer()
                    local Player = nil
                    local Hitpart = nil
                    local Distance = math.huge
                
                    for i, Players in Functions.Normal:GetPlayers() do
                        if Players ~= nil then
                            local Bodyparts = Functions.Normal:GetPlayerBodyparts(Players)

                            local Screen = Camera:WorldToViewportPoint(Bodyparts.Torso.Position)
                            local MeasureDistance = (Vector2.new(Storage.Other.ViewportSize.X / 2, Storage.Other.ViewportSize.Y / 2) - Vector2.new(Screen.X, Screen.Y)).Magnitude
                
                            local PlayerIsVisible = (not FeatureTable.Combat.WallCheck) or Functions.Normal:PlayerVisible(Players, Camera.CFrame.Position, Bodyparts.Torso.Position, {Misc, Ignore, Players:FindFirstChildOfClass("Folder")})
                
                            if MeasureDistance < Distance and MeasureDistance <= FOVCircle.Radius * 1.25 and PlayerIsVisible then
                                Player = Players
                                Distance = MeasureDistance
                
                                if tostring(FeatureTable.Combat.Hitpart):find("Random") then
                                    print("Random")
                                    local Keys = {}
                
                                    do --// WhatTheSigma
                                        for WhatTheSigma in Storage.Identifiers do
                                            table.insert(Keys, WhatTheSigma)
                                        end
                                    end
                
                                    local Index = math.random(1, Functions.Normal:GetLength(Keys))
                                    local Rndm = Keys[Index]
                                    if Rndm ~= "Random" then
                                        Hitpart = Bodyparts[Rndm]
                                    end
                                else
                                    Hitpart = Bodyparts[FeatureTable.Combat.Hitpart]
                                end
                            end
                        end
                    end
                
                    return {Closest = Player, Hitpart = Hitpart}
                end

                function Functions.Normal:PlayerVisible(Player, Origin, End, Ignorelist)

                    local Params = RaycastParams.new()
                    do --// Param Properties

                        Params.FilterDescendantsInstances = Ignorelist
                        Params.FilterType = Enum.RaycastFilterType.Exclude
                        Params.IgnoreWater = true
                        
                    end

                    local CastRay = workspace:Raycast(Origin, End - Origin, Params)
                    if CastRay and CastRay.Instance then
                        if CastRay.Instance:IsDescendantOf(Player) then
                            return true
                        end
                    end
                    return false
        
                end
    
            end
    
            do --// ESP
                function Functions.ESP:Create(Player)
        
                    if FeatureTable.Visuals.Box.Enabled then

                        if not table.find(Storage.ESP.Boxes, Player) then
        
                            local Box = Drawing.new("Square")
                            Box.Color = Color3.fromRGB(255,255,255)
                            Box.Transparency = 1
                            Box.Visible = true
                            Box.Thickness = 1
                            Box.ZIndex = 2
                            
                            do --// Table insert
            
                                table.insert(Storage.ESP.Boxes, Box)
                                table.insert(Storage.ESP.Boxes, Player)
            
                            end
                    
                        end

                    end
                    if FeatureTable.Visuals.Tracers.Enabled then

                        if not table.find(Storage.ESP.Tracers, Player) then
        
                            local Tracer = Drawing.new("Line")
                            Tracer.Transparency = 1
                            Tracer.Visible = true
                            Tracer.Color = Color3.fromRGB(255,255,255)
                            
                            do --// Table insert
            
                                table.insert(Storage.ESP.Tracers, Tracer)
                                table.insert(Storage.ESP.Tracers, Player)
            
                            end
                    
                        end
                        
                    end
                    if FeatureTable.Visuals.Box3D.Enabled then
                        if not table.find(Storage.ESP.Box3D, Player) then
                            local Lines = {}
                            
                            for i = 1, 12 do
                                local Line = Drawing.new("Line")
                                Line.Transparency = 1
                                Line.Color = Color3.fromRGB(255, 255, 255)
                                Line.Visible = false
                                table.insert(Lines, Line)
                            end
                    
                            do --// Table insert
                                table.insert(Storage.ESP.Box3D, Lines)
                                table.insert(Storage.ESP.Box3D, Player)
                            end
                        end
                    end
        
                end
    
                function Functions.ESP:ClearTable(esps, esptable, index)
                    for i = 1, #esps do
                        esps[i]:Destroy()
                    end
                    do --// Table clear
                        table.remove(esptable, index)
                        table.remove(esptable, index-1)
                    end
                end

            end
    
        end
    
        do --// Loops
    
            task.spawn(function()
                while task.wait() do --// gl working with the dogshit code, skids :D
    
                    do --// Combat
    
                        do --// Aimbot
    
                            if FeatureTable.Combat.SilentAim.Enabled then

                                local Enemy = Storage.Other.ClosestPlayer
                                local Target = Enemy.Closest
                                if Target ~= nil and (FeatureTable.Combat.TeamCheck and Functions.Normal:GetTeam(Target) ~= game.Players.LocalPlayer.Team or not FeatureTable.Combat.TeamCheck) then

                                    local Hitpart = Enemy.Hitpart
                                    local Gun = Functions.Normal:GetGun()

                                    if Hitpart and Gun then
                                        for i, GunParts in Gun:GetChildren() do
                                            pcall(function()
                                                local Joints = GunParts:GetJoints()
                                                if GunParts.Name:find("SightMark") or GunParts.Name:find("FlameSUP") or GunParts.Name:find("Flame") then
                                                    local Vector = Vector3New()
                                    
                                                    do --// Hitchance

                                                        local Chance = FeatureTable.Combat.SilentAim.Hitchance
                                                        if Chance < 100 then --// Pretty awful but it works
                                                            local MissChance = (100 - Chance) / 100
                                                            local x = math.random() * 3 - 1
                                                            local y = math.random() * 3 - 1
                                                            local z = math.random() * 3 - 1 
                                                            Vector = Vector3New(x, y, z) * MissChance
                                                        end

                                                    end
                                    
                                                    Joints[1].C0 = Joints[1].Part0.CFrame:ToObjectSpace(CFrame.lookAt(Joints[1].Part1.Position, (Hitpart.Position + Vector)))
                                                end
                                            end)
                                        end
                                    end

                                end

                            end
                            
    
                        end
    
                    end
    
                    do --// Visuals

                        for i,Players in Functions.Normal:GetPlayers() do --// bro... so p1000
                            Functions.ESP:Create(Players)
                        end
    
                        do --// Box ESP
    
                            for i,Player in Storage.ESP.Boxes do --// Box logic (obviously)
                                if typeof(Player) == "Instance" then
    
                                    local Box = Storage.ESP.Boxes[i-1]
                    
                                    if FeatureTable.Visuals.Box.Enabled and Player:IsDescendantOf(workspace) and not tostring(Player:GetFullName()):find(tostring(DeadBodies)) then
                                        local Bodyparts = Functions.Normal:GetPlayerBodyparts(Player)
                                        local Torso = Bodyparts.Torso
                                        if Torso ~= nil then
                                            local Position, OnScreen = Camera:WorldToViewportPoint(Torso.Position) --// Convert to screen pos since we're rendering the boxes on the screen (duh)
    
                                            local Team = Functions.Normal:GetTeam(Player)
                                            local TeamColor = Team.TeamColor
                    
                                            if OnScreen and FeatureTable.Visuals.TeamCheck and tostring(Team) ~= game.Players.LocalPlayer.Team.Name or not FeatureTable.Visuals.TeamCheck then
                    
                                                local PosX = Position.X - (Box.Size.X / 2)
                                                local PosY = Position.Y - (Box.Size.Y / 2)
                                                local Scale = 1000/(Camera.CFrame.Position - Torso.Position).Magnitude*80/Camera.FieldOfView --// Very simple box distance scale
                                                
                                                Box.Position = Vector2.new(PosX, PosY)
                                                Box.Size = Vector2.new(2 * Scale, 3 * Scale)
                                                Box.Visible = true

                                                if FeatureTable.Visuals.UseTeamColor then --// 😭
                                                    if tostring(TeamColor) == "Bright blue" then
                                                        Box.Color = Color3.fromRGB(0, 162, 255)
                                                    elseif tostring(TeamColor) == "Bright orange" then
                                                        Box.Color = Color3.fromRGB(255, 162, 0)
                                                    end
                                                else
                                                    Box.Color = FeatureTable.Visuals.Box.Color
                                                end
                    
                                            else
                    
                                                Functions.ESP:ClearTable({Box}, Storage.ESP.Boxes, i)
                    
                                            end
                    
                                        else
                    
                                            Functions.ESP:ClearTable({Box}, Storage.ESP.Boxes, i)
                    
                                        end
                                    else
                    
                                        Functions.ESP:ClearTable({Box}, Storage.ESP.Boxes, i)
                    
                                    end
                                end
                            end

                        end

                        do --// 3D Box
                            for i, Player in Storage.ESP.Box3D do
                                if typeof(Player) == "Instance" then
                                    local Objects = Storage.ESP.Box3D[i-1]
                                    
                                    if Objects then
                                        if FeatureTable.Visuals.Box3D.Enabled then
                                            local Bodyparts = Functions.Normal:GetPlayerBodyparts(Player)
                                            local Torso = Bodyparts.Torso
                                            local Team = Functions.Normal:GetTeam(Player)
                                            
                                            if Player and Torso and not tostring(Player:GetFullName()):find(tostring(DeadBodies)) and Team and Team.TeamColor then
                                                local a, Visible = Camera:WorldToViewportPoint(Torso.Position)
                                                local TeamColor = Team.TeamColor
                                                local Size = Vector3.new(2, 3, 1.5)
                                                local Corners = {
                                                    Torso.CFrame * CFrameNew(-Size.X, Size.Y, -Size.Z),
                                                    Torso.CFrame * CFrameNew(Size.X, Size.Y, -Size.Z),
                                                    Torso.CFrame * CFrameNew(Size.X, -Size.Y, -Size.Z),
                                                    Torso.CFrame * CFrameNew(-Size.X, -Size.Y, -Size.Z),
                                                    Torso.CFrame * CFrameNew(-Size.X, Size.Y, Size.Z),
                                                    Torso.CFrame * CFrameNew(Size.X, Size.Y, Size.Z),
                                                    Torso.CFrame * CFrameNew(Size.X, -Size.Y, Size.Z),
                                                    Torso.CFrame * CFrameNew(-Size.X, -Size.Y, Size.Z)
                                                }
                                                
                                                if FeatureTable.Visuals.TeamCheck and tostring(Team) ~= game.Players.LocalPlayer.Team.Name or not FeatureTable.Visuals.TeamCheck then
                                                    if FeatureTable.Visuals.Box3D.Method == "Flat" then
                                                        for iA = 1, 4 do
                                                            local Line = Objects[iA]
                                                            Line.Visible = Visible
                                                            if Visible then
                                                                local Next = (iA % 4) + 1
                                                                local ScreenPos1 = Camera:WorldToViewportPoint(Corners[iA].Position)
                                                                local ScreenPos2 = Camera:WorldToViewportPoint(Corners[Next].Position)
                                                                
                                                                Line.From = Vector2.new(ScreenPos1.X, ScreenPos1.Y)
                                                                Line.To = Vector2.new(ScreenPos2.X, ScreenPos2.Y)
                                                                
                                                                if FeatureTable.Visuals.UseTeamColor then
                                                                    if tostring(TeamColor) == "Bright blue" then
                                                                        Line.Color = Color3.fromRGB(0, 162, 255)
                                                                    elseif tostring(TeamColor) == "Bright orange" then
                                                                        Line.Color = Color3.fromRGB(255, 162, 0)
                                                                    end
                                                                else
                                                                    Line.Color = FeatureTable.Visuals.Box3D.Color
                                                                end
                                                            end
                                                        end
                                                    else
                                                        for iB = 1, 12 do
                                                            local Line = Objects[iB]
                                                            Line.Visible = Visible
                                                            
                                                            if Visible then
                                                                local b = Storage.BoxIndex[iB]
                                                                local c = Camera:WorldToViewportPoint(Corners[b[1]].Position)
                                                                local d = Camera:WorldToViewportPoint(Corners[b[2]].Position)
                                                                
                                                                Line.From = Vector2.new(c.X, c.Y)
                                                                Line.To = Vector2.new(d.X, d.Y)
                                                                
                                                                if FeatureTable.Visuals.UseTeamColor then
                                                                    if tostring(TeamColor) == "Bright blue" then
                                                                        Line.Color = Color3.fromRGB(0, 162, 255)
                                                                    elseif tostring(TeamColor) == "Bright orange" then
                                                                        Line.Color = Color3.fromRGB(255, 162, 0)
                                                                    end
                                                                else
                                                                    Line.Color = FeatureTable.Visuals.Box3D.Color
                                                                end
                                                            end
                                                        end
                                                    end
                                                else
                                                    Functions.ESP:ClearTable(Objects, Storage.ESP.Box3D, i)
                                                end
                                            else
                                                Functions.ESP:ClearTable(Objects, Storage.ESP.Box3D, i)
                                            end
                                        else
                                            Functions.ESP:ClearTable(Objects, Storage.ESP.Box3D, i)
                                        end
                                    end
                                end
                            end
                        end
                        do --// Tracer ESP

                            for i,Player in Storage.ESP.Tracers do --// Tracer logic (obviously once again)
                                if typeof(Player) == "Instance" then
    
                                    local Tracer = Storage.ESP.Tracers[i-1]
                    
                                    if FeatureTable.Visuals.Tracers.Enabled and Player:IsDescendantOf(workspace) then
                                        local Bodyparts = Functions.Normal:GetPlayerBodyparts(Player)
                                        local Target = Bodyparts[FeatureTable.Visuals.Tracers.End]
                                        if Target ~= nil and not tostring(Player:GetFullName()):find(tostring(DeadBodies)) then
                                            local Position, OnScreen = Camera:WorldToViewportPoint(Target.Position) --// Convert to screen pos since we're rendering the boxes on the screen (duh)
    
                                            local Team = Functions.Normal:GetTeam(Player)
                                            local TeamColor = Team.TeamColor
                    
                                            if OnScreen and FeatureTable.Visuals.TeamCheck and tostring(Team) ~= game.Players.LocalPlayer.Team.Name or not FeatureTable.Visuals.TeamCheck then
                                                
                                                local Origin = FeatureTable.Visuals.Tracers.Origin
                                                local Value
                                                if Origin ~= "Gun" then

                                                    if Origin == "Top" then
                                                        Value = 0 
                                                    elseif Origin == "Middle" then
                                                        Value = Storage.Other.ViewportSize.Y / 2
                                                    elseif Origin == "Bottom" then
                                                        Value = Storage.Other.ViewportSize.Y
                                                    end

                                                    Tracer.From = Vector2.new(Storage.Other.ViewportSize.X / 2, Value)
                                                    Tracer.To = Vector2.new(Position.X, Position.Y)

                                                else

                                                    local Gun = Functions.Normal:GetGun()
                                                    if Gun ~= nil and Gun:FindFirstChild("Flame") then
                                                        local TipPosition = Camera:WorldToViewportPoint(Gun["Flame"].Position) or Camera:WorldToViewportPoint(Gun["FlameSUP"].Position)
                                                        Tracer.From = Vector2.new(TipPosition.X, TipPosition.Y)
                                                        Tracer.To = Vector2.new(Position.X, Position.Y)
                                                    else
                                                        Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                                                    end

                                                end

                                                if FeatureTable.Visuals.UseTeamColor then
                                                    if tostring(TeamColor) == "Bright blue" then
                                                        Tracer.Color = Color3.fromRGB(0, 162, 255)
                                                    elseif tostring(TeamColor) == "Bright orange" then
                                                        Tracer.Color = Color3.fromRGB(255, 162, 0)
                                                    end
                                                else
                                                    Tracer.Color = FeatureTable.Visuals.Tracers.Color
                                                end
                    
                                            else
                    
                                                Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                    
                                            end
                    
                                        else
                    
                                            Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                    
                                        end
                                    else
                    
                                        Functions.ESP:ClearTable({Tracer}, Storage.ESP.Tracers, i)
                    
                                    end
                                end
                            end
                            
                        end

                        do --// Cham ESP

                            for i, Player in Functions.Normal:GetPlayers() do
                                if Player ~= nil then
                                    
                                    local Highlight = Player:FindFirstChildOfClass("Highlight")
                                    local Team = Functions.Normal:GetTeam(Player)
                                    local TeamColor = Team.TeamColor
                            
                                    if not tostring(Player:GetFullName()):find(tostring(DeadBodies)) and FeatureTable.Visuals.Chams.Enabled and (FeatureTable.Visuals.TeamCheck and tostring(Team) ~= game.Players.LocalPlayer.Team.Name or not FeatureTable.Visuals.TeamCheck) then
                                        
                                        if not Highlight then
                                            Highlight = Instance.new("Highlight", Player)
                                        end
                            
                                        Highlight.Enabled = true
                                        Highlight.Adornee = Player
                                        Highlight.FillColor = FeatureTable.Visuals.Chams.FillColor
                                        Highlight.OutlineColor = FeatureTable.Visuals.Chams.OutlineColor
                                        Highlight.FillTransparency = FeatureTable.Visuals.Chams.FillTransparency
                                        Highlight.OutlineTransparency = FeatureTable.Visuals.Chams.OutlineTransparency
                                        Highlight.DepthMode = FeatureTable.Visuals.Chams.VisibleOnly and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop

                                        if FeatureTable.Visuals.UseTeamColor then --// 😭
                                            if tostring(TeamColor) == "Bright blue" then
                                                Highlight.FillColor = Color3.fromRGB(0, 162, 255)
                                                Highlight.OutlineColor = Color3.fromRGB(0, 162, 255)
                                            elseif tostring(TeamColor) == "Bright orange" then
                                                Highlight.FillColor = Color3.fromRGB(255, 162, 0)
                                                Highlight.OutlineColor = Color3.fromRGB(255, 162, 0)
                                            end
                                        else
                                            Highlight.FillColor = FeatureTable.Visuals.Chams.FillColor
                                            Highlight.OutlineColor = FeatureTable.Visuals.Chams.OutlineColor
                                        end
                  
                                    else

                                        if Highlight then
                                            Highlight:Destroy()
                                        end

                                    end
									
                                end
                            end
                            
                        end
    
                    end

                    do --// Misc

                        do --// Player

                            local LocalPlayer = Ignore:FindFirstChild("RefPlayer")
                            if LocalPlayer then
                                local Humanoid = LocalPlayer:FindFirstChildOfClass("Humanoid")

                                do --// Player Modifications

                                    if Humanoid then
    
                                        if FeatureTable.Misc.Player.JumpPowerModifier.Enabled then
                                            Humanoid.JumpPower = FeatureTable.Misc.Player.JumpPowerModifier.Power
                                        end
                                        if FeatureTable.Misc.Player.Fly.Enabled then

                                            local Direction = Vector3New()

                                            if LocalPlayer then

                                                local LookVector = Camera.CFrame.LookVector * Vector3New(1, 0, 1)
                                                local Directions = { --// Very optimized real!
                                                    [Enum.KeyCode.W] = LookVector,
                                                    [Enum.KeyCode.S] = -LookVector,
                                                    [Enum.KeyCode.D] = Vector3New(-LookVector.Z, 0, LookVector.X),
                                                    [Enum.KeyCode.A] = Vector3New(LookVector.Z, 0, -LookVector.X),
                                                    [Enum.KeyCode.Space] = Vector3New(0, 5 * 5, 0),
                                                    [Enum.KeyCode.LeftControl] = Vector3New(0, -5 * 5, 0)
                                                }
                                                
                                                for Key, Dir in Directions do
                                                    if UserInputService:IsKeyDown(Key) then
                                                        Direction = Direction + Dir
                                                    end
                                                end
                                                
                                                if Direction.Magnitude > 0 then
                                                    Direction = Direction.Unit
                                                    LocalPlayer.HumanoidRootPart.Velocity = Direction * FeatureTable.Misc.Player.Fly.Speed
                                                    LocalPlayer.HumanoidRootPart.Anchored = false
                                                else
                                                    LocalPlayer.HumanoidRootPart.Velocity = Vector3New()
                                                    LocalPlayer.HumanoidRootPart.Anchored = true
                                                end

                                            end

                                        end
                                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and FeatureTable.Misc.Player.Bhop then
                                            Humanoid.Jump = true
                                        end
                                        Humanoid.HipHeight = FeatureTable.Misc.Player.HipHeight
                                    
                                    end
                                    
                                end

                            end
                            
                        end
                        
                    end

                    do --// Extra

                        Storage.Other.ClosestPlayer = Functions.Normal:getClosestPlayer()
                        
                        do --// FOV Circle

                            local Dynamic = FeatureTable.Combat.SilentAim.DummyRange / math.tan(math.rad(Camera.FieldOfView / 2))
                            FOVCircle.Position = Vector2.new(Storage.Other.ViewportSize.X/2, Storage.Other.ViewportSize.Y/2)

                            if FeatureTable.Combat.SilentAim.DynamicFOV then
                                FOVCircle.Radius = Dynamic
                            else
                                FOVCircle.Radius = FeatureTable.Combat.SilentAim.DummyRange
                            end
                            
                        end

                    end
    
                end
            end)
    
        end
    
        do --// Connections
            
            Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                Storage.Other.ViewportSize = Camera.ViewportSize
            end)

            do --// Lighting (I love this part)

                Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
                    Functions.Normal:SetAmbient("Ambient", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)

                Lighting:GetPropertyChangedSignal("OutdoorAmbient"):Connect(function()
                    Functions.Normal:SetAmbient("OutdoorAmbient", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)

                Lighting:GetPropertyChangedSignal("ColorShift_Top"):Connect(function()
                    Functions.Normal:SetAmbient("ColorShift_Top", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)

                Lighting:GetPropertyChangedSignal("ColorShift_Bottom"):Connect(function()
                    Functions.Normal:SetAmbient("ColorShift_Bottom", FeatureTable.Visuals.Lighting.OverrideAmbient.Color)
                end)
                
            end

            Misc.ChildAdded:Connect(function(Child)
                if tostring(Child.Name):find("Trigger") then 
                    if FeatureTable.Visuals.Grenade.GrenadeESP.Enabled then
                        local Billboard = Instance.new("BillboardGui", Child)
                        local Frame = Instance.new("Frame", Billboard)
                        local UICorner = Instance.new("UICorner", Frame)
                        
                        do --// Properties
                            do --// BillboardGui
                                Billboard.Enabled = true
                                Billboard.AlwaysOnTop = true
                                Billboard.Size = UDim2.new(1, 0, 1, 0)
                                Billboard.Adornee = Child
                            end
                            do --// Frame
                                Frame.Size = UDim2.new(1, 0, 1, 0)
                                Frame.BackgroundTransparency = FeatureTable.Visuals.Grenade.GrenadeESP.Transparency
                                Frame.BackgroundColor3 = FeatureTable.Visuals.Grenade.GrenadeESP.Color
                            end
                            do --// UICorner
                                UICorner.CornerRadius = UDim.new(0, 50)
                            end
                        end
                    end
                    if FeatureTable.Visuals.Grenade.TrailModifier.Enabled then
                        local Trail = Child:WaitForChild("Trail")
                        Trail.Lifetime = FeatureTable.Visuals.Grenade.TrailModifier.TrailLifetime
                        Trail.Color = ColorSequence.new(FeatureTable.Visuals.Grenade.TrailModifier.Color)
                    end
                end
            end)
            
            
        end
    


    end
    
end

Library:OnUnload(function()
    Library.Unloaded = true
end)

local MenuGroup = Tabs['Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('pflol')
SaveManager:SetFolder('pflol/PhantomForces')

SaveManager:BuildConfigSection(Tabs['Settings'])
ThemeManager:ApplyToTab(Tabs['Settings'])
SaveManager:LoadAutoloadConfig()

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('pf.lol | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);
