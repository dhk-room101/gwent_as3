package red.game.witcher3.interfaces
{
    import scaleform.clik.controls.*;
    import scaleform.clik.interfaces.*;

    public interface IDragTarget extends IUIComponent
    {

        public function IDragTarget();

        function getDragData();

        function getAvatar() : UILoader;

        function canDrag() : Boolean;

        function get dragSelection() : Boolean;

        function set dragSelection(param1:Boolean) : void;

    }
}
