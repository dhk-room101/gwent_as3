///TooltipPrimaryStat
package red.game.witcher3.tooltips 
{
    import flash.display.*;
    import flash.text.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.core.*;
    
    public class TooltipPrimaryStat extends scaleform.clik.core.UIComponent
    {
        public function TooltipPrimaryStat()
        {
            super();
            return;
        }

        public function setValue(arg1:Number, arg2:String, arg3:String="none", arg4:Number=0, arg5:String="", arg6:Number=0):void
        {
            var loc2:*=NaN;
            var loc3:*=NaN;
            var loc4:*=NaN;
            var loc1:*=0;
            if (arg4 > 0) 
            {
                loc2 = arg1 * arg4;
                loc3 = Math.round(arg1 - loc2);
                loc4 = Math.round(arg1 + loc2);
                if (loc3 == loc4) 
                {
                    this.tfValue.htmlText = String(loc4);
                }
                else 
                {
                    this.tfValue.htmlText = loc3 + " - " + loc4;
                }
            }
            else 
            {
                this.tfValue.htmlText = String(Math.round(arg1));
            }
            this.tfValue.width = this.tfValue.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
            loc1 = this.tfValue.x + this.tfValue.textWidth + SMALL_PADDING;
            if (this.txtDurabilityPrefix && this.txtDurabilityPostfix && this.mcDurabilityIcon) 
            {
                if (arg6 > 0) 
                {
                    this.txtDurabilityPrefix.visible = true;
                    this.txtDurabilityPrefix.text = "(-" + arg6;
                    this.txtDurabilityPrefix.width = this.txtDurabilityPrefix.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                    this.txtDurabilityPrefix.x = loc1;
                    loc1 = loc1 + (this.txtDurabilityPrefix.textWidth + SMALL_PADDING * 2);
                    this.mcDurabilityIcon.visible = true;
                    this.mcDurabilityIcon.x = loc1;
                    loc1 = loc1 + this.mcDurabilityIcon.width;
                    this.txtDurabilityPostfix.visible = true;
                    this.txtDurabilityPostfix.text = ")";
                    this.txtDurabilityPostfix.width = this.txtDurabilityPostfix.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                    this.txtDurabilityPostfix.x = loc1;
                    loc1 = loc1 + this.txtDurabilityPostfix.width;
                }
                else 
                {
                    this.txtDurabilityPrefix.visible = false;
                    this.txtDurabilityPostfix.visible = false;
                    this.mcDurabilityIcon.visible = false;
                }
            }
            if (arg2) 
            {
                this.tfLabel.htmlText = arg2;
                this.tfLabel.htmlText = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(this.tfLabel.htmlText);
            }
            this.tfLabel.width = this.tfLabel.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
            this.tfLabel.x = loc1;
            loc1 = this.tfLabel.x + this.tfLabel.width + ICON_PADDING;
            if (this.mcComparisonIcon) 
            {
                if (arg3 && !(arg3 == "none")) 
                {
                    this.mcComparisonIcon.visible = true;
                    this.mcComparisonIcon.gotoAndStop(arg3);
                    this.mcComparisonIcon.x = loc1;
                    loc1 = loc1 + ICON_PADDING;
                }
                else 
                {
                    this.mcComparisonIcon.visible = false;
                    this.mcComparisonIcon.x = this.mcComparisonIcon.width / 2;
                }
            }
            if (this.tfDiffValue) 
            {
                if (arg5) 
                {
                    this.tfDiffValue.htmlText = arg5;
                    this.tfDiffValue.width = this.tfDiffValue.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                    this.tfDiffValue.x = loc1;
                    this.tfDiffValue.visible = true;
                }
                else 
                {
                    this.tfDiffValue.x = 0;
                    this.tfDiffValue.width = 0;
                    this.tfDiffValue.visible = false;
                }
            }
            return;
        }

        protected static const SMALL_PADDING:Number=2;

        protected static const ICON_PADDING:Number=10;

        public var tfValue:flash.text.TextField;

        public var tfLabel:flash.text.TextField;

        public var tfDiffValue:flash.text.TextField;

        public var txtDurabilityPrefix:flash.text.TextField;

        public var txtDurabilityPostfix:flash.text.TextField;

        public var mcComparisonIcon:flash.display.MovieClip;

        public var mcDurabilityIcon:flash.display.Sprite;

        internal var diffPosition:Number;
    }
}


