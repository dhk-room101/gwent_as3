package red.game.witcher3.menus.gwint
{
    import flash.display.*;
    import red.core.events.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.controls.*;
    import scaleform.clik.core.*;

    public class GwintPlayerRenderer extends UIComponent
    {
        public var txtPassed:W3TextArea;
        public var mcPassed:MovieClip;
        public var txtPlayerName:W3TextArea;
        public var txtFactionName:W3TextArea;
        public var txtCardCount:W3TextArea;
        public var mcPlayerPortrait:MovieClip;
        public var mcScore:MovieClip;
        public var mcLifeIndicator:MovieClip;
        public var mcFactionIcon:MovieClip;
        public var mcWinningRound:MovieClip;
        protected var _playerNameDataProvider:String = "INVALID_STRING_PARAM!";
        protected var _playerID:int;
        private var _score:int = -1;
        private var _turnActive:Boolean = false;
        protected var _lastSetPlayerLives:int = -1;
        protected var passedShown:Boolean = false;

        public function GwintPlayerRenderer()
        {
            this._playerID = CardManager.PLAYER_INVALID;
            return;
        }// end function

        public function set playerName(param1:String) : void
        {
            this.txtPlayerName.text = param1;
            return;
        }// end function

        public function get playerName() : String
        {
            return this.txtPlayerName.text;
        }// end function

        public function get playerNameDataProvider() : String
        {
            return this._playerNameDataProvider;
        }// end function

        public function set playerNameDataProvider(param1:String) : void
        {
            this._playerNameDataProvider = param1;
            return;
        }// end function

        public function get playerID() : int
        {
            return this._playerID;
        }// end function

        public function set playerID(param1:int) : void
        {
            this._playerID = param1;
            if (this.mcPlayerPortrait)
            {
                if (this._playerID == CardManager.PLAYER_1)
                {
                    this.mcPlayerPortrait.gotoAndStop("geralt");
                }
                else
                {
                    this.mcPlayerPortrait.gotoAndStop("npc");
                }
            }
            return;
        }// end function

        public function set score(param1:int) : void
        {
            var _loc_2:* = null;
            if (this._score != param1)
            {
                if (this.mcScore.currentFrameLabel == "Idle")
                {
                    if (this._score < param1)
                    {
                        this.mcScore.gotoAndPlay("Grew");
                    }
                    else
                    {
                        this.mcScore.gotoAndPlay("Shrank");
                    }
                }
                this._score = param1;
                _loc_2 = this.mcScore.getChildByName("txtScore") as W3TextArea;
                if (_loc_2)
                {
                    _loc_2.text = this._score.toString();
                }
            }
            return;
        }// end function

        public function set numCardsInHand(param1:int) : void
        {
            this.txtCardCount.text = param1.toString();
            return;
        }// end function

        public function set turnActive(param1:Boolean) : void
        {
            if (param1 != this._turnActive)
            {
                this._turnActive = param1;
                if (this._turnActive)
                {
                    gotoAndPlay("Selected");
                }
                else
                {
                    gotoAndPlay("Idle");
                }
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            if (this._playerNameDataProvider != CommonConstants.INVALID_STRING_PARAM)
            {
                dispatchEvent(new GameEvent(GameEvent.REGISTER, this._playerNameDataProvider, [this.setPlayerName]));
            }
            if (this.mcPassed)
            {
                this.txtPassed = this.mcPassed.getChildByName("txtPassed") as W3TextArea;
            }
            if (this.mcWinningRound)
            {
                this.mcWinningRound.stop();
                this.mcWinningRound.visible = false;
            }
            this.reset();
            return;
        }// end function

        protected function setPlayerName(param1:String) : void
        {
            this.playerName = param1;
            return;
        }// end function

        public function setPlayerLives(param1:int) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            Console.WriteLine("GFX - Updating life for Player: " + this.playerName + ", to: " + param1 + " and life indicator: " + this.mcLifeIndicator);
            if (this._lastSetPlayerLives != param1)
            {
                this._lastSetPlayerLives = param1;
                _loc_2 = this.mcLifeIndicator.getChildByName("mcLifeGemAnim1") as MovieClip;
                _loc_3 = this.mcLifeIndicator.getChildByName("mcLifeGemAnim2") as MovieClip;
                switch(param1)
                {
                    case 0:
                    {
                        if (_loc_3.currentLabel != "play")
                        {
                            _loc_3.gotoAndPlay("play");
                        }
                        if (_loc_2.currentLabel != "play")
                        {
                            _loc_2.gotoAndPlay("play");
                        }
                        break;
                    }
                    case 1:
                    {
                        if (_loc_3.currentLabel != "visible")
                        {
                            _loc_3.gotoAndStop("visible");
                        }
                        if (_loc_2.currentLabel != "play")
                        {
                            _loc_2.gotoAndPlay("play");
                        }
                        break;
                    }
                    case 2:
                    {
                        if (_loc_3.currentLabel != "visible")
                        {
                            _loc_3.gotoAndStop("visible");
                        }
                        if (_loc_2.currentLabel != "visible")
                        {
                            _loc_2.gotoAndStop("visible");
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

        public function showPassed(param1:Boolean) : void
        {
            if (this.txtPassed)
            {
                this.txtPassed.visible = param1;
            }
            if (this.mcPassed)
            {
                if (param1)
                {
                    if (!this.passedShown)
                    {
                        GwintGameMenu.mSingleton.playSound("gui_gwint_turn_passed");
                    }
                    this.passedShown = true;
                    this.mcPassed.gotoAndPlay("passed");
                }
                else
                {
                    this.passedShown = false;
                    this.mcPassed.gotoAndStop("Idle");
                }
            }
            return;
        }// end function

        public function setIsWinning(param1:Boolean) : void
        {
            if (this.mcWinningRound)
            {
                if (param1)
                {
                    this.mcWinningRound.visible = true;
                    this.mcWinningRound.play();
                }
                else
                {
                    this.mcWinningRound.visible = false;
                    this.mcWinningRound.stop();
                }
            }
            return;
        }// end function

        public function reset() : void
        {
            if (this.txtPassed)
            {
                this.txtPassed.text = "[[gwint_player_passed_element]]";
                this.txtPassed.visible = false;
            }
            this.score = 0;
            this.setPlayerLives(2);
            this.txtCardCount.text = "0";
            return;
        }// end function

    }
}
