package com.tengu.tools.leditor.assets
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class EmbeddedTilesets
	{
		public function EmbeddedTilesets()
		{
			throw new StaticClassConstructError(this);
		}
	}
}