package red.game.witcher3.menus.gwint 
{
    import flash.events.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    
    public class BasePlayerController extends scaleform.clik.core.UIComponent
    {
        public function BasePlayerController()
        {
            super();
            this._stateMachine = new red.game.witcher3.utils.FiniteStateMachine();
            return;
        }

        protected function state_begin_ApplyingCard():void
        {
            var loc1:*=this._decidedCardTransaction.sourceCardInstanceRef as red.game.witcher3.menus.gwint.CardLeaderInstance;
            if (loc1) 
            {
                loc1.ApplyLeaderAbility(this.isAI);
                red.game.witcher3.menus.gwint.CardTweenManager.getInstance().restorePosition(this._transactionCard, true);
                this.transactionCard = null;
            }
            else if (this._decidedCardTransaction.targetSlotID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_INVALID) 
            {
                if (this._decidedCardTransaction.targetCardInstanceRef) 
                {
                    this.applyTransactionCardToCardInstance(this._decidedCardTransaction.targetCardInstanceRef);
                }
                else if (this._decidedCardTransaction.sourceCardInstanceRef.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Global_Effect)) 
                {
                    this.applyGlobalEffectTransactionCard();
                }
                else 
                {
                    this.declineCardTransaction();
                }
            }
            else 
            {
                this.transferTransactionCardToDestination(this._decidedCardTransaction.targetSlotID, this._decidedCardTransaction.targetPlayerID);
            }
            return;
        }

        protected function applyGlobalEffectTransactionCard():void
        {
            if (this._transactionCard) 
            {
                red.game.witcher3.menus.gwint.CardManager.getInstance().applyCardEffectsID(this._transactionCard.instanceId);
                red.game.witcher3.menus.gwint.CardManager.getInstance().sendToGraveyardID(this._transactionCard.instanceId);
                this.transactionCard = null;
            }
            return;
        }

        protected function applyTransactionCardToCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            red.game.witcher3.menus.gwint.CardManager.getInstance().replaceCardInstanceIDs(this._transactionCard.instanceId, arg1.instanceId);
            this.transactionCard = null;
            return;
        }

        protected function transferTransactionCardToDestination(arg1:int, arg2:int):void
        {
            if (this._transactionCard) 
            {
                red.game.witcher3.menus.gwint.CardManager.getInstance().addCardInstanceIDToList(this._transactionCard.instanceId, arg1, arg2);
                this.transactionCard = null;
            }
            return;
        }

        protected function declineCardTransaction():void
        {
            if (this._transactionCard) 
            {
                red.game.witcher3.menus.gwint.CardTweenManager.getInstance().restorePosition(this._transactionCard, true);
                this.transactionCard = null;
            }
            return;
        }

        protected function startCardTransaction(arg1:int):void
        {
            var loc1:*=null;
            var loc2:*=NaN;
            var loc3:*=NaN;
            if (this.boardRenderer) 
            {
                loc1 = this.boardRenderer.getCardSlotById(arg1);
                loc2 = this.boardRenderer.mcTransitionAnchor.x;
                loc3 = this.boardRenderer.mcTransitionAnchor.y;
                red.game.witcher3.menus.gwint.CardTweenManager.getInstance().storePosition(loc1);
                red.game.witcher3.menus.gwint.CardTweenManager.getInstance().tweenTo(loc1, loc2, loc3);
                this.transactionCard = loc1;
            }
            return;
        }

        public function resetCurrentRoundStatus():void
        {
            if (red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, this.playerID).length > 0) 
            {
                this.currentRoundStatus = ROUND_PLAYER_STATUS_ACTIVE;
            }
            return;
        }

        public function skipTurn():void
        {
            return;
        }

        public function get boardRenderer():red.game.witcher3.menus.gwint.GwintBoardRenderer
        {
            return this._boardRenderer;
        }

        public function set boardRenderer(arg1:red.game.witcher3.menus.gwint.GwintBoardRenderer):void
        {
            this._boardRenderer = arg1;
            return;
        }

        public function startTurn():void
        {
            if (this.currentRoundStatus == ROUND_PLAYER_STATUS_DONE) 
            {
                return;
            }
            this._turnOver = false;
            return;
        }

        public function get playerRenderer():red.game.witcher3.menus.gwint.GwintPlayerRenderer
        {
            return this._playerRenderer;
        }

        public function set playerRenderer(arg1:red.game.witcher3.menus.gwint.GwintPlayerRenderer):void
        {
            this._playerRenderer = arg1;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance().playerDeckDefinitions[this._playerRenderer.playerID];
            this._playerRenderer.txtFactionName.text = loc1.getFactionNameString();
            this._playerRenderer.mcFactionIcon.gotoAndStop(loc1.getDeckKingTemplate().getFactionString());
            this._playerRenderer.numCardsInHand = 0;
            return;
        }

        public function get turnOver():Boolean
        {
            return this._turnOver && !this._transactionCard;
        }

        public function set cardZoomEnabled(arg1:Boolean):*
        {
            this._cardZoomEnabled = arg1;
            return;
        }

        public function get cardZoomEnabled():Boolean
        {
            return this._cardZoomEnabled;
        }

        public function set transactionCard(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            if (this._transactionCard) 
            {
                this._transactionCard.cardState = red.game.witcher3.menus.gwint.CardSlot.STATE_BOARD;
            }
            this._transactionCard = arg1;
            if (this._boardRenderer) 
            {
                this._boardRenderer.updateTransactionCardTooltip(arg1);
            }
            if (this._transactionCard) 
            {
                this._transactionCard.cardState = red.game.witcher3.menus.gwint.CardSlot.STATE_CAROUSEL;
            }
            return;
        }

        public function get currentRoundStatus():int
        {
            if (red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, this.playerID).length == 0 && !red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(this.playerID).canBeUsed) 
            {
                return ROUND_PLAYER_STATUS_DONE;
            }
            return this._currentRoundStatus;
        }

        public function set currentRoundStatus(arg1:int):void
        {
            this._currentRoundStatus = arg1;
            if (this._playerRenderer) 
            {
                this._playerRenderer.showPassed(this._currentRoundStatus == ROUND_PLAYER_STATUS_DONE);
            }
            return;
        }

        protected function cardEffectApplying():Boolean
        {
            return red.game.witcher3.menus.gwint.CardTweenManager.getInstance().isAnyCardMoving() || this.gameFlowControllerRef.mcMessageQueue.ShowingMessage() || red.game.witcher3.menus.gwint.CardFXManager.getInstance().isPlayingAnyCardFX();
        }

        protected function state_update_ApplyingCard():void
        {
            if (!this.cardEffectApplying()) 
            {
                if (this.gameFlowControllerRef.playerControllers[this.opponentID].currentRoundStatus != ROUND_PLAYER_STATUS_DONE) 
                {
                    this._stateMachine.ChangeState("Idle");
                }
                else 
                {
                    this._stateMachine.ChangeState("ChoosingMove");
                }
            }
            return;
        }

        public function handleUserInput(arg1:scaleform.clik.events.InputEvent):void
        {
            return;
        }

        public function handleMouseMove(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        public function handleMouseClick(arg1:flash.events.MouseEvent):void
        {
            return;
        }

        public static const ROUND_PLAYER_STATUS_DONE:int=2;

        public static const ROUND_PLAYER_STATUS_ACTIVE:int=1;

        protected var _decidedCardTransaction:red.game.witcher3.menus.gwint.CardTransaction;

        protected var _stateMachine:red.game.witcher3.utils.FiniteStateMachine;

        protected var isAI:Boolean=false;

        public var opponentID:int;

        public var playerID:int;

        public var gameFlowControllerRef:red.game.witcher3.menus.gwint.GwintGameFlowController;

        protected var _transactionCard:red.game.witcher3.menus.gwint.CardSlot;

        private var _currentRoundStatus:int=1;

        protected var _cardZoomEnabled:Boolean=true;

        protected var _playerRenderer:red.game.witcher3.menus.gwint.GwintPlayerRenderer;

        protected var _boardRenderer:red.game.witcher3.menus.gwint.GwintBoardRenderer;

        public var inputEnabled:Boolean=true;

        protected var _turnOver:Boolean;
    }
}
