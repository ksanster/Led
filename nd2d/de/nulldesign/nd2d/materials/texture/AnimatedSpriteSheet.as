/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 02.09.13
 * Time: 16:40
 * To change this template use File | Settings | File Templates.
 */
package de.nulldesign.nd2d.materials.texture
{
    import de.nulldesign.nd2d.events.SpriteSheetAnimationEvent;

    import flash.utils.Dictionary;

    public class AnimatedSpriteSheet extends ASpriteSheetBase
    {
        protected var animationIndex:uint = 0;

        protected var fps:uint;
        protected var animationMap:Dictionary = new Dictionary();
        protected var activeAnimation:SpriteSheetAnimation;


        public function AnimatedSpriteSheet ()
        {
            super();
        }


        public function addAnimation(name:String, keyFrames:Array, loop:Boolean):void {

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
