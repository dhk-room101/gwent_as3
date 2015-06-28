///CommonMainMenu
package red.game.witcher3.menus.mainmenu 
{
    import red.core.*;
    import red.core.events.*;
    import scaleform.clik.events.*;
    
    public class CommonMainMenu extends red.core.CoreMenu
    {
        public function CommonMainMenu()
        {
            addFrameScript(0, this.frame1);
            super();
            SHOW_ANIM_OFFSET = 0;
            SHOW_ANIM_DURATION = 2;
            return;
        }

        protected override function get menuName():String
        {
            return "CommonMainMenu";
        }

        protected override function configUI():void
        {
            super.configUI();
            dispatchEvent(new red.core.events.GameEvent(red.core.events.GameEvent.CALL, "OnConfigUI"));
            return;
        }

        protected override function handleInputNavigate(arg1:scaleform.clik.events.InputEvent):void
        {
            return;
        }

        function frame1():*
        {
            stop();
            return;
        }
    }
}


