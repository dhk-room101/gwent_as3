package red.game.witcher3.controls 
{
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.text.*;
    import flash.utils.*;
    import red.core.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.data.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.controls.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    
    public class InputFeedbackButton extends scaleform.clik.controls.Button
    {
        public function InputFeedbackButton()
        {
            super();
            constraintsDisabled = true;
            preventAutosizing = true;
            if (this.mcIconXbox) 
            {
                this.mcIconXbox.visible = false;
            }
            if (this.mcIconPS) 
            {
                this.mcIconPS.visible = false;
            }
            if (this.mcKeyboardIcon) 
            {
                this.mcKeyboardIcon.visible = false;
            }
            this._gpadIcon = this.mcIconXbox;
            focusable = false;
            if (textField) 
            {
                textField.text = "";
            }
            if (this.mcClickRect) 
            {
                this.mcClickRect.visible = false;
            }
            if (this.mcIconPS && this.mcIconXbox) 
            {
                var loc1:*;
                this.mcIconXbox.visible = loc1 = false;
                this.mcIconPS.visible = loc1;
            }
            if (this.mcHoldAnimation) 
            {
                this.mcHoldAnimation.visible = false;
            }
            if (this.tfKeyLabel) 
            {
                this.tfKeyLabel.visible = false;
            }
            if (this.mcMouseIcon) 
            {
                this.mcMouseIcon.visible = false;
            }
            return;
        }

        public function get dontSwapAcceptCancel():Boolean
        {
            return this._dontSwapAcceptCancel;
        }

        public function set dontSwapAcceptCancel(arg1:Boolean):void
        {
            this._dontSwapAcceptCancel = arg1;
            return;
        }

        public function get overrideTextColor():Number
        {
            return this._overrideTextColor;
        }

        public function set overrideTextColor(arg1:Number):void
        {
            this._overrideTextColor = arg1;
            return;
        }

        public function get lowercaseLabels():Boolean
        {
            return this._lowercaseLabels;
        }

        public function set lowercaseLabels(arg1:Boolean):void
        {
            this._lowercaseLabels = arg1;
            return;
        }

        public override function toString():String
        {
            return "InputFeedbackButton [" + this.name + "] _bindingData: " + this._bindingData;
        }

        public function handleHoldInput(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=0;
            var loc4:*=null;
            if (!arg1.handled && this._holdDuration > 0 && this._bindingData) 
            {
                loc1 = red.game.witcher3.managers.InputManager.getInstance();
                loc2 = arg1.details;
                loc3 = loc2.code;
                loc4 = loc2.navEquivalent;
                if (loc1.swapAcceptCancel) 
                {
                    if (loc4 != scaleform.clik.constants.NavigationCode.GAMEPAD_A) 
                    {
                        if (loc4 == scaleform.clik.constants.NavigationCode.GAMEPAD_B) 
                        {
                            loc4 = scaleform.clik.constants.NavigationCode.GAMEPAD_A;
                            loc3 = red.core.constants.KeyCode.PAD_A_CROSS;
                        }
                    }
                    else 
                    {
                        loc4 = scaleform.clik.constants.NavigationCode.GAMEPAD_B;
                        loc3 = red.core.constants.KeyCode.PAD_B_CIRCLE;
                    }
                }
                if (loc4 == this._bindingData.gamepad_navEquivalent || loc3 == this._bindingData.keyboard_keyCode || loc3 == this._bindingData.gamepad_keyCode) 
                {
                    if (visible) 
                    {
                        if (loc2.value == scaleform.clik.constants.InputValue.KEY_DOWN && !this._holdTimer) 
                        {
                            this.startHoldAnimation();
                        }
                        else if (loc2.value == scaleform.clik.constants.InputValue.KEY_UP && this._holdTimer) 
                        {
                            this.stopHoldAnimation();
                        }
                    }
                }
            }
            return;
        }

        protected function UpdateHoldAnimation():*
        {
            var loc1:*=NaN;
            var loc2:*=NaN;
            if (!this._holdIndicator || !this._holdIndicatorMask && !this.mcHoldAnimation || this.mcHoldAnimation && !this.mcHoldAnimation.visible || !visible) 
            {
                return;
            }
            var loc3:*=this.mcHoldAnimation ? HOLD_INT_MAX_FRAME : HOLD_INT_MAX_ANGLE;
            loc1 = loc3 / (this._holdDuration / HOLD_ANIM_INTERVAL);
            this._holdProgress = this._holdProgress + loc1;
            loc2 = Math.min(loc3, this._holdProgress);
            if (loc2 > 0) 
            {
                if (this.mcHoldAnimation) 
                {
                    this.mcHoldAnimation.visible = true;
                    this.mcHoldAnimation.gotoAndStop(HOLD_INT_FIRST_FRAME + loc2);
                }
                else 
                {
                    this._holdIndicator.visible = true;
                    this._holdIndicatorMask.visible = true;
                    this._holdIndicatorMask.graphics.clear();
                    red.game.witcher3.utils.CommonUtils.drawPie(this._holdIndicatorMask.graphics, this._holdIndicator.width, HOLD_ANIM_STEPS_COUNT, 0, loc2);
                }
            }
            else if (this.mcHoldAnimation) 
            {
                this.mcHoldAnimation.visible = false;
            }
            else 
            {
                this._holdIndicator.visible = false;
                this._holdIndicatorMask.visible = false;
            }
            return;
        }

        public function displayGamepadIcon():void
        {
            var loc3:*=null;
            var loc1:*=this._bindingData.gamepad_navEquivalent;
            var loc2:*=this._bindingData.gamepad_keyCode;
            this.updateText();
            if (loc1) 
            {
                this.SetupGamepadIcon(loc1);
            }
            else if (loc2 > 0) 
            {
                loc3 = scaleform.clik.managers.InputDelegate.getInstance();
                loc1 = loc3.inputToNav("key", loc2);
                this.SetupGamepadIcon(loc1);
            }
            else 
            {
                this._contentInvalid = true;
                this.updateVisibility();
            }
            return;
        }

        protected function handleHoldTimer(arg1:flash.events.TimerEvent):void
        {
            var loc1:*=this.mcHoldAnimation ? HOLD_INT_MAX_FRAME : HOLD_INT_MAX_ANGLE;
            if (this._holdProgress > loc1) 
            {
                this.stopHoldAnimation();
                if (!(this.holdCallback == null) && !this._timerActivated) 
                {
                    this.holdCallback();
                    this._timerActivated = true;
                }
                if (this.mcHoldAnimation) 
                {
                    this.mcHoldAnimation.gotoAndPlay("Done");
                }
                return;
            }
            if (!this.mcHoldAnimation) 
            {
                this.SpawnHoldAnimationMask();
            }
            if (this.parent == null || this.visible == false) 
            {
                return;
            }
            this.UpdateHoldAnimation();
            return;
        }

        protected function stopHoldAnimation():void
        {
            if (this._holdTimer) 
            {
                this._timerActivated = false;
                this._holdTimer.removeEventListener(flash.events.TimerEvent.TIMER, this.handleHoldTimer, false);
                this._holdTimer.stop();
                this._holdTimer = null;
            }
            if (this._holdIndicatorMask) 
            {
                this._holdIndicatorMask.visible = false;
            }
            if (this._holdIndicator) 
            {
                this._holdIndicator.visible = false;
            }
            if (this.mcHoldAnimation) 
            {
                this.mcHoldAnimation.visible = false;
                this.mcHoldAnimation.gotoAndStop("Idle");
            }
            this._holdProgress = 0;
            return;
        }

        public function startHoldAnimation():void
        {
            if (!this._holdIndicator) 
            {
                trace("GFX Can\'t find _holdIndicator in the InputFeedbackButton ", parent);
                return;
            }
            if (this._holdTimer) 
            {
                return;
            }
            this.stopHoldAnimation();
            if (this.mcHoldAnimation) 
            {
                this.mcHoldAnimation.visible = true;
                this.mcHoldAnimation.gotoAndStop("Idle");
            }
            else 
            {
                this.SpawnHoldAnimationMask();
            }
            this._holdTimer = new flash.utils.Timer(HOLD_ANIM_INTERVAL);
            this._holdTimer.addEventListener(flash.events.TimerEvent.TIMER, this.handleHoldTimer, false, 0, true);
            this._holdTimer.start();
            this._holdProgress = 0;
            return;
        }

        private function SpawnHoldAnimationMask():void
        {
            if (this._holdIndicatorMask == null) 
            {
                this._holdIndicatorMask = new flash.display.Sprite();
                this._holdIndicatorMask.x = this._holdIndicator.x + this._holdIndicator.width / 2;
                this._holdIndicatorMask.y = this._holdIndicator.y;
                addChild(this._holdIndicatorMask);
                this._holdIndicator.mask = this._holdIndicatorMask;
            }
            return;
        }

        protected override function updateText():void
        {
            var loc1:*=null;
            var loc2:*=null;
            if (this.tfHoldPrefix) 
            {
                if ((this.holdDuration > 0 || this.addHoldPrefix) && _label && textField) 
                {
                    this.SetHoldButtonText();
                    this.tfHoldPrefix.textColor = this._overrideTextColor > -1 ? this._overrideTextColor : 16777215;
                    this.tfHoldPrefix.autoSize = flash.text.TextFieldAutoSize.LEFT;
                    this.tfHoldPrefix.visible = true;
                    this.tfHoldPrefix.width = this.tfHoldPrefix.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                    this.tfHoldPrefix.x = this._labelPosition;
                    textField.x = this._labelPosition + this.tfHoldPrefix.width;
                }
                else 
                {
                    this.tfHoldPrefix.visible = false;
                    textField.x = this._labelPosition;
                }
            }
            if (!(_label == null) && !(textField == null)) 
            {
                if (this._overrideTextColor >= 0) 
                {
                    textField.textColor = this._overrideTextColor;
                    textField.text = _label;
                }
                else 
                {
                    textField.htmlText = _label;
                }
                if (this._lowercaseLabels) 
                {
                    textField.text = red.game.witcher3.utils.CommonUtils.toLowerCaseExSafe(textField.text);
                }
                textField.width = textField.textWidth + TEXT_OFFSET;
                if (this.mcClickRect && this.mcClickRect.visible) 
                {
                    loc1 = this.mcClickRect as red.game.witcher3.controls.KeyboardButtonClickArea;
                    if (loc1) 
                    {
                        loc1.state = state;
                        loc1.setActualSize(CLICKABLE_BK_OFFSET + textField.x + textField.width, this.mcClickRect.height);
                        this.mcClickRect.x = 0;
                        this.mcClickRect.y = (-this.mcClickRect.height) / 2;
                        this.mcClickRect.visible = true;
                    }
                    else if (this.mcClickRect) 
                    {
                        this.mcClickRect.visible = false;
                    }
                }
            }
            if (enabled) 
            {
                this.filters = [];
                alpha = 1;
            }
            else if (this.filters.length < 1) 
            {
                loc2 = red.game.witcher3.utils.CommonUtils.getDesaturateFilter();
                this.filters = [loc2];
                alpha = DISABLED_ALPHA;
            }
            return;
        }

        protected function handleControllerChanged(arg1:red.game.witcher3.events.ControllerChangeEvent):void
        {
            if (this._dataFromStage) 
            {
                this.SetHoldButtonText();
                this.updateDataFromStage();
            }
            return;
        }

        protected function updateVisibility():void
        {
            var loc1:*=this._actualVisibility && !this._contentInvalid;
            if (super.visible != loc1) 
            {
                super.visible = loc1;
                this.UpdateHoldAnimation();
            }
            return;
        }

        protected function updateDataFromStage():void
        {
            var loc1:*=null;
            if (this._displayGamepadCode || this._displayKeyboardCode > 0 || this._displayGamepadKeyCode > 0) 
            {
                loc1 = new red.game.witcher3.data.KeyBindingData();
                loc1.actionId = 0;
                loc1.gamepad_navEquivalent = this._displayGamepadCode;
                loc1.keyboard_keyCode = this._displayKeyboardCode;
                loc1.gamepad_keyCode = this._displayGamepadKeyCode;
                loc1.label = label ? label : "";
                this._isGamepad = red.game.witcher3.managers.InputManager.getInstance().isGamepad();
                this._dataFromStage = true;
                this.setData(loc1, this._isGamepad);
                this.stopHoldAnimation();
            }
            return;
        }

        protected function displayKeyboardIcon():void
        {
            var loc2:*=null;
            var loc1:*=this._bindingData.keyboard_keyCode;
            if (loc1 > 0) 
            {
                loc2 = red.game.witcher3.constants.KeyboardKeys.getKeyLabel(loc1);
                if (this.clickable) 
                {
                    if (this.tfKeyLabel) 
                    {
                        this.tfKeyLabel.x = KEY_LABEL_PADDING;
                        this.tfKeyLabel.visible = true;
                        if (red.core.CoreComponent.isArabicAligmentMode) 
                        {
                            this.tfKeyLabel.text = "*" + red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(loc2) + "*";
                        }
                        else 
                        {
                            this.tfKeyLabel.text = loc2;
                            this.tfKeyLabel.text = "[" + red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(this.tfKeyLabel.text) + "]";
                        }
                        this.tfKeyLabel.width = this.tfKeyLabel.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                        this._labelPosition = this.tfKeyLabel.x + this.tfKeyLabel.textWidth + TEXT_PADDING_KEYBOARD;
                    }
                    if (this.mcClickRect) 
                    {
                        this.mcClickRect.visible = true;
                    }
                }
                else 
                {
                    if (this.mcMouseIcon && this.mcMouseIcon.isMouseKey(loc1)) 
                    {
                        this.mcMouseIcon.visible = true;
                        this.mcMouseIcon.keyCode = loc1;
                        this._labelPosition = this.mcMouseIcon.width + TEXT_PADDING_KEYBOARD;
                    }
                    else 
                    {
                        this.mcKeyboardIcon.visible = true;
                        this.mcKeyboardIcon.label = loc2;
                        this._labelPosition = this.mcKeyboardIcon.width + TEXT_PADDING_KEYBOARD;
                    }
                    if (this.tfKeyLabel) 
                    {
                        this.tfKeyLabel.visible = false;
                    }
                    if (this.mcClickRect) 
                    {
                        this.mcClickRect.visible = false;
                    }
                }
                this._contentInvalid = false;
                this._gpadIcon.visible = false;
                this.updateText();
                this._currentWidth = this.mcKeyboardIcon.width + textField.width + TEXT_PADDING_PAD + (this._holdDuration > 0 ? this.tfHoldPrefix.width : 0);
            }
            else 
            {
                this._contentInvalid = true;
            }
            this.updateVisibility();
            return;
        }

        protected function getPadIconFrameLabel(arg1:String):String
        {
            var loc1:*=red.game.witcher3.managers.InputManager.getInstance();
            if (!this._dontSwapAcceptCancel && loc1.swapAcceptCancel) 
            {
                if (arg1 == scaleform.clik.constants.NavigationCode.GAMEPAD_A) 
                {
                    return scaleform.clik.constants.NavigationCode.GAMEPAD_B;
                }
                if (arg1 == scaleform.clik.constants.NavigationCode.GAMEPAD_B) 
                {
                    return scaleform.clik.constants.NavigationCode.GAMEPAD_A;
                }
            }
            return arg1;
        }

        protected function SetupGamepadIcon(arg1:String):*
        {
            var loc1:*=null;
            this._gpadIcon.visible = true;
            this._gpadIcon.gotoAndStop(this.getPadIconFrameLabel(arg1));
            this.mcKeyboardIcon.visible = false;
            if (this.mcClickRect) 
            {
                this.mcClickRect.visible = false;
            }
            if (this.tfKeyLabel) 
            {
                this.tfKeyLabel.visible = false;
            }
            this._contentInvalid = false;
            this.updateVisibility();
            loc1 = this._gpadIcon["viewrect"] as flash.display.Sprite;
            this.currentPadIconWidth = loc1 ? loc1.width : this._gpadIcon.width;
            this._labelPosition = this.currentPadIconWidth + TEXT_PADDING_PAD;
            this._gpadIcon.x = Math.round(this.currentPadIconWidth / 2);
            this.updateText();
            this._currentWidth = this.currentPadIconWidth + textField.width + TEXT_PADDING_PAD + (this._holdDuration > 0 ? this.tfHoldPrefix.width : 0);
            if (this._holdIndicator) 
            {
                this._holdIndicator.visible = false;
            }
            this._holdIndicator = this._gpadIcon["holdIndicator"] as flash.display.Sprite;
            if (this._holdIndicator) 
            {
                this._holdIndicator.visible = false;
            }
            return;
        }

        protected function SetHoldButtonText():void
        {
            if (this.tfHoldPrefix && this.tfHoldPrefix.visible) 
            {
                this.tfHoldPrefix.autoSize = flash.text.TextFieldAutoSize.LEFT;
                this.tfHoldPrefix.text = "[[ControlLayout_hold]]";
                if (red.core.CoreComponent.isArabicAligmentMode) 
                {
                    this.tfHoldPrefix.text = "*" + this.tfHoldPrefix.text.toUpperCase() + "*";
                }
                else 
                {
                    this.tfHoldPrefix.text = "[" + this.tfHoldPrefix.text.toUpperCase() + "]";
                }
                this.tfHoldPrefix.width = this.tfHoldPrefix.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                this.tfHoldPrefix.visible = false;
            }
            return;
        }

        public function setData(arg1:red.game.witcher3.data.KeyBindingData, arg2:Boolean, arg3:Boolean=false):void
        {
            var loc1:*=false;
            var loc2:*=null;
            this._bindingData = arg1;
            if (arg3) 
            {
                return;
            }
            if (this._bindingData) 
            {
                loc1 = red.game.witcher3.managers.InputManager.getInstance().getPlatform() == red.game.witcher3.constants.PlatformType.PLATFORM_PS4;
                loc2 = red.game.witcher3.managers.InputManager.getInstance().gamepadType != red.game.witcher3.managers.InputManager.GAMEPAD_TYPE_PS4 ? this.mcIconXbox : this.mcIconPS;
                if (this._gpadIcon && !(this._gpadIcon == loc2)) 
                {
                    this._gpadIcon.visible = false;
                }
                if (this.mcMouseIcon) 
                {
                    this.mcMouseIcon.visible = false;
                }
                this._gpadIcon = loc2;
                this._isGamepad = arg2;
                _label = this._bindingData.label;
                if (this._isGamepad || loc1) 
                {
                    this.displayGamepadIcon();
                    this.mcHoldAnimation.alpha = 1;
                }
                else 
                {
                    this.displayKeyboardIcon();
                    this.mcHoldAnimation.alpha = 0;
                }
            }
            else 
            {
                this._contentInvalid = true;
                this.updateVisibility();
            }
            return;
        }

        public function getBindingData():red.game.witcher3.data.KeyBindingData
        {
            return this._bindingData;
        }

        public function GetIconSize():int
        {
            if (this._gpadIcon.visible) 
            {
                return GPAD_ICON_SIZE;
            }
            if (this.mcKeyboardIcon.visible) 
            {
                return this.mcKeyboardIcon.width;
            }
            return 0;
        }

        public function getViewWidth():Number
        {
            if (this.mcClickRect.visible) 
            {
                return this.mcClickRect.actualWidth;
            }
            return this._currentWidth ? this._currentWidth : width;
        }

        public function setDataFromStage(arg1:String, arg2:int, arg3:int=-1, arg4:Number=0):void
        {
            var loc1:*=red.game.witcher3.managers.InputManager.getInstance();
            loc1.removeEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged);
            loc1.addEventListener(red.game.witcher3.events.ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            this._displayGamepadCode = arg1;
            this._displayGamepadKeyCode = arg3;
            this._displayKeyboardCode = arg2;
            this._dataFromStage = true;
            this.holdDuration = arg4;
            this.updateDataFromStage();
            this.SetHoldButtonText();
            return;
        }

        public function set clickable(arg1:Boolean):void
        {
            this._clickable = arg1;
            return;
        }

        public function get clickable():Boolean
        {
            return this._clickable;
        }

        public override function set visible(arg1:Boolean):void
        {
            this._actualVisibility = arg1;
            this.updateVisibility();
            return;
        }

        public function set holdDuration(arg1:Number):void
        {
            this._holdDuration = arg1;
            scaleform.clik.managers.InputDelegate.getInstance().removeEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleHoldInput, false);
            if (this._holdDuration > 0) 
            {
                this.SetHoldButtonText();
                scaleform.clik.managers.InputDelegate.getInstance().addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleHoldInput, false, 0, true);
            }
            else 
            {
                this.stopHoldAnimation();
            }
            return;
        }

        public function get holdDuration():Number
        {
            return this._holdDuration;
        }

        protected override function configUI():void
        {
            super.configUI();
            this.SetHoldButtonText();
            return;
        }

        protected static const TEXT_PADDING_PAD:Number=1;

        protected static const TEXT_OFFSET:Number=6;

        protected static const KEY_LABEL_PADDING:Number=5;

        protected static const HOLD_INT_MAX_ANGLE:Number=360;

        protected static const HOLD_INT_MAX_FRAME:Number=28;

        protected static const HOLD_INT_FIRST_FRAME:Number=2;

        protected static const DISABLED_ALPHA:Number=0.4;

        protected static const HOLD_ANIM_STEPS_COUNT:Number=30;

        protected static const HOLD_ANIM_INTERVAL:Number=20;

        protected static const CLICKABLE_BK_OFFSET:int=10;

        protected static const INVALIDATE_DISPLAY_DATA:String="invalidate_display_data";

        protected static const GPAD_ICON_SIZE:Number=64;

        protected static const TEXT_PADDING_KEYBOARD:Number=5;

        public var mcIconXbox:flash.display.MovieClip;

        public var mcIconPS:flash.display.MovieClip;

        public var mcKeyboardIcon:red.game.witcher3.controls.KeyboardButtonIcon;

        public var mcMouseIcon:red.game.witcher3.controls.KeyboardButtonMouseIcon;

        public var mcHoldAnimation:flash.display.MovieClip;

        public var mcClickRect:flash.display.MovieClip;

        protected var _holdIndicatorMask:flash.display.Sprite;

        protected var _holdDuration:Number=-1;

        protected var _holdProgress:Number;

        protected var _holdTimer:flash.utils.Timer;

        protected var _labelPosition:Number;

        protected var _clickable:Boolean=true;

        protected var _gpadIcon:flash.display.MovieClip;

        protected var _isGamepad:Boolean;

        protected var _bindingData:red.game.witcher3.data.KeyBindingData;

        protected var _targetViewer:flash.display.DisplayObject;

        protected var _currentWidth:Number;

        public var holdCallback:Function;

        public var tfKeyLabel:flash.text.TextField;

        public var tfHoldPrefix:flash.text.TextField;

        private var _timerActivated:Boolean=false;

        protected var _dontSwapAcceptCancel:Boolean;

        public var addHoldPrefix:Boolean;

        protected var _lowercaseLabels:Boolean=false;

        protected var _actualVisibility:Boolean=true;

        protected var _contentInvalid:Boolean=false;

        protected var _dataFromStage:Boolean;

        protected var _displayKeyboardCode:int=-1;

        protected var _displayGamepadKeyCode:int=-1;

        protected var _displayGamepadCode:String="";

        protected var _overrideTextColor:Number=-1;

        protected var _holdIndicator:flash.display.Sprite;

        protected var currentPadIconWidth:Number;
    }
}
