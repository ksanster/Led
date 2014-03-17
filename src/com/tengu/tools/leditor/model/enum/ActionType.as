package com.tengu.tools.leditor.model.enum
{
	import com.tengu.core.errors.StaticClassConstructError;

	public class ActionType
	{
		public static const MOVE:String  	= "move";
		public static const CENTER:String  	= "center";
		
		public static const DRAW:String  = "draw";
		public static const ERASE:String = "erase";
		
		public function ActionType()
		{
			throw new StaticClassConstructError(this);
		}
	}
}