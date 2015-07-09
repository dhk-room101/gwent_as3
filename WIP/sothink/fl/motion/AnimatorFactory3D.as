package fl.motion
{

    public class AnimatorFactory3D extends AnimatorFactoryBase
    {

        public function AnimatorFactory3D(param1:MotionBase, param2:Array = null)
        {
            super(param1, param2);
            this._is3D = true;
            return;
        }// end function

        override protected function getNewAnimator() : AnimatorBase
        {
            return new Animator3D(null, null);
        }// end function

    }
}
