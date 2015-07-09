package scaleform.clik.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;

    public class Constraints extends EventDispatcher
    {
        public var scope:DisplayObject;
        public var scaleMode:String = "counterScale";
        public var parentXAdjust:Number = 1;
        public var parentYAdjust:Number = 1;
        protected var elements:Object;
        protected var elementCount:int = 0;
        protected var parentConstraints:Constraints;
        public var lastWidth:Number = NaN;
        public var lastHeight:Number = NaN;
        public static const LEFT:uint = 1;
        public static const RIGHT:uint = 2;
        public static const TOP:uint = 4;
        public static const BOTTOM:uint = 8;
        public static var ALL:uint = LEFT | RIGHT | TOP | BOTTOM;
        public static const CENTER_H:uint = 16;
        public static const CENTER_V:uint = 32;

        public function Constraints(param1:Sprite, param2:String = "counterScale")
        {
            this.scope = param1;
            this.scaleMode = param2;
            this.elements = {};
            this.lastWidth = param1.width;
            this.lastHeight = param1.height;
            param1.addEventListener(Event.ADDED_TO_STAGE, this.handleScopeAddedToStage, false, 0, true);
            param1.addEventListener(Event.REMOVED_FROM_STAGE, this.handleScopeAddedToStage, false, 0, true);
            return;
        }// end function

        public function addElement(param1:String, param2:DisplayObject, param3:uint) : void
        {
            if (param2 == null)
            {
                return;
            }
            var _loc_4:* = this.scope.width;
            var _loc_5:* = this.scope.height;
            if (this.scope.parent != null && this.scope.parent is Stage)
            {
                _loc_4 = this.scope.stage.stageWidth;
                _loc_5 = this.scope.stage.stageHeight;
            }
            var _loc_6:* = new ConstrainedElement(param2, param3, param2.x, param2.y, _loc_4 / this.scope.scaleX - (param2.x + param2.width), _loc_5 / this.scope.scaleY - (param2.y + param2.height), param2.scaleX, param2.scaleY);
            if (this.elements[param1] == null)
            {
                var _loc_7:* = this;
                var _loc_8:* = this.elementCount + 1;
                _loc_7.elementCount = _loc_8;
            }
            this.elements[param1] = _loc_6;
            return;
        }// end function

        public function removeElement(param1:String) : void
        {
            if (this.elements[param1] != null)
            {
                var _loc_2:* = this;
                var _loc_3:* = this.elementCount - 1;
                _loc_2.elementCount = _loc_3;
            }
            delete this.elements[param1];
            return;
        }// end function

        public function removeAllElements() : void
        {
            var _loc_1:* = null;
            for (_loc_1 in this.elements)
            {
                
                if (_loc_3[_loc_1] is ConstrainedElement)
                {
                    var _loc_4:* = this;
                    var _loc_5:* = this.elementCount - 1;
                    _loc_4.elementCount = _loc_5;
                    delete _loc_3[_loc_1];
                }
            }
            return;
        }// end function

        public function getElement(param1:String) : ConstrainedElement
        {
            return this.elements[param1] as ConstrainedElement;
        }// end function

        public function updateElement(param1:String, param2:DisplayObject) : void
        {
            if (param2 == null)
            {
                return;
            }
            var _loc_3:* = this.elements[param1] as ConstrainedElement;
            if (_loc_3 == null)
            {
                return;
            }
            _loc_3.clip = param2;
            return;
        }// end function

        public function getXAdjust() : Number
        {
            if (this.scaleMode == ConstrainMode.REFLOW)
            {
                return this.parentXAdjust;
            }
            return this.parentXAdjust / this.scope.scaleX;
        }// end function

        public function getYAdjust() : Number
        {
            if (this.scaleMode == ConstrainMode.REFLOW)
            {
                return this.parentYAdjust;
            }
            return this.parentYAdjust / this.scope.scaleY;
        }// end function

        public function update(param1:Number, param2:Number) : void
        {
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_8:* = 0;
            var _loc_9:* = null;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            this.lastWidth = param1;
            this.lastHeight = param2;
            if (this.elementCount == 0)
            {
                return;
            }
            var _loc_3:* = this.getXAdjust();
            var _loc_4:* = this.getYAdjust();
            var _loc_5:* = this.scaleMode == ConstrainMode.COUNTER_SCALE;
            for (_loc_6 in this.elements)
            {
                
                _loc_7 = _loc_13[_loc_6] as ConstrainedElement;
                _loc_8 = _loc_7.edges;
                _loc_9 = _loc_7.clip;
                if (_loc_5)
                {
                    _loc_9.scaleX = _loc_7.scaleX * _loc_3;
                    _loc_9.scaleY = _loc_7.scaleY * _loc_4;
                    if ((_loc_8 & Constraints.CENTER_H) == 0)
                    {
                        if ((_loc_8 & Constraints.LEFT) > 0)
                        {
                            _loc_9.x = _loc_7.left * _loc_3;
                            if ((_loc_8 & Constraints.RIGHT) > 0)
                            {
                                _loc_10 = param1 - _loc_7.left - _loc_7.right;
                                if (!(_loc_9 is TextField))
                                {
                                    _loc_10 = _loc_10 * _loc_3;
                                }
                                _loc_9.width = _loc_10;
                            }
                        }
                        else if ((_loc_8 & Constraints.RIGHT) > 0)
                        {
                            _loc_9.x = (param1 - _loc_7.right) * _loc_3 - _loc_9.width;
                        }
                    }
                    if ((_loc_8 & Constraints.CENTER_V) == 0)
                    {
                        if ((_loc_8 & Constraints.TOP) > 0)
                        {
                            _loc_9.y = _loc_7.top * _loc_4;
                            if ((_loc_8 & Constraints.BOTTOM) > 0)
                            {
                                _loc_11 = param2 - _loc_7.top - _loc_7.bottom;
                                if (!(_loc_9 is TextField))
                                {
                                    _loc_11 = _loc_11 * _loc_4;
                                }
                                _loc_9.height = _loc_11;
                            }
                        }
                        else if ((_loc_8 & Constraints.BOTTOM) > 0)
                        {
                            _loc_9.y = (param2 - _loc_7.bottom) * _loc_4 - _loc_9.height;
                        }
                    }
                }
                else
                {
                    if ((_loc_8 & Constraints.CENTER_H) == 0 && (_loc_8 & Constraints.RIGHT) > 0)
                    {
                        if ((_loc_8 & Constraints.LEFT) > 0)
                        {
                            _loc_9.width = param1 - _loc_7.left - _loc_7.right;
                        }
                        else
                        {
                            _loc_9.x = param1 - _loc_9.width - _loc_7.right;
                        }
                    }
                    if ((_loc_8 & Constraints.CENTER_V) == 0 && (_loc_8 & Constraints.BOTTOM) > 0)
                    {
                        if ((_loc_8 & Constraints.TOP) > 0)
                        {
                            _loc_9.height = param2 - _loc_7.top - _loc_7.bottom;
                        }
                        else
                        {
                            _loc_9.y = param2 - _loc_9.height - _loc_7.bottom;
                        }
                    }
                    if (_loc_9 is UIComponent)
                    {
                        (_loc_9 as UIComponent).validateNow();
                    }
                }
                if ((_loc_8 & Constraints.CENTER_H) > 0)
                {
                    _loc_9.x = param1 * 0.5 * _loc_3 - _loc_9.width * 0.5;
                }
                if ((_loc_8 & Constraints.CENTER_V) > 0)
                {
                    _loc_9.y = param2 * 0.5 * _loc_4 - _loc_9.height * 0.5;
                }
            }
            if (!_loc_5)
            {
                this.scope.scaleX = this.parentXAdjust;
                this.scope.scaleY = this.parentYAdjust;
            }
            if (hasEventListener(ResizeEvent.RESIZE))
            {
                dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE, _loc_3, _loc_4));
            }
            return;
        }// end function

        override public function toString() : String
        {
            var _loc_3:* = null;
            var _loc_1:* = this.elements.length;
            var _loc_2:* = "[CLIK Constraints (" + _loc_1 + ")]";
            for (_loc_3 in this.elements)
            {
                
                _loc_2 = _loc_2 + ("\n\t" + _loc_3 + ": " + _loc_5[_loc_3].toString());
            }
            return _loc_2;
        }// end function

        protected function handleScopeAddedToStage(event:Event) : void
        {
            this.addToParentConstraints();
            return;
        }// end function

        protected function addToParentConstraints() : void
        {
            if (this.parentConstraints != null)
            {
                this.parentConstraints.removeEventListener(ResizeEvent.RESIZE, this.handleParentConstraintsResize);
            }
            this.parentConstraints = null;
            var _loc_1:* = this.scope.parent;
            if (_loc_1 == null)
            {
                return;
            }
            while (_loc_1 != null)
            {
                
                if (_loc_1.hasOwnProperty("constraints"))
                {
                    this.parentConstraints = _loc_1["constraints"] as Constraints;
                    if (this.parentConstraints != null && this.parentConstraints.scaleMode == ConstrainMode.REFLOW)
                    {
                        return;
                    }
                    if (this.parentConstraints != null && this.scaleMode == ConstrainMode.REFLOW)
                    {
                        return;
                    }
                    if (this.parentConstraints != null)
                    {
                        this.parentConstraints.addEventListener(ResizeEvent.RESIZE, this.handleParentConstraintsResize, false, 0, true);
                        break;
                    }
                }
                _loc_1 = _loc_1.parent;
            }
            if (this.parentConstraints != null)
            {
                this.parentXAdjust = this.parentConstraints.getXAdjust();
                this.parentYAdjust = this.parentConstraints.getYAdjust();
            }
            return;
        }// end function

        protected function handleParentConstraintsResize(event:ResizeEvent) : void
        {
            this.parentXAdjust = event.scaleX;
            this.parentYAdjust = event.scaleY;
            this.update(this.lastWidth, this.lastHeight);
            return;
        }// end function

    }
}
