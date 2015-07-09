package red.game.witcher3.controls
{
    import flash.display.*;
    import flash.text.*;

    public class KeyboardButtonIcon extends MovieClip
    {
        public var mcBackground:Sprite;
        public var textField:TextField;
        protected var _label:String;
        protected var _backgroundVisibility:Boolean;
        static const TEXT_OFFSET:Number = 5;
        static const MIN_SIZE:Number = 42;
        static const POS_LEFT_X:Number = 5;
        static const POS_LEFT_X_BIG:Number = 10;

        public function KeyboardButtonIcon()
        {
            return;
        }// end function

        public function get label() : String
        {
            return this._label;
        }// end function

        public function set label(param1:String) : void
        {
            this._label = param1;
            this.textField.text = this._label;
            var _loc_2:* = this.textField.textWidth + TEXT_OFFSET;
            this.textField.width = _loc_2;
            if (POS_LEFT_X_BIG + _loc_2 > MIN_SIZE)
            {
                this.mcBackground.width = _loc_2 + POS_LEFT_X_BIG;
                this.textField.x = POS_LEFT_X;
            }
            else
            {
                this.mcBackground.width = MIN_SIZE;
                this.textField.x = (this.mcBackground.width - _loc_2) / 2;
            }
            return;
        }// end function

        public function get backgroundVisibility() : Boolean
        {
            return this._backgroundVisibility;
        }// end function

        public function set backgroundVisibility(param1:Boolean) : void
        {
            this._backgroundVisibility = param1;
            this.mcBackground.visible = this._backgroundVisibility;
            return;
        }// end function

    }
}
