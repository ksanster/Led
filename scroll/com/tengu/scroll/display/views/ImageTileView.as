package com.tengu.scroll.display.views
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scroll.layers.ImageTile;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	import mx.effects.Glow;

	public class ImageTileView extends BaseDisplayView
	{
		private static const SELECT:Array = [ new GlowFilter(0xFFFF00, .8, 3, 3, 5, 3)];
		private static const UNSELECT:Array = [];
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
			bitmap.x = - tile.width * .5;
			bitmap.y = - tile.height * .5;
		}
		
		private function updateSelection ():void
		{
			filters = tile.selected ? SELECT : UNSELECT;
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
			tile.addEventListener(Event.SELECT, onSelect);
			updateBitmap();
			updateSelection();
		}
		
		public override function removeObject():void
		{
			if (tile != null)
			{
				tile.removeEventListener(Event.SELECT, onSelect);
				tile.removeEventListener(Event.CHANGE, onChangeBitmap);
				tile = null;
			}
			super.removeObject();
		}
		
		private function onChangeBitmap(event:Event):void
		{
			updateBitmap();			
		}
		
		
		private function onSelect(event:Event):void
		{
			updateSelection();
		}

	}
}