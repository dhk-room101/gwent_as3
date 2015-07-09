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

    public class InputFeedbackButton extends Button
    {
        public var mcIconXbox:MovieClip;
        public var mcIconPS:MovieClip;
        public var mcKeyboardIcon:KeyboardButtonIcon;
        public var mcMouseIcon:KeyboardButtonMouseIcon;
        public var mcHoldAnimation:MovieClip;
        public var mcClickRect:MovieClip;
        public var tfHoldPrefix:TextField;
        public var tfKeyLabel:TextField;
        public var holdCallback:Function;
        public var addHoldPrefix:Boolean;
        protected var _currentWidth:Number;
        protected var _targetViewer:DisplayObject;
        protected var _bindingData:KeyBindingData;
        protected var _isGamepad:Boolean;
        protected var _gpadIcon:MovieClip;
        protected var _clickable:Boolean = true;
        protected var _labelPosition:Number;
        protected var _holdTimer:Timer;
        protected var _holdProgress:Number;
        protected var _holdDuration:Number = -1;
        protected var _holdIndicatorMask:Sprite;
        protected var _holdIndicator:Sprite;
        protected var _displayGamepadCode:String = "";
        protected var _displayGamepadKeyCode:int = -1;
        protected var _displayKeyboardCode:int = -1;
        protected var _dataFromStage:Boolean;
        protected var _contentInvalid:Boolean = false;
        protected var _actualVisibility:Boolean = true;
        protected var _lowercaseLabels:Boolean = false;
        protected var _overrideTextColor:Number = -1;
        protected var _dontSwapAcceptCancel:Boolean;
        private var _timerActivated:Boolean = false;
        protected var currentPadIconWidth:Number;
        static const HOLD_ANIM_STEPS_COUNT:Number = 30;
        static const HOLD_ANIM_INTERVAL:Number = 20;
        static const DISABLED_ALPHA:Object = 0.4;
        static const CLICKABLE_BK_OFFSET:Object = 10;
        static const INVALIDATE_DISPLAY_DATA:String = "invalidate_display_data";
        static const GPAD_ICON_SIZE:Number = 64;
        static const TEXT_PADDING_KEYBOARD:Number = 5;
        static const TEXT_PADDING_PAD:Number = 1;
        static const TEXT_OFFSET:Number = 6;
        static const KEY_LABEL_PADDING:Number = 5;
        static const HOLD_INT_MAX_ANGLE:Number = 360;
        static const HOLD_INT_MAX_FRAME:Number = 28;
        static const HOLD_INT_FIRST_FRAME:Number = 2;

        public function InputFeedbackButton()
        {
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
                var _loc_1:* = false;
                this.mcIconXbox.visible = false;
                this.mcIconPS.visible = _loc_1;
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
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            this.SetHoldButtonText();
            return;
        }// end function

        public function get dontSwapAcceptCancel() : Boolean
        {
            return this._dontSwapAcceptCancel;
        }// end function

        public function set dontSwapAcceptCancel(param1:Boolean) : void
        {
            this._dontSwapAcceptCancel = param1;
            return;
        }// end function

        public function get overrideTextColor() : Number
        {
            return this._overrideTextColor;
        }// end function

        public function set overrideTextColor(param1:Number) : void
        {
            this._overrideTextColor = param1;
            return;
        }// end function

        public function get lowercaseLabels() : Boolean
        {
            return this._lowercaseLabels;
        }// end function

        public function set lowercaseLabels(param1:Boolean) : void
        {
            this._lowercaseLabels = param1;
            return;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            this._actualVisibility = param1;
            this.updateVisibility();
            return;
        }// end function

        public function get holdDuration() : Number
        {
            return this._holdDuration;
        }// end function

        public function set holdDuration(param1:Number) : void
        {
            this._holdDuration = param1;
            InputDelegate.getInstance().removeEventListener(InputEvent.INPUT, this.handleHoldInput, false);
            if (this._holdDuration > 0)
            {
                this.SetHoldButtonText();
                InputDelegate.getInstance().addEventListener(InputEvent.INPUT, this.handleHoldInput, false, 0, true);
            }
            else
            {
                this.stopHoldAnimation();
            }
            return;
        }// end function

        public function get clickable() : Boolean
        {
            return this._clickable;
        }// end function

        public function set clickable(param1:Boolean) : void
        {
            this._clickable = param1;
            return;
        }// end function

        public function setDataFromStage(param1:String, param2:int, param3:int = -1, param4:Number = 0) : void
        {
            var _loc_5:* = InputManager.getInstance();
            _loc_5.removeEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged);
            _loc_5.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE, this.handleControllerChanged, false, 0, true);
            this._displayGamepadCode = param1;
            this._displayGamepadKeyCode = param3;
            this._displayKeyboardCode = param2;
            this._dataFromStage = true;
            this.holdDuration = param4;
            this.updateDataFromStage();
            this.SetHoldButtonText();
            return;
        }// end function

        public function getViewWidth() : Number
        {
            if (this.mcClickRect.visible)
            {
                return this.mcClickRect.actualWidth;
            }
            return this._currentWidth ? (this._currentWidth) : (width);
        }// end function

        public function GetIconSize() : int
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
        }// end function

        public function getBindingData() : KeyBindingData
        {
            return this._bindingData;
        }// end function

        public function setData(param1:KeyBindingData, param2:Boolean, param3:Boolean = false) : void
        {
            var _loc_4:* = false;
            var _loc_5:* = null;
            this._bindingData = param1;
            if (param3)
            {
                return;
            }
            if (this._bindingData)
            {
                _loc_4 = InputManager.getInstance().getPlatform() == PlatformType.PLATFORM_PS4;
                _loc_5 = InputManager.getInstance().gamepadType == InputManager.GAMEPAD_TYPE_PS4 ? (this.mcIconPS) : (this.mcIconXbox);
                if (this._gpadIcon && this._gpadIcon != _loc_5)
                {
                    this._gpadIcon.visible = false;
                }
                if (this.mcMouseIcon)
                {
                    this.mcMouseIcon.visible = false;
                }
                this._gpadIcon = _loc_5;
                this._isGamepad = param2;
                _label = this._bindingData.label;
                if (this._isGamepad || _loc_4)
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
        }// end function

        public function displayGamepadIcon() : void
        {
            var _loc_3:* = null;
            var _loc_1:* = this._bindingData.gamepad_navEquivalent;
            var _loc_2:* = this._bindingData.gamepad_keyCode;
            this.updateText();
            if (_loc_1)
            {
                this.SetupGamepadIcon(_loc_1);
            }
            else if (_loc_2 > 0)
            {
                _loc_3 = InputDelegate.getInstance();
                _loc_1 = _loc_3.inputToNav("key", _loc_2);
                this.SetupGamepadIcon(_loc_1);
            }
            else
            {
                this._contentInvalid = true;
                this.updateVisibility();
            }
            return;
        }// end function

        protected function SetHoldButtonText() : void
        {
            if (this.tfHoldPrefix && this.tfHoldPrefix.visible)
            {
                this.tfHoldPrefix.autoSize = TextFieldAutoSize.LEFT;
                this.tfHoldPrefix.text = "[[ControlLayout_hold]]";
                if (!CoreComponent.isArabicAligmentMode)
                {
                    this.tfHoldPrefix.text = "[" + this.tfHoldPrefix.text.toUpperCase() + "]";
                }
                else
                {
                    this.tfHoldPrefix.text = "*" + this.tfHoldPrefix.text.toUpperCase() + "*";
                }
                this.tfHoldPrefix.width = this.tfHoldPrefix.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                this.tfHoldPrefix.visible = false;
            }
            return;
        }// end function

        protected function SetupGamepadIcon(param1:String)
        {
            var _loc_2:* = null;
            this._gpadIcon.visible = true;
            this._gpadIcon.gotoAndStop(this.getPadIconFrameLabel(param1));
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
            _loc_2 = this._gpadIcon["viewrect"] as Sprite;
            this.currentPadIconWidth = _loc_2 ? (_loc_2.width) : (this._gpadIcon.width);
            this._labelPosition = this.currentPadIconWidth + TEXT_PADDING_PAD;
            this._gpadIcon.x = Math.round(this.currentPadIconWidth / 2);
            this.updateText();
            this._currentWidth = this.currentPadIconWidth + textField.width + TEXT_PADDING_PAD + (this._holdDuration > 0 ? (this.tfHoldPrefix.width) : (0));
            if (this._holdIndicator)
            {
                this._holdIndicator.visible = false;
            }
            this._holdIndicator = this._gpadIcon["holdIndicator"] as Sprite;
            if (this._holdIndicator)
            {
                this._holdIndicator.visible = false;
            }
            return;
        }// end function

        protected function getPadIconFrameLabel(param1:String) : String
        {
            var _loc_2:* = InputManager.getInstance();
            if (!this._dontSwapAcceptCancel && _loc_2.swapAcceptCancel)
            {
                if (param1 == NavigationCode.GAMEPAD_A)
                {
                    return NavigationCode.GAMEPAD_B;
                }
                if (param1 == NavigationCode.GAMEPAD_B)
                {
                    return NavigationCode.GAMEPAD_A;
                }
            }
            return param1;
        }// end function

        protected function displayKeyboardIcon() : void
        {
            var _loc_2:* = null;
            var _loc_1:* = this._bindingData.keyboard_keyCode;
            if (_loc_1 > 0)
            {
                _loc_2 = KeyboardKeys.getKeyLabel(_loc_1);
                if (!this.clickable)
                {
                    if (this.mcMouseIcon && this.mcMouseIcon.isMouseKey(_loc_1))
                    {
                        this.mcMouseIcon.visible = true;
                        this.mcMouseIcon.keyCode = _loc_1;
                        this._labelPosition = this.mcMouseIcon.width + TEXT_PADDING_KEYBOARD;
                    }
                    else
                    {
                        this.mcKeyboardIcon.visible = true;
                        this.mcKeyboardIcon.label = _loc_2;
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
                else
                {
                    if (this.tfKeyLabel)
                    {
                        this.tfKeyLabel.x = KEY_LABEL_PADDING;
                        this.tfKeyLabel.visible = true;
                        if (!CoreComponent.isArabicAligmentMode)
                        {
                            this.tfKeyLabel.text = _loc_2;
                            this.tfKeyLabel.text = "[" + CommonUtils.toUpperCaseSafe(this.tfKeyLabel.text) + "]";
                        }
                        else
                        {
                            this.tfKeyLabel.text = "*" + CommonUtils.toUpperCaseSafe(_loc_2) + "*";
                        }
                        this.tfKeyLabel.width = this.tfKeyLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                        this._labelPosition = this.tfKeyLabel.x + this.tfKeyLabel.textWidth + TEXT_PADDING_KEYBOARD;
                    }
                    if (this.mcClickRect)
                    {
                        this.mcClickRect.visible = true;
                    }
                }
                this._contentInvalid = false;
                this._gpadIcon.visible = false;
                this.updateText();
                this._currentWidth = this.mcKeyboardIcon.width + textField.width + TEXT_PADDING_PAD + (this._holdDuration > 0 ? (this.tfHoldPrefix.width) : (0));
            }
            else
            {
                this._contentInvalid = true;
            }
            this.updateVisibility();
            return;
        }// end function

        protected function updateDataFromStage() : void
        {
            var _loc_1:* = null;
            if (this._displayGamepadCode || this._displayKeyboardCode > 0 || this._displayGamepadKeyCode > 0)
            {
                _loc_1 = new KeyBindingData();
                _loc_1.actionId = 0;
                _loc_1.gamepad_navEquivalent = this._displayGamepadCode;
                _loc_1.keyboard_keyCode = this._displayKeyboardCode;
                _loc_1.gamepad_keyCode = this._displayGamepadKeyCode;
                _loc_1.label = label ? (label) : ("");
                this._isGamepad = InputManager.getInstance().isGamepad();
                this._dataFromStage = true;
                this.setData(_loc_1, this._isGamepad);
                this.stopHoldAnimation();
            }
            return;
        }// end function

        protected function updateVisibility() : void
        {
            var _loc_1:* = this._actualVisibility && !this._contentInvalid;
            if (super.visible != _loc_1)
            {
                super.visible = _loc_1;
                this.UpdateHoldAnimation();
            }
            return;
        }// end function

        protected function handleControllerChanged(event:ControllerChangeEvent) : void
        {
            if (this._dataFromStage)
            {
                this.SetHoldButtonText();
                this.updateDataFromStage();
            }
            return;
        }// end function

        override protected function updateText() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            if (this.tfHoldPrefix)
            {
                if ((this.holdDuration > 0 || this.addHoldPrefix) && _label && textField)
                {
                    this.SetHoldButtonText();
                    this.tfHoldPrefix.textColor = this._overrideTextColor > -1 ? (this._overrideTextColor) : (16777215);
                    this.tfHoldPrefix.autoSize = TextFieldAutoSize.LEFT;
                    this.tfHoldPrefix.visible = true;
                    this.tfHoldPrefix.width = this.tfHoldPrefix.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                    this.tfHoldPrefix.x = this._labelPosition;
                    textField.x = this._labelPosition + this.tfHoldPrefix.width;
                }
                else
                {
                    this.tfHoldPrefix.visible = false;
                    textField.x = this._labelPosition;
                }
            }
            if (_label != null && textField != null)
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
                    textField.text = CommonUtils.toLowerCaseExSafe(textField.text);
                }
                textField.width = textField.textWidth + TEXT_OFFSET;
                if (this.mcClickRect && this.mcClickRect.visible)
                {
                    _loc_1 = this.mcClickRect as KeyboardButtonClickArea;
                    if (_loc_1)
                    {
                        _loc_1.state = state;
                        _loc_1.setActualSize(CLICKABLE_BK_OFFSET + textField.x + textField.width, this.mcClickRect.height);
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
                _loc_2 = CommonUtils.getDesaturateFilter();
                this.filters = [_loc_2];
                alpha = DISABLED_ALPHA;
            }
            return;
        }// end function

        private function SpawnHoldAnimationMask() : void
        {
            if (this._holdIndicatorMask == null)
            {
                this._holdIndicatorMask = new Sprite();
                this._holdIndicatorMask.x = this._holdIndicator.x + this._holdIndicator.width / 2;
                this._holdIndicatorMask.y = this._holdIndicator.y;
                addChild(this._holdIndicatorMask);
                this._holdIndicator.mask = this._holdIndicatorMask;
            }
            return;
        }// end function

        public function startHoldAnimation() : void
        {
            if (!this._holdIndicator)
            {
                Console.WriteLine("GFX Can\'t find _holdIndicator in the InputFeedbackButton ", parent);
                return;
            }
            if (this._holdTimer)
            {
                return;
            }
            this.stopHoldAnimation();
            if (!this.mcHoldAnimation)
            {
                this.SpawnHoldAnimationMask();
            }
            else
            {
                this.mcHoldAnimation.visible = true;
                this.mcHoldAnimation.gotoAndStop("Idle");
            }
            this._holdTimer = new Timer(HOLD_ANIM_INTERVAL);
            this._holdTimer.addEventListener(TimerEvent.TIMER, this.handleHoldTimer, false, 0, true);
            this._holdTimer.start();
            this._holdProgress = 0;
            return;
        }// end function

        protected function stopHoldAnimation() : void
        {
            if (this._holdTimer)
            {
                this._timerActivated = false;
                this._holdTimer.removeEventListener(TimerEvent.TIMER, this.handleHoldTimer, false);
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
        }// end function

        protected function handleHoldTimer(event:TimerEvent) : void
        {
            var _loc_2:* = this.mcHoldAnimation ? (HOLD_INT_MAX_FRAME) : (HOLD_INT_MAX_ANGLE);
            if (this._holdProgress > _loc_2)
            {
                this.stopHoldAnimation();
                if (this.holdCallback != null && !this._timerActivated)
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
        }// end function

        protected function UpdateHoldAnimation()
        {
            var _loc_1:* = NaN;
            var _loc_2:* = NaN;
            if (!this._holdIndicator || !this._holdIndicatorMask && !this.mcHoldAnimation || this.mcHoldAnimation && !this.mcHoldAnimation.visible || !visible)
            {
                return;
            }
            var _loc_3:* = this.mcHoldAnimation ? (HOLD_INT_MAX_FRAME) : (HOLD_INT_MAX_ANGLE);
            _loc_1 = _loc_3 / (this._holdDuration / HOLD_ANIM_INTERVAL);
            this._holdProgress = this._holdProgress + _loc_1;
            _loc_2 = Math.min(_loc_3, this._holdProgress);
            if (_loc_2 > 0)
            {
                if (this.mcHoldAnimation)
                {
                    this.mcHoldAnimation.visible = true;
                    this.mcHoldAnimation.gotoAndStop(HOLD_INT_FIRST_FRAME + _loc_2);
                }
                else
                {
                    this._holdIndicator.visible = true;
                    this._holdIndicatorMask.visible = true;
                    this._holdIndicatorMask.graphics.clear();
                    CommonUtils.drawPie(this._holdIndicatorMask.graphics, this._holdIndicator.width, HOLD_ANIM_STEPS_COUNT, 0, _loc_2);
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
        }// end function

        public function handleHoldInput(event:InputEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_5:* = null;
            if (!event.handled && this._holdDuration > 0 && this._bindingData)
            {
                _loc_2 = InputManager.getInstance();
                _loc_3 = event.details;
                _loc_4 = _loc_3.code;
                _loc_5 = _loc_3.navEquivalent;
                if (_loc_2.swapAcceptCancel)
                {
                    if (_loc_5 == NavigationCode.GAMEPAD_A)
                    {
                        _loc_5 = NavigationCode.GAMEPAD_B;
                        _loc_4 = KeyCode.PAD_B_CIRCLE;
                    }
                    else if (_loc_5 == NavigationCode.GAMEPAD_B)
                    {
                        _loc_5 = NavigationCode.GAMEPAD_A;
                        _loc_4 = KeyCode.PAD_A_CROSS;
                    }
                }
                if (_loc_5 == this._bindingData.gamepad_navEquivalent || _loc_4 == this._bindingData.keyboard_keyCode || _loc_4 == this._bindingData.gamepad_keyCode)
                {
                    if (visible)
                    {
                        if (_loc_3.value == InputValue.KEY_DOWN && !this._holdTimer)
                        {
                            this.startHoldAnimation();
                        }
                        else if (_loc_3.value == InputValue.KEY_UP && this._holdTimer)
                        {
                            this.stopHoldAnimation();
                        }
                    }
                }
            }
            return;
        }// end function

        override public function toString() : String
        {
            return "InputFeedbackButton [" + this.name + "] _bindingData: " + this._bindingData;
        }// end function

    }
}
