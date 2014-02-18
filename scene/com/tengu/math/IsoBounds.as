package com.tengu.math
{
	public class IsoBounds extends IsoCoords
	{
		public var width:int = 0;
		public var length:int = 0;
		public var height:int = 0;
		
		public var front:int = 0;
		public var right:int = 0;
		public var top:int = 0;
		
		public function IsoBounds (x:int = 0, y:int = 0, z:int = 0, width:int = 0, length:int = 0, height:int = 0)
		{
			super(x, y, z);
			this.width = width;
			this.length = length;
			this.height = height;
			
			this.front = y + length;
			this.right = x + width;
			this.top = z + height;
		}
		
		public override function toString ():String
		{
			return "IsoBounds [x:" + x + ", y:" + y + ", z:" + z + ", width:" + width + ", length:" + length + ", height:" + height + ", right:" + right + ", bottom:" + front + "]";
		}
	}
}