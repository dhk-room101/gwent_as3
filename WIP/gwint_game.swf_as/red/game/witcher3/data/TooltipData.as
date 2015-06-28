///TooltipData
package red.game.witcher3.data 
{
    import flash.display.*;
    import flash.geom.*;
    
    public class TooltipData extends Object
    {
        public function TooltipData(arg1:String="", arg2:String="")
        {
            super();
            this.viewerClass = arg1;
            this.dataSource = arg2;
            return;
        }

        public var viewerClass:String;

        public var dataSource:String;

        public var anchor:flash.display.DisplayObject;

        public var anchorRect:flash.geom.Rectangle;

        public var isMouseTooltip:Boolean;

        public var directData:Boolean;

        public var description:String;

        public var label:String;

        public var isComparisonMode:Boolean;
    }
}


