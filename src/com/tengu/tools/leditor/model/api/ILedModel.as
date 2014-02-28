package com.tengu.tools.leditor.model.api
{
	import com.tengu.tools.leditor.api.IEditableLayer;
	
	import mx.collections.IList;

	public interface ILedModel
	{
		function set projectFileName(value:String):void; 
		function get projectFileName():String;

		function get activeLayer ():IEditableLayer;
		function set activeLayer (value:IEditableLayer):void;
		
		function get layers ():IList/*IEditableLayer*/;
		function get availableLayerTypes ():IList/*ILayerInfo*/;
		
		function get config ():XML;
		function set config (value:XML):void;
		
	}
}