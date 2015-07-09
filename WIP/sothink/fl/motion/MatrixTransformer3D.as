package fl.motion
{
    import __AS3__.vec.*;
    import flash.geom.*;

    public class MatrixTransformer3D extends Object
    {
        public static const AXIS_X:int = 0;
        public static const AXIS_Y:int = 1;
        public static const AXIS_Z:int = 2;

        public function MatrixTransformer3D()
        {
            return;
        }// end function

        public static function rotateAboutAxis(param1:Number, param2:int) : Matrix3D
        {
            var _loc_3:* = Math.cos(param1);
            var _loc_4:* = Math.sin(param1);
            var _loc_5:* = new Vector.<Number>;
            switch(param2)
            {
                case AXIS_X:
                {
                    _loc_5[0] = 1;
                    _loc_5[1] = 0;
                    _loc_5[2] = 0;
                    _loc_5[3] = 0;
                    _loc_5[4] = 0;
                    _loc_5[5] = _loc_3;
                    _loc_5[6] = _loc_4;
                    _loc_5[7] = 0;
                    _loc_5[8] = 0;
                    _loc_5[9] = -_loc_4;
                    _loc_5[10] = _loc_3;
                    _loc_5[11] = 0;
                    _loc_5[12] = 0;
                    _loc_5[13] = 0;
                    _loc_5[14] = 0;
                    _loc_5[15] = 1;
                    break;
                }
                case AXIS_Y:
                {
                    _loc_5[0] = _loc_3;
                    _loc_5[1] = 0;
                    _loc_5[2] = -_loc_4;
                    _loc_5[3] = 0;
                    _loc_5[4] = 0;
                    _loc_5[5] = 1;
                    _loc_5[6] = 0;
                    _loc_5[7] = 0;
                    _loc_5[8] = _loc_4;
                    _loc_5[9] = 0;
                    _loc_5[10] = _loc_3;
                    _loc_5[11] = 0;
                    _loc_5[12] = 0;
                    _loc_5[13] = 0;
                    _loc_5[14] = 0;
                    _loc_5[15] = 1;
                    break;
                }
                case AXIS_Z:
                {
                    _loc_5[0] = _loc_3;
                    _loc_5[1] = _loc_4;
                    _loc_5[2] = 0;
                    _loc_5[3] = 0;
                    _loc_5[4] = -_loc_4;
                    _loc_5[5] = _loc_3;
                    _loc_5[6] = 0;
                    _loc_5[7] = 0;
                    _loc_5[8] = 0;
                    _loc_5[9] = 0;
                    _loc_5[10] = 1;
                    _loc_5[11] = 0;
                    _loc_5[12] = 0;
                    _loc_5[13] = 0;
                    _loc_5[14] = 0;
                    _loc_5[15] = 1;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return new Matrix3D(_loc_5);
        }// end function

        public static function getVector(param1:Matrix3D, param2:int) : Vector3D
        {
            switch(param2)
            {
                case 0:
                {
                    return new Vector3D(param1.rawData[0], param1.rawData[1], param1.rawData[2], param1.rawData[3]);
                }
                case 1:
                {
                    return new Vector3D(param1.rawData[4], param1.rawData[5], param1.rawData[6], param1.rawData[7]);
                }
                case 2:
                {
                    return new Vector3D(param1.rawData[8], param1.rawData[9], param1.rawData[10], param1.rawData[11]);
                }
                case 3:
                {
                    return new Vector3D(param1.rawData[12], param1.rawData[13], param1.rawData[14], param1.rawData[15]);
                }
                default:
                {
                    break;
                }
            }
            return new Vector3D(0, 0, 0, 0);
        }// end function

        public static function getMatrix3D(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D) : Matrix3D
        {
            var _loc_5:* = new Vector.<Number>;
            _loc_5[0] = param1.x;
            _loc_5[1] = param1.y;
            _loc_5[2] = param1.z;
            _loc_5[3] = param1.w;
            _loc_5[4] = param2.x;
            _loc_5[5] = param2.y;
            _loc_5[6] = param2.z;
            _loc_5[7] = param2.w;
            _loc_5[8] = param3.x;
            _loc_5[9] = param3.y;
            _loc_5[10] = param3.z;
            _loc_5[11] = param3.w;
            _loc_5[12] = param4.x;
            _loc_5[13] = param4.y;
            _loc_5[14] = param4.z;
            _loc_5[15] = param4.w;
            return new Matrix3D(_loc_5);
        }// end function

        public static function rotateAxis(param1:Matrix3D, param2:Number, param3:int) : Matrix3D
        {
            var _loc_7:* = null;
            var _loc_8:* = null;
            var _loc_9:* = 0;
            var _loc_10:* = null;
            var _loc_11:* = null;
            var _loc_4:* = new Matrix3D();
            var _loc_5:* = getVector(param1, param3);
            _loc_4.prependRotation(param2 * 180 / Math.PI, _loc_5);
            var _loc_6:* = 0;
            while (_loc_6 < 3)
            {
                
                if (_loc_6 != param3)
                {
                    _loc_7 = getVector(param1, _loc_6);
                    _loc_8 = new Array(3);
                    _loc_9 = 0;
                    while (_loc_9 < 3)
                    {
                        
                        _loc_11 = getVector(_loc_4, _loc_9);
                        _loc_8[_loc_9] = _loc_7.dotProduct(_loc_11);
                        _loc_9++;
                    }
                    _loc_7.x = _loc_8[0];
                    _loc_7.y = _loc_8[1];
                    _loc_7.z = _loc_8[2];
                    _loc_7.w = 0;
                    _loc_7 = normalizeVector(_loc_7);
                    _loc_10 = MatrixTransformer3D.Vector.<Number>(getRawDataVector(param1));
                    _loc_10[_loc_6 * 4] = _loc_7.x;
                    _loc_10[_loc_6 * 4 + 1] = _loc_7.y;
                    _loc_10[_loc_6 * 4 + 2] = _loc_7.z;
                    _loc_10[_loc_6 * 4 + 3] = _loc_7.w;
                    param1 = new Matrix3D(MatrixTransformer3D.Vector.<Number>(_loc_10));
                }
                _loc_6++;
            }
            return param1;
        }// end function

        public static function normalizeVector(param1:Vector3D) : Vector3D
        {
            var _loc_2:* = 1 / param1.length;
            var _loc_3:* = new Vector3D();
            _loc_3.x = param1.x * _loc_2;
            _loc_3.y = param1.y * _loc_2;
            _loc_3.z = param1.z * _loc_2;
            _loc_3.w = param1.w;
            return _loc_3;
        }// end function

        public static function getRawDataVector(param1:Matrix3D) : Vector.<Number>
        {
            var _loc_2:* = new Vector.<Number>;
            _loc_2[0] = param1.rawData[0];
            _loc_2[1] = param1.rawData[1];
            _loc_2[2] = param1.rawData[2];
            _loc_2[3] = param1.rawData[3];
            _loc_2[4] = param1.rawData[4];
            _loc_2[5] = param1.rawData[5];
            _loc_2[6] = param1.rawData[6];
            _loc_2[7] = param1.rawData[7];
            _loc_2[8] = param1.rawData[8];
            _loc_2[9] = param1.rawData[9];
            _loc_2[10] = param1.rawData[10];
            _loc_2[11] = param1.rawData[11];
            _loc_2[12] = param1.rawData[12];
            _loc_2[13] = param1.rawData[13];
            _loc_2[14] = param1.rawData[14];
            _loc_2[15] = param1.rawData[15];
            return _loc_2;
        }// end function

    }
}
