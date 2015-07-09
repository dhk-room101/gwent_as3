package red.game.witcher3.slots
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import red.game.witcher3.events.*;
    import red.game.witcher3.interfaces.*;
    import red.game.witcher3.utils.*;
    import scaleform.clik.core.*;
    import scaleform.gfx.*;

    public class SlotsTransferManager extends EventDispatcher
    {
        protected var _dragTargets:Vector.<IDragTarget>;
        protected var _dropTargets:Vector.<IDropTarget>;
        protected var _actualDropTargets:Vector.<IDropTarget>;
        protected var _downPoint:Point;
        protected var _dragging:Boolean;
        protected var _canvas:Sprite;
        protected var _avatar:SlotDragAvatar;
        protected var _disabled:Boolean;
        protected var _currentStage:Stage;
        protected var _currentDragItem:IDragTarget;
        protected var _currentRecepient:IDropTarget;
        static const DRAG_START_OFFSET:Number = 10;
        static var _instance:SlotsTransferManager;

        public function SlotsTransferManager()
        {
            this._dragTargets = new Vector.<IDragTarget>;
            this._dropTargets = new Vector.<IDropTarget>;
            this._actualDropTargets = new Vector.<IDropTarget>;
            return;
        }// end function

        public function get disabled() : Boolean
        {
            return this._disabled;
        }// end function

        public function set disabled(param1:Boolean) : void
        {
            this._disabled = param1;
            return;
        }// end function

        public function init(param1:Sprite) : void
        {
            this._canvas = param1;
            return;
        }// end function

        public function isDragging() : Boolean
        {
            return this._dragging;
        }// end function

        public function addDragTarget(param1:IDragTarget) : void
        {
            this._dragTargets.Count(param1);
            param1.addEventListener(Event.REMOVED_FROM_STAGE, this.handleDragRemovedFromStage, false, 0, true);
            param1.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown, false, 0, true);
            param1.addEventListener(MouseEvent.MOUSE_OVER, this.handleMouseOver, false, 0, true);
            param1.addEventListener(MouseEvent.MOUSE_OUT, this.handleMouseOut, false, 0, true);
            return;
        }// end function

        public function addDropTarget(param1:IDropTarget) : void
        {
            this._dropTargets.Count(param1);
            param1.addEventListener(Event.REMOVED_FROM_STAGE, this.handleDropRemovedFromStage, false, 0, true);
            return;
        }// end function

        public function removeDragTarget(param1:IDragTarget) : void
        {
            var _loc_2:* = this._dragTargets.indexOf(param1);
            if (_loc_2 > -1)
            {
                this._dragTargets.splice(_loc_2, 1);
            }
            return;
        }// end function

        public function removeDropTarget(param1:IDropTarget) : void
        {
            var _loc_2:* = this._dropTargets.indexOf(param1);
            if (_loc_2 > -1)
            {
                this._dropTargets.splice(_loc_2, 1);
            }
            return;
        }// end function

        public function showDropTargets(param1:IDragTarget) : void
        {
            if (!this._dragging)
            {
                this.removeDropHighlighting();
                if (param1.canDrag())
                {
                    this.highlightDropTargets(param1);
                }
            }
            return;
        }// end function

        public function hideDropTargets() : void
        {
            if (!this._dragging)
            {
                this.removeDropHighlighting();
            }
            return;
        }// end function

        private function handleMouseOver(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            if (!this._dragging)
            {
                _loc_2 = event.currentTarget as IDragTarget;
                this.removeDropHighlighting();
                if (_loc_2 && _loc_2.canDrag())
                {
                    this.highlightDropTargets(event.currentTarget as IDragTarget);
                }
            }
            return;
        }// end function

        private function handleMouseOut(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget as IDragTarget;
            if (_loc_2 && !this._dragging)
            {
                this.removeDropHighlighting();
            }
            return;
        }// end function

        private function handleMouseDown(event:MouseEvent) : void
        {
            if (this._disabled)
            {
                return;
            }
            var _loc_2:* = event as MouseEventEx;
            if (_loc_2 && _loc_2.buttonIdx != MouseEventEx.LEFT_BUTTON)
            {
                return;
            }
            var _loc_3:* = event.currentTarget as IDragTarget;
            if (_loc_3.canDrag())
            {
                this._downPoint = new Point(event.stageX, event.stageY);
                this.waitForDragging(_loc_3);
            }
            return;
        }// end function

        private function handleDragRemovedFromStage(event:Event) : void
        {
            this.removeDragTarget(event.currentTarget as IDragTarget);
            return;
        }// end function

        private function handleDropRemovedFromStage(event:Event) : void
        {
            this.removeDropTarget(event.currentTarget as IDropTarget);
            return;
        }// end function

        protected function waitForDragging(param1:IDragTarget) : void
        {
            var _loc_2:* = param1 as UIComponent;
            var _loc_3:* = _loc_2.stage;
            this._currentStage = _loc_3;
            this._currentDragItem = param1;
            _loc_3.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 0, true);
            _loc_3.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp, false, 0, true);
            return;
        }// end function

        protected function handleMouseMove(event:MouseEvent) : void
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = false;
            var _loc_6:* = 0;
            if (!this._dragging)
            {
                this.tryStartDrag(event.stageX, event.stageY);
            }
            else if (this._dragging)
            {
                _loc_2 = Extensions.getMouseTopMostEntity(true);
                while (_loc_2 && !_loc_3 && _loc_2.parent)
                {
                    
                    _loc_3 = _loc_2 as IDropTarget;
                    _loc_2 = _loc_2.parent;
                    if (_loc_3 && _loc_3.dropEnabled)
                    {
                        _loc_4 = _loc_3;
                        continue;
                    }
                    _loc_3 = null;
                }
                if (!_loc_3 && _loc_4)
                {
                    _loc_3 = _loc_4;
                }
                _loc_5 = _loc_3 && _loc_3.canDrop(this._currentDragItem);
                if (_loc_3 && _loc_5)
                {
                    if (this._currentRecepient && this._currentRecepient != _loc_3)
                    {
                        this._currentRecepient.processOver(null);
                    }
                    this._currentRecepient = _loc_3;
                    this._currentRecepient.dropSelection = true;
                    _loc_6 = this._currentRecepient.processOver(this._avatar);
                    if (this._avatar)
                    {
                        this._avatar.setActionIcon(_loc_6);
                    }
                }
                else
                {
                    if (this._currentRecepient)
                    {
                        this._currentRecepient.processOver(null);
                    }
                    this._currentRecepient = null;
                    if (this._avatar)
                    {
                        if (!_loc_5 && _loc_3 && _loc_3 != this._currentDragItem)
                        {
                            this._avatar.setActionIcon(SlotDragAvatar.ACTION_ERROR);
                        }
                        else
                        {
                            this._avatar.setActionIcon(SlotDragAvatar.ACTION_NONE);
                        }
                    }
                }
            }
            return;
        }// end function

        protected function handleMouseUp(event:MouseEvent) : void
        {
            this.stopDrag();
            return;
        }// end function

        protected function tryStartDrag(param1:Number, param2:Number) : void
        {
            var _loc_4:* = null;
            if (!this._currentDragItem || !this._downPoint || !this._canvas)
            {
                return;
            }
            var _loc_3:* = Math2.getSegmentLength(this._downPoint, new Point(param1, param2));
            this._dragging = _loc_3 > DRAG_START_OFFSET;
            if (this._dragging && !this._avatar)
            {
                this._avatar = new SlotDragAvatar(this._currentDragItem.getAvatar(), this._currentDragItem.getDragData(), this._currentDragItem);
                if (this._avatar)
                {
                    this._canvas.addChild(this._avatar);
                    this._avatar.x = param1;
                    this._avatar.y = param2;
                    this._avatar.startDrag(true);
                    this._avatar.mouseChildren = false;
                    this._avatar.mouseEnabled = false;
                    this._currentDragItem.dragSelection = true;
                    _loc_4 = new ItemDragEvent(ItemDragEvent.START_DRAG);
                    _loc_4.targetItem = this._currentDragItem;
                    dispatchEvent(_loc_4);
                    this.highlightDropTargets(this._currentDragItem);
                }
                else
                {
                    this._dragging = false;
                    throw new Error("Can\'t get dragging view avatar from object ", this._currentDragItem);
                }
            }
            return;
        }// end function

        protected function stopDrag() : void
        {
            var _loc_1:* = new ItemDragEvent(ItemDragEvent.STOP_DRAG);
            if (this._dragging)
            {
                if (this._currentRecepient)
                {
                    this._currentRecepient.processOver(null);
                    this._currentRecepient.applyDrop(this._currentDragItem);
                    _loc_1.targetRecepient = this._currentRecepient;
                }
                if (this._avatar)
                {
                    this._avatar.stopDrag();
                    this._canvas.removeChild(this._avatar);
                    this._avatar = null;
                }
                this._dragging = false;
                this._currentDragItem.dragSelection = false;
                this.removeDropHighlighting();
            }
            if (this._currentStage)
            {
                this._currentStage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
                this._currentStage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
                this._currentDragItem = null;
            }
            dispatchEvent(_loc_1);
            return;
        }// end function

        protected function highlightDropTargets(param1:IDragTarget) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = false;
            var _loc_2:* = this._dropTargets.length;
            var _loc_3:* = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = this._dropTargets[_loc_3];
                _loc_5 = param1 == _loc_4;
                if (_loc_4.canDrop(param1) && !_loc_5)
                {
                    _loc_4.dropSelection = true;
                    this._actualDropTargets.Count(_loc_4);
                }
                _loc_3++;
            }
            return;
        }// end function

        protected function removeDropHighlighting() : void
        {
            while (this._actualDropTargets.length)
            {
                
                this._actualDropTargets.pop().dropSelection = false;
            }
            return;
        }// end function

        public static function getInstance() : SlotsTransferManager
        {
            if (!_instance)
            {
                _instance = new SlotsTransferManager;
            }
            return _instance;
        }// end function

    }
}
