package com.tengu.scroll.display.views
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scroll.layers.ImageTileLayer;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;

	public class ImageTileContainerView extends BaseDisplayContainerView
	{
		private var shape:Shape;
		private var tileLayer:ImageTileLayer;
		
		public function ImageTileContainerView()
		{
			super();
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
//			shape.x = - cameraHalfWidth;
//			shape.y = - cameraHalfHeight;
			
			graphix.lineStyle(0, 0xcccccc, .5);
			tileWidth  = tileLayer.tileWidth;
			tileHeight = tileLayer.tileHeight;
			xCoord = cameraX % tileWidth;
			yCoord = cameraY % tileHeight;
			tilesByX = xCoord + cameraWidth;
			tilesByY = yCoord + cameraHeight;
			
//			logger.debug("grid [" + xCoord + "," + yCoord + "]");
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
		}
		
		protected override function updatePosition():void
		{
//			super.updatePosition();
			drawGrid();
		}
		
		protected override function updateScale():void
		{
			drawGrid();
		}

		protected override function initialize():void
		{
			super.initialize();
			
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
			invalidate(VALIDATION_FLAG_VIEWPORT, VALIDATION_FLAG_POSITION);
		}
	}
}