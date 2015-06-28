///TooltipInventory
package red.game.witcher3.tooltips 
{
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.controls.*;
    import scaleform.gfx.*;
    
    public class TooltipInventory extends red.game.witcher3.tooltips.TooltipBase
    {
        public function TooltipInventory()
        {
            super();
            visible = false;
            this.mcPropertyList.alignment = flash.text.TextFormatAlign.RIGHT;
            this.mcSocketList.isHorizontal = false;
            this.mcPropertyList.itemPadding = 0;
            this.mcAttributeList.itemPadding = 0;
            this.mcSocketList.itemPadding = 0;
            return;
        }

        protected function applyDebugData():void
        {
            var loc1:*={};
            loc1.PrimaryStatLabel = "damage";
            loc1.PrimaryStatValue = "10";
            loc1.ItemName = "Witcher Sword";
            loc1.ItemRarity = "Cool";
            loc1.ItemType = "Sword";
            loc1.CommonDescription = "Common Description";
            loc1.UniqDescription = "Sword Description";
            loc1.SocketsDescription = "ddddddddddddd";
            var loc2:*=[];
            loc2.push({"type":"attack", "value":"10", "icon":"better"});
            loc2.push({"type":"attack", "value":"10", "icon":"better"});
            loc2.push({"type":"attack", "value":"10", "icon":"wayBetter"});
            loc2.push({"type":"attack", "value":"10", "icon":"none"});
            loc1.GenericStatsList = loc2;
            var loc3:*=[];
            loc3.push({"type":"notforsale", "label":"", "value":""});
            loc3.push({"type":"price", "label":"price", "value":"100"});
            loc3.push({"type":"weight", "label":"weight", "value":"50"});
            loc3.push({"type":"repair", "label":"repair", "value":"10"});
            loc1.PropertiesList = loc3;
            this.anchorRect = new flash.geom.Rectangle((parent["testAnchor"] as flash.display.MovieClip).x, (parent["testAnchor"] as flash.display.MovieClip).y, 0, 0);
            this.lockFixedPosition = true;
            this.data = loc1;
            return;
        }

        public function get backgroundVisibility():Boolean
        {
            return this._backgroundVisibility;
        }

        public function set backgroundVisibility(arg1:Boolean):void
        {
            this._backgroundVisibility = arg1;
            if (this.mcBackground) 
            {
                this.mcBackground.gotoAndStop(this._backgroundVisibility ? "solid" : "transparent");
            }
            return;
        }

        protected override function configUI():void
        {
            super.configUI();
            if (!scaleform.gfx.Extensions.isScaleform) 
            {
                this.applyDebugData();
            }
            return;
        }

        protected override function populateData():void
        {
            super.populateData();
            if (!_data) 
            {
                return;
            }
            this.populateItemData();
            visible = true;
            return;
        }

        protected function populateItemData():*
        {
            var loc1:*=NaN;
            var loc7:*=null;
            var loc8:*=null;
            loc1 = 0;
            var loc2:*=0;
            var loc3:*=0;
            var loc4:*=40;
            var loc5:*=0;
            if (_data.EquippedTitle) 
            {
                applyTextValue(this.tfEquippedTitle, _data.EquippedTitle, true, true);
                if (this.tfWarningMessage) 
                {
                    this.tfWarningMessage.visible = false;
                }
                this.mcBackground.y = -loc4;
                loc5 = loc4 + this.EQUIPPED_TOOLTIP_PADDING_X;
            }
            else 
            {
                if (this.tfEquippedTitle) 
                {
                    this.tfEquippedTitle.visible = false;
                }
                applyTextValue(this.tfWarningMessage, _data.WarningMessage, false, true);
            }
            applyTextValue(this.tfItemName, _data.ItemName, true, true);
            applyTextValue(this.tfItemType, _data.ItemType, true);
            applyTextValue(this.tfItemRarity, _data.ItemRarity, true);
            applyTextValue(this.tfRequiredLevel, _data.RequiredLevel, false);
            if (this.tfItemType) 
            {
                this.tfItemType.width = this.tfItemType.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                this.tfItemType.x = this.CONTENT_RIGHT_EDGE_POS - this.tfItemType.width;
            }
            if (this.tfItemRarity) 
            {
                this.tfItemRarity.width = this.tfItemRarity.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                this.tfItemRarity.x = this.CONTENT_RIGHT_EDGE_POS - this.tfItemRarity.width;
            }
            if (this.tfRequiredLevel && _data.RequiredLevel) 
            {
                loc3 = this.delDescription.y + this.LIST_OFFSET;
            }
            else 
            {
                loc3 = this.delTitle.y + this.LIST_OFFSET;
            }
            if (_data.PrimaryStatValue > 0) 
            {
                this.mcPrimaryStat.setValue(data.PrimaryStatValue, data.PrimaryStatLabel, data.PrimaryStatDiff, _data.PrimaryStatDelta, data.PrimaryStatDiffStr, data.PrimaryStatDurabilityPenalty);
                this.mcPrimaryStat.visible = true;
                this.delDescription.visible = true;
                this.delDescription.width = this.mcPrimaryStat.actualWidth;
                loc2 = this.delDescription.y + this.LIST_OFFSET;
            }
            else 
            {
                this.delDescription.visible = false;
                this.mcPrimaryStat.visible = false;
                loc2 = this.delTitle.y + this.LIST_OFFSET;
            }
            applyTextValue(this.tfDescription, _data.Description, false, true);
            if (this.tfDescription && _data.Description) 
            {
                this.tfDescription.y = loc2;
                loc2 = loc2 + this.tfDescription.height;
            }
            if (this.mcPropertyList) 
            {
                this.mcPropertyList.dataList = _data.PropertiesList as Array;
                this.mcPropertyList.validateNow();
                this.mcPropertyList.y = loc3;
                loc3 = loc3 + (this.mcPropertyList.actualHeight + this.BLOCK_PADDING);
            }
            var loc6:*=_data.StatsList as Array;
            if (this.mcAttributeList && loc6) 
            {
                this.mcAttributeList.y = loc2;
                this.mcAttributeList.dataList = loc6;
                this.mcAttributeList.validateNow();
                this.mcAttributeList.visible = true;
                loc2 = this.mcAttributeList.y + this.mcAttributeList.actualHeight + this.BLOCK_PADDING;
            }
            else 
            {
                this.mcAttributeList.visible = false;
            }
            loc1 = Math.max(loc2, loc3);
            loc7 = _data.SocketsList as Array;
            if (this.mcSocketList && loc7) 
            {
                this.mcSocketList.y = loc1;
                this.mcSocketList.dataList = loc7;
                this.mcSocketList.validateNow();
                this.mcSocketList.visible = true;
                loc1 = loc1 + (this.mcSocketList.actualHeight + this.BLOCK_PADDING);
            }
            else 
            {
                this.mcSocketList.visible = false;
            }
            if (_data.appliedOilInfo) 
            {
                (loc8 = this.mcOilInfo["textField"]).htmlText = _data.appliedOilInfo;
                loc8.width = loc8.textWidth + red.game.witcher3.constants.CommonConstants.SAFE_TEXT_PADDING;
                this.mcOilInfo.y = loc1;
                this.mcOilInfo.visible = true;
                loc1 = loc1 + (this.mcOilInfo.height + this.BLOCK_PADDING);
            }
            else 
            {
                this.mcOilInfo.visible = false;
            }
            if (_data.equippedItemData) 
            {
                this.createComparisonTooltip(_data.equippedItemData);
            }
            this.mcBackground.height = loc1 + loc5;
            return;
        }

        public function showEquippedTooltip(arg1:Boolean):void
        {
            this._comparisonMode = arg1;
            if (this._comparisonTooltip) 
            {
                this._comparisonTooltip.visible = arg1;
            }
            return;
        }

        protected function createComparisonTooltip(arg1:Object):void
        {
            if (this._comparisonTooltip) 
            {
                removeChild(this._comparisonTooltip);
                this._comparisonTooltip = null;
            }
            var loc1:*=flash.utils.getDefinitionByName("ItemTooltipRef") as Class;
            this._comparisonTooltip = new loc1() as red.game.witcher3.tooltips.TooltipInventory;
            this._comparisonTooltip.x = this.mcBackground.x + this.mcBackground.width + this.EQUIPPED_TOOLTIP_PADDING_X;
            this._comparisonTooltip.y = -this.EQUIPPED_TOOLTIP_PADDING_Y;
            this._comparisonTooltip.isMouseTooltip = false;
            this._comparisonTooltip.lockFixedPosition = true;
            this._comparisonTooltip.backgroundVisibility = true;
            this._comparisonTooltip.data = arg1;
            addChild(this._comparisonTooltip);
            this._comparisonTooltip.validateNow();
            this._comparisonTooltip.visible = this._comparisonMode;
            return;
        }

        protected const BACKGROUND_PADDING:Number=5;

        protected const EQUIPPED_TOOLTIP_PADDING_X:Number=15;

        protected const EQUIPPED_TOOLTIP_PADDING_Y:Number=40;

        protected const LIST_OFFSET:Number=15;

        protected const BLOCK_PADDING:Number=5;

        protected const LIST_PADDING:Number=15;

        protected const BOTTOM_SMALL_PADDING:Number=2;

        protected const CONTENT_RIGHT_EDGE_POS:Number=586;

        public var tfEquippedTitle:flash.text.TextField;

        public var tfItemName:flash.text.TextField;

        public var tfItemRarity:flash.text.TextField;

        public var tfItemType:flash.text.TextField;

        public var tfDescription:flash.text.TextField;

        public var tfRequiredLevel:flash.text.TextField;

        public var tfWarningMessage:flash.text.TextField;

        public var mcAttributeList:red.game.witcher3.controls.RenderersList;

        protected var _backgroundVisibility:Boolean;

        protected var _comparisonMode:Boolean;

        public var mcSocketList:red.game.witcher3.controls.RenderersList;

        public var mcPrimaryStat:red.game.witcher3.tooltips.TooltipPrimaryStat;

        public var mcOilInfo:flash.display.MovieClip;

        public var mcBackground:flash.display.MovieClip;

        public var delDescription:flash.display.Sprite;

        public var delTitle:flash.display.Sprite;

        protected var _comparisonTooltip:red.game.witcher3.tooltips.TooltipInventory;

        public var mcPropertyList:red.game.witcher3.controls.RenderersList;
    }
}


