/**
 * Created with IntelliJ IDEA.
 * User: a.semin
 * Date: 03.09.13
 * Time: 12:08
 * To change this template use File | Settings | File Templates.
 */
package com.tengu.scroll.view
{
    import com.tengu.scene.api.IGameObject;
    import com.tengu.scene.api.IViewport;
    import com.tengu.scene.events.GameObjectEvent;
    
    import de.nulldesign.nd2d.display.Scene2D;

    public class MainScene extends Scene2D
    {
        private static const moveZoomFactor:Number = .08;

        private var sceneViewport:ScrolledViewport;
        private var sceneTarget:IGameObject;

        private var oldDistanceY:Number = 0;

		private var oldX:Number;
		private var oldY:Number;
		
        public function get viewport ():IViewport
        {
            return sceneViewport;
        }

        public function MainScene ()
        {
            super();
            sceneViewport = new ScrolledViewport(this);
        }

        private function setCameraToTarget ():void
        {
            const xCoord:Number     = sceneTarget.x;
            const yCoord:Number     = sceneTarget.y;

            const dy:Number     = yCoord - oldY;
            const dZoom:Number  = (dy - oldDistanceY) * moveZoomFactor;

            sceneViewport.update((xCoord - viewport.centerX),
                                 (yCoord - viewport.centerY),
                                 dZoom);

			oldX = xCoord;
			oldY = yCoord;
            oldDistanceY = dy;
        }

        public function setTarget (value:IGameObject):void
        {
            if (sceneTarget != null)
            {
                sceneTarget.removeEventListener(GameObjectEvent.OBJECT_COORDS_CHANGED, onTargetCoordsChanged);
                sceneTarget.removeEventListener(GameObjectEvent.OBJECT_FINALIZED, onTargetFinalize);
            }

            sceneTarget = value;

            if (sceneTarget != null)
            {
				oldX = value.x;
				oldY = value.y;

                sceneTarget.addEventListener(GameObjectEvent.OBJECT_COORDS_CHANGED, onTargetCoordsChanged);
                sceneTarget.addEventListener(GameObjectEvent.OBJECT_FINALIZED, onTargetFinalize);
            }
        }

        private function onTargetCoordsChanged (event:GameObjectEvent):void
        {
            setCameraToTarget();
        }

        private function onTargetFinalize (event:GameObjectEvent):void
        {
            setTarget(null);
        }
    }
}
