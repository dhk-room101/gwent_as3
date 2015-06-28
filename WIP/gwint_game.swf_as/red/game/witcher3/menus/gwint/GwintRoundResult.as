package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    
    internal class GwintRoundResult extends Object
    {
        public function GwintRoundResult()
        {
            super();
            return;
        }

        public function get played():Boolean
        {
            return !(this.roundScores == null);
        }

        public function getPlayerScore(arg1:int):int
        {
            if (this.played && !(arg1 == red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID)) 
            {
                return this.roundScores[arg1];
            }
            return -1;
        }

        public function reset():void
        {
            this.roundScores = null;
            return;
        }

        public function get winningPlayer():int
        {
            if (this.roundWinner != -1) 
            {
                return this.roundWinner;
            }
            if (this.played) 
            {
                if (this.roundScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] == this.roundScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_2]) 
                {
                    return red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
                }
                if (this.roundScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_1] > this.roundScores[red.game.witcher3.menus.gwint.CardManager.PLAYER_2]) 
                {
                    return red.game.witcher3.menus.gwint.CardManager.PLAYER_1;
                }
                return red.game.witcher3.menus.gwint.CardManager.PLAYER_2;
            }
            return red.game.witcher3.menus.gwint.CardManager.PLAYER_INVALID;
        }

        public function setResults(arg1:int, arg2:int, arg3:int):void
        {
            if (this.played) 
            {
                throw new Error("GFX - Tried to set round results on a round that already had results!");
            }
            this.roundScores = new Vector.<int>();
            this.roundScores.push(arg1);
            this.roundScores.push(arg2);
            this.roundWinner = arg3;
            return;
        }

        public function toString():String
        {
            if (this.roundScores != null) 
            {
                return "[ROUND RESULT] p1Score: " + this.roundScores[0] + ", p2Score: " + this.roundScores[1] + ", roundWinner: " + this.roundWinner;
            }
            return "[ROUND RESULT] empty!";
        }

        private var roundScores:__AS3__.vec.Vector.<int>;

        private var roundWinner:int;
    }
}
