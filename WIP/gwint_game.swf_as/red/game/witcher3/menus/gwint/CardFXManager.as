package red.game.witcher3.menus.gwint 
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;
    import scaleform.clik.core.*;
    
    public class CardFXManager extends scaleform.clik.core.UIComponent
    {
        public function CardFXManager()
        {
            this.effectDictionary = new flash.utils.Dictionary();
            this.activeFXDictionary = new flash.utils.Dictionary();
            super();
            return;
        }

        public function set placeMeleeFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._placeMeleeFXName != value) 
            {
                this._placeMeleeFXName = value;
                try 
                {
                    this._placeMeleeFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get frostFXName():String
        {
            return this._frostFXName;
        }

        public function set frostFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._frostFXName != value) 
            {
                this._frostFXName = value;
                try 
                {
                    this._frostFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            _instance = this;
            mouseEnabled = false;
            mouseChildren = false;
            this.setupWeatherEffects();
            return;
        }

        public function get hornFXName():String
        {
            return this._hornFXName;
        }

        public function playCardDeployFX(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:Function):void
        {
            var loc1:*=null;
            if (arg1.playSummonedFX) 
            {
                loc1 = this._summonClonesArriveFXClassRef;
                arg1.playSummonedFX = false;
                if (arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_siege_weapon");
                }
                else if (arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_long_range");
                }
                else if (arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_close_combat");
                }
            }
            else 
            {
                loc1 = this.getDeployFX(arg1.templateRef);
            }
            if (loc1) 
            {
                this.spawnFX(arg1, arg2, loc1);
            }
            else 
            {
                arg2(arg1);
                trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Deploy FX with no matching fxClass: " + arg1.toString());
            }
            return;
        }

        public function playerCardEffectFX(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:Function):void
        {
            var loc1:*=this.getEffectFX(arg1.templateRef);
            if (loc1) 
            {
                this.spawnFX(arg1, arg2, loc1);
            }
            else 
            {
                arg2(arg1);
                trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Effect FX with no matching fxClass: " + arg1.toString());
            }
            return;
        }

        public function playRessurectEffectFX(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:Function):void
        {
            if (this._resurrectFXClassRef) 
            {
                this.spawnFX(arg1, arg2, this._resurrectFXClassRef);
            }
            else 
            {
                arg2(arg1);
                trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Resurrect FX with no matching fxClass: " + arg1.toString());
            }
            return;
        }

        public function playScorchEffectFX(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:Function):void
        {
            if (this._scorchFXClassRef) 
            {
                this.spawnFX(arg1, arg2, this._scorchFXClassRef);
            }
            else 
            {
                trace("GFX ---- [WARNING] ---- CardFXManager tried to play Card Scorch FX with no matching fxClass: " + arg1.toString());
                arg2(arg1);
            }
            return;
        }

        public function playTightBondsFX(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:Function):void
        {
            if (this._tightBondsFXClassRef) 
            {
                this.spawnFX(arg1, arg2, this._tightBondsFXClassRef);
            }
            else 
            {
                trace("GFX ---- [WARNING] ---- CardFXManager tried to play Tight Bonds FX with no matching fxClass: " + arg1.toString());
                arg2(arg1);
            }
            return;
        }

        public function spawnFX(arg1:red.game.witcher3.menus.gwint.CardInstance, arg2:Function, arg3:Class):void
        {
            var loc3:*=null;
            var loc4:*;
            var loc5:*;
            var loc1:*=++_instanceIDGenerator;
            var loc2:*=new arg3();
            loc2.associatedCardInstance = arg1;
            loc2.instanceID = loc1;
            loc2.finalFinishCallback = arg2;
            loc2.cardFXManagerFinishCallback = this.finishedFXCallback;
            this.addChild(loc2);
            this.addChild(this.weatherParent);
            if (!(arg1 == null) && !arg1.templateRef.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
            {
                loc3 = red.game.witcher3.menus.gwint.CardManager.getInstance().boardRenderer.getCardSlotById(arg1.instanceId);
                if (loc3) 
                {
                    loc2.x = loc3.x;
                    loc2.y = loc3.y;
                }
            }
            else 
            {
                loc2.x = 0;
                loc2.y = 0;
            }
            loc2.play();
            loc5 = ((loc4 = this).numEffectsPlaying + 1);
            loc4.numEffectsPlaying = loc5;
            return;
        }

        protected function finishedFXCallback(arg1:red.game.witcher3.menus.gwint.CardFX):void
        {
            if (arg1.finalFinishCallback != null) 
            {
                arg1.finalFinishCallback(arg1.associatedCardInstance);
            }
            removeChild(arg1);
            var loc1:*;
            var loc2:*=((loc1 = this).numEffectsPlaying - 1);
            loc1.numEffectsPlaying = loc2;
            this.effectDictionary[arg1.instanceID] = null;
            return;
        }

        public function isPlayingAnyCardFX():Boolean
        {
            return this.numEffectsPlaying > 0;
        }

        public function playRowEffect(arg1:int, arg2:int):void
        {
            var loc2:*=NaN;
            var loc1:*=new this._hornRowFXClassRef();
            if (loc1) 
            {
                loc1.cardFXManagerFinishCallback = this.finishedFXCallback;
                this.addChild(loc1);
                this.addChild(this.weatherParent);
                if (arg2 != red.game.witcher3.menus.gwint.CardManager.PLAYER_1) 
                {
                    if (arg2 == red.game.witcher3.menus.gwint.CardManager.PLAYER_2) 
                    {
                        loc3 = arg1;
                        switch (loc3) 
                        {
                            case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE:
                            case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS:
                            {
                                loc2 = this._seigeEnemyRowEffectY;
                                break;
                            }
                            case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED:
                            case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS:
                            {
                                loc2 = this._rangedEnemyRowEffectY;
                                break;
                            }
                            case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE:
                            case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS:
                            {
                                loc2 = this._meleeEnemyRowEffectY;
                                break;
                            }
                        }
                    }
                }
                else 
                {
                    var loc3:*=arg1;
                    switch (loc3) 
                    {
                        case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE:
                        case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGEMODIFIERS:
                        {
                            loc2 = this._seigePlayerRowEffectY;
                            break;
                        }
                        case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED:
                        case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGEDMODIFIERS:
                        {
                            loc2 = this._rangedPlayerRowEffectY;
                            break;
                        }
                        case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE:
                        case red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEEMODIFIERS:
                        {
                            loc2 = this._meleePlayerRowEffectY;
                            break;
                        }
                    }
                }
                loc1.x = this._rowEffectX;
                loc1.y = loc2;
                loc1.play();
                var loc4:*=((loc3 = this).numEffectsPlaying + 1);
                loc3.numEffectsPlaying = loc4;
            }
            return;
        }

        public function set hornFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._hornFXName != value) 
            {
                this._hornFXName = value;
                try 
                {
                    this._hornFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get meleeEnemyRowEffectY():Number
        {
            return this._meleeEnemyRowEffectY;
        }

        public function get fogFXName():String
        {
            return this._fogFXName;
        }

        public function set fogFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._fogFXName != value) 
            {
                this._fogFXName = value;
                try 
                {
                    this._fogFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get dummyFXName():String
        {
            return this._dummyFXName;
        }

        public function set dummyFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._dummyFXName != value) 
            {
                this._dummyFXName = value;
                try 
                {
                    this._dummyFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get rainFXName():String
        {
            return this._rainFXName;
        }

        public function set rainFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._rainFXName != value) 
            {
                this._rainFXName = value;
                try 
                {
                    this._rainFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get scorchFXName():String
        {
            return this._scorchFXName;
        }

        public function set scorchFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._scorchFXName != value) 
            {
                this._scorchFXName = value;
                try 
                {
                    this._scorchFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get clearWeatherFXName():String
        {
            return this._clearWeatherFXName;
        }

        public function set clearWeatherFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._clearWeatherFXName != value) 
            {
                this._clearWeatherFXName = value;
                try 
                {
                    this._clearWeatherFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        protected function setupWeatherEffects():void
        {
            this.weatherParent = new flash.display.MovieClip();
            this.addChild(this.weatherParent);
            this.weatherParent.addChild(this.weatherMeleeP1Ongoing);
            this.weatherParent.addChild(this.weatherMeleeP2Ongoing);
            this.weatherParent.addChild(this.weatherRangedP1Ongoing);
            this.weatherParent.addChild(this.weatherRangedP2Ongoing);
            this.weatherParent.addChild(this.weatherSeigeP1Ongoing);
            this.weatherParent.addChild(this.weatherSeigeP2Ongoing);
            return;
        }

        public function ShowWeatherOngoing(arg1:int, arg2:Boolean):void
        {
            trace("GFX -------------------------------------------------------===================================");
            trace("GFX - ShowWeatherOngoing called for slot: " + arg1 + ", with value: " + arg2);
            if (arg1 != red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_MELEE) 
            {
                if (arg1 != red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_RANGED) 
                {
                    if (arg1 == red.game.witcher3.menus.gwint.CardManager.CARD_LIST_LOC_SEIGE) 
                    {
                        if (arg2) 
                        {
                            if (this.hidingWeatherSiegeTimer) 
                            {
                                this.hidingWeatherSiegeTimer.stop();
                                this.hidingWeatherSiegeTimer = null;
                            }
                            if (!this.weatherSeigeOngoing_Active) 
                            {
                                this.weatherSeigeOngoing_Active = true;
                                trace("GFX - calling gotoAndPlay(start)");
                                this.weatherSeigeP1Ongoing.gotoAndPlay("start");
                                this.weatherSeigeP2Ongoing.gotoAndPlay("start");
                            }
                        }
                        else if (!this.hidingWeatherSiegeTimer && this.weatherSeigeOngoing_Active) 
                        {
                            trace("GFX - starting stop timer");
                            this.hidingWeatherSiegeTimer = new flash.utils.Timer(300, 1);
                            this.hidingWeatherSiegeTimer.addEventListener(flash.events.TimerEvent.TIMER, this.hiddingSiegeWeatherTimerEnded, false, 0, true);
                            this.hidingWeatherSiegeTimer.start();
                        }
                    }
                }
                else if (arg2) 
                {
                    if (this.hidingWeatherRangedTimer) 
                    {
                        this.hidingWeatherRangedTimer.stop();
                        this.hidingWeatherRangedTimer = null;
                    }
                    if (!this.weatherRangedOngoing_Active) 
                    {
                        this.weatherRangedOngoing_Active = true;
                        trace("GFX - calling gotoAndPlay(start)");
                        this.weatherRangedP1Ongoing.gotoAndPlay("start");
                        this.weatherRangedP2Ongoing.gotoAndPlay("start");
                    }
                }
                else if (!this.hidingWeatherRangedTimer && this.weatherRangedOngoing_Active) 
                {
                    trace("GFX - starting stop timer");
                    this.hidingWeatherRangedTimer = new flash.utils.Timer(300, 1);
                    this.hidingWeatherRangedTimer.addEventListener(flash.events.TimerEvent.TIMER, this.hiddingRangeWeatherTimerEnded, false, 0, true);
                    this.hidingWeatherRangedTimer.start();
                }
            }
            else if (arg2) 
            {
                if (this.hidingWeatherMeleeTimer) 
                {
                    this.hidingWeatherMeleeTimer.stop();
                    this.hidingWeatherMeleeTimer = null;
                }
                if (!this.weatherMeleeOngoing_Active) 
                {
                    trace("GFX - calling gotoAndPlay(start)");
                    this.weatherMeleeOngoing_Active = true;
                    this.weatherMeleeP1Ongoing.gotoAndPlay("start");
                    this.weatherMeleeP2Ongoing.gotoAndPlay("start");
                }
            }
            else if (!this.hidingWeatherMeleeTimer && this.weatherMeleeOngoing_Active) 
            {
                trace("GFX - starting stop timer");
                this.hidingWeatherMeleeTimer = new flash.utils.Timer(300, 1);
                this.hidingWeatherMeleeTimer.addEventListener(flash.events.TimerEvent.TIMER, this.hiddingMeleeWeatherTimerEnded, false, 0, true);
                this.hidingWeatherMeleeTimer.start();
            }
            trace("GFX ===================================-------------------------------------------------------");
            return;
        }

        public function hiddingMeleeWeatherTimerEnded(arg1:flash.events.TimerEvent):*
        {
            if (this.weatherMeleeOngoing_Active) 
            {
                this.weatherMeleeOngoing_Active = false;
                this.weatherMeleeP1Ongoing.gotoAndPlay("ending");
                this.weatherMeleeP2Ongoing.gotoAndPlay("ending");
                trace("GFX - calling gotoAndPlay(ending) - Melee");
                this.hidingWeatherMeleeTimer.stop();
                this.hidingWeatherMeleeTimer = null;
            }
            return;
        }

        public function hiddingRangeWeatherTimerEnded(arg1:flash.events.TimerEvent):*
        {
            if (this.weatherRangedOngoing_Active) 
            {
                this.weatherRangedOngoing_Active = false;
                this.weatherRangedP1Ongoing.gotoAndPlay("ending");
                this.weatherRangedP2Ongoing.gotoAndPlay("ending");
                trace("GFX - calling gotoAndPlay(ending) - Ranged");
                this.hidingWeatherRangedTimer.stop();
                this.hidingWeatherRangedTimer = null;
            }
            return;
        }

        public function hiddingSiegeWeatherTimerEnded(arg1:flash.events.TimerEvent):*
        {
            if (this.weatherSeigeOngoing_Active) 
            {
                this.weatherSeigeOngoing_Active = false;
                this.weatherSeigeP1Ongoing.gotoAndPlay("ending");
                this.weatherSeigeP2Ongoing.gotoAndPlay("ending");
                trace("GFX - calling gotoAndPlay(ending) - Siege");
                this.hidingWeatherSiegeTimer.stop();
                this.hidingWeatherSiegeTimer = null;
            }
            return;
        }

        public function get placeMeleeFXName():String
        {
            return this._placeMeleeFXName;
        }

        public function get placeRangedFXName():String
        {
            return this._placeRangedFXName;
        }

        public function set placeRangedFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._placeRangedFXName != value) 
            {
                this._placeRangedFXName = value;
                try 
                {
                    this._placeRangedFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get placeSeigeFXName():String
        {
            return this._placeSeigeFXName;
        }

        public function set placeSeigeFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._placeSeigeFXName != value) 
            {
                this._placeSeigeFXName = value;
                try 
                {
                    this._placeSeigeFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get placeSpyFXName():String
        {
            return this._placeSpyFXName;
        }

        public function set placeSpyFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._placeSpyFXName != value) 
            {
                this._placeSpyFXName = value;
                try 
                {
                    this._placeSpyFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get placeHeroFXName():String
        {
            return this._placeHeroFXName;
        }

        public function set placeHeroFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._placeHeroFXName != value) 
            {
                this._placeHeroFXName = value;
                try 
                {
                    this._placeHeroFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get resurrectFXName():String
        {
            return this._resurrectFXName;
        }

        public function set resurrectFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._resurrectFXName != value) 
            {
                this._resurrectFXName = value;
                try 
                {
                    this._resurrectFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get summonClonesFXName():String
        {
            return this._summonClonesFXName;
        }

        public function set summonClonesFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._summonClonesFXName != value) 
            {
                this._summonClonesFXName = value;
                try 
                {
                    this._summonClonesFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get moraleBoostFXName():String
        {
            return this._moraleBoostFXName;
        }

        public function set moraleBoostFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._moraleBoostFXName != value) 
            {
                this._moraleBoostFXName = value;
                try 
                {
                    this._moraleBoostFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get tightBondsFXName():String
        {
            return this._tightBondsFXName;
        }

        public function set tightBondsFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._tightBondsFXName != value) 
            {
                this._tightBondsFXName = value;
                try 
                {
                    this._tightBondsFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get summonClonesArriveFXName():String
        {
            return this._summonClonesArriveFX;
        }

        public function set summonClonesArriveFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._summonClonesArriveFX != value) 
            {
                this._summonClonesArriveFX = value;
                try 
                {
                    this._summonClonesArriveFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get hornRowFXName():String
        {
            return this._hornRowFXName;
        }

        public function set hornRowFXName(arg1:String):void
        {
            var value:String;

            var loc1:*;
            value = arg1;
            if (this._hornRowFXName != value) 
            {
                this._hornRowFXName = value;
                try 
                {
                    this._hornRowFXClassRef = flash.utils.getDefinitionByName(value) as Class;
                }
                catch (er:Error)
                {
                    trace("GFX Can\'t find class definition in your library for " + value);
                }
            }
            return;
        }

        public function get rowEffectX():Number
        {
            return this._rowEffectX;
        }

        public function set rowEffectX(arg1:Number):void
        {
            this._rowEffectX = arg1;
            return;
        }

        public function get seigeEnemyRowEffectY():Number
        {
            return this._seigeEnemyRowEffectY;
        }

        public function set seigeEnemyRowEffectY(arg1:Number):void
        {
            this._seigeEnemyRowEffectY = arg1;
            return;
        }

        public function get rangedEnemyRowEffectY():Number
        {
            return this._rangedEnemyRowEffectY;
        }

        public function set rangedEnemyRowEffectY(arg1:Number):void
        {
            this._rangedEnemyRowEffectY = arg1;
            return;
        }

        public function set meleeEnemyRowEffectY(arg1:Number):void
        {
            this._meleeEnemyRowEffectY = arg1;
            return;
        }

        public function get meleePlayerRowEffectY():Number
        {
            return this._meleePlayerRowEffectY;
        }

        public function set meleePlayerRowEffectY(arg1:Number):void
        {
            this._meleePlayerRowEffectY = arg1;
            return;
        }

        public function get rangedPlayerRowEffectY():Number
        {
            return this._rangedPlayerRowEffectY;
        }

        public function set rangedPlayerRowEffectY(arg1:Number):void
        {
            this._rangedPlayerRowEffectY = arg1;
            return;
        }

        public function get seigePlayerRowEffectY():Number
        {
            return this._seigePlayerRowEffectY;
        }

        public function set seigePlayerRowEffectY(arg1:Number):void
        {
            this._seigePlayerRowEffectY = arg1;
            return;
        }

        protected function getDeployFX(arg1:red.game.witcher3.menus.gwint.CardTemplate):Class
        {
            if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Hero)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_hero");
                return this._placeHeroFXClassRef;
            }
            if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Spy)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_spy");
                return this._placeSpyFXClassRef;
            }
            if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_RangedMelee)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_agile");
                return this._placeRangedFXClassRef;
            }
            if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Siege)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_siege_weapon");
                return this._placeSeigeFXClassRef;
            }
            if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Ranged)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_long_range");
                return this._placeRangedFXClassRef;
            }
            if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Melee)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_close_combat");
                return this._placeMeleeFXClassRef;
            }
            if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Weather)) 
            {
                if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Melee)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_frost");
                    return this._frostFXClassRef;
                }
                if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Ranged)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_fog");
                    return this._fogFXClassRef;
                }
                if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Siege)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_rain");
                    return this._rainFXClassRef;
                }
                if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ClearSky)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_clear_weather");
                    return this._clearWeatherFXClassRef;
                }
            }
            else if (arg1.isType(red.game.witcher3.menus.gwint.CardTemplate.CardType_Friendly_Effect)) 
            {
                if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy)) 
                {
                    red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_dummy");
                    return this._dummyFXClassRef;
                }
            }
            return null;
        }

        protected function getEffectFX(arg1:red.game.witcher3.menus.gwint.CardTemplate):Class
        {
            if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Horn)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_horn");
                return this._hornFXClassRef;
            }
            if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_resurrect");
                return this._resurrectFXClassRef;
            }
            if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SummonClones)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_summon_clones");
                return this._summonClonesFXClassRef;
            }
            if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SameTypeMorale)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
                return this._tightBondsFXClassRef;
            }
            if (arg1.hasEffect(red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours)) 
            {
                red.game.witcher3.menus.gwint.GwintGameMenu.mSingleton.playSound("gui_gwint_morale_boost");
                return this._moraleBoostFXClassRef;
            }
            return null;
        }

        public static function getInstance():red.game.witcher3.menus.gwint.CardFXManager
        {
            return _instance;
        }

        
        {
            _instanceIDGenerator = 0;
        }

        private var weatherParent:flash.display.MovieClip;

        public var activeFXDictionary:flash.utils.Dictionary;

        protected var _placeSpyFXName:String;

        public var _placeSpyFXClassRef:Class;

        private var weatherMeleeOngoing_Active:Boolean=false;

        private var weatherSeigeOngoing_Active:Boolean=false;

        protected var _placeHeroFXName:String;

        public var _placeHeroFXClassRef:Class;

        public var weatherMeleeP1Ongoing:flash.display.MovieClip;

        public var weatherMeleeP2Ongoing:flash.display.MovieClip;

        protected var _resurrectFXName:String;

        public var _resurrectFXClassRef:Class;

        public var weatherRangedP1Ongoing:flash.display.MovieClip;

        public var weatherRangedP2Ongoing:flash.display.MovieClip;

        protected var _summonClonesFXName:String;

        public var _summonClonesFXClassRef:Class;

        public var weatherSeigeP1Ongoing:flash.display.MovieClip;

        public var weatherSeigeP2Ongoing:flash.display.MovieClip;

        protected var _moraleBoostFXName:String;

        public var _moraleBoostFXClassRef:Class;

        protected var hidingWeatherMeleeTimer:flash.utils.Timer;

        protected var hidingWeatherRangedTimer:flash.utils.Timer;

        protected var _tightBondsFXName:String;

        public var _tightBondsFXClassRef:Class;

        protected var hidingWeatherSiegeTimer:flash.utils.Timer;

        protected var _frostFXName:String;

        protected var _summonClonesArriveFX:String;

        public var _summonClonesArriveFXClassRef:Class;

        public var _frostFXClassRef:Class;

        protected var _fogFXName:String;

        protected var _hornRowFXName:String;

        public var _hornRowFXClassRef:Class;

        public var _fogFXClassRef:Class;

        protected var _rainFXName:String;

        protected var _rowEffectX:Number;

        public var _rainFXClassRef:Class;

        protected var _clearWeatherFXName:String;

        protected var _seigeEnemyRowEffectY:Number;

        public var _clearWeatherFXClassRef:Class;

        protected var _hornFXName:String;

        protected var _rangedEnemyRowEffectY:Number;

        public var _hornFXClassRef:Class;

        protected var _scorchFXName:String;

        protected var _meleeEnemyRowEffectY:Number;

        public var _placeRangedFXClassRef:Class;

        public var _scorchFXClassRef:Class;

        protected var _meleePlayerRowEffectY:Number;

        protected var _dummyFXName:String;

        public var _dummyFXClassRef:Class;

        protected var _rangedPlayerRowEffectY:Number;

        protected var _placeMeleeFXName:String;

        public var _placeMeleeFXClassRef:Class;

        protected var _seigePlayerRowEffectY:Number;

        protected var _placeRangedFXName:String;

        private var weatherRangedOngoing_Active:Boolean=false;

        private var effectDictionary:flash.utils.Dictionary;

        private var numEffectsPlaying:int=0;

        protected static var _instance:red.game.witcher3.menus.gwint.CardFXManager;

        protected var _placeSeigeFXName:String;

        private static var _instanceIDGenerator:int=0;

        public var _placeSeigeFXClassRef:Class;
    }
}
