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
    
    public class GwintGameMenu extends red.game.witcher3.menus.gwint.GwintBaseMenu
    {
        public function GwintGameMenu()
        {
            super();
            red.game.witcher3.managers.InputFeedbackManager.useOverlayPopup = true;
            red.game.witcher3.managers.InputFeedbackManager.eventDispatcher = this;
            this.gameFlowController = new red.game.witcher3.menus.gwint.GwintGameFlowController();
            red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton = this;
            _enableMouse = false;
            addEventListener(flash.events.Event.ADDED_TO_STAGE, this.__setPerspectiveProjection_);
            this.__setProp_mcBoardRenderer_Scene1_mcBoadRenderer_0();
            this.__setProp_mcPlayer2Renderer_Scene1_mcPlayer2Renderer_0();
            this.__setProp_mcPlayer1Renderer_Scene1_mcPlayer1Renderer_0();
            this.__setProp_mcCardFXManager_Scene1_mcCardFXManager_0();
            return;
        }

        public function __setPerspectiveProjection_(arg1:flash.events.Event):void
        {
            root.transform.perspectiveProjection.fieldOfView = 122.353662;
            root.transform.perspectiveProjection.projectionCenter = new flash.geom.Point(275, 200);
            return;
        }

        public function tryQuitGame():void
        {
            if (!this.mcTutorials.visible || this.mcTutorials.isPaused) 
            {
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnConfirmSurrender"));
            }
            return;
        }

        protected override function get menuName():String
        {
            return "GwintGame";
        }

        protected function onGameFlowDone(arg1:Boolean):void
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnMatchResult", [arg1]));
            closeMenu();
            return;
        }

        protected function handleClosePressed(arg1:scaleform.clik.events.ButtonEvent):void
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
        }

        public function setPlayerDeck(arg1:Object):void
        {
            var loc1:*=arg1 as red.game.witcher3.menus.gwint.GwintDeck;
            if (loc1) 
            {
                _cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] = loc1;
                loc1.DeckRenderer = this.mcP1DeckRenderer;
            }
            else 
            {
                throw new Error("GFX - Invalid type for deckDefinition passed from witcher script (player 1)");
            }
            return;
        }

        public function setEnemyDeck(arg1:Object):void
        {
            var loc1:*=arg1 as red.game.witcher3.menus.gwint.GwintDeck;
            if (loc1) 
            {
                _cardManager.playerDeckDefinitions[red.game.witcher3.menus.gwint.CardManager.PLAYER_2] = loc1;
                loc1.DeckRenderer = this.mcP2DeckRenderer;
            }
            else 
            {
                throw new Error("GFX - Invalid type for deckDefinition passed from witcher script (player 2)");
            }
            return;
        }

        public function setCardValues(arg1:Object):void
        {
            trace("GFX ----------------- cardValues received:", arg1);
            _cardManager.cardValues = arg1 as red.game.witcher3.menus.gwint.GwintCardValues;
            return;
        }

        public function setAIEnabled(arg1:Boolean):void
        {
            if (arg1) 
            {
                this.gameFlowController.turnOnAI(red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
            }
            else 
            {
                this.gameFlowController.turnOffAI(red.game.witcher3.menus.gwint.CardManager.PLAYER_2);
            }
            return;
        }

        public function chooseCoingPopup(arg1:flash.events.Event):void
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnChooseCoinFlip"));
            return;
        }

        public function setFirstTurn(arg1:Boolean):void
        {
            if (arg1) 
            {
                this.mcMessageQueue.PushMessage("[[gwint_player_will_go_first_message]]");
                this.gameFlowController.currentPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
            }
            else 
            {
                this.mcMessageQueue.PushMessage("[[gwint_opponent_will_go_first]]");
                this.gameFlowController.currentPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            }
            return;
        }

        protected function testCardsCalculations():void
        {
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=0;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            trace("GFX --------------------------------------------------------- Commencing card test ---------------------------------------------------------");
            trace("GFX ================================================== Creating temporary card instances ===================================================");
            var loc5:*=0;
            var loc6:*=_cardManager._cardTemplates;
            for each (loc3 in loc6) 
            {
                loc2 = new red.game.witcher3.menus.gwint.CardInstance();
                loc2.templateId = loc3.index;
                loc2.templateRef = loc3;
                loc2.owningPlayer = red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
                loc2.instanceId = 100;
                loc1.push(loc2);
            }
            trace("GFX - Successfully created: " + loc1.length + " card instances");
            loc4 = 0;
            while (loc4 < loc1.length) 
            {
                trace("GFX - Checking Card with ID: " + loc1[loc4].templateId + " --------------------------");
                trace("GFX ---------------------------------------------------------");
                trace("GFX - template Ref: " + loc1[loc4].templateRef);
                trace("GFX - instance info: " + loc1[loc4]);
                trace("GFX - recalulating optimal transaction for card");
                loc1[loc4].recalculatePowerPotential(_cardManager);
                trace("GFX - successfully recalculated following power info: ");
                trace("GFX - " + loc1[loc4].getOptimalTransaction());
                ++loc4;
            }
            trace("GFX ================================ Successfully Finished Test of Card Instances ====================================");
            trace("GFX ------------------------------------------------------------------------------------------------------------------");
            return;
        }

        function __setProp_mcPlayer2Renderer_Scene1_mcPlayer2Renderer_0():*
        {
            try 
            {
                this.mcPlayer2Renderer["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
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
            };
            return;
        }

        function __setProp_mcPlayer1Renderer_Scene1_mcPlayer1Renderer_0():*
        {
            try 
            {
                this.mcPlayer1Renderer["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
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
            };
            return;
        }

        function __setProp_mcCardFXManager_Scene1_mcCardFXManager_0():*
        {
            try 
            {
                this.mcCardFXManager["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
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
            };
            return;
        }

        public function playSound(arg1:String):*
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnPlaySoundEvent", [arg1]));
            return;
        }

        public function sendNeutralRoundVictoryAchievement():void
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnNeutralRoundVictoryAchievement"));
            return;
        }

        public function sendHeroRoundVictoryAchievement():void
        {
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnHeroRoundVictoryAchievement"));
            return;
        }

        public function showTutorial():void
        {
            if (this.mcTutorials) 
            {
                this.tutorialsOn = true;
                this.mcTutorials.show();
            }
            return;
        }

        protected override function configUI():void
        {
            this.mcTutorials.currentTutorialFrame = 7;
            this.mcTutorials.messageQueue = this.mcMessageQueue;
            super.configUI();
            _cardManager.playerRenderers.push(this.mcPlayer1Renderer);
            _cardManager.playerRenderers.push(this.mcPlayer2Renderer);
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "gwint.game.player.deck", [this.setPlayerDeck]));
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "gwint.game.enemy.deck", [this.setEnemyDeck]));
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "gwint.game.cardValues", [this.setCardValues]));
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "gwint.game.toggleAI", [this.setAIEnabled]));
            if (this.mcCloseBtn) 
            {
                this.mcCloseBtn.addEventListener(scaleform.clik.events.ButtonEvent.PRESS, this.handleClosePressed, false, 0, true);
                this.mcCloseBtn.label = "[[gwint_pass_game]]";
            }
            this.gameFlowController.mcMessageQueue = this.mcMessageQueue;
            this.gameFlowController.mcTutorials = this.mcTutorials;
            this.gameFlowController.mcChoiceDialog = this.mcChoiceDialog;
            this.gameFlowController.mcEndGameDialog = this.mcEndGameDialog;
            this.gameFlowController.closeMenuFunctor = this.onGameFlowDone;
            this.gameFlowController.addEventListener(red.game.witcher3.menus.gwint.GwintGameFlowController.COIN_TOSS_POPUP_NEEDED, this.chooseCoingPopup, false, 0, true);
            scaleform.clik.managers.InputDelegate.getInstance().addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInput, false, 0, true);
            stage.addEventListener(flash.events.MouseEvent.CLICK, this.handleMouseClick, false, 2, true);
            this.btnSkipTurn.label = "[[qwint_skip_turn]]";
            this.btnSkipTurn.setDataFromStage(scaleform.clik.constants.NavigationCode.GAMEPAD_Y, red.core.constants.KeyCode.SPACE);
            this.btnSkipTurn.holdDuration = SKIP_TURN_HOLD_DELAY;
            this.btnSkipTurn.visible = false;
            this.gameFlowController.skipButton = this.btnSkipTurn;
            this.mcChoiceDialog.visible = false;
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnConfigUI"));
            return;
        }

        function __setProp_mcBoardRenderer_Scene1_mcBoadRenderer_0():*
        {
            try 
            {
                this.mcBoardRenderer["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
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
            };
            return;
        }

        public override function handleInput(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=undefined;
            var loc2:*=null;
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused) 
            {
                this.mcTutorials.handleInput(arg1);
                return;
            }
            if (this.gameFlowController.gameStarted) 
            {
                loc1 = 0;
                while (loc1 < this.gameFlowController.playerControllers.length) 
                {
                    loc2 = this.gameFlowController.playerControllers[loc1];
                    if (loc2) 
                    {
                        loc2.handleUserInput(arg1);
                    }
                    ++loc1;
                }
            }
            return;
        }

        protected override function handleMouseMove(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=undefined;
            var loc2:*=null;
            super.handleMouseMove(arg1);
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused) 
            {
                return;
            }
            if (this.gameFlowController.gameStarted) 
            {
                loc1 = 0;
                while (loc1 < this.gameFlowController.playerControllers.length) 
                {
                    loc2 = this.gameFlowController.playerControllers[loc1];
                    if (loc2) 
                    {
                        loc2.handleMouseMove(arg1);
                    }
                    ++loc1;
                }
            }
            return;
        }

        public function handleMouseClick(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=undefined;
            var loc2:*=null;
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
                loc1 = 0;
                while (loc1 < this.gameFlowController.playerControllers.length) 
                {
                    loc2 = this.gameFlowController.playerControllers[loc1];
                    if (loc2) 
                    {
                        loc2.handleMouseClick(arg1);
                    }
                    ++loc1;
                }
            }
            return;
        }

        protected override function handleInputNavigate(arg1:scaleform.clik.events.InputEvent):void
        {
            if (this.mcTutorials && this.mcTutorials.visible && !this.mcTutorials.isPaused) 
            {
                return;
            }
            var loc1:*=arg1.details;
            var loc2:*=loc1.value == scaleform.clik.constants.InputValue.KEY_UP;
            if (!arg1.handled && loc2) 
            {
                var loc3:*=loc1.navEquivalent;
                switch (loc3) 
                {
                    case scaleform.clik.constants.NavigationCode.START:
                    {
                        this.tryQuitGame();
                        break;
                    }
                    case scaleform.clik.constants.NavigationCode.DPAD_UP:
                    {
                        this.testCardsCalculations();
                        break;
                    }
                    case scaleform.clik.constants.NavigationCode.GAMEPAD_A:
                    case scaleform.clik.constants.NavigationCode.ENTER:
                    {
                        if (this.mcMessageQueue && this.mcMessageQueue.trySkipMessage()) 
                        {
                            arg1.handled = true;
                        }
                        break;
                    }
                }
                loc3 = loc1.code;
                switch (loc3) 
                {
                    case red.core.constants.KeyCode.Q:
                    {
                        this.tryQuitGame();
                        break;
                    }
                }
            }
            return;
        }

        private static const SKIP_TURN_HOLD_DELAY:Number=1000;

        public var gameFlowController:red.game.witcher3.menus.gwint.GwintGameFlowController;

        public var mcMessageQueue:red.game.witcher3.controls.W3MessageQueue;

        public var mcChoiceDialog:red.game.witcher3.controls.W3ChoiceDialog;

        public var mcEndGameDialog:red.game.witcher3.menus.gwint.GwintEndGameDialog;

        public var btnSkipTurn:red.game.witcher3.controls.InputFeedbackButton;

        public var mcCloseBtn:red.game.witcher3.controls.ConditionalCloseButton;

        public var mcTutorials:red.game.witcher3.menus.gwint.GwintTutorial;

        public var tutorialsOn:Boolean=false;

        public var mcPlayer1Renderer:red.game.witcher3.menus.gwint.GwintPlayerRenderer;

        public var mcPlayer2Renderer:red.game.witcher3.menus.gwint.GwintPlayerRenderer;

        public var mcP1DeckRenderer:red.game.witcher3.menus.gwint.GwintDeckRenderer;

        public var mcP2DeckRenderer:red.game.witcher3.menus.gwint.GwintDeckRenderer;

        public var mcBoardRenderer:red.game.witcher3.menus.gwint.GwintBoardRenderer;

        public var mcCardFXManager:red.game.witcher3.menus.gwint.CardFXManager;

        public static var mSingleton:red.game.witcher3.menus.gwint.GwintGameMenu;
    }
}
