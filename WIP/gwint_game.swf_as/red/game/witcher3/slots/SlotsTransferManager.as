///SlotsTransferManager
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
    
    public class SlotsTransferManager extends flash.events.EventDispatcher
    {
        public function SlotsTransferManager()
        {
            super();
            this._dragTargets = new Vector.<red.game.witcher3.interfaces.IDragTarget>();
            this._dropTargets = new Vector.<red.game.witcher3.interfaces.IDropTarget>();
            this._actualDropTargets = new Vector.<red.game.witcher3.interfaces.IDropTarget>();
            return;
        }

        internal function handleDragRemovedFromStage(arg1:flash.events.Event):void
        {
            this.removeDragTarget(arg1.currentTarget as red.game.witcher3.interfaces.IDragTarget);
            return;
        }

        internal function handleDropRemovedFromStage(arg1:flash.events.Event):void
        {
            this.removeDropTarget(arg1.currentTarget as red.game.witcher3.interfaces.IDropTarget);
            return;
        }

        protected function waitForDragging(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            var loc1:*=arg1 as scaleform.clik.core.UIComponent;
            var loc2:*=loc1.stage;
            this._currentStage = loc2;
            this._currentDragItem = arg1;
            loc2.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 0, true);
            loc2.addEventListener(flash.events.MouseEvent.MOUSE_UP, this.handleMouseUp, false, 0, true);
            return;
        }

        protected function handleMouseMove(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=null;
            var loc2:*=null;
            if (this._dragging) 
            {
                if (this._dragging) 
                {
                    loc1 = scaleform.gfx.Extensions.getMouseTopMostEntity(true);
                    while (loc1 && !loc2 && loc1.parent) 
                    {
                        loc2 = loc1 as red.game.witcher3.interfaces.IDropTarget;
                        loc1 = loc1.parent;
                    }
                    if (loc2 && loc2.canDrop(this._currentDragItem)) 
                    {
                        if (this._currentRecepient && !(this._currentRecepient == loc2)) 
                        {
                            this._currentRecepient.processOver(null);
                        }
                        this._currentRecepient = loc2;
                        this._currentRecepient.dropSelection = true;
                        this._currentRecepient.processOver(this._avatar);
                    }
                    else 
                    {
                        if (this._currentRecepient) 
                        {
                            this._currentRecepient.processOver(null);
                        }
                        this._currentRecepient = null;
                    }
                }
            }
            else 
            {
                this.tryStartDrag(arg1.stageX, arg1.stageY);
            }
            return;
        }

        protected function handleMouseUp(arg1:flash.events.MouseEvent):void
        {
            this.stopDrag();
            return;
        }

        protected function tryStartDrag(arg1:Number, arg2:Number):void
        {
            var loc2:*=null;
            if (!this._currentDragItem || !this._downPoint || !this._canvas) 
            {
                return;
            }
            var loc1:*=red.game.witcher3.utils.Math2.getSegmentLength(this._downPoint, new flash.geom.Point(arg1, arg2));
            this._dragging = loc1 > DRAG_START_OFFSET;
            if (this._dragging && !this._avatar) 
            {
                this._avatar = new red.game.witcher3.slots.SlotDragAvatar(this._currentDragItem.getAvatar(), this._currentDragItem.getDragData(), this._currentDragItem);
                if (this._avatar) 
                {
                    this._canvas.addChild(this._avatar);
                    this._avatar.startDrag(true);
                    this._currentDragItem.dragSelection = true;
                    (loc2 = new red.game.witcher3.events.ItemDragEvent(red.game.witcher3.events.ItemDragEvent.START_DRAG)).targetItem = this._currentDragItem;
                    dispatchEvent(loc2);
                    this.highlightDropTargets(this._currentDragItem);
                }
                else 
                {
                    this._dragging = false;
                    throw new Error("Can\'t get dragging view avatar from object ", this._currentDragItem);
                }
            }
            return;
        }

        protected function stopDrag():void
        {
            var loc1:*=new red.game.witcher3.events.ItemDragEvent(red.game.witcher3.events.ItemDragEvent.STOP_DRAG);
            if (this._dragging) 
            {
                if (this._currentRecepient) 
                {
                    this._currentRecepient.processOver(null);
                    this._currentRecepient.applyDrop(this._currentDragItem);
                    loc1.targetRecepient = this._currentRecepient;
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
                this._currentStage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, this.handleMouseMove);
                this._currentStage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, this.handleMouseUp);
                this._currentDragItem = null;
            }
            dispatchEvent(loc1);
            return;
        }

        protected function highlightDropTargets(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            var loc3:*=null;
            var loc4:*=false;
            var loc1:*=this._dropTargets.length;
            if (arg1 is red.game.witcher3.slots.SlotPaperdoll && !(arg1 is red.game.witcher3.slots.SlotSkillGrid && !(arg1 is red.game.witcher3.slots.SlotSkillSocket))) 
            {
                return;
            }
            var loc2:*=0;
            while (loc2 < loc1) 
            {
                loc4 = (loc3 = this._dropTargets[loc2]) as red.game.witcher3.interfaces.IBaseSlot == arg1 as red.game.witcher3.interfaces.IBaseSlot;
                if (loc3.canDrop(arg1) && !loc4) 
                {
                    loc3.dropSelection = true;
                    this._actualDropTargets.push(loc3);
                }
                ++loc2;
            }
            return;
        }

        protected function removeDropHighlighting():void
        {
            while (this._actualDropTargets.length) 
            {
                this._actualDropTargets.pop().dropSelection = false;
            }
            return;
        }

        public static function getInstance():red.game.witcher3.slots.SlotsTransferManager
        {
            if (!_instance) 
            {
                _instance = new SlotsTransferManager();
            }
            return _instance;
        }

        public function init(arg1:flash.display.Sprite):void
        {
            this._canvas = arg1;
            return;
        }

        public function addDragTarget(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            this._dragTargets.push(arg1);
            arg1.addEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.handleDragRemovedFromStage, false, 0, true);
            arg1.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, this.handleMouseDown, false, 0, true);
            arg1.addEventListener(flash.events.MouseEvent.MOUSE_OVER, this.handleMouseOver, false, 0, true);
            arg1.addEventListener(flash.events.MouseEvent.MOUSE_OUT, this.handleMouseOut, false, 0, true);
            return;
        }

        public function addDropTarget(arg1:red.game.witcher3.interfaces.IDropTarget):void
        {
            this._dropTargets.push(arg1);
            arg1.addEventListener(flash.events.Event.REMOVED_FROM_STAGE, this.handleDropRemovedFromStage, false, 0, true);
            return;
        }

        public function removeDragTarget(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            var loc1:*=this._dragTargets.indexOf(arg1);
            if (loc1 > -1) 
            {
                this._dragTargets.splice(loc1, 1);
            }
            return;
        }

        public function removeDropTarget(arg1:red.game.witcher3.interfaces.IDropTarget):void
        {
            var loc1:*=this._dropTargets.indexOf(arg1);
            if (loc1 > -1) 
            {
                this._dropTargets.splice(loc1, 1);
            }
            return;
        }

        public function showDropTargets(arg1:red.game.witcher3.interfaces.IDragTarget):void
        {
            this.removeDropHighlighting();
            if (arg1.canDrag()) 
            {
                this.highlightDropTargets(arg1);
            }
            return;
        }

        public function hideDropTargets():void
        {
            this.removeDropHighlighting();
            return;
        }

        internal function handleMouseOver(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=arg1.currentTarget as red.game.witcher3.interfaces.IDragTarget;
            this.removeDropHighlighting();
            if (loc1 && loc1.canDrag() && !this._dragging) 
            {
                this.highlightDropTargets(arg1.currentTarget as red.game.witcher3.interfaces.IDragTarget);
            }
            return;
        }

        internal function handleMouseOut(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=arg1.currentTarget as red.game.witcher3.interfaces.IDragTarget;
            if (loc1 && !this._dragging) 
            {
                this.removeDropHighlighting();
            }
            return;
        }

        internal function handleMouseDown(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=arg1.currentTarget as red.game.witcher3.interfaces.IDragTarget;
            if (loc1.canDrag()) 
            {
                this._downPoint = new flash.geom.Point(arg1.stageX, arg1.stageY);
                this.waitForDragging(loc1);
            }
            return;
        }

        protected static const DRAG_START_OFFSET:Number=10;

        protected var _dragTargets:__AS3__.vec.Vector.<red.game.witcher3.interfaces.IDragTarget>;

        protected var _dropTargets:__AS3__.vec.Vector.<red.game.witcher3.interfaces.IDropTarget>;

        protected var _actualDropTargets:__AS3__.vec.Vector.<red.game.witcher3.interfaces.IDropTarget>;

        protected var _downPoint:flash.geom.Point;

        protected var _dragging:Boolean;

        protected var _canvas:flash.display.Sprite;

        protected var _avatar:red.game.witcher3.slots.SlotDragAvatar;

        protected var _currentStage:flash.display.Stage;

        protected var _currentDragItem:red.game.witcher3.interfaces.IDragTarget;

        protected var _currentRecepient:red.game.witcher3.interfaces.IDropTarget;

        protected static var _instance:red.game.witcher3.slots.SlotsTransferManager;
    }
}


