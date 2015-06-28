package red.game.witcher3.menus.gwint 
{
    import flash.display.*;
    import red.core.events.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.controls.*;
    import scaleform.clik.core.*;
    
    public class GwintPlayerRenderer extends scaleform.clik.core.UIComponent
    {
        public function GwintPlayerRenderer()
        {
            this._playerID = red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
            super();
            return;
        }

        public function set playerName(arg1:String):void
        {
            this.txtPlayerName.text = arg1;
            return;
        }

        public function get playerName():String
        {
            return this.txtPlayerName.text;
        }

        public function get playerNameDataProvider():String
        {
            return this._playerNameDataProvider;
        }

        public function set playerNameDataProvider(arg1:String):void
        {
            this._playerNameDataProvider = arg1;
            return;
        }

        public function get playerID():int
        {
            return this._playerID;
        }

        public function set playerID(arg1:int):void
        {
            this._playerID = arg1;
            if (this.mcPlayerPortrait) 
            {
                if (this._playerID != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
                {
                    this.mcPlayerPortrait.gotoAndStop("npc");
                }
                else 
                {
                    this.mcPlayerPortrait.gotoAndStop("geralt");
                }
            }
            return;
        }

        public function set score(arg1:int):void
        {
            var loc1:*=null;
            if (this._score != arg1) 
            {
                if (this.mcScore.currentFrameLabel == "Idle") 
                {
                    if (this._score < arg1) 
                    {
                        this.mcScore.gotoAndPlay("Grew");
                    }
                    else 
                    {
                        this.mcScore.gotoAndPlay("Shrank");
                    }
                }
                this._score = arg1;
                loc1 = this.mcScore.getChildByName("txtScore") as red.game.witcher3.controls.W3TextArea;
                if (loc1) 
                {
                    loc1.text = this._score.toString();
                }
            }
            return;
        }

        public function set numCardsInHand(arg1:int):void
        {
            this.txtCardCount.text = arg1.toString();
            return;
        }

        public function set turnActive(arg1:Boolean):void
        {
            if (arg1 != this._turnActive) 
            {
                this._turnActive = arg1;
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
        }

        protected override function configUI():void
        {
            super.configUI();
            if (this._playerNameDataProvider != red.game.witcher3.constants.CommonConstants.INVALID_STRING_PARAM) 
            {
                dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, this._playerNameDataProvider, [this.setPlayerName]));
            }
            if (this.mcPassed) 
            {
                this.txtPassed = this.mcPassed.getChildByName("txtPassed") as red.game.witcher3.controls.W3TextArea;
            }
            if (this.mcWinningRound) 
            {
                this.mcWinningRound.stop();
                this.mcWinningRound.visible = false;
            }
            this.reset();
            return;
        }

        protected function setPlayerName(arg1:String):void
        {
            this.playerName = arg1;
            return;
        }

        public function setPlayerLives(arg1:int):void
        {
            var loc1:*=null;
            var loc2:*=null;
            trace("GFX - Updating life for Player: " + this.playerName + ", to: " + arg1 + " and life indicator: " + this.mcLifeIndicator);
            if (this._lastSetPlayerLives != arg1) 
            {
                this._lastSetPlayerLives = arg1;
                loc1 = this.mcLifeIndicator.getChildByName("mcLifeGemAnim1") as flash.display.MovieClip;
                loc2 = this.mcLifeIndicator.getChildByName("mcLifeGemAnim2") as flash.display.MovieClip;
                var loc3:*=arg1;
                switch (loc3) 
                {
                    case 0:
                    {
                        if (loc2.currentLabel != "play") 
                        {
                            loc2.gotoAndPlay("play");
                        }
                        if (loc1.currentLabel != "play") 
                        {
                            loc1.gotoAndPlay("play");
                        }
                        break;
                    }
                    case 1:
                    {
                        if (loc2.currentLabel != "visible") 
                        {
                            loc2.gotoAndStop("visible");
                        }
                        if (loc1.currentLabel != "play") 
                        {
                            loc1.gotoAndPlay("play");
                        }
                        break;
                    }
                    case 2:
                    {
                        if (loc2.currentLabel != "visible") 
                        {
                            loc2.gotoAndStop("visible");
                        }
                        if (loc1.currentLabel != "visible") 
                        {
                            loc1.gotoAndStop("visible");
                        }
                        break;
                    }
                }
            }
            return;
        }

        public function showPassed(arg1:Boolean):void
        {
            if (this.txtPassed) 
            {
                this.txtPassed.visible = arg1;
            }
            if (this.mcPassed) 
            {
                if (arg1) 
                {
                    if (!this.passedShown) 
                    {
                        red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_turn_passed");
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
        }

        public function setIsWinning(arg1:Boolean):void
        {
            if (this.mcWinningRound) 
            {
                if (arg1) 
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
        }

        public function reset():void
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
        }

        public var txtPassed:red.game.witcher3.controls.W3TextArea;

        public var mcPassed:flash.display.MovieClip;

        public var txtPlayerName:red.game.witcher3.controls.W3TextArea;

        public var txtFactionName:red.game.witcher3.controls.W3TextArea;

        public var txtCardCount:red.game.witcher3.controls.W3TextArea;

        public var mcPlayerPortrait:flash.display.MovieClip;

        public var mcScore:flash.display.MovieClip;

        public var mcLifeIndicator:flash.display.MovieClip;

        public var mcFactionIcon:flash.display.MovieClip;

        public var mcWinningRound:flash.display.MovieClip;

        protected var _playerNameDataProvider:String="INVALID_STRING_PARAM!";

        protected var _playerID:int;

        private var _score:int=-1;

        private var _turnActive:Boolean=false;

        protected var _lastSetPlayerLives:int=-1;

        protected var passedShown:Boolean=false;
    }
}
