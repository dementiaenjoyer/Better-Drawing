local RunService = game:GetService("RunService");

local DrawingObjects = { };

local Drawing = getgenv().Drawing;
local HookFunction = getgenv().hookfunction;

local Flag = "BETTER_DRAWING";

if not (HookFunction or Drawing) then
    return;
end

local cleardrawcache = getgenv().cleardrawcache or (function()
    local DrawingNew = nil; DrawingNew = hookfunction(Drawing.new, function(Type, PotentialFlag)
        local Object = DrawingNew(Type);

        if (PotentialFlag == Flag) then
            DrawingObjects[#DrawingObjects + 1] = Object;
        end

        return Object;
    end)

    return function()
        for _, Object in DrawingObjects do
            Object:Destroy();
        end

        table.clear(DrawingObjects);
    end
end)();

local BetterDrawing = { FLAG = Flag };

function BetterDrawing:Init(Connection)
    local PreRender = RunService.PreRender;

    PreRender:Connect(function()
        Connection();
        PreRender:Wait();
        
        cleardrawcache();
    end)
end

return BetterDrawing;
