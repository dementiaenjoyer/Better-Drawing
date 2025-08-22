getgenv().cleardrawcache = nil; -- This isn't required, but leaving it out will cause it to use the default 'cleardrawcache' function, and that'll also clear all other Drawing objects aswell, not only the ones you use for this scenario.

local UserInputService = game:GetService("UserInputService");
local BetterDrawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/Better-Drawing/refs/heads/main/Main.lua"))();

local function Update()
    local Size = Vector2.new(100, 100);
    local Position = UserInputService:GetMouseLocation() - (Size / 2);

    local SquareObject = Drawing.new("Square", BetterDrawing.FLAG); -- Make sure to pass the drawing flag so that it knows which elements to refresh / update
    SquareObject.Visible = true;
    SquareObject.Filled = true;
    SquareObject.Position = Position;
    SquareObject.Size = Size;
    SquareObject.Color = Color3.new(1, 1, 1);
end

BetterDrawing:Init(Update);
