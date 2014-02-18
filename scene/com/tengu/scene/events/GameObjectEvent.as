package com.tengu.scene.events
{
	import com.tengu.scene.api.IGameObject;
	
	import flash.events.Event;
	
	public class GameObjectEvent extends Event
	{
		public static const OBJECT_FINALIZED:String = "objectFinalized";
		public static const OBJECT_BOUNDS_CHANGED:String = "objectBoundsChanged";
		public static const OBJECT_COORDS_CHANGED:String = "objectCoordsChanged";
		public static const OBJECT_ANIMATION_CHANGED:String = "objectAnimationChanged";
		
		public var gameObject:IGameObject = null;
		public function GameObjectEvent(type:String, gameObject:IGameObject = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.gameObject = gameObject;
		}
		
		override public function clone():Event
		{
			return new GameObjectEvent(type, gameObject, bubbles, cancelable);
		}
	}
}