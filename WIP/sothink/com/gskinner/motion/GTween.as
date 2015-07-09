package com.gskinner.motion
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class GTween extends EventDispatcher
    {
        protected var _delay:Number = 0;
        protected var _values:Object;
        protected var _paused:Boolean = true;
        protected var _position:Number;
        protected var _inited:Boolean;
        protected var _initValues:Object;
        protected var _rangeValues:Object;
        protected var _proxy:TargetProxy;
        public var autoPlay:Boolean = true;
        public var data:Object;
        public var duration:Number;
        public var ease:Function;
        public var nextTween:GTween;
        public var pluginData:Object;
        public var reflect:Boolean;
        public var repeatCount:int = 1;
        public var target:Object;
        public var useFrames:Boolean;
        public var timeScale:Number = 1;
        public var positionOld:Number;
        public var ratio:Number;
        public var ratioOld:Number;
        public var calculatedPosition:Number;
        public var calculatedPositionOld:Number;
        public var suppressEvents:Boolean;
        public var dispatchEvents:Boolean;
        public var onComplete:Function;
        public var onChange:Function;
        public var onInit:Function;
        public static var version:Number = 2.01;
        public static var defaultDispatchEvents:Boolean = false;
        public static var defaultEase:Function = linearEase;
        public static var pauseAll:Boolean = false;
        public static var timeScaleAll:Number = 1;
        static var hasStarPlugins:Boolean = false;
        static var plugins:Object = {};
        static var shape:Shape;
        static var time:Number;
        static var tickList:Dictionary = new Dictionary(true);
        static var gcLockList:Dictionary = new Dictionary(false);

        public function GTween(param1:Object = null, param2:Number = 1, param3:Object = null, param4:Object = null, param5:Object = null)
        {
            var _loc_6:* = false;
            this.ease = defaultEase;
            this.dispatchEvents = defaultDispatchEvents;
            this.target = param1;
            this.duration = param2;
            this.pluginData = this.copy(param5, {});
            if (param4)
            {
                _loc_6 = param4.swapValues;
                delete param4.swapValues;
            }
            this.copy(param4, this);
            this.resetValues(param3);
            if (_loc_6)
            {
                this.swapValues();
            }
            if (this.duration == 0 && this.delay == 0 && this.autoPlay)
            {
                this.position = 0;
            }
            return;
        }// end function

        public function get paused() : Boolean
        {
            return this._paused;
        }// end function

        public function set paused(param1:Boolean) : void
        {
            if (param1 == this._paused)
            {
                return;
            }
            this._paused = param1;
            if (this._paused)
            {
                delete tickList[this];
                if (this.target is IEventDispatcher)
                {
                    this.target.removeEventListener("_", this.invalidate);
                }
                delete gcLockList[this];
            }
            else
            {
                if (isNaN(this._position) || this.repeatCount != 0 && this._position >= this.repeatCount * this.duration)
                {
                    this._inited = false;
                    var _loc_2:* = 0;
                    this.positionOld = 0;
                    this.ratioOld = _loc_2;
                    this.ratio = _loc_2;
                    this.calculatedPositionOld = _loc_2;
                    this.calculatedPosition = _loc_2;
                    this._position = -this.delay;
                }
                tickList[this] = true;
                if (this.target is IEventDispatcher)
                {
                    this.target.addEventListener("_", this.invalidate);
                }
                else
                {
                    gcLockList[this] = true;
                }
            }
            return;
        }// end function

        public function get position() : Number
        {
            return this._position;
        }// end function

        public function set position(param1:Number) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            this.positionOld = this._position;
            this.ratioOld = this.ratio;
            this.calculatedPositionOld = this.calculatedPosition;
            var _loc_2:* = this.repeatCount * this.duration;
            var _loc_3:* = param1 >= _loc_2 && this.repeatCount > 0;
            if (_loc_3)
            {
                if (this.calculatedPositionOld == _loc_2)
                {
                    return;
                }
                this._position = _loc_2;
                this.calculatedPosition = this.reflect && !(this.repeatCount & 1) ? (0) : (this.duration);
            }
            else
            {
                this._position = param1;
                this.calculatedPosition = this._position < 0 ? (0) : (this._position % this.duration);
                if (this.reflect && this._position / this.duration & 1)
                {
                    this.calculatedPosition = this.duration - this.calculatedPosition;
                }
            }
            this.ratio = this.duration == 0 && this._position >= 0 ? (1) : (this.ease(this.calculatedPosition / this.duration, 0, 1, 1));
            if (this.target && (this._position >= 0 || this.positionOld >= 0) && this.calculatedPosition != this.calculatedPositionOld)
            {
                if (!this._inited)
                {
                    this.init();
                }
                for (_loc_4 in this._values)
                {
                    
                    _loc_5 = this._initValues[_loc_4];
                    _loc_6 = this._rangeValues[_loc_4];
                    _loc_7 = _loc_5 + _loc_6 * this.ratio;
                    _loc_8 = plugins[_loc_4];
                    if (_loc_8)
                    {
                        _loc_9 = _loc_8.length;
                        _loc_10 = 0;
                        while (_loc_10 < _loc_9)
                        {
                            
                            _loc_7 = _loc_8[_loc_10].tween(this, _loc_4, _loc_7, _loc_5, _loc_6, this.ratio, _loc_3);
                            _loc_10 = _loc_10 + 1;
                        }
                        if (!isNaN(_loc_7))
                        {
                            this.target[_loc_4] = _loc_7;
                        }
                        continue;
                    }
                    this.target[_loc_4] = _loc_7;
                }
            }
            if (hasStarPlugins)
            {
                _loc_8 = plugins["*"];
                _loc_9 = _loc_8.length;
                _loc_10 = 0;
                while (_loc_10 < _loc_9)
                {
                    
                    _loc_8[_loc_10].tween(this, "*", NaN, NaN, NaN, this.ratio, _loc_3);
                    _loc_10 = _loc_10 + 1;
                }
            }
            if (!this.suppressEvents)
            {
                if (this.dispatchEvents)
                {
                    this.dispatchEvt("change");
                }
                if (this.onChange != null)
                {
                    this.onChange(this);
                }
            }
            if (_loc_3)
            {
                this.paused = true;
                if (this.nextTween)
                {
                    this.nextTween.paused = false;
                }
                if (!this.suppressEvents)
                {
                    if (this.dispatchEvents)
                    {
                        this.dispatchEvt("complete");
                    }
                    if (this.onComplete != null)
                    {
                        this.onComplete(this);
                    }
                }
            }
            return;
        }// end function

        public function get delay() : Number
        {
            return this._delay;
        }// end function

        public function set delay(param1:Number) : void
        {
            if (this._position <= 0)
            {
                this._position = -param1;
            }
            this._delay = param1;
            return;
        }// end function

        public function get proxy() : TargetProxy
        {
            if (this._proxy == null)
            {
                this._proxy = new TargetProxy(this);
            }
            return this._proxy;
        }// end function

        public function setValue(param1:String, param2:Number) : void
        {
            this._values[param1] = param2;
            this.invalidate();
            return;
        }// end function

        public function getValue(param1:String) : Number
        {
            return this._values[param1];
        }// end function

        public function deleteValue(param1:String) : Boolean
        {
            delete this._rangeValues[param1];
            delete this._initValues[param1];
            return delete this._values[param1];
        }// end function

        public function setValues(param1:Object) : void
        {
            this.copy(param1, this._values, true);
            this.invalidate();
            return;
        }// end function

        public function resetValues(param1:Object = null) : void
        {
            this._values = {};
            this.setValues(param1);
            return;
        }// end function

        public function getValues() : Object
        {
            return this.copy(this._values, {});
        }// end function

        public function getInitValue(param1:String) : Number
        {
            return this._initValues[param1];
        }// end function

        public function swapValues() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = NaN;
            if (!this._inited)
            {
                this.init();
            }
            var _loc_1:* = this._values;
            this._values = this._initValues;
            this._initValues = _loc_1;
            for (_loc_2 in this._rangeValues)
            {
                
                _loc_5[_loc_2] = _loc_5[_loc_2] * -1;
            }
            if (this._position < 0)
            {
                _loc_3 = this.positionOld;
                this.position = 0;
                this._position = this.positionOld;
                this.positionOld = _loc_3;
            }
            else
            {
                this.position = this._position;
            }
            return;
        }// end function

        public function init() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            var _loc_5:* = 0;
            this._inited = true;
            this._initValues = {};
            this._rangeValues = {};
            for (_loc_1 in this._values)
            {
                
                if (plugins[_loc_1])
                {
                    _loc_2 = plugins[_loc_1];
                    _loc_3 = _loc_2.length;
                    _loc_4 = _loc_1 in this.target ? (this.target[_loc_1]) : (NaN);
                    _loc_5 = 0;
                    while (_loc_5 < _loc_3)
                    {
                        
                        _loc_4 = _loc_2[_loc_5].init(this, _loc_1, _loc_4);
                        _loc_5 = _loc_5 + 1;
                    }
                    if (!isNaN(_loc_4))
                    {
                        var _loc_8:* = _loc_4;
                        this._initValues[_loc_1] = _loc_4;
                        this._rangeValues[_loc_1] = _loc_7[_loc_1] - _loc_8;
                    }
                    continue;
                }
                var _loc_8:* = this.target[_loc_1];
                this._initValues[_loc_1] = this.target[_loc_1];
                this._rangeValues[_loc_1] = _loc_7[_loc_1] - _loc_8;
            }
            if (hasStarPlugins)
            {
                _loc_2 = plugins["*"];
                _loc_3 = _loc_2.length;
                _loc_5 = 0;
                while (_loc_5 < _loc_3)
                {
                    
                    _loc_2[_loc_5].init(this, "*", NaN);
                    _loc_5 = _loc_5 + 1;
                }
            }
            if (!this.suppressEvents)
            {
                if (this.dispatchEvents)
                {
                    this.dispatchEvt("init");
                }
                if (this.onInit != null)
                {
                    this.onInit(this);
                }
            }
            return;
        }// end function

        public function beginning() : void
        {
            this.position = 0;
            this.paused = true;
            return;
        }// end function

        public function end() : void
        {
            this.position = this.repeatCount > 0 ? (this.repeatCount * this.duration) : (this.duration);
            return;
        }// end function

        protected function invalidate() : void
        {
            this._inited = false;
            if (this._position > 0)
            {
                this._position = 0;
            }
            if (this.autoPlay)
            {
                this.paused = false;
            }
            return;
        }// end function

        protected function copy(param1:Object, param2:Object, param3:Boolean = false) : Object
        {
            var _loc_4:* = null;
            for (_loc_4 in param1)
            {
                
                if (param3 && _loc_6[_loc_4] == null)
                {
                    delete param2[_loc_4];
                    continue;
                }
                param2[_loc_4] = _loc_6[_loc_4];
            }
            return param2;
        }// end function

        protected function dispatchEvt(param1:String) : void
        {
            if (hasEventListener(param1))
            {
                dispatchEvent(new Event(param1));
            }
            return;
        }// end function

        public static function installPlugin(param1:Object, param2:Array, param3:Boolean = false) : void
        {
            var _loc_5:* = null;
            var _loc_4:* = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_5 = param2[_loc_4];
                if (_loc_5 == "*")
                {
                    hasStarPlugins = true;
                }
                if (plugins[_loc_5] == null)
                {
                    plugins[_loc_5] = [param1];
                }
                else if (param3)
                {
                    plugins[_loc_5].unshift(param1);
                }
                else
                {
                    plugins[_loc_5].push(param1);
                }
                _loc_4 = _loc_4 + 1;
            }
            return;
        }// end function

        public static function linearEase(param1:Number, param2:Number, param3:Number, param4:Number) : Number
        {
            return param1;
        }// end function

        static function staticInit() : void
        {
            var _loc_1:* = new Shape();
            shape = new Shape();
            _loc_1.addEventListener(Event.ENTER_FRAME, staticTick);
            time = getTimer() / 1000;
            return;
        }// end function

        static function staticTick(event:Event) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = time;
            time = getTimer() / 1000;
            if (pauseAll)
            {
                return;
            }
            var _loc_3:* = (time - _loc_2) * timeScaleAll;
            for (_loc_4 in tickList)
            {
                
                _loc_5 = _loc_4 as GTween;
                _loc_5.position = _loc_5._position + (_loc_5.useFrames ? (timeScaleAll) : (_loc_3)) * _loc_5.timeScale;
            }
            return;
        }// end function

        staticInit();
    }
}

import flash.display.*;

import flash.events.*;

import flash.utils.*;

dynamic class TargetProxy extends Proxy
{
    private var tween:GTween;

    function TargetProxy(param1:GTween) : void
    {
        this.tween = param1;
        return;
    }// end function

    public function callProperty(param1, ... args)
    {
        return this.tween.target[param1].apply(null, args);
    }// end function

    public function getProperty(param1)
    {
        var _loc_2:* = this.tween.getValue(param1);
        return isNaN(_loc_2) ? (this.tween.target[param1]) : (_loc_2);
    }// end function

    public function setProperty(param1, param2) : void
    {
        if (param2 is Boolean || param2 is String || isNaN(param2))
        {
            this.tween.target[param1] = param2;
        }
        else
        {
            this.tween.setValue(String(param1), Number(param2));
        }
        return;
    }// end function

    public function deleteProperty(param1) : Boolean
    {
        this.tween.deleteValue(param1);
        return true;
    }// end function

}

