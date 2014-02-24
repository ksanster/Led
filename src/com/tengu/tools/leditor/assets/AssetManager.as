package com.tengu.tools.leditor.assets
{
	import com.tengu.tools.leditor.assets.api.IAssetManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class AssetManager implements IAssetManager
	{
		public function AssetManager()
		{
		}
		
		public function setPreviewSize(width:uint, height:uint):void
		{
		}
		
		public function addBitmap(id:String, bitmap:BitmapData):void
		{
		}
		
		public function getBitmap(id:String):Bitmap
		{
			return null;
		}
		
		public function getBitmapPreview(id:String):Bitmap
		{
			return null;
		}
	}
}