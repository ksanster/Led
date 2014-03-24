package com.tengu.tools.leditor.assets
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class EmbeddedTilesets
	{
		[Embed(source="/../assets/tiles.png")]
		public static const TILES:Class;

		public function EmbeddedTilesets()
		{
			throw new StaticClassConstructError(this);
		}
	}
}