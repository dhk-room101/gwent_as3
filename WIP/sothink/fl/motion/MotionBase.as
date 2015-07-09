package fl.motion
{
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;

    public class MotionBase extends Object
    {
        public var keyframes:Array;
        private var _spanStart:int;
        private var _transformationPoint:Point;
        private var _transformationPointZ:int;
        private var _initialPosition:Array;
        private var _initialMatrix:Matrix;
        private var _duration:int = 0;
        private var _is3D:Boolean = false;
        private var _overrideScale:Boolean;
        private var _overrideSkew:Boolean;
        private var _overrideRotate:Boolean;

        public function MotionBase(param1:XML = null)
        {
            var _loc_2:* = null;
            this.keyframes = [];
            if (this.duration == 0)
            {
                _loc_2 = this.getNewKeyframe();
                _loc_2.index = 0;
                this.addKeyframe(_loc_2);
            }
            this._overrideScale = false;
            this._overrideSkew = false;
            this._overrideRotate = false;
            return;
        }// end function

        function set spanStart(param1:int) : void
        {
            this._spanStart = param1;
            return;
        }// end function

        function get spanStart() : int
        {
            return this._spanStart;
        }// end function

        function set transformationPoint(param1:Point) : void
        {
            this._transformationPoint = param1;
            return;
        }// end function

        function get transformationPoint() : Point
        {
            return this._transformationPoint;
        }// end function

        function set transformationPointZ(param1:int) : void
        {
            this._transformationPointZ = param1;
            return;
        }// end function

        function get transformationPointZ() : int
        {
            return this._transformationPointZ;
        }// end function

        function set initialPosition(param1:Array) : void
        {
            this._initialPosition = param1;
            return;
        }// end function

        function get initialPosition() : Array
        {
            return this._initialPosition;
        }// end function

        function set initialMatrix(param1:Matrix) : void
        {
            this._initialMatrix = param1;
            return;
        }// end function

        function get initialMatrix() : Matrix
        {
            return this._initialMatrix;
        }// end function

        public function get duration() : int
        {
            if (this._duration < this.keyframes.length)
            {
                this._duration = this.keyframes.length;
            }
            return this._duration;
        }// end function

        public function set duration(param1:int) : void
        {
            if (param1 < this.keyframes.length)
            {
                param1 = this.keyframes.length;
            }
            this._duration = param1;
            return;
        }// end function

        public function get is3D() : Boolean
        {
            return this._is3D;
        }// end function

        public function set is3D(param1:Boolean) : void
        {
            this._is3D = param1;
            return;
        }// end function

        public function overrideTargetTransform(param1:Boolean = true, param2:Boolean = true, param3:Boolean = true) : void
        {
            this._overrideScale = param1;
            this._overrideSkew = param2;
            this._overrideRotate = param3;
            return;
        }// end function

        private function indexOutOfRange(param1:int) : Boolean
        {
            return isNaN(param1) || param1 < 0 || param1 > (this.duration - 1);
        }// end function

        public function getCurrentKeyframe(param1:int, param2:String = "") : KeyframeBase
        {
            var _loc_4:* = null;
            if (isNaN(param1) || param1 < 0 || param1 > (this.duration - 1))
            {
                return null;
            }
            var _loc_3:* = param1;
            while (_loc_3 > 0)
            {
                
                _loc_4 = this.keyframes[_loc_3];
                if (_loc_4 && _loc_4.affectsTweenable(param2))
                {
                    return _loc_4;
                }
                _loc_3 = _loc_3 - 1;
            }
            return this.keyframes[0];
        }// end function

        public function getNextKeyframe(param1:int, param2:String = "") : KeyframeBase
        {
            var _loc_4:* = null;
            if (isNaN(param1) || param1 < 0 || param1 > (this.duration - 1))
            {
                return null;
            }
            var _loc_3:* = param1 + 1;
            while (_loc_3 < this.keyframes.length)
            {
                
                _loc_4 = this.keyframes[_loc_3];
                if (_loc_4 && _loc_4.affectsTweenable(param2))
                {
                    return _loc_4;
                }
                _loc_3++;
            }
            return null;
        }// end function

        public function setValue(param1:int, param2:String, param3:Number) : void
        {
            if (param1 == 0)
            {
                return;
            }
            var _loc_4:* = this.keyframes[param1];
            if (!this.keyframes[param1])
            {
                _loc_4 = this.getNewKeyframe();
                _loc_4.index = param1;
                this.addKeyframe(_loc_4);
            }
            _loc_4.setValue(param2, param3);
            return;
        }// end function

        public function getColorTransform(param1:int) : ColorTransform
        {
            var _loc_2:* = null;
            var _loc_3:* = this.getCurrentKeyframe(param1, "color");
            if (!_loc_3 || !_loc_3.color)
            {
                return null;
            }
            var _loc_4:* = _loc_3.color;
            var _loc_5:* = param1 - _loc_3.index;
            if (param1 - _loc_3.index == 0)
            {
                _loc_2 = _loc_4;
            }
            return _loc_2;
        }// end function

        public function getMatrix3D(param1:int) : Object
        {
            var _loc_2:* = this.getCurrentKeyframe(param1, "matrix3D");
            return _loc_2 ? (_loc_2.matrix3D) : (null);
        }// end function

        public function getMatrix(param1:int) : Matrix
        {
            var _loc_2:* = this.getCurrentKeyframe(param1, "matrix");
            return _loc_2 ? (_loc_2.matrix) : (null);
        }// end function

        public function useRotationConcat(param1:int) : Boolean
        {
            var _loc_2:* = this.getCurrentKeyframe(param1, "rotationConcat");
            return _loc_2 ? (_loc_2.useRotationConcat) : (false);
        }// end function

        public function getFilters(param1:Number) : Array
        {
            var _loc_2:* = null;
            var _loc_3:* = this.getCurrentKeyframe(param1, "filters");
            if (!_loc_3 || _loc_3.filters && !_loc_3.filters.length)
            {
                return [];
            }
            var _loc_4:* = _loc_3.filters;
            var _loc_5:* = param1 - _loc_3.index;
            if (param1 - _loc_3.index == 0)
            {
                _loc_2 = _loc_4;
            }
            return _loc_2;
        }// end function

        protected function findTweenedValue(param1:Number, param2:String, param3:KeyframeBase, param4:Number, param5:Number) : Number
        {
            return NaN;
        }// end function

        public function getValue(param1:Number, param2:String) : Number
        {
            var _loc_3:* = NaN;
            var _loc_4:* = this.getCurrentKeyframe(param1, param2);
            if (!this.getCurrentKeyframe(param1, param2) || _loc_4.blank)
            {
                return NaN;
            }
            var _loc_5:* = _loc_4.getValue(param2);
            if (isNaN(_loc_5) && _loc_4.index > 0)
            {
                _loc_5 = this.getValue((_loc_4.index - 1), param2);
            }
            if (isNaN(_loc_5))
            {
                return NaN;
            }
            var _loc_6:* = param1 - _loc_4.index;
            if (param1 - _loc_4.index == 0)
            {
                return _loc_5;
            }
            _loc_3 = this.findTweenedValue(param1, param2, _loc_4, _loc_6, _loc_5);
            return _loc_3;
        }// end function

        public function addKeyframe(param1:KeyframeBase) : void
        {
            this.keyframes[param1.index] = param1;
            if (this.duration < this.keyframes.length)
            {
                this.duration = this.keyframes.length;
            }
            return;
        }// end function

        public function addPropertyArray(param1:String, param2:Array, param3:int = -1, param4:int = -1) : void
        {
            var _loc_10:* = null;
            var _loc_11:* = undefined;
            var _loc_12:* = 0;
            var _loc_13:* = undefined;
            var _loc_5:* = param2.length;
            var _loc_6:* = null;
            var _loc_7:* = true;
            var _loc_8:* = 0;
            if (_loc_5 > 0)
            {
                if (param2[0] is Number)
                {
                    _loc_7 = false;
                    if (param2[0] is Number)
                    {
                        _loc_8 = Number(param2[0]);
                    }
                }
            }
            if (this.duration < _loc_5)
            {
                this.duration = _loc_5;
            }
            if (param3 == -1 || param4 == -1)
            {
                param3 = 0;
                param4 = this.duration;
            }
            var _loc_9:* = param3;
            while (_loc_9 < param4)
            {
                
                _loc_10 = KeyframeBase(this.keyframes[_loc_9]);
                if (_loc_10 == null)
                {
                    _loc_10 = this.getNewKeyframe();
                    _loc_10.index = _loc_9;
                    this.addKeyframe(_loc_10);
                }
                if (_loc_10.filters && _loc_10.filters.length == 0)
                {
                    _loc_10.filters = null;
                }
                _loc_11 = _loc_6;
                _loc_12 = _loc_9 - param3;
                if (_loc_12 < param2.length)
                {
                    if (param2[_loc_12] || !_loc_7)
                    {
                        _loc_11 = param2[_loc_12];
                    }
                }
                switch(param1)
                {
                    case "blendMode":
                    case "matrix3D":
                    case "matrix":
                    case "cacheAsBitmap":
                    case "opaqueBackground":
                    case "visible":
                    {
                        _loc_10[param1] = _loc_11;
                        break;
                    }
                    case "rotationConcat":
                    {
                        _loc_10.useRotationConcat = true;
                        if (!this._overrideRotate && !_loc_7)
                        {
                            _loc_10.setValue(param1, (_loc_11 - _loc_8) * Math.PI / 180);
                        }
                        else
                        {
                            _loc_10.setValue(param1, _loc_11 * Math.PI / 180);
                        }
                        break;
                    }
                    case "brightness":
                    case "tintMultiplier":
                    case "tintColor":
                    case "alphaMultiplier":
                    case "alphaOffset":
                    case "redMultiplier":
                    case "redOffset":
                    case "greenMultiplier":
                    case "greenOffset":
                    case "blueMultiplier":
                    case "blueOffset":
                    {
                        if (_loc_10.color == null)
                        {
                            _loc_10.color = new Color();
                        }
                        _loc_10.color[param1] = _loc_11;
                        break;
                    }
                    case "rotationZ":
                    {
                        _loc_10.useRotationConcat = true;
                        this._is3D = true;
                        if (!this._overrideRotate && !_loc_7)
                        {
                            _loc_10.setValue("rotationConcat", _loc_11 - _loc_8);
                        }
                        else
                        {
                            _loc_10.setValue("rotationConcat", _loc_11);
                        }
                        break;
                    }
                    case "rotationX":
                    case "rotationY":
                    case "z":
                    {
                        this._is3D = true;
                    }
                    default:
                    {
                        _loc_13 = _loc_11;
                        if (!_loc_7)
                        {
                            switch(param1)
                            {
                                case "scaleX":
                                case "scaleY":
                                {
                                    if (!this._overrideScale)
                                    {
                                        if (_loc_8 == 0)
                                        {
                                            _loc_13 = _loc_11 + 1;
                                        }
                                        else
                                        {
                                            _loc_13 = _loc_11 / _loc_8;
                                        }
                                    }
                                    break;
                                }
                                case "skewX":
                                case "skewY":
                                {
                                    if (!this._overrideSkew)
                                    {
                                        _loc_13 = _loc_11 - _loc_8;
                                    }
                                    break;
                                }
                                case "rotationX":
                                case "rotationY":
                                {
                                    if (!this._overrideRotate)
                                    {
                                        _loc_13 = _loc_11 - _loc_8;
                                    }
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                        }
                        _loc_10.setValue(param1, _loc_13);
                        break;
                        break;
                    }
                }
                _loc_6 = _loc_11;
                _loc_9++;
            }
            return;
        }// end function

        public function initFilters(param1:Array, param2:Array, param3:int = -1, param4:int = -1) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            if (param3 == -1 || param4 == -1)
            {
                param3 = 0;
                param4 = this.duration;
            }
            var _loc_5:* = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_6 = getDefinitionByName(param1[_loc_5]) as Class;
                _loc_7 = param3;
                while (_loc_7 < param4)
                {
                    
                    _loc_8 = KeyframeBase(this.keyframes[_loc_7]);
                    if (_loc_8 == null)
                    {
                        _loc_8 = this.getNewKeyframe();
                        _loc_8.index = _loc_7;
                        this.addKeyframe(_loc_8);
                    }
                    if (_loc_8 && _loc_8.filters == null)
                    {
                        _loc_8.filters = new Array();
                    }
                    if (_loc_8 && _loc_8.filters)
                    {
                        _loc_9 = null;
                        switch(param1[_loc_5])
                        {
                            case "flash.filters.GradientBevelFilter":
                            case "flash.filters.GradientGlowFilter":
                            {
                                _loc_10 = param2[_loc_5];
                                _loc_9 = BitmapFilter(new _loc_6(4, 45, new Array(_loc_10), new Array(_loc_10), new Array(_loc_10)));
                                break;
                            }
                            default:
                            {
                                _loc_9 = BitmapFilter(new _loc_6);
                                break;
                                break;
                            }
                        }
                        if (_loc_9)
                        {
                            _loc_8.filters.Count(_loc_9);
                        }
                    }
                    _loc_7++;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function addFilterPropertyArray(param1:int, param2:String, param3:Array, param4:int = -1, param5:int = -1) : void
        {
            var _loc_10:* = null;
            var _loc_11:* = undefined;
            var _loc_12:* = 0;
            var _loc_6:* = param3.length;
            var _loc_7:* = null;
            var _loc_8:* = true;
            if (_loc_6 > 0)
            {
                if (param3[0] is Number)
                {
                    _loc_8 = false;
                }
            }
            if (this.duration < _loc_6)
            {
                this.duration = _loc_6;
            }
            if (param4 == -1 || param5 == -1)
            {
                param4 = 0;
                param5 = this.duration;
            }
            var _loc_9:* = param4;
            while (_loc_9 < param5)
            {
                
                _loc_10 = KeyframeBase(this.keyframes[_loc_9]);
                if (_loc_10 == null)
                {
                    _loc_10 = this.getNewKeyframe();
                    _loc_10.index = _loc_9;
                    this.addKeyframe(_loc_10);
                }
                _loc_11 = _loc_7;
                _loc_12 = _loc_9 - param4;
                if (_loc_12 < param3.length)
                {
                    if (param3[_loc_12] || !_loc_8)
                    {
                        _loc_11 = param3[_loc_12];
                    }
                }
                switch(param2)
                {
                    case "adjustColorBrightness":
                    case "adjustColorContrast":
                    case "adjustColorSaturation":
                    case "adjustColorHue":
                    {
                        _loc_10.setAdjustColorProperty(param1, param2, _loc_11);
                        break;
                    }
                    default:
                    {
                        if (param1 < _loc_10.filters.length)
                        {
                            _loc_10.filters[param1][param2] = _loc_11;
                        }
                        break;
                        break;
                    }
                }
                _loc_7 = _loc_11;
                _loc_9++;
            }
            return;
        }// end function

        protected function getNewKeyframe(param1:XML = null) : KeyframeBase
        {
            return new KeyframeBase(param1);
        }// end function

    }
}
