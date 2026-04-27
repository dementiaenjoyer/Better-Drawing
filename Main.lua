local RunService = game:GetService( "RunService" );

local Flag = "BETTER_DRAWING";

local BetterDrawing = { FLAG = Flag, FRAME = 0 };
local DrawingObjects = { };

local HookFunction = getgenv( ).hookfunction;
local Drawing = getgenv( ).Drawing;

if not ( HookFunction or Drawing ) then
    return;
end

local TableInsert = table.insert;
local Vector2New = Vector2.new;
local TableClear = table.clear;
local MathPow = math.pow;

local cleardrawcache = getgenv( ).cleardrawcache or ( function()
    if ( not getgenv( ).IGNORE_HOOK ) then
        local DrawingNew = nil; DrawingNew = hookfunction( Drawing.new, function( Type, PotentialFlag )
            local Object = DrawingNew( Type );

            if ( PotentialFlag == Flag ) then
                TableInsert( DrawingObjects, Object );
            end

            return Object;
        end )
    end

    return function( )
        for _, Object in DrawingObjects do
            Object:Destroy( );
        end

        TableClear( DrawingObjects );
    end
end )( );

-- API
do
    local Tween = { }; do
        local LinearInterpolation = { }; do
            function LinearInterpolation : Any( Start, Destination, Time )
                return Start + ( Destination - Start ) * Time;
            end

            function LinearInterpolation : Vector2( Start, Destination, Time )
                return Vector2New( self : Any( Start.X, Destination.X, Time ), self : Any( Start.Y, Destination.Y, Time ) );
            end
        end

        function Tween : SetValue( DrawingObject, Property, Destination, Time )
            local Start, Class, StartTime = DrawingObject[ Property ], typeof( Destination ), tick( );

            if ( not Start ) then
                return;
            end

            local Connection = nil; Connection = RunService.PreSimulation : Connect( function( )
                local Elapsed = tick( ) - StartTime;
                local Progress = Elapsed / Time;

                DrawingObject[ Property ] = ( LinearInterpolation[ Class ] or LinearInterpolation.Any )( LinearInterpolation, Start, Destination, self : Cubic( Progress ) );

                if ( Progress >= 1 ) then
                    DrawingObject[ Property ] = Destination;
                    Connection : Disconnect( );
                end
            end )
        end

        function Tween : Cubic( Value )
            local Result = 4 * MathPow( Value, 3 );

            if ( Value > .5 ) then
                return ( .5 * MathPow( ( 2 * Value ) - 2, 3 ) ) + 1;
            end

            return Result;
        end

        Tween.LinearInterpolation = LinearInterpolation;
    end

    function BetterDrawing : Create( Class, Properties )
        local DrawingObject = Drawing.new( Class );

        for Index, Value in Properties or { } do
            DrawingObject[ Index ] = Value;
        end

        return DrawingObject, TableInsert( DrawingObjects, DrawingObject );
    end

    function BetterDrawing : Init( Connection )
        return RunService : BindToRenderStep( "BetterDrawing", 2000, function( )
            if ( getgenv( ).FRAME_FIX ) and ( BetterDrawing.FRAME % 2 == 0 ) then
                cleardrawcache( );
            end

            Connection( );

            BetterDrawing.FRAME += 1;
        end )
    end

    BetterDrawing.Tween = Tween;
end

return BetterDrawing;
