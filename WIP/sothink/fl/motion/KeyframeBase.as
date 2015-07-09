package fl.motion
{
    import flash.filters.*;
    import flash.geom.*;
    import flash.utils.*;

    public class KeyframeBase extends Object
    {
        private var _index:int = -1;
        public var x:Number = NaN;
        public var y:Number = NaN;
        public var scaleX:Number = NaN;
        public var scaleY:Number = NaN;
        public var skewX:Number = NaN;
        public var skewY:Number = NaN;
        public var rotationConcat:Number = NaN;
        public var useRotationConcat:Boolean = false;
        public var filters:Array;
        public var color:Color;
        public var label:String = "";
        public var loop:String;
        public var firstFrame:String;
        public var cacheAsBitmap:Boolean = false;
        public var opaqueBackground:Object = null;
        public var blendMode:String = "normal";
        public var visible:Boolean = true;
        public var rotateDirection:String = "auto";
        public var rotateTimes:uint = 0;
        public var orientToPath:Boolean = false;
        public var blank:Boolean = false;
        public var matrix3D:Object = null;
        public var matrix:Matrix = null;
        public var z:Number = NaN;
        public var rotationX:Number = NaN;
        public var rotationY:Number = NaN;
        public var adjustColorObjects:Dictionary = null;

        public function KeyframeBase(param1:XML = null)
        {
            this.filters = [];
            this.adjustColorObjects = new Dictionary();
            return;
        }// end function

        public function get index() : int
        {
            return this._index;
        }// end function

        public function set index(param1:int) : void
        {
            this._index = param1 < 0 ? (0) : (param1);
            if (this._index == 0)
            {
                this.setDefaults();
            }
            return;
        }// end function

        public function get rotation() : Number
        {
            return this.skewY;
        }// end function

        public function set rotation(param1:Number) : void
        {
            if (isNaN(this.skewX) || isNaN(this.skewY))
            {
                this.skewX = param1;
            }
            else
            {
                this.skewX = this.skewX + (param1 - this.skewY);
            }
            this.skewY = param1;
            return;
        }// end function

        private function setDefaults() : void
        {
            if (isNaN(this.x))
            {
                this.x = 0;
            }
            if (isNaN(this.y))
            {
                this.y = 0;
            }
            if (isNaN(this.z))
            {
                this.z = 0;
            }
            if (isNaN(this.scaleX))
            {
                this.scaleX = 1;
            }
            if (isNaN(this.scaleY))
            {
                this.scaleY = 1;
            }
            if (isNaN(this.skewX))
            {
                this.skewX = 0;
            }
            if (isNaN(this.skewY))
            {
                this.skewY = 0;
            }
            if (isNaN(this.rotationConcat))
            {
                this.rotationConcat = 0;
            }
            if (!this.color)
            {
                this.color = new Color();
            }
            return;
        }// end function

        public function getValue(param1:String) : Number
        {
            return Number(this[param1]);
        }// end function

        public function setValue(param1:String, param2:Number) : void
        {
            this[param1] = param2;
            return;
        }// end function

        protected function hasTween() : Boolean
        {
            return false;
        }// end function

        public function affectsTweenable(param1:String = "") : Boolean
        {
            return !param1 || !isNaN(this[param1]) || param1 == "color" && this.color || param1 == "filters" && this.filters.length || param1 == "matrix3D" && this.matrix3D || param1 == "matrix" && this.matrix || this.blank || this.hasTween();
        }// end function

        public function setAdjustColorProperty(param1:int, param2:String, param3) : void
        {
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (param1 >= this.filters.length)
            {
                return;
            }
            var _loc_4:* = this.adjustColorObjects[param1];
            if (this.adjustColorObjects[param1] == null)
            {
                _loc_4 = new AdjustColor();
                this.adjustColorObjects[param1] = _loc_4;
            }
            switch(param2)
            {
                case "adjustColorBrightness":
                {
                    _loc_4.brightness = param3;
                    break;
                }
                case "adjustColorContrast":
                {
                    _loc_4.contrast = param3;
                    break;
                }
                case "adjustColorSaturation":
                {
                    _loc_4.saturation = param3;
                    break;
                }
                case "adjustColorHue":
                {
                    _loc_4.hue = param3;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (_loc_4.AllValuesAreSet())
            {
                _loc_5 = this.filters[param1] as ColorMatrixFilter;
                if (_loc_5)
                {
                    _loc_6 = _loc_4.CalculateFinalFlatArray();
                    if (_loc_6)
                    {
                        _loc_5.matrix = _loc_6;
                    }
                }
            }
            return;
        }// end function

        public function get tweensLength() : int
        {
            return 0;
        }// end function

    }
}
