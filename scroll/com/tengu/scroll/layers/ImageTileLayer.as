package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.utils.SceneUtils;
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.assets.api.IAssetManager;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.LedModel;
	import com.tengu.tools.leditor.model.enum.ActionType;
	
	import mx.containers.Tile;

	public class ImageTileLayer extends TileLayer implements IGameContainer, IEditableLayer
	{
		private var isDrawMode:Boolean = false;
		private var brushAssetId:String;
		
		private var tilesHash:Object;
		private var lastCoordUid:String;
		
		[Inject]
		public var model:LedModel;
		
		[Inject]
		public var assetManager:IAssetManager;
		
		public function set brush(value:String):void 
		{
			brushAssetId = value;
		}
		
		public function get brush():String 
		{
			return brushAssetId;
		}

		public function ImageTileLayer()
		{
			super();
		}
		
		private function drawWithBrush(xCoord:int, yCoord:int):void
		{
			const actionType:String = model.actions.actionType;
			const tileX:int = xCoord / tileWidth + tileWidth * .5;
			const tileY:int = yCoord / tileHeight + tileHeight * .5;
			const uid:uint = SceneUtils.getCoordsUid(tileX, tileY);
			var tile:ImageTile = tilesHash[uid];
			
			if (lastCoordUid == String(uid))
			{
				return;
			}
			
			lastCoordUid = String(uid);
			
			if ((tile != null && actionType == ActionType.DRAW) || actionType == ActionType.ERASE)
			{
				remove(tile);
			}
			if (model.actions.actionType == ActionType.DRAW)
			{
				tile = new ImageTile();
				tile.move(tileX, tileY);
				tile.bitmap = assetManager.getAsset(brushAssetId).bitmap;
				add(tile);
			}
			
		}
		
		protected override function initialize():void
		{
			super.initialize();
			tilesHash = {};
		}

		public override function mouseDown(xCoord:Number, yCoord:Number):Boolean
		{
			if (brushAssetId == null || model.actions.actionType == ActionType.MOVE)
			{
				return false;
			}
			isDrawMode = true;
			drawWithBrush(xCoord, yCoord);
			return true;
		}
		
		public override function mouseMove(xCoord:Number, yCoord:Number):void
		{
			if (!isDrawMode)
			{
				return;
			}
			drawWithBrush(xCoord, yCoord);
		}
		
		public override function mouseUp(xCoord:Number, yCoord:Number):void
		{
			isDrawMode = false;
			lastCoordUid = null;
		}
	}
}