package red.game.witcher3.controls
{
    import scaleform.clik.core.*;

    public class KeyboardButtonClickArea extends UIComponent
    {
        protected var _state:String;

        public function KeyboardButtonClickArea()
        {
            return;
        }// end function

        public function get state() : String
        {
            return this._state;
        }// end function

        public function set state(param1:String) : void
        {
            var _loc_2:* = param1;
            if (!_labelHash[_loc_2])
            {
                _loc_2 = "up";
            }
            if (this._state != _loc_2)
            {
                this._state = _loc_2;
                gotoAndPlay(this._state);
            }
            return;
        }// end function

    }
}
