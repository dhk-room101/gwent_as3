package red.game.witcher3.controls 
{
    import scaleform.clik.core.*;
    
    public class KeyboardButtonClickArea extends scaleform.clik.core.UIComponent
    {
        public function KeyboardButtonClickArea()
        {
            super();
            return;
        }

        public function get state():String
        {
            return this._state;
        }

        public function set state(arg1:String):void
        {
            var loc1:*=arg1;
            if (!_labelHash[loc1]) 
            {
                loc1 = "up";
            }
            if (this._state != loc1) 
            {
                this._state = loc1;
                gotoAndPlay(this._state);
            }
            return;
        }

        protected var _state:String;
    }
}
