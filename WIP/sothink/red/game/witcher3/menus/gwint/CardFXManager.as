package red.game.witcher3.menus.gwint
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import scaleform.clik.core.*;

    public class CardFXManager extends UIComponent
    {
        private var effectDictionary:Dictionary;
        private var numEffectsPlaying:int = 0;
        private var weatherParent:MovieClip;
        public var activeFXDictionary:Dictionary;
        private var weatherMeleeOngoing_Active:Boolean = false;
        private var weatherRangedOngoing_Active:Boolean = false;
        private var weatherSeigeOngoing_Active:Boolean = false;
        public var weatherMeleeP1Ongoing:MovieClip;
        public var weatherMeleeP2Ongoing:MovieClip;
        public var weatherRangedP1Ongoing:MovieClip;
        public var weatherRangedP2Ongoing:MovieClip;
        public var weatherSeigeP1Ongoing:MovieClip;
        public var weatherSeigeP2Ongoing:MovieClip;
        protected var hidingWeatherMeleeTimer:Timer;
        protected var hidingWeatherRangedTimer:Timer;
        protected var hidingWeatherSiegeTimer:Timer;
        protected var _frostFXName:String;
        public var _frostFXClassRef:Class;
        protected var _fogFXName:String;
        public var _fogFXClassRef:Class;
        protected var _rainFXName:String;
        public var _rainFXClassRef:Class;
        protected var _clearWeatherFXName:String;
        public var _clearWeatherFXClassRef:Class;
        protected var _hornFXName:String;
        public var _hornFXClassRef:Class;
        protected var _scorchFXName:String;
        public var _scorchFXClassRef:Class;
        protected var _dummyFXName:String;
        public var _dummyFXClassRef:Class;
        protected var _placeMeleeFXName:String;
        public var _placeMeleeFXClassRef:Class;
        protected var _placeRangedFXName:String;
        public var _placeRangedFXClassRef:Class;
        protected var _placeSeigeFXName:String;
        public var _placeSeigeFXClassRef:Class;
        protected var _placeSpyFXName:String;
        public var _placeSpyFXClassRef:Class;
        protected var _placeHeroFXName:String;
        public var _placeHeroFXClassRef:Class;
        protected var _resurrectFXName:String;
        public var _resurrectFXClassRef:Class;
        protected var _summonClonesFXName:String;
        public var _summonClonesFXClassRef:Class;
        protected var _moraleBoostFXName:String;
        public var _moraleBoostFXClassRef:Class;
        protected var _tightBondsFXName:String;
        public var _tightBondsFXClassRef:Class;
        protected var _summonClonesArriveFX:String;
        public var _summonClonesArriveFXClassRef:Class;
        protected var _hornRowFXName:String;
        public var _hornRowFXClassRef:Class;
        protected var _rowEffectX:Number;
        protected var _seigeEnemyRowEffectY:Number;
        protected var _rangedEnemyRowEffectY:Number;
        protected var _meleeEnemyRowEffectY:Number;
        protected var _meleePlayerRowEffectY:Number;
        protected var _rangedPlayerRowEffectY:Number;
        protected var _seigePlayerRowEffectY:Number;
        static var _instance:CardFXManager;
        private static var _instanceIDGenerator:int = 0;

        public function CardFXManager()
        {
            this.effectDictionary = new Dictionary();
            this.activeFXDictionary = new Dictionary();
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            _instance = this;
            mouseEnabled = false;
            mouseChildren = false;
            this.setupWeatherEffects();
            return;
        }// end function

        public function playCardDeployFX(param1:CardInstance, param2:Function) : void
        {
            var _loc_3:* = null;
            if (param1.playSummonedFX)
            {
                _loc_3 = this._summonClonesArriveFXClassRef;
                param1.playSummonedFX = false;
                if (param1.templateRef.isType(CardTemplate.CardType_Siege))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_siege_weapon");
                }
                else if (param1.templateRef.isType(CardTemplate.CardType_Ranged))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_long_range");
                }
                else if (param1.templateRef.isType(CardTemplate.CardType_Melee))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_close_combat");
                }
            }
            else
            {
                _loc_3 = this.getDeployFX(param1.templateRef);
            }
            if (_loc_3)
            {
                this.spawnFX(param1, param2, _loc_3);
            }
            else
            {
                this.param2(param1);
                Console.WriteLine("GFX ---- [WARNING] ---- CardFXManager tried to play Card Deploy FX with no matching fxClass: " + param1.toString());
            }
            return;
        }// end function

        public function playerCardEffectFX(param1:CardInstance, param2:Function) : void
        {
            var _loc_3:* = this.getEffectFX(param1.templateRef);
            if (_loc_3)
            {
                this.spawnFX(param1, param2, _loc_3);
            }
            else
            {
                this.param2(param1);
                Console.WriteLine("GFX ---- [WARNING] ---- CardFXManager tried to play Card Effect FX with no matching fxClass: " + param1.toString());
            }
            return;
        }// end function

        public function playRessurectEffectFX(param1:CardInstance, param2:Function) : void
        {
            if (this._resurrectFXClassRef)
            {
                this.spawnFX(param1, param2, this._resurrectFXClassRef);
            }
            else
            {
                this.param2(param1);
                Console.WriteLine("GFX ---- [WARNING] ---- CardFXManager tried to play Card Resurrect FX with no matching fxClass: " + param1.toString());
            }
            return;
        }// end function

        public function playScorchEffectFX(param1:CardInstance, param2:Function) : void
        {
            if (this._scorchFXClassRef)
            {
                this.spawnFX(param1, param2, this._scorchFXClassRef);
            }
            else
            {
                Console.WriteLine("GFX ---- [WARNING] ---- CardFXManager tried to play Card Scorch FX with no matching fxClass: " + param1.toString());
                this.param2(param1);
            }
            return;
        }// end function

        public function playTightBondsFX(param1:CardInstance, param2:Function) : void
        {
            if (this._tightBondsFXClassRef)
            {
                this.spawnFX(param1, param2, this._tightBondsFXClassRef);
            }
            else
            {
                Console.WriteLine("GFX ---- [WARNING] ---- CardFXManager tried to play Tight Bonds FX with no matching fxClass: " + param1.toString());
                this.param2(param1);
            }
            return;
        }// end function

        public function spawnFX(param1:CardInstance, param2:Function, param3:Class) : void
        {
            var _loc_6:* = null;
            _instanceIDGenerator = (_instanceIDGenerator + 1);
            var _loc_4:* = _instanceIDGenerator + 1;
            var _loc_5:* = new param3;
            _loc_5.associatedCardInstance = param1;
            _loc_5.instanceID = _loc_4;
            _loc_5.finalFinishCallback = param2;
            _loc_5.cardFXManagerFinishCallback = this.finishedFXCallback;
            this.addChild(_loc_5);
            this.addChild(this.weatherParent);
            if (param1 != null && !param1.templateRef.isType(CardTemplate.CardType_Weather))
            {
                _loc_6 = CardManager.getInstance().boardRenderer.getCardSlotById(param1.instanceId);
                if (_loc_6)
                {
                    _loc_5.x = _loc_6.x;
                    _loc_5.y = _loc_6.y;
                }
            }
            else
            {
                _loc_5.x = 0;
                _loc_5.y = 0;
            }
            _loc_5.play();
            var _loc_7:* = this;
            var _loc_8:* = this.numEffectsPlaying + 1;
            _loc_7.numEffectsPlaying = _loc_8;
            return;
        }// end function

        protected function finishedFXCallback(param1:CardFX) : void
        {
            if (param1.finalFinishCallback != null)
            {
                param1.finalFinishCallback(param1.associatedCardInstance);
            }
            removeChild(param1);
            var _loc_2:* = this;
            var _loc_3:* = this.numEffectsPlaying - 1;
            _loc_2.numEffectsPlaying = _loc_3;
            this.effectDictionary[param1.instanceID] = null;
            return;
        }// end function

        public function isPlayingAnyCardFX() : Boolean
        {
            return this.numEffectsPlaying > 0;
        }// end function

        public function playRowEffect(param1:int, param2:int) : void
        {
            var _loc_4:* = NaN;
            var _loc_3:* = new this._hornRowFXClassRef();
            if (_loc_3)
            {
                _loc_3.cardFXManagerFinishCallback = this.finishedFXCallback;
                this.addChild(_loc_3);
                this.addChild(this.weatherParent);
                switch(param1)
                {
                    case CardManager.CARD_LIST_LOC_SEIGE:
                    case CardManager.CARD_LIST_LOC_SEIGEMODIFIERS:
                    {
                        break;
                    }
                    case CardManager.CARD_LIST_LOC_RANGED:
                    case CardManager.CARD_LIST_LOC_RANGEDMODIFIERS:
                    {
                        break;
                    }
                    case CardManager.CARD_LIST_LOC_MELEE:
                    case CardManager.CARD_LIST_LOC_MELEEMODIFIERS:
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                if (param2 == CardManager.PLAYER_2)
                {
                    switch(param1)
                    {
                        case CardManager.CARD_LIST_LOC_SEIGE:
                        case CardManager.CARD_LIST_LOC_SEIGEMODIFIERS:
                        {
                            break;
                        }
                        case CardManager.CARD_LIST_LOC_RANGED:
                        case CardManager.CARD_LIST_LOC_RANGEDMODIFIERS:
                        {
                            break;
                        }
                        case CardManager.CARD_LIST_LOC_MELEE:
                        case CardManager.CARD_LIST_LOC_MELEEMODIFIERS:
                        {
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                }
                _loc_3.x = this._rowEffectX;
                _loc_3.y = _loc_4;
                _loc_3.play();
                var _loc_5:* = this;
                var _loc_6:* = this.numEffectsPlaying + 1;
                _loc_5.numEffectsPlaying = _loc_6;
            }
            return;
        }// end function

        protected function setupWeatherEffects() : void
        {
            this.weatherParent = new MovieClip();
            this.addChild(this.weatherParent);
            this.weatherParent.addChild(this.weatherMeleeP1Ongoing);
            this.weatherParent.addChild(this.weatherMeleeP2Ongoing);
            this.weatherParent.addChild(this.weatherRangedP1Ongoing);
            this.weatherParent.addChild(this.weatherRangedP2Ongoing);
            this.weatherParent.addChild(this.weatherSeigeP1Ongoing);
            this.weatherParent.addChild(this.weatherSeigeP2Ongoing);
            return;
        }// end function

        public function ShowWeatherOngoing(param1:int, param2:Boolean) : void
        {
            Console.WriteLine("GFX -------------------------------------------------------===================================");
            Console.WriteLine("GFX - ShowWeatherOngoing called for slot: " + param1 + ", with value: " + param2);
            if (param1 == CardManager.CARD_LIST_LOC_MELEE)
            {
                if (param2)
                {
                    if (this.hidingWeatherMeleeTimer)
                    {
                        this.hidingWeatherMeleeTimer.stop();
                        this.hidingWeatherMeleeTimer = null;
                    }
                    if (!this.weatherMeleeOngoing_Active)
                    {
                        Console.WriteLine("GFX - calling gotoAndPlay(start)");
                        this.weatherMeleeOngoing_Active = true;
                        this.weatherMeleeP1Ongoing.gotoAndPlay("start");
                        this.weatherMeleeP2Ongoing.gotoAndPlay("start");
                    }
                }
                else if (!this.hidingWeatherMeleeTimer && this.weatherMeleeOngoing_Active)
                {
                    Console.WriteLine("GFX - starting stop timer");
                    this.hidingWeatherMeleeTimer = new Timer(300, 1);
                    this.hidingWeatherMeleeTimer.addEventListener(TimerEvent.TIMER, this.hiddingMeleeWeatherTimerEnded, false, 0, true);
                    this.hidingWeatherMeleeTimer.start();
                }
            }
            else if (param1 == CardManager.CARD_LIST_LOC_RANGED)
            {
                if (param2)
                {
                    if (this.hidingWeatherRangedTimer)
                    {
                        this.hidingWeatherRangedTimer.stop();
                        this.hidingWeatherRangedTimer = null;
                    }
                    if (!this.weatherRangedOngoing_Active)
                    {
                        this.weatherRangedOngoing_Active = true;
                        Console.WriteLine("GFX - calling gotoAndPlay(start)");
                        this.weatherRangedP1Ongoing.gotoAndPlay("start");
                        this.weatherRangedP2Ongoing.gotoAndPlay("start");
                    }
                }
                else if (!this.hidingWeatherRangedTimer && this.weatherRangedOngoing_Active)
                {
                    Console.WriteLine("GFX - starting stop timer");
                    this.hidingWeatherRangedTimer = new Timer(300, 1);
                    this.hidingWeatherRangedTimer.addEventListener(TimerEvent.TIMER, this.hiddingRangeWeatherTimerEnded, false, 0, true);
                    this.hidingWeatherRangedTimer.start();
                }
            }
            else if (param1 == CardManager.CARD_LIST_LOC_SEIGE)
            {
                if (param2)
                {
                    if (this.hidingWeatherSiegeTimer)
                    {
                        this.hidingWeatherSiegeTimer.stop();
                        this.hidingWeatherSiegeTimer = null;
                    }
                    if (!this.weatherSeigeOngoing_Active)
                    {
                        this.weatherSeigeOngoing_Active = true;
                        Console.WriteLine("GFX - calling gotoAndPlay(start)");
                        this.weatherSeigeP1Ongoing.gotoAndPlay("start");
                        this.weatherSeigeP2Ongoing.gotoAndPlay("start");
                    }
                }
                else if (!this.hidingWeatherSiegeTimer && this.weatherSeigeOngoing_Active)
                {
                    Console.WriteLine("GFX - starting stop timer");
                    this.hidingWeatherSiegeTimer = new Timer(300, 1);
                    this.hidingWeatherSiegeTimer.addEventListener(TimerEvent.TIMER, this.hiddingSiegeWeatherTimerEnded, false, 0, true);
                    this.hidingWeatherSiegeTimer.start();
                }
            }
            Console.WriteLine("GFX ===================================-------------------------------------------------------");
            return;
        }// end function

        public function hiddingMeleeWeatherTimerEnded(event:TimerEvent)
        {
            if (this.weatherMeleeOngoing_Active)
            {
                this.weatherMeleeOngoing_Active = false;
                this.weatherMeleeP1Ongoing.gotoAndPlay("ending");
                this.weatherMeleeP2Ongoing.gotoAndPlay("ending");
                Console.WriteLine("GFX - calling gotoAndPlay(ending) - Melee");
                this.hidingWeatherMeleeTimer.stop();
                this.hidingWeatherMeleeTimer = null;
            }
            return;
        }// end function

        public function hiddingRangeWeatherTimerEnded(event:TimerEvent)
        {
            if (this.weatherRangedOngoing_Active)
            {
                this.weatherRangedOngoing_Active = false;
                this.weatherRangedP1Ongoing.gotoAndPlay("ending");
                this.weatherRangedP2Ongoing.gotoAndPlay("ending");
                Console.WriteLine("GFX - calling gotoAndPlay(ending) - Ranged");
                this.hidingWeatherRangedTimer.stop();
                this.hidingWeatherRangedTimer = null;
            }
            return;
        }// end function

        public function hiddingSiegeWeatherTimerEnded(event:TimerEvent)
        {
            if (this.weatherSeigeOngoing_Active)
            {
                this.weatherSeigeOngoing_Active = false;
                this.weatherSeigeP1Ongoing.gotoAndPlay("ending");
                this.weatherSeigeP2Ongoing.gotoAndPlay("ending");
                Console.WriteLine("GFX - calling gotoAndPlay(ending) - Siege");
                this.hidingWeatherSiegeTimer.stop();
                this.hidingWeatherSiegeTimer = null;
            }
            return;
        }// end function

        public function get frostFXName() : String
        {
            return this._frostFXName;
        }// end function

        public function set frostFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._frostFXName != value)
            {
                this._frostFXName = value;
                try
                {
                    this._frostFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get fogFXName() : String
        {
            return this._fogFXName;
        }// end function

        public function set fogFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._fogFXName != value)
            {
                this._fogFXName = value;
                try
                {
                    this._fogFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get rainFXName() : String
        {
            return this._rainFXName;
        }// end function

        public function set rainFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._rainFXName != value)
            {
                this._rainFXName = value;
                try
                {
                    this._rainFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get clearWeatherFXName() : String
        {
            return this._clearWeatherFXName;
        }// end function

        public function set clearWeatherFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._clearWeatherFXName != value)
            {
                this._clearWeatherFXName = value;
                try
                {
                    this._clearWeatherFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get hornFXName() : String
        {
            return this._hornFXName;
        }// end function

        public function set hornFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._hornFXName != value)
            {
                this._hornFXName = value;
                try
                {
                    this._hornFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get scorchFXName() : String
        {
            return this._scorchFXName;
        }// end function

        public function set scorchFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._scorchFXName != value)
            {
                this._scorchFXName = value;
                try
                {
                    this._scorchFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get dummyFXName() : String
        {
            return this._dummyFXName;
        }// end function

        public function set dummyFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._dummyFXName != value)
            {
                this._dummyFXName = value;
                try
                {
                    this._dummyFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get placeMeleeFXName() : String
        {
            return this._placeMeleeFXName;
        }// end function

        public function set placeMeleeFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._placeMeleeFXName != value)
            {
                this._placeMeleeFXName = value;
                try
                {
                    this._placeMeleeFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get placeRangedFXName() : String
        {
            return this._placeRangedFXName;
        }// end function

        public function set placeRangedFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._placeRangedFXName != value)
            {
                this._placeRangedFXName = value;
                try
                {
                    this._placeRangedFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get placeSeigeFXName() : String
        {
            return this._placeSeigeFXName;
        }// end function

        public function set placeSeigeFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._placeSeigeFXName != value)
            {
                this._placeSeigeFXName = value;
                try
                {
                    this._placeSeigeFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get placeSpyFXName() : String
        {
            return this._placeSpyFXName;
        }// end function

        public function set placeSpyFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._placeSpyFXName != value)
            {
                this._placeSpyFXName = value;
                try
                {
                    this._placeSpyFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get placeHeroFXName() : String
        {
            return this._placeHeroFXName;
        }// end function

        public function set placeHeroFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._placeHeroFXName != value)
            {
                this._placeHeroFXName = value;
                try
                {
                    this._placeHeroFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get resurrectFXName() : String
        {
            return this._resurrectFXName;
        }// end function

        public function set resurrectFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._resurrectFXName != value)
            {
                this._resurrectFXName = value;
                try
                {
                    this._resurrectFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get summonClonesFXName() : String
        {
            return this._summonClonesFXName;
        }// end function

        public function set summonClonesFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._summonClonesFXName != value)
            {
                this._summonClonesFXName = value;
                try
                {
                    this._summonClonesFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get moraleBoostFXName() : String
        {
            return this._moraleBoostFXName;
        }// end function

        public function set moraleBoostFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._moraleBoostFXName != value)
            {
                this._moraleBoostFXName = value;
                try
                {
                    this._moraleBoostFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get tightBondsFXName() : String
        {
            return this._tightBondsFXName;
        }// end function

        public function set tightBondsFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._tightBondsFXName != value)
            {
                this._tightBondsFXName = value;
                try
                {
                    this._tightBondsFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get summonClonesArriveFXName() : String
        {
            return this._summonClonesArriveFX;
        }// end function

        public function set summonClonesArriveFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._summonClonesArriveFX != value)
            {
                this._summonClonesArriveFX = value;
                try
                {
                    this._summonClonesArriveFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get hornRowFXName() : String
        {
            return this._hornRowFXName;
        }// end function

        public function set hornRowFXName(param1:String) : void
        {
            var value:* = param1;
            if (this._hornRowFXName != value)
            {
                this._hornRowFXName = value;
                try
                {
                    this._hornRowFXClassRef = getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    Console.WriteLine("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }// end function

        public function get rowEffectX() : Number
        {
            return this._rowEffectX;
        }// end function

        public function set rowEffectX(param1:Number) : void
        {
            this._rowEffectX = param1;
            return;
        }// end function

        public function get seigeEnemyRowEffectY() : Number
        {
            return this._seigeEnemyRowEffectY;
        }// end function

        public function set seigeEnemyRowEffectY(param1:Number) : void
        {
            this._seigeEnemyRowEffectY = param1;
            return;
        }// end function

        public function get rangedEnemyRowEffectY() : Number
        {
            return this._rangedEnemyRowEffectY;
        }// end function

        public function set rangedEnemyRowEffectY(param1:Number) : void
        {
            this._rangedEnemyRowEffectY = param1;
            return;
        }// end function

        public function get meleeEnemyRowEffectY() : Number
        {
            return this._meleeEnemyRowEffectY;
        }// end function

        public function set meleeEnemyRowEffectY(param1:Number) : void
        {
            this._meleeEnemyRowEffectY = param1;
            return;
        }// end function

        public function get meleePlayerRowEffectY() : Number
        {
            return this._meleePlayerRowEffectY;
        }// end function

        public function set meleePlayerRowEffectY(param1:Number) : void
        {
            this._meleePlayerRowEffectY = param1;
            return;
        }// end function

        public function get rangedPlayerRowEffectY() : Number
        {
            return this._rangedPlayerRowEffectY;
        }// end function

        public function set rangedPlayerRowEffectY(param1:Number) : void
        {
            this._rangedPlayerRowEffectY = param1;
            return;
        }// end function

        public function get seigePlayerRowEffectY() : Number
        {
            return this._seigePlayerRowEffectY;
        }// end function

        public function set seigePlayerRowEffectY(param1:Number) : void
        {
            this._seigePlayerRowEffectY = param1;
            return;
        }// end function

        protected function getDeployFX(param1:CardTemplate) : Class
        {
            if (param1.isType(CardTemplate.CardType_Hero))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_hero");
                return this._placeHeroFXClassRef;
            }
            if (param1.isType(CardTemplate.CardType_Spy))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_spy");
                return this._placeSpyFXClassRef;
            }
            if (param1.isType(CardTemplate.CardType_RangedMelee))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_agile");
                return this._placeRangedFXClassRef;
            }
            if (param1.isType(CardTemplate.CardType_Siege))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_siege_weapon");
                return this._placeSeigeFXClassRef;
            }
            if (param1.isType(CardTemplate.CardType_Ranged))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_long_range");
                return this._placeRangedFXClassRef;
            }
            if (param1.isType(CardTemplate.CardType_Melee))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_close_combat");
                return this._placeMeleeFXClassRef;
            }
            if (param1.isType(CardTemplate.CardType_Weather))
            {
                if (param1.hasEffect(CardTemplate.CardEffect_Melee))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_frost");
                    return this._frostFXClassRef;
                }
                if (param1.hasEffect(CardTemplate.CardEffect_Ranged))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_fog");
                    return this._fogFXClassRef;
                }
                if (param1.hasEffect(CardTemplate.CardEffect_Siege))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_rain");
                    return this._rainFXClassRef;
                }
                if (param1.hasEffect(CardTemplate.CardEffect_ClearSky))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_clear_weather");
                    return this._clearWeatherFXClassRef;
                }
            }
            else if (param1.isType(CardTemplate.CardType_Friendly_Effect))
            {
                if (param1.hasEffect(CardTemplate.CardEffect_UnsummonDummy))
                {
                    GwintGameMenu.mSingleton.playSound("gui_gwint_dummy");
                    return this._dummyFXClassRef;
                }
            }
            return null;
        }// end function

        protected function getEffectFX(param1:CardTemplate) : Class
        {
            if (param1.hasEffect(CardTemplate.CardEffect_Horn))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_horn");
                return this._hornFXClassRef;
            }
            if (param1.hasEffect(CardTemplate.CardEffect_Nurse))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_resurrect");
                return this._resurrectFXClassRef;
            }
            if (param1.hasEffect(CardTemplate.CardEffect_SummonClones))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_summon_clones");
                return this._summonClonesFXClassRef;
            }
            if (param1.hasEffect(CardTemplate.CardEffect_SameTypeMorale))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
                return this._tightBondsFXClassRef;
            }
            if (param1.hasEffect(CardTemplate.CardEffect_ImproveNeighbours))
            {
                GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
                return this._moraleBoostFXClassRef;
            }
            return null;
        }// end function

        public static function getInstance() : CardFXManager
        {
            return _instance;
        }// end function

    }
}
