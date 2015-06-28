package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;
    
    public class AIPlayerController extends red.game.witcher3.menus.gwint.BasePlayerController
    {
        public function AIPlayerController()
        {
            super();
            isAI = true;
            _stateMachine.AddState("Idle", this.state_begin_Idle, null, this.state_end_Idle);
            _stateMachine.AddState("ChoosingMove", this.state_begin_ChoseMove, this.state_update_ChooseMove, null);
            _stateMachine.AddState("SendingCardToTransaction", this.state_begin_SendingCard, this.state_update_SendingCard, null);
            _stateMachine.AddState("DelayBetweenActions", this.state_begin_DelayAction, this.state_update_DelayAction, null);
            _stateMachine.AddState("ApplyingCard", state_begin_ApplyingCard, state_update_ApplyingCard, null);
            return;
        }

        protected function getCardsBasedOnCriteria(arg1:int):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc3:*=0;
            var loc4:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc2:*=red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, playerID);
            var loc5:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc6:*=loc5.getCardLeader(playerID);
            if (loc6 && loc6.canBeUsed) 
            {
                loc6.recalculatePowerPotential(loc5);
                if (loc6.getOptimalTransaction().strategicValue != -1) 
                {
                    loc1.push(loc6);
                }
            }
            loc3 = 0;
            while (loc3 < loc2.length) 
            {
                loc4 = loc2[loc3];
                var loc7:*=arg1;
                switch (loc7) 
                {
                    case SortType_None:
                    {
                        loc1.push(loc4);
                        break;
                    }
                    case SortType_PowerChange:
                    {
                        if (loc4.getOptimalTransaction().powerChangeResult >= 0) 
                        {
                            loc1.push(loc4);
                        }
                        break;
                    }
                    case SortType_StrategicValue:
                    {
                        if (loc4.getOptimalTransaction().strategicValue >= 0) 
                        {
                            loc1.push(loc4);
                        }
                        break;
                    }
                }
                ++loc3;
            }
            loc7 = arg1;
            switch (loc7) 
            {
                case SortType_StrategicValue:
                {
                    loc1.sort(this.strategicValueSorter);
                    break;
                }
                case SortType_PowerChange:
                {
                    loc1.sort(this.powerChangeSorter);
                    break;
                }
            }
            return loc1;
        }

        protected function strategicValueSorter(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance):Number
        {
            return arg1.getOptimalTransaction().strategicValue - arg2.getOptimalTransaction().strategicValue;
        }

        public override function startTurn():void
        {
            if (currentRoundStatus == red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE) 
            {
                return;
            }
            super.startTurn();
            _stateMachine.ChangeState("ChoosingMove");
            return;
        }

        protected function state_begin_Idle():void
        {
            if (this.attitude == TACTIC_PASS) 
            {
                currentRoundStatus = red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE;
            }
            _turnOver = true;
            if (red.game.witcher3.menus.gwint.CardManager.getInstance().getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, playerID).length == 0 && !(red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID) == null) && !red.game.witcher3.menus.gwint.CardManager.getInstance().getCardLeader(playerID).canBeUsed) 
            {
                currentRoundStatus = red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE;
            }
            if (_boardRenderer) 
            {
                _boardRenderer.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER, playerID).updateLeaderStatus(false);
            }
            return;
        }

        protected function state_end_Idle():void
        {
            if (_boardRenderer) 
            {
                _boardRenderer.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER, playerID).updateLeaderStatus(true);
            }
            return;
        }

        protected function attitudeToString(arg1:int):String
        {
            var loc1:*=arg1;
            switch (loc1) 
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
            }
            return arg1.toString();
        }

        protected function state_begin_ChoseMove():void
        {
            red.game.witcher3.menus.gwint.CardManager.getInstance().CalculateCardPowerPotentials();
            this.ChooseAttitude();
            var loc1:*=this.attitudeToString(this.attitude);
            trace("GFX -#AI# ai has decided to use the following attitude:" + loc1);
            _decidedCardTransaction = this.decideWhichCardToPlay();
            if (_decidedCardTransaction == null && !(this.attitude == TACTIC_PASS)) 
            {
                this.attitude = TACTIC_PASS;
            }
            else if (this._currentRoundCritical && !(_decidedCardTransaction == null) && !_decidedCardTransaction.sourceCardInstanceRef.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy) && _decidedCardTransaction.powerChangeResult < 0 && red.game.witcher3.menus.gwint.CardManager.getInstance().getAllCreaturesInHand(playerID).length == 0) 
            {
                _decidedCardTransaction = null;
                this.attitude = TACTIC_PASS;
            }
            trace("GFX -#AI# the ai decided on the following transaction: " + _decidedCardTransaction);
            return;
        }

        protected function state_update_ChooseMove():void
        {
            if (this.attitude == TACTIC_PASS || _decidedCardTransaction == null) 
            {
                _stateMachine.ChangeState("Idle");
                if (this.attitude != TACTIC_PASS) 
                {
                    trace("GFX -#AI#--------------- WARNING ---------- AI is passing since chosen tactic was unable to find a transaction is liked");
                }
                this.attitude = TACTIC_PASS;
            }
            else 
            {
                _stateMachine.ChangeState("SendingCardToTransaction");
            }
            return;
        }

        protected function state_begin_SendingCard():void
        {
            trace("GFX -#AI# AI is sending the following card into transaction: ", _decidedCardTransaction.sourceCardInstanceRef);
            startCardTransaction(_decidedCardTransaction.sourceCardInstanceRef.instanceId);
            return;
        }

        protected function state_update_SendingCard():void
        {
            if (!red.game.witcher3.menus.gwint.CardTweenManager.getInstance().isAnyCardMoving()) 
            {
                _stateMachine.ChangeState("DelayBetweenActions");
            }
            return;
        }

        protected function powerChangeSorter(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:red.game.witcher3.menus.gwint.CardInstance):Number
        {
            if (arg1.getOptimalTransaction().powerChangeResult == arg2.getOptimalTransaction().powerChangeResult) 
            {
                return arg1.getOptimalTransaction().strategicValue - arg2.getOptimalTransaction().strategicValue;
            }
            return arg1.getOptimalTransaction().powerChangeResult - arg2.getOptimalTransaction().powerChangeResult;
        }

        protected function getHighestValueCardOnBoard():red.game.witcher3.menus.gwint.CardInstance
        {
            var loc3:*=0;
            var loc4:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc2:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, playerID, loc1);
            loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, playerID, loc1);
            loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, playerID, loc1);
            var loc5:*=null;
            loc3 = 0;
            while (loc3 < loc1.length) 
            {
                loc4 = loc1[loc3];
                if (loc5 == null || loc4.templateRef.power + loc4.templateRef.GetBonusValue() > loc5.templateRef.power + loc5.templateRef.GetBonusValue()) 
                {
                    loc5 = loc4;
                }
                ++loc3;
            }
            return loc5;
        }

        protected function state_begin_DelayAction():void
        {
            this.waitingForTimer = true;
            this.waitingTimer = new flash.utils.Timer(1200, 1);
            this.waitingTimer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, this.onWaitingTimerEnded, false, 0, true);
            this.waitingTimer.start();
            return;
        }

        protected function state_update_DelayAction():void
        {
            if (!this.waitingForTimer) 
            {
                _stateMachine.ChangeState("ApplyingCard");
            }
            return;
        }

        protected function onWaitingTimerEnded(arg1:flash.events.TimerEvent):void
        {
            this.waitingForTimer = false;
            this.waitingTimer = null;
            return;
        }

        protected function getHighestValueCardOnBoardWithEffectLessThan(arg1:int):red.game.witcher3.menus.gwint.CardInstance
        {
            var loc3:*=0;
            var loc4:*=null;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc2:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE, playerID, loc1);
            loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED, playerID, loc1);
            loc2.getAllCreaturesNonHero(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE, playerID, loc1);
            var loc5:*=null;
            loc3 = 0;
            while (loc3 < loc1.length) 
            {
                loc4 = loc1[loc3];
                if (!loc4.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SameTypeMorale) && !loc4.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours) && loc4.getTotalPower() < arg1 && (loc5 == null || loc5.templateRef.power + loc5.templateRef.GetBonusValue() < loc4.templateRef.power + loc4.templateRef.GetBonusValue())) 
                {
                    loc5 = loc4;
                }
                ++loc3;
            }
            return loc5;
        }

        private function ChooseAttitude():void
        {
            var loc3:*=0;
            var loc4:*=0;
            var loc5:*=0;
            var loc19:*=NaN;
            var loc20:*=undefined;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc2:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            loc2 = loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, playerID);
            if (loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, playerID).length == 0) 
            {
                this.attitude = TACTIC_PASS;
                return;
            }
            var loc6:*=false;
            var loc7:*=false;
            var loc8:*=0;
            var loc9:*=0;
            var loc10:*=0;
            loc4 = 0;
            while (loc4 < loc1.roundResults.length) 
            {
                if (loc1.roundResults[loc4].played) 
                {
                    loc5 = loc1.roundResults[loc4].winningPlayer;
                    if (loc5 == playerID || loc5 == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                    {
                        loc6 = true;
                    }
                    if (loc5 == opponentID || loc5 == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                    {
                        loc7 = true;
                    }
                }
                ++loc4;
            }
            this._currentRoundCritical = loc7;
            loc3 = 0;
            while (loc3 < loc2.length) 
            {
                if (loc2[loc3].templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
                {
                    ++loc8;
                }
                ++loc3;
            }
            var loc11:*=loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, playerID).length;
            var loc12:*=loc1.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, opponentID).length;
            var loc13:*=loc11 - loc12;
            var loc14:*=loc1.currentPlayerScores[playerID] - loc1.currentPlayerScores[opponentID];
            var loc15:*=gameFlowControllerRef.playerControllers[opponentID].currentRoundStatus;
            trace("GFX -#AI# ###############################################################################");
            trace("GFX -#AI#---------------------------- AI Deciding his next move --------------------------------");
            trace("GFX -#AI#------ previousTactic: " + this.attitudeToString(this.attitude));
            trace("GFX -#AI#------ playerCardsInHand: " + loc11);
            trace("GFX -#AI#------ opponentCardsInHand: " + loc12);
            trace("GFX -#AI#------ cardAdvantage: " + loc13);
            trace("GFX -#AI#------ scoreDifference: " + loc14 + ", his score: " + loc1.currentPlayerScores[playerID] + ", enemy score: " + loc1.currentPlayerScores[opponentID]);
            trace("GFX -#AI#------ opponent has won: " + loc7);
            trace("GFX -#AI#------ has won: " + loc6);
            trace("GFX -#AI#------ Num units in hand: " + loc8);
            if (gameFlowControllerRef.playerControllers[opponentID].currentRoundStatus != ROUND_PLAYER_STATUS_DONE) 
            {
                trace("GFX -#AI#------ has opponent passed: false");
            }
            else 
            {
                trace("GFX -#AI#------ has opponent passed: true");
            }
            trace("GFX =#AI#=======================================================================================");
            trace("GFX -#AI#-----------------------------   AI CARDS AT HAND   ------------------------------------");
            loc3 = 0;
            while (loc3 < loc2.length) 
            {
                trace("GFX -#AI# Card Points[ ", loc2[loc3].templateRef.power, " ], Card -", loc2[loc3]);
                ++loc3;
            }
            trace("GFX =#AI#=======================================================================================");
            var loc16:*=loc1.playerDeckDefinitions[playerID].getDeckFaction();
            var loc17:*=loc1.playerDeckDefinitions[opponentID].getDeckFaction();
            var loc18:*=loc1.getCardsInSlotIdWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, opponentID).length;
            if (loc16 == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard && !(loc17 == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard) && loc15 == ROUND_PLAYER_STATUS_DONE && loc14 == 0) 
            {
                this.attitude = TACTIC_PASS;
            }
            else if (!loc7 && this.attitude == TACTIC_SPY_DUMMY_BEST_THEN_PASS) 
            {
                if (loc15 != ROUND_PLAYER_STATUS_DONE) 
                {
                    this.attitude == TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                }
            }
            else if (!loc7 && !(loc1.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID) == null) && (Math.random() < 0.2 || loc18 > 1) && !(this.attitude == TACTIC_SPY_DUMMY_BEST_THEN_PASS)) 
            {
                this.attitude = TACTIC_SPY;
            }
            else if (this.attitude == TACTIC_SPY && !(loc1.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID) == null)) 
            {
                this.attitude = TACTIC_SPY;
            }
            else if (loc15 != ROUND_PLAYER_STATUS_DONE) 
            {
                if (loc14 > 0) 
                {
                    if (loc7) 
                    {
                        this.attitude = TACTIC_JUST_WAIT;
                    }
                    else 
                    {
                        loc19 = loc8 * loc8 / 36;
                        this.attitude = TACTIC_NONE;
                        if (loc6) 
                        {
                            loc9 = loc1.getCardsInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy, playerID).length;
                            loc10 = loc1.getCardsInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID).length;
                            if (Math.random() < 0.2 || loc11 == loc9 + loc10) 
                            {
                                this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                            }
                            else 
                            {
                                loc20 = loc1.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy, playerID);
                                if (!(loc20 == null) && !(loc1.getHigherOrLowerValueTargetCardOnBoard(loc20, playerID, false) == null)) 
                                {
                                    this.attitude = TACTIC_WAIT_DUMMY;
                                }
                                else if (Math.random() < loc14 / 30 && Math.random() < loc19) 
                                {
                                    this.attitude = TACTIC_MAXIMIZE_WIN;
                                }
                            }
                        }
                        if (this.attitude == TACTIC_NONE) 
                        {
                            if (Math.random() < loc11 / 10 || loc11 > 8) 
                            {
                                if (Math.random() < 0.2 || loc11 == loc9 + loc10) 
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
                else if (loc6) 
                {
                    loc9 = loc1.getCardsInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy, playerID).length;
                    loc10 = loc1.getCardsInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID).length;
                    if (!loc7 && (Math.random() < 0.2 || loc11 == loc9 + loc10)) 
                    {
                        this.attitude = TACTIC_SPY_DUMMY_BEST_THEN_PASS;
                    }
                    else 
                    {
                        this.attitude = TACTIC_MAXIMIZE_WIN;
                    }
                }
                else if (loc7) 
                {
                    this.attitude = TACTIC_MINIMAL_WIN;
                }
                else if (!loc1.roundResults[0].played && loc14 < -11 && Math.random() < (Math.abs(loc14) - 10) / 20) 
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
                else if (Math.random() < loc11 / 10) 
                {
                    this.attitude = TACTIC_MINIMAL_WIN;
                }
                else if (Math.random() < loc11 / 10) 
                {
                    this.attitude = TACTIC_AVERAGE_WIN;
                }
                else if (Math.random() < loc11 / 10) 
                {
                    this.attitude = TACTIC_MAXIMIZE_WIN;
                }
                else if (loc11 <= 8 && Math.random() > loc11 / 10) 
                {
                    this.attitude = TACTIC_PASS;
                }
                else 
                {
                    this.attitude = TACTIC_JUST_WAIT;
                }
            }
            else if (this.attitude != TACTIC_MINIMIZE_LOSS) 
            {
                if (!loc7 && loc14 <= 0 && Math.random() < loc14 / 20) 
                {
                    this.attitude = TACTIC_MINIMIZE_LOSS;
                }
                else if (!loc6 && loc14 > 0) 
                {
                    this.attitude = TACTIC_MINIMIZE_WIN;
                }
                else if (loc14 > 0) 
                {
                    this.attitude = TACTIC_PASS;
                }
                else 
                {
                    this.attitude = TACTIC_MINIMAL_WIN;
                }
            }
            else 
            {
                this.attitude = TACTIC_MINIMIZE_LOSS;
            }
            return;
        }

        protected function decideWhichCardToPlay():red.game.witcher3.menus.gwint.CardTransaction
        {
            var loc1:*=null;
            var loc2:*=0;
            var loc7:*=null;
            var loc8:*=null;
            var loc9:*=null;
            var loc10:*=0;
            var loc11:*=0;
            var loc3:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc4:*=loc3.currentPlayerScores[playerID];
            var loc5:*=loc3.currentPlayerScores[opponentID];
            var loc6:*=loc4 - loc5;
            var loc12:*=this.attitude;
            switch (loc12) 
            {
                case TACTIC_SPY_DUMMY_BEST_THEN_PASS:
                {
                    loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID);
                    if (loc8 != null) 
                    {
                        return loc8.getOptimalTransaction();
                    }
                    loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (loc8) 
                    {
                        loc9 = loc3.getHigherOrLowerValueTargetCardOnBoard(loc8, playerID, true, true);
                        if (loc9) 
                        {
                            loc7 = loc8.getOptimalTransaction();
                            loc7.targetCardInstanceRef = loc9;
                            return loc7;
                        }
                    }
                    this.attitude = TACTIC_PASS;
                    break;
                }
                case TACTIC_MINIMIZE_LOSS:
                {
                    loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (loc8) 
                    {
                        loc9 = this.getHighestValueCardOnBoard();
                        if (loc9) 
                        {
                            loc7 = loc8.getOptimalTransaction();
                            loc7.targetCardInstanceRef = loc9;
                            return loc7;
                        }
                    }
                    loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID);
                    if (loc8 != null) 
                    {
                        return loc8.getOptimalTransaction();
                    }
                    this.attitude = TACTIC_PASS;
                    break;
                }
                case TACTIC_MINIMIZE_WIN:
                {
                    loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (loc8) 
                    {
                        loc9 = this.getHighestValueCardOnBoardWithEffectLessThan(loc6);
                        if (loc9) 
                        {
                            loc7 = loc8.getOptimalTransaction();
                            if (loc7) 
                            {
                                loc7.targetCardInstanceRef = loc9;
                                return loc7;
                            }
                        }
                    }
                    loc1 = loc3.getCardsInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID);
                    loc2 = 0;
                    while (loc2 < loc1.length) 
                    {
                        loc8 = loc1[loc2];
                        if (loc8 && Math.abs(loc8.getOptimalTransaction().powerChangeResult) < Math.abs(loc6)) 
                        {
                            return loc8.getOptimalTransaction();
                        }
                        ++loc2;
                    }
                    this.attitude = TACTIC_PASS;
                    break;
                }
                case TACTIC_MAXIMIZE_WIN:
                {
                    loc1 = this.getCardsBasedOnCriteria(SortType_PowerChange);
                    if (loc1.length > 0) 
                    {
                        loc9 = loc1[(loc1.length - 1)];
                        if (loc9) 
                        {
                            return loc9.getOptimalTransaction();
                        }
                    }
                    break;
                }
                case TACTIC_AVERAGE_WIN:
                {
                    loc1 = this.getCardsBasedOnCriteria(SortType_PowerChange);
                    loc10 = -1;
                    while (loc2 < loc1.length && loc10 == -1) 
                    {
                        loc8 = loc1[loc2];
                        if (loc8.getOptimalTransaction().powerChangeResult > Math.abs(loc6)) 
                        {
                            loc10 = loc2;
                        }
                        ++loc2;
                    }
                    if (loc10 == -1) 
                    {
                        if (loc1.length > 0) 
                        {
                            loc9 = loc1[(loc1.length - 1)];
                            if (loc9) 
                            {
                                return loc9.getOptimalTransaction();
                            }
                        }
                    }
                    else 
                    {
                        loc11 = Math.min(loc10, Math.max((loc1.length - 1), loc10 + Math.floor(Math.random() * ((loc1.length - 1) - loc10))));
                        loc9 = loc1[loc11];
                        if (loc9) 
                        {
                            return loc9.getOptimalTransaction();
                        }
                    }
                    break;
                }
                case TACTIC_MINIMAL_WIN:
                {
                    loc1 = this.getCardsBasedOnCriteria(SortType_PowerChange);
                    loc2 = 0;
                    while (loc2 < loc1.length) 
                    {
                        loc8 = loc1[loc2];
                        if (loc8.getOptimalTransaction().powerChangeResult > Math.abs(loc6)) 
                        {
                            loc9 = loc8;
                            break;
                        }
                        ++loc2;
                    }
                    if (!loc9 && loc1.length > 0) 
                    {
                        loc9 = loc1[(loc1.length - 1)];
                    }
                    if (loc9) 
                    {
                        return loc9.getOptimalTransaction();
                    }
                    break;
                }
                case TACTIC_JUST_WAIT:
                {
                    loc1 = this.getCardsBasedOnCriteria(SortType_StrategicValue);
                    if (loc1.length == 0) 
                    {
                        return null;
                    }
                    loc2 = 0;
                    while (loc2 < loc1.length) 
                    {
                        loc7 = loc1[loc2].getOptimalTransaction();
                        if (loc7) 
                        {
                            if (this._currentRoundCritical) 
                            {
                                if (loc7 && loc7.sourceCardInstanceRef.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather) && (loc7.powerChangeResult < 0 || loc7.powerChangeResult < loc7.sourceCardInstanceRef.potentialWeatherHarm())) 
                                {
                                    loc7 = null;
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
                        ++loc2;
                    }
                    return loc7;
                }
                case TACTIC_WAIT_DUMMY:
                {
                    loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy, playerID);
                    if (loc8 != null) 
                    {
                        loc7 = loc8.getOptimalTransaction();
                        if (loc7.targetCardInstanceRef == null) 
                        {
                            loc7.targetCardInstanceRef = loc3.getHigherOrLowerValueTargetCardOnBoard(loc8, playerID, false);
                        }
                        if (loc7.targetCardInstanceRef != null) 
                        {
                            return loc7;
                        }
                    }
                    trace("GFX [ WARNING ] -#AI#---- Uh oh, was in TACTIC_WAIT_DUMMY but was unable to get a valid dummy transaction :S");
                    break;
                }
                case TACTIC_SPY:
                {
                    loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID);
                    if (loc8 != null) 
                    {
                        return loc8.getOptimalTransaction();
                    }
                    break;
                }
            }
            if (!(this.attitude == TACTIC_PASS) && !(this.attitude == TACTIC_MINIMIZE_WIN)) 
            {
                loc8 = loc3.getFirstCardInHandWithEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2, playerID);
                if (loc8 != null) 
                {
                    return loc8.getOptimalTransaction();
                }
            }
            return null;
        }

        protected static const TACTIC_NONE:int=0;

        protected static const TACTIC_SPY_DUMMY_BEST_THEN_PASS:int=1;

        protected static const TACTIC_MINIMIZE_LOSS:int=1;

        protected static const TACTIC_MINIMIZE_WIN:int=2;

        protected static const TACTIC_MAXIMIZE_WIN:int=3;

        protected static const TACTIC_AVERAGE_WIN:int=4;

        protected static const TACTIC_MINIMAL_WIN:int=5;

        protected static const TACTIC_JUST_WAIT:int=6;

        protected static const TACTIC_PASS:int=7;

        protected static const TACTIC_WAIT_DUMMY:int=8;

        protected static const TACTIC_SPY:int=9;

        private static const SortType_None:int=0;

        private static const SortType_StrategicValue:int=1;

        private static const SortType_PowerChange:int=2;

        protected var attitude:int;

        protected var chances:int;

        protected var waitingForTimer:Boolean;

        protected var waitingTimer:flash.utils.Timer;

        protected var _currentRoundCritical:Boolean=false;
    }
}
