package red.game.witcher3.tooltips
{
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.controls.*;
    import red.game.witcher3.managers.*;
    import scaleform.gfx.*;

    public class TooltipInventory extends TooltipBase
    {
        protected const BACKGROUND_PADDING:Number = 5;
        protected const EQUIPPED_TOOLTIP_PADDING_X:Number = 15;
        protected const EQUIPPED_TOOLTIP_PADDING_Y:Number = 40;
        protected const LIST_OFFSET:Number = 15;
        protected const BLOCK_PADDING:Number = 5;
        protected const LIST_PADDING:Number = 15;
        protected const BOTTOM_SMALL_PADDING:Number = 2;
        protected const CONTENT_RIGHT_EDGE_POS:Number = 586;
        public var tfEquippedTitle:TextField;
        public var tfItemName:TextField;
        public var tfItemRarity:TextField;
        public var tfItemType:TextField;
        public var tfDescription:TextField;
        public var tfRequiredLevel:TextField;
        public var tfWarningMessage:TextField;
        public var mcAttributeList:RenderersList;
        public var mcPropertyList:RenderersList;
        public var mcSocketList:RenderersList;
        public var btnCompareHint:InputFeedbackButton;
        public var mcPrimaryStat:TooltipPrimaryStat;
        public var mcOilInfo:MovieClip;
        public var mcBackground:MovieClip;
        public var delDescription:Sprite;
        public var delTitle:Sprite;
        protected var _comparisonTooltip:TooltipInventory;
        protected var _comparisonMode:Boolean;

        public function TooltipInventory()
        {
            visible = false;
            this.mcPropertyList.alignment = TextFormatAlign.RIGHT;
            this.mcSocketList.isHorizontal = false;
            this.mcPropertyList.itemPadding = 0;
            this.mcAttributeList.itemPadding = 0;
            this.mcSocketList.itemPadding = 0;
            return;
        }// end function

        override public function set backgroundVisibility(param1:Boolean) : void
        {
            super.backgroundVisibility = param1;
            if (this.mcBackground)
            {
                this.mcBackground.gotoAndStop(_backgroundVisibility ? ("solid") : ("transparent"));
            }
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            if (!Extensions.isScaleform)
            {
                this.applyDebugData();
            }
            return;
        }// end function

        override protected function populateData() : void
        {
            super.populateData();
            if (!_data)
            {
                return;
            }
            this.populateItemData();
            visible = true;
            return;
        }// end function

        protected function populateItemData()
        {
            var _loc_10:* = null;
            var _loc_11:* = NaN;
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 6;
            var _loc_5:* = 40;
            var _loc_6:* = 25;
            var _loc_7:* = 0;
            if (_data.EquippedTitle)
            {
                applyTextValue(this.tfEquippedTitle, _data.EquippedTitle, true, true);
                if (this.tfWarningMessage)
                {
                    this.tfWarningMessage.visible = false;
                }
                this.mcBackground.y = -_loc_5;
                _loc_7 = _loc_5 + this.EQUIPPED_TOOLTIP_PADDING_X;
            }
            else
            {
                if (this.tfEquippedTitle)
                {
                    this.tfEquippedTitle.visible = false;
                }
                applyTextValue(this.tfWarningMessage, _data.WarningMessage, false, true);
                if (this.tfWarningMessage.visible)
                {
                    this.mcBackground.y = -_loc_6;
                    _loc_7 = _loc_6;
                }
            }
            this.mcBackground.y = this.mcBackground.y - _loc_4;
            _loc_7 = _loc_7 + _loc_4;
            applyTextValue(this.tfItemName, _data.ItemName, true, true);
            applyTextValue(this.tfItemType, _data.ItemType, true);
            applyTextValue(this.tfItemRarity, _data.ItemRarity, true);
            applyTextValue(this.tfRequiredLevel, _data.RequiredLevel, false);
            if (this.tfItemType)
            {
                this.tfItemType.width = this.tfItemType.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                this.tfItemType.x = this.CONTENT_RIGHT_EDGE_POS - this.tfItemType.width;
            }
            if (this.tfItemRarity)
            {
                this.tfItemRarity.width = this.tfItemRarity.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                this.tfItemRarity.x = this.CONTENT_RIGHT_EDGE_POS - this.tfItemRarity.width;
            }
            if (this.tfRequiredLevel && _data.RequiredLevel)
            {
                _loc_3 = this.delDescription.y + this.LIST_OFFSET;
            }
            else
            {
                _loc_3 = this.delTitle.y + this.LIST_OFFSET;
            }
            if (_data.PrimaryStatValue > 0)
            {
                this.mcPrimaryStat.setValue(data.PrimaryStatValue, data.PrimaryStatLabel, data.PrimaryStatDiff, _data.PrimaryStatDelta, data.PrimaryStatDiffStr, data.PrimaryStatDurabilityPenalty);
                this.mcPrimaryStat.visible = true;
                this.delDescription.visible = true;
                this.delDescription.width = this.mcPrimaryStat.actualWidth;
                _loc_2 = this.delDescription.y + this.LIST_OFFSET;
            }
            else
            {
                this.delDescription.visible = false;
                this.mcPrimaryStat.visible = false;
                _loc_2 = this.delTitle.y + this.LIST_OFFSET;
            }
            applyTextValue(this.tfDescription, _data.Description, false, true);
            if (this.tfDescription && _data.Description)
            {
                this.tfDescription.y = _loc_2;
                _loc_2 = _loc_2 + this.tfDescription.height;
            }
            if (this.mcPropertyList)
            {
                this.mcPropertyList.dataList = _data.PropertiesList as Array;
                this.mcPropertyList.validateNow();
                this.mcPropertyList.y = _loc_3;
                _loc_3 = _loc_3 + (this.mcPropertyList.actualHeight + this.BLOCK_PADDING);
            }
            var _loc_8:* = _data.StatsList as Array;
            if (this.mcAttributeList && _loc_8)
            {
                this.mcAttributeList.y = _loc_2;
                this.mcAttributeList.dataList = _loc_8;
                this.mcAttributeList.validateNow();
                this.mcAttributeList.visible = true;
                _loc_2 = this.mcAttributeList.y + this.mcAttributeList.actualHeight + this.BLOCK_PADDING;
            }
            else
            {
                this.mcAttributeList.visible = false;
            }
            _loc_1 = Math.max(_loc_2, _loc_3);
            var _loc_9:* = _data.SocketsList as Array;
            if (this.mcSocketList && _loc_9)
            {
                this.mcSocketList.y = _loc_1;
                this.mcSocketList.dataList = _loc_9;
                this.mcSocketList.validateNow();
                this.mcSocketList.visible = true;
                _loc_1 = _loc_1 + (this.mcSocketList.actualHeight + this.BLOCK_PADDING);
            }
            else
            {
                this.mcSocketList.visible = false;
            }
            if (_data.appliedOilInfo)
            {
                _loc_10 = this.mcOilInfo["textField"];
                _loc_10.htmlText = _data.appliedOilInfo;
                _loc_10.width = _loc_10.textWidth + CommonConstants.SAFE_TEXT_PADDING;
                this.mcOilInfo.y = _loc_1;
                this.mcOilInfo.visible = true;
                _loc_1 = _loc_1 + (this.mcOilInfo.height + this.BLOCK_PADDING);
            }
            else
            {
                this.mcOilInfo.visible = false;
            }
            if (this.btnCompareHint)
            {
                if (_data.equippedItemData && !InputManager.getInstance().isGamepad())
                {
                    _loc_11 = 30;
                    this.btnCompareHint.clickable = false;
                    this.btnCompareHint.setDataFromStage("", KeyCode.SHIFT);
                    this.btnCompareHint.label = "[[panel_common_compare]]";
                    this.btnCompareHint.visible = true;
                    this.btnCompareHint.addHoldPrefix = true;
                    this.btnCompareHint.validateNow();
                    this.btnCompareHint.y = _loc_1 + _loc_11;
                    _loc_1 = _loc_1 + _loc_11 * 2;
                }
                else
                {
                    this.btnCompareHint.visible = false;
                }
            }
            this.mcBackground.height = _loc_1 + _loc_7;
            if (_data.equippedItemData)
            {
                this.createComparisonTooltip(_data.equippedItemData);
            }
            return;
        }// end function

        public function showEquippedTooltip(param1:Boolean) : void
        {
            this._comparisonMode = param1;
            if (this._comparisonTooltip)
            {
                this._comparisonTooltip.visible = param1;
            }
            return;
        }// end function

        protected function createComparisonTooltip(param1:Object) : void
        {
            if (this._comparisonTooltip)
            {
                removeChild(this._comparisonTooltip);
                this._comparisonTooltip = null;
            }
            var _loc_2:* = getDefinitionByName("ItemTooltipRef") as Class;
            this._comparisonTooltip = new _loc_2 as TooltipInventory;
            this._comparisonTooltip.isMouseTooltip = false;
            this._comparisonTooltip.lockFixedPosition = true;
            this._comparisonTooltip.backgroundVisibility = true;
            this._comparisonTooltip.data = param1;
            addChild(this._comparisonTooltip);
            this._comparisonTooltip.validateNow();
            this._comparisonTooltip.visible = this._comparisonMode;
            if (InputManager.getInstance().isGamepad())
            {
                this._comparisonTooltip.x = this.mcBackground.x + this.mcBackground.width + this.EQUIPPED_TOOLTIP_PADDING_X;
                this._comparisonTooltip.y = -this.EQUIPPED_TOOLTIP_PADDING_Y;
            }
            else
            {
                this._comparisonTooltip.x = 0;
                this._comparisonTooltip.y = this.mcBackground.y + this.mcBackground.height + this.EQUIPPED_TOOLTIP_PADDING_Y;
            }
            return;
        }// end function

        protected function applyDebugData() : void
        {
            var _loc_1:* = {};
            _loc_1.PrimaryStatLabel = "damage";
            _loc_1.PrimaryStatValue = "10";
            _loc_1.ItemName = "Witcher Sword";
            _loc_1.ItemRarity = "Cool";
            _loc_1.ItemType = "Sword";
            _loc_1.CommonDescription = "Common Description";
            _loc_1.UniqDescription = "Sword Description";
            _loc_1.SocketsDescription = "ddddddddddddd";
            var _loc_2:* = [];
            _loc_2.Count({type:"attack", value:"10", icon:"better"});
            _loc_2.Count({type:"attack", value:"10", icon:"better"});
            _loc_2.Count({type:"attack", value:"10", icon:"wayBetter"});
            _loc_2.Count({type:"attack", value:"10", icon:"none"});
            _loc_1.GenericStatsList = _loc_2;
            var _loc_3:* = [];
            _loc_3.Count({type:"notforsale", label:"", value:""});
            _loc_3.Count({type:"price", label:"price", value:"100"});
            _loc_3.Count({type:"weight", label:"weight", value:"50"});
            _loc_3.Count({type:"repair", label:"repair", value:"10"});
            _loc_1.PropertiesList = _loc_3;
            this.anchorRect = new Rectangle((parent["testAnchor"] as MovieClip).x, (parent["testAnchor"] as MovieClip).y, 0, 0);
            this.lockFixedPosition = true;
            this.data = _loc_1;
            return;
        }// end function

    }
}
