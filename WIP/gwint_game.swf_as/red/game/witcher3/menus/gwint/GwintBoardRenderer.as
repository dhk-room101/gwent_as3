package red.game.witcher3.menus.gwint 
{
    import __AS3__.vec.*;
    import com.gskinner.motion.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.slots.*;
    import scaleform.clik.events.*;
    
    public class GwintBoardRenderer extends red.game.witcher3.slots.SlotsListBase
    {
        public function GwintBoardRenderer()
        {
            this.allCardSlotInstances = new flash.utils.Dictionary();
            super();
            return;
        }

        public function removeCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=this.allCardSlotInstances[arg1.instanceId];
            if (loc1) 
            {
                this.mcGodCardHolder.removeChild(loc1);
            }
            return;
        }

        public override function handleInputPreset(arg1:scaleform.clik.events.InputEvent):void
        {
            if (selectedIndex < 0) 
            {
                this.selectCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_HAND, red.game.witcher3.menus.gwint.CardManager.PLAYER_1);
            }
            var loc1:*=getSelectedRenderer() as red.game.witcher3.menus.gwint.GwintCardHolder;
            if (loc1) 
            {
                loc1.handleInput(arg1);
            }
            if (!arg1.handled) 
            {
                super.handleInputPreset(arg1);
            }
            return;
        }

        public function getSelectedCardHolder():red.game.witcher3.menus.gwint.GwintCardHolder
        {
            if (selectedIndex == -1) 
            {
                return null;
            }
            return getSelectedRenderer() as red.game.witcher3.menus.gwint.GwintCardHolder;
        }

        public function getSelectedCard():red.game.witcher3.menus.gwint.CardSlot
        {
            var loc1:*=this.getSelectedCardHolder();
            if (loc1 == null) 
            {
                return null;
            }
            return loc1.getSelectedCardSlot();
        }

        protected override function configUI():void
        {
            super.configUI();
            this.cardManager = red.game.witcher3.menus.gwint.CardManager.getInstance();
            red.game.witcher3.menus.gwint.CardManager.getInstance().boardRenderer = this;
            this.updateRowScores(0, 0, 0, 0, 0, 0);
            this.fillRenderersList();
            if (this.mcTransactionTooltip) 
            {
                this.mcTransactionTooltip.visible = false;
                this.mcTransactionTooltip.alpha = 0;
            }
            this.setupCardHolders();
            return;
        }

        protected function setupCardHolders():void
        {
            this.setupCardHolder(this.mcP1Deck);
            this.setupCardHolder(this.mcP2Deck);
            this.setupCardHolder(this.mcP1Hand);
            this.setupCardHolder(this.mcP2Hand);
            this.setupCardHolder(this.mcP1Graveyard);
            this.setupCardHolder(this.mcP2Graveyard);
            this.setupCardHolder(this.mcP1Siege);
            this.setupCardHolder(this.mcP2Siege);
            this.setupCardHolder(this.mcP1Range);
            this.setupCardHolder(this.mcP2Range);
            this.setupCardHolder(this.mcP1Melee);
            this.setupCardHolder(this.mcP2Melee);
            this.setupCardHolder(this.mcP1SiegeModif);
            this.setupCardHolder(this.mcP2SiegeModif);
            this.setupCardHolder(this.mcP1RangeModif);
            this.setupCardHolder(this.mcP2RangeModif);
            this.setupCardHolder(this.mcP1MeleeModif);
            this.setupCardHolder(this.mcP2MeleeModif);
            this.setupCardHolder(this.mcP1LeaderHolder);
            this.setupCardHolder(this.mcP2LeaderHolder);
            this.setupCardHolder(this.mcWeather);
            return;
        }

        protected function fillRenderersList():void
        {
            var loc1:*=0;
            this.allRenderers = new Vector.<red.game.witcher3.menus.gwint.GwintCardHolder>();
            loc1 = 0;
            while (loc1 < numChildren) 
            {
                if (getChildAt(loc1) is red.game.witcher3.menus.gwint.GwintCardHolder) 
                {
                    this.allRenderers.push(getChildAt(loc1));
                }
                ++loc1;
            }
            this.allRenderers.sort(this.cardHolderSorter);
            loc1 = 0;
            while (loc1 < this.allRenderers.length) 
            {
                this.allRenderers[loc1].boardRendererRef = this;
                _renderers.push(this.allRenderers[loc1]);
                ++loc1;
            }
            _renderersCount = this.allRenderers.length;
            return;
        }

        protected function cardHolderSorter(arg1:red.game.witcher3.menus.gwint.GwintCardHolder, arg2:red.game.witcher3.menus.gwint.GwintCardHolder):Number
        {
            return arg1.uniqueID - arg2.uniqueID;
        }

        public function selectCardHolder(arg1:int, arg2:int):void
        {
            this.selectCardHolderAdv(this.getCardHolder(arg1, arg2));
            return;
        }

        public function selectCardHolderAdv(arg1:red.game.witcher3.menus.gwint.GwintCardHolder):void
        {
            if (arg1 == null) 
            {
                return;
            }
            var loc1:*=this.allRenderers.indexOf(arg1);
            if (loc1 > -1) 
            {
                selectedIndex = loc1;
                if (arg1.selectedCardIdx == -1) 
                {
                    arg1.selectedCardIdx = 0;
                }
            }
            return;
        }

        public function selectCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc1:*=null;
            if (arg1) 
            {
                loc1 = this.getCardHolder(arg1.inList, arg1.listsPlayer);
                if (loc1) 
                {
                    this.selectCardHolderAdv(loc1);
                    loc1.selectCardInstance(arg1);
                }
                else 
                {
                    throw new Error("GFX [ERROR] - tried to select card with no matching card holder on board! list: " + arg1.inList + ", listsPlayer: " + arg1.listsPlayer);
                }
            }
            else 
            {
                throw new Error("GFX [ERROR] - tried to select card slot with unknown card instance. Should not happen in this context: " + arg1);
            }
            return;
        }

        public function selectCard(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            var loc1:*=arg1.cardInstance;
            this.selectCardInstance(loc1);
            return;
        }

        public function getCardHolder(arg1:int, arg2:int):red.game.witcher3.menus.gwint.GwintCardHolder
        {
            var loc1:*=0;
            var loc2:*=null;
            loc1 = 0;
            while (loc1 < this.allRenderers.length) 
            {
                loc2 = this.allRenderers[loc1];
                if (loc2.cardHolderID == arg1 && loc2.playerID == arg2) 
                {
                    return loc2;
                }
                ++loc1;
            }
            return null;
        }

        public function activateAllHolders(arg1:Boolean):void
        {
            var value:Boolean;

            var loc1:*;
            value = arg1;
            this.allRenderers.forEach(function (arg1:red.game.witcher3.menus.gwint.GwintCardHolder):*
            {
                arg1.selectable = value;
                arg1.disableNavigation = false;
                arg1.cardSelectionEnabled = true;
                arg1.alwaysHighlight = false;
                return;
            })
            return;
        }

        public function activateHoldersForCard(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:Boolean=false):void
        {
            var loc1:*=null;
            var loc3:*=false;
            var loc2:*=this.allRenderers.length;
            var loc4:*=new Vector.<red.game.witcher3.menus.gwint.CardInstance>();
            var loc5:*=0;
            while (loc5 < loc2) 
            {
                loc1 = this.allRenderers[loc5];
                loc3 = false;
                if (arg1.templateRef.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy) && loc1.playerID == arg1.owningPlayer && (loc1.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE || loc1.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED || loc1.cardHolderID == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE) && loc1.playerID == arg1.owningPlayer) 
                {
                    loc4.length = 0;
                    red.game.witcher3.menus.gwint.CardManager.getInstance().getAllCreaturesNonHero(loc1.cardHolderID, loc1.playerID, loc4);
                    loc3 = loc4.length > 0;
                }
                else 
                {
                    loc1.cardSelectionEnabled = false;
                    if (arg1.canBePlacedInSlot(loc1.cardHolderID, loc1.playerID)) 
                    {
                        loc3 = true;
                    }
                }
                trace("GFX ----- Analyzing slot for placement, valid: " + loc3 + ", for slot: " + loc1);
                loc1.selectable = loc3;
                loc1.alwaysHighlight = loc3;
                if (loc3 && arg2) 
                {
                    selectedIndex = loc5;
                    arg2 = false;
                }
                ++loc5;
            }
            return;
        }

        public function getCardSlotById(arg1:int):red.game.witcher3.menus.gwint.CardSlot
        {
            return this.allCardSlotInstances[arg1];
        }

        public function wasRemovedFromList(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:int, arg3:int):void
        {
            var loc1:*=this.getCardHolder(arg2, arg3);
            var loc2:*=this.allCardSlotInstances[arg1.instanceId];
            if (!loc1 || !loc2) 
            {
                throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + arg2.toString() + ", sourcePlayerID: " + arg3.toString());
            }
            loc1.cardRemoved(loc2);
            return;
        }

        public function wasAddedToList(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:int, arg3:int):void
        {
            var loc1:*=this.getCardHolder(arg2, arg3);
            var loc2:*=this.allCardSlotInstances[arg1.instanceId];
            if (!loc1 || !loc2) 
            {
                throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + arg2.toString() + ", sourcePlayerID: " + arg3.toString());
            }
            loc1.cardAdded(loc2);
            return;
        }

        public function spawnCardInstance(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:int, arg3:int):*
        {
            var loc1:*=this.getCardHolder(arg2, arg3);
            if (!loc1) 
            {
                throw new Error("GFX ---- spawnCardInstance failed because it was called with unknown params, sourceTypeID: " + arg2.toString() + ", sourcePlayerID: " + arg3.toString());
            }
            var loc2:*=new _slotRendererRef() as red.game.witcher3.menus.gwint.CardSlot;
            loc2.useContextMgr = false;
            loc2.instanceId = arg1.instanceId;
            loc2.cardState = "Board";
            this.mcGodCardHolder.addChild(loc2);
            this.allCardSlotInstances[arg1.instanceId] = loc2;
            loc2.setCallbacksToCardInstance(arg1);
            loc1.spawnCard(loc2);
            return;
        }

        public function returnToDeck(arg1:red.game.witcher3.menus.gwint.CardInstance):void
        {
            var loc2:*=null;
            var loc1:*=this.allCardSlotInstances[arg1.instanceId];
            if (loc1) 
            {
                loc2 = this.getCardHolder(red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_DECK, arg1.owningPlayer);
                red.game.witcher3.menus.gwint.CardTweenManager.getInstance().tweenTo(loc1, loc2.x + red.game.witcher3.menus.gwint.CardSlot.CARD_BOARD_WIDTH / 2, loc2.y + red.game.witcher3.menus.gwint.CardSlot.CARD_BOARD_HEIGHT / 2, this.onReturnToDeckEnded);
            }
            return;
        }

        public function onReturnToDeckEnded(arg1:com.gskinner.motion.GTween):void
        {
            var loc1:*=arg1.target as red.game.witcher3.menus.gwint.CardSlot;
            if (loc1) 
            {
                this.mcGodCardHolder.removeChild(loc1);
            }
            return;
        }

        public function updateRowScores(arg1:int, arg2:int, arg3:int, arg4:int, arg5:int, arg6:int):void
        {
            var loc1:*=null;
            loc1 = this.rowScoreP1Seige.getChildByName("txtScore") as red.game.witcher3.controls.W3TextArea;
            if (loc1) 
            {
                loc1.text = arg1.toString();
            }
            loc1 = this.rowScoreP1Ranged.getChildByName("txtScore") as red.game.witcher3.controls.W3TextArea;
            if (loc1) 
            {
                loc1.text = arg2.toString();
            }
            loc1 = this.rowScoreP1Melee.getChildByName("txtScore") as red.game.witcher3.controls.W3TextArea;
            if (loc1) 
            {
                loc1.text = arg3.toString();
            }
            loc1 = this.rowScoreP2Melee.getChildByName("txtScore") as red.game.witcher3.controls.W3TextArea;
            if (loc1) 
            {
                loc1.text = arg4.toString();
            }
            loc1 = this.rowScoreP2Ranged.getChildByName("txtScore") as red.game.witcher3.controls.W3TextArea;
            if (loc1) 
            {
                loc1.text = arg5.toString();
            }
            loc1 = this.rowScoreP2Seige.getChildByName("txtScore") as red.game.witcher3.controls.W3TextArea;
            if (loc1) 
            {
                loc1.text = arg6.toString();
            }
            return;
        }

        public function clearAllCards():void
        {
            var loc1:*=null;
            this.mcP1Deck.clearAllCards();
            this.mcP2Deck.clearAllCards();
            this.mcP1Hand.clearAllCards();
            this.mcP2Hand.clearAllCards();
            this.mcP1Graveyard.clearAllCards();
            this.mcP2Graveyard.clearAllCards();
            this.mcP1Siege.clearAllCards();
            this.mcP2Siege.clearAllCards();
            this.mcP1Range.clearAllCards();
            this.mcP2Range.clearAllCards();
            this.mcP1Melee.clearAllCards();
            this.mcP2Melee.clearAllCards();
            this.mcP1SiegeModif.clearAllCards();
            this.mcP2SiegeModif.clearAllCards();
            this.mcP1RangeModif.clearAllCards();
            this.mcP2RangeModif.clearAllCards();
            this.mcP1MeleeModif.clearAllCards();
            this.mcP2MeleeModif.clearAllCards();
            this.mcP1LeaderHolder.clearAllCards();
            this.mcP2LeaderHolder.clearAllCards();
            while (this.mcGodCardHolder.numChildren > 0) 
            {
                this.mcGodCardHolder.removeChildAt(0);
            }
            return;
        }

        public function updateTransactionCardTooltip(arg1:red.game.witcher3.menus.gwint.CardSlot):void
        {
            var loc1:*=null;
            var loc2:*=null;
            var loc3:*=null;
            var loc4:*=null;
            var loc5:*=null;
            if (this.mcTransactionTooltip) 
            {
                if (arg1 == null) 
                {
                    if (this.mcTransactionTooltip.visible) 
                    {
                        com.gskinner.motion.GTweener.removeTweens(this.mcTransactionTooltip);
                        com.gskinner.motion.GTweener.to(this.mcTransactionTooltip, 0.2, {"alpha":0}, {"onComplete":this.onTooltipHideEnded});
                    }
                }
                else 
                {
                    visible = true;
                    com.gskinner.motion.GTweener.removeTweens(this.mcTransactionTooltip);
                    com.gskinner.motion.GTweener.to(this.mcTransactionTooltip, 0.2, {"alpha":1}, {});
                    if (this.cardManager) 
                    {
                        loc1 = this.cardManager.getCardTemplate(arg1.cardIndex);
                        loc2 = loc1.tooltipString;
                        loc3 = this.mcTransactionTooltip.getChildByName("txtTooltipTitle") as flash.text.TextField;
                        loc4 = this.mcTransactionTooltip.getChildByName("txtTooltip") as flash.text.TextField;
                        if (loc2 == "" || !loc3 || !loc4) 
                        {
                            this.mcTransactionTooltip.visible = false;
                        }
                        else 
                        {
                            this.mcTransactionTooltip.visible = true;
                            if (loc1.index >= 1000) 
                            {
                                loc3.text = "[[gwint_leader_ability]]";
                            }
                            else 
                            {
                                loc3.text = "[[" + loc2 + "_title]]";
                            }
                            loc4.text = "[[" + loc2 + "]]";
                            loc5 = this.mcTransactionTooltip.getChildByName("mcTooltipIcon") as flash.display.MovieClip;
                            if (loc5) 
                            {
                                loc5.gotoAndStop(loc1.tooltipIcon);
                            }
                        }
                    }
                }
            }
            return;
        }

        protected function setupCardHolder(arg1:red.game.witcher3.menus.gwint.GwintCardHolder):void
        {
            return;
        }

        public function handleMouseMove(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=0;
            var loc2:*=null;
            var loc3:*=-1;
            loc1 = 0;
            while (loc1 < _renderers.length) 
            {
                loc2 = _renderers[loc1] as red.game.witcher3.menus.gwint.GwintCardHolder;
                if (loc2 && (loc2.selectable || loc2.cardSelectionEnabled) && loc2.handleMouseMove(arg1.stageX, arg1.stageY)) 
                {
                    loc3 = loc1;
                    break;
                }
                ++loc1;
            }
            selectedIndex = loc3;
            return;
        }

        public function handleLeftClick(arg1:flash.events.MouseEvent):void
        {
            this.handleMouseMove(arg1);
            var loc1:*=this.getSelectedCardHolder();
            if (loc1) 
            {
                loc1.handleLeftClick(arg1);
            }
            return;
        }

        protected function onTooltipHideEnded(arg1:com.gskinner.motion.GTween):void
        {
            if (this.mcTransactionTooltip) 
            {
                this.mcTransactionTooltip.visible = false;
            }
            return;
        }

        public var mcWeather:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcTransactionTooltip:flash.display.MovieClip;

        public var rowScoreP1Ranged:flash.display.MovieClip;

        private var allRenderers:__AS3__.vec.Vector.<red.game.witcher3.menus.gwint.GwintCardHolder>;

        private var allCardSlotInstances:flash.utils.Dictionary;

        public var mcGodCardHolder:flash.display.MovieClip;

        public var mcTransitionAnchor:flash.display.MovieClip;

        public var rowScoreP2Seige:flash.display.MovieClip;

        public var rowScoreP2Ranged:flash.display.MovieClip;

        private var cardManager:red.game.witcher3.menus.gwint.CardManager;

        public var rowScoreP2Melee:flash.display.MovieClip;

        public var rowScoreP1Melee:flash.display.MovieClip;

        public var rowScoreP1Seige:flash.display.MovieClip;

        public var mcP1LeaderHolder:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2LeaderHolder:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1Deck:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2Deck:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1Hand:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2Hand:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1Graveyard:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2Graveyard:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1Siege:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2Siege:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1Range:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2Range:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2SiegeModif:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1Melee:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2Melee:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1SiegeModif:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1RangeModif:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2RangeModif:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP1MeleeModif:red.game.witcher3.menus.gwint.GwintCardHolder;

        public var mcP2MeleeModif:red.game.witcher3.menus.gwint.GwintCardHolder;
    }
}
