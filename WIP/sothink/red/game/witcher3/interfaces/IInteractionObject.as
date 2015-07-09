package red.game.witcher3.interfaces
{
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;

    public interface IInteractionObject extends IUIComponent
    {

        public function IInteractionObject();

        function executeAction(param1:Number, param2:InputEvent) : Boolean;

    }
}
