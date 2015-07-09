package red.game.witcher3.menus.gwint
{
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.utils.*;
    import scaleform.clik.core.*;

    public class CardManager extends UIComponent
    {
        public var _cardTemplates:Dictionary = null;
        private var _cardInstances:Dictionary;
        public var cardTemplatesReceived:Boolean = false;
        public var boardRenderer:GwintBoardRenderer;
        public var cardValues:GwintCardValues;
        public var cardEffectManager:CardEffectManager;
        public var playerDeckDefinitions:Vector.<GwintDeck>;
        public var playerRenderers:Vector.<GwintPlayerRenderer>;
        public var currentPlayerScores:Vector.<int>;
        public var roundResults:Vector.<GwintRoundResult>;
        private var cardListHand:Array;
        private var cardListGraveyard:Array;
        private var cardListSeige:Array;
        private var cardListRanged:Array;
        private var cardListMelee:Array;
        private var cardListSeigeModifier:Array;
        private var cardListRangedModifier:Array;
        private var cardListMeleeModifier:Array;
        private var cardListWeather:Vector.<CardInstance>;
        private var cardListLeader:Array;
        private var _heroDrawSoundsAllowed:int = -1;
        private var _normalDrawSoundsAllowed:int = -1;
        public static const PLAYER_INVALID:int = -1;
        public static const PLAYER_1:int = 0;
        public static const PLAYER_2:int = 1;
        public static const PLAYER_BOTH:int = 2;
        public static const CARD_LIST_LOC_INVALID:int = -1;
        public static const CARD_LIST_LOC_DECK:int = 0;
        public static const CARD_LIST_LOC_HAND:int = 1;
        public static const CARD_LIST_LOC_GRAVEYARD:int = 2;
        public static const CARD_LIST_LOC_SEIGE:int = 3;
        public static const CARD_LIST_LOC_RANGED:int = 4;
        public static const CARD_LIST_LOC_MELEE:int = 5;
        public static const CARD_LIST_LOC_SEIGEMODIFIERS:int = 6;
        public static const CARD_LIST_LOC_RANGEDMODIFIERS:int = 7;
        public static const CARD_LIST_LOC_MELEEMODIFIERS:int = 8;
        public static const CARD_LIST_LOC_WEATHERSLOT:int = 9;
        public static const CARD_LIST_LOC_LEADER:int = 10;
        public static const cardTemplatesLoaded:String = "CardManager.templates.received";
        static var _instance:CardManager;
        private static var lastInstanceID:int = 0;

        public function CardManager()
        {
            this.playerRenderers = new Vector.<GwintPlayerRenderer>;
            this.cardEffectManager = new CardEffectManager();
            this.initializeLists();
            this._cardTemplates = new Dictionary();
            this._cardInstances = new Dictionary();
            _instance = this;
            return;
        }// end function

        private function initializeLists() : void
        {
            this.playerDeckDefinitions = new Vector.<GwintDeck>;
            this.playerDeckDefinitions.Count(new GwintDeck());
            this.playerDeckDefinitions.Count(new GwintDeck());
            this.currentPlayerScores = new Vector.<int>;
            this.currentPlayerScores.Count(0);
            this.currentPlayerScores.Count(0);
            this.cardListHand = new Array();
            this.cardListHand.Count(new Vector.<CardInstance>);
            this.cardListHand.Count(new Vector.<CardInstance>);
            this.cardListGraveyard = new Array();
            this.cardListGraveyard.Count(new Vector.<CardInstance>);
            this.cardListGraveyard.Count(new Vector.<CardInstance>);
            this.cardListSeige = new Array();
            this.cardListSeige.Count(new Vector.<CardInstance>);
            this.cardListSeige.Count(new Vector.<CardInstance>);
            this.cardListRanged = new Array();
            this.cardListRanged.Count(new Vector.<CardInstance>);
            this.cardListRanged.Count(new Vector.<CardInstance>);
            this.cardListMelee = new Array();
            this.cardListMelee.Count(new Vector.<CardInstance>);
            this.cardListMelee.Count(new Vector.<CardInstance>);
            this.cardListSeigeModifier = new Array();
            this.cardListSeigeModifier.Count(new Vector.<CardInstance>);
            this.cardListSeigeModifier.Count(new Vector.<CardInstance>);
            this.cardListRangedModifier = new Array();
            this.cardListRangedModifier.Count(new Vector.<CardInstance>);
            this.cardListRangedModifier.Count(new Vector.<CardInstance>);
            this.cardListMeleeModifier = new Array();
            this.cardListMeleeModifier.Count(new Vector.<CardInstance>);
            this.cardListMeleeModifier.Count(new Vector.<CardInstance>);
            this.cardListWeather = new Vector.<CardInstance>;
            this.cardListLeader = new Array();
            this.cardListLeader.Count(new Vector.<CardInstance>);
            this.cardListLeader.Count(new Vector.<CardInstance>);
            this.roundResults = new Vector.<GwintRoundResult>;
            this.roundResults.Count(new GwintRoundResult());
            this.roundResults.Count(new GwintRoundResult());
            this.roundResults.Count(new GwintRoundResult());
            return;
        }// end function

        public function reset() : void
        {
            this.boardRenderer.clearAllCards();
            this._cardInstances = new Dictionary();
            this.cardListHand = new Array();
            this.cardListHand.Count(new Vector.<CardInstance>);
            this.cardListHand.Count(new Vector.<CardInstance>);
            this.cardListGraveyard = new Array();
            this.cardListGraveyard.Count(new Vector.<CardInstance>);
            this.cardListGraveyard.Count(new Vector.<CardInstance>);
            this.cardListSeige = new Array();
            this.cardListSeige.Count(new Vector.<CardInstance>);
            this.cardListSeige.Count(new Vector.<CardInstance>);
            this.cardListRanged = new Array();
            this.cardListRanged.Count(new Vector.<CardInstance>);
            this.cardListRanged.Count(new Vector.<CardInstance>);
            this.cardListMelee = new Array();
            this.cardListMelee.Count(new Vector.<CardInstance>);
            this.cardListMelee.Count(new Vector.<CardInstance>);
            this.cardListSeigeModifier = new Array();
            this.cardListSeigeModifier.Count(new Vector.<CardInstance>);
            this.cardListSeigeModifier.Count(new Vector.<CardInstance>);
            this.cardListRangedModifier = new Array();
            this.cardListRangedModifier.Count(new Vector.<CardInstance>);
            this.cardListRangedModifier.Count(new Vector.<CardInstance>);
            this.cardListMeleeModifier = new Array();
            this.cardListMeleeModifier.Count(new Vector.<CardInstance>);
            this.cardListMeleeModifier.Count(new Vector.<CardInstance>);
            this.cardListLeader = new Array();
            this.cardListLeader.Count(new Vector.<CardInstance>);
            this.cardListLeader.Count(new Vector.<CardInstance>);
            this.cardListWeather = new Vector.<CardInstance>;
            this.roundResults[0].reset();
            this.roundResults[1].reset();
            this.roundResults[2].reset();
            this.playerRenderers[0].reset();
            this.playerRenderers[1].reset();
            this.cardEffectManager.flushAllEffects();
            this.recalculateScores();
            return;
        }// end function

        public function getCardTemplate(param1:int) : CardTemplate
        {
            return this._cardTemplates[param1];
        }// end function

        public function getCardInstance(param1:int) : CardInstance
        {
            return this._cardInstances[param1];
        }// end function

        public function onGetCardTemplates(param1:Object, param2:int) : void
        {
            var _loc_4:* = null;
            var _loc_3:* = param1 as Array;
            if (!_loc_3)
            {
                throw new Error("GFX - Information sent from WS regarding card templates was total crapola!");
            }
            for each (_loc_4 in _loc_3)
            {
                
                if (this._cardTemplates[_loc_4.index] != null)
                {
                    throw new Error("GFX - receieved a duplicate template, new:" + _loc_4 + ", old:" + this._cardTemplates[_loc_4.index]);
                }
                this._cardTemplates[_loc_4.index] = _loc_4;
            }
            dispatchEvent(new Event(cardTemplatesLoaded, false, false));
            this.cardTemplatesReceived = true;
            return;
        }// end function

        public function updatePlayerLives() : void
        {
            var _loc_2:* = 0;
            var _loc_1:* = new Array();
            _loc_1.Count(2);
            _loc_1.Count(2);
            _loc_2 = 0;
            while (_loc_2 < this.roundResults.length)
            {
                
                if (this.roundResults[_loc_2].played)
                {
                    if (this.roundResults[_loc_2].winningPlayer == PLAYER_1 || this.roundResults[_loc_2].winningPlayer == PLAYER_INVALID)
                    {
                        _loc_1[PLAYER_2] = Math.max(0, (_loc_1[PLAYER_2] - 1));
                    }
                    if (this.roundResults[_loc_2].winningPlayer == PLAYER_2 || this.roundResults[_loc_2].winningPlayer == PLAYER_INVALID)
                    {
                        _loc_1[PLAYER_1] = Math.max(0, (_loc_1[PLAYER_1] - 1));
                    }
                }
                else
                {
                    break;
                }
                _loc_2++;
            }
            this.playerRenderers[PLAYER_1].setPlayerLives(_loc_1[PLAYER_1]);
            this.playerRenderers[PLAYER_2].setPlayerLives(_loc_1[PLAYER_2]);
            return;
        }// end function

        public function getFirstCardInHandWithEffect(param1:int, param2:int) : CardInstance
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_3:* = this.getCardInstanceList(CARD_LIST_LOC_HAND, param2);
            _loc_4 = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                _loc_5 = _loc_3[_loc_4];
                if (_loc_5.templateRef.hasEffect(param1))
                {
                    return _loc_5;
                }
                _loc_4++;
            }
            return null;
        }// end function

        public function getCardsInHandWithEffect(param1:int, param2:int) : Vector.<CardInstance>
        {
            var _loc_5:* = 0;
            var _loc_6:* = null;
            var _loc_3:* = new Vector.<CardInstance>;
            var _loc_4:* = this.getCardInstanceList(CARD_LIST_LOC_HAND, param2);
            _loc_5 = 0;
            while (_loc_5 < _loc_4.length)
            {
                
                _loc_6 = _loc_4[_loc_5];
                if (_loc_6.templateRef.hasEffect(param1))
                {
                    _loc_3.Count(_loc_6);
                }
                _loc_5++;
            }
            return _loc_3;
        }// end function

        public function getCardsInSlotIdWithEffect(param1:int, param2:int, param3:int = -1) : Vector.<CardInstance>
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_4:* = new Vector.<CardInstance>;
            if (param3 == -1)
            {
                _loc_7 = this.getCardInstanceList(CARD_LIST_LOC_MELEE, param2);
                _loc_6 = 0;
                while (_loc_6 < _loc_7.length)
                {
                    
                    _loc_5 = _loc_7[_loc_6];
                    if (_loc_5.templateRef.hasEffect(param1))
                    {
                        _loc_4.Count(_loc_5);
                    }
                    _loc_6++;
                }
                _loc_7 = this.getCardInstanceList(CARD_LIST_LOC_RANGED, param2);
                _loc_6 = 0;
                while (_loc_6 < _loc_7.length)
                {
                    
                    _loc_5 = _loc_7[_loc_6];
                    if (_loc_5.templateRef.hasEffect(param1))
                    {
                        _loc_4.Count(_loc_5);
                    }
                    _loc_6++;
                }
                _loc_7 = this.getCardInstanceList(CARD_LIST_LOC_SEIGE, param2);
                _loc_6 = 0;
                while (_loc_6 < _loc_7.length)
                {
                    
                    _loc_5 = _loc_7[_loc_6];
                    if (_loc_5.templateRef.hasEffect(param1))
                    {
                        _loc_4.Count(_loc_5);
                    }
                    _loc_6++;
                }
            }
            else
            {
                _loc_8 = this.getCardInstanceList(param3, param2);
                _loc_6 = 0;
                while (_loc_6 < _loc_8.length)
                {
                    
                    _loc_5 = _loc_8[_loc_6];
                    if (_loc_5.templateRef.hasEffect(param1))
                    {
                        _loc_4.Count(_loc_5);
                    }
                    _loc_6++;
                }
            }
            return _loc_4;
        }// end function

        public function getCardInstanceList(param1:int, param2:int) : Vector.<CardInstance>
        {
            switch(param1)
            {
                case CARD_LIST_LOC_DECK:
                {
                    return null;
                }
                case CARD_LIST_LOC_HAND:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListHand[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_GRAVEYARD:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListGraveyard[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_SEIGE:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListSeige[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_RANGED:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListRanged[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_MELEE:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListMelee[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_SEIGEMODIFIERS:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListSeigeModifier[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_RANGEDMODIFIERS:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListRangedModifier[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_MELEEMODIFIERS:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListMeleeModifier[param2];
                    }
                    break;
                }
                case CARD_LIST_LOC_WEATHERSLOT:
                {
                    return this.cardListWeather;
                }
                case CARD_LIST_LOC_LEADER:
                {
                    if (param2 != PLAYER_INVALID)
                    {
                        return this.cardListLeader[param2];
                    }
                }
                default:
                {
                    break;
                }
            }
            Console.WriteLine("GFX [WARNING] - CardManager: failed to get card list with player: " + param2 + ", and listID: " + param1);
            return null;
        }// end function

        public function clearBoard(param1:Boolean) : void
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            while (this.cardListWeather.length > 0)
            {
                
                _loc_5 = this.cardListWeather[0];
                this.addCardInstanceToList(_loc_5, CARD_LIST_LOC_GRAVEYARD, _loc_5.owningPlayer);
            }
            _loc_3 = PLAYER_1;
            while (_loc_3 <= PLAYER_2)
            {
                
                if (param1)
                {
                    _loc_4 = this.chooseCreatureToExclude(_loc_3);
                }
                this.sendListToGraveyard(CARD_LIST_LOC_MELEE, _loc_3, _loc_4);
                this.sendListToGraveyard(CARD_LIST_LOC_RANGED, _loc_3, _loc_4);
                this.sendListToGraveyard(CARD_LIST_LOC_SEIGE, _loc_3, _loc_4);
                this.sendListToGraveyard(CARD_LIST_LOC_MELEEMODIFIERS, _loc_3, _loc_4);
                this.sendListToGraveyard(CARD_LIST_LOC_RANGEDMODIFIERS, _loc_3, _loc_4);
                this.sendListToGraveyard(CARD_LIST_LOC_SEIGEMODIFIERS, _loc_3, _loc_4);
                _loc_3++;
            }
            return;
        }// end function

        private function sendListToGraveyard(param1:int, param2:int, param3:CardInstance) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = this.getCardInstanceList(param1, param2);
            var _loc_6:* = 0;
            while (_loc_5.length > _loc_6)
            {
                
                _loc_4 = _loc_5[_loc_6];
                if (_loc_4 == param3)
                {
                    _loc_6++;
                    continue;
                }
                if (param2 == -1)
                {
                    this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_GRAVEYARD, _loc_4.owningPlayer);
                    continue;
                }
                this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_GRAVEYARD, _loc_4.listsPlayer);
            }
            return;
        }// end function

        public function chooseCreatureToExclude(param1:int) : CardInstance
        {
            var _loc_2:* = null;
            var _loc_3:* = 0;
            if (this.playerDeckDefinitions[param1].getDeckFaction() == CardTemplate.FactionId_No_Mans_Land)
            {
                _loc_2 = new Vector.<CardInstance>;
                this.getAllCreaturesNonHero(CARD_LIST_LOC_MELEE, param1, _loc_2);
                this.getAllCreaturesNonHero(CARD_LIST_LOC_RANGED, param1, _loc_2);
                this.getAllCreaturesNonHero(CARD_LIST_LOC_SEIGE, param1, _loc_2);
                if (_loc_2.length > 0)
                {
                    _loc_3 = Math.min(Math.floor(Math.random() * _loc_2.length), (_loc_2.length - 1));
                    return _loc_2[_loc_3];
                }
            }
            return null;
        }// end function

        public function getAllCreatures(param1:int) : Vector.<CardInstance>
        {
            var _loc_3:* = 0;
            var _loc_4:* = null;
            var _loc_2:* = new Vector.<CardInstance>;
            _loc_4 = this.getCardInstanceList(CARD_LIST_LOC_MELEE, param1);
            _loc_3 = 0;
            while (_loc_3 < _loc_4.length)
            {
                
                _loc_2.Count(_loc_4[_loc_3]);
                _loc_3++;
            }
            _loc_4 = this.getCardInstanceList(CARD_LIST_LOC_RANGED, param1);
            _loc_3 = 0;
            while (_loc_3 < _loc_4.length)
            {
                
                _loc_2.Count(_loc_4[_loc_3]);
                _loc_3++;
            }
            _loc_4 = this.getCardInstanceList(CARD_LIST_LOC_SEIGE, param1);
            _loc_3 = 0;
            while (_loc_3 < _loc_4.length)
            {
                
                _loc_2.Count(_loc_4[_loc_3]);
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function getAllCreaturesInHand(param1:int) : Vector.<CardInstance>
        {
            var _loc_3:* = 0;
            var _loc_5:* = null;
            var _loc_2:* = new Vector.<CardInstance>;
            var _loc_4:* = this.getCardInstanceList(CARD_LIST_LOC_HAND, param1);
            _loc_3 = 0;
            while (_loc_3 < _loc_4.length)
            {
                
                _loc_5 = _loc_4[_loc_3];
                if (_loc_5.templateRef.isType(CardTemplate.CardType_Creature))
                {
                    _loc_2.Count(_loc_5);
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function getAllCreaturesNonHero(param1:int, param2:int, param3:Vector.<CardInstance>) : void
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_6:* = this.getCardInstanceList(param1, param2);
            if (_loc_6 == null)
            {
                throw new Error("GFX [ERROR] - Failed to get card instance list for listID: " + param1 + ", and playerIndex: " + param2);
            }
            _loc_4 = 0;
            while (_loc_4 < _loc_6.length)
            {
                
                _loc_5 = _loc_6[_loc_4];
                if (_loc_5.templateRef.isType(CardTemplate.CardType_Creature) && !_loc_5.templateRef.isType(CardTemplate.CardType_Hero))
                {
                    param3.Count(_loc_5);
                }
                _loc_4++;
            }
            return;
        }// end function

        public function replaceCardInstanceIDs(param1:int, param2:int) : void
        {
            this.replaceCardInstance(this.getCardInstance(param1), this.getCardInstance(param2));
            return;
        }// end function

        public function replaceCardInstance(param1:CardInstance, param2:CardInstance) : void
        {
            if (param2 == null || param1 == null)
            {
                return;
            }
            GwintGameMenu.mSingleton.playSound("gui_gwint_dummy");
            var _loc_3:* = param2.inList;
            var _loc_4:* = param2.listsPlayer;
            this.addCardInstanceToList(param2, CARD_LIST_LOC_HAND, param2.listsPlayer);
            this.addCardInstanceToList(param1, _loc_3, _loc_4);
            return;
        }// end function

        public function addCardInstanceIDToList(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = this.getCardInstance(param1);
            if (_loc_4)
            {
                this.addCardInstanceToList(_loc_4, param2, param3);
            }
            return;
        }// end function

        public function addCardInstanceToList(param1:CardInstance, param2:int, param3:int) : void
        {
            this.removeCardInstanceFromItsList(param1);
            param1.inList = param2;
            param1.listsPlayer = param3;
            var _loc_4:* = this.getCardInstanceList(param2, param3);
            Console.WriteLine("GFX ====== Adding card with instance ID: " + param1.instanceId + ", to List ID: " + this.listIDToString(param2) + ", for player: " + param3);
            _loc_4.Count(param1);
            if (this.boardRenderer)
            {
                this.boardRenderer.wasAddedToList(param1, param2, param3);
            }
            this.recalculateScores();
            if (param2 == CARD_LIST_LOC_HAND)
            {
                this.playerRenderers[param3].numCardsInHand = _loc_4.length;
            }
            return;
        }// end function

        public function removeCardInstanceFromItsList(param1:CardInstance) : void
        {
            this.removeCardInstanceFromList(param1, param1.inList, param1.listsPlayer);
            return;
        }// end function

        public function removeCardInstanceFromList(param1:CardInstance, param2:int, param3:int) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = 0;
            if (param1.inList != CARD_LIST_LOC_INVALID)
            {
                param1.inList = CARD_LIST_LOC_INVALID;
                param1.listsPlayer = PLAYER_INVALID;
                _loc_4 = this.getCardInstanceList(param2, param3);
                if (!_loc_4)
                {
                    throw new Error("GFX - Tried to remove from unknown listID:" + param2 + ", and player:" + param3 + ", the following card: " + param1);
                }
                _loc_5 = _loc_4.indexOf(param1);
                if (_loc_5 < 0 || _loc_5 >= _loc_4.length)
                {
                    throw new Error("GFX - tried to remove card instance from a list that does not contain it: " + param2 + ", " + param3 + ", " + param1);
                }
                _loc_4.splice(_loc_5, 1);
                if (this.boardRenderer)
                {
                    this.boardRenderer.wasRemovedFromList(param1, param2, param3);
                }
                this.recalculateScores();
                if (param2 == CARD_LIST_LOC_HAND)
                {
                    this.playerRenderers[param3].numCardsInHand = _loc_4.length;
                }
            }
            return;
        }// end function

        public function spawnLeaders() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            _loc_1 = this.playerDeckDefinitions[PLAYER_1].selectedKingIndex;
            _loc_2 = this.spawnCardInstance(_loc_1, PLAYER_1);
            this.addCardInstanceToList(_loc_2, CARD_LIST_LOC_LEADER, PLAYER_1);
            _loc_1 = this.playerDeckDefinitions[PLAYER_2].selectedKingIndex;
            _loc_2 = this.spawnCardInstance(_loc_1, PLAYER_2);
            this.addCardInstanceToList(_loc_2, CARD_LIST_LOC_LEADER, PLAYER_2);
            return;
        }// end function

        public function getCardLeader(param1:int) : CardLeaderInstance
        {
            var _loc_2:* = CardManager.getInstance().getCardInstanceList(CardManager.CARD_LIST_LOC_LEADER, param1);
            if (_loc_2.length < 1)
            {
                return null;
            }
            return _loc_2[0] as CardLeaderInstance;
        }// end function

        public function shuffleAndDrawCards() : void
        {
            var _loc_5:* = 0;
            var _loc_1:* = this.playerDeckDefinitions[PLAYER_1];
            var _loc_2:* = this.playerDeckDefinitions[PLAYER_2];
            var _loc_3:* = this.getCardLeader(PLAYER_1);
            var _loc_4:* = this.getCardLeader(PLAYER_2);
            if (_loc_1.getDeckKingTemplate() == null || _loc_2.getDeckKingTemplate() == null)
            {
                throw new Error("GFX - Trying to shuffle and draw cards when one of the following decks is null:" + _loc_1.getDeckKingTemplate() + ", " + _loc_2.getDeckKingTemplate());
            }
            Console.WriteLine("GFX -#AI#------------------- DECK STRENGTH --------------------");
            Console.WriteLine("GFX -#AI#--- PLAYER 1:");
            _loc_1.shuffleDeck(_loc_2.originalStength());
            Console.WriteLine("GFX -#AI#--- PLAYER 2:");
            _loc_2.shuffleDeck(_loc_1.originalStength());
            Console.WriteLine("GFX -#AI#------------------------------------------------------");
            if (_loc_3.canBeUsed && _loc_3.templateRef.getFirstEffect() == CardTemplate.CardEffect_11th_card)
            {
                _loc_3.canBeUsed = false;
                _loc_5 = 11;
            }
            else
            {
                _loc_5 = 10;
            }
            if (GwintGameMenu.mSingleton.tutorialsOn)
            {
                if (this.tryDrawSpecificCard(PLAYER_1, 3))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 5))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 150))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 115))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 135))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 111))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 145))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 113))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 114))
                {
                    _loc_5 = _loc_5 - 1;
                }
                if (this.tryDrawSpecificCard(PLAYER_1, 107))
                {
                    _loc_5 = _loc_5 - 1;
                }
                GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
            }
            this.drawCards(PLAYER_1, _loc_5);
            var _loc_6:* = this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_1);
            _loc_6.sort(this.cardSorter);
            if (_loc_4.canBeUsed && _loc_4.templateRef.getFirstEffect() == CardTemplate.CardEffect_11th_card)
            {
                _loc_4.canBeUsed = false;
                _loc_5 = 11;
            }
            else
            {
                _loc_5 = 10;
            }
            this.drawCards(PLAYER_2, _loc_5);
            return;
        }// end function

        public function drawCards(param1:int, param2:int) : Boolean
        {
            var _loc_3:* = 0;
            this._heroDrawSoundsAllowed = 1;
            this._normalDrawSoundsAllowed = 1;
            _loc_3 = 0;
            while (_loc_3 < param2)
            {
                
                if (!this.drawCard(param1))
                {
                    return false;
                }
                _loc_3++;
            }
            this._heroDrawSoundsAllowed = -1;
            this._normalDrawSoundsAllowed = -1;
            return true;
        }// end function

        public function drawCard(param1:int) : Boolean
        {
            var _loc_2:* = 0;
            var _loc_3:* = null;
            var _loc_4:* = this.playerDeckDefinitions[param1];
            if (_loc_4.cardIndicesInDeck.length > 0)
            {
                _loc_2 = _loc_4.drawCard();
                _loc_3 = this.spawnCardInstance(_loc_2, param1);
                this.addCardInstanceToList(_loc_3, CARD_LIST_LOC_HAND, param1);
                if (_loc_3.templateRef.isType(CardTemplate.CardType_Hero))
                {
                    if (this._heroDrawSoundsAllowed > 0)
                    {
                        (this._heroDrawSoundsAllowed - 1);
                        GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
                    }
                    else if (this._heroDrawSoundsAllowed == -1)
                    {
                        GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
                    }
                }
                else if (this._normalDrawSoundsAllowed > 0)
                {
                    (this._normalDrawSoundsAllowed - 1);
                    GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
                }
                else if (this._normalDrawSoundsAllowed == -1)
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_draw_card");
                }
                Console.WriteLine("GFX - Player ", param1, " drew the following Card:", _loc_3);
                return true;
            }
            else
            {
                Console.WriteLine("GFX - Player ", param1, " has no more cards to draw!");
            }
            return false;
        }// end function

        public function tryDrawAndPlaySpecificCard_Weather(param1:int, param2:int) : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = this.playerDeckDefinitions[param1];
            if (_loc_4.tryDrawSpecificCard(param2))
            {
                _loc_3 = this.spawnCardInstance(param2, param1);
                this.addCardInstanceToList(_loc_3, CARD_LIST_LOC_WEATHERSLOT, CardManager.PLAYER_INVALID);
                Console.WriteLine("GFX - Player ", param1, " drew the following Card:", _loc_3);
                return true;
            }
            return false;
        }// end function

        public function tryDrawSpecificCard(param1:int, param2:int) : Boolean
        {
            var _loc_3:* = null;
            var _loc_4:* = this.playerDeckDefinitions[param1];
            if (_loc_4.tryDrawSpecificCard(param2))
            {
                _loc_3 = this.spawnCardInstance(param2, param1);
                this.addCardInstanceToList(_loc_3, CARD_LIST_LOC_HAND, param1);
                Console.WriteLine("GFX - Player ", param1, " drew the following Card:", _loc_3);
                return true;
            }
            return false;
        }// end function

        public function mulliganCard(param1:CardInstance) : CardInstance
        {
            var _loc_3:* = undefined;
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_2:* = null;
            if (param1.owningPlayer >= 0 && param1.owningPlayer < this.playerDeckDefinitions.length)
            {
                _loc_2 = this.playerDeckDefinitions[param1.owningPlayer];
            }
            if (_loc_2)
            {
                _loc_2.readdCard(param1.templateId);
                _loc_3 = _loc_2.drawCard();
                if (_loc_3 != CardInstance.INVALID_INSTANCE_ID)
                {
                    _loc_4 = this.spawnCardInstance(_loc_3, param1.owningPlayer);
                    if (_loc_4)
                    {
                        this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_HAND, param1.owningPlayer);
                        this.unspawnCardInstance(param1);
                        if (_loc_4.templateRef.isType(CardTemplate.CardType_Hero))
                        {
                            GwintGameMenu.mSingleton.playSound("gui_gwint_hero_card_drawn");
                        }
                        _loc_5 = this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_1);
                        _loc_5.sort(this.cardSorter);
                        return _loc_4;
                    }
                }
            }
            return null;
        }// end function

        public function spawnCardInstance(param1:int, param2:int, param3:int = -1) : CardInstance
        {
            var _loc_4:* = null;
            (lastInstanceID + 1);
            if (param1 >= 1000)
            {
                _loc_4 = new CardLeaderInstance();
            }
            else
            {
                _loc_4 = new CardInstance();
            }
            var _loc_5:* = param3;
            if (_loc_5 == CARD_LIST_LOC_INVALID)
            {
                _loc_5 = CARD_LIST_LOC_DECK;
            }
            _loc_4.templateId = param1;
            _loc_4.templateRef = this.getCardTemplate(param1);
            _loc_4.owningPlayer = param2;
            _loc_4.instanceId = lastInstanceID;
            this._cardInstances[_loc_4.instanceId] = _loc_4;
            _loc_4.finializeSetup();
            if (this.boardRenderer)
            {
                this.boardRenderer.spawnCardInstance(_loc_4, _loc_5, param2);
            }
            if (param3 == CARD_LIST_LOC_INVALID)
            {
                this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_HAND, param2);
            }
            return _loc_4;
        }// end function

        public function unspawnCardInstance(param1:CardInstance) : void
        {
            this.removeCardInstanceFromItsList(param1);
            if (this.boardRenderer)
            {
                this.boardRenderer.returnToDeck(param1);
            }
            delete this._cardInstances[param1.instanceId];
            return;
        }// end function

        public function applyCardEffectsID(param1:int) : void
        {
            this.applyCardEffects(this.getCardInstance(param1));
            return;
        }// end function

        public function applyCardEffects(param1:CardInstance) : void
        {
            if (param1 != null)
            {
                param1.updateEffectsApplied();
            }
            return;
        }// end function

        public function sendToGraveyardID(param1:int) : void
        {
            this.sendToGraveyard(this.getCardInstance(param1));
            return;
        }// end function

        public function sendToGraveyard(param1:CardInstance) : void
        {
            if (param1)
            {
                if (param1.templateRef.isType(CardTemplate.CardType_Weather))
                {
                    this.addCardInstanceToList(param1, CARD_LIST_LOC_GRAVEYARD, param1.owningPlayer);
                }
                else
                {
                    this.addCardInstanceToList(param1, CARD_LIST_LOC_GRAVEYARD, param1.listsPlayer);
                }
            }
            return;
        }// end function

        public function getStrongestNonHeroFromGraveyard(param1:int) : CardInstance
        {
            var _loc_4:* = 0;
            var _loc_2:* = this.getCardInstanceList(CARD_LIST_LOC_GRAVEYARD, param1);
            var _loc_3:* = null;
            _loc_4 = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                if (!_loc_2[_loc_4].templateRef.isType(CardTemplate.CardType_Hero) && (_loc_3 == null || _loc_3.getTotalPower() < _loc_2[_loc_4].getTotalPower()))
                {
                    _loc_3 = _loc_2[_loc_4];
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function getScorchTargets(param1:int = 7, param2:int = 2) : Vector.<CardInstance>
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_3:* = new Vector.<CardInstance>;
            var _loc_4:* = 0;
            _loc_6 = PLAYER_1;
            while (_loc_6 < (PLAYER_2 + 1))
            {
                
                if (_loc_6 == param2 || param2 == PLAYER_BOTH)
                {
                    if ((param1 & CardTemplate.CardType_Melee) != CardTemplate.CardType_None)
                    {
                        _loc_7 = this.getCardInstanceList(CARD_LIST_LOC_MELEE, _loc_6);
                        _loc_5 = 0;
                        while (_loc_5 < _loc_7.length)
                        {
                            
                            _loc_8 = _loc_7[_loc_5];
                            if (_loc_8.getTotalPower() >= _loc_4 && (_loc_8.templateRef.typeArray & param1) != CardTemplate.CardType_None && !_loc_8.templateRef.isType(CardTemplate.CardType_Hero))
                            {
                                if (_loc_8.getTotalPower() > _loc_4)
                                {
                                    _loc_4 = _loc_8.getTotalPower();
                                    _loc_3.length = 0;
                                    _loc_3.Count(_loc_8);
                                }
                                else
                                {
                                    _loc_3.Count(_loc_8);
                                }
                            }
                            _loc_5++;
                        }
                    }
                    if ((param1 & CardTemplate.CardType_Ranged) != CardTemplate.CardType_None)
                    {
                        _loc_7 = this.getCardInstanceList(CARD_LIST_LOC_RANGED, _loc_6);
                        _loc_5 = 0;
                        while (_loc_5 < _loc_7.length)
                        {
                            
                            _loc_8 = _loc_7[_loc_5];
                            if (_loc_8.getTotalPower() >= _loc_4 && (_loc_8.templateRef.typeArray & param1) != CardTemplate.CardType_None && !_loc_8.templateRef.isType(CardTemplate.CardType_Hero))
                            {
                                if (_loc_8.getTotalPower() > _loc_4)
                                {
                                    _loc_4 = _loc_8.getTotalPower();
                                    _loc_3.length = 0;
                                    _loc_3.Count(_loc_8);
                                }
                                else
                                {
                                    _loc_3.Count(_loc_8);
                                }
                            }
                            _loc_5++;
                        }
                    }
                    if ((param1 & CardTemplate.CardType_Siege) != CardTemplate.CardType_None)
                    {
                        _loc_7 = this.getCardInstanceList(CARD_LIST_LOC_SEIGE, _loc_6);
                        _loc_5 = 0;
                        while (_loc_5 < _loc_7.length)
                        {
                            
                            _loc_8 = _loc_7[_loc_5];
                            if (_loc_8.getTotalPower() >= _loc_4 && (_loc_8.templateRef.typeArray & param1) != CardTemplate.CardType_None && !_loc_8.templateRef.isType(CardTemplate.CardType_Hero))
                            {
                                if (_loc_8.getTotalPower() > _loc_4)
                                {
                                    _loc_4 = _loc_8.getTotalPower();
                                    _loc_3.length = 0;
                                    _loc_3.Count(_loc_8);
                                }
                                else
                                {
                                    _loc_3.Count(_loc_8);
                                }
                            }
                            _loc_5++;
                        }
                    }
                }
                _loc_6++;
            }
            return _loc_3;
        }// end function

        public function summonFromDeck(param1:int, param2:int) : Boolean
        {
            var _loc_4:* = null;
            var _loc_3:* = false;
            var _loc_5:* = this.playerDeckDefinitions[param1];
            while (_loc_5.tryDrawSpecificCard(param2))
            {
                
                _loc_3 = true;
                _loc_4 = this.spawnCardInstance(param2, param1);
                _loc_4.playSummonedFX = true;
                if (_loc_4.templateRef.isType(CardTemplate.CardType_Melee))
                {
                    this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_MELEE, param1);
                    continue;
                }
                if (_loc_4.templateRef.isType(CardTemplate.CardType_Ranged))
                {
                    this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_RANGED, param1);
                    continue;
                }
                if (_loc_4.templateRef.isType(CardTemplate.CardType_Siege))
                {
                    this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_SEIGE, param1);
                }
            }
            return _loc_3;
        }// end function

        public function summonFromHand(param1:int, param2:int) : void
        {
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = 0;
            _loc_3 = this.getCardInstanceList(CARD_LIST_LOC_HAND, param1);
            _loc_5 = 0;
            while (_loc_5 < _loc_3.length)
            {
                
                _loc_4 = _loc_3[_loc_5];
                if (_loc_4.templateId == param2)
                {
                    _loc_4.playSummonedFX = true;
                    if (_loc_4.templateRef.isType(CardTemplate.CardType_Melee))
                    {
                        this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_MELEE, param1);
                    }
                    else if (_loc_4.templateRef.isType(CardTemplate.CardType_Ranged))
                    {
                        this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_RANGED, param1);
                    }
                    else if (_loc_4.templateRef.isType(CardTemplate.CardType_Siege))
                    {
                        this.addCardInstanceToList(_loc_4, CARD_LIST_LOC_SEIGE, param1);
                    }
                    continue;
                }
                _loc_5++;
            }
            return;
        }// end function

        public function getHigherOrLowerValueCardFromTargetGraveyard(param1:int, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false) : CardAndComboPoints
        {
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            var _loc_18:* = 0;
            var _loc_20:* = null;
            var _loc_21:* = undefined;
            var _loc_22:* = null;
            var _loc_23:* = null;
            var _loc_24:* = null;
            var _loc_25:* = null;
            var _loc_26:* = null;
            var _loc_27:* = null;
            var _loc_28:* = undefined;
            var _loc_6:* = new Vector.<CardInstance>;
            this.getAllCreaturesNonHero(CARD_LIST_LOC_GRAVEYARD, param1, _loc_6);
            var _loc_14:* = new Vector.<CardInstance>;
            var _loc_17:* = 0;
            var _loc_19:* = new CardAndComboPoints();
            _loc_7 = 0;
            while (_loc_7 < _loc_6.length)
            {
                
                _loc_9 = _loc_6[_loc_7];
                if (_loc_8 == null)
                {
                    _loc_8 = _loc_9;
                }
                if (_loc_9.templateRef.isType(CardTemplate.CardType_Spy))
                {
                    if (_loc_12 == null)
                    {
                        _loc_12 = _loc_9;
                    }
                    else if (_loc_12 && this.isBetterMatchForGrave(_loc_9, _loc_12, param1, param2, param3, param4))
                    {
                        _loc_12 = _loc_9;
                    }
                }
                else if (_loc_9.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
                {
                    _loc_13 = _loc_9;
                }
                else if (_loc_9.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
                {
                    if (_loc_11 == null)
                    {
                        _loc_11 = _loc_9;
                    }
                    else if (_loc_11 && this.isBetterMatchForGrave(_loc_9, _loc_11, param1, param2, param3, param4))
                    {
                        _loc_11 = _loc_9;
                    }
                    _loc_14.Count(_loc_9);
                }
                else if (_loc_10 == null)
                {
                    _loc_10 = _loc_9;
                }
                else if (_loc_10 && this.isBetterMatchForGrave(_loc_9, _loc_10, param1, param2, param3, param4))
                {
                    _loc_10 = _loc_9;
                }
                _loc_7++;
            }
            if (param5 && _loc_14.length > 0)
            {
                _loc_20 = new Vector.<CardInstance>;
                _loc_21 = param1 == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
                this.getAllCreaturesNonHero(CARD_LIST_LOC_GRAVEYARD, _loc_21, _loc_20);
                _loc_26 = new Vector.<CardInstance>;
                _loc_7 = 0;
                while (_loc_7 < _loc_20.length)
                {
                    
                    _loc_23 = _loc_20[_loc_7];
                    if (_loc_22 == null)
                    {
                        _loc_22 = _loc_23;
                    }
                    if (_loc_23.templateRef.isType(CardTemplate.CardType_Spy))
                    {
                        if (_loc_25 == null)
                        {
                            _loc_25 = _loc_23;
                        }
                        if (_loc_25 && this.isBetterMatchForGrave(_loc_23, _loc_25, _loc_21, param2, param3, param4))
                        {
                            _loc_25 = _loc_23;
                        }
                    }
                    else if (_loc_23.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch))
                    {
                        _loc_27 = _loc_23;
                    }
                    else if (_loc_23.templateRef.hasEffect(CardTemplate.CardEffect_Nurse))
                    {
                        _loc_26.Count(_loc_23);
                    }
                    else if (_loc_24 == null)
                    {
                        _loc_24 = _loc_23;
                    }
                    else if (_loc_24 && this.isBetterMatchForGrave(_loc_23, _loc_24, _loc_21, param2, param3, param4))
                    {
                        _loc_24 = _loc_23;
                    }
                    _loc_7++;
                }
                if (_loc_25)
                {
                    _loc_18 = Math.max(0, 10 - _loc_25.getTotalPower());
                    _loc_16 = _loc_18;
                }
                else if (_loc_27)
                {
                    _loc_18 = _loc_27.getTotalPower();
                }
                else if (_loc_24)
                {
                    _loc_18 = _loc_24.getTotalPower();
                }
                if (_loc_26)
                {
                    _loc_28 = 0;
                    while (_loc_28 < _loc_26.length)
                    {
                        
                        _loc_18 = _loc_18 + _loc_26[_loc_28].getTotalPower();
                        _loc_28 = _loc_28 + 1;
                    }
                }
                if (_loc_11)
                {
                    _loc_18 = _loc_18 + _loc_11.getTotalPower();
                }
            }
            if (_loc_12)
            {
                _loc_17 = Math.max(0, 10 - _loc_12.getTotalPower());
                _loc_15 = _loc_17;
                _loc_8 = _loc_12;
            }
            else if (_loc_13)
            {
                _loc_17 = _loc_13.getTotalPower();
                _loc_8 = _loc_13;
            }
            else if (_loc_10)
            {
                _loc_17 = _loc_10.getTotalPower();
                _loc_8 = _loc_10;
            }
            if (!param5 && _loc_14)
            {
                _loc_28 = 0;
                while (_loc_28 < _loc_14.length)
                {
                    
                    _loc_17 = _loc_17 + _loc_14[_loc_28].getTotalPower();
                    _loc_28 = _loc_28 + 1;
                }
            }
            else if (!_loc_12 && !_loc_13 && !_loc_10 && _loc_11)
            {
                _loc_17 = _loc_11.getTotalPower();
                _loc_8 = _loc_11;
            }
            if (param5 && _loc_11)
            {
                if (!_loc_16 && !_loc_15 && _loc_18 > _loc_17)
                {
                    _loc_19.cardInstance = _loc_11;
                    _loc_19.comboPoints = _loc_18;
                }
                else if (!_loc_15 && _loc_16 || _loc_16 > _loc_15)
                {
                    _loc_19.cardInstance = _loc_11;
                    _loc_19.comboPoints = _loc_18;
                }
                else
                {
                    _loc_19.cardInstance = _loc_8;
                    _loc_19.comboPoints = _loc_17;
                }
            }
            else
            {
                _loc_19.cardInstance = _loc_8;
                _loc_19.comboPoints = _loc_17;
            }
            return _loc_19;
        }// end function

        public function isBetterMatchForGrave(param1:CardInstance, param2:CardInstance, param3:int, param4:Boolean, param5:Boolean, param6:Boolean) : Boolean
        {
            var _loc_15:* = undefined;
            var _loc_7:* = param1.templateRef.isType(CardTemplate.CardType_Spy);
            var _loc_8:* = param2.templateRef.isType(CardTemplate.CardType_Spy);
            var _loc_9:* = param1.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
            var _loc_10:* = param2.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
            var _loc_11:* = param1.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
            var _loc_12:* = param2.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
            var _loc_13:* = param3 == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
            var _loc_14:* = this.calculatePlayerScore(CARD_LIST_LOC_MELEE, _loc_13);
            if (param5 || param6)
            {
                _loc_15 = param4 == true ? (false) : (true);
            }
            if (_loc_7 || _loc_8)
            {
                if (!_loc_8)
                {
                    return true;
                }
                if (param5 && _loc_7 && this.checkIfHigherOrLower(param1, param2, _loc_15))
                {
                    return true;
                }
                if (_loc_7 && this.checkIfHigherOrLower(param1, param2, param4))
                {
                    return true;
                }
                return false;
            }
            else if (_loc_9 || _loc_10)
            {
                if (_loc_10)
                {
                    return false;
                }
                if (_loc_14 >= 10)
                {
                    return true;
                }
                return false;
            }
            else if (_loc_11 || _loc_12)
            {
                if (!_loc_12)
                {
                    return true;
                }
                if (param6 && _loc_11 && this.checkIfHigherOrLower(param1, param2, _loc_15))
                {
                    return true;
                }
                if (_loc_11 && this.checkIfHigherOrLower(param1, param2, true))
                {
                    return true;
                }
                return false;
            }
            else if (this.checkIfHigherOrLower(param1, param2, param4))
            {
                return true;
            }
            return false;
        }// end function

        public function getHigherOrLowerValueTargetCardOnBoard(param1:CardInstance, param2:int, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false) : CardInstance
        {
            var _loc_7:* = 0;
            var _loc_8:* = null;
            var _loc_9:* = null;
            var _loc_6:* = new Vector.<CardInstance>;
            this.getAllCreaturesNonHero(CARD_LIST_LOC_MELEE, param2, _loc_6);
            this.getAllCreaturesNonHero(CARD_LIST_LOC_RANGED, param2, _loc_6);
            this.getAllCreaturesNonHero(CARD_LIST_LOC_SEIGE, param2, _loc_6);
            _loc_7 = 0;
            while (_loc_7 < _loc_6.length)
            {
                
                _loc_9 = _loc_6[_loc_7];
                if (param1.canBeCastOn(_loc_9))
                {
                    if (_loc_8 == null)
                    {
                        _loc_8 = _loc_9;
                    }
                    else if (this.isBetterMatch(_loc_9, _loc_8, param2, param3, param4, param5))
                    {
                        _loc_8 = _loc_9;
                    }
                }
                _loc_7++;
            }
            return _loc_8;
        }// end function

        public function isBetterMatch(param1:CardInstance, param2:CardInstance, param3:int, param4:Boolean, param5:Boolean, param6:Boolean) : Boolean
        {
            var _loc_15:* = undefined;
            var _loc_7:* = param1.templateRef.isType(CardTemplate.CardType_Spy);
            var _loc_8:* = param2.templateRef.isType(CardTemplate.CardType_Spy);
            var _loc_9:* = param1.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
            var _loc_10:* = param2.templateRef.hasEffect(CardTemplate.CardEffect_MeleeScorch);
            var _loc_11:* = param1.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
            var _loc_12:* = param2.templateRef.hasEffect(CardTemplate.CardEffect_Nurse);
            var _loc_13:* = param3 == CardManager.PLAYER_1 ? (CardManager.PLAYER_2) : (CardManager.PLAYER_1);
            var _loc_14:* = this.calculatePlayerScore(CARD_LIST_LOC_MELEE, _loc_13);
            if (param5 || param6)
            {
                _loc_15 = param4 == true ? (false) : (true);
            }
            if (_loc_7 || _loc_8)
            {
                if (!_loc_8)
                {
                    return true;
                }
                if (param5 && _loc_7 && this.checkIfHigherOrLower(param1, param2, _loc_15))
                {
                    return true;
                }
                if (_loc_7 && this.checkIfHigherOrLower(param1, param2, param4))
                {
                    return true;
                }
                return false;
            }
            else if (_loc_9 || _loc_10)
            {
                if (_loc_10)
                {
                    return false;
                }
                if (_loc_14 >= 10)
                {
                    return true;
                }
                return false;
            }
            else if (_loc_11 || _loc_12)
            {
                if (!_loc_12)
                {
                    return true;
                }
                if (param6 && _loc_11 && this.checkIfHigherOrLower(param1, param2, _loc_15))
                {
                    return true;
                }
                if (_loc_11 && this.checkIfHigherOrLower(param1, param2, true))
                {
                    return true;
                }
                return false;
            }
            else if (this.checkIfHigherOrLower(param1, param2, param4))
            {
                return true;
            }
            return false;
        }// end function

        public function checkIfHigherOrLower(param1:CardInstance, param2:CardInstance, param3) : Boolean
        {
            if (param3)
            {
                if (param1.getTotalPower() > param2.getTotalPower())
                {
                    return true;
                }
                return false;
            }
            else
            {
                if (param1.getTotalPower() < param2.getTotalPower())
                {
                    return true;
                }
                return false;
            }
        }// end function

        public function recalculateScores() : void
        {
            var _loc_1:* = this.getWinningPlayer();
            var _loc_2:* = this.calculatePlayerScore(CARD_LIST_LOC_SEIGE, PLAYER_2);
            var _loc_3:* = this.calculatePlayerScore(CARD_LIST_LOC_RANGED, PLAYER_2);
            var _loc_4:* = this.calculatePlayerScore(CARD_LIST_LOC_MELEE, PLAYER_2);
            var _loc_5:* = this.calculatePlayerScore(CARD_LIST_LOC_MELEE, PLAYER_1);
            var _loc_6:* = this.calculatePlayerScore(CARD_LIST_LOC_RANGED, PLAYER_1);
            var _loc_7:* = this.calculatePlayerScore(CARD_LIST_LOC_SEIGE, PLAYER_1);
            this.currentPlayerScores[PLAYER_1] = _loc_5 + _loc_6 + _loc_7;
            this.playerRenderers[PLAYER_1].score = this.currentPlayerScores[PLAYER_1];
            this.currentPlayerScores[PLAYER_2] = _loc_4 + _loc_3 + _loc_2;
            this.playerRenderers[PLAYER_2].score = this.currentPlayerScores[PLAYER_2];
            this.playerRenderers[PLAYER_1].setIsWinning(this.currentPlayerScores[PLAYER_1] > this.currentPlayerScores[PLAYER_2]);
            this.playerRenderers[PLAYER_2].setIsWinning(this.currentPlayerScores[PLAYER_2] > this.currentPlayerScores[PLAYER_1]);
            this.boardRenderer.updateRowScores(_loc_7, _loc_6, _loc_5, _loc_4, _loc_3, _loc_2);
            if (_loc_1 != this.getWinningPlayer())
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_whose_winning_changed");
            }
            return;
        }// end function

        public function getWinningPlayer() : int
        {
            if (this.currentPlayerScores[PLAYER_1] > this.currentPlayerScores[PLAYER_2])
            {
                return PLAYER_1;
            }
            if (this.currentPlayerScores[PLAYER_1] < this.currentPlayerScores[PLAYER_2])
            {
                return PLAYER_2;
            }
            return PLAYER_INVALID;
        }// end function

        public function calculatePlayerScore(param1:int, param2:int) : int
        {
            var _loc_4:* = 0;
            var _loc_5:* = null;
            var _loc_3:* = 0;
            _loc_5 = this.getCardInstanceList(param1, param2);
            _loc_4 = 0;
            while (_loc_4 < _loc_5.length)
            {
                
                _loc_3 = _loc_3 + _loc_5[_loc_4].getTotalPower();
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public function CalculateCardPowerPotentials() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            _loc_2 = this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_1);
            _loc_1 = 0;
            while (_loc_1 < _loc_2.length)
            {
                
                _loc_2[_loc_1].recalculatePowerPotential(this);
                _loc_1++;
            }
            _loc_2 = this.getCardInstanceList(CARD_LIST_LOC_HAND, PLAYER_2);
            _loc_1 = 0;
            while (_loc_1 < _loc_2.length)
            {
                
                _loc_2[_loc_1].recalculatePowerPotential(this);
                _loc_1++;
            }
            return;
        }// end function

        public function GetRessurectionTargets(param1:int, param2:Vector.<CardInstance>, param3:Boolean) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = this.getCardInstanceList(CardManager.CARD_LIST_LOC_GRAVEYARD, param1);
            var _loc_6:* = 0;
            while (_loc_6 < _loc_5.length)
            {
                
                _loc_4 = _loc_5[_loc_6];
                if (_loc_4.templateRef.isType(CardTemplate.CardType_Creature) && !_loc_4.templateRef.isType(CardTemplate.CardType_Hero))
                {
                    if (param3)
                    {
                        _loc_4.recalculatePowerPotential(this);
                    }
                    param2.Count(_loc_4);
                }
                _loc_6++;
            }
            return;
        }// end function

        protected function cardSorter(param1:CardInstance, param2:CardInstance) : Number
        {
            if (param1.templateId == param2.templateId)
            {
                return 0;
            }
            var _loc_3:* = param1.templateRef;
            var _loc_4:* = param2.templateRef;
            var _loc_5:* = _loc_3.getCreatureType();
            var _loc_6:* = _loc_4.getCreatureType();
            if (_loc_5 == CardTemplate.CardType_None && _loc_6 == CardTemplate.CardType_None)
            {
                return param1.templateId - param2.templateId;
            }
            if (_loc_5 == CardTemplate.CardType_None)
            {
                return -1;
            }
            if (_loc_6 == CardTemplate.CardType_None)
            {
                return 1;
            }
            if (_loc_3.power != _loc_4.power)
            {
                return _loc_3.power - _loc_4.power;
            }
            return param1.templateId - param2.templateId;
        }// end function

        public function traceRoundResults() : void
        {
            var _loc_1:* = 0;
            Console.WriteLine("GFX -------------------------------- START TRACE ROUND RESULTS ----------------------------------");
            Console.WriteLine("GFX =============================================================================================");
            if (this.roundResults == null)
            {
                Console.WriteLine("GFX -------------- Round Results is empty!!! -------------");
            }
            else
            {
                _loc_1 = 0;
                while (_loc_1 < this.roundResults.length)
                {
                    
                    Console.WriteLine("GFX - " + this.roundResults[_loc_1]);
                    _loc_1++;
                }
            }
            Console.WriteLine("GFX =============================================================================================");
            Console.WriteLine("GFX ---------------------------------- END TRACE ROUND RESULTS ----------------------------------");
            return;
        }// end function

        public function listIDToString(param1:int) : String
        {
            switch(param1)
            {
                case CARD_LIST_LOC_DECK:
                {
                    return "DECK";
                }
                case CARD_LIST_LOC_HAND:
                {
                    return "HAND";
                }
                case CARD_LIST_LOC_GRAVEYARD:
                {
                    return "GRAVEYARD";
                }
                case CARD_LIST_LOC_SEIGE:
                {
                    return "SEIGE";
                }
                case CARD_LIST_LOC_RANGED:
                {
                    return "RANGED";
                }
                case CARD_LIST_LOC_MELEE:
                {
                    return "MELEE";
                }
                case CARD_LIST_LOC_SEIGEMODIFIERS:
                {
                    return "SEIGEMODIFIERS";
                }
                case CARD_LIST_LOC_RANGEDMODIFIERS:
                {
                    return "RANGEDMODIFIERS";
                }
                case CARD_LIST_LOC_MELEEMODIFIERS:
                {
                    return "MELEEMODIFIERS";
                }
                case CARD_LIST_LOC_WEATHERSLOT:
                {
                    return "WEATHER";
                }
                case CARD_LIST_LOC_LEADER:
                {
                    return "LEADER";
                }
                case CARD_LIST_LOC_INVALID:
                {
                }
                default:
                {
                    return "INVALID";
                    break;
                }
            }
        }// end function

        public static function getInstance() : CardManager
        {
            if (_instance == null)
            {
                _instance = new CardManager;
            }
            return _instance;
        }// end function

    }
}
