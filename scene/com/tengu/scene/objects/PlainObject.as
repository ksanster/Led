package com.tengu.scene.objects
{
	import com.tengu.scene.api.IPlainObject;
	import com.tengu.scene.events.GameObjectEvent;

	public class PlainObject extends GameObject implements IPlainObject
	{
		protected var objectWidth:uint;
		protected var objectHeight:uint;

		public function get width():uint 
		{
			return objectWidth;
		}

		public function get height():uint 
		{
			return objectHeight;
		}
		
		public function PlainObject()
		{
			super();
		}
		
		public function setSize (width:int = 0, height:int = 0):void
		{
			objectWidth  = width;
			objectHeight = height;
			dispatchGameObjectEvent(GameObjectEvent.OBJECT_BOUNDS_CHANGED);
		}

	}
}