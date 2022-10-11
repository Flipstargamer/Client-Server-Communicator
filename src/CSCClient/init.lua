local RunService = game:GetService("RunService")

if RunService:IsServer() then
    error("Don't require the CSCClient using server instead require the parent of this script to make it easier.")
    return nil
end

local Client = {}

local MainEvent:RemoteEvent = script.Parent:WaitForChild("MainRemote")
local ClientCalled:BindableEvent = script:FindFirstChild("ClientCalled")
if not ClientCalled then
    ClientCalled = Instance.new("BindableEvent")
    ClientCalled.Name = "ClientCalled"
    ClientCalled.Parent = script
end


Client.ClientCalled = ClientCalled.Event

function Client:CallServer(EventName:string, ...)
    MainEvent:FireServer(EventName, ...)
end

MainEvent.OnClientEvent:Connect(function(EventName, ...)
    ClientCalled:Fire(EventName, ...)
end)

return Client