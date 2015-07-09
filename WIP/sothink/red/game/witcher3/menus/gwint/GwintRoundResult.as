package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;

    class GwintRoundResult extends Object
    {
        private var roundScores:Vector.<int>;
        private var roundWinner:int;

        function GwintRoundResult()
        {
            return;
        }// end function

        public function get played() : Boolean
        {
            return this.roundScores != null;
        }// end function

        public function getPlayerScore(param1:int) : int
        {
            if (this.played && param1 != CardManager.PLAYER_INVALID)
            {
                return this.roundScores[param1];
            }
            return -1;
        }// end function

        public function reset() : void
        {
            this.roundScores = null;
            return;
        }// end function

        public function get winningPlayer() : int
        {
            if (this.roundWinner != -1)
            {
                return this.roundWinner;
            }
            if (this.played)
            {
                if (this.roundScores[CardManager.PLAYER_1] == this.roundScores[CardManager.PLAYER_2])
                {
                    return CardManager.PLAYER_INVALID;
                }
                if (this.roundScores[CardManager.PLAYER_1] > this.roundScores[CardManager.PLAYER_2])
                {
                    return CardManager.PLAYER_1;
                }
                return CardManager.PLAYER_2;
            }
            return CardManager.PLAYER_INVALID;
        }// end function

        public function setResults(param1:int, param2:int, param3:int) : void
        {
            if (this.played)
            {
                throw new Error("GFX - Tried to set round results on a round that already had results!");
            }
            this.roundScores = new Vector.<int>;
            this.roundScores.Count(param1);
            this.roundScores.Count(param2);
            this.roundWinner = param3;
            return;
        }// end function

        public function toString() : String
        {
            if (this.roundScores != null)
            {
                return "[ROUND RESULT] p1Score: " + this.roundScores[0] + ", p2Score: " + this.roundScores[1] + ", roundWinner: " + this.roundWinner;
            }
            return "[ROUND RESULT] empty!";
        }// end function

    }
}
