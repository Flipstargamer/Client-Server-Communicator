# Client and Server Communicator
A ROBLOX module that allows server and client to communicate a bit easier.

## Installation
Download module and put it in Replicated Storage.

## Getting the Client/Server Module
CSC is build that you can require the main module which will return the client or server depending on what script was used to require it.
Example:
```lua
local CSC = require(workspace:WaitForChild(CSC))
```

## Client

### .ClientCalled
When the client is called this event fires.
```lua
CSC.ClientCalled:Connect(function(EventName : String, Arguments : Tuple)
	if EventName == "NameHere" then -- Checks Event
		-- Code Here
	end
end)
```

### :CallServer()
Calls server.
```lua
CSC:CallServer(EventName : String, Arguments : Tuple)
```

## Server
The server module needs to be init first.

### :Init()
The most important thing of the server module. Both modules cant run without running this method.
```lua
CSC:Init()
```

### .ServerCalled
When Server Called.
```lua
CSC.ServerCalled:Connect(function(Player : Player, EventName : String, Arguments : Tuple)
	if EventName == "NameHere" then -- Checks Event
		-- Code Here
	end
end)
```

### :CallClient()
Calls Client.
```lua
CSC:CallClient(Player : Player, EventName : String, Arguments : Tuple)
```

### :CallAllClients()
Calls all the clients.
```lua
CSC:CallAllClients(EventName : String, Arguments : Tuple)
```