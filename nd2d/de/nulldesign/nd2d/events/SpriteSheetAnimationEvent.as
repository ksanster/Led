package de.nulldesign.nd2d.events {

    import flash.events.Event;

    public class SpriteSheetAnimationEvent extends Event {

        public static const ANIMATION_FINISHED:String = "animationFinished";

        public function SpriteSheetAnimationEvent(type:String) {
            super(type);
        }
    }
}