local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if RunService:IsClient() then
    error("Don't require the CSCServer using client instead require the parent of this script to make it easier.")
    return nil
end

--[=[
    @within CSCServer
    @type Seconds number
]=]
type Seconds = number

--[=[
    @class CSCServer
    @server

    The Server Side of CSC
]=]
local Server = {}

local Functions = {}

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
    @since v1.1.0
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

--[=[
    @within CSCServer
    @yields
    @unreleased
    Calls specified client after a certain amount of time.

    @param ... Tuple
]=]
function Server:DelayCallClient(Delay:Seconds, Player:Player, EventName:string, ...)
    task.wait(Delay)
    self:CallClient(Player, EventName, ...)
end

--[=[
    @within CSCServer
    @unreleased
    Adds a callback to be executed when server is invoked.

    ```lua
    local Callback = function(Player, EventName, ArgumentOne, ArgumentTwo)
        -- Code
    end
    CSC:AddCallback(Callback)
    ```
]=]
function Server:AddCallback(Callback: (Player:Player, EventName:string, ...any) -> any)
    table.insert(Functions, Callback)
end

--[=[
    @within CSCServer
    @unreleased
    @yields
    Invokes the client and executes all callbacks added to it.

    ```lua
    CSC:InvokeServer(Player, "This is a Event Name", ArgumentOne, ArgumentTwo)
    ```
    @param ... Tuple
    @return any
]=]
function Server:InvokeClient(Player:Player, EventName:string, ...)
    RemoteFunction:InvokeClient(Player, EventName, ...)
end

coroutine.resume(coroutine.create(function()
    local Wait = script.Parent:WaitForChild("MainRemote")
    if Wait then
        MainEvent.OnServerEvent:Connect(function(Player, EventName, ...)
            ServerCalled:Fire(Player, EventName, ...)
        end)
        RemoteFunction.OnServerInvoke = function(Player:Player, EventName:string, ...)
            for _, Callback in ipairs(Functions) do
                Callback(Player, EventName, ...)
            end
        end
    end
end))

return Server