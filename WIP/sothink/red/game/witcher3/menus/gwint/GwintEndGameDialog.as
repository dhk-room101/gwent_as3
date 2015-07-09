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

    public class GwintEndGameDialog extends UIComponent
    {
        public var txtPlayer1Name:TextField;
        public var txtPlayer2Name:TextField;
        public var txtRound1Title:TextField;
        public var txtRound2Title:TextField;
        public var txtRound3Title:TextField;
        public var txtP1Round1Score:TextField;
        public var txtP2Round1Score:TextField;
        public var txtP1Round2Score:TextField;
        public var txtP2Round2Score:TextField;
        public var txtP1Round3Score:TextField;
        public var txtP2Round3Score:TextField;
        protected var _winningPlayer:int;
        protected var _resultFunctor:Function;
        private var _btnAccept:int = -1;
        private var _btnRestart:int = -1;
        public static const EndGameDialogResult_EndVictory:int = 0;
        public static const EndGameDialogResult_EndDefeat:int = 1;
        public static const EndGameDialogResult_Restart:int = 2;

        public function GwintEndGameDialog()
        {
            return;
        }// end function

        override protected function configUI() : void
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
        }// end function

        public function show(param1:int, param2:Function) : void
        {
            this._winningPlayer = param1;
            this._resultFunctor = param2;
            alpha = 0;
            visible = true;
            GTweener.removeTweens(this);
            GTweener.to(this, 0.2, {alpha:1}, {});
            if (param1 == CardManager.PLAYER_1)
            {
                gotoAndPlay("Victory");
            }
            else if (param1 == CardManager.PLAYER_2)
            {
                gotoAndPlay("Defeat");
            }
            else
            {
                gotoAndPlay("Draw");
            }
            this.setPlayerScores();
            this.updatePlayerNames();
            this.showInputFeedback();
            InputDelegate.getInstance().addEventListener(InputEvent.INPUT, this.handleInputDialog, false, 0, true);
            return;
        }// end function

        public function hide() : void
        {
            if (visible)
            {
                GTweener.removeTweens(this);
                GTweener.to(this, 0.2, {alpha:0}, {});
                InputDelegate.getInstance().removeEventListener(InputEvent.INPUT, this.handleInputDialog);
                this.hideInputFeedback();
            }
            return;
        }// end function

        protected function setPlayerScores() : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_1:* = CardManager.getInstance();
            if (_loc_1)
            {
                if (_loc_1.roundResults.length < 3)
                {
                    throw new Error("GFX - Tried to set Player scores in end game dialog but not enough round data available! " + _loc_1.roundResults.length);
                }
                this.updateTextFieldsWithRoundResult(_loc_1.roundResults[0], this.txtP1Round1Score, this.txtP2Round1Score);
                this.updateTextFieldsWithRoundResult(_loc_1.roundResults[1], this.txtP1Round2Score, this.txtP2Round2Score);
                this.updateTextFieldsWithRoundResult(_loc_1.roundResults[2], this.txtP1Round3Score, this.txtP2Round3Score);
            }
            return;
        }// end function

        protected function updateTextFieldsWithRoundResult(param1:GwintRoundResult, param2:TextField, param3:TextField)
        {
            if (param1.played)
            {
                param2.text = param1.getPlayerScore(CardManager.PLAYER_1).toString();
                param3.text = param1.getPlayerScore(CardManager.PLAYER_2).toString();
                if (param1.winningPlayer == CardManager.PLAYER_1)
                {
                    param2.textColor = 14722621;
                }
                else
                {
                    param2.textColor = 12763584;
                }
                if (param1.winningPlayer == CardManager.PLAYER_2)
                {
                    param3.textColor = 14722621;
                }
                else
                {
                    param3.textColor = 12763584;
                }
            }
            else
            {
                param2.text = "-";
                param3.text = "-";
            }
            return;
        }// end function

        protected function updatePlayerNames() : void
        {
            var _loc_1:* = CardManager.getInstance();
            if (_loc_1)
            {
                this.txtPlayer1Name.text = _loc_1.playerRenderers[CardManager.PLAYER_1].playerName;
                this.txtPlayer2Name.text = _loc_1.playerRenderers[CardManager.PLAYER_2].playerName;
            }
            return;
        }// end function

        protected function showInputFeedback() : void
        {
            InputFeedbackManager.cleanupButtons();
            if (!GwintGameMenu.mSingleton.mcTutorials.visible)
            {
                if (this._winningPlayer == CardManager.PLAYER_INVALID)
                {
                    InputFeedbackManager.appendButtonById(GwintInputFeedback.restart, NavigationCode.GAMEPAD_Y, KeyCode.SPACE, "gwint_play_again");
                }
                InputFeedbackManager.appendButtonById(GwintInputFeedback.close, NavigationCode.GAMEPAD_B, KeyCode.ESCAPE, "panel_button_common_close");
            }
            else
            {
                GwintGameMenu.mSingleton.mcTutorials.onHideCallback = this.showInputFeedback;
            }
            return;
        }// end function

        protected function hideInputFeedback() : void
        {
            InputFeedbackManager.removeButtonById(GwintInputFeedback.restart);
            InputFeedbackManager.removeButtonById(GwintInputFeedback.close);
            return;
        }// end function

        public function closeButtonPressed() : void
        {
            if (this._winningPlayer == CardManager.PLAYER_2 || this._winningPlayer == CardManager.PLAYER_INVALID)
            {
                this._resultFunctor(EndGameDialogResult_EndDefeat);
            }
            else
            {
                this._resultFunctor(EndGameDialogResult_EndVictory);
            }
            this.hide();
            return;
        }// end function

        private function handleInputDialog(event:InputEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = false;
            if (visible && !GwintGameMenu.mSingleton.mcTutorials.visible)
            {
                _loc_2 = event.details;
                _loc_3 = _loc_2.value == InputValue.KEY_UP;
                if (_loc_3 && !event.handled && this._resultFunctor != null)
                {
                    switch(_loc_2.navEquivalent)
                    {
                        case NavigationCode.GAMEPAD_B:
                        {
                            this.closeButtonPressed();
                            break;
                        }
                        case NavigationCode.GAMEPAD_Y:
                        {
                            if (this._winningPlayer == CardManager.PLAYER_INVALID)
                            {
                                this._resultFunctor(EndGameDialogResult_Restart);
                                this.hide();
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    if (_loc_2.code == KeyCode.SPACE)
                    {
                        if (this._winningPlayer == CardManager.PLAYER_INVALID)
                        {
                            this._resultFunctor(EndGameDialogResult_Restart);
                            this.hide();
                        }
                    }
                }
            }
            return;
        }// end function

    }
}
