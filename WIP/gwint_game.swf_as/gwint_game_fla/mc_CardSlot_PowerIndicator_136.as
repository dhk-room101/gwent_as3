package gwint_game_fla 
{
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.globalization.*;
    import flash.media.*;
    import flash.net.*;
    import flash.net.drm.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.sensors.*;
    import flash.system.*;
    import flash.text.*;
    import flash.text.engine.*;
    import flash.text.ime.*;
    import flash.ui.*;
    import flash.utils.*;
    import flash.xml.*;
    
    public dynamic class mc_CardSlot_PowerIndicator_136 extends flash.display.MovieClip
    {
        public function mc_CardSlot_PowerIndicator_136()
        {
            this.__setPropDict = new flash.utils.Dictionary(true);
            super();
            addFrameScript(0, this.frame1, 6, this.frame7, 7, this.frame8, 12, this.frame13, 13, this.frame14, 18, this.frame19, 26, this.frame27, 32, this.frame33, 37, this.frame38, 42, this.frame43, 49, this.frame50, 54, this.frame55);
            addEventListener(flash.events.Event.FRAME_CONSTRUCTED, this.__setProp_handler, false, 0, true);
            return;
        }

        function __setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_0(arg1:int):*
        {
            if (!(this.txtPower == null) && arg1 >= 1 && arg1 <= 13 && (this.__setPropDict[this.txtPower] == undefined || !(int(this.__setPropDict[this.txtPower]) >= 1 && int(this.__setPropDict[this.txtPower]) <= 13))) 
            {
                this.__setPropDict[this.txtPower] = arg1;
                try 
                {
                    this.txtPower["componentInspectorSetting"] = true;
                }
                catch (e:Error)
                {
                };
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
                this.txtPower.thumbOffset = {"top":0, "bottom":0};
                this.txtPower.visible = true;
                try 
                {
                    this.txtPower["componentInspectorSetting"] = false;
                }
                catch (e:Error)
                {
                };
            }
            return;
        }

        function __setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_13(arg1:int):*
        {
            if (!(this.txtPower == null) && arg1 >= 14 && arg1 <= 55 && (this.__setPropDict[this.txtPower] == undefined || !(int(this.__setPropDict[this.txtPower]) >= 14 && int(this.__setPropDict[this.txtPower]) <= 55))) 
            {
                this.__setPropDict[this.txtPower] = arg1;
                try 
                {
                    this.txtPower["componentInspectorSetting"] = true;
                }
                catch (e:Error)
                {
                };
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
                this.txtPower.thumbOffset = {"top":0, "bottom":0};
                this.txtPower.visible = false;
                try 
                {
                    this.txtPower["componentInspectorSetting"] = false;
                }
                catch (e:Error)
                {
                };
            }
            return;
        }

        function __setProp_handler(arg1:Object):*
        {
            var loc1:*=currentFrame;
            if (this.__lastFrameProp == loc1) 
            {
                return;
            }
            this.__lastFrameProp = loc1;
            this.__setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_0(loc1);
            this.__setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_13(loc1);
            return;
        }

        function frame1():*
        {
            stop();
            return;
        }

        function frame7():*
        {
            stop();
            return;
        }

        function frame8():*
        {
            stop();
            return;
        }

        function frame13():*
        {
            stop();
            return;
        }

        function frame14():*
        {
            stop();
            return;
        }

        function frame19():*
        {
            stop();
            return;
        }

        function frame27():*
        {
            stop();
            return;
        }

        function frame33():*
        {
            stop();
            return;
        }

        function frame38():*
        {
            stop();
            return;
        }

        function frame43():*
        {
            stop();
            return;
        }

        function frame50():*
        {
            stop();
            return;
        }

        function frame55():*
        {
            stop();
            return;
        }

        public var txtPower:txt_CardSlot_Power;

        public var __setPropDict:flash.utils.Dictionary;

        public var __lastFrameProp:int=-1;
    }
}
