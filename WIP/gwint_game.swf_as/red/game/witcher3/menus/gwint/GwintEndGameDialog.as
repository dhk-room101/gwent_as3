package red.game.witcher3.menus.gwint 
{
    import com.gskinner.motion.*;
    import flash.text.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.managers.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.core.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    
    public class GwintEndGameDialog extends scaleform.clik.core.UIComponent
    {
        public function GwintEndGameDialog()
        {
            super();
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            mouseEnabled = false;
            mouseChildren = false;
            this.txtRound1Title.text = "[[gwint_round]]";
            this.txtRound2Title.text = this.txtRound1Title.text + " 2";
            this.txtRound3Title.text = this.txtRound1Title.text + " 3";
            this.txtRound1Title.appendText(" 1");
            visible = false;
            return;
        }

        public function show(arg1:int, arg2:Function):void
        {
            this._winningPlayer = arg1;
            this._resultFunctor = arg2;
            alpha = 0;
            visible = true;
            com.gskinner.motion.GTweener.removeTweens(this);
            com.gskinner.motion.GTweener.to(this, 0.2, {"alpha":1}, {});
            if (arg1 != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
            {
                if (arg1 != red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
                {
                    gotoAndPlay("Draw");
                }
                else 
                {
                    gotoAndPlay("Defeat");
                }
            }
            else 
            {
                gotoAndPlay("Victory");
            }
            this.setPlayerScores();
            this.updatePlayerNames();
            this.showInputFeedback();
            scaleform.clik.managers.InputDelegate.getInstance().addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInputDialog, false, 0, true);
            return;
        }

        public function hide():void
        {
            if (visible) 
            {
                com.gskinner.motion.GTweener.removeTweens(this);
                com.gskinner.motion.GTweener.to(this, 0.2, {"alpha":0}, {});
                scaleform.clik.managers.InputDelegate.getInstance().removeEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInputDialog);
                this.hideInputFeedback();
            }
            return;
        }

        protected function setPlayerScores():void
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc4:*=null;
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            if (loc1) 
            {
                if (loc1.roundResults.length < 3) 
                {
                    throw new Error("GFX - Tried to set Player scores in end game dialog but not enough round data available! " + loc1.roundResults.length);
                }
                this.updateTextFieldsWithRoundResult(loc1.roundResults[0], this.txtP1Round1Score, this.txtP2Round1Score);
                this.updateTextFieldsWithRoundResult(loc1.roundResults[1], this.txtP1Round2Score, this.txtP2Round2Score);
                this.updateTextFieldsWithRoundResult(loc1.roundResults[2], this.txtP1Round3Score, this.txtP2Round3Score);
            }
            return;
        }

        protected function updateTextFieldsWithRoundResult(arg1:GwintRoundResult, arg2:flash.text.TextField, arg3:flash.text.TextField):*
        {
            if (arg1.played) 
            {
                arg2.text = arg1.getPlayerScore(red.game.witcher3.menus.gwint.CardManager.PLAYER_1).toString();
                arg3.text = arg1.getPlayerScore(red.game.witcher3.menus.gwint.CardManager.PLAYER_2).toString();
                if (arg1.winningPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
                {
                    arg2.textColor = 12763584;
                }
                else 
                {
                    arg2.textColor = 14722621;
                }
                if (arg1.winningPlayer != red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
                {
                    arg3.textColor = 12763584;
                }
                else 
                {
                    arg3.textColor = 14722621;
                }
            }
            else 
            {
                arg2.text = "-";
                arg3.text = "-";
            }
            return;
        }

        protected function updatePlayerNames():void
        {
            var loc1:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            if (loc1) 
            {
                this.txtPlayer1Name.text = loc1.playerRenderers[red.game.witcher3.menus.gwint.CardManager.PLAYER_1].playerName;
                this.txtPlayer2Name.text = loc1.playerRenderers[red.game.witcher3.menus.gwint.CardManager.PLAYER_2].playerName;
            }
            return;
        }

        protected function showInputFeedback():void
        {
            red.game.witcher3.managers.InputFeedbackManager.cleanupButtons();
            if (red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.mcTutorials.visible) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.mcTutorials.onHideCallback = this.showInputFeedback;
            }
            else 
            {
                if (this._winningPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                {
                    red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.restart, scaleform.clik.constants.NavigationCode.GAMEPAD_Y, red.core.constants.KeyCode.SPACE, "gwint_play_again");
                }
                red.game.witcher3.managers.InputFeedbackManager.appendButtonById(red.game.witcher3.constants.GwintInputFeedback.close, scaleform.clik.constants.NavigationCode.GAMEPAD_B, red.core.constants.KeyCode.ESCAPE, "panel_button_common_close");
            }
            return;
        }

        protected function hideInputFeedback():void
        {
            red.game.witcher3.managers.InputFeedbackManager.removeButtonById(red.game.witcher3.constants.GwintInputFeedback.restart);
            red.game.witcher3.managers.InputFeedbackManager.removeButtonById(red.game.witcher3.constants.GwintInputFeedback.close);
            return;
        }

        public function closeButtonPressed():void
        {
            if (this._winningPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_2 || this._winningPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
            {
                this._resultFunctor(EndGameDialogResult_EndDefeat);
            }
            else 
            {
                this._resultFunctor(EndGameDialogResult_EndVictory);
            }
            this.hide();
            return;
        }

        private function handleInputDialog(arg1:scaleform.clik.events.InputEvent):void
        {
            var loc1:*=null;
            var loc2:*=false;
            if (visible && !red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.mcTutorials.visible) 
            {
                loc1 = arg1.details;
                loc2 = loc1.value == scaleform.clik.constants.InputValue.KEY_UP;
                if (loc2 && !arg1.handled && !(this._resultFunctor == null)) 
                {
                    var loc3:*=loc1.navEquivalent;
                    switch (loc3) 
                    {
                        case scaleform.clik.constants.NavigationCode.GAMEPAD_B:
                        {
                            this.closeButtonPressed();
                            break;
                        }
                        case scaleform.clik.constants.NavigationCode.GAMEPAD_Y:
                        {
                            if (this._winningPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                            {
                                this._resultFunctor(EndGameDialogResult_Restart);
                                this.hide();
                            }
                            break;
                        }
                    }
                    if (loc1.code == red.core.constants.KeyCode.SPACE) 
                    {
                        if (this._winningPlayer == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID) 
                        {
                            this._resultFunctor(EndGameDialogResult_Restart);
                            this.hide();
                        }
                    }
                }
            }
            return;
        }

        public static const EndGameDialogResult_EndVictory:int=0;

        public static const EndGameDialogResult_EndDefeat:int=1;

        public static const EndGameDialogResult_Restart:int=2;

        public var txtPlayer1Name:flash.text.TextField;

        public var txtPlayer2Name:flash.text.TextField;

        public var txtRound1Title:flash.text.TextField;

        public var txtRound2Title:flash.text.TextField;

        public var txtRound3Title:flash.text.TextField;

        public var txtP1Round1Score:flash.text.TextField;

        public var txtP2Round1Score:flash.text.TextField;

        public var txtP1Round2Score:flash.text.TextField;

        public var txtP2Round2Score:flash.text.TextField;

        public var txtP1Round3Score:flash.text.TextField;

        public var txtP2Round3Score:flash.text.TextField;

        protected var _winningPlayer:int;

        protected var _resultFunctor:Function;

        private var _btnAccept:int=-1;

        private var _btnRestart:int=-1;
    }
}
