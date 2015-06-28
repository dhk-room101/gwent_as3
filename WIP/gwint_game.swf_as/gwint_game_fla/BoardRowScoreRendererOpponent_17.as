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
    
    public dynamic class BoardRowScoreRendererOpponent_17 extends flash.display.MovieClip
    {
        public function BoardRowScoreRendererOpponent_17()
        {
            super();
            this.__setProp_txtScore_BoardRowScoreRendererOpponent_txtScore_0();
            return;
        }

        function __setProp_txtScore_BoardRowScoreRendererOpponent_txtScore_0():*
        {
            try 
            {
                this.txtScore["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            };
            this.txtScore.actAsButton = false;
            this.txtScore.defaultText = "";
            this.txtScore.displayAsPassword = false;
            this.txtScore.editable = false;
            this.txtScore.enabled = true;
            this.txtScore.enableInitCallback = false;
            this.txtScore.focusable = false;
            this.txtScore.maxChars = 0;
            this.txtScore.minThumbSize = 1;
            this.txtScore.scrollBar = "";
            this.txtScore.scrollSpeed = 40;
            this.txtScore.text = "";
            this.txtScore.thumbOffset = {"top":0, "bottom":0};
            this.txtScore.visible = true;
            try 
            {
                this.txtScore["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        public var txtScore:txt_BoardRowScoreRenderer;
    }
}
