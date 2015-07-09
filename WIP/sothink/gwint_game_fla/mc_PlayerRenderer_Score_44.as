package gwint_game_fla
{
    import flash.display.*;

    dynamic public class mc_PlayerRenderer_Score_44 extends MovieClip
    {
        public var txtScore:txt_PlayerRenderer_Score;

        public function mc_PlayerRenderer_Score_44()
        {
            addFrameScript(0, this.frame1, 4, this.frame5, 19, this.frame20, 34, this.frame35);
            this.__setProp_txtScore_mc_PlayerRenderer_Score_txtScore_0();
            return;
        }// end function

        function __setProp_txtScore_mc_PlayerRenderer_Score_txtScore_0()
        {
            try
            {
                this.txtScore["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
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
            this.txtScore.thumbOffset = {top:0, bottom:0};
            this.txtScore.visible = true;
            try
            {
                this.txtScore["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function frame1()
        {
            stop();
            return;
        }// end function

        function frame5()
        {
            stop();
            return;
        }// end function

        function frame20()
        {
            gotoAndStop("Idle");
            return;
        }// end function

        function frame35()
        {
            gotoAndPlay("Idle");
            return;
        }// end function

    }
}
