package com.tengu.tools.leditor.model
{
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.model.api.ILedModel;
	import com.tengu.tools.leditor.model.enum.LayerType;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class LedModel implements ILedModel
	{
		private var layerList:ArrayCollection;
		private var layer:IEditableLayer;
		
		public function LedModel()
		{
			initialize();
		}
		
		private function initialize():void
		{
			layerList = new ArrayCollection();
			
			layerList.addItem( new LayerInfo(LayerType.INFINITE_BITMAP, "Looped bitmap") );
			layerList.addItem( new LayerInfo(LayerType.BITMAP, "Bitmap") );
			layerList.addItem( new LayerInfo(LayerType.IMAGE_TILES, "Image tiles") );
			layerList.addItem( new LayerInfo(LayerType.OBJECTS, "Objects") );
		}
		
		public function get activeLayer():IEditableLayer
		{
			return layer;
		}
		
		public function set activeLayer(value:IEditableLayer):void
		{
			layer = value;
		}
		
		public function get layers():IList
		{
			return layerList;
		}
	}
}