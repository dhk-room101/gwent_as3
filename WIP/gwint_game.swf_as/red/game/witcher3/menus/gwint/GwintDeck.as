package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    
    public class GwintDeck extends Object
    {
        public function GwintDeck()
        {
            this.cardIndicesInDeck = new Vector.<int>();
            super();
            return;
        }

        public function drawCard():int
        {
            if (this.cardIndicesInDeck.length > 0) 
            {
                if (this._deckRenderer) 
                {
                    this._deckRenderer.cardCount = (this.cardIndicesInDeck.length - 1);
                }
                return this.cardIndicesInDeck.pop();
            }
            return red.game.witcher3.menus.gwint.CardInstance.INVALID_INSTANCE_ID;
        }

        public function getCardsInDeck(arg1:int, arg2:int, arg3:__AS3__.vec.Vector.<int>):void
        {
            var loc1:*=null;
            var loc2:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc3:*=0;
            while (loc3 < this.cardIndicesInDeck.length) 
            {
                loc1 = loc2.getCardTemplate(this.cardIndicesInDeck[loc3]);
                if (loc1) 
                {
                    if ((loc1.isType(arg1) || arg1 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) && (loc1.hasEffect(arg2) || arg2 == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_None)) 
                    {
                        arg3.push(this.cardIndicesInDeck[loc3]);
                    }
                }
                else 
                {
                    throw new Error("GFX [ERROR] - failed to fetch template reference for card ID: " + this.cardIndicesInDeck[loc3]);
                }
                ++loc3;
            }
            return;
        }

        public function tryDrawSpecificCard(arg1:int):Boolean
        {
            var loc1:*=0;
            while (loc1 < this.cardIndicesInDeck.length) 
            {
                if (this.cardIndicesInDeck[loc1] == arg1) 
                {
                    this.cardIndicesInDeck.splice(loc1, 1);
                    return true;
                }
                ++loc1;
            }
            return false;
        }

        public function numCopiesLeft(arg1:int):int
        {
            var loc1:*=0;
            var loc2:*=0;
            loc1 = 0;
            while (loc1 < this.cardIndicesInDeck.length) 
            {
                if (arg1 == this.cardIndicesInDeck[loc1]) 
                {
                    ++loc2;
                }
                ++loc1;
            }
            return loc2;
        }

        public function dbGetNumCopiesOfCard(arg1:int):int
        {
            var loc1:*=0;
            var loc2:*=0;
            loc1 = 0;
            while (loc1 < this.cardIndices.length) 
            {
                if (arg1 == this.cardIndices[loc1]) 
                {
                    ++loc2;
                }
                ++loc1;
            }
            return loc2;
        }

        public function triggerRefresh():void
        {
            if (this.refreshCallback != null) 
            {
                this.refreshCallback();
            }
            return;
        }

        public function dbAddCard(arg1:int):void
        {
            this.cardIndices.push(arg1);
            if (this.onCardChangedCallback != null) 
            {
                this.onCardChangedCallback(arg1, this.dbGetNumCopiesOfCard(arg1));
            }
            return;
        }

        public function dbRemoveCard(arg1:int):void
        {
            var loc1:*=0;
            loc1 = 0;
            while (loc1 < this.cardIndices.length) 
            {
                if (this.cardIndices[loc1] == arg1) 
                {
                    this.cardIndices.splice(loc1, 1);
                    break;
                }
                ++loc1;
            }
            if (this.onCardChangedCallback != null) 
            {
                this.onCardChangedCallback(arg1, this.dbGetNumCopiesOfCard(arg1));
            }
            return;
        }

        public function dbIsValidDeck():Boolean
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=0;
            var loc4:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            loc2 = 0;
            while (loc2 < this.cardIndices.length) 
            {
                loc3 = loc4.getCardTemplate(this.cardIndices[loc2]);
                if (loc3.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
                {
                    ++loc1;
                }
                ++loc2;
            }
            trace("GFX RRR dbIsValidDeck ", loc1);
            if (loc1 < 22) 
            {
                return false;
            }
            return true;
        }

        public function dbCanAddCard(arg1:int):Boolean
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=0;
            var loc4:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc5:*=loc4.getCardTemplate(arg1);
            if (!loc5.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
            {
                loc2 = 0;
                while (loc2 < this.cardIndices.length) 
                {
                    loc3 = loc4.getCardTemplate(this.cardIndices[loc2]);
                    if (!loc3.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
                    {
                        ++loc1;
                    }
                    ++loc2;
                }
                return loc1 < 10;
            }
            return true;
        }

        public function set DeckRenderer(arg1:red.game.witcher3.menus.gwint.GwintDeckRenderer):void
        {
            this._deckRenderer = arg1;
            this._deckRenderer.factionString = this.getDeckKingTemplate().getFactionString();
            this._deckRenderer.cardCount = this.cardIndices.length;
            return;
        }

        public function dbCountCards(arg1:int, arg2:int):int
        {
            var loc2:*=null;
            var loc1:*=0;
            var loc3:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            var loc4:*=0;
            while (loc4 < this.cardIndices.length) 
            {
                loc2 = loc3.getCardTemplate(this.cardIndices[loc4]);
                if ((loc2.isType(arg1) || arg1 == red.game.witcher3.menus.gwint.CardTemplate.CardType_None) && (loc2.hasEffect(arg2) || arg2 == red.game.witcher3.menus.gwint.CardTemplate.CardEffect_None)) 
                {
                    ++loc1;
                }
                ++loc4;
            }
            return loc1;
        }

        public function getDeckFaction():int
        {
            var loc1:*=this.getDeckKingTemplate();
            if (loc1) 
            {
                return loc1.factionIdx;
            }
            return red.game.witcher3.menus.gwint.CardTemplate.FactionId_Error;
        }

        public function getFactionNameString():String
        {
            var loc1:*=this.getDeckFaction();
            switch (loc1) 
            {
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard:
                {
                    return "[[gwint_faction_name_nilfgaard]]";
                }
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_No_Mans_Land:
                {
                    return "[[gwint_faction_name_no_mans_land]]";
                }
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_Northern_Kingdom:
                {
                    return "[[gwint_faction_name_northern_kingdom]]";
                }
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_Scoiatael:
                {
                    return "[[gwint_faction_name_scoiatael]]";
                }
            }
            return "Invalid Faction for Deck";
        }

        public function getFactionPerkString():String
        {
            var loc1:*=this.getDeckFaction();
            switch (loc1) 
            {
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_Nilfgaard:
                {
                    return "[[gwint_faction_ability_nilf]]";
                }
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_No_Mans_Land:
                {
                    return "[[gwint_faction_ability_nml]]";
                }
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_Northern_Kingdom:
                {
                    return "[[gwint_faction_ability_nr]]";
                }
                case red.game.witcher3.menus.gwint.CardTemplate.FactionId_Scoiatael:
                {
                    return "[[gwint_faction_ability_scoia]]";
                }
            }
            return "Invalid Faction, no perk";
        }

        public function getDeckKingTemplate():red.game.witcher3.menus.gwint.CardTemplate
        {
            return red.game.witcher3.menus.gwint.CardManager.getInstance().getCardTemplate(this.selectedKingIndex);
        }

        public function toString():String
        {
            var loc2:*=0;
            var loc1:*="";
            loc2 = 0;
            while (loc2 < this.cardIndices.length) 
            {
                loc1 = loc1 + (this.cardIndices[loc2].toString() + " - ");
                ++loc2;
            }
            return "[GwintDeck] Name:" + this.deckName + ", selectedKing:" + this.selectedKingIndex.toString() + ", indices:" + loc1;
        }

        public function originalStength():int
        {
            var loc2:*=0;
            var loc3:*=null;
            var loc1:*=0;
            var loc4:*=red.game.witcher3.menus.gwint.CardManager.getInstance();
            loc2 = 0;
            while (loc2 < this.cardIndices.length) 
            {
                loc3 = loc4.getCardTemplate(this.cardIndices[loc2]);
                if (loc3.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Creature)) 
                {
                    loc1 = loc1 + loc3.power;
                }
                var loc5:*=loc3.getFirstEffect();
                switch (loc5) 
                {
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee:
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged:
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege:
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ClearSky:
                    {
                        loc1 = loc1 + 2;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy:
                    {
                        loc1 = loc1 + 4;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Horn:
                    {
                        loc1 = loc1 + 5;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Scorch:
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_MeleeScorch:
                    {
                        loc1 = loc1 + 6;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SummonClones:
                    {
                        loc1 = loc1 + 3;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours:
                    {
                        loc1 = loc1 + 4;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse:
                    {
                        loc1 = loc1 + 4;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2:
                    {
                        loc1 = loc1 + 6;
                        break;
                    }
                    case red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SameTypeMorale:
                    {
                        loc1 = loc1 + 4;
                        break;
                    }
                }
                ++loc2;
            }
            trace("GFX -#AI#----- > ", loc1);
            return loc1;
        }

        public function shuffleDeck(arg1:int):void
        {
            var loc2:*=0;
            var loc3:*=0;
            var loc1:*=new Vector.<int>();
            var loc4:*=this.cardIndices.length;
            loc2 = 0;
            while (loc2 < loc4) 
            {
                loc1.push(this.cardIndices[loc2]);
                ++loc2;
            }
            this.adjustDeckToDifficulty(arg1, loc1);
            this.cardIndicesInDeck.length = 0;
            while (loc1.length > 0) 
            {
                loc3 = Math.min(Math.floor(Math.random() * loc1.length), (loc1.length - 1));
                this.cardIndicesInDeck.push(loc1[loc3]);
                loc1.splice(loc3, 1);
            }
            if (this.specialCard != -1) 
            {
                this.cardIndicesInDeck.push(this.specialCard);
            }
            if (this._deckRenderer) 
            {
                this._deckRenderer.cardCount = this.cardIndicesInDeck.length;
            }
            return;
        }

        private function adjustDeckToDifficulty(arg1:int, arg2:__AS3__.vec.Vector.<int>):void
        {
            var loc1:*=0;
            if (this.dynamicCardRequirements.length > 0 && this.dynamicCardRequirements.length == this.dynamicCards.length) 
            {
                trace("GFX -#AI#------------------- Deck balance --------------------");
                loc1 = 0;
                while (loc1 < this.dynamicCardRequirements.length) 
                {
                    if (arg1 >= this.dynamicCardRequirements[loc1]) 
                    {
                        trace("GFX -#AI# Requirement [ " + this.dynamicCardRequirements[loc1] + " ] - Adding card with id [ " + this.dynamicCards[loc1] + "]");
                        arg2.push(this.dynamicCards[loc1]);
                    }
                    ++loc1;
                }
                trace("GFX -#AI#-----------------------------------------------------");
            }
            return;
        }

        public function readdCard(arg1:int):void
        {
            this.cardIndicesInDeck.unshift(arg1);
            return;
        }

        public var deckName:String;

        public var cardIndices:Array;

        public var selectedKingIndex:int;

        public var specialCard:int;

        public var isUnlocked:Boolean=false;

        public var dynamicCardRequirements:Array;

        public var dynamicCards:Array;

        public var refreshCallback:Function;

        public var onCardChangedCallback:Function;

        private var _deckRenderer:red.game.witcher3.menus.gwint.GwintDeckRenderer;

        public var cardIndicesInDeck:__AS3__.vec.Vector.<int>;
    }
}
