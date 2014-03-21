package com.tengu.tools.leditor.logic.external
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class XMLProtocol
	{
		public static const LAYERS:String = "layers";
		public static const LAYER_TYPE:String = "layer-type";

		public static const LAYER:String = "layer";
		public static const Z_INDEX:String = "z-index";

		public static const WIDTH:String  = "width";
		public static const HEIGHT:String = "height";
		public static const TILE_WIDTH:String  = "tile-width";
		public static const TILE_HEIGHT:String = "tile-height";

		public static const BITMAP:String = "bitmap";

		public function XMLProtocol()
		{
			throw new StaticClassConstructError(this);
		}
	}
}