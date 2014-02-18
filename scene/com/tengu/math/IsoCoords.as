package com.tengu.math
{
	public class IsoCoords
	{
		public var x:int = 0;
		public var y:int = 0;
		public var z:int = 0;
		
		public function IsoCoords(x:int = 0, y:int = 0, z:int = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function toString ():String
		{
			return "IsoCoords [x:" + x + ", y:" + y + ", z:" + z + "]";
		}
		
	}
}