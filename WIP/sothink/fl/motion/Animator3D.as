package fl.motion
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;

    public class Animator3D extends AnimatorBase
    {
        private var _initialPosition:Vector3D;
        private var _initialMatrixOfTarget:Matrix3D;
        private static var IDENTITY_MATRIX:Matrix = new Matrix();
        static const EPSILON:Number = 1e-008;

        public function Animator3D(param1:XML = null, param2:DisplayObject = null)
        {
            super(param1, param2);
            this.transformationPoint = new Point(0, 0);
            this._initialPosition = null;
            this._initialMatrixOfTarget = null;
            this._isAnimator3D = true;
            return;
        }// end function

        override public function set initialPosition(param1:Array) : void
        {
            if (param1.length == 3)
            {
                this._initialPosition = new Vector3D();
                this._initialPosition.x = param1[0];
                this._initialPosition.y = param1[1];
                this._initialPosition.z = param1[2];
            }
            return;
        }// end function

        override protected function setTargetState() : void
        {
            if (!motionArray && this._target.transform.matrix != null)
            {
                this._initialMatrixOfTarget = convertMatrixToMatrix3D(this._target.transform.matrix);
            }
            return;
        }// end function

        override protected function setTime3D(param1:int, param2:MotionBase) : Boolean
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = NaN;
            var _loc_7:* = NaN;
            var _loc_8:* = NaN;
            var _loc_9:* = NaN;
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = null;
            var _loc_13:* = null;
            var _loc_3:* = param2.getMatrix3D(param1) as Matrix3D;
            if (motionArray && param2 != _lastMotionUsed)
            {
                this.transformationPoint = motion_internal::transformationPoint ? (motion_internal::transformationPoint) : (new Point(0, 0));
                if (motion_internal::initialPosition)
                {
                    this.initialPosition = motion_internal::initialPosition;
                }
                else
                {
                    this._initialPosition = null;
                }
                _lastMotionUsed = param2;
            }
            if (_loc_3)
            {
                if (!motionArray || !_lastMatrix3DApplied || !matrices3DEqual(_loc_3, Matrix3D(_lastMatrix3DApplied)))
                {
                    _loc_4 = _loc_3.clone();
                    if (this._initialMatrixOfTarget)
                    {
                        _loc_4.append(this._initialMatrixOfTarget);
                    }
                    this._target.transform.matrix3D = _loc_4;
                    _lastMatrix3DApplied = _loc_3;
                }
                return true;
            }
            else if (param2.is3D)
            {
                _loc_5 = new Matrix3D();
                _loc_6 = param2.getValue(param1, Tweenables.ROTATION_X) * Math.PI / 180;
                _loc_7 = param2.getValue(param1, Tweenables.ROTATION_Y) * Math.PI / 180;
                _loc_8 = param2.getValue(param1, Tweenables.ROTATION_CONCAT) * Math.PI / 180;
                _loc_5.prepend(MatrixTransformer3D.rotateAboutAxis(_loc_8, MatrixTransformer3D.AXIS_Z));
                _loc_5.prepend(MatrixTransformer3D.rotateAboutAxis(_loc_7, MatrixTransformer3D.AXIS_Y));
                _loc_5.prepend(MatrixTransformer3D.rotateAboutAxis(_loc_6, MatrixTransformer3D.AXIS_X));
                _loc_9 = param2.getValue(param1, Tweenables.X);
                _loc_10 = param2.getValue(param1, Tweenables.Y);
                _loc_11 = param2.getValue(param1, Tweenables.Z);
                if (getSign(_loc_9) != 0 || getSign(_loc_10) != 0 || getSign(_loc_11) != 0)
                {
                    _loc_5.appendTranslation(_loc_9, _loc_10, _loc_11);
                }
                _loc_5.prependTranslation(-this.transformationPoint.x, -this.transformationPoint.y, -this.transformationPointZ);
                if (this._initialPosition)
                {
                    _loc_5.appendTranslation(this._initialPosition.x, this._initialPosition.y, this._initialPosition.z);
                }
                _loc_12 = this.getScaleSkewMatrix(param2, param1, this.transformationPoint.x, this.transformationPoint.y);
                _loc_13 = convertMatrixToMatrix3D(_loc_12);
                _loc_5.prepend(_loc_13);
                if (this._initialMatrixOfTarget)
                {
                    _loc_5.append(this._initialMatrixOfTarget);
                }
                if (!motionArray || !_lastMatrix3DApplied || !matrices3DEqual(_loc_5, Matrix3D(_lastMatrix3DApplied)))
                {
                    this._target.transform.matrix3D = _loc_5;
                    _lastMatrix3DApplied = _loc_5;
                }
            }
            return false;
        }// end function

        override protected function removeChildTarget(param1:MovieClip, param2:DisplayObject, param3:String) : void
        {
            super.removeChildTarget(param1, param2, param3);
            if (param2.transform.matrix3D != null)
            {
                param2.transform.matrix = IDENTITY_MATRIX;
            }
            return;
        }// end function

        private function getScaleSkewMatrix(param1:MotionBase, param2:int, param3:Number, param4:Number) : Matrix
        {
            var _loc_5:* = param1.getValue(param2, Tweenables.SCALE_X);
            var _loc_6:* = param1.getValue(param2, Tweenables.SCALE_Y);
            var _loc_7:* = param1.getValue(param2, Tweenables.SKEW_X);
            var _loc_8:* = param1.getValue(param2, Tweenables.SKEW_Y);
            var _loc_9:* = new Matrix();
            _loc_9.translate(-param3, -param4);
            var _loc_10:* = new Matrix();
            _loc_9.scale(_loc_5, _loc_6);
            _loc_9.concat(_loc_10);
            var _loc_11:* = new Matrix();
            _loc_9.a = Math.cos(_loc_8 * (Math.PI / 180));
            _loc_11.b = Math.sin(_loc_8 * (Math.PI / 180));
            _loc_11.c = -Math.sin(_loc_7 * (Math.PI / 180));
            _loc_11.d = Math.cos(_loc_7 * (Math.PI / 180));
            _loc_9.concat(_loc_11);
            _loc_9.translate(param3, param4);
            return _loc_9;
        }// end function

        static function getSign(param1:Number) : int
        {
            return param1 < -EPSILON ? (-1) : (param1 > EPSILON ? (1) : (0));
        }// end function

        static function convertMatrixToMatrix3D(param1:Matrix) : Matrix3D
        {
            var _loc_2:* = new Vector.<Number>(16);
            _loc_2[0] = param1.a;
            _loc_2[1] = param1.b;
            _loc_2[2] = 0;
            _loc_2[3] = 0;
            _loc_2[4] = param1.c;
            _loc_2[5] = param1.d;
            _loc_2[6] = 0;
            _loc_2[7] = 0;
            _loc_2[8] = 0;
            _loc_2[9] = 0;
            _loc_2[10] = 1;
            _loc_2[11] = 0;
            _loc_2[12] = param1.tx;
            _loc_2[13] = param1.ty;
            _loc_2[14] = 0;
            _loc_2[15] = 1;
            return new Matrix3D(_loc_2);
        }// end function

        static function matrices3DEqual(param1:Matrix3D, param2:Matrix3D) : Boolean
        {
            var _loc_3:* = param1.rawData;
            var _loc_4:* = param2.rawData;
            if (_loc_3 == null || _loc_3.length != 16 || _loc_4 == null || _loc_4.length != 16)
            {
                return false;
            }
            var _loc_5:* = 0;
            while (_loc_5 < 16)
            {
                
                if (_loc_3[_loc_5] != _loc_4[_loc_5])
                {
                    return false;
                }
                _loc_5++;
            }
            return true;
        }// end function

    }
}
