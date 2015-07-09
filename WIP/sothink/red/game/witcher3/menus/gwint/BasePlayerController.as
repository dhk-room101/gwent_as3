package red.game.witcher3.menus.gwint
{
    import flash.events.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;

    public class BasePlayerController extends UIComponent
    {
        public var gameFlowControllerRef:GwintGameFlowController;
        public var playerID:int;
        public var opponentID:int;
        protected var isAI:Boolean = false;
        protected var _stateMachine:FiniteStateMachine;
        protected var _decidedCardTransaction:CardTransaction;
        public var inputEnabled:Boolean = true;
        protected var _boardRenderer:GwintBoardRenderer;
        protected var _playerRenderer:GwintPlayerRenderer;
        protected var _cardZoomEnabled:Boolean = true;
        private var _currentRoundStatus:int = 1;
        protected var _turnOver:Boolean;
        protected var _transactionCard:CardSlot;
        public static const ROUND_PLAYER_STATUS_ACTIVE:int = 1;
        public static const ROUND_PLAYER_STATUS_DONE:int = 2;

        public function BasePlayerController()
        {
            this._stateMachine = new FiniteStateMachine();
            return;
        }// end function

        public function get boardRenderer() : GwintBoardRenderer
        {
            return this._boardRenderer;
        }// end function

        public function set boardRenderer(param1:GwintBoardRenderer) : void
        {
            this._boardRenderer = param1;
            return;
        }// end function

        public function get playerRenderer() : GwintPlayerRenderer
        {
            return this._playerRenderer;
        }// end function

        public function set playerRenderer(param1:GwintPlayerRenderer) : void
        {
            this._playerRenderer = param1;
            var _loc_2:* = CardManager.getInstance().playerDeckDefinitions[this._playerRenderer.playerID];
            this._playerRenderer.txtFactionName.text = _loc_2.getFactionNameString();
            this._playerRenderer.mcFactionIcon.gotoAndStop(_loc_2.getDeckKingTemplate().getFactionString());
            this._playerRenderer.numCardsInHand = 0;
            return;
        }// end function

        public function set cardZoomEnabled(param1:Boolean)
        {
            this._cardZoomEnabled = param1;
            return;
        }// end function

        public function get cardZoomEnabled() : Boolean
        {
            return this._cardZoomEnabled;
        }// end function

        public function get currentRoundStatus() : int
        {
            if (CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, this.playerID).length == 0 && !CardManager.getInstance().getCardLeader(this.playerID).canBeUsed)
            {
                return ROUND_PLAYER_STATUS_DONE;
            }
            return this._currentRoundStatus;
        }// end function

        public function set currentRoundStatus(param1:int) : void
        {
            this._currentRoundStatus = param1;
            if (this._playerRenderer)
            {
                this._playerRenderer.showPassed(this._currentRoundStatus == ROUND_PLAYER_STATUS_DONE);
            }
            return;
        }// end function

        public function set transactionCard(param1:CardSlot) : void
        {
            if (this._transactionCard)
            {
                this._transactionCard.cardState = CardSlot.STATE_BOARD;
            }
            this._transactionCard = param1;
            if (this._boardRenderer)
            {
                this._boardRenderer.updateTransactionCardTooltip(param1);
            }
            if (this._transactionCard)
            {
                this._transactionCard.cardState = CardSlot.STATE_CAROUSEL;
            }
            return;
        }// end function

        public function get turnOver() : Boolean
        {
            return this._turnOver && !this._transactionCard;
        }// end function

        public function startTurn() : void
        {
            if (this.currentRoundStatus == ROUND_PLAYER_STATUS_DONE)
            {
                return;
            }
            this._turnOver = false;
            return;
        }// end function

        public function skipTurn() : void
        {
            return;
        }// end function

        public function resetCurrentRoundStatus() : void
        {
            if (CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, this.playerID).length > 0)
            {
                this.currentRoundStatus = ROUND_PLAYER_STATUS_ACTIVE;
            }
            return;
        }// end function

        protected function startCardTransaction(param1:int) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = NaN;
            var _loc_4:* = NaN;
            if (this.boardRenderer)
            {
                _loc_2 = this.boardRenderer.getCardSlotById(param1);
                _loc_3 = this.boardRenderer.mcTransitionAnchor.x;
                _loc_4 = this.boardRenderer.mcTransitionAnchor.y;
                CardTweenManager.getInstance().storePosition(_loc_2);
                CardTweenManager.getInstance().tweenTo(_loc_2, _loc_3, _loc_4);
                this.transactionCard = _loc_2;
            }
            return;
        }// end function

        protected function declineCardTransaction() : void
        {
            if (this._transactionCard)
            {
                CardTweenManager.getInstance().restorePosition(this._transactionCard, true);
                this.transactionCard = null;
            }
            return;
        }// end function

        protected function transferTransactionCardToDestination(param1:int, param2:int) : void
        {
            if (this._transactionCard)
            {
                CardManager.getInstance().addCardInstanceIDToList(this._transactionCard.instanceId, param1, param2);
                this.transactionCard = null;
            }
            return;
        }// end function

        protected function applyTransactionCardToCardInstance(param1:CardInstance) : void
        {
            CardManager.getInstance().replaceCardInstanceIDs(this._transactionCard.instanceId, param1.instanceId);
            this.transactionCard = null;
            return;
        }// end function

        protected function applyGlobalEffectTransactionCard() : void
        {
            if (this._transactionCard)
            {
                CardManager.getInstance().applyCardEffectsID(this._transactionCard.instanceId);
                CardManager.getInstance().sendToGraveyardID(this._transactionCard.instanceId);
                this.transactionCard = null;
            }
            return;
        }// end function

        protected function state_begin_ApplyingCard() : void
        {
            var _loc_1:* = this._decidedCardTransaction.sourceCardInstanceRef as CardLeaderInstance;
            if (_loc_1)
            {
                _loc_1.ApplyLeaderAbility(this.isAI);
                CardTweenManager.getInstance().restorePosition(this._transactionCard, true);
                this.transactionCard = null;
            }
            else if (this._decidedCardTransaction.targetSlotID != CardManager.CARD_LIST_LOC_INVALID)
            {
                this.transferTransactionCardToDestination(this._decidedCardTransaction.targetSlotID, this._decidedCardTransaction.targetPlayerID);
            }
            else if (this._decidedCardTransaction.targetCardInstanceRef)
            {
                this.applyTransactionCardToCardInstance(this._decidedCardTransaction.targetCardInstanceRef);
            }
            else if (this._decidedCardTransaction.sourceCardInstanceRef.templateRef.isType(CardTemplate.CardType_Global_Effect))
            {
                this.applyGlobalEffectTransactionCard();
            }
            else
            {
                this.declineCardTransaction();
            }
            return;
        }// end function

        protected function cardEffectApplying() : Boolean
        {
            return CardTweenManager.getInstance().isAnyCardMoving() || this.gameFlowControllerRef.mcMessageQueue.ShowingMessage() || CardFXManager.getInstance().isPlayingAnyCardFX();
        }// end function

        protected function state_update_ApplyingCard() : void
        {
            if (!this.cardEffectApplying())
            {
                if (this.gameFlowControllerRef.playerControllers[this.opponentID].currentRoundStatus == ROUND_PLAYER_STATUS_DONE)
                {
                    this._stateMachine.ChangeState("ChoosingMove");
                }
                else
                {
                    this._stateMachine.ChangeState("Idle");
                }
            }
            return;
        }// end function

        public function handleUserInput(event:InputEvent) : void
        {
            return;
        }// end function

        public function handleMouseMove(event:MouseEvent) : void
        {
            return;
        }// end function

        public function handleMouseClick(event:MouseEvent) : void
        {
            return;
        }// end function

    }
}
