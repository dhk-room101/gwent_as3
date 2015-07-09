package scaleform.clik.utils
{
    import flash.utils.*;

    public class WeakReference extends Object
    {
        protected var _dictionary:Dictionary;

        public function WeakReference(param1:Object)
        {
            this._dictionary = new Dictionary(true);
            this._dictionary[param1] = 1;
            return;
        }// end function

        public function get value() : Object
        {
            var _loc_1:* = null;
            for (_loc_1 in this._dictionary)
            {
                
                return _loc_1;
            }
            return null;
        }// end function

    }
}
