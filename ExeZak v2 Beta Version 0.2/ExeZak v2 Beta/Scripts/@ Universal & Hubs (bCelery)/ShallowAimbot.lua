--[[
	My first ever nerd-ass script.
	A really simple Universal "ESP"(Overhead Marker) and Aimbot, works surprisingly well!
	Hold MouseButton2 (Right Mouse Click) to activate Aimbot.
--]]



-- Settings
ESPpoint = "Head"
PixelFOV = 130
ScreenWidth = 2560
ScreenHeight = 1440

Target = "first"
Rage = false -- sets pixel to max, then turns off onScreen detection. also uses some raycasting to avoid walls!
-- ========



-- Services
local UIS = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players")
local Myself = game:GetService("Players").LocalPlayer
local Camera = game.Workspace.CurrentCamera
-- ========



-- Draw FOV
if Rage then
	PixelFOV = 10000
end
local fov = Drawing.new("Square");
fov.Size = Vector2.new(
	PixelFOV*2,
	PixelFOV*2
)
fov.Color = Color3.fromRGB(
	255,
	255,
	255
)
fov.Filled = false;
fov.Thickness = 3;
fov.Visible = true;
fov.Position = Vector2.new(
	(ScreenWidth/2)-PixelFOV,
	(ScreenHeight/2)-PixelFOV
)
-- ========



-- UserInput handling
UIS.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton2) then
		rightClick = true
	end
end)
UIS.InputEnded:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton2) then
		rightClick = false
	end
end)
-- ========



-- Module functions
openDrawings = {}
playersInFOV = {}
function reloadPlayers()
	for i, keyName in pairs(openDrawings) do
		(openDrawings[i]):Remove();
	end
	openDrawings = {}
	for i, Player in pairs(Players:GetPlayers()) do
		if Player ~= Myself and Player.Team ~= Myself.Team and Player.Character.Humanoid.Health > 0 and Player.Character:WaitForChild(ESPpoint, true) then
			openDrawings[Player.Name] = Drawing.new("Square");
			openDrawings[Player.Name].Thickness = 6;
			openDrawings[Player.Name].Color = Color3.fromRGB(6, 0, 181);
			openDrawings[Player.Name].Filled = true;
			openDrawings[Player.Name].Size = Vector2.new(0,0);
			openDrawings[Player.Name].Visible = false;
			openDrawings[Player.Name].Position = Vector2.new(0, 0);
		end
	end
end
function checkIfInFOV(onScreen,Player,screenPos)
	if rightClick then
		local xDiff = math.abs(ScreenWidth/2 - screenPos.x)
		local yDiff = math.abs(ScreenHeight/2 - screenPos.y)
		if xDiff < PixelFOV and yDiff < PixelFOV and onScreen then
			if Player ~= nil then
				table.insert(playersInFOV,1,Player)
                print(Player)
			end
		end
	end
end
function checkRaycast(targetPlayer)
    local targetPosition = targetPlayer.Character.PrimaryPart.Position
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = (targetPosition - rayOrigin).unit * 1000
    local raycastParams = RaycastParams.new()

    raycastParams.FilterDescendantsInstances = {Players.LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = game.Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        local hitPlayer = Players:GetPlayerFromCharacter(result.Instance.Parent)
        return hitPlayer
    end
    return nil
end
-- ========

print(game.PlaceId)

-- Render each frame
RunService.RenderStepped:Connect(function()
	
	-- arsenal only
	if game.PlaceId == 286090429 then
		game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 30
		game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 120
	end

	reloadPlayers()
	playersInFOV = {}
	for i, Player in pairs(Players:GetPlayers()) do
		if (
			Player ~= Myself 
			and Player.Team ~= Myself.Team
			and Player.Character.Humanoid.Health > 0
			and Player.Character:WaitForChild(ESPpoint, true)
		) then
			local screenPos,onScreen = Camera:WorldToScreenPoint(
				Player.Character[ESPpoint].Position
			)
			openDrawings[Player.Name].Position = Vector2.new(
				screenPos.x,
				screenPos.y
			)
			if Rage then
				onScreen = true
			end
			if onScreen then
				openDrawings[Player.Name].Visible = true
				checkIfInFOV(onScreen,Player,screenPos)
			else
				openDrawings[Player.Name].Visible = false
			end
		end
	end
	if rightClick then
        if playersInFOV[1] ~= nil then
		    Camera.CFrame = CFrame.new(
			    Camera.CFrame.Position,
			    playersInFOV[1].Character[ESPpoint].Position
		    )
        end
	end
end)