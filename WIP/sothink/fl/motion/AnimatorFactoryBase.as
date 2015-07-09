package fl.motion
{
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class AnimatorFactoryBase extends Object
    {
        private var _motion:MotionBase;
        private var _motionArray:Array;
        private var _animators:Dictionary;
        protected var _transformationPoint:Point;
        protected var _transformationPointZ:int;
        protected var _is3D:Boolean;
        protected var _sceneName:String;

        public function AnimatorFactoryBase(param1:MotionBase, param2:Array = null)
        {
            this._motion = param1;
            this._motionArray = param2;
            this._animators = new Dictionary(true);
            this._transformationPoint = new Point(0.5, 0.5);
            this._transformationPointZ = 0;
            this._is3D = false;
            this._sceneName = "";
            return;
        }// end function

        public function get motion() : MotionBase
        {
            return this._motion;
        }// end function

        public function addTarget(param1:DisplayObject, param2:int = 0, param3:Boolean = true, param4:int = -1, param5:Boolean = false) : AnimatorBase
        {
            if (param1)
            {
                return this.addTargetInfo(param1.parent, param1.name, param2, param3, param4, param5);
            }
            return null;
        }// end function

        protected function getNewAnimator() : AnimatorBase
        {
            return null;
        }// end function

        public function addTargetInfo(param1:DisplayObject, param2:String, param3:int = 0, param4:Boolean = true, param5:int = -1, param6:Boolean = false, param7:Array = null, param8:int = -1, param9:String = null, param10:Class = null) : AnimatorBase
        {
            var _loc_14:* = null;
            if (!(param1 is DisplayObjectContainer) && !(param1 is SimpleButton))
            {
                return null;
            }
            var _loc_11:* = this._animators[param1];
            if (!this._animators[param1])
            {
                _loc_11 = new Dictionary();
                this._animators[param1] = _loc_11;
            }
            var _loc_12:* = _loc_11[param2];
            var _loc_13:* = false;
            if (!_loc_12)
            {
                _loc_12 = this.getNewAnimator();
                _loc_14 = getDefinitionByName("flash.events.Event") as Class;
                if (_loc_14.hasOwnProperty("FRAME_CONSTRUCTED"))
                {
                    _loc_12.frameEvent = "frameConstructed";
                }
                _loc_11[param2] = _loc_12;
                _loc_13 = true;
            }
            _loc_12.motion = this._motion;
            _loc_12.motionArray = this._motionArray;
            _loc_12.transformationPoint = this._transformationPoint;
            _loc_12.transformationPointZ = this._transformationPointZ;
            _loc_12.sceneName = this._sceneName;
            if (_loc_13)
            {
                if (param1 is MovieClip)
                {
                    AnimatorBase.registerParentFrameHandler(param1 as MovieClip, _loc_12, param5, param3, param6);
                }
            }
            if (param1 is MovieClip)
            {
                _loc_12.targetParent = MovieClip(param1);
                _loc_12.targetName = param2;
                _loc_12.placeholderName = param9;
                _loc_12.instanceFactoryClass = param10;
            }
            else if (param1 is SimpleButton)
            {
                AnimatorBase.registerButtonState(param1 as SimpleButton, _loc_12, param5, param8, param2, param9, param10);
            }
            else if (param1 is Sprite)
            {
                AnimatorBase.registerSpriteParent(param1 as Sprite, _loc_12, param2, param9, param10);
            }
            if (param7)
            {
                _loc_12.initialPosition = param7;
            }
            if (param4)
            {
                AnimatorBase.processCurrentFrame(param1 as MovieClip, _loc_12, true, true);
            }
            return _loc_12;
        }// end function

        public function set transformationPoint(param1:Point) : void
        {
            this._transformationPoint = param1;
            return;
        }// end function

        public function set transformationPointZ(param1:int) : void
        {
            this._transformationPointZ = param1;
            return;
        }// end function

        public function set sceneName(param1:String) : void
        {
            this._sceneName = param1;
            return;
        }// end function

    }
}
