local RunService = game:GetService("RunService");

local DrawingObjects = { };

local Drawing = getgenv().Drawing;
local HookFunction = getgenv().hookfunction;

local cleardrawcache = getgenv().cleardrawcache or (function()
    local DrawingNew = nil; DrawingNew = hookfunction(Drawing.new, function(...)
        local Object = DrawingNew(...);
        DrawingObjects[#DrawingObjects + 1] = Object;

        return Object;
    end)

    return function()
        for _, Object in DrawingObjects do
            Object:Destroy();
        end

        table.clear(DrawingObjects);
    end
end)();

if not (HookFunction or Drawing) then
    return;
end

local BetterDrawing = { }; do
    BetterDrawing.Update = tick();

    function BetterDrawing:Init(Connection)
        local PreRender = RunService.PreRender;

        PreRender:Connect(function()
            Connection();
            PreRender:Wait();
            cleardrawcache();
        end)
    end
end

return BetterDrawing;
