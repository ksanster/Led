package com.tengu.scroll.display.views
{
	import com.tengu.math.IntRectangle;
	import com.tengu.scene.api.ICameraView;
	import com.tengu.scene.api.IContainerView;
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IViewFactory;
	import com.tengu.scene.events.GameContainerEvent;
	
	import flash.display.Sprite;
	
	public class BaseDisplayContainerView extends BaseDisplayView implements IContainerView, ICameraView
	{
		protected var viewFactory:IViewFactory;
		protected var container:IGameContainer;
		
		protected var holder:Sprite;
		
		protected var cameraX:Number = 0;
		protected var cameraY:Number = 0;
		
		protected var cameraScale:Number 	= 1;
		protected var cameraRotation:Number = 0;
		
		protected var cameraWidth:uint = 0;
		protected var cameraHeight:uint = 0; 
		protected var cameraHalfWidth:uint  = 0;
		protected var cameraHalfHeight:uint = 0; 
		
		protected var visibleBounds:IntRectangle;
		
		public function BaseDisplayContainerView()
		{
			super();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			holder = new Sprite();
			holder.mouseEnabled = false;
			addChild(holder);
			
			visibleBounds = new IntRectangle();
			
			awake();
		}
		
		protected override function updateScale():void
		{
			holder.scaleX = cameraScale;
			holder.scaleY = cameraScale;
		}
		
		protected override function updateViewport():void
		{
			updateVisibleBounds();			
			holder.x = - cameraX * cameraScale + cameraWidth - cameraHalfWidth * cameraScale;
			holder.y = - cameraY * cameraScale + cameraHeight - cameraHalfHeight * cameraScale;
		}
		
		protected override function updateRotation():void
		{
			rotation = cameraRotation;
		}

		protected function updateVisibleBounds():void
		{
			visibleBounds.x = cameraX - cameraHalfWidth / cameraScale;
			visibleBounds.y = cameraY - cameraHalfHeight / cameraScale;
			
			visibleBounds.width  = cameraWidth  / cameraScale;
			visibleBounds.height = cameraHeight / cameraScale;
		}
		
		public function setCameraScale (value:Number):void
		{
			cameraScale = value;
			invalidate(VALIDATION_FLAG_SCALE);
		}
		
		public function setCameraSize (width:uint, height:uint):void
		{
			cameraWidth  = width;
			cameraHeight = height; 
			
			cameraHalfWidth  = width * .5;
			cameraHalfHeight = height * .5;
			
			invalidate(VALIDATION_FLAG_BOUNDS);
		}
		
		public function setCameraRotation (angle:Number):void
		{
			cameraRotation = angle;
			invalidate(VALIDATION_FLAG_ROTATION);
		}
		
		public function moveCamera (x:Number, y:Number):void
		{
			cameraX = x;
			cameraY = y;
			invalidate(VALIDATION_FLAG_VIEWPORT);
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
			setCameraSize(value.width, value.height);
			moveCamera(value.x, value.y);
			invalidate(VALIDATION_FLAG_VIEWPORT);
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