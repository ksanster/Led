/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 02.09.13
 * Time: 12:11
 * To change this template use File | Settings | File Templates.
 */
package de.nulldesign.nd2d.materials.texture.parser
{
    import de.nulldesign.nd2d.geom.FrameRectangle;

    import flash.geom.Point;

    public class StarlingParser extends ATextureAtlasParser
    {
        private static const NAME:String            = "name";
        private static const X_COORD:String         = "x";
        private static const Y_COORD:String         = "y";
        private static const WIDTH:String           = "width";
        private static const HEIGHT:String          = "height";
        private static const FRAME_X_COORD:String   = "frameX"
        private static const FRAME_Y_COORD:String   = "frameY"
        private static const FRAME_WIDTH:String     = "frameWidth"
        private static const FRAME_HEIGHT:String    = "frameHeight"

        public function StarlingParser ()
        {
            super();
        }

        public override function parse(data:XML):void
        {
            const list:XMLList = data.children();
            var name:String;
            var x:Number;
            var y:Number;
            var width:Number;
            var height:Number;
            var frameX:Number;
            var frameY:Number;
            var frameWidth:Number;
            var frameHeight:Number;
            var index:uint = 0;

            for each (var subTexture:XML in list)
            {
                name    = String(subTexture.@[NAME]);
                x       = parseFloat(String(subTexture.@[X_COORD]));
                y       = parseFloat(String(subTexture.@[Y_COORD]));
                width   = parseFloat(String(subTexture.@[WIDTH]));
                height  = parseFloat(String(subTexture.@[HEIGHT]));

                frameX  = parseFloat(String(subTexture.@[FRAME_X_COORD]))    || 0;
                frameY  = parseFloat(String(subTexture.@[FRAME_Y_COORD]))    || 0;
                frameWidth  = parseFloat(String(subTexture.@[FRAME_WIDTH]))  || 0;
                frameHeight = parseFloat(String(subTexture.@[FRAME_HEIGHT])) || 0;

                frameNameToIndex[name] = index++;
                frames[frames.length] = new FrameRectangle(x, y, width, height);

                offsets[offsets.length] = new Point(0, 0);
//                offsets[offsets.length] = new Point(- frameX, - frameY);
            }
        }
    }
}
