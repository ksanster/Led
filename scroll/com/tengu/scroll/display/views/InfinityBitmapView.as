package com.tengu.scroll.display.views
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scroll.layers.InfinityBitmapLayer;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class InfinityBitmapView extends BaseDisplayContainerView
	{
		private var bitmapLayer:InfinityBitmapLayer;
		
		private var shape:Shape;
		private var rectHalfHeight:uint = 1;
		
		private var rect:Rectangle;
		
		public function InfinityBitmapView()
		{
			super();
		}
		
		
		private function updateFill():void
		{
			var bitmapHeight:uint;
			var count:uint;
			var graphix:Graphics = shape.graphics;
			graphix.clear();
			
			if (bitmapLayer == null ||  bitmapLayer.bitmap == null)
			{
				return;
			}
			
			bitmapHeight = bitmapLayer.bitmap.height;
			count = cameraHeight / bitmapHeight;
			if ((cameraHeight % bitmapHeight) != 0)
			{
				count += 1;
			}
			rectHalfHeight = count * bitmapHeight;
			graphix.beginBitmapFill(bitmapLayer.bitmap);
			graphix.drawRect(0, 0, cameraWidth, 2 * rectHalfHeight);
			graphix.endFill();
			
			rect.width  = cameraWidth - 1;
			rect.height = cameraHeight - 1;
			holder.scrollRect = rect;
		}
		
		protected override function updateViewport():void
		{
			var yCoord:Number = - cameraY % rectHalfHeight;
			if (yCoord > 0)
			{
				yCoord = yCoord - rectHalfHeight;
			}
			
			shape.y = yCoord;
			updateFill();
		}
		
		protected override function initialize():void
		{
			super.initialize();
			
			shape = new Shape();
			holder.addChild(shape);
			
			rect = new Rectangle();
		}
		
		public override function assignObject(value:IGameObject):void
		{
			super.assignObject(value);
			bitmapLayer = value as InfinityBitmapLayer;
			bitmapLayer.addEventListener(Event.CHANGE, onChangeBitmap);
		}
		
		public override function removeObject():void
		{
			if (bitmapLayer != null)
			{
				bitmapLayer.removeEventListener(Event.CHANGE, onChangeBitmap);
				bitmapLayer = null;
			}
			super.removeObject();
		}
		
		private function onChangeBitmap(event:Event):void
		{
			invalidate(VALIDATION_FLAG_VIEWPORT, VALIDATION_FLAG_POSITION);
		}
	}
}