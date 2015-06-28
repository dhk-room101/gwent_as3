///ColorSprite
package red.game.witcher3.menus.common 
{
    import flash.display.*;
    import scaleform.clik.core.*;
    
    public class ColorSprite extends scaleform.clik.core.UIComponent
    {
        public function ColorSprite()
        {
            super();
            this.mcColorBlind.visible = false;
            return;
        }

        public function get colorBlind():Boolean
        {
            return this._colorBlind;
        }

        public function set colorBlind(arg1:Boolean):void
        {
            this._colorBlind = arg1;
            this.updateColor();
            return;
        }

        public function get color():String
        {
            return this._color;
        }

        public function set color(arg1:String):void
        {
            this._color = arg1;
            this.updateColor();
            return;
        }

        protected function updateColor():void
        {
            if (this._color) 
            {
                this.mcColorBlind.visible = this._colorBlind;
                this.mcColorBlind.gotoAndStop(this._color);
                this.mcColor.gotoAndStop(this._color);
            }
            return;
        }

        public function setByItemQuality(arg1:int):void
        {
            var loc1:*=arg1;
            switch (loc1) 
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
            }
            return;
        }

        public function setBySkillType(arg1:String):void
        {
            var loc1:*=arg1;
            switch (loc1) 
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
            }
            return;
        }

        public override function toString():String
        {
            return "ColorSprite [" + this.name + "]";
        }

        public static const COLOR_NONE:String="none";

        public static const COLOR_YELLOW:String="red";

        public static const COLOR_GREEN:String="green";

        public static const COLOR_BLUE:String="blue";

        public static const COLOR_ORANGE:String="orange";

        public var mcColorBlind:flash.display.MovieClip;

        public var mcColor:flash.display.MovieClip;

        protected var _colorBlind:Boolean;

        protected var _color:String;
    }
}


