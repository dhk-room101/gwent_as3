package red.game.witcher3.menus.gwint
{
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class CardTweenManager extends EventDispatcher
    {
        protected var _cardTweens:Dictionary;
        protected var _cardPositions:Dictionary;
        static const FLIP_TIMELAPSE_DURATION:Number = 0.5;
        static const FLIP_TIMELAPSE_SCALE:Number = 1.4;
        static const FLIP_MIN_SCALE:Number = 0.001;
        static const FLIP_SCALE:Number = 1.2;
        static const DEFAULT_TWEEN_DURATION:Number = 1;
        static const MOVE_TWEEN_SPEED:Number = 2000;
        static var _instance:CardTweenManager;

        public function CardTweenManager()
        {
            this._cardTweens = new Dictionary(true);
            this._cardPositions = new Dictionary(true);
            return;
        }// end function

        public function tweenTo(param1:CardSlot, param2:Number, param3:Number, param4:Function = null) : GTween
        {
            var _loc_5:* = null;
            if (!param1)
            {
                Console.WriteLine("GFX [WARNING] <CardTweenManager.tweenTo> card is undefined");
                return null;
            }
            this.tryStopCardTween(param1, false);
            if (param2 == param1.x && param3 == param1.y)
            {
                return null;
            }
            var _loc_6:* = this.calcTweenDuration(param1.x, param1.y, param2, param3);
            var _loc_7:* = {};
            if (param4 != null)
            {
                _loc_7.onComplete = param4;
            }
            _loc_7.ease = Sine.easeInOut;
            _loc_5 = new GTween(param1, _loc_6, {x:param2, y:param3}, _loc_7);
            this._cardTweens[param1] = _loc_5;
            return _loc_5;
        }// end function

        public function flipTo(param1:CardSlot, param2:String, param3:Number = NaN, param4:Number = NaN, param5:Function = null) : GTween
        {
            var _loc_6:* = false;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = NaN;
            var _loc_12:* = null;
            var _loc_15:* = null;
            var _loc_18:* = null;
            if (!param1)
            {
                Console.WriteLine("GFX [WARNING] <CardTweenManager.flipTo> card is undefined");
                return null;
            }
            this.tryStopCardTween(param1, false);
            if (!isNaN(param3) && !isNaN(param4))
            {
                _loc_6 = true;
                _loc_7 = new Point(param1.x, param1.y);
                _loc_10 = new Point(param3, param4);
                _loc_9 = new Point((_loc_7.x + _loc_10.x) / 2, (_loc_7.y + _loc_10.y) / 2);
                _loc_8 = new Point((_loc_7.x + _loc_9.x) / 2, (_loc_7.y + _loc_9.y) / 2);
            }
            _loc_11 = this.calcTweenDuration(param1.x, param1.y, param3, param4);
            var _loc_13:* = {};
            var _loc_14:* = {};
            if (_loc_6)
            {
                _loc_13.x = _loc_8.x;
                _loc_13.y = _loc_8.y;
            }
            _loc_13.rotationY = 90;
            _loc_14.data = param2;
            _loc_14.onComplete = this.onStartFlipComplete;
            _loc_12 = new GTween(param1, _loc_11 / 3, _loc_13, _loc_14);
            var _loc_16:* = {};
            var _loc_17:* = {};
            if (_loc_6)
            {
                _loc_16.x = _loc_9.x;
                _loc_16.y = _loc_9.y;
            }
            _loc_16.rotationY = 0;
            _loc_15 = new GTween(param1, _loc_11 / 3, _loc_16, _loc_17);
            _loc_15.paused = true;
            _loc_12.nextTween = _loc_15;
            var _loc_19:* = {};
            var _loc_20:* = {};
            if (_loc_6)
            {
                _loc_19.x = _loc_10.x;
                _loc_19.y = _loc_10.y;
            }
            _loc_20.onComplete = param5;
            _loc_18 = new GTween(param1, _loc_11 / 3, _loc_19, _loc_20);
            _loc_18.paused = true;
            _loc_15.nextTween = _loc_18;
            return null;
        }// end function

        public function onStartFlipComplete(param1:GTween) : void
        {
            var _loc_2:* = param1.target as CardSlot;
            if (_loc_2)
            {
                _loc_2.cardState = param1.data as String;
                _loc_2.rotationY = -90;
            }
            return;
        }// end function

        public function flip(param1:CardSlot, param2:String) : void
        {
            param1.cardState = param2;
            return;
        }// end function

        public function getPosition(param1:CardSlot) : Point
        {
            return this._cardPositions[param1];
        }// end function

        public function setPosition(param1:CardSlot, param2:Number, param3:Number) : void
        {
            this._cardPositions[param1] = new Point(param2, param3);
            param1.x = param2;
            param1.y = param3;
            return;
        }// end function

        public function storePosition(param1:CardSlot) : void
        {
            this._cardPositions[param1] = new Point(param1.x, param1.y);
            return;
        }// end function

        public function restorePosition(param1:CardSlot, param2:Boolean = false) : Boolean
        {
            var _loc_3:* = this._cardPositions[param1];
            if (_loc_3)
            {
                if (param2)
                {
                    this.tweenTo(param1, _loc_3.x, _loc_3.y);
                }
                else
                {
                    param1.x = _loc_3.x;
                    param1.y = _loc_3.y;
                }
                return true;
            }
            return false;
        }// end function

        public function isCardMoving(param1:CardSlot) : Boolean
        {
            return this._cardTweens[param1];
        }// end function

        public function isAnyCardMoving() : Boolean
        {
            var _loc_1:* = null;
            for each (_loc_1 in this._cardTweens)
            {
                
                if (_loc_1 && !_loc_1.paused)
                {
                    return true;
                }
            }
            return false;
        }// end function

        private function calcTweenDuration(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            var _loc_5:* = NaN;
            if (isNaN(param1) || isNaN(param2) || isNaN(param3) || isNaN(param4))
            {
                return DEFAULT_TWEEN_DURATION;
            }
            _loc_5 = Point.distance(new Point(param1, param2), new Point(param3, param4));
            return _loc_5 / MOVE_TWEEN_SPEED;
        }// end function

        private function getCardTween(param1:CardSlot) : GTween
        {
            return this._cardTweens[param1] as GTween;
        }// end function

        private function getCardDefaultPosition(param1:CardSlot) : Point
        {
            return this._cardPositions[param1] as Point;
        }// end function

        private function tryStopCardTween(param1:CardSlot, param2:Boolean = true) : Boolean
        {
            var _loc_3:* = this.getCardTween(param1);
            if (_loc_3)
            {
                if (_loc_3.onComplete != null && param2)
                {
                    _loc_3.onComplete(_loc_3);
                }
                _loc_3.paused = true;
                _loc_3 = null;
                return true;
            }
            return false;
        }// end function

        public static function getInstance() : CardTweenManager
        {
            if (!_instance)
            {
                _instance = new CardTweenManager;
            }
            return _instance;
        }// end function

    }
}
