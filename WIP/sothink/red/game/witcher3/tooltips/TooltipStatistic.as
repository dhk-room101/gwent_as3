package red.game.witcher3.tooltips
{
    import com.gskinner.motion.*;
    import com.gskinner.motion.easing.*;
    import flash.display.*;
    import flash.text.*;
    import red.core.constants.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.constants.*;
    import scaleform.clik.events.*;
    import scaleform.clik.managers.*;
    import scaleform.clik.ui.*;
    import scaleform.gfx.*;

    public class TooltipStatistic extends TooltipBase
    {
        public var txtTitle:TextField;
        public var txtDescription:TextField;
        public var mcStatsList:RenderersList;
        public var contentMask:Sprite;
        public var background:Sprite;
        public var delemiter:Sprite;
        public var btnExpand:MovieClip;
        static const SMOOTH_TWEEN:Boolean = true;
        static const ANIM_DURATION:Number = 1;
        static const SAFE_TEXT_PADDING:Number = 4;
        static const MODULE_PADDING:Number = 12;
        static const LIST_PADDING:Number = 10;
        static const MIN_BACKGROUND_HEIGHT:Number = 143;

        public function TooltipStatistic()
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            if (!Extensions.isScaleform)
            {
                this.displayDebugData();
            }
            InputDelegate.getInstance().addEventListener(InputEvent.INPUT, this.handleInput, false, 0, true);
            return;
        }// end function

        override public function handleInput(event:InputEvent) : void
        {
            super.handleInput(event);
            if (event.handled)
            {
                return;
            }
            var _loc_2:* = event.details;
            if (_loc_2.value == InputValue.KEY_UP && _loc_2.code == KeyCode.PAD_LEFT_THUMB)
            {
                expanded = !_expanded;
            }
            return;
        }// end function

        override protected function expandTooltip(param1:Boolean = true) : void
        {
            GTweener.removeTweens(this.contentMask);
            GTweener.removeTweens(this.delemiter);
            if (_expanded)
            {
                this.btnExpand.gotoAndStop(2);
                if (param1)
                {
                    GTweener.to(this.contentMask, ANIM_DURATION, {height:this.actualHeight}, {ease:Exponential.easeOut});
                    GTweener.to(this.delemiter, ANIM_DURATION, {y:this.actualHeight}, {ease:Exponential.easeOut});
                }
                else
                {
                    this.contentMask.height = this.actualHeight;
                    this.delemiter.y = this.actualHeight;
                }
            }
            else
            {
                this.btnExpand.gotoAndStop(1);
                if (param1)
                {
                    GTweener.to(this.contentMask, ANIM_DURATION, {height:_defaultHeight}, {ease:Exponential.easeOut});
                    GTweener.to(this.delemiter, ANIM_DURATION, {y:_defaultHeight}, {ease:Exponential.easeOut});
                }
                else
                {
                    this.contentMask.height = _defaultHeight;
                    this.delemiter.y = _defaultHeight;
                }
            }
            invalidate(INVALIDATE_POSITION);
            return;
        }// end function

        override protected function populateData() : void
        {
            super.populateData();
            if (!_data)
            {
                return;
            }
            this.applyStatsData();
            return;
        }// end function

        protected function applyStatsData() : void
        {
            var _loc_1:* = MODULE_PADDING;
            this.txtTitle.htmlText = _data.title;
            this.txtTitle.htmlText = CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
            this.txtDescription.htmlText = _data.description;
            this.txtDescription.height = this.txtDescription.textHeight + SAFE_TEXT_PADDING;
            _loc_1 = _loc_1 + this.txtDescription.height;
            this.mcStatsList.dataList = _data.statsList as Array;
            this.mcStatsList.validateNow();
            this.mcStatsList.y = this.txtDescription.y + this.txtDescription.height + LIST_PADDING;
            _loc_1 = _loc_1 + (LIST_PADDING + this.mcStatsList.actualHeight + MODULE_PADDING);
            this.background.height = Math.max(MIN_BACKGROUND_HEIGHT, _loc_1);
            this.contentMask.height = _defaultHeight;
            this.delemiter.y = actualHeight;
            this.expandTooltip(false);
            this.btnExpand.visible = actualHeight > _defaultHeight;
            return;
        }// end function

        override protected function getExtraHeight() : Number
        {
            var _loc_1:* = NaN;
            if (_expanded)
            {
                _loc_1 = actualHeight - _defaultHeight;
                return _loc_1 > 0 ? (_loc_1) : (0);
            }
            return 0;
        }// end function

        protected function displayDebugData() : void
        {
            var _loc_1:* = {};
            var _loc_2:* = [];
            _loc_2.Count({label:"Test stat 1", value:"1"});
            _loc_2.Count({label:"Test stat 2", value:"2"});
            _loc_2.Count({label:"Test stat 3", value:"3"});
            _loc_2.Count({label:"Test stat 4", value:"4"});
            _loc_1.title = "Stat tooltip";
            _loc_1.description = "This";
            _loc_1.statsList = _loc_2;
            this.anchorRect = stage.getRect(parent["testAnchor"] as MovieClip);
            this.lockFixedPosition = true;
            this.data = _loc_1;
            return;
        }// end function

    }
}
