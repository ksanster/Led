package com.tengu.tools.leditor.assets.api
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public interface IAssetManager
	{
		function setPreviewSize (width:uint, height:uint):void;
		
		function addBitmap (id:String, bitmap:BitmapData):void;
		
		function getBitmap (id:String):Bitmap;
		function getBitmapPreview (id:String):Bitmap;
		
	}
}