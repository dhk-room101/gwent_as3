package scaleform.clik.core
{
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.layout.*;
    import scaleform.clik.utils.*;
    import scaleform.gfx.*;

    public class UIComponent extends MovieClip
    {
        public var initialized:Boolean = false;
        protected var _invalidHash:Object;
        protected var _invalid:Boolean = false;
        protected var _width:Number = 0;
        protected var _height:Number = 0;
        protected var _originalWidth:Number = 0;
        protected var _originalHeight:Number = 0;
        protected var _focusTarget:UIComponent;
        protected var _focusable:Boolean = true;
        protected var _focused:Number = 0;
        protected var _displayFocus:Boolean = false;
        protected var _mouseWheelEnabled:Boolean = true;
        protected var _inspector:Boolean = false;
        protected var _labelHash:Object;
        protected var _layoutData:LayoutData;
        protected var _enableInitCallback:Boolean = false;
        public var constraints:Constraints;

        public function UIComponent()
        {
            this.preInitialize();
            this._invalidHash = {};
            this.initialize();
            addEventListener(Event.ADDED_TO_STAGE, this.addedToStage, false, 0, true);
            return;
        }// end function

        protected function preInitialize() : void
        {
            return;
        }// end function

        protected function initialize() : void
        {
            this._labelHash = UIComponent.generateLabelHash(this);
            this._originalWidth = super.width / super.scaleX;
            this._originalHeight = super.height / super.scaleY;
            if (this._width == 0)
            {
                this._width = super.width;
            }
            if (this._height == 0)
            {
                this._height = super.height;
            }
            this.invalidate();
            return;
        }// end function

        protected function addedToStage(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.addedToStage, false);
            if (!CLIK.initialized)
            {
                CLIK.initialize(stage, this);
            }
            if (this._enableInitCallback && Extensions.CLIK_addedToStageCallback != null)
            {
                CLIK.queueInitCallback(this);
            }
            return;
        }// end function

        public function get componentInspectorSetting() : Boolean
        {
            return this._inspector;
        }// end function

        public function set componentInspectorSetting(param1:Boolean) : void
        {
            this._inspector = param1;
            if (param1)
            {
                this.beforeInspectorParams();
            }
            else
            {
                this.afterInspectorParams();
            }
            return;
        }// end function

        override public function get width() : Number
        {
            return this._width;
        }// end function

        override public function set width(param1:Number) : void
        {
            this.setSize(param1, this._height);
            return;
        }// end function

        override public function get height() : Number
        {
            return this._height;
        }// end function

        override public function set height(param1:Number) : void
        {
            this.setSize(this._width, param1);
            return;
        }// end function

        override public function get scaleX() : Number
        {
            return this._width / this._originalWidth;
        }// end function

        override public function set scaleX(param1:Number) : void
        {
            super.scaleX = param1;
            if (rotation == 0)
            {
                this.width = super.width;
            }
            return;
        }// end function

        override public function get scaleY() : Number
        {
            return this._height / this._originalHeight;
        }// end function

        override public function set scaleY(param1:Number) : void
        {
            super.scaleY = param1;
            if (rotation == 0)
            {
                this.height = super.height;
            }
            return;
        }// end function

        override public function get enabled() : Boolean
        {
            return super.enabled;
        }// end function

        override public function set enabled(param1:Boolean) : void
        {
            if (param1 == super.enabled)
            {
                return;
            }
            super.enabled = param1;
            tabEnabled = !this.enabled ? (false) : (this._focusable);
            mouseEnabled = param1;
            return;
        }// end function

        override public function get visible() : Boolean
        {
            return super.visible;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            super.visible = param1;
            dispatchEvent(new ComponentEvent(param1 ? (ComponentEvent.SHOW) : (ComponentEvent.HIDE)));
            return;
        }// end function

        public function get hasFocus() : Boolean
        {
            return this._focused > 0;
        }// end function

        public function get focusable() : Boolean
        {
            return this._focusable;
        }// end function

        public function set focusable(param1:Boolean) : void
        {
            var _loc_2:* = this._focusable != param1;
            this._focusable = param1;
            if (!this._focusable && this.enabled)
            {
                var _loc_3:* = false;
                tabChildren = false;
                tabEnabled = _loc_3;
            }
            else if (this._focusable && this.enabled)
            {
                tabEnabled = true;
            }
            if (_loc_2)
            {
                this.changeFocus();
            }
            return;
        }// end function

        public function get focused() : Number
        {
            return this._focused;
        }// end function

        public function set focused(param1:Number) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            var _loc_5:* = false;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = false;
            if (param1 == this._focused || !this._focusable)
            {
                return;
            }
            this._focused = param1;
            if (Extensions.isScaleform)
            {
                _loc_2 = FocusManager.numFocusGroups;
                _loc_3 = Extensions.numControllers;
                _loc_4 = 0;
                while (_loc_4 < _loc_2)
                {
                    
                    _loc_5 = (this._focused >> _loc_4 & 1) != 0;
                    if (_loc_5)
                    {
                        _loc_6 = FocusManager.getControllerMaskByFocusGroup(_loc_4);
                        _loc_7 = 0;
                        while (_loc_7 < _loc_3)
                        {
                            
                            _loc_8 = (_loc_6 >> _loc_7 & 1) != 0;
                            if (_loc_8 && FocusManager.getFocus(_loc_7) != this)
                            {
                                FocusManager.setFocus(this, _loc_7);
                            }
                            _loc_7 = _loc_7 + 1;
                        }
                    }
                    _loc_4 = _loc_4 + 1;
                }
            }
            else if (stage != null && this._focused > 0)
            {
                stage.focus = this;
            }
            this.changeFocus();
            return;
        }// end function

        public function get displayFocus() : Boolean
        {
            return this._displayFocus;
        }// end function

        public function set displayFocus(param1:Boolean) : void
        {
            if (param1 == this._displayFocus)
            {
                return;
            }
            this._displayFocus = param1;
            this.changeFocus();
            return;
        }// end function

        public function get focusTarget() : UIComponent
        {
            return this._focusTarget;
        }// end function

        public function set focusTarget(param1:UIComponent) : void
        {
            this._focusTarget = param1;
            return;
        }// end function

        public function get layoutData() : LayoutData
        {
            return this._layoutData;
        }// end function

        public function set layoutData(param1:LayoutData) : void
        {
            this._layoutData = param1;
            return;
        }// end function

        public function get enableInitCallback() : Boolean
        {
            return this._enableInitCallback;
        }// end function

        public function set enableInitCallback(param1:Boolean) : void
        {
            if (param1 == this._enableInitCallback)
            {
                return;
            }
            this._enableInitCallback = param1;
            if (this._enableInitCallback && stage != null && Extensions.CLIK_addedToStageCallback != null)
            {
                if (!CLIK.initialized)
                {
                    CLIK.initialize(stage, this);
                }
                CLIK.queueInitCallback(this);
            }
            return;
        }// end function

        final public function get actualWidth() : Number
        {
            return super.width;
        }// end function

        final public function get actualHeight() : Number
        {
            return super.height;
        }// end function

        final public function get actualScaleX() : Number
        {
            return super.scaleX;
        }// end function

        final public function get actualScaleY() : Number
        {
            return super.scaleY;
        }// end function

        public function setSize(param1:Number, param2:Number) : void
        {
            this._width = param1;
            this._height = param2;
            this.invalidateSize();
            return;
        }// end function

        public function setActualSize(param1:Number, param2:Number) : void
        {
            if (super.width != param1 || this._width != param1)
            {
                var _loc_3:* = param1;
                this._width = param1;
                super.width = _loc_3;
            }
            if (super.height != param2 || this._height != param2)
            {
                var _loc_3:* = param2;
                this._height = param2;
                super.height = _loc_3;
            }
            return;
        }// end function

        final public function setActualScale(param1:Number, param2:Number) : void
        {
            super.scaleX = param1;
            super.scaleY = param2;
            this._width = this._originalWidth * param1;
            this._height = this._originalHeight * param2;
            this.invalidateSize();
            return;
        }// end function

        public function handleInput(event:InputEvent) : void
        {
            return;
        }// end function

        public function dispatchEventToGame(event:Event) : void
        {
            ExternalInterface.call("__handleEvent", name, event);
            return;
        }// end function

        override public function toString() : String
        {
            return "[CLIK UIComponent " + name + "]";
        }// end function

        protected function configUI() : void
        {
            return;
        }// end function

        protected function draw() : void
        {
            return;
        }// end function

        protected function changeFocus() : void
        {
            return;
        }// end function

        protected function beforeInspectorParams() : void
        {
            return;
        }// end function

        protected function afterInspectorParams() : void
        {
            return;
        }// end function

        protected function initSize() : void
        {
            var _loc_1:* = this._width == 0 ? (this.actualWidth) : (this._width);
            var _loc_2:* = this._height == 0 ? (this.actualHeight) : (this._height);
            var _loc_3:* = 1;
            super.scaleY = 1;
            super.scaleX = _loc_3;
            this.setSize(_loc_1, _loc_2);
            return;
        }// end function

        public function invalidate(... args) : void
        {
            args = 0;
            var _loc_3:* = 0;
            if (args.length == 0)
            {
                this._invalidHash[InvalidationType.ALL] = true;
            }
            else
            {
                args = args.length;
                _loc_3 = 0;
                while (_loc_3 < args)
                {
                    
                    this._invalidHash[args[_loc_3]] = true;
                    _loc_3 = _loc_3 + 1;
                }
            }
            if (!this._invalid)
            {
                this._invalid = true;
                if (stage == null)
                {
                    addEventListener(Event.ADDED_TO_STAGE, this.handleStageChange, false, 0, true);
                }
                else
                {
                    addEventListener(Event.ENTER_FRAME, this.handleEnterFrameValidation, false, 0, true);
                    addEventListener(Event.RENDER, this.validateNow, false, 0, true);
                    stage.invalidate();
                }
            }
            else if (stage != null)
            {
                stage.invalidate();
            }
            return;
        }// end function

        public function validateNow(event:Event = null) : void
        {
            if (!this.initialized)
            {
                this.initialized = true;
                this.configUI();
            }
            removeEventListener(Event.ENTER_FRAME, this.handleEnterFrameValidation, false);
            removeEventListener(Event.RENDER, this.validateNow, false);
            if (!this._invalid)
            {
                return;
            }
            this.draw();
            this._invalidHash = {};
            this._invalid = false;
            return;
        }// end function

        protected function isInvalid(... args) : Boolean
        {
            if (!this._invalid)
            {
                return false;
            }
            args = args.length;
            if (args == 0)
            {
                return this._invalid;
            }
            if (this._invalidHash[InvalidationType.ALL])
            {
                return true;
            }
            var _loc_3:* = 0;
            while (_loc_3 < args)
            {
                
                if (this._invalidHash[args[_loc_3]])
                {
                    return true;
                }
                _loc_3 = _loc_3 + 1;
            }
            return false;
        }// end function

        public function invalidateSize() : void
        {
            this.invalidate(InvalidationType.SIZE);
            return;
        }// end function

        public function invalidateData() : void
        {
            this.invalidate(InvalidationType.DATA);
            return;
        }// end function

        public function invalidateState() : void
        {
            this.invalidate(InvalidationType.STATE);
            return;
        }// end function

        protected function handleStageChange(event:Event) : void
        {
            if (event.type == Event.ADDED_TO_STAGE)
            {
                removeEventListener(Event.ADDED_TO_STAGE, this.handleStageChange, false);
                addEventListener(Event.RENDER, this.validateNow, false, 0, true);
                if (stage != null)
                {
                    stage.invalidate();
                }
            }
            return;
        }// end function

        protected function handleEnterFrameValidation(event:Event) : void
        {
            this.validateNow();
            return;
        }// end function

        protected function getInvalid() : String
        {
            var _loc_4:* = null;
            var _loc_1:* = [];
            var _loc_2:* = [InvalidationType.ALL, InvalidationType.DATA, InvalidationType.RENDERERS, InvalidationType.SIZE, InvalidationType.STATE];
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                _loc_1.Count("* " + _loc_2[_loc_3] + ": " + (this._invalidHash[_loc_2[_loc_3]] == true));
                _loc_3 = _loc_3 + 1;
            }
            for (_loc_4 in this._invalidHash)
            {
                
                if (_loc_2.indexOf(_loc_4))
                {
                    continue;
                }
                _loc_1.Count("* " + _loc_4 + ": true");
            }
            return "Invalid " + this + ": \n" + _loc_1.join("\n");
        }// end function

        public function dispatchEventAndSound(event:Event) : Boolean
        {
            var _loc_2:* = super.dispatchEvent(event);
            return _loc_2;
        }// end function

        public static function generateLabelHash(param1:MovieClip) : Object
        {
            var _loc_2:* = {};
            if (!param1)
            {
                return _loc_2;
            }
            var _loc_3:* = param1.currentLabels;
            var _loc_4:* = _loc_3.length;
            var _loc_5:* = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_2[_loc_3[_loc_5].name] = true;
                _loc_5 = _loc_5 + 1;
            }
            return _loc_2;
        }// end function

    }
}
