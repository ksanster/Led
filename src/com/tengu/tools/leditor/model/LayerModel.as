package com.tengu.tools.leditor.model
{
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	public class LayerModel
	{
		private var availableTypes:ArrayCollection;
		private var ledLayers:ArrayCollection;
		private var layer:IEditableLayer;
		
		[Bindable]
		public function set activeLayer(value:IEditableLayer):void
		{
			layer = value;
		}
		
		public function get activeLayer():IEditableLayer
		{
			return layer;
		}
		
		[Bindable]
		public function get layerList():IList
		{
			return ledLayers;
		}
		
		[Bindable]
		public function get availableLayerTypes ():IList 
		{
			return availableTypes;
		}

		public function LayerModel()
		{
			initialize();
		}
		
		private function initialize():void
		{
			availableTypes = new ArrayCollection();
			ledLayers = new ArrayCollection();
			
			availableTypes.addItem( new LayerInfo(LayerType.INFINITE_BITMAP, "Looped bitmap") );
			availableTypes.addItem( new LayerInfo(LayerType.BITMAP, "Bitmap") );
			availableTypes.addItem( new LayerInfo(LayerType.IMAGE_TILES, "Image tiles") );
			availableTypes.addItem( new LayerInfo(LayerType.OBJECTS, "Objects") );
		}
	}
}