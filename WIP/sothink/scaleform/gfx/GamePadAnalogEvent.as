package scaleform.gfx
{
    import flash.events.*;

    final public class GamePadAnalogEvent extends Event
    {
        public var code:uint = 0;
        public var controllerIdx:uint = 0;
        public var xvalue:Number = 0;
        public var yvalue:Number = 0;
        public static const CHANGE:String = "gamePadAnalogChange";

        public function GamePadAnalogEvent(param1:Boolean, param2:Boolean, param3:uint, param4:uint = 0, param5:Number = 0, param6:Number = 0)
        {
            super(GamePadAnalogEvent.CHANGE, param1, param2);
            this.code = param3;
            this.controllerIdx = param4;
            this.xvalue = param5;
            this.yvalue = param6;
            return;
        }// end function

    }
}
