package scaleform.gfx
{
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;

    final public class Extensions extends Object
    {
        public static const EDGEAA_INHERIT:uint = 0;
        public static const EDGEAA_ON:uint = 1;
        public static const EDGEAA_OFF:uint = 2;
        public static const EDGEAA_DISABLE:uint = 3;
        public static var isGFxPlayer:Boolean = false;
        public static var CLIK_addedToStageCallback:Function;
        public static var gfxProcessSound:Function;

        public function Extensions()
        {
            return;
        }// end function

        public static function set enabled(param1:Boolean) : void
        {
            return;
        }// end function

        public static function get enabled() : Boolean
        {
            return false;
        }// end function

        public static function set noInvisibleAdvance(param1:Boolean) : void
        {
            return;
        }// end function

        public static function get noInvisibleAdvance() : Boolean
        {
            return false;
        }// end function

        public static function getTopMostEntity(param1:Number, param2:Number, param3:Boolean = true) : DisplayObject
        {
            return null;
        }// end function

        public static function getMouseTopMostEntity(param1:Boolean = true, param2:uint = 0) : DisplayObject
        {
            return null;
        }// end function

        public static function setMouseCursorType(param1:String, param2:uint = 0) : void
        {
            return;
        }// end function

        public static function getMouseCursorType(param1:uint = 0) : String
        {
            return "";
        }// end function

        public static function get numControllers() : uint
        {
            return 1;
        }// end function

        public static function get visibleRect() : Rectangle
        {
            return new Rectangle(0, 0, 0, 0);
        }// end function

        public static function getEdgeAAMode(param1:DisplayObject) : uint
        {
            return EDGEAA_INHERIT;
        }// end function

        public static function setEdgeAAMode(param1:DisplayObject, param2:uint) : void
        {
            return;
        }// end function

        public static function setIMEEnabled(param1:TextField, param2:Boolean) : void
        {
            return;
        }// end function

        public static function get isScaleform() : Boolean
        {
            return false;
        }// end function

    }
}
