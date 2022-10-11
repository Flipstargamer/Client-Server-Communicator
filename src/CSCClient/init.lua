local RunService = game:GetService("RunService")

if RunService:IsServer() then
    error("Don't require the CSCClient using server instead require the parent of this script to make it easier.")
    return nil
end

local Client = {}

local MainEvent:RemoteEvent = script.Parent:WaitForChild("MainRemote")
local RemoteFunction:RemoteFunction = script.Parent:WaitForChild("MainFunction")

local ClientCalled:BindableEvent = script:FindFirstChild("ClientCalled")
if not ClientCalled then
    ClientCalled = Instance.new("BindableEvent")
    ClientCalled.Name = "ClientCalled"
    ClientCalled.Parent = script
end
local ClientInvoked:BindableEvent = script:FindFirstChild("ClientInvoked")
if not ClientInvoked then
    ClientInvoked = Instance.new("BindableEvent")
    ClientInvoked.Name = "ClientInvoked"
    ClientInvoked.Parent = script
end


Client.ClientCalled = ClientCalled.Event
Client.ClientInvoked = ClientInvoked.Event

function Client:CallServer(EventName:string, ...)
    MainEvent:FireServer(EventName, ...)
end

MainEvent.OnClientEvent:Connect(function(EventName, ...)
    ClientCalled:Fire(EventName, ...)
end)

RemoteFunction.OnClientInvoke = function(EventName, ...)
    ClientInvoked:Fire(EventName, ...)
end

return Client