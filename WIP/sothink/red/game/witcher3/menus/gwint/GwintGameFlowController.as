package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;
    import flash.events.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.managers.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;

    public class GwintGameFlowController extends UIComponent
    {
        public var currentPlayer:int = -1;
        public var closeMenuFunctor:Function;
        public var mcMessageQueue:W3MessageQueue;
        public var mcTutorials:GwintTutorial;
        public var mcChoiceDialog:W3ChoiceDialog;
        public var mcEndGameDialog:GwintEndGameDialog;
        private var cardManager:CardManager;
        private var currentRound:int;
        protected var allNeutralInRound:Boolean = true;
        protected var playedCreaturesInRound:Boolean = false;
        protected var lastRoundWinner:int = -1;
        protected var playedThreeHeroesOneRound:Boolean = false;
        public var playerControllers:Vector.<BasePlayerController>;
        public var gameStarted:Boolean = false;
        protected var sawRoundEndTutorial:Boolean = false;
        public var stateMachine:FiniteStateMachine;
        protected var _skipButton:InputFeedbackButton;
        protected var _mulliganCardsCount:int = 0;
        protected var _mulliganDecided:Boolean;
        protected var sawRoundStartTutorial:Boolean = false;
        private var sawStartMessage:Boolean;
        protected var sawScoreChangeTutorial:Boolean = false;
        protected var sawEndGameTutorial:Boolean = false;
        static var _instance:GwintGameFlowController;
        public static const COIN_TOSS_POPUP_NEEDED:String = "Gameflow.event.Cointoss.needed";

        public function GwintGameFlowController()
        {
            var _loc_1:* = null;
            _instance = this;
            this.stateMachine = new FiniteStateMachine();
            this.stateMachine.AddState("Initializing", null, this.state_update_Initializing, this.state_leave_Initializing);
            this.stateMachine.AddState("Tutorials", this.state_begin_Tutorials, this.state_update_Tutorials, null);
            this.stateMachine.AddState("SpawnLeaders", this.state_begin_SpawnLeaders, this.state_update_SpawnLeaders, null);
            this.stateMachine.AddState("CoinToss", this.state_begin_CoinToss, this.state_update_CoinToss, null);
            this.stateMachine.AddState("Mulligan", this.state_begin_Mulligan, this.state_update_Mulligan, null);
            this.stateMachine.AddState("RoundStart", this.state_begin_RoundStart, this.state_update_RoundStart, null);
            this.stateMachine.AddState("PlayerTurn", this.state_begin_PlayerTurn, this.state_update_PlayerTurn, this.state_leave_PlayerTurn);
            this.stateMachine.AddState("ChangingPlayer", this.state_begin_ChangingPlayer, this.state_update_ChangingPlayer, null);
            this.stateMachine.AddState("ShowingRoundResult", this.state_begin_ShowingRoundResult, this.state_update_ShowingRoundResult, null);
            this.stateMachine.AddState("ClearingBoard", this.state_begin_ClearingBoard, this.state_update_ClearingBoard, this.state_leave_ClearingBoard);
            this.stateMachine.AddState("ShowingFinalResult", this.state_begin_ShowingFinalResult, this.state_update_ShowingFinalResult, null);
            this.stateMachine.AddState("Reset", this.state_begin_reset, null, null);
            this.playerControllers = new Vector.<BasePlayerController>;
            _loc_1 = new HumanPlayerController();
            _loc_1.gameFlowControllerRef = this;
            _loc_1.playerID = CardManager.PLAYER_1;
            _loc_1.opponentID = CardManager.PLAYER_2;
            (_loc_1 as HumanPlayerController).skipButton = this._skipButton;
            this.playerControllers.Count(_loc_1);
            _loc_1 = new AIPlayerController();
            _loc_1.gameFlowControllerRef = this;
            _loc_1.playerID = CardManager.PLAYER_2;
            _loc_1.opponentID = CardManager.PLAYER_1;
            this.playerControllers.Count(_loc_1);
            this.currentRound = 0;
            return;
        }// end function

        protected function shouldDisallowStateChangeFunc() : Boolean
        {
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
            {
                return true;
            }
            return this.mcMessageQueue.ShowingMessage() || CardFXManager.getInstance().isPlayingAnyCardFX() || this.mcChoiceDialog.isShown() || CardTweenManager.getInstance().isAnyCardMoving();
        }// end function

        public function turnOnAI(param1:int) : void
        {
            var _loc_2:* = null;
            _loc_2 = new AIPlayerController();
            _loc_2.gameFlowControllerRef = this;
            _loc_2.playerID = CardManager.PLAYER_1;
            _loc_2.opponentID = CardManager.PLAYER_2;
            this.playerControllers[CardManager.PLAYER_1] = _loc_2;
            return;
        }// end function

        public function turnOffAI(param1:int) : void
        {
            var _loc_2:* = null;
            _loc_2 = new HumanPlayerController();
            _loc_2.gameFlowControllerRef = this;
            _loc_2.playerID = CardManager.PLAYER_1;
            _loc_2.opponentID = CardManager.PLAYER_2;
            (_loc_2 as HumanPlayerController).setChoiceDialog(this.mcChoiceDialog);
            this.playerControllers[CardManager.PLAYER_1] = _loc_2;
            return;
        }// end function

        public function get skipButton() : InputFeedbackButton
        {
            return this._skipButton;
        }// end function

        public function set skipButton(param1:InputFeedbackButton) : void
        {
            this._skipButton = param1;
            var _loc_2:* = this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController;
            if (_loc_2)
            {
                _loc_2.skipButton = this._skipButton;
            }
            return;
        }// end function

        protected function state_update_Initializing() : void
        {
            if (CardManager.getInstance() && CardManager.getInstance().cardTemplatesReceived && CardFXManager.getInstance() != null)
            {
                this.stateMachine.ChangeState("Tutorials");
            }
            return;
        }// end function

        protected function state_leave_Initializing() : void
        {
            var _loc_1:* = null;
            this.cardManager = CardManager.getInstance();
            if (!this.cardManager)
            {
                throw new Error("GFX --- Tried to link reference to card manager after initializing, was unable to!");
            }
            if (this.playerControllers[CardManager.PLAYER_1] is HumanPlayerController)
            {
                (this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController).setChoiceDialog(this.mcChoiceDialog);
            }
            this.playerControllers[CardManager.PLAYER_1].boardRenderer = this.cardManager.boardRenderer;
            this.playerControllers[CardManager.PLAYER_2].boardRenderer = this.cardManager.boardRenderer;
            this.playerControllers[CardManager.PLAYER_1].playerRenderer = this.cardManager.playerRenderers[CardManager.PLAYER_1];
            this.playerControllers[CardManager.PLAYER_2].playerRenderer = this.cardManager.playerRenderers[CardManager.PLAYER_2];
            this.stateMachine.pauseOnStateChangeIfFunc = this.shouldDisallowStateChangeFunc;
            if (this._skipButton != null)
            {
                _loc_1 = this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController;
                if (_loc_1)
                {
                    _loc_1.skipButton = this._skipButton;
                }
            }
            return;
        }// end function

        protected function state_begin_Tutorials() : void
        {
            return;
        }// end function

        protected function state_update_Tutorials() : void
        {
            if (!this.mcTutorials.visible || this.mcTutorials.isPaused)
            {
                this.stateMachine.ChangeState("SpawnLeaders");
                InputFeedbackManager.cleanupButtons();
                InputFeedbackManager.appendButtonById(GwintInputFeedback.navigate, NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                InputFeedbackManager.appendButtonById(GwintInputFeedback.quitGame, NavigationCode.START, KeyCode.Q, "gwint_pass_game");
            }
            return;
        }// end function

        protected function state_begin_SpawnLeaders() : void
        {
            Console.WriteLine("GFX ##########################################################");
            Console.WriteLine("GFX -#AI#-----------------------------------------------------------------------------------------------------");
            Console.WriteLine("GFX -#AI#----------------------------- NEW GWINT GAME ------------------------------------");
            Console.WriteLine("GFX -#AI#-----------------------------------------------------------------------------------------------------");
            this.cardManager.spawnLeaders();
            this.gameStarted = false;
            this.playedThreeHeroesOneRound = false;
            var _loc_1:* = this.cardManager.getCardLeader(CardManager.PLAYER_1);
            var _loc_2:* = this.cardManager.getCardLeader(CardManager.PLAYER_2);
            if (this.playerControllers[CardManager.PLAYER_1] is HumanPlayerController)
            {
                (this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController).attachToTutorialCarouselMessage();
            }
            this.playerControllers[CardManager.PLAYER_1].cardZoomEnabled = false;
            this.playerControllers[CardManager.PLAYER_2].cardZoomEnabled = false;
            this.playerControllers[CardManager.PLAYER_1].inputEnabled = true;
            this.playerControllers[CardManager.PLAYER_2].inputEnabled = true;
            if (_loc_1 != null && _loc_2 != null && _loc_1.templateId != _loc_2.templateId)
            {
                if (_loc_1.templateRef.getFirstEffect() == CardTemplate.CardEffect_Counter_King || _loc_2.templateRef.getFirstEffect() == CardTemplate.CardEffect_Counter_King)
                {
                    if (_loc_1.templateRef.getFirstEffect() != _loc_2.templateRef.getFirstEffect())
                    {
                        if (_loc_1.templateRef.getFirstEffect() == CardTemplate.CardEffect_Counter_King)
                        {
                            this.mcMessageQueue.PushMessage("[[gwint_player_counter_leader]]");
                            GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
                        }
                        else
                        {
                            this.mcMessageQueue.PushMessage("[[gwint_opponent_counter_leader]]");
                            GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
                        }
                    }
                    _loc_1.canBeUsed = false;
                    _loc_2.canBeUsed = false;
                    if (this.cardManager.boardRenderer)
                    {
                        this.cardManager.boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER, CardManager.PLAYER_1).updateLeaderStatus(false);
                        this.cardManager.boardRenderer.getCardHolder(CardManager.CARD_LIST_LOC_LEADER, CardManager.PLAYER_2).updateLeaderStatus(false);
                    }
                }
            }
            this.playerControllers[CardManager.PLAYER_1].currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE;
            this.playerControllers[CardManager.PLAYER_2].currentRoundStatus = BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE;
            return;
        }// end function

        protected function state_update_SpawnLeaders() : void
        {
            this.stateMachine.ChangeState("CoinToss");
            return;
        }// end function

        protected function state_begin_CoinToss() : void
        {
            var _loc_1:* = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction();
            var _loc_2:* = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction();
            Console.WriteLine("GFX - Coing flip logic, player1faction:", _loc_1, ", player2Faction:", _loc_2);
            if (_loc_1 != _loc_2 && !this.mcTutorials.visible && (_loc_1 == CardTemplate.FactionId_Scoiatael || _loc_2 == CardTemplate.FactionId_Scoiatael))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_scoia_tael_ability");
                if (_loc_1 == CardTemplate.FactionId_Scoiatael)
                {
                    this.currentPlayer = CardManager.PLAYER_INVALID;
                    dispatchEvent(new Event(COIN_TOSS_POPUP_NEEDED, false, false));
                }
                else
                {
                    this.currentPlayer = CardManager.PLAYER_2;
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_scoiatael_start_special]]", "sco_ability");
                }
            }
            else
            {
                if (this.mcTutorials.visible)
                {
                    this.currentPlayer = CardManager.PLAYER_1;
                }
                else
                {
                    this.currentPlayer = Math.floor(Math.random() * 2);
                }
                if (this.currentPlayer == CardManager.PLAYER_1)
                {
                    this.mcMessageQueue.PushMessage("[[gwint_player_will_go_first_message]]", "coin_flip_win");
                }
                else if (this.currentPlayer == CardManager.PLAYER_2)
                {
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_will_go_first]]", "coin_flip_loss");
                }
                GwintGameMenu.mSingleton.playSound("gui_gwint_coin_toss");
            }
            return;
        }// end function

        protected function state_update_CoinToss() : void
        {
            if (this.currentPlayer != CardManager.PLAYER_INVALID)
            {
                this.stateMachine.ChangeState("Mulligan");
            }
            return;
        }// end function

        protected function state_begin_Mulligan() : void
        {
            var _loc_1:* = null;
            this._mulliganDecided = false;
            this._mulliganCardsCount = 0;
            this.cardManager.shuffleAndDrawCards();
            _loc_1 = this.cardManager.getCardInstanceList(CardManager.CARD_LIST_LOC_HAND, CardManager.PLAYER_1);
            this.mcChoiceDialog.showDialogCardInstances(_loc_1, this.handleAcceptMulligan, this.handleDeclineMulligan, "[[gwint_can_choose_card_to_redraw]]");
            this.mcChoiceDialog.appendDialogText(" 0/2");
            if (this.mcTutorials.visible)
            {
                this.mcTutorials.continueTutorial();
                this.mcChoiceDialog.inputEnabled = false;
                this.mcTutorials.hideCarouselCB = this.handleDeclineMulligan;
                this.mcTutorials.changeChoiceCB = this.handleForceCardSelected;
            }
            GwintGameMenu.mSingleton.playSound("gui_gwint_draw_2");
            return;
        }// end function

        protected function state_update_Mulligan() : void
        {
            if (this._mulliganDecided && (!this.mcTutorials.visible || this.mcTutorials.isPaused))
            {
                this.stateMachine.ChangeState("RoundStart");
                this.mcChoiceDialog.hideDialog();
                this.gameStarted = true;
                this.playerControllers[CardManager.PLAYER_1].cardZoomEnabled = true;
                this.playerControllers[CardManager.PLAYER_2].cardZoomEnabled = true;
                GwintGameMenu.mSingleton.playSound("gui_gwint_game_start");
            }
            return;
        }// end function

        protected function handleAcceptMulligan(param1:int) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = this.cardManager.getCardInstance(param1);
            if (_loc_2)
            {
                _loc_3 = this.cardManager.mulliganCard(_loc_2);
                this.mcChoiceDialog.replaceCard(_loc_2, _loc_3);
                var _loc_4:* = this;
                var _loc_5:* = this._mulliganCardsCount + 1;
                _loc_4._mulliganCardsCount = _loc_5;
                GwintGameMenu.mSingleton.playSound("gui_gwint_card_redrawn");
                if (this._mulliganCardsCount < 2)
                {
                    this.mcChoiceDialog.updateDialogText("[[gwint_can_choose_card_to_redraw]]");
                    this.mcChoiceDialog.appendDialogText(" 1/2");
                }
                this._mulliganDecided = this._mulliganCardsCount >= 2;
            }
            return;
        }// end function

        protected function handleDeclineMulligan() : void
        {
            this.mcChoiceDialog.hideDialog();
            this._mulliganDecided = true;
            if (this.playerControllers[CardManager.PLAYER_1] is HumanPlayerController)
            {
                (this.playerControllers[CardManager.PLAYER_1] as HumanPlayerController).attachToTutorialCarouselMessage();
            }
            return;
        }// end function

        protected function handleForceCardSelected(param1:int) : void
        {
            if (this.mcChoiceDialog && this.mcChoiceDialog.visible)
            {
                this.mcChoiceDialog.cardsCarousel.selectedIndex = param1;
            }
            return;
        }// end function

        protected function state_begin_RoundStart() : void
        {
            this.mcMessageQueue.PushMessage("[[gwint_round_start]]", "round_start");
            this.allNeutralInRound = true;
            this.playedCreaturesInRound = false;
            if (this.lastRoundWinner != CardManager.PLAYER_INVALID && this.cardManager.playerDeckDefinitions[this.lastRoundWinner].getDeckFaction() == CardTemplate.FactionId_Northern_Kingdom)
            {
                this.mcMessageQueue.PushMessage("[[gwint_northern_ability_triggered]]", "north_ability", this.onShowNorthAbilityShown, null);
                GwintGameMenu.mSingleton.playSound("gui_gwint_northern_realms_ability");
            }
            return;
        }// end function

        protected function state_update_RoundStart() : void
        {
            if (!this.mcMessageQueue.ShowingMessage())
            {
                if (this.mcTutorials.visible && !this.sawRoundStartTutorial)
                {
                    this.sawRoundStartTutorial = true;
                    this.mcTutorials.continueTutorial();
                }
                this.playerControllers[CardManager.PLAYER_1].resetCurrentRoundStatus();
                this.playerControllers[CardManager.PLAYER_2].resetCurrentRoundStatus();
                if (this.playerControllers[this.currentPlayer].currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
                {
                    this.currentPlayer = this.currentPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
                    if (this.playerControllers[this.currentPlayer].currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
                    {
                        this.stateMachine.ChangeState("ShowingRoundResult");
                    }
                    else
                    {
                        this.stateMachine.ChangeState("PlayerTurn");
                    }
                }
                else
                {
                    this.stateMachine.ChangeState("PlayerTurn");
                }
            }
            return;
        }// end function

        protected function onShowNorthAbilityShown() : void
        {
            this.cardManager.drawCard(this.lastRoundWinner);
            return;
        }// end function

        protected function state_begin_PlayerTurn() : void
        {
            Console.WriteLine("GFX -#AI# starting player turn for player: " + this.currentPlayer);
            if (this.currentPlayer == CardManager.PLAYER_1)
            {
                this.mcMessageQueue.PushMessage("[[gwint_player_turn_start_message]]", "your_turn");
                GwintGameMenu.mSingleton.playSound("gui_gwint_your_turn");
            }
            else if (this.currentPlayer == CardManager.PLAYER_2)
            {
                this.mcMessageQueue.PushMessage("[[gwint_opponent_turn_start_message]]", "Opponents_turn");
                GwintGameMenu.mSingleton.playSound("gui_gwint_opponents_turn");
            }
            this.sawStartMessage = false;
            this.playerControllers[this.currentPlayer].playerRenderer.turnActive = true;
            return;
        }// end function

        protected function state_update_PlayerTurn() : void
        {
            var _loc_1:* = this.playerControllers[this.currentPlayer];
            var _loc_2:* = this.playerControllers[this.currentPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1)];
            if (!_loc_1)
            {
                throw new Error("GFX ---- currentPlayerController not found for player: " + this.currentPlayer.toString());
            }
            if (this.mcMessageQueue.ShowingMessage())
            {
                return;
            }
            if (!this.sawStartMessage)
            {
                this.sawStartMessage = true;
                _loc_1.startTurn();
            }
            if (_loc_1.turnOver)
            {
                if (this.mcTutorials.visible && !this.sawScoreChangeTutorial)
                {
                    if (this.cardManager.currentPlayerScores[CardManager.PLAYER_1] != 0 || this.cardManager.currentPlayerScores[CardManager.PLAYER_2] != 0)
                    {
                        this.sawScoreChangeTutorial = true;
                        this.mcTutorials.continueTutorial();
                    }
                }
                if (this.mcTutorials.visible && !this.mcTutorials.isPaused)
                {
                    return;
                }
                if (_loc_1.currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE)
                {
                    if (_loc_2.currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
                    {
                        _loc_1.startTurn();
                    }
                    else
                    {
                        this.stateMachine.ChangeState("ChangingPlayer");
                    }
                }
                else if (_loc_2.currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE)
                {
                    this.stateMachine.ChangeState("ChangingPlayer");
                }
                else
                {
                    this.stateMachine.ChangeState("ShowingRoundResult");
                }
            }
            return;
        }// end function

        protected function state_leave_PlayerTurn() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = 0;
            this.playerControllers[this.currentPlayer].playerRenderer.turnActive = false;
            if (this.allNeutralInRound || !this.playedCreaturesInRound)
            {
                _loc_1 = this.cardManager.getAllCreatures(CardManager.PLAYER_1);
                _loc_3 = 0;
                while (_loc_3 < _loc_1.length)
                {
                    
                    _loc_2 = _loc_1[_loc_3].templateRef;
                    if (!_loc_2.isType(CardTemplate.CardType_Spy))
                    {
                        this.playedCreaturesInRound = true;
                        if (_loc_2.factionIdx != CardTemplate.FactionId_Neutral)
                        {
                            this.allNeutralInRound = false;
                        }
                    }
                    _loc_3++;
                }
                _loc_1 = this.cardManager.getAllCreatures(CardManager.PLAYER_2);
                _loc_3 = 0;
                while (_loc_3 < _loc_1.length)
                {
                    
                    _loc_2 = _loc_1[_loc_3].templateRef;
                    if (_loc_2.isType(CardTemplate.CardType_Spy))
                    {
                        this.playedCreaturesInRound = true;
                        if (_loc_2.factionIdx != CardTemplate.FactionId_Neutral)
                        {
                            this.allNeutralInRound = false;
                        }
                    }
                    _loc_3++;
                }
            }
            return;
        }// end function

        protected function state_begin_ChangingPlayer() : void
        {
            if (this.playerControllers[this.currentPlayer].currentRoundStatus == BasePlayerController.ROUND_PLAYER_STATUS_DONE)
            {
                if (this.currentPlayer == CardManager.PLAYER_1)
                {
                    this.mcMessageQueue.PushMessage("[[gwint_player_passed_turn]]", "passed");
                }
                else
                {
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_passed_turn]]", "passed");
                }
            }
            return;
        }// end function

        protected function state_update_ChangingPlayer() : void
        {
            if (!this.mcMessageQueue.ShowingMessage())
            {
                this.currentPlayer = this.currentPlayer == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
                this.stateMachine.ChangeState("PlayerTurn");
            }
            return;
        }// end function

        protected function state_begin_ShowingRoundResult() : void
        {
            var _loc_6:* = 0;
            var _loc_1:* = this.cardManager.currentPlayerScores[CardManager.PLAYER_1];
            var _loc_2:* = this.cardManager.currentPlayerScores[CardManager.PLAYER_2];
            var _loc_3:* = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction();
            var _loc_4:* = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction();
            var _loc_5:* = CardManager.PLAYER_INVALID;
            this.playerControllers[CardManager.PLAYER_1].resetCurrentRoundStatus();
            this.playerControllers[CardManager.PLAYER_2].resetCurrentRoundStatus();
            if (this.mcTutorials.visible && !this.sawRoundEndTutorial)
            {
                this.sawRoundEndTutorial = true;
                this.mcTutorials.continueTutorial();
            }
            if (_loc_1 == _loc_2)
            {
                if (_loc_3 != _loc_4 && (_loc_3 == CardTemplate.FactionId_Nilfgaard || _loc_4 == CardTemplate.FactionId_Nilfgaard))
                {
                    this.mcMessageQueue.PushMessage("[[gwint_nilfgaard_ability_triggered]]", "nilf_ability");
                    GwintGameMenu.mSingleton.playSound("gui_gwint_nilfgaardian_ability");
                    if (_loc_3 == CardTemplate.FactionId_Nilfgaard)
                    {
                        this.mcMessageQueue.PushMessage("[[gwint_player_won_round]]", "battle_won");
                        _loc_5 = CardManager.PLAYER_1;
                        this.lastRoundWinner = CardManager.PLAYER_1;
                        GwintGameMenu.mSingleton.playSound("gui_gwint_clash_victory");
                    }
                    else
                    {
                        this.mcMessageQueue.PushMessage("[[gwint_opponent_won_round]]", "battle_lost");
                        _loc_5 = CardManager.PLAYER_2;
                        this.lastRoundWinner = CardManager.PLAYER_2;
                        GwintGameMenu.mSingleton.playSound("gui_gwint_clash_defeat");
                    }
                }
                else
                {
                    this.mcMessageQueue.PushMessage("[[gwint_round_draw]]", "battle_draw");
                    _loc_5 = CardManager.PLAYER_INVALID;
                    this.lastRoundWinner = CardManager.PLAYER_INVALID;
                    GwintGameMenu.mSingleton.playSound("gui_gwint_round_draw");
                    GwintGameMenu.mSingleton.playSound("gui_gwint_gem_destruction");
                }
            }
            else if (_loc_1 > _loc_2)
            {
                this.mcMessageQueue.PushMessage("[[gwint_player_won_round]]", "battle_won");
                _loc_5 = CardManager.PLAYER_1;
                this.lastRoundWinner = CardManager.PLAYER_1;
                GwintGameMenu.mSingleton.playSound("gui_gwint_clash_victory");
            }
            else
            {
                this.mcMessageQueue.PushMessage("[[gwint_opponent_won_round]]", "battle_lost");
                _loc_5 = CardManager.PLAYER_2;
                this.lastRoundWinner = CardManager.PLAYER_2;
                GwintGameMenu.mSingleton.playSound("gui_gwint_clash_defeat");
            }
            if (_loc_5 != CardManager.PLAYER_INVALID)
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_gem_destruction");
            }
            this.cardManager.roundResults[this.currentRound].setResults(_loc_1, _loc_2, _loc_5);
            this.cardManager.traceRoundResults();
            this.cardManager.updatePlayerLives();
            var _loc_7:* = 0;
            var _loc_8:* = this.cardManager.getAllCreatures(CardManager.PLAYER_1);
            _loc_6 = 0;
            while (_loc_6 < _loc_8.length)
            {
                
                if (_loc_8[_loc_6].templateRef.isType(CardTemplate.CardType_Hero))
                {
                    _loc_7++;
                }
                _loc_6++;
            }
            if (_loc_7 >= 3)
            {
                this.playedThreeHeroesOneRound = true;
            }
            if (this.allNeutralInRound && this.playedCreaturesInRound && _loc_5 == CardManager.PLAYER_1)
            {
                GwintGameMenu.mSingleton.sendNeutralRoundVictoryAchievement();
            }
            return;
        }// end function

        protected function state_update_ShowingRoundResult() : void
        {
            if (!this.mcMessageQueue.ShowingMessage())
            {
                if (this.currentRound == 2 || this.currentRound == 1 && (this.cardManager.roundResults[0].winningPlayer == this.cardManager.roundResults[1].winningPlayer || this.cardManager.roundResults[0].winningPlayer == CardManager.PLAYER_INVALID || this.cardManager.roundResults[1].winningPlayer == CardManager.PLAYER_INVALID))
                {
                    this.cardManager.clearBoard(false);
                    this.stateMachine.ChangeState("ShowingFinalResult");
                }
                else
                {
                    if (this.lastRoundWinner != CardManager.PLAYER_INVALID)
                    {
                        this.currentPlayer = this.lastRoundWinner;
                    }
                    this.stateMachine.ChangeState("ClearingBoard");
                }
            }
            return;
        }// end function

        protected function state_begin_ClearingBoard() : void
        {
            var _loc_1:* = false;
            if (this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction() == CardTemplate.FactionId_No_Mans_Land && this.cardManager.chooseCreatureToExclude(CardManager.PLAYER_1) != null)
            {
                _loc_1 = true;
            }
            else if (!_loc_1 && this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction() == CardTemplate.FactionId_No_Mans_Land && this.cardManager.chooseCreatureToExclude(CardManager.PLAYER_2) != null)
            {
                _loc_1 = true;
            }
            if (_loc_1)
            {
                this.mcMessageQueue.PushMessage("[[gwint_monster_faction_ability_triggered]]", "monster_ability");
                GwintGameMenu.mSingleton.playSound("gui_gwint_monster_ability");
            }
            this.cardManager.clearBoard(true);
            return;
        }// end function

        protected function state_update_ClearingBoard() : void
        {
            if (!this.mcMessageQueue.ShowingMessage())
            {
                this.cardManager.recalculateScores();
                var _loc_1:* = this;
                var _loc_2:* = this.currentRound + 1;
                _loc_1.currentRound = _loc_2;
                this.stateMachine.ChangeState("RoundStart");
            }
            return;
        }// end function

        protected function state_leave_ClearingBoard() : void
        {
            this.cardManager.recalculateScores();
            return;
        }// end function

        protected function state_begin_ShowingFinalResult() : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_1:* = CardManager.PLAYER_INVALID;
            var _loc_2:* = this.cardManager.roundResults[0].winningPlayer;
            var _loc_3:* = this.cardManager.roundResults[1].winningPlayer;
            if (this.currentRound == 1 && _loc_2 != _loc_3 && !this.cardManager.roundResults[2].played)
            {
                _loc_5 = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_1].getDeckFaction();
                _loc_6 = this.cardManager.playerDeckDefinitions[CardManager.PLAYER_2].getDeckFaction();
                if (_loc_5 != _loc_6)
                {
                    if (_loc_5 == CardTemplate.FactionId_Nilfgaard)
                    {
                        this.cardManager.roundResults[2].setResults(0, 0, CardManager.PLAYER_1);
                    }
                    else if (_loc_6 == CardTemplate.FactionId_Nilfgaard)
                    {
                        this.cardManager.roundResults[2].setResults(0, 0, CardManager.PLAYER_2);
                    }
                }
            }
            if (this.mcTutorials.visible && !this.sawEndGameTutorial)
            {
                this.sawEndGameTutorial = true;
                this.mcTutorials.continueTutorial();
            }
            var _loc_4:* = this.cardManager.roundResults[2].winningPlayer;
            this.playerControllers[CardManager.PLAYER_1].cardZoomEnabled = false;
            this.playerControllers[CardManager.PLAYER_2].cardZoomEnabled = false;
            this.playerControllers[CardManager.PLAYER_1].inputEnabled = false;
            this.playerControllers[CardManager.PLAYER_2].inputEnabled = false;
            this.mcChoiceDialog.hideDialog();
            if (this.currentRound == 1 && (_loc_2 == _loc_3 || _loc_2 == CardManager.PLAYER_INVALID || _loc_3 == CardManager.PLAYER_INVALID))
            {
                if (_loc_2 == CardManager.PLAYER_INVALID)
                {
                    _loc_1 = _loc_3;
                }
                else
                {
                    _loc_1 = _loc_2;
                }
            }
            else if (this.currentRound == 2)
            {
                if (_loc_2 == _loc_3 || _loc_2 == _loc_4)
                {
                    _loc_1 = _loc_2;
                }
                else if (_loc_3 == _loc_4)
                {
                    _loc_1 = _loc_3;
                }
            }
            else
            {
                throw new Error("GFX - Danger will robinson, danger!");
            }
            this.cardManager.traceRoundResults();
            Console.WriteLine("GFX -#AI#--- game winner was: " + _loc_1);
            Console.WriteLine("GFX -#AI#--- current round was: " + this.currentRound);
            Console.WriteLine("GFX -#AI#--- Round 1 winner: " + _loc_2);
            Console.WriteLine("GFX -#AI#--- Round 2 winner: " + _loc_2);
            Console.WriteLine("GFX -#AI#--- Round 3 winner: " + _loc_2);
            if (_loc_1 == CardManager.PLAYER_1)
            {
                if (this.playedThreeHeroesOneRound)
                {
                    GwintGameMenu.mSingleton.sendHeroRoundVictoryAchievement();
                }
                GwintGameMenu.mSingleton.playSound("gui_gwint_battle_won");
            }
            else if (_loc_1 == CardManager.PLAYER_2)
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_battle_lost");
            }
            else
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_battle_draw");
            }
            this.mcEndGameDialog.show(_loc_1, this.OnEndGameResult);
            return;
        }// end function

        protected function state_update_ShowingFinalResult() : void
        {
            return;
        }// end function

        protected function OnEndGameResult(param1:int) : void
        {
            if (param1 == GwintEndGameDialog.EndGameDialogResult_Restart)
            {
                this.stateMachine.ChangeState("Reset");
            }
            else
            {
                this.closeMenuFunctor(param1 == GwintEndGameDialog.EndGameDialogResult_EndVictory);
            }
            return;
        }// end function

        protected function state_begin_reset() : void
        {
            this.currentRound = 0;
            this.cardManager.reset();
            this.mcMessageQueue.PushMessage("[[gwint_resetting]]");
            this.stateMachine.ChangeState("SpawnLeaders");
            return;
        }// end function

        public static function getInstance() : GwintGameFlowController
        {
            return _instance;
        }// end function

    }
}
