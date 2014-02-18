package com.tengu.scene.enum
{
	import com.tengu.core.enum.Constant;

	public class InvalidationType extends Constant
	{
		public static const ALL:String 				= "all";
		public static const POSITION:String 		= "position";
		public static const SCALE:String 		    = "scale";
		public static const ROTATION:String 		= "rotation";
		public static const SORT:String 			= "sort";
		public static const CHILD_BOUNDS:String 	= "child_bounds";
		public static const VISIBLE_BOUNDS:String 	= "visible_bounds";
		
		public function InvalidationType(name:String)
		{
			super(name);
		}
	}
}