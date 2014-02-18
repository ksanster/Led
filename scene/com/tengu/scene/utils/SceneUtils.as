package com.tengu.scene.utils
{
	import com.tengu.core.errors.StaticClassConstructError;
	import com.tengu.math.IsoBounds;

	public class SceneUtils
	{
		private static const SCENE_POW:uint = 12;
		private static const MAX_COORD_VALUE:uint = Math.pow(2, SCENE_POW);
		private static const SCENE_OFFSET:uint = SCENE_POW + 1;

		public static function getCoordsUid (x:int, y:int):uint
		{
			return (x + MAX_COORD_VALUE) | ((y + MAX_COORD_VALUE) << SCENE_OFFSET);
		}
		
		public static function getBoundsUid (bounds: IsoBounds):uint
		{
			return getCoordsUid(bounds.x, bounds.y);
		}
		
		public function SceneUtils()
		{
			throw new StaticClassConstructError(this);
		}
		
	}
}