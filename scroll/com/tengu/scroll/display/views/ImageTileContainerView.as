package com.tengu.scroll.display.views
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.api.IObjectView;
	import com.tengu.scene.events.GameContainerEvent;
	import com.tengu.scroll.layers.ImageTileLayer;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class ImageTileContainerView extends BaseDisplayContainerView
	{
		private var shape:Shape;
		private var tileLayer:ImageTileLayer;
		
		private var views:Dictionary;
		private var objects:Vector.<IGameObject>;
		private var objectHash:Dictionary;
		
		public function ImageTileContainerView()
		{
			super();
		}
		
		private function addChildView (object:IGameObject):void
		{
			var result:BaseDisplayView = views[object];
			if (result == null)
			{
				result = viewFactory.createView(object) as BaseDisplayView;
				holder.addChild(result);
				result.awake();
				views[object] = result;
			}
		}
		
		private function removeChildView (object:IGameObject):void
		{
			var childView:IObjectView = views[object];
			var displayObject:BaseDisplayView = childView as BaseDisplayView;
			delete views[object];
			if (childView == null)
			{
				return;
			}
			if (displayObject.parent == holder)
			{
				holder.removeChild(displayObject);
			}
			childView.removeObject();
			childView.sleep();
			viewFactory.disposeView(childView);
		}
		
		private function validateVisibleBounds():void
		{
			for each (var object:IGameObject in objects)
			{
				if (screenBounds.intersects(object.bounds))
				{
					addChildView(object);
				}
				else
				{
					removeChildView(object);
				}
			}
		}
		
		private function drawGrid():void
		{
			var i:int;
			var xCoord:int;
			var yCoord:int;
			var tileWidth:int;
			var tileHeight:int;
			var tilesByX:int;
			var tilesByY:int;
			var graphix:Graphics = shape.graphics;
			
			graphix.clear();
			
			if (tileLayer == null || tileLayer.tileWidth == 0 || tileLayer.tileHeight == 0)
			{
				return;
			}
			
			graphix.lineStyle(0, 0xcccccc, .5);
			tileWidth  = tileLayer.tileWidth;
			tileHeight = tileLayer.tileHeight;
			xCoord = cameraX % tileWidth;
			yCoord = cameraY % tileHeight;
			tilesByX = xCoord + cameraWidth;
			tilesByY = yCoord + cameraHeight;
			
			for (i = xCoord; i < tilesByX; i += tileWidth)
			{
				if (i < 0)
				{
					continue;
				}
				graphix.moveTo(i, 0);
				graphix.lineTo(i, cameraHeight);
			}
			
			for (i = yCoord; i < tilesByY; i += tileHeight)
			{
				if (i < 0)
				{
					continue;
				}
				graphix.moveTo(0, i);
				graphix.lineTo(cameraWidth, i);
			}
		}
		
		protected override function updateViewport():void
		{
			super.updateViewport();
			drawGrid();
			validateVisibleBounds();
		}
		
		protected override function updateScale():void
		{
			drawGrid();
		}
		
		protected override function updatePosition():void
		{
			//			super.updatePosition();
//			drawGrid();
		}
		
		protected override function updateBounds():void
		{
			
		}

		protected override function initialize():void
		{
			super.initialize();
			
			views = new Dictionary();
			objects = new Vector.<IGameObject>();
			objectHash = new Dictionary();
			
			shape = new Shape();
			holder.addChild(shape);
		}
		
		public override function assignObject(value:IGameObject):void
		{
			super.assignObject(value);
			tileLayer = value as ImageTileLayer;
			tileLayer.addEventListener("tileSizeChanged", onChangeTileSize);
		}
		
		public override function removeObject():void
		{
			if (tileLayer != null)
			{
				tileLayer.removeEventListener("tileSizeChanged", onChangeTileSize);
				tileLayer = null;
			}
			super.removeObject();
		}

		private function onChangeTileSize(event:Event):void
		{
			invalidate(VALIDATION_FLAG_VIEWPORT);
		}
		
		protected override function onChildAdded(event:GameContainerEvent):void
		{
			const child:IGameObject = event.gameObject;
			if (objectHash[child] == null)
			{
				objects[objects.length] = child;
				objectHash[child] = true;
			}
			if (screenBounds.intersects(child.bounds))
			{
				addChildView(child);
				invalidate(BaseDisplayView.VALIDATION_FLAG_SORT);
			}
		}
		
		protected override function onChildRemoved(event:GameContainerEvent):void
		{
			var index:int;
			const child:IGameObject = event.gameObject;
			if (objectHash[child])
			{
				index = objects.indexOf(child);
				objects.splice(index, 1);
				delete objectHash[child];
			}
			removeChildView(child);
		}
	}
}