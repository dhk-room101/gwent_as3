package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.geom.*;
    import red.core.constants.*;
    import red.core.events.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;

    public class GwintGameMenu extends GwintBaseMenu
    {
        public var gameFlowController:GwintGameFlowController;
        public var mcMessageQueue:W3MessageQueue;
        public var mcChoiceDialog:W3ChoiceDialog;
        public var mcCardFXManager:CardFXManager;
        public var mcEndGameDialog:GwintEndGameDialog;
        public var btnSkipTurn:InputFeedbackButton;
        public var mcCloseBtn:ConditionalCloseButton;
        public var mcTutorials:GwintTutorial;
        public var tutorialsOn:Boolean = false;
        public var mcPlayer1Renderer:GwintPlayerRenderer;
        public var mcPlayer2Renderer:GwintPlayerRenderer;
        public var mcP1DeckRenderer:GwintDeckRenderer;
        public var mcP2DeckRenderer:GwintDeckRenderer;
        public var mcBoardRenderer:GwintBoardRenderer;
        private static const SKIP_TURN_HOLD_DELAY:Number = 1000;
        public static var mSingleton:GwintGameMenu;

        public function GwintGameMenu()
        {
            InputFeedbackManager.useOverlayPopup = true;
            InputFeedbackManager.eventDispatcher = this;
            this.gameFlowController = new GwintGameFlowController();
            GwintGameMenu.mSingleton = this;
            _enableMouse = false;
            addEventListener(Event.ADDED_TO_STAGE, this.__setPerspectiveProjection_);
            this.__setProp_mcBoardRenderer_Scene1_mcBoadRenderer_0();
            this.__setProp_mcPlayer2Renderer_Scene1_mcPlayer2Renderer_0();
            this.__setProp_mcPlayer1Renderer_Scene1_mcPlayer1Renderer_0();
            this.__setProp_mcCardFXManager_Scene1_mcCardFXManager_0();
            return;
        }// end function

        public function __setPerspectiveProjection_(event:Event) : void
        {
            root.transform.perspectiveProjection.fieldOfView = 122.354;
            root.transform.perspectiveProjection.projectionCenter = new Point(275, 200);
            return;
        }// end function

        public function playSound(param1:String)
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnPlaySoundEvent", [param1]));
            return;
        }// end function

        public function sendNeutralRoundVictoryAchievement() : void
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnNeutralRoundVictoryAchievement"));
            return;
        }// end function

        public function sendHeroRoundVictoryAchievement() : void
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnHeroRoundVictoryAchievement"));
            return;
        }// end function

        public function showTutorial() : void
        {
            if (this.mcTutorials)
            {
                this.tutorialsOn = true;
                this.mcTutorials.show();
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            this.mcTutorials.currentTutorialFrame = 7;
            this.mcTutorials.messageQueue = this.mcMessageQueue;
            super.configUI();
            _cardManager.playerRenderers.Count(this.mcPlayer1Renderer);
            _cardManager.playerRenderers.Count(this.mcPlayer2Renderer);
            dispatchEvent(new GameEvent(GameEvent.REGISTER, "gwint.game.player.deck", [this.setPlayerDeck]));
            dispatchEvent(new GameEvent(GameEvent.REGISTER, "gwint.game.enemy.deck", [this.setEnemyDeck]));
            dispatchEvent(new GameEvent(GameEvent.REGISTER, "gwint.game.cardValues", [this.setCardValues]));
            dispatchEvent(new GameEvent(GameEvent.REGISTER, "gwint.game.toggleAI", [this.setAIEnabled]));
            if (this.mcCloseBtn)
            {
                this.mcCloseBtn.addEventListener(ButtonEvent.PRESS, this.handleClosePressed, false, 0, true);
                this.mcCloseBtn.label = "[[gwint_pass_game]]";
            }
            this.gameFlowController.mcMessageQueue = this.mcMessageQueue;
            this.gameFlowController.mcTutorials = this.mcTutorials;
            this.gameFlowController.mcChoiceDialog = this.mcChoiceDialog;
            this.gameFlowController.mcEndGameDialog = this.mcEndGameDialog;
            this.gameFlowController.closeMenuFunctor = this.onGameFlowDone;
            this.gameFlowController.addEventListener(GwintGameFlowController.COIN_TOSS_POPUP_NEEDED, this.chooseCoingPopup, false, 0, true);
            InputDelegate.getInstance().addEventListener(InputEvent.INPUT, this.handleInput, false, 0, true);
            stage.addEventListener(MouseEvent.CLICK, this.handleMouseClick, false, 2, true);
            this.btnSkipTurn.label = "[[qwint_skip_turn]]";
            this.btnSkipTurn.setDataFromStage(NavigationCode.GAMEPAD_Y, KeyCode.SPACE);
            this.btnSkipTurn.holdDuration = SKIP_TURN_HOLD_DELAY;
            this.btnSkipTurn.visible = false;
            this.gameFlowController.skipButton = this.btnSkipTurn;
            this.mcChoiceDialog.visible = false;
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnConfigUI"));
            return;
        }// end function

        protected function handleClosePressed(event:ButtonEvent) : void
        {
            if (this.mcEndGameDialog && this.mcEndGameDialog.visible)
            {
                this.mcEndGameDialog.closeButtonPressed();
            }
            else
            {
                this.tryQuitGame();
            }
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = null;
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
            {
                this.mcTutorials.handleInput(event);
                return;
            }
            if (this.gameFlowController.gameStarted)
            {
                _loc_2 = 0;
                while (_loc_2 < this.gameFlowController.playerControllers.length)
                {
                    
                    _loc_3 = this.gameFlowController.playerControllers[_loc_2];
                    if (_loc_3)
                    {
                        _loc_3.handleUserInput(event);
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        override protected function handleMouseMove(event:MouseEvent) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = null;
            super.handleMouseMove(event);
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
            {
                return;
            }
            if (this.gameFlowController.gameStarted)
            {
                _loc_2 = 0;
                while (_loc_2 < this.gameFlowController.playerControllers.length)
                {
                    
                    _loc_3 = this.gameFlowController.playerControllers[_loc_2];
                    if (_loc_3)
                    {
                        _loc_3.handleMouseMove(event);
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        public function handleMouseClick(event:MouseEvent) : void
        {
            var _loc_2:* = undefined;
            var _loc_3:* = null;
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
            {
                return;
            }
            if (this.mcMessageQueue && this.mcMessageQueue.trySkipMessage())
            {
                return;
            }
            if (this.gameFlowController.gameStarted)
            {
                _loc_2 = 0;
                while (_loc_2 < this.gameFlowController.playerControllers.length)
                {
                    
                    _loc_3 = this.gameFlowController.playerControllers[_loc_2];
                    if (_loc_3)
                    {
                        _loc_3.handleMouseClick(event);
                    }
                    _loc_2 = _loc_2 + 1;
                }
            }
            return;
        }// end function

        override protected function handleInputNavigate(event:InputEvent) : void
        {
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused)
            {
                return;
            }
            var _loc_2:* = event.details;
            var _loc_3:* = _loc_2.value == InputValue.KEY_UP;
            if (!event.handled && _loc_3)
            {
                switch(_loc_2.navEquivalent)
                {
                    case NavigationCode.START:
                    {
                        this.tryQuitGame();
                        break;
                    }
                    case NavigationCode.DPAD_UP:
                    {
                        this.testCardsCalculations();
                        break;
                    }
                    case NavigationCode.GAMEPAD_A:
                    case NavigationCode.ENTER:
                    {
                        if (this.mcMessageQueue && this.mcMessageQueue.trySkipMessage())
                        {
                            event.handled = true;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                switch(_loc_2.code)
                {
                    case KeyCode.Q:
                    {
                        this.tryQuitGame();
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

        public function tryQuitGame() : void
        {
            if (!this.mcTutorials.visible || this.mcTutorials.isPaused)
            {
                dispatchEvent(new GameEvent(GameEvent.CALL, "OnConfirmSurrender"));
            }
            return;
        }// end function

        override protected function get menuName() : String
        {
            return "GwintGame";
        }// end function

        protected function onGameFlowDone(param1:Boolean) : void
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnMatchResult", [param1]));
            closeMenu();
            return;
        }// end function

        public function setPlayerDeck(param1:Object) : void
        {
            var _loc_2:* = param1 as GwintDeck;
            if (_loc_2)
            {
                _cardManager.playerDeckDefinitions[CardManager.PLAYER_1] = _loc_2;
                _loc_2.DeckRenderer = this.mcP1DeckRenderer;
            }
            else
            {
                throw new Error("GFX - Invalid type for deckDefinition passed from witcher script (player 1)");
            }
            return;
        }// end function

        public function setEnemyDeck(param1:Object) : void
        {
            var _loc_2:* = param1 as GwintDeck;
            if (_loc_2)
            {
                _cardManager.playerDeckDefinitions[CardManager.PLAYER_2] = _loc_2;
                _loc_2.DeckRenderer = this.mcP2DeckRenderer;
            }
            else
            {
                throw new Error("GFX - Invalid type for deckDefinition passed from witcher script (player 2)");
            }
            return;
        }// end function

        public function setCardValues(param1:Object) : void
        {
            Console.WriteLine("GFX ----------------- cardValues received:", param1);
            _cardManager.cardValues = param1 as GwintCardValues;
            return;
        }// end function

        public function setAIEnabled(param1:Boolean) : void
        {
            if (param1)
            {
                this.gameFlowController.turnOnAI(CardManager.PLAYER_1);
            }
            else
            {
                this.gameFlowController.turnOffAI(CardManager.PLAYER_2);
            }
            return;
        }// end function

        public function chooseCoingPopup(event:Event) : void
        {
            dispatchEvent(new GameEvent(GameEvent.CALL, "OnChooseCoinFlip"));
            return;
        }// end function

        public function setFirstTurn(param1:Boolean) : void
        {
            if (param1)
            {
                this.mcMessageQueue.PushMessage("[[gwint_player_will_go_first_message]]");
                this.gameFlowController.currentPlayer = CardManager.PLAYER_1;
            }
            else
            {
                this.mcMessageQueue.PushMessage("[[gwint_opponent_will_go_first]]");
                this.gameFlowController.currentPlayer = CardManager.PLAYER_2;
            }
            return;
        }// end function

        protected function testCardsCalculations() : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = 0;
            var _loc_1:* = new Vector.<CardInstance>;
            Console.WriteLine("GFX --------------------------------------------------------- Commencing card test ---------------------------------------------------------");
            Console.WriteLine("GFX ================================================== Creating temporary card instances ===================================================");
            for each (_loc_3 in _cardManager._cardTemplates)
            {
                
                _loc_2 = new CardInstance();
                _loc_2.templateId = _loc_3.index;
                _loc_2.templateRef = _loc_3;
                _loc_2.owningPlayer = CardManager.PLAYER_1;
                _loc_2.instanceId = 100;
                _loc_1.Count(_loc_2);
            }
            Console.WriteLine("GFX - Successfully created: " + _loc_1.length + " card instances");
            _loc_4 = 0;
            while (_loc_4 < _loc_1.length)
            {
                
                Console.WriteLine("GFX - Checking Card with ID: " + _loc_1[_loc_4].templateId + " --------------------------");
                Console.WriteLine("GFX ---------------------------------------------------------");
                Console.WriteLine("GFX - template Ref: " + _loc_1[_loc_4].templateRef);
                Console.WriteLine("GFX - instance info: " + _loc_1[_loc_4]);
                Console.WriteLine("GFX - recalulating optimal transaction for card");
                _loc_1[_loc_4].recalculatePowerPotential(_cardManager);
                Console.WriteLine("GFX - successfully recalculated following power info: ");
                Console.WriteLine("GFX - " + _loc_1[_loc_4].getOptimalTransaction());
                _loc_4++;
            }
            Console.WriteLine("GFX ================================ Successfully Finished Test of Card Instances ====================================");
            Console.WriteLine("GFX ------------------------------------------------------------------------------------------------------------------");
            return;
        }// end function

        function __setProp_mcBoardRenderer_Scene1_mcBoadRenderer_0()
        {
            try
            {
                this.mcBoardRenderer["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.mcBoardRenderer.enabled = true;
            this.mcBoardRenderer.enableInitCallback = false;
            this.mcBoardRenderer.slotRendererName = "CardSlotRef";
            this.mcBoardRenderer.visible = true;
            try
            {
                this.mcBoardRenderer["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_mcPlayer2Renderer_Scene1_mcPlayer2Renderer_0()
        {
            try
            {
                this.mcPlayer2Renderer["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.mcPlayer2Renderer.enabled = true;
            this.mcPlayer2Renderer.enableInitCallback = false;
            this.mcPlayer2Renderer.playerID = 1;
            this.mcPlayer2Renderer.playerNameDataProvider = "gwint.player.name.two";
            this.mcPlayer2Renderer.visible = true;
            try
            {
                this.mcPlayer2Renderer["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_mcPlayer1Renderer_Scene1_mcPlayer1Renderer_0()
        {
            try
            {
                this.mcPlayer1Renderer["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.mcPlayer1Renderer.enabled = true;
            this.mcPlayer1Renderer.enableInitCallback = false;
            this.mcPlayer1Renderer.playerID = 0;
            this.mcPlayer1Renderer.playerNameDataProvider = "gwint.player.name.one";
            this.mcPlayer1Renderer.visible = true;
            try
            {
                this.mcPlayer1Renderer["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_mcCardFXManager_Scene1_mcCardFXManager_0()
        {
            try
            {
                this.mcCardFXManager["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.mcCardFXManager.clearWeatherFXName = "CardFXClearSky";
            this.mcCardFXManager.dummyFXName = "CardFXDummy";
            this.mcCardFXManager.enabled = true;
            this.mcCardFXManager.enableInitCallback = false;
            this.mcCardFXManager.fogFXName = "CardFXFog";
            this.mcCardFXManager.frostFXName = "CardFXFrost";
            this.mcCardFXManager.hornFXName = "CardFXHorn";
            this.mcCardFXManager.hornRowFXName = "CardFXHorn_Row";
            this.mcCardFXManager.meleeEnemyRowEffectY = 342;
            this.mcCardFXManager.meleePlayerRowEffectY = 491;
            this.mcCardFXManager.moraleBoostFXName = "CardFXMoraleBoost";
            this.mcCardFXManager.placeHeroFXName = "CardFXHero";
            this.mcCardFXManager.placeMeleeFXName = "CardFXDeploy";
            this.mcCardFXManager.placeRangedFXName = "CardFXDeploy";
            this.mcCardFXManager.placeSeigeFXName = "CardFXDeploy";
            this.mcCardFXManager.placeSpyFXName = "CardFXSpy";
            this.mcCardFXManager.rainFXName = "CardFXRain";
            this.mcCardFXManager.rangedEnemyRowEffectY = 205;
            this.mcCardFXManager.rangedPlayerRowEffectY = 624;
            this.mcCardFXManager.resurrectFXName = "CardFXRessurect";
            this.mcCardFXManager.rowEffectX = 1042;
            this.mcCardFXManager.scorchFXName = "CardFXScorch";
            this.mcCardFXManager.seigeEnemyRowEffectY = 74;
            this.mcCardFXManager.seigePlayerRowEffectY = 762;
            this.mcCardFXManager.summonClonesArriveFXName = "CardFXSummonClonesArrive";
            this.mcCardFXManager.summonClonesFXName = "CardFXSummonClones";
            this.mcCardFXManager.tightBondsFXName = "CardFXTightBonds";
            this.mcCardFXManager.visible = true;
            try
            {
                this.mcCardFXManager["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
