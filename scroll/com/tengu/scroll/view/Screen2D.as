package com.tengu.scroll.view
{
    import com.tengu.log.LogFactory;
    
    import de.nulldesign.nd2d.display.Camera2D;
    import de.nulldesign.nd2d.display.World2D;
    
    import flash.display3D.Context3DRenderMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    
    import net.hires.debug.Stats;

    public class Screen2D extends World2D
	{
        private var stats:Stats;
        private var ndScene:MainScene;

        public function get mainScene ():MainScene
        {
            return ndScene;
        }

        public function get mainCamera ():Camera2D
        {
            return camera;
        }

		public function Screen2D(bounds:Rectangle = null)
		{
            enableErrorChecking = true;
			super(Context3DRenderMode.AUTO, 60, bounds );
			sleep();
		}
		
		public function configure ():void
		{
			createSceneView();

            stats = new Stats();
            addChild(stats);
		}

		private function createSceneView ():void
		{
            ndScene = new MainScene();
//            setActiveScene(ndScene);
		}

        protected override function mainLoop(e:Event):void
        {
            super.mainLoop(e);
            stats.update(statsObject.totalDrawCalls, statsObject.totalTris, statsObject.elapsed);
        }

        protected override function context3DCreated(e:Event):void
        {
            super.context3DCreated(e);
			LogFactory.getLogger(this).info("context created");
            if (context3D)
            {
                stats.driverInfo = context3D.driverInfo;
            }
        }

        protected override function addedToStage(event:Event):void
        {
            super.addedToStage(event);
            configure();
        }

    }
}