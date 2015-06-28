package red.game.witcher3.menus.gwint 
{
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;
    
    public class CardTweenManager extends flash.events.EventDispatcher
    {
        public function CardTweenManager()
        {
            this._cardTweens = new flash.utils.Dictionary(true);
            this._cardPositions = new flash.utils.Dictionary(true);
            super();
            return;
        }

        public function tweenTo(arg1:red.game.witcher3.menus.gwint.CardSlot, arg2:Number, arg3:Number, arg4:Function=null):com.gskinner.motion.GTween
        {
            var loc1:*=null;
            if (!arg1) 
            {
                trace("GFX [WARNING] <CardTweenManager.tweenTo> card is undefined");
                return null;
            }
            this.tryStopCardTween(arg1, false);
            if (arg2 == arg1.x && arg3 == arg1.y) 
            {
                return null;
            }
            var loc2:*=this.calcTweenDuration(arg1.x, arg1.y, arg2, arg3);
            var loc3:*={};
            if (arg4 != null) 
            {
                loc3.onComplete = arg4;
            }
            loc3.ease = com.gskinner.motion.easing.Sine.easeInOut;
            loc1 = new com.gskinner.motion.GTween(arg1, loc2, {"x":arg2, "y":arg3}, loc3);
            this._cardTweens[arg1] = loc1;
            return loc1;
        }

        public function flipTo(arg1:red.game.witcher3.menus.gwint.CardSlot, arg2:String, arg3:Number=NaN, arg4:Number=NaN, arg5:Function=null):com.gskinner.motion.GTween
        {
            var loc1:*=false;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            var loc6:*=NaN;
            var loc7:*=null;
            var loc10:*=null;
            var loc13:*=null;
            if (!arg1) 
            {
                trace("GFX [WARNING] <CardTweenManager.flipTo> card is undefined");
                return null;
            }
            this.tryStopCardTween(arg1, false);
            if (!isNaN(arg3) && !isNaN(arg4)) 
            {
                loc1 = true;
                loc2 = new flash.geom.Point(arg1.x, arg1.y);
                loc5 = new flash.geom.Point(arg3, arg4);
                loc4 = new flash.geom.Point((loc2.x + loc5.x) / 2, (loc2.y + loc5.y) / 2);
                loc3 = new flash.geom.Point((loc2.x + loc4.x) / 2, (loc2.y + loc4.y) / 2);
            }
            loc6 = this.calcTweenDuration(arg1.x, arg1.y, arg3, arg4);
            var loc8:*={};
            var loc9:*={};
            if (loc1) 
            {
                loc8.x = loc3.x;
                loc8.y = loc3.y;
            }
            loc8.rotationY = 90;
            loc9.data = arg2;
            loc9.onComplete = this.onStartFlipComplete;
            loc7 = new com.gskinner.motion.GTween(arg1, loc6 / 3, loc8, loc9);
            var loc11:*={};
            var loc12:*={};
            if (loc1) 
            {
                loc11.x = loc4.x;
                loc11.y = loc4.y;
            }
            loc11.rotationY = 0;
            loc10 = new com.gskinner.motion.GTween(arg1, loc6 / 3, loc11, loc12);
            loc10.paused = true;
            loc7.nextTween = loc10;
            var loc14:*={};
            var loc15:*={};
            if (loc1) 
            {
                loc14.x = loc5.x;
                loc14.y = loc5.y;
            }
            loc15.onComplete = arg5;
            loc13 = new com.gskinner.motion.GTween(arg1, loc6 / 3, loc14, loc15);
            loc13.paused = true;
            loc10.nextTween = loc13;
            return null;
        }

        public function onStartFlipComplete(arg1:com.gskinner.motion.GTween):void
        {
            var loc1:*=arg1.target as red.game.witcher3.menus.gwint.CardSlot;
            if (loc1) 
            {
                loc1.cardState = arg1.data as String;
                loc1.rotationY = -90;
            }
            return;
        }

        public function flip(arg1:red.game.witcher3.menus.gwint.CardSlot, arg2:String):void
        {
            arg1.cardState = arg2;
            return;
        }

        public function getPosition(arg1:red.game.witcher3.menus.gwint.CardSlot):flash.geom.Point
        {
            return this._cardPositions[arg1];
        }

        public function setPosition(arg1:red.game.witcher3.menus.gwint.CardSlot, arg2:Number, arg3:Number):void
        {
            this._cardPositions[arg1] = new flash.geom.Point(arg2, arg3);
            arg1.x = arg2;
            arg1.y = arg3;
            return;
        }

        public function storePosition(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            this._cardPositions[arg1] = new flash.geom.Point(arg1.x, arg1.y);
            return;
        }

        public function restorePosition(arg1:red.game.witcher3.menus.gwint.CardSlot, arg2:Boolean=false):Boolean
        {
            var loc1:*=this._cardPositions[arg1];
            if (loc1) 
            {
                if (arg2) 
                {
                    this.tweenTo(arg1, loc1.x, loc1.y);
                }
                else 
                {
                    arg1.x = loc1.x;
                    arg1.y = loc1.y;
                }
                return true;
            }
            return false;
        }

        public function isCardMoving(arg1:red.game.witcher3.menus.gwint.CardSlot):Boolean
        {
            return this._cardTweens[arg1];
        }

        public function isAnyCardMoving():Boolean
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc3:*=this._cardTweens;
            for each (loc1 in loc3) 
            {
                if (!(loc1 && !loc1.paused)) 
                {
                    continue;
                }
                return true;
            }
            return false;
        }

        private function calcTweenDuration(arg1:Number, arg2:Number, arg3:Number, arg4:Number):Number
        {
            var loc1:*=NaN;
            if (isNaN(arg1) || isNaN(arg2) || isNaN(arg3) || isNaN(arg4)) 
            {
                return DEFAULT_TWEEN_DURATION;
            }
            loc1 = flash.geom.Point.distance(new flash.geom.Point(arg1, arg2), new flash.geom.Point(arg3, arg4));
            return loc1 / MOVE_TWEEN_SPEED;
        }

        private function getCardTween(arg1:red.game.witcher3.menus.gwint.CardSlot):com.gskinner.motion.GTween
        {
            return this._cardTweens[arg1] as com.gskinner.motion.GTween;
        }

        private function getCardDefaultPosition(arg1:red.game.witcher3.menus.gwint.CardSlot):flash.geom.Point
        {
            return this._cardPositions[arg1] as flash.geom.Point;
        }

        private function tryStopCardTween(arg1:red.game.witcher3.menus.gwint.CardSlot, arg2:Boolean=true):Boolean
        {
            var loc1:*=this.getCardTween(arg1);
            if (loc1) 
            {
                if (!(loc1.onComplete == null) && arg2) 
                {
                    loc1.onComplete(loc1);
                }
                loc1.paused = true;
                loc1 = null;
                return true;
            }
            return false;
        }

        public static function getInstance():red.game.witcher3.menus.gwint.CardTweenManager
        {
            if (!_instance) 
            {
                _instance = new CardTweenManager();
            }
            return _instance;
        }

        protected static const FLIP_TIMELAPSE_DURATION:Number=0.5;

        protected static const FLIP_TIMELAPSE_SCALE:Number=1.4;

        protected static const FLIP_MIN_SCALE:Number=0.001;

        protected static const FLIP_SCALE:Number=1.2;

        protected static const DEFAULT_TWEEN_DURATION:Number=1;

        protected static const MOVE_TWEEN_SPEED:Number=2000;

        protected var _cardTweens:flash.utils.Dictionary;

        protected var _cardPositions:flash.utils.Dictionary;

        protected static var _instance:red.game.witcher3.menus.gwint.CardTweenManager;
    }
}
