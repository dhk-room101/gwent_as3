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
    
    public class GwintGameFlowController extends scaleform.clik.core.UIComponent
    {
        public function GwintGameFlowController()
        {
            var loc1:*=null;
            super();
            _instance = this;
            this.stateMachine = new red.game.witcher3.utils.FiniteStateMachine();
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
            this.playerControllers = new Vector.<red.game.witcher3.menus.gwint.BasePlayerController>();
            loc1 = new red.game.witcher3.menus.gwint.HumanPlayerController();
            loc1.gameFlowControllerRef = this;
            loc1.playerID = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
            loc1.opponentID = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            (loc1 as red.game.witcher3.menus.gwint.HumanPlayerController).skipButton = this._skipButton;
            this.playerControllers.push(loc1);
            loc1 = new red.game.witcher3.menus.gwint.AIPlayerController();
            loc1.gameFlowControllerRef = this;
            loc1.playerID = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            loc1.opponentID = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
            this.playerControllers.push(loc1);
            this.currentRound = 0;
            return;
        }

        protected function state_update_RoundStart():void
        {
            if (!this.mcMessageQueue.ShowingMessage()) 
            {
                if (this.mcTutorials.visible && !this.sawRoundStartTutorial) 
                {
                    this.sawRoundStartTutorial = true;
                    this.mcTutorials.continueTutorial();
                }
                this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].resetCurrentRoundStatus();
                this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].resetCurrentRoundStatus();
                if (this.playerControllers[this.currentPlayer].currentRoundStatus != red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE) 
                {
                    this.stateMachine.ChangeState("PlayerTurn");
                }
                else 
                {
                    this.currentPlayer = this.currentPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                    if (this.playerControllers[this.currentPlayer].currentRoundStatus != red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE) 
                    {
                        this.stateMachine.ChangeState("PlayerTurn");
                    }
                    else 
                    {
                        this.stateMachine.ChangeState("ShowingRoundResult");
                    }
                }
            }
            return;
        }

        protected function onShowNorthAbilityShown():void
        {
            this.cardManager.drawCard(this.lastRoundWinner);
            return;
        }

        protected function state_begin_PlayerTurn():void
        {
            trace("GFX -#AI# starting player turn for player: " + this.currentPlayer);
            if (this.currentPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
            {
                if (this.currentPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_turn_start_message]]", "Opponents_turn");
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_opponents_turn");
                }
            }
            else 
            {
                this.mcMessageQueue.PushMessage("[[gwint_player_turn_start_message]]", "your_turn");
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_your_turn");
            }
            this.sawStartMessage = false;
            this.playerControllers[this.currentPlayer].playerRenderer.turnActive = true;
            return;
        }

        protected function state_update_PlayerTurn():void
        {
            var loc1:*=this.playerControllers[this.currentPlayer];
            var loc2:*=this.playerControllers[this.currentPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2];
            if (!loc1) 
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
                loc1.startTurn();
            }
            if (loc1.turnOver) 
            {
                if (this.mcTutorials.visible && !this.sawScoreChangeTutorial) 
                {
                    if (!(this.cardManager.currentPlayerScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] == 0) || !(this.cardManager.currentPlayerScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_2] == 0)) 
                    {
                        this.sawScoreChangeTutorial = true;
                        this.mcTutorials.continueTutorial();
                    }
                }
                if (this.mcTutorials.visible && !this.mcTutorials.isPaused) 
                {
                    return;
                }
                if (loc1.currentRoundStatus != red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE) 
                {
                    if (loc2.currentRoundStatus != red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE) 
                    {
                        this.stateMachine.ChangeState("ShowingRoundResult");
                    }
                    else 
                    {
                        this.stateMachine.ChangeState("ChangingPlayer");
                    }
                }
                else if (loc2.currentRoundStatus != red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE) 
                {
                    this.stateMachine.ChangeState("ChangingPlayer");
                }
                else 
                {
                    loc1.startTurn();
                }
            }
            return;
        }

        protected function state_leave_PlayerTurn():void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=0;
            this.playerControllers[this.currentPlayer].playerRenderer.turnActive = false;
            if (this.allNeutralInRound || !this.playedCreaturesInRound) 
            {
                loc1 = this.cardManager.getAllCreatures(red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
                loc3 = 0;
                while (loc3 < loc1.length) 
                {
                    loc2 = loc1[loc3].templateRef;
                    if (!loc2.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
                    {
                        this.playedCreaturesInRound = true;
                        if (loc2.factionIdx != red.game.witcher3.menus.gwint.CardTemplate.FactionId_Neutral) 
                        {
                            this.allNeutralInRound = false;
                        }
                    }
                    ++loc3;
                }
                loc1 = this.cardManager.getAllCreatures(red.game.witcher3.menus.gwint.CardManager.PLAYER_2);
                loc3 = 0;
                while (loc3 < loc1.length) 
                {
                    loc2 = loc1[loc3].templateRef;
                    if (loc2.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
                    {
                        this.playedCreaturesInRound = true;
                        if (loc2.factionIdx != red.game.witcher3.menus.gwint.CardTemplate.FactionId_Neutral) 
                        {
                            this.allNeutralInRound = false;
                        }
                    }
                    ++loc3;
                }
            }
            return;
        }

        protected function state_begin_ChangingPlayer():void
        {
            if (this.playerControllers[this.currentPlayer].currentRoundStatus == red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_DONE) 
            {
                if (this.currentPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_passed_turn]]", "passed");
                }
                else 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_player_passed_turn]]", "passed");
                }
            }
            return;
        }

        protected function state_begin_RoundStart():void
        {
            this.mcMessageQueue.PushMessage("[[gwint_round_start]]", "round_start");
            this.allNeutralInRound = true;
            this.playedCreaturesInRound = false;
            if (!(this.lastRoundWinner == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) && this.cardManager.playerDeckDefinitions[this.lastRoundWinner].getDeckFaction() == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Northern_Kingdom) 
            {
                this.mcMessageQueue.PushMessage("[[gwint_northern_ability_triggered]]", "north_ability", this.onShowNorthAbilityShown, null);
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_northern_realms_ability");
            }
            return;
        }

        protected function state_update_ChangingPlayer():void
        {
            if (!this.mcMessageQueue.ShowingMessage()) 
            {
                this.currentPlayer = this.currentPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1 ? red.game.witcher3.menus.gwint.CardManager.PLAYER_1 : red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                this.stateMachine.ChangeState("PlayerTurn");
            }
            return;
        }

        protected function state_begin_ShowingRoundResult():void
        {
            var loc6:*=0;
            var loc1:*=this.cardManager.currentPlayerScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_1];
            var loc2:*=this.cardManager.currentPlayerScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_2];
            var loc3:*=this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].getDeckFaction();
            var loc4:*=this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].getDeckFaction();
            var loc5:*=red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].resetCurrentRoundStatus();
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].resetCurrentRoundStatus();
            if (this.mcTutorials.visible && !this.sawRoundEndTutorial) 
            {
                this.sawRoundEndTutorial = true;
                this.mcTutorials.continueTutorial();
            }
            if (loc1 != loc2) 
            {
                if (loc1 > loc2) 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_player_won_round]]", "battle_won");
                    loc5 = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
                    this.lastRoundWinner = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_clash_victory");
                }
                else 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_won_round]]", "battle_lost");
                    loc5 = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                    this.lastRoundWinner = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_clash_defeat");
                }
            }
            else if (!(loc3 == loc4) && (loc3 == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard || loc4 == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard)) 
            {
                this.mcMessageQueue.PushMessage("[[gwint_nilfgaard_ability_triggered]]", "nilf_ability");
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_nilfgaardian_ability");
                if (loc3 != red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard) 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_won_round]]", "battle_lost");
                    loc5 = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                    this.lastRoundWinner = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_clash_defeat");
                }
                else 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_player_won_round]]", "battle_won");
                    loc5 = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
                    this.lastRoundWinner = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_clash_victory");
                }
            }
            else 
            {
                this.mcMessageQueue.PushMessage("[[gwint_round_draw]]", "battle_draw");
                loc5 = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
                this.lastRoundWinner = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_round_draw");
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_gem_destruction");
            }
            if (loc5 != red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_gem_destruction");
            }
            this.cardManager.roundResults[this.currentRound].setResults(loc1, loc2, loc5);
            this.cardManager.traceRoundResults();
            this.cardManager.updatePlayerLives();
            var loc7:*=0;
            var loc8:*=this.cardManager.getAllCreatures(red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
            loc6 = 0;
            while (loc6 < loc8.length) 
            {
                if (loc8[loc6].templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
                {
                    ++loc7;
                }
                ++loc6;
            }
            if (loc7 >= 3) 
            {
                this.playedThreeHeroesOneRound = true;
            }
            if (this.allNeutralInRound && this.playedCreaturesInRound && loc5 == red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.sendNeutralRoundVictoryAchievement();
            }
            return;
        }

        protected function state_update_ShowingRoundResult():void
        {
            if (!this.mcMessageQueue.ShowingMessage()) 
            {
                if (this.currentRound == 2 || this.currentRound == 1 && (this.cardManager.roundResults[0].winningPlayer == this.cardManager.roundResults[1].winningPlayer || this.cardManager.roundResults[0].winningPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID || this.cardManager.roundResults[1].winningPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID)) 
                {
                    this.cardManager.clearBoard(false);
                    this.stateMachine.ChangeState("ShowingFinalResult");
                }
                else 
                {
                    if (this.lastRoundWinner != red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                    {
                        this.currentPlayer = this.lastRoundWinner;
                    }
                    this.stateMachine.ChangeState("ClearingBoard");
                }
            }
            return;
        }

        protected function state_begin_ClearingBoard():void
        {
            var loc1:*=false;
            if (this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].getDeckFaction() == red.game.witcher3.menus.gwint.CardTemplate.FactionId_No_Mans_Land && !(this.cardManager.chooseCreatureToExclude(red.game.witcher3.menus.gwint.CardManager.PLAYER_1) == null)) 
            {
                loc1 = true;
            }
            else if (!loc1 && this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].getDeckFaction() == red.game.witcher3.menus.gwint.CardTemplate.FactionId_No_Mans_Land && !(this.cardManager.chooseCreatureToExclude(red.game.witcher3.menus.gwint.CardManager.PLAYER_2) == null)) 
            {
                loc1 = true;
            }
            if (loc1) 
            {
                this.mcMessageQueue.PushMessage("[[gwint_monster_faction_ability_triggered]]", "monster_ability");
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_monster_ability");
            }
            this.cardManager.clearBoard(true);
            return;
        }

        protected function state_update_ClearingBoard():void
        {
            if (!this.mcMessageQueue.ShowingMessage()) 
            {
                this.cardManager.recalculateScores();
                var loc1:*;
                var loc2:*=((loc1 = this).currentRound + 1);
                loc1.currentRound = loc2;
                this.stateMachine.ChangeState("RoundStart");
            }
            return;
        }

        protected function state_leave_ClearingBoard():void
        {
            this.cardManager.recalculateScores();
            return;
        }

        protected function state_update_ShowingFinalResult():void
        {
            return;
        }

        protected function OnEndGameResult(arg1:int):void
        {
            if (arg1 != red.game.witcher3.menus.gwint.GwintEndGameDialog.EndGameDialogResult_Restart) 
            {
                this.closeMenuFunctor(arg1 == red.game.witcher3.menus.gwint.GwintEndGameDialog.EndGameDialogResult_EndVictory);
            }
            else 
            {
                this.stateMachine.ChangeState("Reset");
            }
            return;
        }

        protected function state_begin_reset():void
        {
            this.currentRound = 0;
            this.cardManager.reset();
            this.mcMessageQueue.PushMessage("[[gwint_resetting]]");
            this.stateMachine.ChangeState("SpawnLeaders");
            return;
        }

        protected function shouldDisallowStateChangeFunc():Boolean
        {
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused) 
            {
                return true;
            }
            return this.mcMessageQueue.ShowingMessage() || red.game.witcher3.menus.gwint.CardFXManager.getInstance().isPlayingAnyCardFX() || this.mcChoiceDialog.isShown() || red.game.witcher3.menus.gwint.CardTweenManager.getInstance().isAnyCardMoving();
        }

        public function turnOnAI(arg1:int):void
        {
            var loc1:*=null;
            loc1 = new red.game.witcher3.menus.gwint.AIPlayerController();
            loc1.gameFlowControllerRef = this;
            loc1.playerID = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
            loc1.opponentID = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] = loc1;
            return;
        }

        public function turnOffAI(arg1:int):void
        {
            var loc1:*=null;
            loc1 = new red.game.witcher3.menus.gwint.HumanPlayerController();
            loc1.gameFlowControllerRef = this;
            loc1.playerID = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
            loc1.opponentID = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            (loc1 as red.game.witcher3.menus.gwint.HumanPlayerController).setChoiceDialog(this.mcChoiceDialog);
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] = loc1;
            return;
        }

        public static function getInstance():red.game.witcher3.menus.gwint.GwintGameFlowController
        {
            return _instance;
        }

        public function get skipButton():red.game.witcher3.controls.InputFeedbackButton
        {
            return this._skipButton;
        }

        public function set skipButton(arg1:red.game.witcher3.controls.InputFeedbackButton):void
        {
            this._skipButton = arg1;
            var loc1:*=this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] as red.game.witcher3.menus.gwint.HumanPlayerController;
            if (loc1) 
            {
                loc1.skipButton = this._skipButton;
            }
            return;
        }

        protected function state_update_Initializing():void
        {
            if (red.game.witcher3.menus.gwint.CardManager.getInstance() && red.game.witcher3.menus.gwint.CardManager.getInstance().cardTemplatesReceived && !(red.game.witcher3.menus.gwint.CardFXManager.getInstance() == null)) 
            {
                this.stateMachine.ChangeState("Tutorials");
            }
            return;
        }

        protected function state_leave_Initializing():void
        {
            var loc1:*=null;
            this.cardManager = red.game.witcher3.menus.gwint.CardManager.getInstance();
            if (!this.cardManager) 
            {
                throw new Error("GFX --- Tried to link reference to card manager after initializing, was unable to!");
            }
            if (this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] is red.game.witcher3.menus.gwint.HumanPlayerController) 
            {
                (this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] as red.game.witcher3.menus.gwint.HumanPlayerController).setChoiceDialog(this.mcChoiceDialog);
            }
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].boardRenderer = this.cardManager.boardRenderer;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].boardRenderer = this.cardManager.boardRenderer;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].playerRenderer = this.cardManager.playerRenderers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1];
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].playerRenderer = this.cardManager.playerRenderers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2];
            this.stateMachine.pauseOnStateChangeIfFunc = this.shouldDisallowStateChangeFunc;
            if (this._skipButton != null) 
            {
                loc1 = this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] as red.game.witcher3.menus.gwint.HumanPlayerController;
                if (loc1) 
                {
                    loc1.skipButton = this._skipButton;
                }
            }
            return;
        }

        protected function state_begin_Tutorials():void
        {
            return;
        }

        protected function state_update_Tutorials():void
        {
            if (!this.mcTutorials.visible || this.mcTutorials.isPaused) 
            {
                this.stateMachine.ChangeState("SpawnLeaders");
                red.game.witcher3.managers.InputFeedbackManager.cleanupButtons();
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.navigate, scaleform.clik.constants.NavigationCode.GAMEPAD_L3, -1, "panel_button_common_navigation");
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.quitGame, scaleform.clik.constants.NavigationCode.START, red.core.constants.KeyCode.Q, "gwint_pass_game");
            }
            return;
        }

        protected function state_begin_SpawnLeaders():void
        {
            trace("GFX ##########################################################");
            trace("GFX -#AI#-----------------------------------------------------------------------------------------------------");
            trace("GFX -#AI#----------------------------- NEW GWINT GAME ------------------------------------");
            trace("GFX -#AI#-----------------------------------------------------------------------------------------------------");
            this.cardManager.spawnLeaders();
            this.gameStarted = false;
            this.playedThreeHeroesOneRound = false;
            var loc1:*=this.cardManager.getCardLeader(red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
            var loc2:*=this.cardManager.getCardLeader(red.game.witcher3.menus.gwint.CardManager.PLAYER_2);
            if (this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] is red.game.witcher3.menus.gwint.HumanPlayerController) 
            {
                (this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] as red.game.witcher3.menus.gwint.HumanPlayerController).attachToTutorialCarouselMessage();
            }
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].cardZoomEnabled = false;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].cardZoomEnabled = false;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].inputEnabled = true;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].inputEnabled = true;
            if (!(loc1 == null) && !(loc2 == null) && !(loc1.templateId == loc2.templateId)) 
            {
                if (loc1.templateRef.getFirstEffect() == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Counter_King || loc2.templateRef.getFirstEffect() == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Counter_King) 
                {
                    if (loc1.templateRef.getFirstEffect() != loc2.templateRef.getFirstEffect()) 
                    {
                        if (loc1.templateRef.getFirstEffect() != red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Counter_King) 
                        {
                            this.mcMessageQueue.PushMessage("[[gwint_opponent_counter_leader]]");
                            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
                        }
                        else 
                        {
                            this.mcMessageQueue.PushMessage("[[gwint_player_counter_leader]]");
                            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_using_ability");
                        }
                    }
                    loc1.canBeUsed = false;
                    loc2.canBeUsed = false;
                    if (this.cardManager.boardRenderer) 
                    {
                        this.cardManager.boardRenderer.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER, red.game.witcher3.menus.gwint.CardManager.PLAYER_1).updateLeaderStatus(false);
                        this.cardManager.boardRenderer.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_LEADER, red.game.witcher3.menus.gwint.CardManager.PLAYER_2).updateLeaderStatus(false);
                    }
                }
            }
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].currentRoundStatus = red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].currentRoundStatus = red.game.witcher3.menus.gwint.BasePlayerController.ROUND_PLAYER_STATUS_ACTIVE;
            return;
        }

        protected function state_update_SpawnLeaders():void
        {
            this.stateMachine.ChangeState("CoinToss");
            return;
        }

        protected function state_begin_CoinToss():void
        {
            var loc1:*=this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].getDeckFaction();
            var loc2:*=this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].getDeckFaction();
            trace("GFX - Coing flip logic, player1faction:", loc1, ", player2Faction:", loc2);
            if (!(loc1 == loc2) && !this.mcTutorials.visible && (loc1 == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Scoiatael || loc2 == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Scoiatael)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_scoia_tael_ability");
                if (loc1 != red.game.witcher3.menus.gwint.CardTemplate.FactionId_Scoiatael) 
                {
                    this.currentPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
                    this.mcMessageQueue.PushMessage("[[gwint_opponent_scoiatael_start_special]]", "sco_ability");
                }
                else 
                {
                    this.currentPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
                    dispatchEvent(new flash.events.Event(COIN_TOSS_POPUP_NEEDED, false, false));
                }
            }
            else 
            {
                if (this.mcTutorials.visible) 
                {
                    this.currentPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
                }
                else 
                {
                    this.currentPlayer = Math.floor(Math.random() * 2);
                }
                if (this.currentPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
                {
                    if (this.currentPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
                    {
                        this.mcMessageQueue.PushMessage("[[gwint_opponent_will_go_first]]", "coin_flip_loss");
                    }
                }
                else 
                {
                    this.mcMessageQueue.PushMessage("[[gwint_player_will_go_first_message]]", "coin_flip_win");
                }
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_coin_toss");
            }
            return;
        }

        protected function state_update_CoinToss():void
        {
            if (this.currentPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
            {
                this.stateMachine.ChangeState("Mulligan");
            }
            return;
        }

        protected function state_begin_ShowingFinalResult():void
        {
            var loc5:*=0;
            var loc6:*=0;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            var loc2:*=this.cardManager.roundResults[0].winningPlayer;
            var loc3:*=this.cardManager.roundResults[1].winningPlayer;
            if (this.currentRound == 1 && !(loc2 == loc3) && !this.cardManager.roundResults[2].played) 
            {
                loc5 = this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].getDeckFaction();
                loc6 = this.cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].getDeckFaction();
                if (loc5 != loc6) 
                {
                    if (loc5 != red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard) 
                    {
                        if (loc6 == red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard) 
                        {
                            this.cardManager.roundResults[2].setResults(0, 0, red.game.witcher3.menus.gwint.CardManager.PLAYER_2);
                        }
                    }
                    else 
                    {
                        this.cardManager.roundResults[2].setResults(0, 0, red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
                    }
                }
            }
            if (this.mcTutorials.visible && !this.sawEndGameTutorial) 
            {
                this.sawEndGameTutorial = true;
                this.mcTutorials.continueTutorial();
            }
            var loc4:*=this.cardManager.roundResults[2].winningPlayer;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].cardZoomEnabled = false;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].cardZoomEnabled = false;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].inputEnabled = false;
            this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].inputEnabled = false;
            this.mcChoiceDialog.hideDialog();
            if (this.currentRound == 1 && (loc2 == loc3 || loc2 == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID || loc3 == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID)) 
            {
                if (loc2 != red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                {
                    loc1 = loc2;
                }
                else 
                {
                    loc1 = loc3;
                }
            }
            else if (this.currentRound != 2) 
            {
                throw new Error("GFX - Danger will robinson, danger!");
            }
            else if (loc2 == loc3 || loc2 == loc4) 
            {
                loc1 = loc2;
            }
            else if (loc3 == loc4) 
            {
                loc1 = loc3;
            }
            this.cardManager.traceRoundResults();
            trace("GFX -#AI#--- game winner was: " + loc1);
            trace("GFX -#AI#--- current round was: " + this.currentRound);
            trace("GFX -#AI#--- Round 1 winner: " + loc2);
            trace("GFX -#AI#--- Round 2 winner: " + loc2);
            trace("GFX -#AI#--- Round 3 winner: " + loc2);
            if (loc1 != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
            {
                if (loc1 != red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_battle_draw");
                }
                else 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_battle_lost");
                }
            }
            else 
            {
                if (this.playedThreeHeroesOneRound) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.sendHeroRoundVictoryAchievement();
                }
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_battle_won");
            }
            this.mcEndGameDialog.show(loc1, this.OnEndGameResult);
            return;
        }

        protected function state_begin_Mulligan():void
        {
            var loc1:*=null;
            this._mulliganDecided = false;
            this._mulliganCardsCount = 0;
            this.cardManager.shuffleAndDrawCards();
            loc1 = this.cardManager.getCardInstanceList(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
            this.mcChoiceDialog.showDialogCardInstances(loc1, this.handleAcceptMulligan, this.handleDeclineMulligan, "[[gwint_can_choose_card_to_redraw]]");
            this.mcChoiceDialog.appendDialogText(" 0/2");
            if (this.mcTutorials.visible) 
            {
                this.mcTutorials.continueTutorial();
                this.mcChoiceDialog.inputEnabled = false;
                this.mcTutorials.hideCarouselCB = this.handleDeclineMulligan;
                this.mcTutorials.changeChoiceCB = this.handleForceCardSelected;
            }
            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_draw_2");
            return;
        }

        protected function state_update_Mulligan():void
        {
            if (this._mulliganDecided && (!this.mcTutorials.visible || this.mcTutorials.isPaused)) 
            {
                this.stateMachine.ChangeState("RoundStart");
                this.mcChoiceDialog.hideDialog();
                this.gameStarted = true;
                this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].cardZoomEnabled = true;
                this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].cardZoomEnabled = true;
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_game_start");
            }
            return;
        }

        protected function handleAcceptMulligan(arg1:int):void
        {
            var loc2:*=null;
            var loc1:*=this.cardManager.getCardInstance(arg1);
            if (loc1) 
            {
                loc2 = this.cardManager.mulliganCard(loc1);
                this.mcChoiceDialog.replaceCard(loc1, loc2);
                var loc3:*;
                var loc4:*=((loc3 = this)._mulliganCardsCount + 1);
                loc3._mulliganCardsCount = loc4;
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_card_redrawn");
                if (this._mulliganCardsCount < 2) 
                {
                    this.mcChoiceDialog.updateDialogText("[[gwint_can_choose_card_to_redraw]]");
                    this.mcChoiceDialog.appendDialogText(" 1/2");
                }
                this._mulliganDecided = this._mulliganCardsCount >= 2;
            }
            return;
        }

        protected function handleDeclineMulligan():void
        {
            this.mcChoiceDialog.hideDialog();
            this._mulliganDecided = true;
            if (this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] is red.game.witcher3.menus.gwint.HumanPlayerController) 
            {
                (this.playerControllers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] as red.game.witcher3.menus.gwint.HumanPlayerController).attachToTutorialCarouselMessage();
            }
            return;
        }

        protected function handleForceCardSelected(arg1:int):void
        {
            if (this.mcChoiceDialog && this.mcChoiceDialog.visible) 
            {
                this.mcChoiceDialog.cardsCarousel.selectedIndex = arg1;
            }
            return;
        }

        public static const COIN_TOSS_POPUP_NEEDED:String="Gameflow.event.Cointoss.needed";

        public var currentPlayer:int=-1;

        public var closeMenuFunctor:Function;

        public var mcMessageQueue:red.game.witcher3.controls.W3MessageQueue;

        public var mcTutorials:red.game.witcher3.menus.gwint.GwintTutorial;

        public var mcChoiceDialog:red.game.witcher3.controls.W3ChoiceDialog;

        public var mcEndGameDialog:red.game.witcher3.menus.gwint.GwintEndGameDialog;

        private var currentRound:int;

        protected var allNeutralInRound:Boolean=true;

        protected var playedCreaturesInRound:Boolean=false;

        protected var lastRoundWinner:int=-1;

        protected var playedThreeHeroesOneRound:Boolean=false;

        public var playerControllers:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.BasePlayerController>;

        public var gameStarted:Boolean=false;

        protected var sawRoundEndTutorial:Boolean=false;

        public var stateMachine:red.game.witcher3.utils.FiniteStateMachine;

        protected var _skipButton:red.game.witcher3.controls.InputFeedbackButton;

        protected var sawScoreChangeTutorial:Boolean=false;

        private var cardManager:red.game.witcher3.menus.gwint.CardManager;

        protected var sawRoundStartTutorial:Boolean=false;

        protected var _mulliganCardsCount:int=0;

        protected var sawEndGameTutorial:Boolean=false;

        private var sawStartMessage:Boolean;

        protected static var _instance:red.game.witcher3.menus.gwint.GwintGameFlowController;

        protected var _mulliganDecided:Boolean;
    }
}
