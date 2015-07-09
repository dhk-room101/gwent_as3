package red.game.witcher3.menus.gwint
{
    import red.core.*;
    import red.core.events.*;

    public class GwintBaseMenu extends CoreMenu
    {
        public var _cardManager:CardManager;

        public function GwintBaseMenu()
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            _restrictDirectClosing = false;
            this._cardManager = CardManager.getInstance();
            dispatchEvent(new GameEvent(GameEvent.REGISTER, "gwint.card.templates", [this.onGetCardTemplates]));
            return;
        }// end function

        protected function onGetCardTemplates(param1:Object, param2:int) : void
        {
            this._cardManager.onGetCardTemplates(param1, param2);
            return;
        }// end function

    }
}
