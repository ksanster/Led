package com.tengu.tools.leditor.assets.api
{
	import flash.display.BitmapData;

	public interface IAssetManager
	{
		function get assetList ():Vector.<IAssetData>;
		
		function setPreviewSize (width:uint, height:uint):void;
		
		function addAsset (id:String, bitmapData:BitmapData):void;
		function getAsset (id:String):IAssetData;
		function getAssetByBitmap (bitmap:BitmapData):IAssetData

		function getTileList (assetId:String, tileWidth:uint, tileHeight:uint):Vector.<BitmapData>;
	}
}