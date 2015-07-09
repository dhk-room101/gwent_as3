package scaleform.gfx
{
    import flash.events.*;

    final public class KeyboardEventEx extends KeyboardEvent
    {
        public var controllerIdx:uint = 0;

        public function KeyboardEventEx(param1:String)
        {
            super(param1);
            return;
        }// end function

    }
}
