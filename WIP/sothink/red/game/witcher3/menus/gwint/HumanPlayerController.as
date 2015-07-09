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

    public class HumanPlayerController extends BasePlayerController
    {
        protected var _handHolder:GwintCardHolder;
        protected var mcChoiceDialog:W3ChoiceDialog;
        protected var _currentZoomedHolder:GwintCardHolder = null;
        protected var _skipButton:InputFeedbackButton;
        protected var _cardConfirmation:Boolean;

        public function HumanPlayerController()
        {
            _stateMachine.AddState("Idle", this.state_begin_Idle, this.on_state_about_to_update, this.state_end_Idle);
            _stateMachine.AddState("ChoosingCard", this.state_begin_ChoosingCard, this.state_update_ChoosingCard, this.state_end_ChoosingCard);
            _stateMachine.AddState("ChoosingHandler", this.state_begin_ChoosingHandler, this.state_update_ChoosingHandler, null);
            _stateMachine.AddState("ChoosingTargetCard", this.state_begin_ChoosingTargetCard, this.state_update_ChoosingTargetCard, null);
            _stateMachine.AddState("WaitConfirmation", this.state_begin_WaitConfirmation, this.state_update_WaitConfirmation, null);
            _stateMachine.AddState("ApplyingCard", this.state_begin_ApplyingCard, this.state_update_ApplyingCard, null);
            return;
        }// end function

        override public function set boardRenderer(param1:GwintBoardRenderer) : void
        {
            if (_boardRenderer != param1 && param1)
            {
                param1.addEventListener(GwintCardEvent.CARD_CHOSEN, this.handleCardChosen, false, 0, true);
                param1.addEventListener(GwintCardEvent.CARD_SELECTED, this.handleCardSelected, false, 0, true);
                param1.addEventListener(GwintHolderEvent.HOLDER_CHOSEN, this.handleHolderChosen, false, 0, true);
                param1.addEventListener(GwintHolderEvent.HOLDER_SELECTED, this.handleHolderSelected, false, 0, true);
                this._handHolder = param1.getCardHolder(CardManager.CARD_LIST_LOC_HAND, playerID);
            }
            super.boardRenderer = param1;
            return;
        }// end function

        public function setChoiceDialog(param1:W3ChoiceDialog) : void
        {
            this.mcChoiceDialog = param1;
            return;
        }// end function

        public function get skipButton() : InputFeedbackButton
        {
            return this._skipButton;
        }// end function

        public function set skipButton(param1:InputFeedbackButton) : void
        {
            this._skipButton = param1;
            if (this._skipButton)
            {
                this._skipButton.holdCallback = this.handleSkipTurn;
                if (_stateMachine.currentState == "ChoosingCard")
                {
                    this._skipButton.visible = true;
                }
                else
                {
                    this._skipButton.visible = false;
                }
                this._skipButton.addEventListener(MouseEvent.CLICK, this.handleSkipTurn, false, 0, true);
            }
            return;
        }// end function

        private function handleSkipTurn(event:MouseEvent = null) : void
        {
            this.skipTurn();
            return;
        }// end function

        override public function startTurn() : void
        {
            if (CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, playerID).length == 0 && !CardManager.getInstance().getCardLeader(playerID).canBeUsed)
            {
                currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
            }
            else
            {
                super.startTurn();
                _stateMachine.ChangeState("ChoosingCard");
            }
            return;
        }// end function

        override public function skipTurn() : void
        {
            if (_stateMachine.currentState == "ChoosingCard" && this._currentZoomedHolder == null)
            {
                currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
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
        }// end function

        override public function set cardZoomEnabled(param1:Boolean)
        {
            super.cardZoomEnabled = param1;
            if (!param1 && this._currentZoomedHolder != null)
            {
                this.closeZoomCB();
            }
            return;
        }// end function

        protected function on_state_about_to_update() : void
        {
            if (this._currentZoomedHolder && !this.mcChoiceDialog.visible)
            {
                this.closeZoomCB();
            }
            return;
        }// end function

        protected function state_begin_Idle() : void
        {
            _decidedCardTransaction = null;
            if (_boardRenderer)
            {
                _boardRenderer.activateAllHolders(true);
                if (this._handHolder && _boardRenderer.getSelectedCardHolder() != this._handHolder)
                {
                    _boardRenderer.selectCardHolderAdv(this._handHolder);
                }
                _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER, CardManager.PLAYER_1).updateLeaderStatus(false);
            }
            declineCardTransaction();
            if (!GwintGameMenu.mSingleton.mcTutorials.visible && this._currentZoomedHolder == null)
            {
                this.resetToDefaultButtons();
                InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate, NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                if (_boardRenderer && _boardRenderer.getSelectedCard() != null && cardZoomEnabled)
                {
                    InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard, NavigationCode.GAMEPAD_R2, KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
                }
            }
            return;
        }// end function

        protected function state_end_Idle() : void
        {
            if (_boardRenderer)
            {
                if (_boardRenderer.getSelectedCardHolder() != this._handHolder)
                {
                    _boardRenderer.selectCardHolderAdv(this._handHolder);
                }
                _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER, CardManager.PLAYER_1).updateLeaderStatus(true);
            }
            return;
        }// end function

        protected function state_begin_ChoosingCard() : void
        {
            var _loc_1:* = null;
            if (this._skipButton)
            {
                this._skipButton.visible = true;
            }
            if (this._currentZoomedHolder == null)
            {
                this.resetToDefaultButtons();
                InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate, NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                _loc_1 = CardManager.getInstance().getCardLeader(playerID);
                if (_loc_1 && _loc_1.canBeUsed)
                {
                    InputFeedbackManager.appendButtonById(GwintInputFeedback.leaderCard, NavigationCode.GAMEPAD_X, KeyCode.X, "gwint_use_leader");
                }
                if (this._handHolder.cardSlotsList.length > 0)
                {
                    InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_button_common_select");
                }
                if (_boardRenderer.getSelectedCard() != null && cardZoomEnabled)
                {
                    InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard, NavigationCode.GAMEPAD_R2, KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
                }
            }
            return;
        }// end function

        protected function state_update_ChoosingCard() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = false;
            var _loc_3:* = false;
            var _loc_4:* = false;
            this.on_state_about_to_update();
            if (_transactionCard)
            {
                _loc_1 = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                _loc_2 = _loc_1 is CardLeaderInstance;
                _loc_3 = _loc_1.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy);
                _loc_4 = _loc_1.templateRef.isType(CardTemplate.CardType_Global_Effect);
                if (_loc_2 || _loc_4)
                {
                    _stateMachine.ChangeState("WaitConfirmation");
                }
                else if (_loc_3)
                {
                    _stateMachine.ChangeState("ChoosingTargetCard");
                }
                else
                {
                    _stateMachine.ChangeState("ChoosingHandler");
                }
            }
            return;
        }// end function

        protected function state_end_ChoosingCard() : void
        {
            if (this._skipButton)
            {
                this._skipButton.visible = false;
            }
            return;
        }// end function

        protected function state_begin_ChoosingTargetCard() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            if (_transactionCard && _boardRenderer)
            {
                _loc_1 = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                _boardRenderer.activateHoldersForCard(_loc_1, true);
            }
            if (this._currentZoomedHolder == null)
            {
                this.resetToDefaultButtons();
                InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate, NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel, NavigationCode.GAMEPAD_B, KeyCode.ESCAPE, "panel_common_cancel");
                _loc_2 = _boardRenderer.getSelectedCardHolder();
                if (_loc_2.cardSelectionEnabled && _loc_2.cardSlotsList.length > 0 && _loc_2.getSelectedCardSlot() != null)
                {
                    _loc_3 = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                    _loc_4 = CardManager.getInstance().getCardInstance(_loc_2.getSelectedCardSlot().instanceId);
                    if (_loc_3.canBeCastOn(_loc_4))
                    {
                        InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_common_apply");
                    }
                }
            }
            return;
        }// end function

        protected function state_update_ChoosingTargetCard() : void
        {
            this.on_state_about_to_update();
            return;
        }// end function

        protected function state_begin_ChoosingHandler() : void
        {
            var _loc_1:* = null;
            if (_transactionCard && _boardRenderer)
            {
                _loc_1 = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                boardRenderer.activateHoldersForCard(_loc_1, true);
            }
            if (this._currentZoomedHolder == null)
            {
                this.resetToDefaultButtons();
                InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_common_apply");
                InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel, NavigationCode.GAMEPAD_B, KeyCode.ESCAPE, "panel_common_cancel");
                InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate, NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
            }
            return;
        }// end function

        protected function state_update_ChoosingHandler() : void
        {
            this.on_state_about_to_update();
            return;
        }// end function

        protected function state_begin_WaitConfirmation() : void
        {
            this._cardConfirmation = false;
            if (this._currentZoomedHolder == null)
            {
                this.resetToDefaultButtons();
                InputFeedbackManager.appendButtonById(GwintInputFeedback.cancel, NavigationCode.GAMEPAD_B, KeyCode.ESCAPE, "panel_common_cancel");
                InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_common_apply");
            }
            return;
        }// end function

        protected function state_update_WaitConfirmation() : void
        {
            this.on_state_about_to_update();
            if (this._cardConfirmation && _transactionCard)
            {
                this._cardConfirmation = false;
                _decidedCardTransaction = new CardTransaction();
                _decidedCardTransaction.targetPlayerID = playerID;
                _decidedCardTransaction.sourceCardInstanceRef = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                _stateMachine.ChangeState("ApplyingCard");
            }
            return;
        }// end function

        override protected function cardEffectApplying() : Boolean
        {
            return super.cardEffectApplying() || this.mcChoiceDialog.visible;
        }// end function

        override protected function state_begin_ApplyingCard() : void
        {
            super.state_begin_ApplyingCard();
            _boardRenderer.activateAllHolders(true);
            if (this._handHolder && _boardRenderer.getSelectedCardHolder() != this._handHolder)
            {
                _boardRenderer.selectCardHolderAdv(this._handHolder);
            }
            return;
        }// end function

        override protected function state_update_ApplyingCard() : void
        {
            this.on_state_about_to_update();
            if (!CardTweenManager.getInstance().isAnyCardMoving() && !gameFlowControllerRef.mcMessageQueue.ShowingMessage() && !CardFXManager.getInstance().isPlayingAnyCardFX() && !this.mcChoiceDialog.visible)
            {
                _turnOver = true;
                _stateMachine.ChangeState("Idle");
            }
            return;
        }// end function

        protected function handleCardSelected(event:GwintCardEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this._currentZoomedHolder != null || this.mcChoiceDialog.visible)
            {
                return;
            }
            Console.WriteLine("GFX handleCardSelected <", _stateMachine.currentState, "> ", event.cardSlot);
            if (event.cardSlot)
            {
                switch(_stateMachine.currentState)
                {
                    case "ChoosingTargetCard":
                    {
                        _loc_2 = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                        _loc_3 = CardManager.getInstance().getCardInstance(event.cardSlot.instanceId);
                        if (_loc_2.canBeCastOn(_loc_3))
                        {
                            InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_common_apply");
                        }
                        else
                        {
                            InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
                        }
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            if (_boardRenderer.getSelectedCard() != null && cardZoomEnabled && !this.mcChoiceDialog.visible && _stateMachine.currentState != "ChoosingTargetCard" && _stateMachine.currentState != "ChoosingHandler")
            {
                InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard, NavigationCode.GAMEPAD_R2, KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
            }
            else
            {
                InputFeedbackManager.removeButtonById(GwintInputFeedback.zoomCard);
            }
            return;
        }// end function

        protected function handleHolderSelected(event:GwintHolderEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this._currentZoomedHolder != null || this.mcChoiceDialog.visible)
            {
                return;
            }
            Console.WriteLine("GFX handleHolderSelected <", _stateMachine.currentState, "> ", _transactionCard, event.cardHolder);
            switch(_stateMachine.currentState)
            {
                case "ChoosingHandler":
                {
                    if (_transactionCard)
                    {
                        InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_common_apply");
                    }
                    break;
                }
                case "ChoosingCard":
                {
                    _loc_2 = event.cardHolder;
                    _loc_3 = CardManager.getInstance().getCardLeader(playerID);
                    if (_loc_2.cardSlotsList.length > 0 && (_loc_2.cardHolderID == CardManager.CARD_LIST_LOC_HAND || _loc_2.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && _loc_2.playerID == CardManager.PLAYER_1 && _loc_3 && _loc_3.canBeUsed))
                    {
                        InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_button_common_select");
                    }
                    else
                    {
                        InputFeedbackManager.removeButtonById(GwintInputFeedback.apply);
                    }
                    if (_boardRenderer.getSelectedCard() != null && cardZoomEnabled && !this.mcChoiceDialog.visible)
                    {
                        InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard, NavigationCode.GAMEPAD_R2, KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
                    }
                    else
                    {
                        InputFeedbackManager.removeButtonById(GwintInputFeedback.zoomCard);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        protected function handleCardChosen(event:GwintCardEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this._currentZoomedHolder != null)
            {
                return;
            }
            Console.WriteLine("GFX handleCardChosen <", _stateMachine.currentState, "> ", event.cardSlot);
            if (event.cardSlot)
            {
                switch(_stateMachine.currentState)
                {
                    case "ChoosingCard":
                    {
                        _loc_2 = event.cardHolder;
                        if (_loc_2.cardHolderID == CardManager.CARD_LIST_LOC_HAND || _loc_2.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && _loc_2.playerID == CardManager.PLAYER_1)
                        {
                            _loc_5 = event.cardSlot.cardInstance as CardLeaderInstance;
                            if (_loc_5 == null || _loc_5.canBeUsed)
                            {
                                startCardTransaction(event.cardSlot.instanceId);
                            }
                        }
                        break;
                    }
                    case "ChoosingTargetCard":
                    {
                        _loc_3 = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                        _loc_4 = CardManager.getInstance().getCardInstance(event.cardSlot.instanceId);
                        if (_loc_3.canBeCastOn(_loc_4))
                        {
                            _decidedCardTransaction = new CardTransaction();
                            _decidedCardTransaction.targetPlayerID = playerID;
                            _decidedCardTransaction.targetSlotID = CardManager.CARD_LIST_LOC_INVALID;
                            _decidedCardTransaction.targetCardInstanceRef = _loc_4;
                            _decidedCardTransaction.sourceCardInstanceRef = _loc_3;
                            _stateMachine.ChangeState("ApplyingCard");
                        }
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

        protected function handleHolderChosen(event:GwintHolderEvent) : void
        {
            var _loc_2:* = null;
            Console.WriteLine("GFX handleHolderChosen <", _stateMachine.currentState, "> ", _transactionCard, event.cardHolder);
            if (_transactionCard && _stateMachine.currentState == "ChoosingHandler")
            {
                _loc_2 = CardManager.getInstance().getCardInstance(_transactionCard.instanceId);
                _decidedCardTransaction = new CardTransaction();
                _decidedCardTransaction.targetPlayerID = event.cardHolder.playerID;
                _decidedCardTransaction.targetSlotID = event.cardHolder.cardHolderID;
                _decidedCardTransaction.targetCardInstanceRef = null;
                _decidedCardTransaction.sourceCardInstanceRef = _loc_2;
                _stateMachine.ChangeState("ApplyingCard");
            }
            return;
        }// end function

        override public function handleUserInput(event:InputEvent) : void
        {
            if (!inputEnabled)
            {
                return;
            }
            if (_boardRenderer && this._currentZoomedHolder == null && (_transactionCard == null || CardManager.getInstance().getCardLeader(playerID) != _transactionCard.cardInstance))
            {
                _boardRenderer.handleInputPreset(event);
            }
            if (!event.handled)
            {
                this.processUserInput(event);
            }
            return;
        }// end function

        override public function handleMouseMove(event:MouseEvent) : void
        {
            if (!inputEnabled)
            {
                return;
            }
            if (_boardRenderer && this._currentZoomedHolder == null && (_transactionCard == null || CardManager.getInstance().getCardLeader(playerID) != _transactionCard.cardInstance))
            {
                _boardRenderer.handleMouseMove(event);
            }
            return;
        }// end function

        override public function handleMouseClick(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (_boardRenderer && this._currentZoomedHolder == null)
            {
                _loc_2 = event as MouseEventEx;
                if (_loc_2.buttonIdx == MouseEventEx.LEFT_BUTTON)
                {
                    if (_stateMachine.currentState == "WaitConfirmation")
                    {
                        this._cardConfirmation = true;
                    }
                    else
                    {
                        _boardRenderer.handleLeftClick(event);
                    }
                }
                else if (_loc_2.buttonIdx == MouseEventEx.RIGHT_BUTTON && !CardTweenManager.getInstance().isAnyCardMoving())
                {
                    if (_transactionCard == null)
                    {
                        if (_stateMachine.currentState == "Idle" || _stateMachine.currentState == "ChoosingCard")
                        {
                            if (this._currentZoomedHolder == null)
                            {
                                this.tryStartZoom();
                                if (this.mcChoiceDialog.visible)
                                {
                                    this.mcChoiceDialog.ignoreNextRightClick = true;
                                }
                            }
                            else
                            {
                                this.closeZoomCB(-1);
                                event.stopImmediatePropagation();
                            }
                        }
                    }
                    else
                    {
                        _boardRenderer.activateAllHolders(true);
                        declineCardTransaction();
                        _stateMachine.ChangeState("ChoosingCard");
                    }
                }
            }
            return;
        }// end function

        protected function processUserInput(event:InputEvent) : void
        {
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_UP;
            var _loc_4:* = _loc_2.navEquivalent;
            if (CardTweenManager.getInstance().isAnyCardMoving())
            {
                return;
            }
            if (_loc_3 && !event.handled)
            {
                if (this._currentZoomedHolder)
                {
                    if (_loc_4 == NavigationCode.GAMEPAD_R2)
                    {
                        this.closeZoomCB();
                    }
                }
                else
                {
                    switch(_loc_4)
                    {
                        case NavigationCode.GAMEPAD_A:
                        {
                            if (_stateMachine.currentState == "WaitConfirmation" && _loc_2.code != KeyCode.SPACE)
                            {
                                this._cardConfirmation = true;
                            }
                            break;
                        }
                        case NavigationCode.GAMEPAD_B:
                        {
                            if (_transactionCard)
                            {
                                _boardRenderer.activateAllHolders(true);
                                _boardRenderer.selectCard(_transactionCard);
                                declineCardTransaction();
                                event.handled = true;
                                _stateMachine.ChangeState("ChoosingCard");
                            }
                            break;
                        }
                        case NavigationCode.GAMEPAD_X:
                        {
                            this.tryPutLeaderInTransaction();
                            break;
                        }
                        case NavigationCode.GAMEPAD_R2:
                        {
                            if (_stateMachine.currentState == "Idle" || _stateMachine.currentState == "ChoosingCard")
                            {
                                this.tryStartZoom();
                            }
                        }
                        default:
                        {
                            break;
                        }
                    }
                    switch(_loc_2.code)
                    {
                        case KeyCode.X:
                        {
                            this.tryPutLeaderInTransaction();
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                if (!event.handled && !this.mcChoiceDialog.visible && _loc_2.code == KeyCode.ESCAPE)
                {
                    GwintGameMenu.mSingleton.tryQuitGame();
                }
            }
            return;
        }// end function

        protected function tryPutLeaderInTransaction() : void
        {
            var _loc_1:* = null;
            if (_stateMachine.currentState == "ChoosingCard" && _transactionCard == null)
            {
                _loc_1 = CardManager.getInstance().getCardLeader(playerID);
                if (_loc_1)
                {
                    if (_loc_1.canBeUsed)
                    {
                        startCardTransaction(_loc_1.instanceId);
                    }
                }
                else
                {
                    throw new Error("GFX [ERROR] - The leader card for player: " + playerID + " is not the correct type");
                }
            }
            return;
        }// end function

        protected function resetToDefaultButtons() : void
        {
            InputFeedbackManager.cleanupButtons();
            InputFeedbackManager.appendButtonById(GwintInputFeedback.quitGame, NavigationCode.START, KeyCode.Q, "gwint_pass_game");
            if (_stateMachine.currentState == "ChoosingCard")
            {
                InputFeedbackManager.appendButtonById(GwintInputFeedback.endTurn, NavigationCode.GAMEPAD_Y, -1, "qwint_skip_turn");
                if (this._skipButton)
                {
                    this._skipButton.visible = true;
                }
            }
            return;
        }// end function

        protected function tryStartZoom() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            if (this._currentZoomedHolder || !cardZoomEnabled)
            {
                return;
            }
            if (_boardRenderer.getSelectedCardHolder() && _boardRenderer.getSelectedCardHolder().cardSlotsList.length > 0)
            {
                this._currentZoomedHolder = _boardRenderer.getSelectedCardHolder();
            }
            if (this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND && this._currentZoomedHolder.playerID == CardManager.PLAYER_2)
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
                GwintGameMenu.mSingleton.playSound("gui_gwint_preview_card");
                InputFeedbackManager.cleanupButtons();
                InputFeedbackManager.appendButtonById(GwintInputFeedback.quitGame, NavigationCode.START, KeyCode.Q, "gwint_pass_game");
                InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate, NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard, NavigationCode.GAMEPAD_R2, KeyCode.RIGHT_MOUSE, "panel_button_common_close");
                if (this._skipButton)
                {
                    this._skipButton.visible = false;
                }
                _loc_1 = new Vector.<CardInstance>;
                _loc_2 = 0;
                while (_loc_2 < this._currentZoomedHolder.cardSlotsList.length)
                {
                    
                    _loc_1.Count(this._currentZoomedHolder.cardSlotsList[_loc_2].cardInstance);
                    _loc_2++;
                }
                if (_stateMachine.currentState == "ChoosingCard" && (this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND && this._currentZoomedHolder.playerID == CardManager.PLAYER_1 || this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && this._currentZoomedHolder.playerID == CardManager.PLAYER_1 && CardManager.getInstance().getCardLeader(CardManager.PLAYER_1).canBeUsed))
                {
                    this.mcChoiceDialog.showDialogCardInstances(_loc_1, this.zoomCardToTransaction, this.closeZoomCB, "");
                }
                else
                {
                    this.mcChoiceDialog.showDialogCardInstances(_loc_1, null, this.closeZoomCB, "");
                }
                this.mcChoiceDialog.cardsCarousel.validateNow();
                this.mcChoiceDialog.cardsCarousel.addEventListener(ListEvent.INDEX_CHANGE, this.onCarouselSelectionChanged, false, 0, true);
                if (this._currentZoomedHolder.selectedCardIdx != -1)
                {
                    this.mcChoiceDialog.cardsCarousel.selectedIndex = this._currentZoomedHolder.selectedCardIdx;
                }
            }
            return;
        }// end function

        protected function zoomCardToTransaction(param1:int = 0) : void
        {
            if (param1 != -1)
            {
                startCardTransaction(param1);
            }
            this.closeZoomCB(param1);
            return;
        }// end function

        protected function closeZoomCB(param1:int = 0) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            if (this._currentZoomedHolder)
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_preview_card");
                if (this._skipButton)
                {
                    this._skipButton.visible = false;
                }
                if (this.mcChoiceDialog.visible)
                {
                    this.mcChoiceDialog.hideDialog();
                }
                this.resetToDefaultButtons();
                _loc_2 = CardManager.getInstance().getCardLeader(playerID);
                _loc_3 = _boardRenderer.getSelectedCardHolder();
                if (_stateMachine.currentState == "ChoosingCard" && (this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_HAND || this._currentZoomedHolder.cardHolderID == CardManager.CARD_LIST_LOC_LEADER && this._currentZoomedHolder.playerID == CardManager.PLAYER_1 && _loc_2 && _loc_2.canBeUsed))
                {
                    InputFeedbackManager.appendButtonById(GwintInputFeedback.apply, NavigationCode.GAMEPAD_A, KeyCode.ENTER, "panel_button_common_select");
                }
                InputFeedbackManager.appendButtonById(GwintInputFeedback.zoomCard, NavigationCode.GAMEPAD_R2, KeyCode.RIGHT_MOUSE, "panel_button_common_zoom");
                if (_loc_2 && _loc_2.canBeUsed)
                {
                    InputFeedbackManager.appendButtonById(GwintInputFeedback.leaderCard, NavigationCode.GAMEPAD_X, KeyCode.X, "gwint_use_leader");
                }
                this.mcChoiceDialog.cardsCarousel.removeEventListener(ListEvent.INDEX_CHANGE, this.onCarouselSelectionChanged, false);
                InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate, NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                this._currentZoomedHolder = null;
            }
            return;
        }// end function

        public function attachToTutorialCarouselMessage() : void
        {
            if (GwintTutorial.mSingleton)
            {
                GwintTutorial.mSingleton.hideCarouselCB = this.closeZoomCB;
            }
            return;
        }// end function

        protected function onCarouselSelectionChanged(event:ListEvent) : void
        {
            if (this._currentZoomedHolder)
            {
                this._currentZoomedHolder.selectedCardIdx = event.index;
            }
            return;
        }// end function

    }
}
