package com.tengu.tools.leditor.logic.external
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class XMLProtocol
	{
		public static const LAYERS:String = "layers";
		public static const LAYER_TYPE:String = "layer-type";

		public static const LAYER:String = "layer";
		public static const Z_INDEX:String = "z-index";

		public static const BITMAP:String = "bitmap";

		public function XMLProtocol()
		{
			throw new StaticClassConstructError(this);
		}
	}
}