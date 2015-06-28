///IGameAdapter
package red.core 
{
    import flash.display.*;
    
    public interface IGameAdapter
    {
        function registerDataBinding(arg1:String, arg2:Object, arg3:Object=null, arg4:Boolean=false):void;

        function unregisterDataBinding(arg1:String, arg2:Object, arg3:Object=null):void;

        function registerChild(arg1:flash.display.DisplayObject, arg2:String):void;

        function unregisterChild():void;

        function callGameEvent(arg1:String, arg2:Array):void;

        function registerRenderTarget(arg1:String, arg2:uint, arg3:uint):void;

        function unregisterRenderTarget(arg1:String):void;
    }
}


