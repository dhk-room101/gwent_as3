package red.game.witcher3.utils
{
    import flash.events.*;
    import flash.utils.*;

    public class FiniteStateMachine extends Object
    {
        private var stateList:Dictionary;
        private var currentStateName:String = "";
        private var nextState:String = "";
        private var prevStateName:String = "";
        private var updateTimer:Timer;
        private var disallowStateChangeFunc:Function;

        public function FiniteStateMachine()
        {
            this.stateList = new Dictionary();
            this.updateTimer = new Timer(20, 0);
            this.updateTimer.addEventListener(TimerEvent.TIMER, this.updateStates);
            this.updateTimer.start();
            return;
        }// end function

        public function get previousState() : String
        {
            return this.prevStateName;
        }// end function

        public function get currentState() : String
        {
            return this.currentStateName;
        }// end function

        public function set pauseOnStateChangeIfFunc(param1:Function) : void
        {
            this.disallowStateChangeFunc = param1;
            return;
        }// end function

        public function get awaitingNextState() : Boolean
        {
            return this.currentStateName != this.nextState;
        }// end function

        public function AddState(param1:String, param2:Function, param3:Function, param4:Function) : void
        {
            var _loc_5:* = new FSMState();
            _loc_5.stateTag = param1;
            _loc_5.enterStateCallback = param2;
            _loc_5.updateStateCallback = param3;
            _loc_5.leaveStateCallback = param4;
            this.stateList[param1] = _loc_5;
            if (this.currentStateName == "" && this.nextState == "")
            {
                this.nextState = param1;
            }
            return;
        }// end function

        public function ChangeState(param1:String) : void
        {
            if (this.stateList[this.nextState])
            {
                this.nextState = param1;
            }
            else
            {
                Console.WriteLine("GFX - [WARNING] Tried to change to an unknown state:", param1);
            }
            return;
        }// end function

        public function ForceUpdateState() : void
        {
            this.updateStates();
            return;
        }// end function

        private function updateStates(event:TimerEvent = null) : void
        {
            if (this.nextState != this.currentStateName && this.disallowStateChangeFunc && this.disallowStateChangeFunc())
            {
                return;
            }
            if (this.nextState != this.currentStateName && this.stateList[this.nextState] != null)
            {
                Console.WriteLine("GFX - [FSM] Switching from: ", this.currentStateName, ", to:", this.nextState);
                if (this.stateList[this.currentStateName] && this.stateList[this.currentStateName].leaveStateCallback)
                {
                    this.stateList[this.currentStateName].leaveStateCallback();
                }
                this.prevStateName = this.currentStateName;
                this.currentStateName = this.nextState;
                if (this.stateList[this.nextState] && this.stateList[this.nextState].enterStateCallback)
                {
                    this.stateList[this.nextState].enterStateCallback();
                }
            }
            if (this.currentStateName == "")
            {
                return;
            }
            if (this.stateList[this.currentStateName].updateStateCallback)
            {
                this.stateList[this.currentStateName].updateStateCallback();
            }
            if (this.nextState != this.currentStateName && this.disallowStateChangeFunc && this.disallowStateChangeFunc())
            {
                return;
            }
            if (this.nextState != this.currentStateName && this.stateList[this.nextState] != null)
            {
                Console.WriteLine("GFX - [FSM] Switching from: ", this.currentStateName, ", to:", this.nextState);
                if (this.stateList[this.currentStateName] && this.stateList[this.currentStateName].leaveStateCallback)
                {
                    this.stateList[this.currentStateName].leaveStateCallback();
                }
                this.prevStateName = this.currentStateName;
                this.currentStateName = this.nextState;
                if (this.stateList[this.nextState] && this.stateList[this.nextState].enterStateCallback)
                {
                    this.stateList[this.nextState].enterStateCallback();
                }
            }
            return;
        }// end function

    }
}
