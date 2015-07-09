package fl.motion
{

    public class ColorMatrix extends DynamicMatrix
    {
        static const LUMINANCER:Number = 0.3086;
        static const LUMINANCEG:Number = 0.6094;
        static const LUMINANCEB:Number = 0.082;

        public function ColorMatrix()
        {
            super(5, 5);
            LoadIdentity();
            return;
        }// end function

        public function SetBrightnessMatrix(param1:Number) : void
        {
            if (!m_matrix)
            {
                return;
            }
            m_matrix[0][4] = param1;
            m_matrix[1][4] = param1;
            m_matrix[2][4] = param1;
            return;
        }// end function

        public function SetContrastMatrix(param1:Number) : void
        {
            if (!m_matrix)
            {
                return;
            }
            var _loc_2:* = 0.5 * (127 - param1);
            param1 = param1 / 127;
            m_matrix[0][0] = param1;
            m_matrix[1][1] = param1;
            m_matrix[2][2] = param1;
            m_matrix[0][4] = _loc_2;
            m_matrix[1][4] = _loc_2;
            m_matrix[2][4] = _loc_2;
            return;
        }// end function

        public function SetSaturationMatrix(param1:Number) : void
        {
            if (!m_matrix)
            {
                return;
            }
            var _loc_2:* = 1 - param1;
            var _loc_3:* = _loc_2 * LUMINANCER;
            m_matrix[0][0] = _loc_3 + param1;
            m_matrix[1][0] = _loc_3;
            m_matrix[2][0] = _loc_3;
            _loc_3 = _loc_2 * LUMINANCEG;
            m_matrix[0][1] = _loc_3;
            m_matrix[1][1] = _loc_3 + param1;
            m_matrix[2][1] = _loc_3;
            _loc_3 = _loc_2 * LUMINANCEB;
            m_matrix[0][2] = _loc_3;
            m_matrix[1][2] = _loc_3;
            m_matrix[2][2] = _loc_3 + param1;
            return;
        }// end function

        public function SetHueMatrix(param1:Number) : void
        {
            var _loc_11:* = 0;
            if (!m_matrix)
            {
                return;
            }
            LoadIdentity();
            var _loc_2:* = new DynamicMatrix(3, 3);
            var _loc_3:* = new DynamicMatrix(3, 3);
            var _loc_4:* = new DynamicMatrix(3, 3);
            var _loc_5:* = Math.cos(param1);
            var _loc_6:* = Math.sin(param1);
            var _loc_7:* = 0.213;
            var _loc_8:* = 0.715;
            var _loc_9:* = 0.072;
            _loc_2.SetValue(0, 0, _loc_7);
            _loc_2.SetValue(1, 0, _loc_7);
            _loc_2.SetValue(2, 0, _loc_7);
            _loc_2.SetValue(0, 1, _loc_8);
            _loc_2.SetValue(1, 1, _loc_8);
            _loc_2.SetValue(2, 1, _loc_8);
            _loc_2.SetValue(0, 2, _loc_9);
            _loc_2.SetValue(1, 2, _loc_9);
            _loc_2.SetValue(2, 2, _loc_9);
            _loc_3.SetValue(0, 0, 1 - _loc_7);
            _loc_3.SetValue(1, 0, -_loc_7);
            _loc_3.SetValue(2, 0, -_loc_7);
            _loc_3.SetValue(0, 1, -_loc_8);
            _loc_3.SetValue(1, 1, 1 - _loc_8);
            _loc_3.SetValue(2, 1, -_loc_8);
            _loc_3.SetValue(0, 2, -_loc_9);
            _loc_3.SetValue(1, 2, -_loc_9);
            _loc_3.SetValue(2, 2, 1 - _loc_9);
            _loc_3.MultiplyNumber(_loc_5);
            _loc_4.SetValue(0, 0, -_loc_7);
            _loc_4.SetValue(1, 0, 0.143);
            _loc_4.SetValue(2, 0, -(1 - _loc_7));
            _loc_4.SetValue(0, 1, -_loc_8);
            _loc_4.SetValue(1, 1, 0.14);
            _loc_4.SetValue(2, 1, _loc_8);
            _loc_4.SetValue(0, 2, 1 - _loc_9);
            _loc_4.SetValue(1, 2, -0.283);
            _loc_4.SetValue(2, 2, _loc_9);
            _loc_4.MultiplyNumber(_loc_6);
            _loc_2.Add(_loc_3);
            _loc_2.Add(_loc_4);
            var _loc_10:* = 0;
            while (_loc_10 < 3)
            {
                
                _loc_11 = 0;
                while (_loc_11 < 3)
                {
                    
                    m_matrix[_loc_10][_loc_11] = _loc_2.GetValue(_loc_10, _loc_11);
                    _loc_11++;
                }
                _loc_10++;
            }
            return;
        }// end function

        public function GetFlatArray() : Array
        {
            var _loc_4:* = 0;
            if (!m_matrix)
            {
                return null;
            }
            var _loc_1:* = new Array();
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            while (_loc_3 < 4)
            {
                
                _loc_4 = 0;
                while (_loc_4 < 5)
                {
                    
                    _loc_1[_loc_2] = m_matrix[_loc_3][_loc_4];
                    _loc_2++;
                    _loc_4++;
                }
                _loc_3++;
            }
            return _loc_1;
        }// end function

    }
}
