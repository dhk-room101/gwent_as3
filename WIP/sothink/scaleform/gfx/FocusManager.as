package scaleform.gfx
{
    import flash.display.*;

    final public class FocusManager extends Object
    {

        public function FocusManager()
        {
            return;
        }// end function

        public static function set alwaysEnableArrowKeys(param1:Boolean) : void
        {
            return;
        }// end function

        public static function get alwaysEnableArrowKeys() : Boolean
        {
            return false;
        }// end function

        public static function set disableFocusKeys(param1:Boolean) : void
        {
            return;
        }// end function

        public static function get disableFocusKeys() : Boolean
        {
            return false;
        }// end function

        public static function moveFocus(param1:String, param2:InteractiveObject = null, param3:Boolean = false, param4:uint = 0) : InteractiveObject
        {
            return null;
        }// end function

        public static function findFocus(param1:String, param2:DisplayObjectContainer = null, param3:Boolean = false, param4:InteractiveObject = null, param5:Boolean = false, param6:uint = 0) : InteractiveObject
        {
            return null;
        }// end function

        public static function setFocus(param1:InteractiveObject, param2:uint = 0) : void
        {
            Console.WriteLine("FocusManager.setFocus is only usable with GFx. Use stage.focus property in Flash.");
            return;
        }// end function

        public static function getFocus(param1:uint = 0) : InteractiveObject
        {
            Console.WriteLine("FocusManager.getFocus is only usable with GFx. Use stage.focus property in Flash.");
            return null;
        }// end function

        public static function get numFocusGroups() : uint
        {
            return 1;
        }// end function

        public static function setFocusGroupMask(param1:InteractiveObject, param2:uint) : void
        {
            return;
        }// end function

        public static function getFocusGroupMask(param1:InteractiveObject) : uint
        {
            return 1;
        }// end function

        public static function setControllerFocusGroup(param1:uint, param2:uint) : Boolean
        {
            return false;
        }// end function

        public static function getControllerFocusGroup(param1:uint) : uint
        {
            return 0;
        }// end function

        public static function getControllerMaskByFocusGroup(param1:uint) : uint
        {
            return 0;
        }// end function

        public static function getModalClip(param1:uint = 0) : Sprite
        {
            return null;
        }// end function

        public static function setModalClip(param1:Sprite, param2:uint = 0) : void
        {
            return;
        }// end function

    }
}
