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
    
    public class GwintTutorial extends scaleform.clik.core.UIComponent
    {
        public function GwintTutorial()
        {
            super();
            return;
        }

        protected override function configUI():void
        {
            var loc1:*=null;
            mouseEnabled = false;
            this.visible = false;
            mSingleton = this;
            super.configUI();
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "gwint.tutorial.strings", [this.onGetTutorialStrings]));
            stage.addEventListener(flash.events.MouseEvent.CLICK, this.handleClick, false, 0, true);
            mouseChildren = false;
            if (this.mcAButtonWrapper) 
            {
                loc1 = this.mcAButtonWrapper.getChildByName("mcFeedbackButton") as red.game.witcher3.controls.InputFeedbackButton;
                if (loc1) 
                {
                    loc1.label = "[[panel_continue]]";
                    if (red.game.witcher3.managers.InputManager.getInstance().swapAcceptCancel) 
                    {
                        loc1.setDataFromStage(scaleform.clik.constants.NavigationCode.GAMEPAD_B, red.core.constants.KeyCode.SPACE);
                    }
                    else 
                    {
                        loc1.setDataFromStage(scaleform.clik.constants.NavigationCode.GAMEPAD_A, red.core.constants.KeyCode.SPACE);
                    }
                    loc1.clickable = true;
                    loc1.visible = true;
                    loc1.validateNow();
                }
            }
            return;
        }

        public function get active():Boolean
        {
            return visible && !this._isPaused;
        }

        public function get isPaused():Boolean
        {
            return this._isPaused;
        }

        public function set isPaused(arg1:Boolean):void
        {
            if (this._isPaused != arg1) 
            {
                this._isPaused = arg1;
                if (visible && this.messageQueue) 
                {
                    this.messageQueue.msgsEnabled = this._isPaused;
                }
            }
            return;
        }

        public function OnTutorialShown(arg1:Boolean):*
        {
            this.nextFrameRenderer = true;
            if (arg1) 
            {
                if (this.bigSoundPlayed) 
                {
                    dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPlaySoundEvent", ["gui_tutorial_notification"]));
                }
                else 
                {
                    this.bigSoundPlayed = true;
                    dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPlaySoundEvent", ["gui_tutorial_big_appear"]));
                }
            }
            else 
            {
                this.bigSoundPlayed = false;
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPlaySoundEvent", ["gui_tutorial_big_disappear"]));
            }
            return;
        }

        private function updateStartTimer(arg1:flash.events.TimerEvent=null):void
        {
            this.initialDelayActive = false;
            return;
        }

        public function show():void
        {
            this.visible = true;
            if (this.startupDelayTimer == null && this.initialDelayActive) 
            {
                this.startupDelayTimer = new flash.utils.Timer(600, 0);
                this.startupDelayTimer.addEventListener(flash.events.TimerEvent.TIMER, this.updateStartTimer);
                this.startupDelayTimer.start();
            }
            this.OnTutorialShown(true);
            if (this.messageQueue) 
            {
                this.messageQueue.msgsEnabled = false;
            }
            red.game.witcher3.managers.InputFeedbackManager.cleanupButtons();
            gotoAndStop(1);
            return;
        }

        public function continueTutorial():void
        {
            nextFrame();
            this.isPaused = false;
            this.hideCarousel();
            return;
        }

        public override function set visible(arg1:Boolean):void
        {
            super.visible = arg1;
            mouseEnabled = arg1;
            return;
        }

        public override function handleInput(arg1:scaleform.clik.events.InputEvent):void
        {
            if (this.isPaused || !visible) 
            {
                return;
            }
            super.handleInput(arg1);
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_UP;
            if (loc2 && !arg1.handled) 
            {
                var loc3:*=loc1.navEquivalent;
                switch (loc3) 
                {
                    case scaleform.clik.constants.NavigationCode.GAMEPAD_X:
                    {
                        if (!this.allowX) 
                        {
                            break;
                        }
                    }
                    case scaleform.clik.constants.NavigationCode.GAMEPAD_A:
                    case scaleform.clik.constants.NavigationCode.ENTER:
                    {
                        arg1.handled = true;
                        this.incrementTutorial();
                        break;
                    }
                }
            }
            return;
        }

        protected function handleClick(arg1:flash.events.MouseEvent):void
        {
            if (this.isPaused || !visible) 
            {
                return;
            }
            var loc1:*=arg1 as scaleform.gfx.MouseEventEx;
            if (loc1.buttonIdx == scaleform.gfx.MouseEventEx.LEFT_BUTTON) 
            {
                arg1.stopImmediatePropagation();
                this.incrementTutorial();
            }
            return;
        }

        protected function incrementTutorial():void
        {
            if (!this.nextFrameRenderer || this.initialDelayActive) 
            {
                return;
            }
            trace("GFX Marcin ", this.currentTutorialFrame, totalFrames);
            if (this.currentTutorialFrame <= totalFrames) 
            {
                this.nextFrameRenderer = false;
                var loc1:*;
                var loc2:*=((loc1 = this).currentTutorialFrame + 1);
                loc1.currentTutorialFrame = loc2;
                nextFrame();
            }
            else 
            {
                this.hide();
            }
            return;
        }

        protected function hide():void
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
        }

        public function showCarousel():void
        {
            if (this.showCarouselCB != null) 
            {
                this.showCarouselCB();
            }
            return;
        }

        public function hideCarousel():void
        {
            if (this.hideCarouselCB != null) 
            {
                this.hideCarouselCB();
            }
            return;
        }

        public function showCardAtIndex(arg1:int):void
        {
            trace("GFX showCardAtIndex", this.changeChoiceCB);
            if (this.changeChoiceCB != null) 
            {
                this.changeChoiceCB(arg1);
            }
            return;
        }

        protected function onGetTutorialStrings(arg1:Array):void
        {
            this.localizedStringsWithIcons = arg1;
            if (currentFrame == 1 && this.localizedStringsWithIcons.length > 0 && !(this.mcMainText == null)) 
            {
                this.mcMainText.htmlText = this.localizedStringsWithIcons[0];
            }
            return;
        }

        public var bigSoundPlayed:Boolean=false;

        public var messageQueue:red.game.witcher3.controls.W3MessageQueue;

        public var mcTitleText:flash.text.TextField;

        public var mcMainText:flash.text.TextField;

        private var _isPaused:Boolean=false;

        public var mcMeleeText:flash.text.TextField;

        public var mcRangeText:flash.text.TextField;

        public var mcSiegeText:flash.text.TextField;

        public var mcSecondaryText:flash.text.TextField;

        public var mcAButtonWrapper:flash.display.MovieClip;

        private var startupDelayTimer:flash.utils.Timer;

        private var initialDelayActive:Boolean=true;

        public var onHideCallback:Function;

        public var localizedStringsWithIcons:Array=null;

        public var allowX:Boolean=false;

        public var currentTutorialFrame:int=8;

        public var showCarouselCB:Function;

        public var hideCarouselCB:Function;

        public var changeChoiceCB:Function;

        public var nextFrameRenderer:Boolean=true;

        public static var mSingleton:red.game.witcher3.menus.gwint.GwintTutorial;
    }
}
