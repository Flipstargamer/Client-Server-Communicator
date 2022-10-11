local RunService = game:GetService("RunService")

if RunService:IsServer() then
    return require(script.CSCServer)
else
    return require(script.CSCClient)
end