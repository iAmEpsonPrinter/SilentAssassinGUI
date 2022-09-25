local lib =  loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt")()

local window = lib:Window("Diskurd")

local server1 = window:Server("Silent Assassin", "")

local channel1 = server1:Channel("Combat")
local channel2 = server1:Channel("Target")
local channel3 = server1:Channel("Assassin")
local channel4 = server1:Channel("Infection/FFA")
local channel5 = server1:Channel("Misc")

--important variables
_G.infAmmo = false
_G.hbeActive = true 
local roundtype = game:GetService("Workspace").roundtype.Value
local assassinValues = game:GetService("Workspace").assassin
local targetName = game:GetService("Workspace").target.showname.Value
local targetValues = game:GetService("Workspace").target

--functions 

function setHBE(value)
    for i, v in pairs(game.Players:GetPlayers()) do
        local hrp = v.Character:FindFirstChild("HumanoidRootPart")
        if v.role.Value == value and hrp then
            
            pcall(function()
                hrp.CanCollide = false 
                hrp.BrickColor = BrickColor.new("Really red")
                hrp.Transparency = 0.6
                hrp.Size = Vector3.new(9,9,9)
            end)
        end
    end 
end 

function getAssassin()
    local assassinName = game:GetService("Workspace").assassin.showname.Value
    local roundtype = game:GetService("Workspace").roundtype.Value
    if game:GetService("Workspace").assassin.puserid.Value ~= 0 or assassinName ~= nil and assassinName ~= game.Players.LocalPlayer.Name then
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.Name == assassinName and v.role.Value == "assassin" then
                return v 
            end 
        end 

    end

    return false
end 

function getTarget()
    local targetName = game:GetService("Workspace").target.showname.Value
    local roundtype = game:GetService("Workspace").roundtype.Value

    if game:GetService("Workspace").target.puserid.Value ~= 0 or targetName ~= nil and targetName ~= game.Players.LocalPlayer.Name and roundtype == "Standard" then
        for i, v in pairs(game.Players:GetPlayers()) do
            if v.Name == targetName and v.role.Value == "target" then
                return v
            end
        end
    end 

    return false 
end 

--COMBAT
channel1:Button("TP assassin", function()
    repeat
        getAssassin().Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-5)
        wait()
    until assassinValues.escaped.Value or assassinValues.dead.Value 
end)

channel1:Button("Infinite Ammo Capacity", function()
    _G.infAmmo = true 
end)



channel1:Toggle("Enemy Hitbox Extender",false, function(bool)
    while true do
        if bool then 
            if roundtype == "Infection" then
                if game.Players.LocalPlayer.role.Value == "assassin" then
                    setHBE("guard")
                else
                    setHBE("assassin")
                end
            elseif roundtype == "Standard" then
                if game.Players.LocalPlayer.role.Value == "assassin" then
                    setHBE("target")
                    setHBE("guard")
                else
                    setHBE("assassin")
                end
            
            
            
            end 
        
        elseif not bool then
            for i, v in pairs(game.Players:GetPlayers()) do
                local char = v.Character 
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if char and hrp then
                    hrp.CanCollide = true
                    hrp.BrickColor = BrickColor.new("Medium stone grey")
                    hrp.Transparency = 1
                    hrp.Size = Vector3.new(2,2,1)
                end
            end
            

        end
    wait(0.5)
  
    end


end)



--target 


channel2:Button("TP to all briefcases", function()
    local oldCFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame 
    if not game:GetService("Workspace").Map.BulletsGoThrough.Briefcases then
        return lib:Notification("Alert!", "No briefcases found", "Okay!")
    elseif game:GetService("Workspace").target.pname.Value ~= game.Players.LocalPlayer.Name then
        return lib:Notification("Alert!", "You are not the target", "Okay!")
    end
    for i,v in pairs(game:GetService("Workspace").Map.BulletsGoThrough.Briefcases:GetChildren()) do
        if v then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
            wait(0.1)
        else 
            return lib:Notification("Alert!", "No briefcases found", "Okay!")
        end
    end

    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
end)

--assassin 

channel3:Button("TP target", function()
    if game.Players.LocalPlayer.role.Value ~= "Assassin" then 
        return lib:Notification("Alert!", "You aren't the assassin", "aw ;(")
    end 


    if getTarget() then 
        repeat
            getTarget().Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.CFrame * CFrame.new(0,0,-1)
            wait()
        until targetValues.dead
    else 
        lib:Notification("Alert!", "No target found", "Wow fuck you!")
    end 
end)

--FFA

channel4:Button("Kill all (FFA GUNS)", function()
    for i, v in pairs(game.Players:GetPlayers()) do 
        pcall(function()
            repeat
                game:GetService("ReplicatedStorage").gunscripts.LocalHandler.bhit:FireServer(1, v.Character.Humanoid, v.Character.HumanoidRootPart.CFrame)
            until v.Character.Humanoid.Health <= 0
        end)
        
    end 
end)

--misc 

channel5:Button("X2 Assassin Chance", function()
    game:GetService("Players").LocalPlayer.x2assassinchance.Value = true
end)

channel5:Button("TP to lobby", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-47.1988678, 2112.57251, -206.233261)
end)


--metatables 

local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local namecall = gmt.__namecall

gmt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and tostring(self) == "bstorage" and _G.infAmmo then 
        args[2] = 999999
        return self.FireServer(self, unpack(args))
    end 
    
    return namecall(self, ...)
end)


