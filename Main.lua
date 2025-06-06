local RunService = game:GetService("RunService");

local DrawingObjects = { };

local Drawing = getgenv().Drawing;
local HookFunction = getgenv().hookfunction;

if not (HookFunction or Drawing) then
    return;
end

local function ClearObjects()
    for Index = 1, #DrawingObjects do
        DrawingObjects[Index]:Destroy();
    end
end

local OldDrawing = nil; OldDrawing = hookfunction(Drawing.new, function(...)
    local Object = OldDrawing(...);
    table.insert(DrawingObjects, Object);

    return Object;
end)

local BetterDrawing = { }; do
    function BetterDrawing:Init(Connection)
        local PreRender = RunService.PreRender;

        PreRender:Connect(Connection);
        PreRender:Connect(ClearObjects);
    end
end

return BetterDrawing;
