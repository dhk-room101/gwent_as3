package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    import flash.events.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;
    
    public class HumanPlayerController extends red.game.witcher3.menus.gwint.BasePlayerController
    {
        public function HumanPlayerController()
        {
            super();
            _stateMachine.AddState("Idle", this.state_begin_Idle, this.on_state_about_to_update, this.state_end_Idle);
            _stateMachine.AddState("ChoosingCard", this.state_begin_ChoosingCard, this.state_update_ChoosingCard, this.state_end_ChoosingCard);
            _stateMachine.AddState("ChoosingHandler", this.state_begin_ChoosingHandler, this.state_update_ChoosingHandler, null);
            _stateMachine.AddState("ChoosingTargetCard", this.state_begin_ChoosingTargetCard, this.state_update_ChoosingTargetCard, null);
            _stateMachine.AddState("WaitConfirmation", this.state_begin_WaitConfirmation, this.state_update_WaitConfirmation, null);
            _stateMachine.AddState("ApplyingCard", this.state_begin_ApplyingCard, this.state_update_ApplyingCard, null);
            return;
        }

        protected function zoomCardToTransaction(arg1:int=0):void
        {
            if (arg1 != -1) 
            {
                startCardTransaction(arg1);
            }
            this.closeZoomCB(arg1);
            return;
        }

        protected function closeZoomCB(arg1:int=0):void
        {
            var loc1:*=null;
            var loc2:*=null;
            if (this._currentZoomedHolder) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_preview_card");
                if (this._skipButton) 
                {
                    this._skipButton.visible = false;
                }
                if (this.mcChoiceDialog.visible) 
                {
                    this.mcChoiceDialog.hideDialog();
                }
                this.resetToDefaultButtons();
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID);
                loc2 = _boardRenderer.getSelectedCardHolder();
                if (_stateMachine.currentState == "ChoosingCard" && (this._currentZoomedHolder.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND || this._currentZoomedHolder.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER && this._currentZoomedHolder.playerID == red.game.witcher3.menus.gwint.CardManager.PLAYER_1 && loc1 && loc1.canBeUsed)) 
                {
                    red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.apply, scaleform.clik.constants.NavigationCode.GAMEPAD_A, red.core.constants.KeyCode.ENTER, "panel_button_common_select");
                }
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.zoomCard, scaleform.clik.constants.NavigationCode.GAMEPAD_R2, red.core.constants.KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
                if (loc1 && loc1.canBeUsed) 
                {
                    red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.leaderCard, scaleform.clik.constants.NavigationCode.GAMEPAD_X, red.core.constants.KeyCode.X, "gwint_use_leader");
                }
                this.mcChoiceDialog.cardsCarousel.removeEventListener(scaleform.clik.events.ListEvent.INDEX_CHANGE, this.onCarouselSelectionChanged, false);
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.navigate, scaleform.clik.constants.NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                this._currentZoomedHolder = null;
            }
            return;
        }

        public function attachToTutorialCarouselMessage():void
        {
            if (red.game.witcher3.menus.gwint.GwintTutorial.mSingleton) 
            {
                red.game.witcher3.menus.gwint.GwintTutorial.mSingleton.hideCarouselCB = this.closeZoomCB;
            }
            return;
        }

        public override function set boardRenderer(arg1:red.game.witcher3.menus.gwint.GwintBoardRenderer):void
        {
            if (!(_boardRenderer == arg1) && arg1) 
            {
                arg1.addEventListener(red.game.witcher3.events.GwintCardEvent.CARD_CHOSEN, this.handleCardChosen, false, 0, true);
                arg1.addEventListener(red.game.witcher3.events.GwintCardEvent.CARD_SELECTED, this.handleCardSelected, false, 0, true);
                arg1.addEventListener(red.game.witcher3.events.GwintHolderEvent.HOLDER_CHOSEN, this.handleHolderChosen, false, 0, true);
                arg1.addEventListener(red.game.witcher3.events.GwintHolderEvent.HOLDER_SELECTED, this.handleHolderSelected, false, 0, true);
                this._handHolder = arg1.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, playerID);
            }
            super.boardRenderer = arg1;
            return;
        }

        public function setChoiceDialog(arg1:red.game.witcher3.controls.W3ChoiceDialog):void
        {
            this.mcChoiceDialog = arg1;
            return;
        }

        protected function onCarouselSelectionChanged(arg1:scaleform.clik.events.ListEvent):void
        {
            if (this._currentZoomedHolder) 
            {
                this._currentZoomedHolder.selectedCardIdx = arg1.index;
            }
            return;
        }

        public function get skipButton():red.game.witcher3.controls.InputFeedbackButton
        {
            return this._skipButton;
        }

        public function set skipButton(arg1:red.game.witcher3.controls.InputFeedbackButton):void
        {
            this._skipButton = arg1;
            if (this._skipButton) 
            {
                this._skipButton.holdCallback = this.handleSkipTurn;
                if (_stateMachine.currentState != "ChoosingCard") 
                {
                    this._skipButton.visible = false;
                }
                else 
                {
                    this._skipButton.visible = true;
                }
                this._skipButton.addEventListener(flash.events.MouseEvent.CLICK, this.handleSkipTurn, false, 0, true);
            }
            return;
        }

        private function handleSkipTurn(arg1:flash.events.MouseEvent=null):void
        {
            this.skipTurn();
            return;
        }

        public override function startTurn():void
        {
            if (red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, playerID).length == 0 && !red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID).canBeUsed) 
            {
                currentRoundStatus = red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE;
            }
            else 
            {
                super.startTurn();
                _stateMachine.ChangeState("ChoosingCard");
            }
            return;
        }

        public override function skipTurn():void
        {
            if (_stateMachine.currentState == "ChoosingCard" && this._currentZoomedHolder == null) 
            {
                currentRoundStatus = red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE;
                _turnOver = true;
                if (_transactionCard != null) 
                {
                    _boardRenderer.activateAllHolders(true);
                    _boardRenderer.selectCard(_transactionCard);
                    declineCardTransaction();
                }
                _stateMachine.ChangeState("Idle");
            }
            return;
        }

        public override function set cardZoomEnabled(arg1:Boolean):*
        {
            super.cardZoomEnabled = arg1;
            if (!arg1 && !(this._currentZoomedHolder == null)) 
            {
                this.closeZoomCB();
            }
            return;
        }

        protected function on_state_about_to_update():void
        {
            if (this._currentZoomedHolder && !this.mcChoiceDialog.visible) 
            {
                this.closeZoomCB();
            }
            return;
        }

        protected function state_begin_Idle():void
        {
            _decidedCardTransaction = null;
            if (_boardRenderer) 
            {
                _boardRenderer.activateAllHolders(true);
                if (this._handHolder && !(_boardRenderer.getSelectedCardHolder() == this._handHolder)) 
                {
                    _boardRenderer.selectCardHolderAdv(this._handHolder);
                }
                _boardRenderer.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER, red.game.witcher3.menus.gwint.CardManager.PLAYER_1).updateLeaderStatus(false);
            }
            declineCardTransaction();
            if (!red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.mcTutorials.visible && this._currentZoomedHolder == null) 
            {
                this.resetToDefaultButtons();
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.navigate, scaleform.clik.constants.NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                if (_boardRenderer && !(_boardRenderer.getSelectedCard() == null) && cardZoomEnabled) 
                {
                    red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.zoomCard, scaleform.clik.constants.NavigationCode.GAMEPAD_R2, red.core.constants.KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
                }
            }
            return;
        }

        protected function state_end_Idle():void
        {
            if (_boardRenderer) 
            {
                if (_boardRenderer.getSelectedCardHolder() != this._handHolder) 
                {
                    _boardRenderer.selectCardHolderAdv(this._handHolder);
                }
                _boardRenderer.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER, red.game.witcher3.menus.gwint.CardManager.PLAYER_1).updateLeaderStatus(true);
            }
            return;
        }

        protected function state_begin_ChoosingCard():void
        {
            var loc1:*=null;
            if (this._skipButton) 
            {
                this._skipButton.visible = true;
            }
            if (this._currentZoomedHolder == null) 
            {
                this.resetToDefaultButtons();
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.navigate, scaleform.clik.constants.NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID);
                if (loc1 && loc1.canBeUsed) 
                {
                    red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.leaderCard, scaleform.clik.constants.NavigationCode.GAMEPAD_X, red.core.constants.KeyCode.X, "gwint_use_leader");
                }
                if (this._handHolder.cardSlotsList.length > 0) 
                {
                    red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.apply, scaleform.clik.constants.NavigationCode.GAMEPAD_A, red.core.constants.KeyCode.ENTER, "panel_button_common_select");
                }
                if (!(_boardRenderer.getSelectedCard() == null) && cardZoomEnabled) 
                {
                    red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.zoomCard, scaleform.clik.constants.NavigationCode.GAMEPAD_R2, red.core.constants.KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
                }
            }
            return;
        }

        protected function state_update_ChoosingCard():void
        {
            var loc1:*=null;
            var loc2:*=false;
            var loc3:*=false;
            var loc4:*=false;
            this.on_state_about_to_update();
            if (_transactionCard) 
            {
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                loc2 = loc1 is red.game.witcher3.menus.gwint.CardLeaderInstance;
                loc3 = loc1.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy);
                loc4 = loc1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Global_Effect);
                if (loc2 || loc4) 
                {
                    _stateMachine.ChangeState("WaitConfirmation");
                }
                else if (loc3) 
                {
                    _stateMachine.ChangeState("ChoosingTargetCard");
                }
                else 
                {
                    _stateMachine.ChangeState("ChoosingHandler");
                }
            }
            return;
        }

        protected function state_end_ChoosingCard():void
        {
            if (this._skipButton) 
            {
                this._skipButton.visible = false;
            }
            return;
        }

        protected function state_begin_ChoosingTargetCard():void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            if (_transactionCard && _boardRenderer) 
            {
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                _boardRenderer.activateHoldersForCard(loc1, true);
            }
            if (this._currentZoomedHolder == null) 
            {
                this.resetToDefaultButtons();
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.navigate, scaleform.clik.constants.NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.cancel, scaleform.clik.constants.NavigationCode.GAMEPAD_B, red.core.constants.KeyCode.ESCAPE, "panel_common_cancel");
                loc2 = _boardRenderer.getSelectedCardHolder();
                if (loc2.cardSelectionEnabled && loc2.cardSlotsList.length > 0 && !(loc2.getSelectedCardSlot() == null)) 
                {
                    loc3 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                    loc4 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(loc2.getSelectedCardSlot().instanceId);
                    if (loc3.canBeCastOn(loc4)) 
                    {
                        red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.apply, scaleform.clik.constants.NavigationCode.GAMEPAD_A, red.core.constants.KeyCode.ENTER, "panel_common_apply");
                    }
                }
            }
            return;
        }

        protected function state_update_ChoosingTargetCard():void
        {
            this.on_state_about_to_update();
            return;
        }

        protected function state_begin_ChoosingHandler():void
        {
            var loc1:*=null;
            if (_transactionCard && _boardRenderer) 
            {
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                boardRenderer.activateHoldersForCard(loc1, true);
            }
            if (this._currentZoomedHolder == null) 
            {
                this.resetToDefaultButtons();
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.apply, scaleform.clik.constants.NavigationCode.GAMEPAD_A, red.core.constants.KeyCode.ENTER, "panel_common_apply");
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.cancel, scaleform.clik.constants.NavigationCode.GAMEPAD_B, red.core.constants.KeyCode.ESCAPE, "panel_common_cancel");
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.navigate, scaleform.clik.constants.NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
            }
            return;
        }

        protected function state_update_ChoosingHandler():void
        {
            this.on_state_about_to_update();
            return;
        }

        protected function state_begin_WaitConfirmation():void
        {
            this._cardConfirmation = false;
            if (this._currentZoomedHolder == null) 
            {
                this.resetToDefaultButtons();
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.cancel, scaleform.clik.constants.NavigationCode.GAMEPAD_B, red.core.constants.KeyCode.ESCAPE, "panel_common_cancel");
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.apply, scaleform.clik.constants.NavigationCode.GAMEPAD_A, red.core.constants.KeyCode.ENTER, "panel_common_apply");
            }
            return;
        }

        protected function state_update_WaitConfirmation():void
        {
            this.on_state_about_to_update();
            if (this._cardConfirmation && _transactionCard) 
            {
                this._cardConfirmation = false;
                _decidedCardTransaction = new red.game.witcher3.menus.gwint.CardTransaction();
                _decidedCardTransaction.targetPlayerID = playerID;
                _decidedCardTransaction.sourceCardInstanceRef = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                _stateMachine.ChangeState("ApplyingCard");
            }
            return;
        }

        protected override function cardEffectApplying():Boolean
        {
            return super.cardEffectApplying() || this.mcChoiceDialog.visible;
        }

        protected override function state_begin_ApplyingCard():void
        {
            super.state_begin_ApplyingCard();
            _boardRenderer.activateAllHolders(true);
            if (this._handHolder && !(_boardRenderer.getSelectedCardHolder() == this._handHolder)) 
            {
                _boardRenderer.selectCardHolderAdv(this._handHolder);
            }
            return;
        }

        protected override function state_update_ApplyingCard():void
        {
            this.on_state_about_to_update();
            if (!red.game.witcher3.menus.gwint.CardTweenManager.getInstance().isAnyCardMoving() && !gameFlowControllerRef.mcMessageQueue.ShowingMessage() && !red.game.witcher3.menus.gwint.CardFXManager.getInstance().isPlayingAnyCardFX() && !this.mcChoiceDialog.visible) 
            {
                _turnOver = true;
                _stateMachine.ChangeState("Idle");
            }
            return;
        }

        protected function handleCardSelected(arg1:red.game.witcher3.events.GwintCardEvent):void
        {
            var loc1:*=null;
            var loc2:*=null;
            if (!(this._currentZoomedHolder == null) || this.mcChoiceDialog.visible) 
            {
                return;
            }
            trace("GFX handleCardSelected <", _stateMachine.currentState, "> ", arg1.cardSlot);
            if (arg1.cardSlot) 
            {
                var loc3:*=_stateMachine.currentState;
            }
            if (!(_boardRenderer.getSelectedCard() == null) && cardZoomEnabled && !this.mcChoiceDialog.visible && !(_stateMachine.currentState == "ChoosingTargetCard") && !(_stateMachine.currentState == "ChoosingHandler")) 
            {
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.zoomCard, scaleform.clik.constants.NavigationCode.GAMEPAD_R2, red.core.constants.KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
            }
            else 
            {
                red.game.witcher3.managers.InputFeedbackManager.removeButtonById(red.game.witcher3.constants.GwintInputFeedback.zoomCard);
            }
            return;
        }

        protected function handleHolderSelected(arg1:red.game.witcher3.events.GwintHolderEvent):void
        {
            var loc1:*=null;
            var loc2:*=null;
            if (!(this._currentZoomedHolder == null) || this.mcChoiceDialog.visible) 
            {
                return;
            }
            trace("GFX handleHolderSelected <", _stateMachine.currentState, "> ", _transactionCard, arg1.cardHolder);
            var loc3:*=_stateMachine.currentState;
        }

        protected function handleCardChosen(arg1:red.game.witcher3.events.GwintCardEvent):void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            if (this._currentZoomedHolder != null) 
            {
                return;
            }
            trace("GFX handleCardChosen <", _stateMachine.currentState, "> ", arg1.cardSlot);
            if (arg1.cardSlot) 
            {
                var loc5:*=_stateMachine.currentState;
            }
            return;
        }

        protected function handleHolderChosen(arg1:red.game.witcher3.events.GwintHolderEvent):void
        {
            var loc1:*=null;
            trace("GFX handleHolderChosen <", _stateMachine.currentState, "> ", _transactionCard, arg1.cardHolder);
            if (_transactionCard && _stateMachine.currentState == "ChoosingHandler") 
            {
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                _decidedCardTransaction = new red.game.witcher3.menus.gwint.CardTransaction();
                _decidedCardTransaction.targetPlayerID = arg1.cardHolder.playerID;
                _decidedCardTransaction.targetSlotID = arg1.cardHolder.cardHolderID;
                _decidedCardTransaction.targetCardInstanceRef = null;
                _decidedCardTransaction.sourceCardInstanceRef = loc1;
                _stateMachine.ChangeState("ApplyingCard");
            }
            return;
        }

        public override function handleUserInput(arg1:scaleform.clik.events.InputEvent):void
        {
            if (!inputEnabled) 
            {
                return;
            }
            if (_boardRenderer && this._currentZoomedHolder == null && (_transactionCard == null || !(red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID) == _transactionCard.cardInstance))) 
            {
                _boardRenderer.handleInputPreset(arg1);
            }
            if (!arg1.handled) 
            {
                this.processUserInput(arg1);
            }
            return;
        }

        public override function handleMouseMove(arg1:flash.events.MouseEvent):void
        {
            if (!inputEnabled) 
            {
                return;
            }
            if (_boardRenderer && this._currentZoomedHolder == null && (_transactionCard == null || !(red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID) == _transactionCard.cardInstance))) 
            {
                _boardRenderer.handleMouseMove(arg1);
            }
            return;
        }

        public override function handleMouseClick(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=null;
            if (_boardRenderer && this._currentZoomedHolder == null) 
            {
                loc1 = arg1 as scaleform.gfx.MouseEventEx;
                if (loc1.buttonIdx != scaleform.gfx.MouseEventEx.LEFT_BUTTON) 
                {
                    if (loc1.buttonIdx == scaleform.gfx.MouseEventEx.RIGHT_BUTTON && !red.game.witcher3.menus.gwint.CardTweenManager.getInstance().isAnyCardMoving()) 
                    {
                        if (_transactionCard != null) 
                        {
                            _boardRenderer.activateAllHolders(true);
                            declineCardTransaction();
                            _stateMachine.ChangeState("ChoosingCard");
                        }
                        else if (_stateMachine.currentState == "Idle" || _stateMachine.currentState == "ChoosingCard") 
                        {
                            if (this._currentZoomedHolder != null) 
                            {
                                this.closeZoomCB(-1);
                                arg1.stopImmediatePropagation();
                            }
                            else 
                            {
                                this.tryStartZoom();
                                if (this.mcChoiceDialog.visible) 
                                {
                                    this.mcChoiceDialog.ignoreNextRightClick = true;
                                }
                            }
                        }
                    }
                }
                else if (_stateMachine.currentState != "WaitConfirmation") 
                {
                    _boardRenderer.handleLeftClick(arg1);
                }
                else 
                {
                    this._cardConfirmation = true;
                }
            }
            return;
        }

        protected function processUserInput(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_UP;
            var loc3:*=loc1.navEquivalent;
            if (red.game.witcher3.menus.gwint.CardTweenManager.getInstance().isAnyCardMoving()) 
            {
                return;
            }
            if (loc2 && !arg1.handled) 
            {
                if (this._currentZoomedHolder) 
                {
                    if (loc3 == scaleform.clik.constants.NavigationCode.GAMEPAD_R2) 
                    {
                        this.closeZoomCB();
                    }
                }
                else 
                {
                    var loc4:*=loc3;
                    switch (loc4) 
                    {
                        case scaleform.clik.constants.NavigationCode.GAMEPAD_A:
                        {
                            if (_stateMachine.currentState == "WaitConfirmation" && !(loc1.code == red.core.constants.KeyCode.SPACE)) 
                            {
                                this._cardConfirmation = true;
                            }
                            break;
                        }
                        case scaleform.clik.constants.NavigationCode.GAMEPAD_B:
                        {
                            if (_transactionCard) 
                            {
                                _boardRenderer.activateAllHolders(true);
                                _boardRenderer.selectCard(_transactionCard);
                                declineCardTransaction();
                                arg1.handled = true;
                                _stateMachine.ChangeState("ChoosingCard");
                            }
                            break;
                        }
                        case scaleform.clik.constants.NavigationCode.GAMEPAD_X:
                        {
                            this.tryPutLeaderInTransaction();
                            break;
                        }
                        case scaleform.clik.constants.NavigationCode.GAMEPAD_R2:
                        {
                            if (_stateMachine.currentState == "Idle" || _stateMachine.currentState == "ChoosingCard") 
                            {
                                this.tryStartZoom();
                            }
                        }
                    }
                    loc4 = loc1.code;
                    switch (loc4) 
                    {
                        case red.core.constants.KeyCode.X:
                        {
                            this.tryPutLeaderInTransaction();
                            break;
                        }
                    }
                }
                if (!arg1.handled && !this.mcChoiceDialog.visible && loc1.code == red.core.constants.KeyCode.ESCAPE) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.tryQuitGame();
                }
            }
            return;
        }

        protected function tryPutLeaderInTransaction():void
        {
            var loc1:*=null;
            if (_stateMachine.currentState == "ChoosingCard" && _transactionCard == null) 
            {
                loc1 = red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID);
                if (loc1) 
                {
                    if (loc1.canBeUsed) 
                    {
                        startCardTransaction(loc1.instanceId);
                    }
                }
                else 
                {
                    throw new Error("GFX [ERROR] - The leader card for player: " + playerID + " is not the correct type");
                }
            }
            return;
        }

        protected function resetToDefaultButtons():void
        {
            red.game.witcher3.managers.InputFeedbackManager.cleanupButtons();
            red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.quitGame, scaleform.clik.constants.NavigationCode.START, red.core.constants.KeyCode.Q, "gwint_pass_game");
            if (_stateMachine.currentState == "ChoosingCard") 
            {
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.endTurn, scaleform.clik.constants.NavigationCode.GAMEPAD_Y, -1, "qwint_skip_turn");
                if (this._skipButton) 
                {
                    this._skipButton.visible = true;
                }
            }
            return;
        }

        protected function tryStartZoom():void
        {
            var loc1:*=null;
            var loc2:*=0;
            if (this._currentZoomedHolder || !cardZoomEnabled) 
            {
                return;
            }
            if (_boardRenderer.getSelectedCardHolder() && _boardRenderer.getSelectedCardHolder().cardSlotsList.length > 0) 
            {
                this._currentZoomedHolder = _boardRenderer.getSelectedCardHolder();
            }
            if (this._currentZoomedHolder.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND && this._currentZoomedHolder.playerID == red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
            {
                this._currentZoomedHolder = null;
                return;
            }
            if (this._currentZoomedHolder) 
            {
                if (this._currentZoomedHolder.selectedCardIdx == -1) 
                {
                    return;
                }
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_preview_card");
                red.game.witcher3.managers.InputFeedbackManager.cleanupButtons();
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.quitGame, scaleform.clik.constants.NavigationCode.START, red.core.constants.KeyCode.Q, "gwint_pass_game");
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.navigate, scaleform.clik.constants.NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.zoomCard, scaleform.clik.constants.NavigationCode.GAMEPAD_R2, red.core.constants.KeyCode.RIGHT_MOUSE, "panel_button_common_close");
                if (this._skipButton) 
                {
                    this._skipButton.visible = false;
                }
                loc1 = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
                loc2 = 0;
                while (loc2 < this._currentZoomedHolder.cardSlotsList.length) 
                {
                    loc1.push(this._currentZoomedHolder.cardSlotsList[loc2].cardInstance);
                    ++loc2;
                }
                if (_stateMachine.currentState == "ChoosingCard" && (this._currentZoomedHolder.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND && this._currentZoomedHolder.playerID == red.game.witcher3.menus.gwint.CardManager.PLAYER_1 || this._currentZoomedHolder.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER && this._currentZoomedHolder.playerID == red.game.witcher3.menus.gwint.CardManager.PLAYER_1 && red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(red.game.witcher3.menus.gwint.CardManager.PLAYER_1).canBeUsed)) 
                {
                    this.mcChoiceDialog.showDialogCardInstances(loc1, this.zoomCardToTransaction, this.closeZoomCB, "");
                }
                else 
                {
                    this.mcChoiceDialog.showDialogCardInstances(loc1, null, this.closeZoomCB, "");
                }
                this.mcChoiceDialog.cardsCarousel.validateNow();
                this.mcChoiceDialog.cardsCarousel.addEventListener(scaleform.clik.events.ListEvent.INDEX_CHANGE, this.onCarouselSelectionChanged, false, 0, true);
                if (this._currentZoomedHolder.selectedCardIdx != -1) 
                {
                    this.mcChoiceDialog.cardsCarousel.selectedIndex = this._currentZoomedHolder.selectedCardIdx;
                }
            }
            return;
        }

        protected var _handHolder:red.game.witcher3.menus.gwint.GwintCardHolder;

        protected var mcChoiceDialog:red.game.witcher3.controls.W3ChoiceDialog;

        protected var _currentZoomedHolder:red.game.witcher3.menus.gwint.GwintCardHolder=null;

        protected var _skipButton:red.game.witcher3.controls.InputFeedbackButton;

        protected var _cardConfirmation:Boolean;
    }
}
