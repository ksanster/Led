package com.tengu.tools.leditor.model
{
	import com.tengu.tools.leditor.api.ILayerInfo;
	
	public class LayerInfo implements ILayerInfo
	{
		private var infoType:String;
		private var infoName:String;
		
		public function LayerInfo(type:String, name:String)
		{
			infoType = type;
			infoName = name;
		}
		
		public function set type(value:String):void 
		{
			infoType = value;
		}
		public function get type():String
		{
			return infoType;
		}
		
		public function get name():String 
		{
			return infoName;
		}
	}
}