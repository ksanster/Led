package com.tengu.scroll.display.views
{
	import com.tengu.math.IntRectangle;
	import com.tengu.scene.api.ICameraView;
	import com.tengu.scene.api.IContainerView;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IViewFactory;
	import com.tengu.scene.api.IViewport;
	import com.tengu.scene.events.GameContainerEvent;
	import com.tengu.scene.objects.GameContainer;
	import com.tengu.scroll.display.DisplayViewport;
	
	public class BaseDisplayContainerView extends BaseDisplayView implements IContainerView, ICameraView
	{
		protected var viewFactory:IViewFactory;
		protected var container:IGameContainer;
		
		public function BaseDisplayContainerView()
		{
			super();
		}
		
		public function setCameraScale (value:Number):void
		{
			//Abstract
		}
		
		public function setCameraSize (width:uint, height:uint):void
		{
			//Abstract
		}
		
		public function setCameraRotation (angle:Number):void
		{
			//Abstract
		}
		
		public function moveCamera (x:Number, y:Number):void
		{
			//Abstract
		}
		
		public override function assignObject(value:IGameObject):void
		{
			super.assignObject(value);
			container = value as IGameContainer;
			container.addEventListener(GameContainerEvent.CHILD_ADDED, onChildAdded);
			container.addEventListener(GameContainerEvent.CHILD_REMOVED, onChildRemoved);
			container.addEventListener(GameContainerEvent.CHILD_BOUNDS_CHANGED, onChildBoundsChanged);
			container.addEventListener(GameContainerEvent.CHILD_COORDS_CHANGED, onChildBoundsChanged);
		}
		
		public override function removeObject():void
		{
			super.removeObject();
			if (container != null)
			{
				container.removeEventListener(GameContainerEvent.CHILD_ADDED, onChildAdded);
				container.removeEventListener(GameContainerEvent.CHILD_REMOVED, onChildRemoved);
				container.removeEventListener(GameContainerEvent.CHILD_BOUNDS_CHANGED, onChildBoundsChanged);
				container.removeEventListener(GameContainerEvent.CHILD_COORDS_CHANGED, onChildBoundsChanged);
				container = null;
			}
		}
		
		public function setVisibleBounds(value:IntRectangle):void
		{
		}
		
		public function setViewFactory(value:IViewFactory):void
		{
			viewFactory = value;
		}
		
		protected function onChildAdded(event:GameContainerEvent):void
		{
			// Abstract
		}
		
		protected function onChildRemoved(event:GameContainerEvent):void
		{
			// Abstract
		}
		
		protected function onChildBoundsChanged(event:GameContainerEvent):void
		{
			// Abstract
		}
	}
}