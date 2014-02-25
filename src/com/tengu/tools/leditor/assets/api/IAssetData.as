package com.tengu.tools.leditor.assets.api
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public interface IAssetData
	{
		function get id():String;
		function get bitmap ():BitmapData;
		function get preview ():BitmapData;
	}
}