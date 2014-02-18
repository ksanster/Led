package com.tengu.tools.leditor.model
{
	import com.tengu.core.errors.SingletonConstructError;
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.model.api.ILedModel;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class LedModel implements ILedModel
	{
		public static const instance:LedModel = new LedModel();
		
		private var availableTypes:ArrayCollection;
		private var ledLayers:ArrayCollection;
		private var layer:IEditableLayer;
		
		public function LedModel()
		{
			if (instance != null)
			{
				throw new SingletonConstructError(this);
			}
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
		
		[Bindable]
		public function set activeLayer(value:IEditableLayer):void
		{
			layer = value;
		}

		public function get activeLayer():IEditableLayer
		{
			return layer;
		}
		
		
		public function get layers():IList
		{
			return ledLayers;
		}
		
		public function get availableLayerTypes ():IList 
		{
			return availableTypes;
		}
	}
}