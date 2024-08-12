-- Changes the attributes of every gun in Arsenal.
-- Made by @shall0e on discord, bCelery 2024.
local RS = game:GetService("ReplicatedStorage")
print("START")
function changeThis(g,n,v)
    if g:FindFirstChild(n) ~= nil and g:FindFirstChild(n):IsA("ValueBase") then
        g[n].Value = v
    else
        warn(g.Name..' does not have a value for "'..n..'"')
    end
end
for i,g in pairs(RS.Weapons:GetChildren()) do
    if g ~= nil then
        changeThis(g,"FireRate",0.011)
        changeThis(g,"Auto",true)
        changeThis(g,"RecoilControl",0)
        changeThis(g,"Ammo",999)
        changeThis(g,"Speed%",-1000)
        -- Add more functions to change more shit.
    end
end