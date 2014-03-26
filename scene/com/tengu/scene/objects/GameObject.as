package com.tengu.scene.objects
{

    import com.tengu.scene.api.IGameContainer;
    import com.tengu.scene.api.IGameObject;
    import com.tengu.scene.events.GameObjectEvent;
    
    import flash.events.EventDispatcher;

    [Event(name="objectBoundsChanged", type="com.tengu.scene.events.GameObjectEvent")]
	[Event(name="objectFinalized", type="com.tengu.scene.events.GameObjectEvent")]
	public class GameObject extends EventDispatcher implements IGameObject
	{
		protected var parentContainer:IGameContainer = null;

		protected var xCoord:Number = 0;
		protected var yCoord:Number = 0;
		protected var zCoord:Number = 0;
		
		public function set parent(value:IGameContainer):void
		{
			parentContainer = value;
		}
		
		public function get parent():IGameContainer 
		{
			return parentContainer;
		}
		
		public function get x():Number 
		{
			return xCoord;
		}
		
		public function get y():Number 
		{
			return yCoord;
		}
		
		public function get z():Number 
		{
			return zCoord;
		}

		public function GameObject()
		{
			super();
			initialize();
		}
		
		protected function initialize ():void
		{
			//Abstract
		}
		
		protected function dispose ():void
		{
			//Abstract
		}
		
		public function move (x:Number = 0, y:Number = 0, z:Number = 0):void
		{
			xCoord = x;
			yCoord = y;
			zCoord = z;
			dispatchGameObjectEvent(GameObjectEvent.OBJECT_COORDS_CHANGED);
		}
		
		public final function finalize ():void
		{
			dispose();
			dispatchGameObjectEvent(GameObjectEvent.OBJECT_FINALIZED);
		}
		
		protected function dispatchGameObjectEvent (type:String, item:IGameObject = null):void
		{
			if (hasEventListener(type))
			{
				dispatchEvent(new GameObjectEvent(type, item));
			}
		}
		
	}
}