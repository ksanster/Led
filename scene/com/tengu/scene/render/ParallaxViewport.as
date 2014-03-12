package com.tengu.scene.render
{
    import com.tengu.scene.api.ICameraView;
    import com.tengu.scene.api.IContainerView;
    import com.tengu.scene.api.IScrolledViewport;

    public class ParallaxViewport implements IScrolledViewport
	{
        private static const DUMP:Number = .1;

        private static const MIN_SCALE_FACTOR:Number = .00001;
		private var scenes:Vector.<IContainerView> = null;

		private var cameraX:Number = 0;
		private var cameraY:Number = 0;
        private var cameraScale:Number    = 1;
        private var cameraRotation:Number = 0;

        private var mapFocalLength:uint = 300;

		private var viewportWidth:int = 0;
		private var viewportHeight:int = 0;

        public function set focalLength (value:int):void
        {
            mapFocalLength = value;
        }

		public function ParallaxViewport()
		{
			super();
			initialize();
		}

		protected function initialize ():void
		{
			scenes = new Vector.<IContainerView>();
		}
		
		protected function updateCameraPosition ():void
		{
            var focalDistance:int;
            var xCoord:Number;
            var yCoord:Number;
			for each (var sceneView:ICameraView in scenes)
			{
				focalDistance = sceneView.object.z;
				xCoord = cameraX * mapFocalLength / (mapFocalLength + focalDistance);
				yCoord = cameraY * mapFocalLength / (mapFocalLength + focalDistance);
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
		
		protected function addToContainer (value:ICameraView):void
		{
			//Abstract
		}
		
		protected function removeFromContainer (value:ICameraView):void
		{
			//Abstract
		}
		
		public function addSceneView (value:ICameraView, focalX:int = 0, focalY:int = 0):void
		{
			value.setCameraScale(cameraScale);
            value.setCameraSize(viewportWidth, viewportHeight);
            value.moveCamera(cameraX, cameraY);
			
			scenes[scenes.length] = value;
//			focalXs[value] = focalX;
//			focalYs[value] = focalY;

			addToContainer(value);
		}

		public function removeSceneView (value:ICameraView):void
		{
			var idx:int = scenes.indexOf(value);
			if (idx != -1)
			{
				scenes.splice(idx, 1);
			}
			
			removeFromContainer(value);
		}
									  
        public function update (dx:Number, dy:Number, scaleFactor:Number):void
        {
            if (dx == 0 && dy == 0 && scaleFactor == 0)
            {
                return;
            }
            var focalDistance:int;
            var newScale:Number = cameraScale + scaleFactor;

            cameraScale += (newScale - cameraScale) * DUMP * .8;
            cameraX += dx * DUMP;
            cameraY += dy * DUMP;

            for each (var sceneView:ICameraView in scenes)
            {
				focalDistance = sceneView.object.z;
                sceneView.setCameraScale(cameraScale);
                sceneView.moveCamera(cameraX * mapFocalLength / (mapFocalLength + focalDistance), 
									 cameraY * mapFocalLength / (mapFocalLength + focalDistance));
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
//			trace(cameraY, dy);
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