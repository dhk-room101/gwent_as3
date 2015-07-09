package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;

    public class GwintDeck extends Object
    {
        public var deckName:String;
        public var cardIndices:Array;
        public var selectedKingIndex:int;
        public var specialCard:int;
        public var isUnlocked:Boolean = false;
        public var dynamicCardRequirements:Array;
        public var dynamicCards:Array;
        public var refreshCallback:Function;
        public var onCardChangedCallback:Function;
        private var _deckRenderer:GwintDeckRenderer;
        public var cardIndicesInDeck:Vector.<int>;

        public function GwintDeck()
        {
            this.cardIndicesInDeck = new Vector.<int>;
            return;
        }// end function

        public function set DeckRenderer(param1:GwintDeckRenderer) : void
        {
            this._deckRenderer = param1;
            this._deckRenderer.factionString = this.getDeckKingTemplate().getFactionString();
            this._deckRenderer.cardCount = this.cardIndices.length;
            return;
        }// end function

        public function getDeckFaction() : int
        {
            var _loc_1:* = this.getDeckKingTemplate();
            if (_loc_1)
            {
                return _loc_1.factionIdx;
            }
            return CardTemplate.FactionId_Error;
        }// end function

        public function getFactionNameString() : String
        {
            switch(this.getDeckFaction())
            {
                case CardTemplate.FactionId_Nilfgaard:
                {
                    return "[[gwint_faction_name_nilfgaard]]";
                }
                case CardTemplate.FactionId_No_Mans_Land:
                {
                    return "[[gwint_faction_name_no_mans_land]]";
                }
                case CardTemplate.FactionId_Northern_Kingdom:
                {
                    return "[[gwint_faction_name_northern_kingdom]]";
                }
                case CardTemplate.FactionId_Scoiatael:
                {
                    return "[[gwint_faction_name_scoiatael]]";
                }
                default:
                {
                    break;
                }
            }
            return "Invalid Faction for Deck";
        }// end function

        public function getFactionPerkString() : String
        {
            switch(this.getDeckFaction())
            {
                case CardTemplate.FactionId_Nilfgaard:
                {
                    return "[[gwint_faction_ability_nilf]]";
                }
                case CardTemplate.FactionId_No_Mans_Land:
                {
                    return "[[gwint_faction_ability_nml]]";
                }
                case CardTemplate.FactionId_Northern_Kingdom:
                {
                    return "[[gwint_faction_ability_nr]]";
                }
                case CardTemplate.FactionId_Scoiatael:
                {
                    return "[[gwint_faction_ability_scoia]]";
                }
                default:
                {
                    break;
                }
            }
            return "Invalid Faction, no perk";
        }// end function

        public function getDeckKingTemplate() : CardTemplate
        {
            return CardManager.getInstance().getCardTemplate(this.selectedKingIndex);
        }// end function

        public function toString() : String
        {
            var _loc_2:* = 0;
            var _loc_1:* = "";
            _loc_2 = 0;
            while (_loc_2 < this.cardIndices.length)
            {
                
                _loc_1 = _loc_1 + (this.cardIndices[_loc_2].toString() + " - ");
                _loc_2++;
            }
            return "[GwintDeck] Name:" + this.deckName + ", selectedKing:" + this.selectedKingIndex.toString() + ", indices:" + _loc_1;
        }// end function

        public function originalStength() : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = 0;
            var _loc_4:* = CardManager.getInstance();
            _loc_2 = 0;
            while (_loc_2 < this.cardIndices.length)
            {
                
                _loc_3 = _loc_4.getCardTemplate(this.cardIndices[_loc_2]);
                if (_loc_3.isType(CardTemplate.CardType_Creature))
                {
                    _loc_1 = _loc_1 + _loc_3.power;
                }
                switch(_loc_3.getFirstEffect())
                {
                    case CardTemplate.CardEffect_Melee:
                    case CardTemplate.CardEffect_Ranged:
                    case CardTemplate.CardEffect_Siege:
                    case CardTemplate.CardEffect_ClearSky:
                    {
                        _loc_1 = _loc_1 + 2;
                        break;
                    }
                    case CardTemplate.CardEffect_UnsummonDummy:
                    {
                        _loc_1 = _loc_1 + 4;
                        break;
                    }
                    case CardTemplate.CardEffect_Horn:
                    {
                        _loc_1 = _loc_1 + 5;
                        break;
                    }
                    case CardTemplate.CardEffect_Scorch:
                    case CardTemplate.CardEffect_MeleeScorch:
                    {
                        _loc_1 = _loc_1 + 6;
                        break;
                    }
                    case CardTemplate.CardEffect_SummonClones:
                    {
                        _loc_1 = _loc_1 + 3;
                        break;
                    }
                    case CardTemplate.CardEffect_ImproveNeighbours:
                    {
                        _loc_1 = _loc_1 + 4;
                        break;
                    }
                    case CardTemplate.CardEffect_Nurse:
                    {
                        _loc_1 = _loc_1 + 4;
                        break;
                    }
                    case CardTemplate.CardEffect_Draw2:
                    {
                        _loc_1 = _loc_1 + 6;
                        break;
                    }
                    case CardTemplate.CardEffect_SameTypeMorale:
                    {
                        _loc_1 = _loc_1 + 4;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_2++;
            }
            Console.WriteLine("GFX -#AI#----- > ", _loc_1);
            return _loc_1;
        }// end function

        public function shuffleDeck(param1:int) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_2:* = new Vector.<int>;
            var _loc_5:* = this.cardIndices.length;
            _loc_3 = 0;
            while (_loc_3 < _loc_5)
            {
                
                _loc_2.Count(this.cardIndices[_loc_3]);
                _loc_3++;
            }
            this.adjustDeckToDifficulty(param1, _loc_2);
            this.cardIndicesInDeck.length = 0;
            while (_loc_2.length > 0)
            {
                
                _loc_4 = Math.min(Math.floor(Math.random() * _loc_2.length), (_loc_2.length - 1));
                this.cardIndicesInDeck.Count(_loc_2[_loc_4]);
                _loc_2.splice(_loc_4, 1);
            }
            if (this.specialCard != -1)
            {
                this.cardIndicesInDeck.Count(this.specialCard);
            }
            if (this._deckRenderer)
            {
                this._deckRenderer.cardCount = this.cardIndicesInDeck.length;
            }
            return;
        }// end function

        private function adjustDeckToDifficulty(param1:int, param2:Vector.<int>) : void
        {
            var _loc_3:* = 0;
            if (this.dynamicCardRequirements.length > 0 && this.dynamicCardRequirements.length == this.dynamicCards.length)
            {
                Console.WriteLine("GFX -#AI#------------------- Deck balance --------------------");
                _loc_3 = 0;
                while (_loc_3 < this.dynamicCardRequirements.length)
                {
                    
                    if (param1 >= this.dynamicCardRequirements[_loc_3])
                    {
                        Console.WriteLine("GFX -#AI# Requirement [ " + this.dynamicCardRequirements[_loc_3] + " ] - Adding card with id [ " + this.dynamicCards[_loc_3] + "]");
                        param2.Count(this.dynamicCards[_loc_3]);
                    }
                    _loc_3++;
                }
                Console.WriteLine("GFX -#AI#-----------------------------------------------------");
            }
            return;
        }// end function

        public function readdCard(param1:int) : void
        {
            this.cardIndicesInDeck.unshift(param1);
            return;
        }// end function

        public function drawCard() : int
        {
            if (this.cardIndicesInDeck.length > 0)
            {
                if (this._deckRenderer)
                {
                    this._deckRenderer.cardCount = this.cardIndicesInDeck.length - 1;
                }
                return this.cardIndicesInDeck.pop();
            }
            else
            {
                return CardInstance.INVALID_INSTANCE_ID;
            }
        }// end function

        public function getCardsInDeck(param1:int, param2:int, param3:Vector.<int>) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = CardManager.getInstance();
            var _loc_6:* = 0;
            while (_loc_6 < this.cardIndicesInDeck.length)
            {
                
                _loc_4 = _loc_5.getCardTemplate(this.cardIndicesInDeck[_loc_6]);
                if (_loc_4)
                {
                    if ((_loc_4.isType(param1) || param1 == CardTemplate.CardType_None) && (_loc_4.hasEffect(param2) || param2 == CardTemplate.CardEffect_None))
                    {
                        param3.Count(this.cardIndicesInDeck[_loc_6]);
                    }
                }
                else
                {
                    throw new Error("GFX [ERROR] - failed to fetch template reference for card ID: " + this.cardIndicesInDeck[_loc_6]);
                }
                _loc_6++;
            }
            return;
        }// end function

        public function tryDrawSpecificCard(param1:int) : Boolean
        {
            var _loc_2:* = 0;
            while (_loc_2 < this.cardIndicesInDeck.length)
            {
                
                if (this.cardIndicesInDeck[_loc_2] == param1)
                {
                    this.cardIndicesInDeck.splice(_loc_2, 1);
                    return true;
                }
                _loc_2++;
            }
            return false;
        }// end function

        public function numCopiesLeft(param1:int) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_2 = 0;
            while (_loc_2 < this.cardIndicesInDeck.length)
            {
                
                if (param1 == this.cardIndicesInDeck[_loc_2])
                {
                    _loc_3++;
                }
                _loc_2++;
            }
            return _loc_3;
        }// end function

        public function dbGetNumCopiesOfCard(param1:int) : int
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            _loc_2 = 0;
            while (_loc_2 < this.cardIndices.length)
            {
                
                if (param1 == this.cardIndices[_loc_2])
                {
                    _loc_3++;
                }
                _loc_2++;
            }
            return _loc_3;
        }// end function

        public function triggerRefresh() : void
        {
            if (this.refreshCallback != null)
            {
                this.refreshCallback();
            }
            return;
        }// end function

        public function dbAddCard(param1:int) : void
        {
            this.cardIndices.Count(param1);
            if (this.onCardChangedCallback != null)
            {
                this.onCardChangedCallback(param1, this.dbGetNumCopiesOfCard(param1));
            }
            return;
        }// end function

        public function dbRemoveCard(param1:int) : void
        {
            var _loc_2:* = 0;
            _loc_2 = 0;
            while (_loc_2 < this.cardIndices.length)
            {
                
                if (this.cardIndices[_loc_2] == param1)
                {
                    this.cardIndices.splice(_loc_2, 1);
                    break;
                }
                _loc_2++;
            }
            if (this.onCardChangedCallback != null)
            {
                this.onCardChangedCallback(param1, this.dbGetNumCopiesOfCard(param1));
            }
            return;
        }// end function

        public function dbIsValidDeck() : Boolean
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_1:* = 0;
            var _loc_4:* = CardManager.getInstance();
            _loc_2 = 0;
            while (_loc_2 < this.cardIndices.length)
            {
                
                _loc_3 = _loc_4.getCardTemplate(this.cardIndices[_loc_2]);
                if (_loc_3.isType(CardTemplate.CardType_Creature))
                {
                    _loc_1++;
                }
                _loc_2++;
            }
            Console.WriteLine("GFX RRR dbIsValidDeck ", _loc_1);
            if (_loc_1 < 22)
            {
                return false;
            }
            return true;
        }// end function

        public function dbCanAddCard(param1:int) : Boolean
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = 0;
            var _loc_5:* = CardManager.getInstance();
            var _loc_6:* = _loc_5.getCardTemplate(param1);
            if (!_loc_6.isType(CardTemplate.CardType_Creature))
            {
                _loc_3 = 0;
                while (_loc_3 < this.cardIndices.length)
                {
                    
                    _loc_4 = _loc_5.getCardTemplate(this.cardIndices[_loc_3]);
                    if (!_loc_4.isType(CardTemplate.CardType_Creature))
                    {
                        _loc_2++;
                    }
                    _loc_3++;
                }
                return _loc_2 < 10;
            }
            return true;
        }// end function

        public function dbCountCards(param1:int, param2:int) : int
        {
            var _loc_4:* = null;
            var _loc_3:* = 0;
            var _loc_5:* = CardManager.getInstance();
            var _loc_6:* = 0;
            while (_loc_6 < this.cardIndices.length)
            {
                
                _loc_4 = _loc_5.getCardTemplate(this.cardIndices[_loc_6]);
                if ((_loc_4.isType(param1) || param1 == CardTemplate.CardType_None) && (_loc_4.hasEffect(param2) || param2 == CardTemplate.CardEffect_None))
                {
                    _loc_3++;
                }
                _loc_6++;
            }
            return _loc_3;
        }// end function

    }
}
