package com.tengu.geom
{
	public class Vector2d
	{
		private static const cache:Vector.<Vector2d> = new Vector.<Vector2d>();
		
		public static function create (x:Number = 0, y:Number = 0):Vector2d
		{
			var result:Vector2d;
			if (cache.length > 0)
			{
				result = cache.pop();
                result.finalized = false;
				result.copyXY(x, y);
			}
			else
			{
				result = new Vector2d(x, y);
			}
			return result;
		}

        public static function toCache (...vectors):void
        {
            for each (var vector:Vector2d in vectors)
            {
                if (vector != null)
                {
                    vector.free();
                }
            }
        }
		
		private static const _RadsToDeg:Number = 180 / Math.PI;
		public static const Zero:Vector2d = new Vector2d;
		public static const Epsilon:Number = 0.0000001;
		public static const EpsilonSqr:Number = Epsilon * Epsilon;

        private  var finalized:Boolean = false;
		internal var _x:Number;
		internal var _y:Number;
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function get y():Number 
		{
			return _y;
		}

		public function set x(x:Number):void 
		{ 
			_x = x; 
		}
		public function set y(y:Number):void 
		{ 
			_y = y; 
		}

		public function Vector2d(x:Number = 0, y:Number = 0)
		{
			_x = x;
			_y = y;
		}
		
		public function free ():void
		{
            if (!finalized)
            {
			    cache[cache.length] = this;
                finalized = true;
            }
		}
		
		public function copy(pos:Vector2d):Vector2d
		{
			_x = pos._x;
			_y = pos._y;
			return this;
		}
		public function copyXY(x:Number, y:Number):Vector2d
		{
			_x = x;
			_y = y;
			return this;
		}
		public function clear():Vector2d
		{
			_x = 0;
			_y = 0;
			return this;
		}
		
		/**
		 * Add, sub, mul and div
		 */
		public function add(pos:Vector2d):Vector2d 
		{ 
			return create(_x + pos._x, _y + pos._y); 
		}
		public function addXY(x:Number, y:Number):Vector2d 
		{ 
			return create(_x + x, _y + y); 
		}
		
		public function sub(pos:Vector2d):Vector2d 
		{ 
			return create(_x - pos._x, _y - pos._y); 
		}
		public function subXY(x:Number, y:Number):Vector2d 
		{ 
			return create(_x - x, _y - y); 
		}
		
		public function mul(vec:Vector2d):Vector2d 
		{ 
			return create(_x * vec._x, _y * vec._y); 
		}
		public function mulXY(x:Number, y:Number):Vector2d 
		{ 
			return create(_x * x, _y * y); 
		}
		
		public function div(vec:Vector2d):Vector2d 
		{ 
			return create(_x / vec._x, _y / vec._y); 
		}
		public function divXY(x:Number, y:Number):Vector2d 
		{ 
			return create(_x / x, _y / y); 
		}
		
		/**
		 * Scale
		 */
		public function scale(s:Number):Vector2d 
		{ 
			return create(_x * s, _y * s); 
		}
		
		/**
		 * Normalize
		 */
		public function normalize():Vector2d
		{
			const nf:Number = 1 / Math.sqrt(_x * _x + _y * _y);
			return create(_x * nf, _y * nf);
		}

		
		/**
		 * Add
		 */
		public function addSelf(pos:Vector2d):Vector2d
		{
			_x += pos._x;
			_y += pos._y;
			return this;
		}
		public function addXYSelf(x:Number, y:Number):Vector2d
		{
			_x += x;
			_y += y;
			return this;
		}
		
		/**
		 * Sub
		 */
		public function subSelf(pos:Vector2d):Vector2d
		{
			_x -= pos._x;
			_y -= pos._y;
			return this;
		}
		public function subXYSelf(x:Number, y:Number):Vector2d
		{
			_x -= x;
			_y -= y;
			return this;
		}
		
		/**
		 * Mul
		 */
		public function mulSelf(vec:Vector2d):Vector2d
		{
			_x *= vec._x;
			_y *= vec._y;
			return this;
		}
		public function mulXYSelf(x:Number, y:Number):Vector2d
		{
			_x *= x;
			_y *= y;
			return this;
		}
		
		/**
		 * Div
		 */
		public function divSelf(vec:Vector2d):Vector2d
		{
			_x /= vec._x;
			_y /= vec._y;
			return this;
		}
		public function divXYSelf(x:Number, y:Number):Vector2d
		{
			_x /= x;
			_y /= y;
			return this;
		}
		
		/**
		 * Scale
		 */
		public function scaleSelf(s:Number):Vector2d
		{
			_x *= s;
			_y *= s;
			return this;
		}
		
		/**
		 * Normalize
		 */
		public function normalizeSelf():Vector2d
		{
			const nf:Number = 1 / Math.sqrt(_x * _x + _y * _y);
			_x *= nf;
			_y *= nf;
			return this;
		}
		
		/**
		 * Rotate
		 */
		public function rotateSelf(rads:Number):Vector2d
		{
			const s:Number = Math.sin(rads);
			const c:Number = Math.cos(rads);
			const xr:Number = _x * c - _y * s;
			_y = _x * s + _y * c;
			_x = xr;
			return this;
		}
		public function normalRightSelf():Vector2d
		{
			const xr:Number = _x;
			_x = -_y
				_y = xr;
			return this;
		}
		public function normalLeftSelf():Vector2d
		{
			const xr:Number = _x;
			_x = _y
			_y = -xr;
			return this;
		}
		public function negateSelf():Vector2d
		{
			_x = -_x;
			_y = -_y;
			return this;
		}
		
		public function abs ():Vector2d
		{
			var xCoord:Number = (x < 0) ? - x : x;
			var yCoord:Number = (y < 0) ? - y : y;
			return create(xCoord, yCoord);
		}
		
		/**
		 * Spinor
		 */
		public function rotateSpinorSelf(vec:Vector2d):Vector2d
		{
			const xr:Number = _x * vec._x - _y * vec._y;
			_y = _x * vec._y + _y * vec._x;
			_x = xr;
			return this;
		}
		
		/**
		 * lerp
		 */
		public function lerpSelf(to:Vector2d, t:Number):Vector2d
		{
			_x = _x + t * (to._x - _x);
			_y = _y + t * (to._y - _y);
			return this;
		}
		
		public function clone():Vector2d 
		{ 
			return create(_x, _y); 
		}
		
		/**
		 * Distance
		 */
		public function length():Number { return Math.sqrt(_x * _x + _y * _y); }
		public function lengthSqr():Number { return _x * _x + _y * _y; }
		public function distance(vec:Vector2d):Number
		{
			const xd:Number = _x - vec._x;
			const yd:Number = _y - vec._y;
			return Math.sqrt(xd * xd + yd * yd);
		}
		public function distanceXY(x:Number, y:Number):Number
		{
			const xd:Number = _x - x;
			const yd:Number = _y - y;
			return Math.sqrt(xd * xd + yd * yd);
		}
		public function distanceSqr(vec:Vector2d):Number
		{
			const xd:Number = _x - vec._x;
			const yd:Number = _y - vec._y;
			return xd * xd + yd * yd;
		}
		public function distanceXYSqr(x:Number, y:Number):Number
		{
			const xd:Number = _x - x;
			const yd:Number = _y - y;
			return xd * xd + yd * yd;
		}
		
		/**
		 * Queries.
		 */
		public function equals(vec:Vector2d):Boolean 
		{ 
			return _x == vec._x && _y == vec._y; 
		}
		public function equalsXY(x:Number, y:Number):Boolean 
		{ 
			return _x == x && _y == y; 
		}
		public function get isNormalized():Boolean 
		{ 
			return Math.abs((_x * _x + _y * _y)-1) < EpsilonSqr; 
		}
		public function get isZero():Boolean 
		{ 
			return _x == 0 && _y == 0; 
		}
		public function isNear(Vector2d:Vector2d):Boolean 
		{ 
			return distanceSqr(Vector2d) < EpsilonSqr; 
		}
		public function isNearXY(x:Number, y:Number):Boolean 
		{ 
			return distanceXYSqr(x, y) < EpsilonSqr; 
		}
		public function isWithin(Vector2d:Vector2d, epsilon:Number):Boolean 
		{ 
			return distanceSqr(Vector2d) < epsilon*epsilon; 
		}
		public function isWithinXY(x:Number, y:Number, epsilon:Number):Boolean 
		{ 
			return distanceXYSqr(x, y) < epsilon*epsilon; 
		}
		public function get isValid():Boolean 
		{ 
			return !isNaN(_x) && !isNaN(_y) && isFinite(_x) && isFinite(_y); 
		}
		public function getDegrees():Number 
		{ 
			return getRads() * _RadsToDeg; 
		}
		public function getRads():Number 
		{ 
			return Math.atan2(_y, _x); 
		}
		
		/**
		 * Dot product
		 */
		public function dot(vec:Vector2d):Number { return _x * vec._x + _y * vec._y; }
		public function dotXY(x:Number, y:Number):Number { return _x * x + _y * y; }
		
		/**
		 * Cross determinant
		 */
		public function crossDet(vec:Vector2d):Number { return _x * vec._y - _y * vec._x; }
		public function crossDetXY(x:Number, y:Number):Number { return _x * y - _y * x; }

		/**
		 * Reflect
		 */
		public function reflect(normal:Vector2d):Vector2d
		{
			const d:Number = 2 * (_x * normal._x + _y * normal._y);
			return create(_x - d * normal._x, _y - d * normal._y);
		}
		
		/**
		 * Helpers
		 */
		public static function swap(a:Vector2d, b:Vector2d):void
		{
			const x:Number = a._x;
			const y:Number = a._y;
			a._x = b._x;
			a._y = b._y;
			b._x = x;
			b._y = y;
		}
		
		public function toString ():String
		{
			return "[x:" + x + ", y:" + y + "]";
		}
		
	}
}