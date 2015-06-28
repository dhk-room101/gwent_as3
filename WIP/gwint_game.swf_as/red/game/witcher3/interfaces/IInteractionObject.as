///IInteractionObject
package red.game.witcher3.interfaces 
{
    import scaleform.clik.events.*;
    import scaleform.clik.interfaces.*;
    
    public interface IInteractionObject extends scaleform.clik.interfaces.IUIComponent
    {
        function executeAction(arg1:Number, arg2:scaleform.clik.events.InputEvent):Boolean;
    }
}


