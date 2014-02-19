/**
 * Created with IntelliJ IDEA.
 * User: tengu
 * Date: 02.09.13
 * Time: 19:49
 * To change this template use File | Settings | File Templates.
 */
package de.nulldesign.nd2d.display
{
    import de.nulldesign.nd2d.materials.texture.ASpriteSheetBase;
    import de.nulldesign.nd2d.materials.texture.SpriteSheetAnimation;
    import de.nulldesign.nd2d.materials.texture.Texture2D;

    import flash.display3D.Context3D;

    import flash.utils.Dictionary;

    public class ContainerNode2D extends Node2D
    {
        internal var animationMap:Dictionary = new Dictionary();

        public var texture:Texture2D;
        public var spriteSheet:ASpriteSheetBase;

        public function ContainerNode2D (textureObject:Texture2D)
        {
            super();
            texture = textureObject;
        }

        public function setSpriteSheet(value:ASpriteSheetBase):void {
            spriteSheet = value;
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

        public override function dispose():void
        {
            if (spriteSheet != null)
            {
                spriteSheet.dispose();
            }
            for (var name:String in animationMap)
            {
                delete animationMap[name];
            }

            super.dispose();
        }

    }
}
