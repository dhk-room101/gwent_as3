package red.game.witcher3.constants
{

    public class KeyboardKeys extends Object
    {
        public static var keyCodesMap:Object = {1:"LeftMouse", 2:"RightMouse", 3:"MiddleMouse", 9:"[[input_device_key_name_IK_Tab]]", 13:"[[input_device_key_name_IK_Enter]]", 16:"[[input_device_key_name_IK_Shift]]", 17:"[[input_device_key_name_IK_Ctrl]]", 18:"[[input_device_key_name_IK_Alt]]", 19:"[[input_device_key_name_IK_Pause]]", 20:"[[input_device_key_name_IK_CapsLock]]", 27:"[[input_device_key_name_IK_Escape]]", 32:"[[input_device_key_name_IK_Space]]", 33:"[[input_device_key_name_IK_PageUp]]", 34:"[[input_device_key_name_IK_PageDown]]", 35:"[[input_device_key_name_IK_End]]", 36:"[[input_device_key_name_IK_Home]]", 38:"Up", 37:"Left", 39:"Right", 40:"Down", 41:"Select", 44:"[[input_device_key_name_IK_Print]]", 45:"[[input_device_key_name_IK_Insert]]", 46:"[[input_device_key_name_IK_Delete]]", 96:"NumPad0", 97:"NumPad1", 98:"NumPad2", 99:"NumPad3", 0:"NumPad4", 0:"NumPad5", 0:"NumPad6", 0:"NumPad7", 0:"NumPad8", 0:"NumPad9", 0:"NumStar", 0:"NumPlus", 0:"Separator", 0:"[[input_device_key_name_IK_NumMinus]]", 1:"NumPeriod", 1:"NumSlash", 1:"F1", 1:"F2", 1:"F3", 1:"F4", 1:"F5", 1:"F6", 1:"F7", 1:"F8", 2:"F9", 2:"F10", 2:"F11", 2:"F12", 2:"F13", 2:"F14", 2:"F15", 2:"F16", 2:"F17", 2:"F18", 3:"F19", 3:"F20", 3:"F21", 3:"F22", 3:"F23", 3:"F24", 5:"NumLock", 5:"[[input_device_key_name_IK_ScrollLock]]", 6:"[[input_device_key_name_IK_LShift]]", 6:"[[input_device_key_name_IK_RShift]]", 6:"[[input_device_key_name_IK_LControl]]", 6:"[[input_device_key_name_IK_RControl]]", 8:";", 8:"=", 8:",", 8:"-", 9:".", 9:"/", 9:"~", 2:"[", 2:"]", 2:"\'", 9:"Mouse4", 9:"Mouse5", 9:"Mouse6", 9:"Mouse7", 9:"Mouse8"};

        public function KeyboardKeys()
        {
            return;
        }// end function

        public static function getKeyLabel(param1:int) : String
        {
            if (!param1)
            {
                return "[[input_device_key_name_IK_none]]";
            }
            var _loc_2:* = keyCodesMap[param1];
            if (_loc_2)
            {
                return _loc_2;
            }
            _loc_2 = String.fromCharCode(param1);
            return _loc_2;
        }// end function

    }
}
