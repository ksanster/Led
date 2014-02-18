package com.tengu.math
{
	
	import com.tengu.core.tengu_internal;
	
	import flash.geom.Rectangle;

	public final class IntRectangle
	{
		private var rX:int = 0;
        private var rY:int = 0;
        private var rWidth:int = 0;
        private var rHeight:int = 0;
        private var rRight:int = 0;
        private var rBottom:int = 0;
		
		private var nativeRectangle:Rectangle = new Rectangle();
		
		
		public function IntRectangle(xValue:int = 0, yValue:int = 0, w:int = 0, h:int = 0)
		{
			
			rX = xValue;
			rY = yValue;
			
			rWidth = w;
			rHeight = h;
			
			rRight = xValue + w;
			rBottom = yValue + h;
		}
		
		public function get x():int
		{
			return rX;
		}
		
		public function set x(value:int):void
		{
			rX = value;
			rRight = rWidth + value;
		}
		
		public function get y():int
		{
			return rY;
		}
		
		public function set y(value:int):void
		{
			rY = value;
			rBottom = rHeight + value;
		}
		
		public function get right():int
		{
			return rRight;
		}

        public function set right (value:int):void
        {
            width = value - rX;
        }
		
		public function get bottom():int
		{
			return rBottom;
		}

        public function set bottom (value:int):void
        {
            height = value - rY;
        }
		
		public function get width():int
		{
			return rWidth;
		}
		
		public function set width(value:int):void
		{
			rWidth = value;
			rRight = rX + value;
		}
		
		public function get height():int
		{
			return rHeight;
		}
		
		public function set height(value:int):void
		{
			rHeight = value;
			rBottom = rY + value;
		}

		public function toString():String
		{
			return "IntegerRectangle ["+rX+", "+rY+", "+rWidth+", "+rHeight+"]";
		}
		
		
		public function copy():IntRectangle
		{
			return new IntRectangle(rX, rY, rWidth, rHeight);
		}
		
		public function intersects(rect:IntRectangle):Boolean
		{
			if (    (rX <= rect.rX && rect.rX <= rRight)
				|| (rX <= rect.rRight && rect.rRight <= rRight))
			{ 
				
				if (rect.rY <= rY && rY <= rect.rBottom)
				{
					return true;
				}                      
				if (rect.rY <= rBottom && rBottom <= rect.rBottom)
				{
					return true;
				}      
			}

			if (    (rY <= rect.rY && rect.rY <= rBottom)  
				|| (rY <= rect.rBottom && rect.rBottom <= rBottom) )
			{
				
				if (rect.rX <= rX && rX <= rect.rRight)
				{
					return true;
				}
				if (rect.rX <= rRight && rRight <= rect.rRight)
				{
					return true;
				}
			}
			
			if (contains(rect) || rect.contains(this))
			{
				return true;
			}
			return false;
		}
		
		public function contains(rect:IntRectangle):Boolean
		{
			if (   (rX <= rect.rX && rY <= rect.rY) 
				&& (rect.rRight <= rRight) 
				&& (rect.rBottom <= rBottom))
			{
				return true;
			}
			return false;
		}
		
		public function containsCoords(px:int, py:int):Boolean
		{
			if (   (rX <= px && rY <= py) 
				&& (px <= rRight && py <= rBottom))
			{
				return true;
			}
			return false;
			
		}
		
		public function intersection(rect:IntRectangle):IntRectangle
		{
			var newRect:IntRectangle = new IntRectangle();
			
			if (contains(rect))
			{
				return rect.copy();
			}
			if (rect.contains(this))
			{
				return this.copy();
			}
			
			if (rect.containsCoords(x,y))
			{        
				newRect.x = rX;
				newRect.y = rY;
			}
			else if (containsCoords(rect.x, rect.y))
			{             
				newRect.x = rect.rX;
				newRect.y = rect.rY;
			}
			else if (   (rX <= rect.rX && rect.rX <= rRight)
				&& (rect.rY <= rY && rY <= rect.rBottom))
			{
				newRect.x = rect.rX;
				newRect.y = rY;
			}
			else if (   (rY <= rect.rY && rect.rY <= rBottom)
				&& (rect.rX <= rX && rX <= rect.rRight))
			{              
				newRect.x = rX;
				newRect.y = rect.rY;
			}
			else
			{
				return null;
			}

			if (rect.containsCoords(rRight, rBottom))
			{                        
				newRect.width = rRight - newRect.rX;
				newRect.height = rBottom - newRect.rY;
				newRect.width = (newRect.width > 0 ? newRect.width : 1);
				newRect.height = (newRect.height > 0 ? newRect.height : 1);
				return newRect;
			}
			else if (containsCoords(rect.rRight, rect.rBottom))
			{            
				newRect.width = rect.rRight - newRect.rX;
				newRect.height = rect.rBottom - newRect.rY;
				newRect.width = (newRect.width > 0 ? newRect.width : 1);
				newRect.height = (newRect.height > 0 ? newRect.height : 1);
				return newRect;
			}
			else if (   (rX <= rect.rRight && rect.rRight <= rRight)
				&& (rect.rY <= rBottom && rBottom <= rect.rBottom))
			{
				newRect.width = rect.rRight - newRect.rX;
				newRect.height = rBottom - newRect.rY;
				newRect.width = (newRect.width > 0 ? newRect.width : 1);
				newRect.height = (newRect.height > 0 ? newRect.height : 1);
				return newRect;
			}
			else if (   (rY <= rect.rBottom && rect.rBottom <= rBottom)
				&& (rect.rX <= rRight && rRight <= rect.rRight))
			{
				newRect.width = rRight - newRect.rX;
				newRect.height = rect.rBottom - newRect.rY;
				newRect.width = (newRect.width > 0 ? newRect.width : 1);
				newRect.height = (newRect.height > 0 ? newRect.height : 1);
				return newRect;
			}
			return null;
		}
		
		public function isEmpty():Boolean
		{
			if (rX == 0 && rY == 0 && rWidth == 0 && rHeight == 0)
			{
				return true;
			}
			return false;
		}
		
		public function area():int
		{
			return rWidth * rHeight;
		}
		
		public function offset(xCoord:int, yCoord:int):void
		{
			x += xCoord;
			y += yCoord;
		}
		
		public function offsetPoint(value:IntPoint):void
		{
			x += value.x;
			y += value.y;
		}
		
		public function clear():void
		{
			x = 0;
			y = 0;
			
			width = 0;
			height = 0;
		}
		
		public function toRectangle():Rectangle
		{
			nativeRectangle.x = rX;
			nativeRectangle.y = rY;
			nativeRectangle.width = rWidth;
			nativeRectangle.height = rHeight;
			return nativeRectangle;
		}
		
	}
}