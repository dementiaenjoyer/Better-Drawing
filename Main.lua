local RunService = game:GetService("RunService");

local DrawingObjects = { };

local Drawing = getgenv().Drawing;
local HookFunction = getgenv().hookfunction;

if not (HookFunction or Drawing) then
    return;
end

local function ClearObjects()
    for _, Object in DrawingObjects do
        Object:Destroy();
    end

    table.clear(DrawingObjects);
end

local OldDrawing = nil; OldDrawing = hookfunction(Drawing.new, function(...)
    local Object = OldDrawing(...);
    DrawingObjects[#DrawingObjects + 1] = Object;

    return Object;
end)

local BetterDrawing = { }; do
    BetterDrawing.Update = tick();

    function BetterDrawing:Init(Connection)
        local PreRender = RunService.PreRender;

        PreRender:Connect(function()
            Connection();
            PreRender:Wait();
            ClearObjects();
        end)
    end
end

return BetterDrawing;
