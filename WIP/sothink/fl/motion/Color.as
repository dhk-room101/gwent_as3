package fl.motion
{
    import flash.geom.*;

    public class Color extends ColorTransform
    {
        private var _tintColor:Number = 0;
        private var _tintMultiplier:Number = 0;

        public function Color(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0)
        {
            super(param1, param2, param3, param4, param5, param6, param7, param8);
            return;
        }// end function

        public function get brightness() : Number
        {
            return this.redOffset ? (1 - this.redMultiplier) : ((this.redMultiplier - 1));
        }// end function

        public function set brightness(param1:Number) : void
        {
            if (param1 > 1)
            {
                param1 = 1;
            }
            else if (param1 < -1)
            {
                param1 = -1;
            }
            var _loc_2:* = 1 - Math.abs(param1);
            var _loc_3:* = 0;
            if (param1 > 0)
            {
                _loc_3 = param1 * 255;
            }
            var _loc_4:* = _loc_2;
            this.blueMultiplier = _loc_2;
            this.greenMultiplier = _loc_4;
            this.redMultiplier = _loc_4;
            var _loc_4:* = _loc_3;
            this.blueOffset = _loc_3;
            this.greenOffset = _loc_4;
            this.redOffset = _loc_4;
            return;
        }// end function

        public function setTint(param1:uint, param2:Number) : void
        {
            this._tintColor = param1;
            this._tintMultiplier = param2;
            var _loc_6:* = 1 - param2;
            this.blueMultiplier = 1 - param2;
            this.greenMultiplier = _loc_6;
            this.redMultiplier = _loc_6;
            var _loc_3:* = param1 >> 16 & 255;
            var _loc_4:* = param1 >> 8 & 255;
            var _loc_5:* = param1 & 255;
            this.redOffset = Math.round(_loc_3 * param2);
            this.greenOffset = Math.round(_loc_4 * param2);
            this.blueOffset = Math.round(_loc_5 * param2);
            return;
        }// end function

        public function get tintColor() : uint
        {
            return this._tintColor;
        }// end function

        public function set tintColor(param1:uint) : void
        {
            this.setTint(param1, this.tintMultiplier);
            return;
        }// end function

        private function deriveTintColor() : uint
        {
            var _loc_1:* = 1 / this.tintMultiplier;
            var _loc_2:* = Math.round(this.redOffset * _loc_1);
            var _loc_3:* = Math.round(this.greenOffset * _loc_1);
            var _loc_4:* = Math.round(this.blueOffset * _loc_1);
            var _loc_5:* = _loc_2 << 16 | _loc_3 << 8 | _loc_4;
            return _loc_2 << 16 | _loc_3 << 8 | _loc_4;
        }// end function

        public function get tintMultiplier() : Number
        {
            return this._tintMultiplier;
        }// end function

        public function set tintMultiplier(param1:Number) : void
        {
            this.setTint(this.tintColor, param1);
            return;
        }// end function

        private function parseXML(param1:XML = null) : Color
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            if (!param1)
            {
                return this;
            }
            var _loc_2:* = param1.elements()[0];
            if (!_loc_2)
            {
                return this;
            }
            for each (_loc_3 in _loc_2.attributes())
            {
                
                _loc_4 = _loc_3.localName();
                if (_loc_4 == "tintColor")
                {
                    _loc_5 = Number(_loc_3.toString()) as uint;
                    this.tintColor = _loc_5;
                    continue;
                }
                this[_loc_4] = Number(_loc_3.toString());
            }
            return this;
        }// end function

        public static function fromXML(param1:XML) : Color
        {
            return Color.Color(new Color.parseXML(param1));
        }// end function

        public static function interpolateTransform(param1:ColorTransform, param2:ColorTransform, param3:Number) : ColorTransform
        {
            var _loc_4:* = 1 - param3;
            var _loc_5:* = new ColorTransform(param1.redMultiplier * _loc_4 + param2.redMultiplier * param3, param1.greenMultiplier * _loc_4 + param2.greenMultiplier * param3, param1.blueMultiplier * _loc_4 + param2.blueMultiplier * param3, param1.alphaMultiplier * _loc_4 + param2.alphaMultiplier * param3, param1.redOffset * _loc_4 + param2.redOffset * param3, param1.greenOffset * _loc_4 + param2.greenOffset * param3, param1.blueOffset * _loc_4 + param2.blueOffset * param3, param1.alphaOffset * _loc_4 + param2.alphaOffset * param3);
            return new ColorTransform(param1.redMultiplier * _loc_4 + param2.redMultiplier * param3, param1.greenMultiplier * _loc_4 + param2.greenMultiplier * param3, param1.blueMultiplier * _loc_4 + param2.blueMultiplier * param3, param1.alphaMultiplier * _loc_4 + param2.alphaMultiplier * param3, param1.redOffset * _loc_4 + param2.redOffset * param3, param1.greenOffset * _loc_4 + param2.greenOffset * param3, param1.blueOffset * _loc_4 + param2.blueOffset * param3, param1.alphaOffset * _loc_4 + param2.alphaOffset * param3);
        }// end function

        public static function interpolateColor(param1:uint, param2:uint, param3:Number) : uint
        {
            var _loc_4:* = 1 - param3;
            var _loc_5:* = param1 >> 24 & 255;
            var _loc_6:* = param1 >> 16 & 255;
            var _loc_7:* = param1 >> 8 & 255;
            var _loc_8:* = param1 & 255;
            var _loc_9:* = param2 >> 24 & 255;
            var _loc_10:* = param2 >> 16 & 255;
            var _loc_11:* = param2 >> 8 & 255;
            var _loc_12:* = param2 & 255;
            var _loc_13:* = _loc_5 * _loc_4 + _loc_9 * param3;
            var _loc_14:* = _loc_6 * _loc_4 + _loc_10 * param3;
            var _loc_15:* = _loc_7 * _loc_4 + _loc_11 * param3;
            var _loc_16:* = _loc_8 * _loc_4 + _loc_12 * param3;
            var _loc_17:* = _loc_13 << 24 | _loc_14 << 16 | _loc_15 << 8 | _loc_16;
            return _loc_13 << 24 | _loc_14 << 16 | _loc_15 << 8 | _loc_16;
        }// end function

    }
}
