local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if RunService:IsClient() then
    error("Don't require the CSCServer using client instead require the parent of this script to make it easier.")
    return nil
end

--[=[
    @class CSCServer
    @server

    The Server Side of CSC
]=]
local Server = {}

local MainEvent:RemoteEvent
local RemoteFunction:RemoteFunction

local ServerCalled:BindableEvent

--[=[
    @within CSCServer

    Inits the CDC.

    ```lua
    CDC:Init()
    ```
]=]
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

    --[=[
        @prop ServerCalled RBXScriptSignal
        @within CSCServer
        A signal that fires when server is called.
        ```lua
        CSC.ServerCalled:Connect(Player, EventName, ArgumentOne, ArgumentTwo)
        ```
    ]=]
    self.ServerCalled = ServerCalled.Event
end

--[=[
    @within CSCServer

    Calls a client that is given.

    ```lua
    CSC:CallClient(APlayerVar, "Hey This is a test name.", AArgumentVar, ASecondArgumentVar)
    ```

    @param ... Tuple
]=]
function Server:CallClient(Player:Player, EventName:string, ...)
    MainEvent:FireClient(Player, EventName, ...)
end

--[=[
    @within CSCServer

    Calls all clients that are available.

    ```lua
    CSC:CallAllClients("Hey This is a test name.", AArgumentVar, ASecondArgumentVar)
    ```

    @param ... Tuple
]=]
function Server:CallAllClients(EventName:string, ...)
    MainEvent:FireAllClients(EventName, ...)
end

--[=[
    @within CSCServer
    @unreleased

    :::caution Testing
    This method is being tested.
    Please report any bugs to us using Github Issues.
    :::

    Calls clients in a table.

    ```lua
    local TableOfPlayers = {
        APlayerVar,
        SecondPlayerVar
    }
    CSC:CallClientsInTable(TableOfPlayers, "Hey This is a test name.", AArgumentVar, ASecondArgumentVar) -- You can add as much arguments as you want.
    ```

    @param ... Tuple
]=]
function Server:CallClientsInTable(Players:table, EventName:string, ...)
    for _, Player in ipairs(Players) do
        MainEvent:FireClient(Player)
    end
end

coroutine.resume(coroutine.create(function()
    local Wait = script.Parent:WaitForChild("MainRemote")
    if Wait then
        MainEvent.OnServerEvent:Connect(function(Player, EventName, ...)
            ServerCalled:Fire(Player, EventName, ...)
        end)
    end
end))

return Server