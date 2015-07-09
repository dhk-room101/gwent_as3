package red.game.witcher3.tooltips
{
    import flash.display.*;
    import flash.text.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.core.*;

    public class TooltipPrimaryStat extends UIComponent
    {
        public var tfValue:TextField;
        public var tfLabel:TextField;
        public var tfDiffValue:TextField;
        public var txtDurabilityPrefix:TextField;
        public var txtDurabilityPostfix:TextField;
        public var mcComparisonIcon:MovieClip;
        public var mcDurabilityIcon:Sprite;
        private var diffPosition:Number;
        static const SMALL_PADDING:Number = 2;
        static const STAT_NAME_PADDING:Number = 3;
        static const ICON_PADDING:Number = 10;

        public function TooltipPrimaryStat()
        {
            return;
        }// end function

        public function setValue(param1:Number, param2:String, param3:String = "none", param4:Number = 0, param5:String = "", param6:Number = 0) : void
        {
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_7:* = 0;
            if (param4 > 0)
            {
                _loc_8 = param1 * param4;
                _loc_9 = Math.round(param1 - _loc_8);
                _loc_10 = Math.round(param1 + _loc_8);
                if (_loc_9 != _loc_10)
                {
                    this.tfValue.htmlText = _loc_9 + " - " + _loc_10;
                }
                else
                {
                    this.tfValue.htmlText = String(_loc_10);
                }
            }
            else
            {
                this.tfValue.htmlText = String(Math.round(param1));
            }
            this.tfValue.width = this.tfValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            _loc_7 = this.tfValue.x + this.tfValue.textWidth + SMALL_PADDING;
            if (this.txtDurabilityPrefix && this.txtDurabilityPostfix && this.mcDurabilityIcon)
            {
                if (param6 > 0)
                {
                    this.txtDurabilityPrefix.visible = true;
                    this.txtDurabilityPrefix.text = "(-" + param6;
                    this.txtDurabilityPrefix.width = this.txtDurabilityPrefix.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                    this.txtDurabilityPrefix.x = _loc_7;
                    _loc_7 = _loc_7 + (this.txtDurabilityPrefix.textWidth + SMALL_PADDING * 2);
                    this.mcDurabilityIcon.visible = true;
                    this.mcDurabilityIcon.x = _loc_7;
                    _loc_7 = _loc_7 + this.mcDurabilityIcon.width;
                    this.txtDurabilityPostfix.visible = true;
                    this.txtDurabilityPostfix.text = ")";
                    this.txtDurabilityPostfix.width = this.txtDurabilityPostfix.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                    this.txtDurabilityPostfix.x = _loc_7;
                    _loc_7 = _loc_7 + this.txtDurabilityPostfix.width;
                }
                else
                {
                    this.txtDurabilityPrefix.visible = false;
                    this.txtDurabilityPostfix.visible = false;
                    this.mcDurabilityIcon.visible = false;
                    _loc_7 = _loc_7 + STAT_NAME_PADDING;
                }
            }
            else
            {
                _loc_7 = _loc_7 + STAT_NAME_PADDING;
            }
            if (param2)
            {
                this.tfLabel.htmlText = param2;
                this.tfLabel.htmlText = CommonUtils.toUpperCaseSafe(this.tfLabel.htmlText);
            }
            this.tfLabel.width = this.tfLabel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            this.tfLabel.x = _loc_7;
            _loc_7 = this.tfLabel.x + this.tfLabel.width + ICON_PADDING;
            if (this.mcComparisonIcon)
            {
                if (param3 && param3 != "none")
                {
                    this.mcComparisonIcon.visible = true;
                    this.mcComparisonIcon.gotoAndStop(param3);
                    this.mcComparisonIcon.x = _loc_7;
                    _loc_7 = _loc_7 + ICON_PADDING;
                }
                else
                {
                    this.mcComparisonIcon.visible = false;
                    this.mcComparisonIcon.x = this.mcComparisonIcon.width / 2;
                }
            }
            if (this.tfDiffValue)
            {
                if (param5)
                {
                    this.tfDiffValue.htmlText = param5;
                    this.tfDiffValue.width = this.tfDiffValue.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                    this.tfDiffValue.x = _loc_7;
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
        }// end function

    }
}
