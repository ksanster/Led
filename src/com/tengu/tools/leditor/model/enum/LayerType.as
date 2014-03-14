package com.tengu.tools.leditor.model.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class LayerType
	{
		public static const INFINITE_BITMAP:String = "infiniteBitmap";
		public static const IMAGE_TILES:String 		= "imageTiles";
		public static const OBJECTS:String 			= "objects";
		
		public function LayerType()
		{
			throw new StaticClassConstructError(this);
		}
	}
}