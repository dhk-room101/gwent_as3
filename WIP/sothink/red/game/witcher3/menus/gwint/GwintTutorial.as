package red.game.witcher3.menus.gwint
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import red.core.constants.*;
    import red.core.events.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;

    public class GwintTutorial extends UIComponent
    {
        public var mcTitleText:TextField;
        public var mcMainText:TextField;
        public var mcMeleeText:TextField;
        public var mcRangeText:TextField;
        public var mcSiegeText:TextField;
        public var mcSecondaryText:TextField;
        public var mcAButtonWrapper:MovieClip;
        private var startupDelayTimer:Timer;
        private var initialDelayActive:Boolean = true;
        public var onHideCallback:Function;
        public var localizedStringsWithIcons:Array = null;
        public var allowX:Boolean = false;
        public var currentTutorialFrame:int = 8;
        public var showCarouselCB:Function;
        public var hideCarouselCB:Function;
        public var changeChoiceCB:Function;
        public var nextFrameRenderer:Boolean = true;
        public var bigSoundPlayed:Boolean = false;
        public var messageQueue:W3MessageQueue;
        private var _isPaused:Boolean = false;
        public static var mSingleton:GwintTutorial;

        public function GwintTutorial()
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            var _loc_1:* = null;
            mouseEnabled = false;
            this.visible = false;
            mSingleton = this;
            super.configUI();
            dispatchEvent(new GameEvent(GameEvent.REGISTER, "gwint.tutorial.strings", [this.onGetTutorialStrings]));
            stage.addEventListener(MouseEvent.CLICK, this.handleClick, false, 0, true);
            mouseChildren = false;
            if (this.mcAButtonWrapper)
            {
                _loc_1 = this.mcAButtonWrapper.getChildByName("mcFeedbackButton") as InputFeedbackButton;
                if (_loc_1)
                {
                    _loc_1.label = "[[panel_continue]]";
                    if (InputManager.getInstance().swapAcceptCancel)
                    {
                        _loc_1.setDataFromStage(NavigationCode.GAMEPAD_B, KeyCode.SPACE);
                    }
                    else
                    {
                        _loc_1.setDataFromStage(NavigationCode.GAMEPAD_A, KeyCode.SPACE);
                    }
                    _loc_1.clickable = true;
                    _loc_1.visible = true;
                    _loc_1.validateNow();
                }
            }
            return;
        }// end function

        public function get active() : Boolean
        {
            return visible && !this._isPaused;
        }// end function

        public function get isPaused() : Boolean
        {
            return this._isPaused;
        }// end function

        public function set isPaused(param1:Boolean) : void
        {
            if (this._isPaused != param1)
            {
                this._isPaused = param1;
                if (visible && this.messageQueue)
                {
                    this.messageQueue.msgsEnabled = this._isPaused;
                }
            }
            return;
        }// end function

        public function OnTutorialShown(param1:Boolean)
        {
            this.nextFrameRenderer = true;
            if (param1)
            {
                if (!this.bigSoundPlayed)
                {
                    this.bigSoundPlayed = true;
                    dispatchEvent(new GameEvent(GameEvent.CALL, "OnPlaySoundEvent", ["gui_tutorial_big_appear"]));
                }
                else
                {
                    dispatchEvent(new GameEvent(GameEvent.CALL, "OnPlaySoundEvent", ["gui_tutorial_notification"]));
                }
            }
            else
            {
                this.bigSoundPlayed = false;
                dispatchEvent(new GameEvent(GameEvent.CALL, "OnPlaySoundEvent", ["gui_tutorial_big_disappear"]));
            }
            return;
        }// end function

        private function updateStartTimer(event:TimerEvent = null) : void
        {
            this.initialDelayActive = false;
            return;
        }// end function

        public function show() : void
        {
            this.visible = true;
            if (this.startupDelayTimer == null && this.initialDelayActive)
            {
                this.startupDelayTimer = new Timer(600, 0);
                this.startupDelayTimer.addEventListener(TimerEvent.TIMER, this.updateStartTimer);
                this.startupDelayTimer.start();
            }
            this.OnTutorialShown(true);
            if (this.messageQueue)
            {
                this.messageQueue.msgsEnabled = false;
            }
            InputFeedbackManager.cleanupButtons();
            gotoAndStop(1);
            return;
        }// end function

        public function continueTutorial() : void
        {
            nextFrame();
            this.isPaused = false;
            this.hideCarousel();
            return;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            super.visible = param1;
            mouseEnabled = param1;
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            if (this.isPaused || !visible)
            {
                return;
            }
            super.handleInput(event);
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_UP;
            if (_loc_3 && !event.handled)
            {
                switch(_loc_2.navEquivalent)
                {
                    case NavigationCode.GAMEPAD_X:
                    {
                        if (!this.allowX)
                        {
                            break;
                        }
                    }
                    case NavigationCode.GAMEPAD_A:
                    case NavigationCode.ENTER:
                    {
                        event.handled = true;
                        this.incrementTutorial();
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        protected function handleClick(event:MouseEvent) : void
        {
            if (this.isPaused || !visible)
            {
                return;
            }
            var _loc_2:* = event as MouseEventEx;
            if (_loc_2.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
                event.stopImmediatePropagation();
                this.incrementTutorial();
            }
            return;
        }// end function

        protected function incrementTutorial() : void
        {
            if (!this.nextFrameRenderer || this.initialDelayActive)
            {
                return;
            }
            Console.WriteLine("GFX Marcin ", this.currentTutorialFrame, totalFrames);
            if (this.currentTutorialFrame <= totalFrames)
            {
                this.nextFrameRenderer = false;
                var _loc_1:* = this;
                var _loc_2:* = this.currentTutorialFrame + 1;
                _loc_1.currentTutorialFrame = _loc_2;
                nextFrame();
            }
            else
            {
                this.hide();
            }
            return;
        }// end function

        protected function hide() : void
        {
            this.visible = false;
            this.OnTutorialShown(false);
            if (this.messageQueue)
            {
                this.messageQueue.msgsEnabled = true;
            }
            if (this.onHideCallback != null)
            {
                this.onHideCallback();
            }
            return;
        }// end function

        public function showCarousel() : void
        {
            if (this.showCarouselCB != null)
            {
                this.showCarouselCB();
            }
            return;
        }// end function

        public function hideCarousel() : void
        {
            if (this.hideCarouselCB != null)
            {
                this.hideCarouselCB();
            }
            return;
        }// end function

        public function showCardAtIndex(param1:int) : void
        {
            Console.WriteLine("GFX showCardAtIndex", this.changeChoiceCB);
            if (this.changeChoiceCB != null)
            {
                this.changeChoiceCB(param1);
            }
            return;
        }// end function

        protected function onGetTutorialStrings(param1:Array) : void
        {
            this.localizedStringsWithIcons = param1;
            if (currentFrame == 1 && this.localizedStringsWithIcons.length > 0 && this.mcMainText != null)
            {
                this.mcMainText.htmlText = this.localizedStringsWithIcons[0];
            }
            return;
        }// end function

    }
}
