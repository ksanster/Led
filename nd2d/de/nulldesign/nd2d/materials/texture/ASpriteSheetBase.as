/*
 * ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 * Author: Lars Gerckens
 * Copyright (c) nulldesign 2011
 * Repository URL: http://github.com/nulldesign/nd2d
 * Getting started: https://github.com/nulldesign/nd2d/wiki
 *
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package de.nulldesign.nd2d.materials.texture {

    import de.nulldesign.nd2d.geom.FrameRectangle;

    import flash.events.EventDispatcher;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    public class ASpriteSheetBase extends EventDispatcher {

		protected var frames:Vector.<FrameRectangle> = new Vector.<FrameRectangle>();
		protected var uvRects:Vector.<FrameRectangle>;
		protected var offsets:Vector.<Point> = new Vector.<Point>();
		protected var frameNameToIndex:Dictionary = new Dictionary();

		protected var spritesPackedWithoutSpace:Boolean;


		protected var frameIdx:uint = 0;

		public var frameUpdated:Boolean = true;


		protected var spWidth:Number;
		protected var spHeight:Number;

        protected var spHalfWidth:Number;
        protected var spHalfHeight:Number;

		protected var shWidth:Number;
		protected var shHeight:Number;

		public function get spriteWidth():Number {
			return spWidth;
		}

		public function get spriteHeight():Number {
			return spHeight;
		}

		public function get spriteHalfWidth():Number {
			return spHalfWidth;
		}

		public function get spriteHalfHeight():Number {
			return spHalfHeight;
		}

		protected var _frame:uint = int.MAX_VALUE;

		public function get frame():uint {
			return _frame;
		}

		public function set frame(value:uint):void {
			var config:FrameRectangle;
            if(frame != value)
            {
				_frame = value;
				frameUpdated = true;

				if(frames.length - 1 >= _frame)
                {
                    config       = frames[_frame];
					spWidth      = config.width;
					spHeight     = config.height;
                    spHalfWidth  = config.halfWidth;
                    spHalfHeight = config.halfHeight;
				}
			}
		}

		/**
		 * returns the total number of frames (sprites) in a spritesheet
		 */
		public function get totalFrames():uint {
			return frames.length;
		}

		public function ASpriteSheetBase() {

		}

		public function clone():ASpriteSheetBase {
			return null;
		}

		public function getOffsetForFrame():Point {
			return offsets[frame];
		}

		/**
		 * Returns the current selected frame rectangle if no frameIdx is specified, otherwise the rect of the given frameIdx
		 * @param frameIdx
		 * @return
		 */
		public function getDimensionForFrame(frameIdx:int = -1):FrameRectangle
        {
			return frames[frameIdx > -1 ? frameIdx : frame];
		}

		/**
		 * converts a frame name to a index
		 * @param name
		 * @return
		 */
		public function getIndexForFrame(name:String):uint {
			return frameNameToIndex[name];
		}

		/**
		 * sets an a frame by a given name
		 * @param value
		 */
		public function setFrameByName(value:String):void {
			frame = getIndexForFrame(value);
		}

		public function getUVRectForFrame(textureWidth:Number, textureHeight:Number):FrameRectangle
        {

			if(uvRects[frame]) {
				return uvRects[frame];
			}

			var rect:FrameRectangle = frames[frame].clone();

			rect.x += (textureWidth - shWidth) * .5;
			rect.y += (textureHeight - shHeight) * .5;

			if(spritesPackedWithoutSpace) {
				rect.x += 0.5;
				rect.y += 0.5;

				rect.width -= 1.0;
				rect.height -= 1.0;
			}

			rect.x /= textureWidth;
			rect.y /= textureHeight;
			rect.width /= textureWidth;
			rect.height /= textureHeight;

			uvRects[frame] = rect;

			return rect;
		}

        public function getSequenceByName (frameNamePattern:*):Vector.<uint>
        {
            var keyFramesIndices:Vector.<uint> = new <uint>[];
            var match:Vector.<KeyFrame> = new <KeyFrame>[];

            for (var frameName:String in frameNameToIndex)
            {
                if (frameName.match(frameNamePattern))
                {
                    match[match.length] = new KeyFrame(frameName, frameNameToIndex[frameName]);
                }
            }
            match.sort(compareFrames);
            for each (var keyFrame:KeyFrame in match)
            {
                keyFramesIndices[keyFramesIndices.length] = keyFrame.index;
            }
            return keyFramesIndices;
        }
		
		public function dispose():void
		{
			frames = null;
			offsets = null;
			frameNameToIndex = null;
			uvRects = null;
		}

        protected function compareFrames (frame1:KeyFrame, frame2:KeyFrame):int
        {
            if (frame1.name < frame2.name)
            {
                return -1;
            }
            else if (frame1.name > frame2.name)
            {
                return 1;
            }
            return 0;
        }
	}
}

internal class KeyFrame
{
    public var name:String;
    public var index:uint;

    public function KeyFrame(name:String, index:uint)
    {
        this.name  = name;
        this.index = index;
    }
}