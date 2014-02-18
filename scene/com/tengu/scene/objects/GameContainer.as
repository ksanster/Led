package com.tengu.scene.objects
{
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.events.GameContainerEvent;
	import com.tengu.scene.events.GameObjectEvent;

	[Event(name="childAdded", type="com.tengu.scene.events.GameContainerEvent")]
	[Event(name="childRemoved", type="com.tengu.scene.events.GameContainerEvent")]
	public class GameContainer extends GameObject implements IGameContainer
	{
		private var childList:Vector.<IGameObject> = null;

        public function get children ():Vector.<IGameObject>
        {
            return childList;
        }

		public function GameContainer()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			childList = new Vector.<IGameObject>();
		}
		
		protected override function dispose():void
		{
			for each (var child:GameObject in childList)
			{
				child.removeEventListener(GameObjectEvent.OBJECT_BOUNDS_CHANGED, onBoundsChanged);
				child.removeEventListener(GameObjectEvent.OBJECT_FINALIZED, onChildFinalized);
				child.parent = null;
				child.finalize();
			}
			childList.length = 0;
		}
		
		public function add (value:IGameObject):void
		{
			if (value.parent != null)
			{
				value.parent.remove(value);
			}
			childList[childList.length] = value;
			value.parent = this;
			value.addEventListener(GameObjectEvent.OBJECT_BOUNDS_CHANGED, onBoundsChanged);
			value.addEventListener(GameObjectEvent.OBJECT_COORDS_CHANGED, onCoordsChanged);
			value.addEventListener(GameObjectEvent.OBJECT_FINALIZED, onChildFinalized);
			if (hasEventListener(GameContainerEvent.CHILD_ADDED))
			{
				dispatchEvent(new GameContainerEvent(GameContainerEvent.CHILD_ADDED, value));
			}
		}
		
		public function remove (value:IGameObject):void
		{
			var idx:int = childList.indexOf(value);
			if (idx == -1)
			{
				return;
			}
			childList.splice(idx, 1);
			value.removeEventListener(GameObjectEvent.OBJECT_BOUNDS_CHANGED, onBoundsChanged);
			value.removeEventListener(GameObjectEvent.OBJECT_COORDS_CHANGED, onCoordsChanged);
			value.removeEventListener(GameObjectEvent.OBJECT_FINALIZED, onChildFinalized);
			value.parent = null;
			if (hasEventListener(GameContainerEvent.CHILD_REMOVED))
			{
				dispatchEvent(new GameContainerEvent(GameContainerEvent.CHILD_REMOVED, value));
			}
		}
		
		protected function onCoordsChanged(event:GameObjectEvent):void
		{
			dispatchGameObjectEvent(GameContainerEvent.CHILD_COORDS_CHANGED, event.target as IGameObject);
		}
		
		protected function onBoundsChanged(event:GameObjectEvent):void
		{
			dispatchGameObjectEvent(GameContainerEvent.CHILD_BOUNDS_CHANGED, event.target as IGameObject);
		}
		
		private function onChildFinalized(event:GameObjectEvent):void
		{
			var child:IGameObject = event.target as IGameObject;
			remove(child);
		}
	}
}