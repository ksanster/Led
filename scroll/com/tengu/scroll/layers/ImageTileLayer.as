package com.tengu.scroll.layers
{
	import com.tengu.scene.api.IGameContainer;
	import com.tengu.scene.utils.SceneUtils;
	import com.tengu.tools.leditor.api.IEditableLayer;
	import com.tengu.tools.leditor.assets.api.IAssetManager;
	import com.tengu.tools.leditor.logic.api.ILayerFactory;
	import com.tengu.tools.leditor.model.LedModel;
	import com.tengu.tools.leditor.model.enum.ActionType;
	
	import flash.display.BitmapData;
	
	import mx.containers.Tile;

	public class ImageTileLayer extends TileLayer implements IGameContainer, IEditableLayer
	{
		private var isDrawMode:Boolean = false;
		private var brushAssetId:String;
		private var brushIndex:int;
		
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
		
		public function set tileIndex (value:int):void 
		{
			brushIndex = value;
		}
		
		public function get tileIndex():int 
		{
			return brushIndex;
		}

		public function ImageTileLayer()
		{
			super();
		}
		
		private function translateToTileCoord (coord:Number, tileSize:uint):int
		{
			const sign:int = (coord < 0) ? -1 : 1;
			const absTileCoord:int = Math.abs(coord) / tileSize + .5;
			
			return sign * absTileCoord;
		}
		
		private function drawWithBrush(xCoord:Number, yCoord:Number):void
		{
			const actionType:String = model.actions.actionType;
			const tileX:int = translateToTileCoord(xCoord, tileWidth);
			const tileY:int = translateToTileCoord(yCoord, tileHeight);
			const uid:uint = SceneUtils.getCoordsUid(tileX, tileY);
			var tile:ImageTile = tilesHash[uid];
			var tileList:Vector.<BitmapData>;

			if (lastCoordUid == String(uid))
			{
				return;
			}
			
			lastCoordUid = String(uid);
			
			if (tile != null && (actionType == ActionType.DRAW || actionType == ActionType.ERASE))
			{
				remove(tile);
			}
			if (model.actions.actionType == ActionType.DRAW)
			{
				tileList = assetManager.getTileList(brushAssetId, tileWidth, tileHeight);
				if (brushIndex < 0 || brushIndex >= tileList.length)
				{
					return;
				}
				tile = new ImageTile();
				tile.setSize(tileWidth, tileHeight);
				tile.move(tileX * tileWidth, tileY * tileHeight);
				tile.bitmap = tileList[brushIndex];
				add(tile);
				tilesHash[uid] = tile;
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