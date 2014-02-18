package com.tengu.math
{
	import flash.geom.Point;

	public class IntPoint
	{
		private var point:Point;
		
		public var x:int = 0;
		public var y:int = 0;
		
		public function IntPoint(x:int = 0, y:int = 0)
		{
			this.x = x;
			this.y = y;
			point = new Point(x, y);
		}
		
		public function add(value:IntPoint):void
		{
			x += value.x;
			y += value.y;
		}
		
		public function subtract(value:IntPoint):void
		{
			x -= value.x;
			y -= value.y;
		}
			
		public function copy():IntPoint
		{
			return new IntPoint(x, y);
		}
		
		public function offset(dx:int, dy:int):void
		{
			x += dx;
			y += dy;
		}
		
		public function toString():String
		{
			return "IntegerPoint [" + x + ", " + y + "]";
		}
		
		public function toPoint():Point
		{
			point.x = x;
			point.y = y;
			return point;
		}
	}
}