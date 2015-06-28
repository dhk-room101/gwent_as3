package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    
    public class CardEffectManager extends Object
    {
        public function CardEffectManager()
        {
            this.seigeP2List = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.rangedP2List = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.meleeP2List = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.meleeP1List = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.rangedP1List = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            this.seigeP1List = new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            super();
            return;
        }

        public function flushAllEffects():void
        {
            this.meleeP1List.length = 0;
            this.meleeP2List.length = 0;
            this.rangedP1List.length = 0;
            this.rangedP2List.length = 0;
            this.seigeP1List.length = 0;
            this.seigeP2List.length = 0;
            return;
        }

        private function getEffectList(arg1:int, arg2:int):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            if (arg2 != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
            {
                if (arg2 == red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
                {
                    if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE) 
                    {
                        return this.meleeP2List;
                    }
                    if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED) 
                    {
                        return this.rangedP2List;
                    }
                    if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE) 
                    {
                        return this.seigeP2List;
                    }
                }
            }
            else 
            {
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE) 
                {
                    return this.meleeP1List;
                }
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED) 
                {
                    return this.rangedP1List;
                }
                if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE) 
                {
                    return this.seigeP1List;
                }
            }
            return null;
        }

        public function registerActiveEffectCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:int, arg3:int):void
        {
            var loc1:*=this.getEffectList(arg2, arg3);
            trace("GFX - effect was registed in list:", arg2, ", for player:", arg3, " and CardInstance:", arg1);
            if (loc1) 
            {
                loc1.push(arg1);
            }
            else 
            {
                throw new Error("GFX - Failed to set effect into proper list in GFX manager. listID: " + arg2.toString() + ", playerID: " + arg3);
            }
            red.game.witcher3.menus.gwint.CardManager.getInstance().recalculateScores();
            return;
        }

        public function unregisterActiveEffectCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=0;
            trace("GFX - unregistering Effect: ", arg1);
            loc1 = this.seigeP2List.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.seigeP2List.splice(loc1, 1);
            }
            loc1 = this.rangedP2List.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.rangedP2List.splice(loc1, 1);
            }
            loc1 = this.meleeP2List.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.meleeP2List.splice(loc1, 1);
            }
            loc1 = this.meleeP1List.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.meleeP1List.splice(loc1, 1);
            }
            loc1 = this.rangedP1List.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.rangedP1List.splice(loc1, 1);
            }
            loc1 = this.seigeP1List.indexOf(arg1);
            if (loc1 != -1) 
            {
                this.seigeP1List.splice(loc1, 1);
            }
            red.game.witcher3.menus.gwint.CardManager.getInstance().recalculateScores();
            return;
        }

        public function getEffectsForList(arg1:int, arg2:int):__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>
        {
            var loc2:*=0;
            var loc1:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc3:*=this.getEffectList(arg1, arg2);
            if (loc3) 
            {
                loc2 = 0;
                while (loc2 < loc3.length) 
                {
                    loc1.push(loc3[loc2]);
                    ++loc2;
                }
            }
            return loc1;
        }

        private var seigeP2List:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        private var rangedP2List:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        private var meleeP2List:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        private var meleeP1List:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        private var rangedP1List:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;

        private var seigeP1List:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.CardInstance>;
    }
}
