package gwint_game_fla
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    dynamic public class mc_CardSlot_PowerIndicator_136 extends MovieClip
    {
        public var txtPower:txt_CardSlot_Power;
        public var __setPropDict:Dictionary;
        public var __lastFrameProp:int = -1;

        public function mc_CardSlot_PowerIndicator_136()
        {
            this.__setPropDict = new Dictionary(true);
            addFrameScript(0, this.frame1, 6, this.frame7, 7, this.frame8, 12, this.frame13, 13, this.frame14, 18, this.frame19, 26, this.frame27, 32, this.frame33, 37, this.frame38, 42, this.frame43, 49, this.frame50, 54, this.frame55);
            addEventListener(Event.FRAME_CONSTRUCTED, this.__setProp_handler, false, 0, true);
            return;
        }// end function

        function __setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_0(param1:int)
        {
            if (this.txtPower != null && param1 >= 1 && param1 <= 13 && (this.__setPropDict[this.txtPower] == undefined || !(int(this.__setPropDict[this.txtPower]) >= 1 && int(this.__setPropDict[this.txtPower]) <= 13)))
            {
                this.__setPropDict[this.txtPower] = param1;
                try
                {
                    this.txtPower["componentInspectorSetting"] = true;
                }
                catch (e:Error)
                {
                }
                this.txtPower.actAsButton = false;
                this.txtPower.defaultText = "";
                this.txtPower.displayAsPassword = false;
                this.txtPower.editable = false;
                this.txtPower.enabled = true;
                this.txtPower.enableInitCallback = false;
                this.txtPower.focusable = false;
                this.txtPower.maxChars = 0;
                this.txtPower.minThumbSize = 1;
                this.txtPower.scrollBar = "";
                this.txtPower.scrollSpeed = 40;
                this.txtPower.text = "";
                this.txtPower.thumbOffset = {top:0, bottom:0};
                this.txtPower.visible = true;
                try
                {
                    this.txtPower["componentInspectorSetting"] = false;
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        function __setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_13(param1:int)
        {
            if (this.txtPower != null && param1 >= 14 && param1 <= 55 && (this.__setPropDict[this.txtPower] == undefined || !(int(this.__setPropDict[this.txtPower]) >= 14 && int(this.__setPropDict[this.txtPower]) <= 55)))
            {
                this.__setPropDict[this.txtPower] = param1;
                try
                {
                    this.txtPower["componentInspectorSetting"] = true;
                }
                catch (e:Error)
                {
                }
                this.txtPower.actAsButton = false;
                this.txtPower.defaultText = "";
                this.txtPower.displayAsPassword = false;
                this.txtPower.editable = false;
                this.txtPower.enabled = true;
                this.txtPower.enableInitCallback = false;
                this.txtPower.focusable = false;
                this.txtPower.maxChars = 0;
                this.txtPower.minThumbSize = 1;
                this.txtPower.scrollBar = "";
                this.txtPower.scrollSpeed = 40;
                this.txtPower.text = "";
                this.txtPower.thumbOffset = {top:0, bottom:0};
                this.txtPower.visible = false;
                try
                {
                    this.txtPower["componentInspectorSetting"] = false;
                }
                catch (e:Error)
                {
                }
            }
            return;
        }// end function

        function __setProp_handler(param1:Object)
        {
            var _loc_2:* = currentFrame;
            if (this.__lastFrameProp == _loc_2)
            {
                return;
            }
            this.__lastFrameProp = _loc_2;
            this.__setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_0(_loc_2);
            this.__setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_13(_loc_2);
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame7()
        {
            stop();
            return;
        }// end function

        function frame8()
        {
            stop();
            return;
        }// end function

        function frame13()
        {
            stop();
            return;
        }// end function

        function frame14()
        {
            stop();
            return;
        }// end function

        function frame19()
        {
            stop();
            return;
        }// end function

        function frame27()
        {
            stop();
            return;
        }// end function

        function frame33()
        {
            stop();
            return;
        }// end function

        function frame38()
        {
            stop();
            return;
        }// end function

        function frame43()
        {
            stop();
            return;
        }// end function

        function frame50()
        {
            stop();
            return;
        }// end function

        function frame55()
        {
            stop();
            return;
        }// end function

    }
}
