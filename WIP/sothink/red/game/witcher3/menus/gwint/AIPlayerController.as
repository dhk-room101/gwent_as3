package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;

    public class AIPlayerController extends BasePlayerController
    {
        protected var attitude:int;
        protected var chances:int;
        protected var waitingForTimer:Boolean;
        protected var waitingTimer:Timer;
        protected var _currentRoundCritical:Boolean = false;
        static const TACTIC_NONE:int = 0;
        static const TACTIC_SPY_DUMMY_BEST_THEN_PASS:int = 1;
        static const TACTIC_MINIMIZE_LOSS:int = 1;
        static const TACTIC_MINIMIZE_WIN:int = 2;
        static const TACTIC_MAXIMIZE_WIN:int = 3;
        static const TACTIC_AVERAGE_WIN:int = 4;
        static const TACTIC_MINIMAL_WIN:int = 5;
        static const TACTIC_JUST_WAIT:int = 6;
        static const TACTIC_PASS:int = 7;
        static const TACTIC_WAIT_DUMMY:int = 8;
        static const TACTIC_SPY:int = 9;
        private static const SortType_None:int = 0;
        private static const SortType_StrategicValue:int = 1;
        private static const SortType_PowerChange:int = 2;

        public function AIPlayerController()
        {
            isAI = true;
            _stateMachine.AddState("Idle", this.state_begin_Idle, null, this.state_end_Idle);
            _stateMachine.AddState("ChoosingMove", this.state_begin_ChoseMove, this.state_update_ChooseMove, null);
            _stateMachine.AddState("SendingCardToTransaction", this.state_begin_SendingCard, this.state_update_SendingCard, null);
            _stateMachine.AddState("DelayBetweenActions", this.state_begin_DelayAction, this.state_update_DelayAction, null);
            _stateMachine.AddState("ApplyingCard", state_begin_ApplyingCard, state_update_ApplyingCard, null);
            return;
        }// end function

        override public function startTurn() : void
        {
            if (currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
            {
                return;
            }
            super.startTurn();
            _stateMachine.ChangeState("ChoosingMove");
            return;
        }// end function

        protected function state_begin_Idle() : void
        {
            if (this.attitude == TACTIC_PASS)
            {
                currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
            }
            _turnOver = true;
            if (CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, playerID).length == 0 && CardManager.getInstance().getCardLeader(playerID) != null && !CardManager.getInstance().getCardLeader(playerID).canBeUsed)
            {
                currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_DONE;
            }
            if (_boardRenderer)
            {
                _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER, playerID).updateLeaderStatus(false);
            }
            return;
        }// end function

        protected function state_end_Idle() : void
        {
            if (_boardRenderer)
            {
                _boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER, playerID).updateLeaderStatus(true);
            }
            return;
        }// end function

        protected function attitudeToString(param1:int) : String
        {
            switch(param1)
            {
                case TACTIC_NONE:
                {
                    return "NONE - ERROR";
                }
                case TACTIC_SPY_DUMMY_BEST_THEN_PASS:
                {
                    return "DUMMY BETS THEN PASS";
                }
                case TACTIC_MINIMIZE_LOSS:
                {
                    return "MINIMIZE LOSS";
                }
                case TACTIC_MINIMIZE_WIN:
                {
                    return "MINIMIZE WIN";
                }
                case TACTIC_MAXIMIZE_WIN:
                {
                    return "MAXIMIZE WIN";
                }
                case TACTIC_AVERAGE_WIN:
                {
                    return "AVERAGE WIN";
                }
                case TACTIC_MINIMAL_WIN:
                {
                    return "MINIMAL WIN";
                }
                case TACTIC_JUST_WAIT:
                {
                    return "JUST WAIT";
                }
                case TACTIC_PASS:
                {
                    return "PASS";
                }
                case TACTIC_WAIT_DUMMY:
                {
                    return "WAIT DUMMY";
                }
                case TACTIC_SPY:
                {
                    return "SPIES";
                }
                default:
                {
                    break;
                }
            }
            return _loc_2.toString();
        }// end function

        protected function state_begin_ChoseMove() : void
        {
            CardManager.getInstance().CalculateCardPowerPotentials();
            this.ChooseAttitude();
            var _loc_1:* = this.attitudeToString(this.attitude);
            Console.WriteLine("GFX -#AI# ai has decided to use the following attitude:" + _loc_1);
            _decidedCardTransaction = this.decideWhichCardToPlay();
            if (_decidedCardTransaction == null && this.attitude != TACTIC_PASS)
            {
                this.attitude = TACTIC_PASS;
            }
            else if (this._currentRoundCritical && _decidedCardTransaction != null && !_decidedCardTransaction.sourceCardInstanceRef.templateRef.hasEffect(CardTemplate.CardEffect_UnsummonDummy) && _decidedCardTransaction.powerChangeResult < 0 && CardManager.getInstance().getAllCreaturesInHand(playerID).length == 0)
            {
                _decidedCardTransaction = null;
                this.attitude = TACTIC_PASS;
            }
            Console.WriteLine("GFX -#AI# the ai decided on the following transaction: " + _decidedCardTransaction);
            return;
        }// end function

        protected function state_update_ChooseMove() : void
        {
            if (this.attitude == TACTIC_PASS || _decidedCardTransaction == null)
            {
                _stateMachine.ChangeState("Idle");
                if (this.attitude != TACTIC_PASS)
                {
                    Console.WriteLine("GFX -#AI#--------------- WARNING ---------- AI is passing since chosen tactic was unable to find a transaction is liked");
                }
                this.attitude = TACTIC_PASS;
            }
            else
            {
                _stateMachine.ChangeState("SendingCardToTransaction");
            }
            return;
        }// end function

        protected function state_begin_SendingCard() : void
        {
            Console.WriteLine("GFX -#AI# AI is sending the following card into transaction: ", _decidedCardTransaction.sourceCardInstanceRef);
            startCardTransaction(_decidedCardTransaction.sourceCardInstanceRef.instanceId);
            return;
        }// end function

        protected function state_update_SendingCard() : void
        {
            if (!CardTweenManager.getInstance().isAnyCardMoving())
            {
                _stateMachine.ChangeState("DelayBetweenActions");
            }
            return;
        }// end function

        protected function state_begin_DelayAction() : void
        {
            this.waitingForTimer = true;
            this.waitingTimer = new Timer(1200, 1);
            this.waitingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onWaitingTimerEnded, false, 0, true);
            this.waitingTimer.start();
            return;
        }// end function

        protected function state_update_DelayAction() : void
        {
            if (!this.waitingForTimer)
            {
                _stateMachine.ChangeState("ApplyingCard");
            }
            return;
        }// end function

        protected function onWaitingTimerEnded(event:TimerEvent) : void
        {
            this.waitingForTimer = false;
            this.waitingTimer = null;
            return;
        }// end function

        private function ChooseAttitude() : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_19:* = NaN;
            var _loc_20:* = undefined;
            var _loc_1:* = CardManager.getInstance();
            var _loc_2:* = new Vector.<CardInstance>;
            _loc_2 = _loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, playerID);
            if (_loc_2.length == 0)
            {
                this.attitude = TACTIC_PASS;
                return;
            }
            var _loc_6:* = false;
            var _loc_7:* = false;
            var _loc_8:* = 0;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            _loc_4 = 0;
            while (_loc_4 < _loc_1.roundResults.length)
            {
                
                if (_loc_1.roundResults[_loc_4].played)
                {
                    _loc_5 = _loc_1.roundResults[_loc_4].winningPlayer;
                    if (_loc_5 == playerID || _loc_5 == CardManager.PLAYER_INVALID)
                    {
                        _loc_6 = true;
                    }
                    if (_loc_5 == opponentID || _loc_5 == CardManager.PLAYER_INVALID)
                    {
                        _loc_7 = true;
                    }
                }
                _loc_4++;
            }
            this._currentRoundCritical = _loc_7;
            _loc_3 = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                if (_loc_2[_loc_3].templateRef.isType(CardTemplate.CardType_Creature))
                {
                    _loc_8++;
                }
                _loc_3++;
            }
            var _loc_11:* = _loc_2.length;
            var _loc_12:* = _loc_1.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, opponentID).length;
            var _loc_13:* = _loc_11 - _loc_12;
            var _loc_14:* = _loc_1.currentPlayerScores[playerID] - _loc_1.currentPlayerScores[opponentID];
            var _loc_15:* = gameFlowControllerRef.playerControllers[opponentID].currentRoundStatus;
            Console.WriteLine("GFX -#AI# ###############################################################################");
            Console.WriteLine("GFX -#AI#---------------------------- AI Deciding his next move --------------------------------");
            Console.WriteLine("GFX -#AI#------ previousTactic: " + this.attitudeToString(this.attitude));
            Console.WriteLine("GFX -#AI#------ playerCardsInHand: " + _loc_11);
            Console.WriteLine("GFX -#AI#------ opponentCardsInHand: " + _loc_12);
            Console.WriteLine("GFX -#AI#------ cardAdvantage: " + _loc_13);
            Console.WriteLine("GFX -#AI#------ scoreDifference: " + _loc_14 + ", his score: " + _loc_1.currentPlayerScores[playerID] + ", enemy score: " + _loc_1.currentPlayerScores[opponentID]);
            Console.WriteLine("GFX -#AI#------ opponent has won: " + _loc_7);
            Console.WriteLine("GFX -#AI#------ has won: " + _loc_6);
            Console.WriteLine("GFX -#AI#------ Num units in hand: " + _loc_8);
            if (gameFlowControllerRef.playerControllers[opponentID].currentRoundStatus == ROUND_PLAYER_STATUS_DONE)
            {
                Console.WriteLine("GFX -#AI#------ has opponent passed: true");
            }
            else
            {
                Console.WriteLine("GFX -#AI#------ has opponent passed: false");
            }
            Console.WriteLine("GFX =#AI#=======================================================================================");
            Console.WriteLine("GFX -#AI#-----------------------------   AI CARDS AT HAND   ------------------------------------");
            _loc_3 = 0;
            while (_loc_3 < _loc_2.length)
            {
                
                Console.WriteLine("GFX -#AI# Card Points[ ", _loc_2[_loc_3].templateRef.power, " ], Card -", _loc_2[_loc_3]);
                _loc_3++;
            }
            Console.WriteLine("GFX =#AI#=======================================================================================");
            var _loc_16:* = _loc_1.playerDeckDefinitions[playerID].getDeckFaction();
            var _loc_17:* = _loc_1.playerDeckDefinitions[opponentID].getDeckFaction();
            var _loc_18:* = _loc_1.getCardsInSlotIdWithEffect(CardTemplate.CardEffect_Draw2, opponentID).length;
            if (_loc_16 == CardTemplate.FactionId_Nilfgaard && _loc_17 != CardTemplate.FactionId_Nilfgaard && _loc_15 == ROUND_PLAYER_STATUS_DONE && _loc_14 == 0)
            {
                this.attitude = TACTIC_PASS;
            }
            else if (!_loc_7 && this.attitude == TACTIC_SPY_DUMMY_BEST_THEN_PASS)
            {
                if (_loc_15 != ROUND_PLAYER_STATUS_DONE)
                {
                }
            }
            else if (!_loc_7 && _loc_1.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID) != null && (Math.random() < 0.2 || _loc_18 > 1) && this.attitude != TACTIC_SPY_DUMMY_BEST_THEN_PASS)
            {
                this.attitude = TACTIC_SPY;
            }
            else if (this.attitude == TACTIC_SPY && _loc_1.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID) != null)
            {
                this.attitude = TACTIC_SPY;
            }
            else if (_loc_15 == ROUND_PLAYER_STATUS_DONE)
            {
                if (this.attitude == TACTIC_MINIMIZE_LOSS)
                {
                    this.attitude = TACTIC_MINIMIZE_LOSS;
                }
                else if (!_loc_7 && _loc_14 <= 0 && Math.random() < _loc_14 / 20)
                {
                    this.attitude = TACTIC_MINIMIZE_LOSS;
                }
                else if (!_loc_6 && _loc_14 > 0)
                {
                    this.attitude = TACTIC_MINIMIZE_WIN;
                }
                else if (_loc_14 > 0)
                {
                    this.attitude = TACTIC_PASS;
                }
                else
                {
                    this.attitude = TACTIC_MINIMAL_WIN;
                }
            }
            else if (_loc_14 > 0)
            {
                if (_loc_7)
                {
                    this.attitude = TACTIC_JUST_WAIT;
                }
                else
                {
                    _loc_19 = _loc_8 * _loc_8 / 36;
                    this.attitude = TACTIC_NONE;
                    if (_loc_6)
                    {
                        _loc_9 = _loc_1.getCardsInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy, playerID).length;
                        _loc_10 = _loc_1.getCardsInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID).length;
                        if (Math.random() < 0.2 || _loc_11 == _loc_9 + _loc_10)
                        {
                            this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                        }
                        else
                        {
                            _loc_20 = _loc_1.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy, playerID);
                            if (_loc_20 != null && _loc_1.getHigherOrLowerValueTargetCardOnBoard(_loc_20, playerID, false) != null)
                            {
                                this.attitude = TACTIC_WAIT_DUMMY;
                            }
                            else if (Math.random() < _loc_14 / 30 && Math.random() < _loc_19)
                            {
                                this.attitude = TACTIC_MAXIMIZE_WIN;
                            }
                        }
                    }
                    if (this.attitude == TACTIC_NONE)
                    {
                        if (Math.random() < _loc_11 / 10 || _loc_11 > 8)
                        {
                            if (Math.random() < 0.2 || _loc_11 == _loc_9 + _loc_10)
                            {
                                this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                            }
                            else
                            {
                                this.attitude = TACTIC_JUST_WAIT;
                            }
                        }
                        else
                        {
                            this.attitude = TACTIC_PASS;
                        }
                    }
                }
            }
            else if (_loc_6)
            {
                _loc_9 = _loc_1.getCardsInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy, playerID).length;
                _loc_10 = _loc_1.getCardsInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID).length;
                if (!_loc_7 && (Math.random() < 0.2 || _loc_11 == _loc_9 + _loc_10))
                {
                    this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                }
                else
                {
                    this.attitude = TACTIC_MAXIMIZE_WIN;
                }
            }
            else if (_loc_7)
            {
                this.attitude = TACTIC_MINIMAL_WIN;
            }
            else if (!_loc_1.roundResults[0].played && _loc_14 < -11 && Math.random() < (Math.abs(_loc_14) - 10) / 20)
            {
                if (Math.random() < 0.9)
                {
                    this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                }
                else
                {
                    this.attitude = TACTIC_PASS;
                }
            }
            else if (Math.random() < _loc_11 / 10)
            {
                this.attitude = TACTIC_MINIMAL_WIN;
            }
            else if (Math.random() < _loc_11 / 10)
            {
                this.attitude = TACTIC_AVERAGE_WIN;
            }
            else if (Math.random() < _loc_11 / 10)
            {
                this.attitude = TACTIC_MAXIMIZE_WIN;
            }
            else if (_loc_11 <= 8 && Math.random() > _loc_11 / 10)
            {
                this.attitude = TACTIC_PASS;
            }
            else
            {
                this.attitude = TACTIC_JUST_WAIT;
            }
            return;
        }// end function

        protected function decideWhichCardToPlay() : CardTransaction
        {
            var _loc_1:* = null;
            var _loc_2:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_3:* = CardManager.getInstance();
            var _loc_4:* = _loc_3.currentPlayerScores[playerID];
            var _loc_5:* = _loc_3.currentPlayerScores[opponentID];
            var _loc_6:* = _loc_4 - _loc_5;
            switch(this.attitude)
            {
                case TACTIC_SPY_DUMMY_BEST_THEN_PASS:
                {
                    _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID);
                    if (_loc_8 != null)
                    {
                        return _loc_8.getOptimalTransaction();
                    }
                    _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (_loc_8)
                    {
                        _loc_9 = _loc_3.getHigherOrLowerValueTargetCardOnBoard(_loc_8, playerID, true, true);
                        if (_loc_9)
                        {
                            _loc_7 = _loc_8.getOptimalTransaction();
                            _loc_7.targetCardInstanceRef = _loc_9;
                            return _loc_7;
                        }
                    }
                    this.attitude = TACTIC_PASS;
                    break;
                }
                case TACTIC_MINIMIZE_LOSS:
                {
                    _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (_loc_8)
                    {
                        _loc_9 = this.getHighestValueCardOnBoard();
                        if (_loc_9)
                        {
                            _loc_7 = _loc_8.getOptimalTransaction();
                            _loc_7.targetCardInstanceRef = _loc_9;
                            return _loc_7;
                        }
                    }
                    _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID);
                    if (_loc_8 != null)
                    {
                        return _loc_8.getOptimalTransaction();
                    }
                    this.attitude = TACTIC_PASS;
                    break;
                }
                case TACTIC_MINIMIZE_WIN:
                {
                    _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (_loc_8)
                    {
                        _loc_9 = this.getHighestValueCardOnBoardWithEffectLessThan(_loc_6);
                        if (_loc_9)
                        {
                            _loc_7 = _loc_8.getOptimalTransaction();
                            if (_loc_7)
                            {
                                _loc_7.targetCardInstanceRef = _loc_9;
                                return _loc_7;
                            }
                        }
                    }
                    _loc_1 = _loc_3.getCardsInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1.length)
                    {
                        
                        _loc_8 = _loc_1[_loc_2];
                        if (_loc_8 && Math.abs(_loc_7.powerChangeResult) < Math.abs(_loc_6))
                        {
                            return _loc_8.getOptimalTransaction();
                        }
                        _loc_2++;
                    }
                    this.attitude = TACTIC_PASS;
                    break;
                }
                case TACTIC_MAXIMIZE_WIN:
                {
                    _loc_1 = this.getCardsBasedOnCriteria(SortType_PowerChange);
                    if (_loc_1.length > 0)
                    {
                        _loc_9 = _loc_1[(_loc_1.length - 1)];
                        if (_loc_9)
                        {
                            return _loc_9.getOptimalTransaction();
                        }
                    }
                    break;
                }
                case TACTIC_AVERAGE_WIN:
                {
                    _loc_1 = this.getCardsBasedOnCriteria(SortType_PowerChange);
                    _loc_10 = -1;
                    while (_loc_2 < _loc_1.length && _loc_10 == -1)
                    {
                        
                        _loc_8 = _loc_1[_loc_2];
                        if (_loc_7.powerChangeResult > Math.abs(_loc_6))
                        {
                            _loc_10 = _loc_2;
                        }
                        _loc_2++;
                    }
                    if (_loc_10 != -1)
                    {
                        _loc_11 = Math.min(_loc_10, Math.max((_loc_1.length - 1), _loc_10 + Math.floor(Math.random() * ((_loc_1.length - 1) - _loc_10))));
                        _loc_9 = _loc_1[_loc_11];
                        if (_loc_9)
                        {
                            return _loc_9.getOptimalTransaction();
                        }
                    }
                    else if (_loc_1.length > 0)
                    {
                        _loc_9 = _loc_1[(_loc_1.length - 1)];
                        if (_loc_9)
                        {
                            return _loc_9.getOptimalTransaction();
                        }
                    }
                    break;
                }
                case TACTIC_MINIMAL_WIN:
                {
                    _loc_1 = this.getCardsBasedOnCriteria(SortType_PowerChange);
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1.length)
                    {
                        
                        _loc_8 = _loc_1[_loc_2];
                        if (_loc_7.powerChangeResult > Math.abs(_loc_6))
                        {
                            _loc_9 = _loc_8;
                            break;
                        }
                        _loc_2++;
                    }
                    if (!_loc_9 && _loc_1.length > 0)
                    {
                        _loc_9 = _loc_1[(_loc_1.length - 1)];
                    }
                    if (_loc_9)
                    {
                        return _loc_9.getOptimalTransaction();
                    }
                    break;
                }
                case TACTIC_JUST_WAIT:
                {
                    _loc_1 = this.getCardsBasedOnCriteria(SortType_StrategicValue);
                    if (_loc_1.length == 0)
                    {
                        return null;
                    }
                    _loc_2 = 0;
                    while (_loc_2 < _loc_1.length)
                    {
                        
                        _loc_7 = _loc_8.getOptimalTransaction();
                        if (_loc_7)
                        {
                            if (this._currentRoundCritical)
                            {
                                if (_loc_7 && _loc_7.sourceCardInstanceRef.templateRef.isType(CardTemplate.CardType_Weather) && (_loc_7.powerChangeResult < 0 || _loc_7.powerChangeResult < _loc_7.sourceCardInstanceRef.potentialWeatherHarm()))
                                {
                                    _loc_7 = null;
                                    ;
                                }
                                else
                                {
                                    break;
                                }
                            }
                            else
                            {
                                break;
                            }
                        }
                        _loc_2++;
                    }
                    return _loc_7;
                }
                case TACTIC_WAIT_DUMMY:
                {
                    _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (_loc_8 != null)
                    {
                        _loc_7 = _loc_8.getOptimalTransaction();
                        if (_loc_7.targetCardInstanceRef == null)
                        {
                            _loc_7.targetCardInstanceRef = _loc_3.getHigherOrLowerValueTargetCardOnBoard(_loc_8, playerID, false);
                        }
                        if (_loc_7.targetCardInstanceRef != null)
                        {
                            return _loc_7;
                        }
                    }
                    Console.WriteLine("GFX [ WARNING ] -#AI#---- Uh oh, was in TACTIC_WAIT_DUMMY but was unable to get a valid dummy transaction :S");
                    break;
                }
                case TACTIC_SPY:
                {
                    _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID);
                    if (_loc_8 != null)
                    {
                        return _loc_8.getOptimalTransaction();
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (this.attitude != TACTIC_PASS && this.attitude != TACTIC_MINIMIZE_WIN)
            {
                _loc_8 = _loc_3.getFirstCardInHandWithEffect(CardTemplate.CardEffect_Draw2, playerID);
                if (_loc_8 != null)
                {
                    return _loc_8.getOptimalTransaction();
                }
            }
            return null;
        }// end function

        protected function getCardsBasedOnCriteria(param1:int) : Vector.<CardInstance>
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = new Vector.<CardInstance>;
            var _loc_3:* = CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, playerID);
            var _loc_6:* = CardManager.getInstance();
            var _loc_7:* = _loc_6.getCardLeader(playerID);
            if (_loc_7 && _loc_7.canBeUsed)
            {
                _loc_7.recalculatePowerPotential(_loc_6);
                if (_loc_7.getOptimalTransaction().strategicValue != -1)
                {
                    _loc_2.Count(_loc_7);
                }
            }
            _loc_4 = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                _loc_5 = _loc_3[_loc_4];
                switch(param1)
                {
                    case SortType_None:
                    {
                        _loc_2.Count(_loc_5);
                        break;
                    }
                    case SortType_PowerChange:
                    {
                        if (_loc_5.getOptimalTransaction().powerChangeResult >= 0)
                        {
                            _loc_2.Count(_loc_5);
                        }
                        break;
                    }
                    case SortType_StrategicValue:
                    {
                        if (_loc_5.getOptimalTransaction().strategicValue >= 0)
                        {
                            _loc_2.Count(_loc_5);
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_4++;
            }
            switch(param1)
            {
                case SortType_StrategicValue:
                {
                    _loc_2.sort(this.strategicValueSorter);
                    break;
                }
                case SortType_PowerChange:
                {
                    _loc_2.sort(this.powerChangeSorter);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return _loc_2;
        }// end function

        protected function strategicValueSorter(param1:CardInstance, param2:CardInstance) : Number
        {
            return param1.getOptimalTransaction().strategicValue - param2.getOptimalTransaction().strategicValue;
        }// end function

        protected function powerChangeSorter(param1:CardInstance, param2:CardInstance) : Number
        {
            if (param1.getOptimalTransaction().powerChangeResult == param2.getOptimalTransaction().powerChangeResult)
            {
                return param1.getOptimalTransaction().strategicValue - param2.getOptimalTransaction().strategicValue;
            }
            return param1.getOptimalTransaction().powerChangeResult - param2.getOptimalTransaction().powerChangeResult;
        }// end function

        protected function getHighestValueCardOnBoard() : CardInstance
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_1:* = new Vector.<CardInstance>;
            var _loc_2:* = CardManager.getInstance();
            _loc_2.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, playerID, _loc_1);
            _loc_2.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, playerID, _loc_1);
            _loc_2.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, playerID, _loc_1);
            var _loc_5:* = null;
            _loc_3 = 0;
            while (_loc_3 < _loc_1.length)
            {
                
                _loc_4 = _loc_1[_loc_3];
                if (_loc_5 == null || _loc_4.templateRef.power + _loc_4.templateRef.GetBonusValue() > _loc_5.templateRef.power + _loc_5.templateRef.GetBonusValue())
                {
                    _loc_5 = _loc_4;
                }
                _loc_3++;
            }
            return _loc_5;
        }// end function

        protected function getHighestValueCardOnBoardWithEffectLessThan(param1:int) : CardInstance
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = new Vector.<CardInstance>;
            var _loc_3:* = CardManager.getInstance();
            _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_MELEE, playerID, _loc_2);
            _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_RANGED, playerID, _loc_2);
            _loc_3.getAllCreaturesNonHero(CardManager.CARD_LIST_LOC_SEIGE, playerID, _loc_2);
            var _loc_6:* = null;
            _loc_4 = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                _loc_5 = _loc_2[_loc_4];
                if (!_loc_5.templateRef.hasEffect(CardTemplate.CardEffect_SameTypeMorale) && !_loc_5.templateRef.hasEffect(CardTemplate.CardEffect_ImproveNeighbours) && _loc_5.getTotalPower() < param1 && (_loc_6 == null || _loc_6.templateRef.power + _loc_6.templateRef.GetBonusValue() < _loc_5.templateRef.power + _loc_5.templateRef.GetBonusValue()))
                {
                    _loc_6 = _loc_5;
                }
                _loc_4++;
            }
            return _loc_6;
        }// end function

    }
}
