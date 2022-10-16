---
sidebar_position: 2
---
# Getting Started
**Want to get started using this?**

Well this guide is for you.

## Installation
### Roblox Studio
To install CSC in Roblox Studio just get the file put it in replicated storage.
#### Require/Init
To require use this simple script:
```lua
-- Server-Sided
local CSC = require(game:GetService("ReplicatedStorage").CSC) -- If you changed the name of CSC change CSC to the new name.
CSC:Init() -- This is IMPORTANT don't forget it.
```
### Wally
Add this to your dependencies list:
```
CSC = "flipstargamer/clsecom@1.1.1"
```

## Learing the Module
Lets setup the communication part, but what are we going to do? Well let's make a simple thing that when the player presses `B` then we call the server to print something.

**TODO**
