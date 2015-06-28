///TooltipStatistic
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
    
    public class TooltipStatistic extends red.game.witcher3.tooltips.TooltipBase
    {
        public function TooltipStatistic()
        {
            super();
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            if (!scaleform.gfx.Extensions.isScaleform) 
            {
                this.displayDebugData();
            }
            scaleform.clik.managers.InputDelegate.getInstance().addEventListener(scaleform.clik.events.InputEvent.INPUT, this.handleInput, false, 0, true);
            return;
        }

        public override function handleInput(arg1:scaleform.clik.events.InputEvent):void
        {
            super.handleInput(arg1);
            if (arg1.handled) 
            {
                return;
            }
            var loc1:*=arg1.details;
            if (loc1.value == scaleform.clik.constants.InputValue.KEY_UP && loc1.code == red.core.constants.KeyCode.PAD_LEFT_THUMB) 
            {
                expanded = !_expanded;
            }
            return;
        }

        protected override function expandTooltip(arg1:Boolean=true):void
        {
            com.gskinner.motion.GTweener.removeTweens(this.contentMask);
            com.gskinner.motion.GTweener.removeTweens(this.delemiter);
            if (_expanded) 
            {
                this.btnExpand.gotoAndStop(2);
                if (arg1) 
                {
                    com.gskinner.motion.GTweener.to(this.contentMask, ANIM_DURATION, {"height":this.actualHeight}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
                    com.gskinner.motion.GTweener.to(this.delemiter, ANIM_DURATION, {"y":this.actualHeight}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
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
                if (arg1) 
                {
                    com.gskinner.motion.GTweener.to(this.contentMask, ANIM_DURATION, {"height":_defaultHeight}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
                    com.gskinner.motion.GTweener.to(this.delemiter, ANIM_DURATION, {"y":_defaultHeight}, {"ease":com.gskinner.motion.easing.Exponential.easeOut});
                }
                else 
                {
                    this.contentMask.height = _defaultHeight;
                    this.delemiter.y = _defaultHeight;
                }
            }
            invalidate(INVALIDATE_POSITION);
            return;
        }

        protected override function populateData():void
        {
            super.populateData();
            if (!_data) 
            {
                return;
            }
            this.applyStatsData();
            return;
        }

        protected function applyStatsData():void
        {
            var loc1:*=MODULE_PADDING;
            this.txtTitle.htmlText = _data.title;
            this.txtTitle.htmlText = red.game.witcher3.utils.CommonUtils.toUpperCaseSafe(this.txtTitle.htmlText);
            this.txtDescription.htmlText = _data.description;
            this.txtDescription.height = this.txtDescription.textHeight + SAFE_TEXT_PADDING;
            loc1 = loc1 + this.txtDescription.height;
            this.mcStatsList.dataList = _data.statsList as Array;
            this.mcStatsList.validateNow();
            this.mcStatsList.y = this.txtDescription.y + this.txtDescription.height + LIST_PADDING;
            loc1 = loc1 + (LIST_PADDING + this.mcStatsList.actualHeight + MODULE_PADDING);
            this.background.height = Math.max(MIN_BACKGROUND_HEIGHT, loc1);
            this.contentMask.height = _defaultHeight;
            this.delemiter.y = actualHeight;
            this.expandTooltip(false);
            this.btnExpand.visible = actualHeight > _defaultHeight;
            return;
        }

        protected override function getExtraHeight():Number
        {
            var loc1:*=NaN;
            if (_expanded) 
            {
                loc1 = actualHeight - _defaultHeight;
                return loc1 > 0 ? loc1 : 0;
            }
            return 0;
        }

        protected function displayDebugData():void
        {
            var loc1:*={};
            var loc2:*=[];
            loc2.push({"label":"Test stat 1", "value":"1"});
            loc2.push({"label":"Test stat 2", "value":"2"});
            loc2.push({"label":"Test stat 3", "value":"3"});
            loc2.push({"label":"Test stat 4", "value":"4"});
            loc1.title = "Stat tooltip";
            loc1.description = "This";
            loc1.statsList = loc2;
            this.anchorRect = stage.getRect(parent["testAnchor"] as flash.display.MovieClip);
            this.lockFixedPosition = true;
            this.data = loc1;
            return;
        }

        protected static const SMOOTH_TWEEN:Boolean=true;

        protected static const ANIM_DURATION:Number=1;

        protected static const SAFE_TEXT_PADDING:Number=4;

        protected static const MODULE_PADDING:Number=12;

        protected static const LIST_PADDING:Number=10;

        protected static const MIN_BACKGROUND_HEIGHT:Number=143;

        public var txtTitle:flash.text.TextField;

        public var txtDescription:flash.text.TextField;

        public var mcStatsList:red.game.witcher3.controls.RenderersList;

        public var contentMask:flash.display.Sprite;

        public var background:flash.display.Sprite;

        public var delemiter:flash.display.Sprite;

        public var btnExpand:flash.display.MovieClip;
    }
}


