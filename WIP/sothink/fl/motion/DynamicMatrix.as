package fl.motion
{

    public class DynamicMatrix extends Object
    {
        protected var m_width:int;
        protected var m_height:int;
        protected var m_matrix:Array;
        public static const MATRIX_ORDER_PREPEND:int = 0;
        public static const MATRIX_ORDER_APPEND:int = 1;

        public function DynamicMatrix(param1:int, param2:int)
        {
            this.Create(param1, param2);
            return;
        }// end function

        protected function Create(param1:int, param2:int) : void
        {
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            if (param1 > 0 && param2 > 0)
            {
                this.m_width = param1;
                this.m_height = param2;
                this.m_matrix = new Array(param2);
                _loc_3 = 0;
                while (_loc_3 < param2)
                {
                    
                    this.m_matrix[_loc_3] = new Array(param1);
                    _loc_4 = 0;
                    while (_loc_4 < param2)
                    {
                        
                        this.m_matrix[_loc_3][_loc_4] = 0;
                        _loc_4++;
                    }
                    _loc_3++;
                }
            }
            return;
        }// end function

        protected function Destroy() : void
        {
            this.m_matrix = null;
            return;
        }// end function

        public function GetWidth() : Number
        {
            return this.m_width;
        }// end function

        public function GetHeight() : Number
        {
            return this.m_height;
        }// end function

        public function GetValue(param1:int, param2:int) : Number
        {
            var _loc_3:* = 0;
            if (param1 >= 0 && param1 < this.m_height && param2 >= 0 && param2 <= this.m_width)
            {
                _loc_3 = this.m_matrix[param1][param2];
            }
            return _loc_3;
        }// end function

        public function SetValue(param1:int, param2:int, param3:Number) : void
        {
            if (param1 >= 0 && param1 < this.m_height && param2 >= 0 && param2 <= this.m_width)
            {
                this.m_matrix[param1][param2] = param3;
            }
            return;
        }// end function

        public function LoadIdentity() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            if (this.m_matrix)
            {
                _loc_1 = 0;
                while (_loc_1 < this.m_height)
                {
                    
                    _loc_2 = 0;
                    while (_loc_2 < this.m_width)
                    {
                        
                        if (_loc_1 == _loc_2)
                        {
                            this.m_matrix[_loc_1][_loc_2] = 1;
                        }
                        else
                        {
                            this.m_matrix[_loc_1][_loc_2] = 0;
                        }
                        _loc_2++;
                    }
                    _loc_1++;
                }
            }
            return;
        }// end function

        public function LoadZeros() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = 0;
            if (this.m_matrix)
            {
                _loc_1 = 0;
                while (_loc_1 < this.m_height)
                {
                    
                    _loc_2 = 0;
                    while (_loc_2 < this.m_width)
                    {
                        
                        this.m_matrix[_loc_1][_loc_2] = 0;
                        _loc_2++;
                    }
                    _loc_1++;
                }
            }
            return;
        }// end function

        public function Multiply(param1:DynamicMatrix, param2:int = 0) : Boolean
        {
            var _loc_5:* = null;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = NaN;
            var _loc_9:* = 0;
            var _loc_10:* = 0;
            if (!this.m_matrix || !param1)
            {
                return false;
            }
            var _loc_3:* = param1.GetHeight();
            var _loc_4:* = param1.GetWidth();
            if (param2 == MATRIX_ORDER_APPEND)
            {
                if (this.m_width != _loc_3)
                {
                    return false;
                }
                _loc_5 = new DynamicMatrix(_loc_4, this.m_height);
                _loc_6 = 0;
                while (_loc_6 < this.m_height)
                {
                    
                    _loc_7 = 0;
                    while (_loc_7 < _loc_4)
                    {
                        
                        _loc_8 = 0;
                        _loc_9 = 0;
                        _loc_10 = 0;
                        while (_loc_9 < Math.max(this.m_height, _loc_3) && _loc_10 < Math.max(this.m_width, _loc_4))
                        {
                            
                            _loc_8 = _loc_8 + param1.GetValue(_loc_9, _loc_7) * this.m_matrix[_loc_6][_loc_10];
                            _loc_9++;
                            _loc_10++;
                        }
                        _loc_5.SetValue(_loc_6, _loc_7, _loc_8);
                        _loc_7++;
                    }
                    _loc_6++;
                }
                this.Destroy();
                this.Create(_loc_4, this.m_height);
                _loc_6 = 0;
                while (_loc_6 < _loc_3)
                {
                    
                    _loc_7 = 0;
                    while (_loc_7 < this.m_width)
                    {
                        
                        this.m_matrix[_loc_6][_loc_7] = _loc_5.GetValue(_loc_6, _loc_7);
                        _loc_7++;
                    }
                    _loc_6++;
                }
            }
            else
            {
                if (this.m_height != _loc_4)
                {
                    return false;
                }
                _loc_5 = new DynamicMatrix(this.m_width, _loc_3);
                _loc_6 = 0;
                while (_loc_6 < _loc_3)
                {
                    
                    _loc_7 = 0;
                    while (_loc_7 < this.m_width)
                    {
                        
                        _loc_8 = 0;
                        _loc_9 = 0;
                        _loc_10 = 0;
                        while (_loc_9 < Math.max(_loc_3, this.m_height) && _loc_10 < Math.max(_loc_4, this.m_width))
                        {
                            
                            _loc_8 = _loc_8 + this.m_matrix[_loc_9][_loc_7] * param1.GetValue(_loc_6, _loc_10);
                            _loc_9++;
                            _loc_10++;
                        }
                        _loc_5.SetValue(_loc_6, _loc_7, _loc_8);
                        _loc_7++;
                    }
                    _loc_6++;
                }
                this.Destroy();
                this.Create(this.m_width, _loc_3);
                _loc_6 = 0;
                while (_loc_6 < _loc_3)
                {
                    
                    _loc_7 = 0;
                    while (_loc_7 < this.m_width)
                    {
                        
                        this.m_matrix[_loc_6][_loc_7] = _loc_5.GetValue(_loc_6, _loc_7);
                        _loc_7++;
                    }
                    _loc_6++;
                }
            }
            return true;
        }// end function

        public function MultiplyNumber(param1:Number) : Boolean
        {
            var _loc_3:* = 0;
            var _loc_4:* = NaN;
            if (!this.m_matrix)
            {
                return false;
            }
            var _loc_2:* = 0;
            while (_loc_2 < this.m_height)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this.m_width)
                {
                    
                    _loc_4 = 0;
                    _loc_4 = this.m_matrix[_loc_2][_loc_3] * param1;
                    this.m_matrix[_loc_2][_loc_3] = _loc_4;
                    _loc_3++;
                }
                _loc_2++;
            }
            return true;
        }// end function

        public function Add(param1:DynamicMatrix) : Boolean
        {
            var _loc_5:* = 0;
            var _loc_6:* = NaN;
            if (!this.m_matrix || !param1)
            {
                return false;
            }
            var _loc_2:* = param1.GetHeight();
            var _loc_3:* = param1.GetWidth();
            if (this.m_width != _loc_3 || this.m_height != _loc_2)
            {
                return false;
            }
            var _loc_4:* = 0;
            while (_loc_4 < this.m_height)
            {
                
                _loc_5 = 0;
                while (_loc_5 < this.m_width)
                {
                    
                    _loc_6 = 0;
                    _loc_6 = this.m_matrix[_loc_4][_loc_5] + param1.GetValue(_loc_4, _loc_5);
                    this.m_matrix[_loc_4][_loc_5] = _loc_6;
                    _loc_5++;
                }
                _loc_4++;
            }
            return true;
        }// end function

    }
}
