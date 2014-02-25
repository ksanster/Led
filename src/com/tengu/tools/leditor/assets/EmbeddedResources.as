package com.tengu.tools.leditor.assets
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class EmbeddedResources
	{
		[Embed(source="/../assets/sky.jpg")]
		public static const SKY:Class;
		
		[Embed(source="/../assets/cloud.png")]
		public static const CLOUDS:Class;

		public function EmbeddedResources()
		{
			throw new StaticClassConstructError(this);
		}
	}
}