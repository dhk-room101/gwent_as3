package red.game.witcher3.menus.gwint 
{
    import red.core.*;
    import red.core.events.*;
    
    public class GwintBaseMenu extends red.core.CoreMenu
    {
        public function GwintBaseMenu()
        {
            super();
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            _restrictDirectClosing = false;
            this._cardManager = red.game.witcher3.menus.gwint.CardManager.getInstance();
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.REGISTER, "gwint.card.templates", [this.onGetCardTemplates]));
            return;
        }

        protected function onGetCardTemplates(arg1:Object, arg2:int):void
        {
            this._cardManager.onGetCardTemplates(arg1, arg2);
            return;
        }

        public var _cardManager:red.game.witcher3.menus.gwint.CardManager;
    }
}
