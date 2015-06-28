package red.game.witcher3.controls 
{
    import flash.display.*;
    import flash.text.*;
    
    public class KeyboardButtonIcon extends flash.display.MovieClip
    {
        public function KeyboardButtonIcon()
        {
            super();
            return;
        }

        public function get label():String
        {
            return this._label;
        }

        public function set label(arg1:String):void
        {
            this._label = arg1;
            this.textField.text = this._label;
            var loc1:*=this.textField.textWidth + TEXT_OFFSET;
            this.textField.width = loc1;
            if (POS_LEFT_X_BIG + loc1 > MIN_SIZE) 
            {
                this.mcBackground.width = loc1 + POS_LEFT_X_BIG;
                this.textField.x = POS_LEFT_X;
            }
            else 
            {
                this.mcBackground.width = MIN_SIZE;
                this.textField.x = (this.mcBackground.width - loc1) / 2;
            }
            return;
        }

        public function get backgroundVisibility():Boolean
        {
            return this._backgroundVisibility;
        }

        public function set backgroundVisibility(arg1:Boolean):void
        {
            this._backgroundVisibility = arg1;
            this.mcBackground.visible = this._backgroundVisibility;
            return;
        }

        protected static const TEXT_OFFSET:Number=5;

        protected static const MIN_SIZE:Number=42;

        protected static const POS_LEFT_X:Number=5;

        protected static const POS_LEFT_X_BIG:Number=10;

        public var mcBackground:flash.display.Sprite;

        public var textField:flash.text.TextField;

        protected var _label:String;

        protected var _backgroundVisibility:Boolean;
    }
}
