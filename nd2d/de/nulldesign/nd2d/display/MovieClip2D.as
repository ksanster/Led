/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 02.09.13
 * Time: 15:34
 * To change this template use File | Settings | File Templates.
 */
package de.nulldesign.nd2d.display
{
    import de.nulldesign.nd2d.events.SpriteSheetAnimationEvent;
    import de.nulldesign.nd2d.geom.FrameRectangle;
    import de.nulldesign.nd2d.materials.BlendModePresets;
    import de.nulldesign.nd2d.materials.texture.ASpriteSheetBase;
    import de.nulldesign.nd2d.materials.texture.SpriteSheetAnimation;
    import de.nulldesign.nd2d.materials.texture.Texture2D;

    import flash.display3D.Context3D;
    import flash.utils.Dictionary;

    [Event(name="animationFinished", type="de.nulldesign.nd2d.events.SpriteSheetAnimationEvent")]
    public class MovieClip2D extends Sprite2D
    {
        internal var animationMap:Dictionary = new Dictionary();

        protected var animationIndex:uint = 0;

        protected var fpms:Number;
        protected var activeAnimation:SpriteSheetAnimation;

        protected var triggerEventOnLastFrame:Boolean = false;

        protected var ctime:Number = 0.0;
        protected var otime:Number = 0.0;
        protected var interp:Number = 0.0;


        public var spriteSheet:ASpriteSheetBase;

        protected override function set batchRoot (value:ContainerNode2D):void
        {
            super.batchRoot = value;
            if (spriteSheet == null && value != null && value.spriteSheet != null)
            {
                setSpriteSheet(value.spriteSheet.clone());
                const batchAnimations:Object = value.animationMap;
                for (var name:String in batchAnimations)
                {
                    animationMap[name] = batchAnimations[name];
                }
            }
        }

        public function MovieClip2D (textureObject:Texture2D = null, spriteSheet:ASpriteSheetBase = null, fps:uint = 0)
        {
            super(textureObject);
            this.spriteSheet = spriteSheet != null ? spriteSheet.clone() : null;
            this.fpms = fps * .001;
        }

        /**
         * @private
         */
        internal override function stepNode(elapsed:Number, timeSinceStartInSeconds:Number):void {

            super.stepNode(elapsed, timeSinceStartInSeconds);
            updateAnimation(timeSinceStartInSeconds);
        }

        protected function updateAnimation (timeSinceStartInSeconds:Number):void
        {
            if (spriteSheet == null || activeAnimation == null)
            {
                return;
            }

            var prevFrameIdx:int = animationIndex;

            ctime = timeSinceStartInSeconds;

            // Update the timer part, to get time based animation
            interp += fpms * (ctime - otime);
            if(interp >= 1.0) {
                animationIndex++;
                interp = 0;
            }

            if(activeAnimation.loop) {
                animationIndex = animationIndex % activeAnimation.numFrames;
            } else {
                animationIndex = Math.min(animationIndex, activeAnimation.numFrames - 1);
            }

            spriteSheet.frame = activeAnimation.frames[animationIndex];

            otime = ctime;

            // skipped frames
            if(triggerEventOnLastFrame && (animationIndex == activeAnimation.numFrames - 1 || animationIndex < prevFrameIdx)) {
                if(!activeAnimation.loop) {
                    triggerEventOnLastFrame = false;
                }
                dispatchEvent(new SpriteSheetAnimationEvent(SpriteSheetAnimationEvent.ANIMATION_FINISHED));
            }

            unscaledWidth = spriteSheet.spriteWidth;
            unscaledHeight = spriteSheet.spriteHeight;
        }

        protected override function draw(context:Context3D, camera:Camera2D):void
        {
            material.spriteSheet = spriteSheet;
            super.draw(context, camera);
        }

        override protected function hitTest():Boolean {

            if(usePixelPerfectHitTest && texture.bitmap) {

                var xCoord:Number = _mouseX + halfWidth;
                var yCoord:Number = _mouseY + halfHeight;

                if(spriteSheet) {
                    var rect:FrameRectangle = spriteSheet.getDimensionForFrame();
                    xCoord += rect.x;
                    yCoord += rect.y;
                }

                return super.hitTest() && (texture.bitmap.getPixel32(xCoord, yCoord) >> 24 & 0xFF) > 0;
            }

            return super.hitTest();
        }

        /**
         * @param SpriteSheet or TextureAtlas
         */
        public function setSpriteSheet(value:ASpriteSheetBase):void {
            this.spriteSheet = value;

            if(spriteSheet) {
                unscaledWidth  = spriteSheet.spriteWidth;
                unscaledHeight = spriteSheet.spriteHeight;
            }
        }

        /**
         * The texture object
         * @param Texture2D
         */
        public override function setTexture(value:Texture2D):void {

            this.texture = value;

            if (texture == null) {
                return;
            }

            if (spriteSheet == null)
            {
                unscaledWidth = texture.bitmapWidth;
                unscaledHeight = texture.bitmapHeight;
            }
            hasPremultipliedAlphaTexture = texture.hasPremultipliedAlpha;
            blendMode = texture.hasPremultipliedAlpha ? BlendModePresets.NORMAL_PREMULTIPLIED_ALPHA : BlendModePresets.NORMAL_NO_PREMULTIPLIED_ALPHA;
        }

        public function addAnimation (name:String, keyFrames:Vector.<uint>, loop:Boolean):SpriteSheetAnimation
        {
            const animation:SpriteSheetAnimation = new SpriteSheetAnimation(keyFrames, loop);
            animationMap[name] = animation;

            return animation;
        }

        public function addAnimationByName (name:String, frameNamePattern:*, loop:Boolean):SpriteSheetAnimation
        {
            if (spriteSheet == null)
            {
                return null;
            }
            const keyFramesIndices:Vector.<uint> = spriteSheet.getSequenceByName(frameNamePattern);
            const animation:SpriteSheetAnimation = new SpriteSheetAnimation(keyFramesIndices, loop);

            animationMap[name] = animation;
            return animation;
        }

        /**
         * starts to play an animation if a spritesheet / textureatlas exists and updates the size of the sprite immediately
         * @param name
         * @param startIdx
         * @param restart
         * @param triggerEventOnLastFrame
         */
        public function playAnimation(name:String, startIdx:uint = 0, restart:Boolean = false, triggerEventOnLastFrame:Boolean = false):void
        {
            if(spriteSheet == null)
            {
                return;
            }

            this.triggerEventOnLastFrame = triggerEventOnLastFrame;

            if(restart || activeAnimation != animationMap[name]) {
                animationIndex = startIdx;
                activeAnimation = animationMap[name];
                spriteSheet.frame = activeAnimation.frames[0];
            }

            unscaledWidth  = spriteSheet.spriteWidth;
            unscaledHeight = spriteSheet.spriteHeight;
        }

        public function stopCurrentAnimation():void {
            activeAnimation = null;
        }

        public function setFrame (animationName:String = null, index:uint = 0):void
        {
            const animation:SpriteSheetAnimation = animationMap[animationName] || activeAnimation;

            if (animation != null && spriteSheet != null)
            {
                spriteSheet.frame = animation.frames[index];
            }
        }

        public override function dispose():void
        {
            animationMap = null;

            if(activeAnimation)
            {
                activeAnimation.dispose();
                activeAnimation = null;
            }
            super.dispose();
        }

    }
}
