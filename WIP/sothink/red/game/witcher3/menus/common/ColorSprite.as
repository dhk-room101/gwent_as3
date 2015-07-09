package red.game.witcher3.menus.common
{
    import flash.display.*;
    import scaleform.clik.core.*;

    public class ColorSprite extends UIComponent
    {
        public var mcColorBlind:MovieClip;
        public var mcColor:MovieClip;
        protected var _colorBlind:Boolean;
        protected var _color:String;
        public static const COLOR_NONE:String = "none";
        public static const COLOR_YELLOW:String = "red";
        public static const COLOR_GREEN:String = "green";
        public static const COLOR_BLUE:String = "blue";
        public static const COLOR_ORANGE:String = "orange";

        public function ColorSprite()
        {
            this.mcColorBlind.visible = false;
            return;
        }// end function

        public function get colorBlind() : Boolean
        {
            return this._colorBlind;
        }// end function

        public function set colorBlind(param1:Boolean) : void
        {
            this._colorBlind = param1;
            this.mcColorBlind.visible = this._colorBlind;
            return;
        }// end function

        public function get color() : String
        {
            return this._color;
        }// end function

        public function set color(param1:String) : void
        {
            this._color = param1;
            this.updateColor();
            return;
        }// end function

        protected function updateColor() : void
        {
            if (this._color)
            {
                this.mcColorBlind.gotoAndStop(this._color);
                this.mcColor.gotoAndStop(this._color);
            }
            return;
        }// end function

        public function setByItemQuality(param1:int) : void
        {
            switch(param1)
            {
                case 0:
                case 1:
                {
                    this.color = COLOR_NONE;
                    break;
                }
                case 2:
                {
                    this.color = COLOR_BLUE;
                    break;
                }
                case 3:
                {
                    this.color = COLOR_YELLOW;
                    break;
                }
                case 4:
                {
                    this.color = COLOR_ORANGE;
                    break;
                }
                case 5:
                {
                    this.color = COLOR_GREEN;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function setBySkillType(param1:String) : void
        {
            switch(param1)
            {
                case "SC_None":
                {
                    this.color = COLOR_NONE;
                    break;
                }
                case "SC_Blue":
                {
                    this.color = COLOR_BLUE;
                    break;
                }
                case "SC_Green":
                {
                    this.color = COLOR_GREEN;
                    break;
                }
                case "SC_Yellow":
                {
                    this.color = COLOR_YELLOW;
                    break;
                }
                case "SC_Red":
                {
                    this.color = COLOR_ORANGE;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "ColorSprite [" + this.name + "]";
        }// end function

    }
}
