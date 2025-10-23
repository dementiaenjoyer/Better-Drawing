local RunService = game:GetService("RunService");

local Flag = "BETTER_DRAWING";

local DrawingObjects = { };
local BetterDrawing = { FLAG = Flag };

local Drawing = getgenv().Drawing;
local HookFunction = getgenv().hookfunction;

if not (HookFunction or Drawing) then
    return;
end

local cleardrawcache = getgenv().cleardrawcache or (function()
    local DrawingNew = nil; DrawingNew = hookfunction(Drawing.new, function(Type, PotentialFlag)
        local Object = DrawingNew(Type);

        if (PotentialFlag == Flag) then
            table.insert(DrawingObjects, Object);
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

-- Methods
do
    local Tween = { }; do
        local LinearInterpolation = { }; do
            function LinearInterpolation:Any(Start, Destination, Time)
                return Start + (Destination - Start) * Time;
            end

            function LinearInterpolation:Vector2(Start, Destination, Time)
                return Vector2.new(self:Any(Start.X, Destination.X, Time), self:Any(Start.Y, Destination.Y, Time));
            end
        end

        function Tween:Cubic(T)
            if (T < 0.5) then
                return 4 * T * T * T;
            else
                local F = (2 * T) - 2;
                return 0.5 * F * F * F + 1;
            end
        end

        Tween.LinearInterpolation = LinearInterpolation;
    end

    function BetterDrawing:Init(Connection)
        local PreRender = RunService.PreRender;

        return PreRender:Connect(function(DeltaTime)
            Connection(DeltaTime);
            PreRender:Wait();

            cleardrawcache();
        end)
    end

    function Tween:SetValue(DrawingObject, Property, Destination, Time)
        local Start = DrawingObject[Property];

        if (not Start) then
            return;
        end
        
        local StartTime = tick();
        local Class = typeof(Destination);
        
        local Connection, LinearInterpolation = nil, self.LinearInterpolation; Connection = RunService.PreSimulation:Connect(function()
            local Progress = (tick() - StartTime) / Time;
            DrawingObject[Property] = (LinearInterpolation[Class] or LinearInterpolation.Any)(LinearInterpolation, Start, Destination, self:Cubic(Progress));

            if (Progress >= 1) then
                Connection:Disconnect();
                DrawingObject[Property] = Destination;
            end
        end)
    end

    BetterDrawing.Tween = Tween;
end

return BetterDrawing;
