/**
 * Created with IntelliJ IDEA.
 * User: tengu
 * Date: 17.09.13
 * Time: 22:54
 * To change this template use File | Settings | File Templates.
 */
package de.nulldesign.nd2d.geom
{
    public class FrameRectangle
    {
        public var x:Number          = 0;
        public var y:Number          = 0;
        public var width:Number      = 0;
        public var height:Number     = 0;
        public var halfWidth:Number  = 0;
        public var halfHeight:Number = 0;

        public function FrameRectangle(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
        {
            this.x = x;
            this.y = y;
            this.width  = width;
            this.height = height;
            this.halfWidth  = width * .5;
            this.halfHeight = height * .5;
        }

        public function clone ():FrameRectangle
        {
            return new FrameRectangle(x, y,  width, height);
        }
    }
}
