package red.game.witcher3.menus.gwint 
{
    import flash.utils.*;
    
    public class GwintCardValues extends Object
    {
        public function GwintCardValues()
        {
            super();
            return;
        }

        public function getEffectValueDictionary():flash.utils.Dictionary
        {
            if (this._bufferedDictionary == null) 
            {
                this._bufferedDictionary = new flash.utils.Dictionary();
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Horn] = this.hornCardValue;
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw] = this.drawCardValue;
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Draw2] = this.drawCardValue * 2;
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Scorch] = this.scorchCardValue;
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_SummonClones] = this.summonClonesCardValue;
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_UnsummonDummy] = this.unsummonCardValue;
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_ImproveNeighbours] = this.improveNeighboursCardValue;
                this._bufferedDictionary[red.game.witcher3.menus.gwint.CardTemplate.CardEffect_Nurse] = this.nurseCardValue;
            }
            return this._bufferedDictionary;
        }

        public var weatherCardValue:Number;

        public var hornCardValue:Number;

        public var drawCardValue:Number;

        public var scorchCardValue:Number;

        public var summonClonesCardValue:Number;

        public var unsummonCardValue:Number;

        public var improveNeighboursCardValue:Number;

        public var nurseCardValue:Number;

        private var _bufferedDictionary:flash.utils.Dictionary;
    }
}
