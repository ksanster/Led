package com.tengu.scroll.view
{
    import com.tengu.scene.api.ICameraView;
    import com.tengu.scene.api.IContainerView;
    import com.tengu.scene.api.IViewport;

    import de.nulldesign.nd2d.display.Node2D;
    import de.nulldesign.nd2d.display.Scene2D;

    import flash.utils.Dictionary;

    public class ScrolledViewport implements IViewport
	{
        private static const DUMP:Number = .1;

        private static const MIN_SCALE_FACTOR:Number = .00001;
		private var scenes:Vector.<IContainerView> = null;

        private var nd2dScene:Scene2D;
		private var cameraX:Number = 0;
		private var cameraY:Number = 0;
        private var cameraScale:Number    = 1;
        private var cameraRotation:Number = 0;

        private var mapFocalLength:uint = 300;

		private var viewportWidth:int = 0;
		private var viewportHeight:int = 0;

        private var focalXs:Dictionary;
        private var focalYs:Dictionary;

        public function set focalLength (value:int):void
        {
            mapFocalLength = value;
        }

		public function ScrolledViewport(nd2dScene:Scene2D)
		{
			super();
			initialize(nd2dScene);
		}

		private function initialize (nd2dScene:Scene2D):void
		{
            this.nd2dScene = nd2dScene;
			scenes = new Vector.<IContainerView>();
            focalXs = new Dictionary();
            focalYs = new Dictionary();
		}
		
		protected function updateCameraPosition ():void
		{
            var focalX:int;
            var focalY:int;
            var xCoord:Number;
            var yCoord:Number;
			for each (var sceneView:ICameraView in scenes)
			{
                focalX = focalXs[sceneView];
                focalY = focalYs[sceneView];
				xCoord = cameraX * mapFocalLength / (mapFocalLength + focalX);
				yCoord = cameraY * mapFocalLength / (mapFocalLength + focalY);
                sceneView.moveCamera(xCoord, yCoord);
			}
		}
		
		protected function updateCameraScale ():void
		{
			for each (var sceneView:ICameraView in scenes)
			{
				sceneView.setCameraScale(cameraScale);
			}
		}

        protected function updateCameraRotation ():void
        {
            for each (var sceneView:ICameraView in scenes)
            {
                sceneView.setCameraRotation(cameraScale);
            }
        }
		
		public function addSceneView (value:ICameraView, focalX:int = 0, focalY:int = 0):void
		{
			value.setCameraScale(cameraScale);
            value.setCameraSize(viewportWidth, viewportHeight);
            value.moveCamera(cameraX, cameraY);
			
			scenes[scenes.length] = value;
			focalXs[value] = focalX;
			focalYs[value] = focalY;

            nd2dScene.addChild(value as Node2D);
		}

        public function update (dx:Number, dy:Number, scaleFactor:Number):void
        {
            if (dx == 0 && dy == 0 && scaleFactor == 0)
            {
                return;
            }
            var focalX:int;
            var focalY:int;
            var newScale:Number = cameraScale + scaleFactor;

            cameraScale += (newScale - cameraScale) * DUMP * .8;
            cameraX += dx * DUMP;
            cameraY += dy * DUMP;

            for each (var sceneView:ICameraView in scenes)
            {
                focalX = focalXs[sceneView];
                focalY = focalYs[sceneView];
                sceneView.setCameraScale(cameraScale);
                sceneView.moveCamera(cameraX * mapFocalLength / (mapFocalLength + focalX), cameraY * mapFocalLength / (mapFocalLength + focalY));
            }

        }
		
		public function setSize (width:int, height:int):void
		{
            if (viewportWidth == width && viewportHeight == height)
            {
                return;
            }
			viewportWidth  = width;
			viewportHeight = height;

            for each (var scene:ICameraView in scenes)
            {
                scene.setCameraSize(width, height);
            }
		}
		
		public function moveTo (x:Number, y:Number):void
		{
            if (cameraX == x && cameraY == y)
            {
                return;
            }
			cameraX = x;
			cameraY = y;
			updateCameraPosition();
		}
		
		public function moveBy (dx:Number, dy:Number):void
		{
			cameraX += dx;
			cameraY += dy;
			updateCameraPosition();
		}
		
		public function scaleTo(value:Number):void
		{
			if (cameraScale == value)
			{
				return;
			}
			cameraScale = value;
			updateCameraScale();
		}


        public function rotateTo (angle:Number):void
        {
            if (cameraRotation == angle)
            {
                return;
            }
            cameraRotation = angle;
            updateCameraRotation();
        }

        public function get centerX ():Number
		{
			return cameraX;
		}
		
		public function get centerY ():Number
		{
			return cameraY;
		}
    }
}