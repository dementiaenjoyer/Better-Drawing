# Better-Drawing
i do not like the roblox drawing library exploits have to offer, especially when making esps and such. so i threw this together. you can of course just do this yourself, but this is mostly just for personal use so i do not need to re-do this all of the time. this automatically deletes elements so you do not have to clear them yourself!

# Example
```lua
local function Update()
	local Object = Drawing.new("Text");
	Object.Visible = true;
	Object.Text = "Cursor";
	Object.Center = true;
	Object.Color = Color3.new(1, 1, 1);
	
	local Position = game:GetService("UserInputService"):GetMouseLocation();
	Object.Position = Vector2.new(Position.X, Position.Y);
end

BetterDrawing:Init(Update);
```
