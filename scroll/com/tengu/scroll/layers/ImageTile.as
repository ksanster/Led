package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameObject;
	import com.tengu.scene.objects.GameObject;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	public class ImageTile extends GameObject implements IGameObject
	{
		private var bitmapData:BitmapData;
		
		public function set bitmap(value:BitmapData):void 
		{
			bitmapData = value;
			setSize(value.width, value.height);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get bitmap():BitmapData
		{
			return bitmapData;
		}

		public function ImageTile()
		{
			super();
		}
	}
}