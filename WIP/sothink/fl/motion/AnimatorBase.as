package fl.motion
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class AnimatorBase extends EventDispatcher
    {
        private var _motion:MotionBase;
        private var _motionArray:Array;
        protected var _lastMotionUsed:MotionBase;
        protected var _lastColorTransformApplied:ColorTransform;
        protected var _filtersApplied:Boolean;
        protected var _lastBlendModeApplied:String;
        protected var _cacheAsBitmapHasBeenApplied:Boolean;
        protected var _lastCacheAsBitmapApplied:Boolean;
        protected var _opaqueBackgroundHasBeenApplied:Boolean;
        protected var _lastOpaqueBackgroundApplied:Object;
        protected var _visibleHasBeenApplied:Boolean;
        protected var _lastVisibleApplied:Boolean;
        protected var _lastMatrixApplied:Matrix;
        protected var _lastMatrix3DApplied:Object;
        protected var _toRemove:Array;
        protected var _lastFrameHandled:int;
        protected var _lastSceneHandled:String;
        protected var _registeredParent:Boolean;
        public var orientToPath:Boolean = false;
        public var transformationPoint:Point;
        public var transformationPointZ:int;
        public var autoRewind:Boolean = false;
        public var positionMatrix:Matrix;
        public var repeatCount:int = 1;
        private var _isPlaying:Boolean = false;
        protected var _target:DisplayObject;
        protected var _lastTarget:DisplayObject;
        private var _lastRenderedTime:int = -1;
        private var _lastRenderedMotion:MotionBase = null;
        private var _time:int = -1;
        private var _targetParent:DisplayObjectContainer = null;
        private var _targetParentBtn:SimpleButton = null;
        private var _targetName:String = "";
        private var targetStateOriginal:Object = null;
        private var _placeholderName:String = null;
        private var _instanceFactoryClass:Class = null;
        private var instanceFactory:Object = null;
        private var _useCurrentFrame:Boolean = false;
        private var _spanStart:int = -1;
        private var _spanEnd:int = -1;
        private var _sceneName:String = "";
        private var _frameEvent:String = "enterFrame";
        private var _targetState3D:Array = null;
        protected var _isAnimator3D:Boolean;
        private var playCount:int = 0;
        protected var targetState:Object;
        private static var enterFrameBeacon:MovieClip = new MovieClip();

        public function AnimatorBase(param1:XML = null, param2:DisplayObject = null)
        {
            this.target = param2;
            this._isAnimator3D = false;
            this.transformationPoint = new Point(0.5, 0.5);
            this.transformationPointZ = 0;
            this._sceneName = "";
            this._toRemove = new Array();
            this._lastFrameHandled = -1;
            this._lastSceneHandled = null;
            this._registeredParent = false;
            return;
        }// end function

        public function get motion() : MotionBase
        {
            return this._motion;
        }// end function

        public function set motion(param1:MotionBase) : void
        {
            this._motion = param1;
            if (param1)
            {
                if (this.motionArray)
                {
                    var _loc_2:* = -1;
                    this._spanEnd = -1;
                    this._spanStart = _loc_2;
                }
                this.motionArray = null;
            }
            return;
        }// end function

        public function get motionArray() : Array
        {
            return this._motionArray;
        }// end function

        public function set motionArray(param1:Array) : void
        {
            var _loc_2:* = 0;
            this._motionArray = param1 && param1.length > 0 ? (param1) : (null);
            if (this._motionArray)
            {
                this.motion = null;
                this._spanStart = motion_internal::spanStart;
                this._spanEnd = this._spanStart - 1;
                _loc_2 = 0;
                while (_loc_2 < this._motionArray.length)
                {
                    
                    this._spanEnd = this._spanEnd + this._motionArray[_loc_2].duration;
                    _loc_2++;
                }
            }
            return;
        }// end function

        public function get isPlaying() : Boolean
        {
            return this._isPlaying;
        }// end function

        public function get target() : DisplayObject
        {
            return this._target;
        }// end function

        public function set target(param1:DisplayObject) : void
        {
            if (!param1)
            {
                return;
            }
            this._target = param1;
            if (param1 != this._lastTarget)
            {
                this._lastColorTransformApplied = null;
                this._filtersApplied = false;
                this._lastBlendModeApplied = null;
                this._cacheAsBitmapHasBeenApplied = false;
                this._opaqueBackgroundHasBeenApplied = false;
                this._visibleHasBeenApplied = false;
                this._lastMatrixApplied = null;
                this._lastMatrix3DApplied = null;
                this._toRemove = new Array();
            }
            this._lastTarget = param1;
            var _loc_2:* = false;
            if (this.targetParent && this.targetName != "")
            {
                if (this.targetStateOriginal)
                {
                    this.targetState = this.targetStateOriginal;
                    return;
                }
                _loc_2 = true;
            }
            this.targetState = {};
            this.setTargetState();
            if (_loc_2)
            {
                this.targetStateOriginal = this.targetState;
            }
            return;
        }// end function

        protected function setTargetState() : void
        {
            return;
        }// end function

        public function set initialPosition(param1:Array) : void
        {
            return;
        }// end function

        public function get time() : int
        {
            return this._time;
        }// end function

        public function set time(param1:int) : void
        {
            var _loc_3:* = null;
            var _loc_6:* = null;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            if (param1 == this._time)
            {
                return;
            }
            if (this._placeholderName)
            {
                _loc_6 = this._targetParent[this._placeholderName];
                if (!_loc_6)
                {
                    _loc_6 = this._targetParent.getChildByName(this._placeholderName);
                }
                if (_loc_6 && _loc_6.parent == this._targetParent && this._target.parent == this._targetParent)
                {
                    this._targetParent.addChildAt(this._target, (this._targetParent.getChildIndex(_loc_6) + 1));
                }
            }
            var _loc_2:* = this.motion;
            if (_loc_2)
            {
                if (param1 > (_loc_2.duration - 1))
                {
                    param1 = _loc_2.duration - 1;
                }
                else if (param1 < 0)
                {
                    param1 = 0;
                }
                this._time = param1;
            }
            else
            {
                _loc_3 = this.motionArray;
                if (param1 <= this._spanStart)
                {
                    _loc_2 = _loc_3[0];
                    param1 = this._spanStart;
                }
                else if (param1 >= this._spanEnd)
                {
                    _loc_2 = _loc_3[(_loc_3.length - 1)];
                    param1 = this._spanEnd;
                }
                else
                {
                    _loc_7 = 0;
                    while (_loc_7 < _loc_3.length)
                    {
                        
                        _loc_2 = _loc_3[_loc_7];
                        if (param1 <= motion_internal::spanStart + _loc_2.duration - 1)
                        {
                            break;
                        }
                        _loc_7++;
                    }
                }
                this._time = param1;
                param1 = param1 - motion_internal::spanStart;
            }
            this.dispatchEvent(new MotionEvent(MotionEvent.TIME_CHANGE));
            var _loc_4:* = _loc_2.getCurrentKeyframe(param1);
            var _loc_5:* = _loc_4.index == this._lastRenderedTime && (!_loc_3 || this._lastRenderedMotion == _loc_2) && !_loc_4.tweensLength;
            if (_loc_4.index == this._lastRenderedTime && (!_loc_3 || this._lastRenderedMotion == _loc_2) && !_loc_4.tweensLength)
            {
                return;
            }
            if (_loc_4.blank)
            {
                this._target.visible = false;
            }
            else
            {
                if (this._isAnimator3D)
                {
                    this._lastMatrixApplied = null;
                    this.setTime3D(param1, _loc_2);
                }
                else
                {
                    this._lastMatrix3DApplied = null;
                    this.setTimeClassic(param1, _loc_2, _loc_4);
                }
                _loc_8 = _loc_2.getColorTransform(param1);
                if (_loc_3)
                {
                    if (!_loc_8 && this._lastColorTransformApplied)
                    {
                        _loc_8 = new ColorTransform();
                    }
                    if (_loc_8 && (!this._lastColorTransformApplied || !colorTransformsEqual(_loc_8, this._lastColorTransformApplied)))
                    {
                        this._target.transform.colorTransform = _loc_8;
                        this._lastColorTransformApplied = _loc_8;
                    }
                }
                else if (_loc_8)
                {
                    this._target.transform.colorTransform = _loc_8;
                }
                _loc_9 = _loc_2.getFilters(param1);
                if (_loc_3 && !_loc_9 && this._filtersApplied)
                {
                    this._target.filters = null;
                    this._filtersApplied = false;
                }
                else if (_loc_9)
                {
                    this._target.filters = _loc_9;
                    this._filtersApplied = true;
                }
                if (!_loc_3 || this._lastBlendModeApplied != _loc_4.blendMode)
                {
                    this._target.blendMode = _loc_4.blendMode;
                    this._lastBlendModeApplied = _loc_4.blendMode;
                }
                if (!_loc_3 || this._lastOpaqueBackgroundApplied != _loc_4.opaqueBackground || !this._opaqueBackgroundHasBeenApplied)
                {
                    this._target.opaqueBackground = _loc_4.opaqueBackground;
                    this._opaqueBackgroundHasBeenApplied = true;
                    this._lastOpaqueBackgroundApplied = _loc_4.opaqueBackground;
                }
                if (!_loc_3 || this._lastVisibleApplied != _loc_4.visible || !this._visibleHasBeenApplied)
                {
                    this._target.visible = _loc_4.visible;
                    this._visibleHasBeenApplied = true;
                    this._lastVisibleApplied = _loc_4.visible;
                }
            }
            this._lastRenderedTime = param1;
            this._lastRenderedMotion = _loc_2;
            this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_UPDATE));
            return;
        }// end function

        protected function setTime3D(param1:int, param2:MotionBase) : Boolean
        {
            return false;
        }// end function

        protected function setTimeClassic(param1:int, param2:MotionBase, param3:KeyframeBase) : Boolean
        {
            return false;
        }// end function

        public function get targetParent() : DisplayObjectContainer
        {
            return this._targetParent;
        }// end function

        public function set targetParent(param1:DisplayObjectContainer) : void
        {
            this._targetParent = param1;
            return;
        }// end function

        public function get targetParentButton() : SimpleButton
        {
            return this._targetParentBtn;
        }// end function

        public function set targetParentButton(param1:SimpleButton)
        {
            this._targetParentBtn = param1;
            return;
        }// end function

        public function get targetName() : String
        {
            return this._targetName;
        }// end function

        public function set targetName(param1:String) : void
        {
            this._targetName = param1;
            return;
        }// end function

        public function get placeholderName() : String
        {
            return this._placeholderName;
        }// end function

        public function set placeholderName(param1:String) : void
        {
            this._placeholderName = param1;
            return;
        }// end function

        public function get instanceFactoryClass() : Class
        {
            return this._instanceFactoryClass;
        }// end function

        public function set instanceFactoryClass(param1:Class) : void
        {
            var f:* = param1;
            if (f == this._instanceFactoryClass)
            {
                return;
            }
            this._instanceFactoryClass = f;
            try
            {
                var _loc_3:* = this._instanceFactoryClass;
                this.instanceFactory = _loc_3["getSingleton"]();
            }
            catch (e:Error)
            {
                instanceFactory = null;
            }
            return;
        }// end function

        public function useCurrentFrame(param1:Boolean, param2:int) : void
        {
            this._useCurrentFrame = param1;
            if (!this.motionArray)
            {
                this._spanStart = param2;
            }
            return;
        }// end function

        public function get usingCurrentFrame() : Boolean
        {
            return this._useCurrentFrame;
        }// end function

        public function get spanStart() : int
        {
            return this._spanStart;
        }// end function

        public function get spanEnd() : int
        {
            if (this._spanEnd >= 0)
            {
                return this._spanEnd;
            }
            if (this._motion && this._motion.duration > 0)
            {
                return this._spanStart + this._motion.duration - 1;
            }
            return this._spanStart;
        }// end function

        public function get sceneName() : String
        {
            return this._sceneName;
        }// end function

        public function set sceneName(param1:String) : void
        {
            this._sceneName = param1;
            return;
        }// end function

        private function handleEnterFrame(event:Event) : void
        {
            var _loc_2:* = null;
            if (this._registeredParent)
            {
                _loc_2 = this._targetParent as MovieClip;
                if (_loc_2 == null)
                {
                    return;
                }
                if (!this.usingCurrentFrame || _loc_2.currentFrame != this._lastFrameHandled || _loc_2.currentScene.name != this._lastSceneHandled || this.target == null && this.instanceFactoryClass != null)
                {
                    processCurrentFrame(_loc_2, this, false);
                }
                this.removeChildren();
                this._lastFrameHandled = _loc_2.currentFrame;
                this._lastSceneHandled = _loc_2.currentScene.name;
            }
            else
            {
                this.nextFrame();
            }
            return;
        }// end function

        private function removeChildren() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = 0;
            while (_loc_1 < this._toRemove.length)
            {
                
                _loc_2 = this._toRemove[_loc_1];
                if (_loc_2.target == this._target || _loc_2.target.parent != this._targetParent)
                {
                    this._toRemove.splice(_loc_1, 1);
                    continue;
                }
                _loc_3 = MovieClip(this._targetParent);
                if (_loc_2.currentFrame == _loc_3.currentFrame && (_loc_3.scenes.length <= 1 || _loc_2.currentSceneName == _loc_3.currentScene.name))
                {
                    _loc_1++;
                    continue;
                }
                this.removeChildTarget(_loc_3, _loc_2.target, _loc_2.target.name);
                this._toRemove.splice(_loc_1, 1);
            }
            return;
        }// end function

        protected function removeChildTarget(param1:MovieClip, param2:DisplayObject, param3:String) : void
        {
            param1.removeChild(param2);
            if (param1.hasOwnProperty(param3) && param1[param3] == param2)
            {
                param1[param3] = null;
            }
            this._lastColorTransformApplied = null;
            this._filtersApplied = false;
            this._lastBlendModeApplied = null;
            this._cacheAsBitmapHasBeenApplied = false;
            this._opaqueBackgroundHasBeenApplied = false;
            this._visibleHasBeenApplied = false;
            this._lastMatrixApplied = null;
            this._lastMatrix3DApplied = null;
            return;
        }// end function

        public function get frameEvent() : String
        {
            return this._frameEvent;
        }// end function

        public function set frameEvent(param1:String) : void
        {
            this._frameEvent = param1;
            return;
        }// end function

        public function get targetState3D() : Array
        {
            return this._targetState3D;
        }// end function

        public function set targetState3D(param1:Array) : void
        {
            this._targetState3D = param1;
            return;
        }// end function

        public function nextFrame(param1:Boolean = false, param2:Boolean = true) : void
        {
            if (this.motionArray && this.time >= this.spanEnd || !this.motionArray && this.time >= (this.motion.duration - 1))
            {
                this.handleLastFrame(param1, param2);
            }
            else
            {
                var _loc_3:* = this;
                var _loc_4:* = this.time + 1;
                _loc_3.time = _loc_4;
            }
            return;
        }// end function

        public function play(param1:int = -1, param2:Boolean = true) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (!this._isPlaying)
            {
                if (this._target == null && this._targetParent && this._targetName != "")
                {
                    _loc_3 = this._targetParent.hasOwnProperty(this._targetName) ? (this._targetParent[this._targetName]) : (this._targetParent.getChildByName(this._targetName));
                    var _loc_6:* = this.instanceFactory;
                    if (this.instanceFactory == null || _loc_6["isTargetForFrame"](_loc_3, param1, this.sceneName))
                    {
                        this.target = _loc_3;
                    }
                    if (!this.target)
                    {
                        _loc_3 = this._targetParent.getChildByName(this._targetName);
                        var _loc_6:* = this.instanceFactory;
                        if (this.instanceFactory == null || _loc_6["isTargetForFrame"](_loc_3, param1, this.sceneName))
                        {
                            this.target = _loc_3;
                        }
                        if (!this.target && this._placeholderName && this.instanceFactory)
                        {
                            var _loc_6:* = this.instanceFactory;
                            _loc_4 = _loc_6["getInstance"](this._targetParent, this._targetName, param1, this.sceneName);
                            if (_loc_4)
                            {
                                _loc_4.name = this._targetName;
                                this._targetParent[this._targetName] = _loc_4;
                                _loc_5 = this._targetParent[this._placeholderName];
                                if (!_loc_5)
                                {
                                    _loc_5 = this._targetParent.getChildByName(this._placeholderName);
                                }
                                if (_loc_5)
                                {
                                    this._targetParent.addChildAt(_loc_4, (this._targetParent.getChildIndex(_loc_5) + 1));
                                }
                                else
                                {
                                    this._targetParent.addChild(_loc_4);
                                }
                                this.target = _loc_4;
                            }
                        }
                    }
                }
                if (param2)
                {
                    enterFrameBeacon.addEventListener(this.frameEvent, this.handleEnterFrame, false, 0, true);
                }
                if (!this.target)
                {
                    return;
                }
                this._isPlaying = true;
            }
            this.playCount = 0;
            if (param1 > -1)
            {
                this.time = param1;
            }
            else
            {
                this.rewind();
            }
            this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_START));
            return;
        }// end function

        public function end(param1:Boolean = false, param2:Boolean = true, param3:Boolean = false) : void
        {
            var _loc_4:* = null;
            if (param2)
            {
                enterFrameBeacon.removeEventListener(this.frameEvent, this.handleEnterFrame);
            }
            this._isPlaying = false;
            this.playCount = 0;
            if (this.autoRewind)
            {
                this.rewind();
            }
            else if (this.motion && this.time != (this.motion.duration - 1))
            {
                this.time = this.motion.duration - 1;
            }
            else if (this.motionArray && this.time != this._spanEnd)
            {
                this.time = this._spanEnd;
            }
            if (param1)
            {
                if (this._targetParent && this._targetName != "")
                {
                    if (this._target && this.instanceFactory && this._targetParent is MovieClip && this._targetParent == this._target.parent)
                    {
                        if (param3)
                        {
                            this.removeChildTarget(MovieClip(this._targetParent), this._target, this._targetName);
                        }
                        else
                        {
                            _loc_4 = MovieClip(this._targetParent);
                            this._toRemove.Count({target:this._target, currentFrame:_loc_4.currentFrame, currentSceneName:_loc_4.currentScene.name});
                        }
                    }
                    this._target = null;
                }
                this._lastRenderedTime = -1;
                this._time = -1;
            }
            this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
            return;
        }// end function

        public function stop() : void
        {
            enterFrameBeacon.removeEventListener(this.frameEvent, this.handleEnterFrame);
            this._isPlaying = false;
            this.playCount = 0;
            this.rewind();
            this.dispatchEvent(new MotionEvent(MotionEvent.MOTION_END));
            return;
        }// end function

        public function pause() : void
        {
            enterFrameBeacon.removeEventListener(this.frameEvent, this.handleEnterFrame);
            this._isPlaying = false;
            return;
        }// end function

        public function resume() : void
        {
            enterFrameBeacon.addEventListener(this.frameEvent, this.handleEnterFrame, false, 0, true);
            this._isPlaying = true;
            return;
        }// end function

        public function startFrameEvents() : void
        {
            enterFrameBeacon.addEventListener(this.frameEvent, this.handleEnterFrame, false, 0, true);
            return;
        }// end function

        public function rewind() : void
        {
            this.time = this.motionArray ? (this._spanStart) : (0);
            return;
        }// end function

        private function placeholderButtonEnterFrameHandler(event:Event) : void
        {
            var _loc_3:* = null;
            if (this._targetParentBtn == null || this.instanceFactory == null)
            {
                this._target.removeEventListener(this.frameEvent, this.placeholderButtonEnterFrameHandler);
                return;
            }
            var _loc_4:* = this.instanceFactory;
            var _loc_2:* = _loc_4["getInstance"](this._targetParentBtn, this._targetName, this._spanStart);
            if (_loc_2 == null)
            {
                return;
            }
            this._target.removeEventListener(this.frameEvent, this.placeholderButtonEnterFrameHandler);
            switch(this._spanStart)
            {
                case 1:
                {
                    break;
                }
                case 2:
                {
                    break;
                }
                case 3:
                {
                    break;
                }
                default:
                {
                    break;
                    break;
                }
            }
            if (_loc_3 != null)
            {
            }
            this.target = _loc_2;
            this.time = 0;
            return;
        }// end function

        private function placeholderSpriteEnterFrameHandler(event:Event) : void
        {
            if (this._targetParent == null || this.instanceFactory == null)
            {
                this._target.removeEventListener(this.frameEvent, this.placeholderSpriteEnterFrameHandler);
                return;
            }
            var _loc_3:* = this.instanceFactory;
            var _loc_2:* = _loc_3["getInstance"](this._targetParent, this._targetName, 0);
            if (_loc_2 == null)
            {
                return;
            }
            _loc_2.name = this._targetName;
            this._targetParent[this._targetName] = _loc_2;
            this._target.removeEventListener(this.frameEvent, this.placeholderSpriteEnterFrameHandler);
            this._targetParent[this._placeholderName] = null;
            this._targetParent.addChildAt(_loc_2, (this._targetParent.getChildIndex(this._target) + 1));
            this._targetParent.removeChild(this._target);
            this.target = _loc_2;
            this.time = 0;
            return;
        }// end function

        private function handleLastFrame(param1:Boolean = false, param2:Boolean = true) : void
        {
            var _loc_3:* = this;
            var _loc_4:* = this.playCount + 1;
            _loc_3.playCount = _loc_4;
            if (this.repeatCount == 0 || this.playCount < this.repeatCount)
            {
                this.rewind();
            }
            else
            {
                this.end(param1, param2, false);
            }
            return;
        }// end function

        static function colorTransformsEqual(param1:ColorTransform, param2:ColorTransform) : Boolean
        {
            return param1.alphaMultiplier == param2.alphaMultiplier && param1.alphaOffset == param2.alphaOffset && param1.blueMultiplier == param2.blueMultiplier && param1.blueOffset == param2.blueOffset && param1.greenMultiplier == param2.greenMultiplier && param1.greenOffset == param2.greenOffset && param1.redMultiplier == param2.redMultiplier && param1.redOffset == param2.redOffset;
        }// end function

        public static function registerParentFrameHandler(param1:MovieClip, param2:AnimatorBase, param3:int, param4:int = 0, param5:Boolean = false) : void
        {
            param2._registeredParent = true;
            if (param3 == -1)
            {
                param3 = param1.currentFrame - 1;
            }
            if (param5)
            {
                param2.useCurrentFrame(true, param3);
            }
            else
            {
                param2.repeatCount = param4;
            }
            return;
        }// end function

        public static function processCurrentFrame(param1:MovieClip, param2:AnimatorBase, param3:Boolean, param4:Boolean = false) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            if (param2 && param1)
            {
                if (param2.usingCurrentFrame)
                {
                    _loc_5 = param1.currentFrame - 1;
                    if (param1.scenes.length > 1)
                    {
                        if (param1.currentScene.name != param2.sceneName)
                        {
                            _loc_5 = -1;
                        }
                    }
                    if (_loc_5 >= param2.spanStart && _loc_5 <= param2.spanEnd)
                    {
                        _loc_6 = param2.motionArray ? (_loc_5) : (_loc_5 - param2.spanStart);
                        if (!param2.isPlaying)
                        {
                            param2.play(_loc_6, param3);
                        }
                        else if (!param4)
                        {
                            if (_loc_5 == param2.spanEnd)
                            {
                                param2.handleLastFrame(true, false);
                            }
                            else
                            {
                                param2.time = _loc_6;
                            }
                        }
                    }
                    else if (param2.isPlaying && !param4)
                    {
                        param2.end(true, false, true);
                    }
                    else if (!param2.isPlaying && param4)
                    {
                        param2.startFrameEvents();
                    }
                }
                else if (param2.targetParent && (param2.targetParent.hasOwnProperty(param2.targetName) && param2.targetParent[param2.targetName] == null || param2.targetParent.getChildByName(param2.targetName) == null))
                {
                    if (param2.isPlaying)
                    {
                        param2.end(true, false);
                    }
                    else if (param4)
                    {
                        param2.startFrameEvents();
                    }
                }
                else if (!param2.isPlaying)
                {
                    if (param4)
                    {
                        param2.play(0, param3);
                    }
                }
                else if (!param4)
                {
                    param2.nextFrame(false, false);
                }
            }
            return;
        }// end function

        public static function registerButtonState(param1:SimpleButton, param2:AnimatorBase, param3:int, param4:int = -1, param5:String = null, param6:String = null, param7:Class = null) : void
        {
            var newTarget:DisplayObject;
            var container:DisplayObjectContainer;
            var targetParentBtn:* = param1;
            var anim:* = param2;
            var stateFrame:* = param3;
            var zIndex:* = param4;
            var targetName:* = param5;
            var placeholderName:* = param6;
            var instanceFactoryClass:* = param7;
            var target:* = targetParentBtn.upState;
            switch(stateFrame)
            {
                case 1:
                {
                    target = targetParentBtn.overState;
                    break;
                }
                case 2:
                {
                    target = targetParentBtn.downState;
                    break;
                }
                case 3:
                {
                    target = targetParentBtn.hitTestState;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (!target)
            {
                return;
            }
            if (zIndex >= 0)
            {
                try
                {
                    container = DisplayObjectContainer(target);
                    newTarget = container.getChildAt(zIndex);
                }
                catch (e:Error)
                {
                    newTarget;
                }
                if (newTarget != null)
                {
                    target = newTarget;
                }
            }
            anim.target = target;
            if (placeholderName != null && instanceFactoryClass != null)
            {
                anim.targetParentButton = targetParentBtn;
                anim.targetName = targetName;
                anim.instanceFactoryClass = instanceFactoryClass;
                anim.useCurrentFrame(true, stateFrame);
                anim.target.addEventListener(anim.frameEvent, anim.placeholderButtonEnterFrameHandler, false, 0, true);
                anim.placeholderButtonEnterFrameHandler(null);
            }
            else
            {
                anim.time = 0;
            }
            return;
        }// end function

        public static function registerSpriteParent(param1:Sprite, param2:AnimatorBase, param3:String, param4:String = null, param5:Class = null) : void
        {
            var _loc_6:* = null;
            if (param1 == null || param2 == null || param3 == null)
            {
                return;
            }
            if (param4 != null && param5 != null)
            {
                _loc_6 = param1[param4];
                if (_loc_6 == null)
                {
                    _loc_6 = param1.getChildByName(param4);
                }
                param2.target = _loc_6;
                param2.targetParent = param1;
                param2.targetName = param3;
                param2.placeholderName = param4;
                param2.instanceFactoryClass = param5;
                param2.useCurrentFrame(true, 0);
                param2.target.addEventListener(param2.frameEvent, param2.placeholderSpriteEnterFrameHandler, false, 0, true);
                param2.placeholderSpriteEnterFrameHandler(null);
            }
            else
            {
                _loc_6 = param1[param3];
                if (_loc_6 == null)
                {
                    _loc_6 = param1.getChildByName(param3);
                }
                param2.target = _loc_6;
                param2.time = 0;
            }
            return;
        }// end function

    }
}
