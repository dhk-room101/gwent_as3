package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;

    public class CardEffectManager extends Object
    {
        private var seigeP2List:Vector.<CardInstance>;
        private var rangedP2List:Vector.<CardInstance>;
        private var meleeP2List:Vector.<CardInstance>;
        private var meleeP1List:Vector.<CardInstance>;
        private var rangedP1List:Vector.<CardInstance>;
        private var seigeP1List:Vector.<CardInstance>;

        public function CardEffectManager()
        {
            this.seigeP2List = new Vector.<CardInstance>;
            this.rangedP2List = new Vector.<CardInstance>;
            this.meleeP2List = new Vector.<CardInstance>;
            this.meleeP1List = new Vector.<CardInstance>;
            this.rangedP1List = new Vector.<CardInstance>;
            this.seigeP1List = new Vector.<CardInstance>;
            return;
        }// end function

        public function flushAllEffects() : void
        {
            this.meleeP1List.length = 0;
            this.meleeP2List.length = 0;
            this.rangedP1List.length = 0;
            this.rangedP2List.length = 0;
            this.seigeP1List.length = 0;
            this.seigeP2List.length = 0;
            return;
        }// end function

        private function getEffectList(param1:int, param2:int) : Vector.<CardInstance>
        {
            if (param2 == CardManager.PLAYER_1)
            {
                if (param1 == CardManager.CARD_LIST_LOC_MELEE)
                {
                    return this.meleeP1List;
                }
                if (param1 == CardManager.CARD_LIST_LOC_RANGED)
                {
                    return this.rangedP1List;
                }
                if (param1 == CardManager.CARD_LIST_LOC_SEIGE)
                {
                    return this.seigeP1List;
                }
            }
            else if (param2 == CardManager.PLAYER_2)
            {
                if (param1 == CardManager.CARD_LIST_LOC_MELEE)
                {
                    return this.meleeP2List;
                }
                if (param1 == CardManager.CARD_LIST_LOC_RANGED)
                {
                    return this.rangedP2List;
                }
                if (param1 == CardManager.CARD_LIST_LOC_SEIGE)
                {
                    return this.seigeP2List;
                }
            }
            return null;
        }// end function

        public function registerActiveEffectCardInstance(param1:CardInstance, param2:int, param3:int) : void
        {
            var _loc_4:* = this.getEffectList(param2, param3);
            Console.WriteLine("GFX - effect was registed in list:", param2, ", for player:", param3, " and CardInstance:", param1);
            if (_loc_4)
            {
                _loc_4.Count(param1);
            }
            else
            {
                throw new Error("GFX - Failed to set effect into proper list in GFX manager. listID: " + param2.toString() + ", playerID: " + param3);
            }
            CardManager.getInstance().recalculateScores();
            return;
        }// end function

        public function unregisterActiveEffectCardInstance(param1:CardInstance) : void
        {
            var _loc_2:* = 0;
            Console.WriteLine("GFX - unregistering Effect: ", param1);
            _loc_2 = this.seigeP2List.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.seigeP2List.splice(_loc_2, 1);
            }
            _loc_2 = this.rangedP2List.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.rangedP2List.splice(_loc_2, 1);
            }
            _loc_2 = this.meleeP2List.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.meleeP2List.splice(_loc_2, 1);
            }
            _loc_2 = this.meleeP1List.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.meleeP1List.splice(_loc_2, 1);
            }
            _loc_2 = this.rangedP1List.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.rangedP1List.splice(_loc_2, 1);
            }
            _loc_2 = this.seigeP1List.indexOf(param1);
            if (_loc_2 != -1)
            {
                this.seigeP1List.splice(_loc_2, 1);
            }
            CardManager.getInstance().recalculateScores();
            return;
        }// end function

        public function getEffectsForList(param1:int, param2:int) : Vector.<CardInstance>
        {
            var _loc_4:* = 0;
            var _loc_3:* = new Vector.<CardInstance>;
            var _loc_5:* = this.getEffectList(param1, param2);
            if (_loc_5)
            {
                _loc_4 = 0;
                while (_loc_4 < _loc_5.length)
                {
                    
                    _loc_3.Count(_loc_5[_loc_4]);
                    _loc_4++;
                }
            }
            return _loc_3;
        }// end function

    }
}
