local RunService = game:GetService("RunService")

if RunService:IsClient() then
    error("Don't require the CSCServer using client instead require the parent of this script to make it easier.")
    return nil
end

local Server = {}

local MainEvent:RemoteEvent
local RemoteFunction:RemoteFunction

local ServerCalled:BindableEvent
local ServerInvoked:BindableEvent

function Server:Init()
    RemoteFunction = Instance.new("RemoteEvent")
    RemoteFunction.Name = "MainFunction"
    RemoteFunction.Parent = script.Parent
    MainEvent = Instance.new("RemoteEvent")
    MainEvent.Name = "MainRemote"
    MainEvent.Parent = script.Parent

    ServerCalled = Instance.new("BindableEvent")
    ServerCalled.Name = "ServerCalled"
    ServerCalled.Parent = script
    ServerInvoked = Instance.new("BindableEvent")
    ServerInvoked.Name = "ServerInvoked"
    ServerInvoked.Parent = script

    self.ServerInvoked = ServerInvoked.Event
    self.ServerCalled = ServerCalled.Event
end

function Server:CallClient(Player:Player, EventName:string, ...)
    MainEvent:FireClient(Player, EventName, ...)
end

function Server:CallAllClients(EventName:string, ...)
    MainEvent:FireAllClients(EventName, ...)
end

coroutine.resume(coroutine.create(function()
    local Wait = script.Parent:WaitForChild("MainRemote")
    if Wait then
        MainEvent.OnServerEvent:Connect(function(Player, EventName, ...)
            ServerCalled:Fire(Player, EventName, ...)
        end)
        RemoteFunction.OnServerInvoke = function(Player, EventName, ...)
            ServerInvoked:Fire(Player, EventName, ...)
        end
    end
end))

return Server