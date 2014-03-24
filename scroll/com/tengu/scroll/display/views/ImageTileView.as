package com.tengu.scroll.display.views
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scroll.layers.ImageTile;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	public class ImageTileView extends BaseDisplayView
	{
		private var bitmap:Bitmap;
		private var tile:ImageTile;
		
		public function ImageTileView()
		{
			super();
		}
		
		private function updateBitmap():void
		{
			if (tile == null)
			{
				return;
			}
			bitmap.bitmapData = tile.bitmap;
			bitmap.x = - tile.bounds.width * .5;
			bitmap.y = - tile.bounds.height * .5;
		}
		
		protected override function initialize():void
		{
			super.initialize();
			bitmap = new Bitmap();
			addChild(bitmap);
		}

		public override function assignObject(value:IGameObject):void
		{
			super.assignObject(value);
			tile = value as ImageTile;
			tile.addEventListener(Event.CHANGE, onChangeBitmap);
			updateBitmap();
		}
		
		public override function removeObject():void
		{
			if (tile != null)
			{
				tile.removeEventListener(Event.CHANGE, onChangeBitmap);
				tile = null;
			}
			super.removeObject();
		}
		
		private function onChangeBitmap(event:Event):void
		{
			updateBitmap();			
		}
	}
}