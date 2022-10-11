local RunService = game:GetService("RunService")

if RunService:IsClient() then
    error("Don't require the CSCServer using client instead require the parent of this script to make it easier.")
    return nil
end

local Server = {}

local MainEvent:RemoteEvent
local ServerCalled:BindableEvent

function Server:Init()
    MainEvent = Instance.new("RemoteEvent")
    MainEvent.Name = "MainRemote"
    MainEvent.Parent = script.Parent
    ServerCalled = Instance.new("BindableEvent")
    ServerCalled.Name = "ServerCalled"
    ServerCalled.Parent = script

    self.ServerCalled = ServerCalled.Event
end

function Server:CallClient(Player:Player, EventName:string, ...)
    MainEvent:FireClient(Player, EventName, ...)
end

return Server