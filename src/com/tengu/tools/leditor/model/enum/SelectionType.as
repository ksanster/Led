package com.tengu.tools.leditor.model.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class SelectionType
	{
		public static const NONE:String = "none";
		public static const TILE:String = "tile";
		
		public function SelectionType()
		{
			throw new StaticClassConstructError(this);
		}
	}
}