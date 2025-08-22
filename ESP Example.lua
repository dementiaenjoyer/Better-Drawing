getgenv().cleardrawcache = nil; -- This isn't required, but leaving it out will cause it to use the default 'cleardrawcache' function, and that'll also clear all other Drawing objects aswell, not only the ones you use for esp.

local BetterDrawing = loadstring(game:HttpGet("https://raw.githubusercontent.com/dementiaenjoyer/Better-Drawing/refs/heads/main/Main.lua"))();
local DrawingFlag = BetterDrawing.FLAG;

local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");

local Camera = Workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;

local Round = math.round;

local function Update()
    for _, Player in Players:GetChildren() do
        local Character = Player.Character;
        local Root = Character and Character:FindFirstChild("HumanoidRootPart");

        if (not Root) or (Player == LocalPlayer) then
            continue;
        end

        local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 0.5, 0));
        local Distance = ScreenPosition.Z;

        if (not OnScreen) then
            continue;
        end

        local Scale = (2 * Camera.ViewportSize.Y) / ((2 * Distance * math.tan(math.rad(Camera.FieldOfView) / 2)) * 1.5); -- Found this somewhere cant remember where

        local Width, Height = Round(3 * Scale), Round(4 * Scale);
        local Size = Vector2.new(Width, Height);

        local Position = Vector2.new(Round(ScreenPosition.X - (Width / 2)), Round(ScreenPosition.Y - (Height / 2)));

        local Outline = Drawing.new("Square", DrawingFlag);
        Outline.Visible = true;

        local Box = Drawing.new("Square", DrawingFlag);
        Box.Visible = true;
        
        -- Box
        do
            Box.Color = Color3.new(1, 1, 1);
            Box.Thickness = 1;

            Box.Size = Size;
            Box.Position = Position;
        end

        -- Outline
        do
            Outline.Color = Color3.new(0, 0, 0);
            Outline.Thickness = 3;

            Outline.Position = Box.Position;
            Outline.Size = Box.Size;
        end
    end
end

BetterDrawing:Init(Update);
