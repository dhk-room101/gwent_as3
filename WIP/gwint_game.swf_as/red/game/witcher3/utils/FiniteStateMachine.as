package red.game.witcher3.utils 
{
    import flash.events.*;
    import flash.utils.*;
    
    public class FiniteStateMachine extends Object
    {
        public function FiniteStateMachine()
        {
            super();
            this.stateList = new flash.utils.Dictionary();
            this.updateTimer = new flash.utils.Timer(20, 0);
            this.updateTimer.addEventListener(flash.events.TimerEvent.TIMER, this.updateStates);
            this.updateTimer.start();
            return;
        }

        public function get previousState():String
        {
            return this.prevStateName;
        }

        public function get currentState():String
        {
            return this.currentStateName;
        }

        public function set pauseOnStateChangeIfFunc(arg1:Function):void
        {
            this.disallowStateChangeFunc = arg1;
            return;
        }

        public function get awaitingNextState():Boolean
        {
            return !(this.currentStateName == this.nextState);
        }

        public function AddState(arg1:String, arg2:Function, arg3:Function, arg4:Function):void
        {
            var loc1:*=new red.game.witcher3.utils.FSMState();
            loc1.stateTag = arg1;
            loc1.enterStateCallback = arg2;
            loc1.updateStateCallback = arg3;
            loc1.leaveStateCallback = arg4;
            this.stateList[arg1] = loc1;
            if (this.currentStateName == "" && this.nextState == "") 
            {
                this.nextState = arg1;
            }
            return;
        }

        public function ChangeState(arg1:String):void
        {
            if (this.stateList[this.nextState]) 
            {
                this.nextState = arg1;
            }
            else 
            {
                trace("GFX - [WARNING] Tried to change to an unknown state:", arg1);
            }
            return;
        }

        public function ForceUpdateState():void
        {
            this.updateStates();
            return;
        }

        private function updateStates(arg1:flash.events.TimerEvent=null):void
        {
            if (!(this.nextState == this.currentStateName) && this.disallowStateChangeFunc && this.disallowStateChangeFunc()) 
            {
                return;
            }
            if (!(this.nextState == this.currentStateName) && !(this.stateList[this.nextState] == null)) 
            {
                trace("GFX - [FSM] Switching from: ", this.currentStateName, ", to:", this.nextState);
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
            if (!(this.nextState == this.currentStateName) && this.disallowStateChangeFunc && this.disallowStateChangeFunc()) 
            {
                return;
            }
            if (!(this.nextState == this.currentStateName) && !(this.stateList[this.nextState] == null)) 
            {
                trace("GFX - [FSM] Switching from: ", this.currentStateName, ", to:", this.nextState);
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
        }

        private var stateList:flash.utils.Dictionary;

        private var currentStateName:String="";

        private var nextState:String="";

        private var prevStateName:String="";

        private var updateTimer:flash.utils.Timer;

        private var disallowStateChangeFunc:Function;
    }
}
