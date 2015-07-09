package red.game.witcher3.controls
{
    import flash.text.*;
    import red.core.constants.*;
    import red.game.witcher3.constants.*;
    import red.game.witcher3.utils.*;

    public class ConditionalCloseButton extends ConditionalButton
    {
        public var tfKeyLabel:TextField;

        public function ConditionalCloseButton()
        {
            visible = true;
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            if (label == "")
            {
                label = "[[panel_button_common_exit]]";
            }
            this.tfKeyLabel.text = CommonUtils.toUpperCaseSafe(KeyboardKeys.getKeyLabel(KeyCode.ESCAPE));
            this.tfKeyLabel.text = "[" + this.tfKeyLabel.text + "]";
            return;
        }// end function

        override protected function updateText() : void
        {
            super.updateText();
            if (this.tfKeyLabel)
            {
                this.tfKeyLabel.x = textField.x + textField.width - textField.textWidth - this.tfKeyLabel.width - 4;
            }
            if (mcClickRect)
            {
                mcClickRect.x = this.tfKeyLabel.x + this.tfKeyLabel.width - this.tfKeyLabel.textWidth - 10;
                mcClickRect.setActualSize(Math.abs(mcClickRect.x) + 5, mcClickRect.height);
            }
            return;
        }// end function

    }
}
