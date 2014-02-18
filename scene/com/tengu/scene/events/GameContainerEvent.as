package com.tengu.scene.events
{
	import com.tengu.scene.api.IGameObject;
	
	import flash.events.Event;
	
	public class GameContainerEvent extends GameObjectEvent
	{
		public static const SCENE_CONFIGURED:String 	= "sceneConfigured";
		public static const CHILD_ADDED:String 			= "childAdded";
		public static const CHILD_REMOVED:String 		= "childRemoved";
		public static const CHILD_BOUNDS_CHANGED:String = "childBoundsChanged";
		public static const CHILD_COORDS_CHANGED:String = "childCoordsChanged";
		
		public function GameContainerEvent(type:String, gameObject:IGameObject = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, gameObject, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GameContainerEvent(type, gameObject, bubbles, cancelable);
		}
		
	}
}