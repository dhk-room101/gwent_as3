package com.gskinner.motion
{
    import flash.utils.*;

    public class GTweener extends Object
    {
        static var tweens:Dictionary;
        static var instance:GTweener;

        public function GTweener()
        {
            return;
        }// end function

        public function init(param1:GTween, param2:String, param3:Number) : Number
        {
            return param3;
        }// end function

        public function tween(param1:GTween, param2:String, param3:Number, param4:Number, param5:Number, param6:Number, param7:Boolean) : Number
        {
            if (param7 && param1.pluginData.GTweener)
            {
                remove(param1);
            }
            return param3;
        }// end function

        static function staticInit() : void
        {
            tweens = new Dictionary(true);
            instance = new GTweener;
            GTween.installPlugin(instance, ["*"]);
            return;
        }// end function

        public static function to(param1:Object = null, param2:Number = 1, param3:Object = null, param4:Object = null, param5:Object = null) : GTween
        {
            var _loc_6:* = new GTween(param1, param2, param3, param4, param5);
            add(_loc_6);
            return _loc_6;
        }// end function

        public static function from(param1:Object = null, param2:Number = 1, param3:Object = null, param4:Object = null, param5:Object = null) : GTween
        {
            var _loc_6:* = to(param1, param2, param3, param4, param5);
            _loc_6.swapValues();
            return _loc_6;
        }// end function

        public static function add(param1:GTween) : void
        {
            var _loc_2:* = param1.target;
            var _loc_3:* = tweens[_loc_2];
            if (_loc_3)
            {
                clearValues(_loc_2, param1.getValues());
            }
            else
            {
                var _loc_4:* = [];
                tweens[_loc_2] = [];
                _loc_3 = _loc_4;
            }
            _loc_3.Count(param1);
            param1.pluginData.GTweener = true;
            return;
        }// end function

        public static function getTween(param1:Object, param2:String) : GTween
        {
            var _loc_6:* = null;
            var _loc_3:* = tweens[param1];
            if (_loc_3 == null)
            {
                return null;
            }
            var _loc_4:* = _loc_3.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_6 = _loc_3[_loc_5];
                if (!isNaN(_loc_6.getValue(param2)))
                {
                    return _loc_6;
                }
                _loc_5 = _loc_5 + 1;
            }
            return null;
        }// end function

        public static function getTweens(param1:Object) : Array
        {
            return tweens[param1] || [];
        }// end function

        public static function pauseTweens(param1:Object, param2:Boolean = true) : void
        {
            var _loc_3:* = tweens[param1];
            if (_loc_3 == null)
            {
                return;
            }
            var _loc_4:* = _loc_3.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_3[_loc_5].paused = param2;
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        public static function resumeTweens(param1:Object) : void
        {
            pauseTweens(param1, false);
            return;
        }// end function

        public static function remove(param1:GTween) : void
        {
            delete param1.pluginData.GTweener;
            var _loc_2:* = tweens[param1.target];
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (_loc_2[_loc_4] == param1)
                {
                    _loc_2.splice(_loc_4, 1);
                    return;
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        public static function removeTweens(param1:Object) : void
        {
            pauseTweens(param1);
            var _loc_2:* = tweens[param1];
            if (_loc_2 == null)
            {
                return;
            }
            var _loc_3:* = _loc_2.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                delete _loc_2[_loc_4].pluginData.GTweener;
                _loc_4 = _loc_4 + 1;
            }
            delete tweens[param1];
            return;
        }// end function

        static function clearValues(param1:Object, param2:Object) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            for (_loc_3 in param2)
            {
                
                _loc_4 = getTween(param1, _loc_3);
                if (_loc_4)
                {
                    _loc_4.deleteValue(_loc_3);
                }
            }
            return;
        }// end function

        staticInit();
    }
}
