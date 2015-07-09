package red.game.witcher3.controls
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.menus.gwint.*;
    import red.game.witcher3.slots.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;

    public class W3ChoiceDialog extends UIComponent
    {
        public var txtCarouselMessage:TextField;
        public var mcCarouselMsgBackground:MovieClip;
        public var cardsCarousel:SlotsListCarousel;
        public var mcTooltip:MovieClip;
        public var mcBackground:Sprite;
        private var _choices:Array;
        private var _sourceList:Array;
        private var _acceptCallback:Function;
        private var _declineCallback:Function;
        private var _shown:Boolean;
        public var ignoreNextRightClick:Boolean = false;
        protected var _inputEnabled:Boolean = true;

        public function W3ChoiceDialog()
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            this.txtCarouselMessage.text = "";
            InputDelegate.getInstance().addEventListener(InputEvent.INPUT, this.handleInputCustom, false, 0, true);
            this.cardsCarousel.addEventListener(ListEvent.INDEX_CHANGE, this.onCarouselSelectionChanged, false, 0, true);
            stage.addEventListener(MouseEvent.CLICK, this.handleStageClick, false, 1, true);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.OnMouseWheel, false, 0, true);
            this.cardsCarousel.addEventListener(CardSlot.CardMouseDoubleClick, this.OnCardMouseDoubleClick, false, 0, true);
            return;
        }// end function

        public function showDialogCardInstances(param1:Vector.<CardInstance>, param2:Function, param3:Function, param4:String) : void
        {
            var _loc_6:* = 0;
            var _loc_5:* = new Array();
            _loc_6 = 0;
            while (_loc_6 < param1.length)
            {
                
                _loc_5.Count(param1[_loc_6]);
                _loc_6++;
            }
            this.showDialog(_loc_5, param2, param3, param4);
            return;
        }// end function

        public function showDialogCardTemplates(param1:Vector.<int>, param2:Function, param3:Function, param4:String) : void
        {
            var _loc_6:* = 0;
            var _loc_5:* = new Array();
            _loc_6 = 0;
            while (_loc_6 < param1.length)
            {
                
                _loc_5.Count(param1[_loc_6]);
                _loc_6++;
            }
            this.showDialog(_loc_5, param2, param3, param4);
            return;
        }// end function

        public function showDialog(param1:Array, param2:Function, param3:Function, param4:String) : void
        {
            if (!this._shown)
            {
                this._shown = true;
                var _loc_5:* = true;
                this.visible = true;
                enabled = _loc_5;
            }
            this._acceptCallback = param2;
            this._declineCallback = param3;
            this._sourceList = param1;
            this.cardsCarousel.data = this._sourceList;
            this.cardsCarousel.focused = 1;
            this.cardsCarousel.validateNow();
            if (this.cardsCarousel.selectedIndex == -1)
            {
                this.cardsCarousel.selectedIndex = 0;
            }
            else if (this.cardsCarousel.selectedIndex > param1.length)
            {
                this.cardsCarousel.selectedIndex = param1.length - 1;
            }
            this.cardsCarousel.validateNow();
            this.updateTooltip(this.cardsCarousel.getSelectedRenderer() as CardSlot);
            this.updateDialogText(param4);
            this.updateInputFeedback();
            this.inputEnabled = true;
            return;
        }// end function

        public function set inputEnabled(param1:Boolean) : void
        {
            this._inputEnabled = param1;
            this.cardsCarousel.inputEnabled = param1;
            return;
        }// end function

        public function updateDialogText(param1:String) : void
        {
            if (this.txtCarouselMessage)
            {
                this.txtCarouselMessage.text = param1;
            }
            if (this.txtCarouselMessage.text == "")
            {
                this.mcCarouselMsgBackground.visible = false;
            }
            else
            {
                this.mcCarouselMsgBackground.visible = true;
            }
            return;
        }// end function

        public function appendDialogText(param1:String) : void
        {
            if (this.txtCarouselMessage)
            {
                this.txtCarouselMessage.appendText(param1);
            }
            if (this.txtCarouselMessage.text == "")
            {
                this.mcCarouselMsgBackground.visible = false;
            }
            else
            {
                this.mcCarouselMsgBackground.visible = true;
            }
            return;
        }// end function

        public function hideDialog() : void
        {
            if (this._shown)
            {
                this._shown = false;
                this.cardsCarousel.focused = 0;
                var _loc_1:* = false;
                this.visible = false;
                enabled = _loc_1;
                this.txtCarouselMessage.text = "";
            }
            InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
            InputFeedbackManager.removeButtonById(GwintInputFeedback.cancel);
            return;
        }// end function

        override public function set visible(param1:Boolean) : void
        {
            super.visible = param1;
            mouseEnabled = param1;
            mouseChildren = param1;
            return;
        }// end function

        public function replaceCard(param1:CardInstance, param2:CardInstance) : void
        {
            this.cardsCarousel.replaceItem(param1, param2);
            this.updateTooltip(this.cardsCarousel.getSelectedRenderer() as CardSlot);
            return;
        }// end function

        private function handleDialogShown(param1:GTween) : void
        {
            return;
        }// end function

        private function handleDialogHidden(param1:GTween) : void
        {
            var _loc_2:* = false;
            this.visible = false;
            enabled = _loc_2;
            return;
        }// end function

        public function isShown() : Boolean
        {
            return this._shown;
        }// end function

        private function handleInputCustom(event:InputEvent) : void
        {
            if (!this._inputEnabled)
            {
                return;
            }
            super.handleInput(event);
            if (event.handled || !this._shown)
            {
                return;
            }
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_UP;
            if (_loc_3)
            {
                switch(_loc_2.navEquivalent)
                {
                    case NavigationCode.GAMEPAD_A:
                    {
                        this.applyChoice();
                        event.handled = true;
                        break;
                    }
                    case NavigationCode.GAMEPAD_B:
                    {
                        this.cancelChoice();
                        event.handled = true;
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

        private function applyChoice() : void
        {
            var _loc_1:* = null;
            if (this._shown && this._acceptCallback != null)
            {
                this.cardsCarousel.validateNow();
                _loc_1 = this.cardsCarousel.getRendererAt(this.cardsCarousel.selectedIndex) as CardSlot;
                if (_loc_1 && _loc_1.activateEnabled)
                {
                    if (_loc_1.instanceId != -1)
                    {
                        this._acceptCallback(_loc_1.instanceId);
                    }
                    else
                    {
                        this._acceptCallback(_loc_1.cardIndex);
                    }
                }
            }
            return;
        }// end function

        private function cancelChoice() : void
        {
            if (this._declineCallback != null)
            {
                this._declineCallback();
            }
            return;
        }// end function

        protected function onCarouselSelectionChanged(event:ListEvent) : void
        {
            var _loc_2:* = this.cardsCarousel.getRendererAt(event.index) as CardSlot;
            this.updateTooltip(_loc_2);
            this.updateInputFeedback();
            return;
        }// end function

        protected function updateInputFeedback() : void
        {
            var _loc_1:* = this._acceptCallback != null;
            var _loc_2:* = this.cardsCarousel.getSelectedRenderer() as CardSlot;
            if (_loc_2 && _loc_1 && !_loc_2.activateEnabled)
            {
                _loc_1 = false;
            }
            if (_loc_1)
            {
                InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_button_common_select");
            }
            else
            {
                InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
            }
            if (this._declineCallback != null)
            {
                InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel, NavigationCode.GAMEPAD_B, KeyCode.ESCAPE, "panel_common_cancel");
            }
            else
            {
                InputFeedbackManager.removeButtonById(GwintInputFeedback.cancel);
            }
            return;
        }// end function

        protected function updateTooltip(param1:CardSlot) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            var _loc_7:* = null;
            var _loc_2:* = CardManager.getInstance();
            var _loc_3:* = null;
            if (param1)
            {
                _loc_3 = _loc_2.getCardTemplate(param1.cardIndex);
            }
            else if (this.cardsCarousel.data.length > 0)
            {
                if (this.cardsCarousel.data[0] is CardInstance)
                {
                    _loc_3 = (this.cardsCarousel.data[0] as CardInstance).templateRef;
                }
                else if (this.cardsCarousel.data[0] is int)
                {
                    _loc_3 = _loc_2.getCardTemplate(this.cardsCarousel.data[0]);
                }
            }
            if (_loc_3)
            {
                if (this.mcTooltip && _loc_2)
                {
                    _loc_4 = _loc_3.tooltipString;
                    _loc_5 = this.mcTooltip.getChildByName("txtTooltipTitle") as TextField;
                    _loc_6 = this.mcTooltip.getChildByName("txtTooltip") as TextField;
                    if (_loc_4 == "" || !_loc_5 || !_loc_6)
                    {
                        this.mcTooltip.visible = false;
                    }
                    else
                    {
                        this.mcTooltip.visible = true;
                        if (_loc_3.index >= 1000)
                        {
                            _loc_5.text = "[[gwint_leader_ability]]";
                        }
                        else
                        {
                            _loc_5.text = "[[" + _loc_4 + "_title]]";
                        }
                        _loc_6.text = "[[" + _loc_4 + "]]";
                        _loc_7 = this.mcTooltip.getChildByName("mcTooltipIcon") as MovieClip;
                        if (_loc_7)
                        {
                            _loc_7.gotoAndStop(_loc_3.tooltipIcon);
                        }
                    }
                }
            }
            else
            {
                this.mcTooltip.visible = false;
            }
            return;
        }// end function

        protected function handleStageClick(event:MouseEvent) : void
        {
            if (!this._shown)
            {
                return;
            }
            var _loc_2:* = event as MouseEventEx;
            if (_loc_2.buttonIdx == MouseEventEx.RIGHT_BUTTON && !GwintTutorial.mSingleton.active)
            {
                if (!this.ignoreNextRightClick)
                {
                    this.cancelChoice();
                }
                else
                {
                    this.ignoreNextRightClick = false;
                }
            }
            return;
        }// end function

        public function OnMouseWheel(event:MouseEvent)
        {
            if (!this._shown)
            {
                return;
            }
            if (event.delta > 0)
            {
                this.cardsCarousel.navigateLeft();
            }
            else
            {
                this.cardsCarousel.navigateRight();
            }
            return;
        }// end function

        public function OnCardMouseDoubleClick(event:Event)
        {
            this.applyChoice();
            return;
        }// end function

    }
}
