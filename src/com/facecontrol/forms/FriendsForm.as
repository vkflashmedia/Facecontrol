package com.facecontrol.forms
{
	import com.facecontrol.gui.FriendGridItem;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.Pagination;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FriendsForm extends GameLayer
	{
		
		private var _friendsCount:TextField;
		private var _pagination:Pagination;
		private var _grid:GridBox;
		
		public function FriendsForm(value:GameScene)
		{
			super(value);
			
			var label:TextField = Util.createLabel("Мои друзья", 150, 75);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var background:Bitmap = Util.multiLoader.get(Images.FRIENDS_BACKGROUND);
			background.x = 152;
			background.y = 104;
			addChild(background);
			
			_friendsCount = Util.createLabel("всего: 1", 400, 84, 80, 10);
			_friendsCount.setTextFormat(new TextFormat(Util.tahoma.fontName, 11, 0xff352b));
			_friendsCount.embedFonts = true;
			_friendsCount.antiAliasType = AntiAliasType.ADVANCED;
			_friendsCount.autoSize = TextFieldAutoSize.RIGHT;
			addChild(_friendsCount);
			
			_pagination = new Pagination(_scene, 383, 600);
			_pagination.width = 83;
			_pagination.textFormatForDefaultButton = new TextFormat(Util.tahoma.fontName, 9, 0xbcbcbc);
			_pagination.textFormatForSelectedButton = new TextFormat(Util.tahomaBold.fontName, 9, 0x00ccff);
			_pagination.addEventListener(Event.CHANGE, onPaginationChange);
			addChild(_pagination);
			_pagination.pagesCount = 10;
			
			_grid = new GridBox(_scene, 1, 5);
			_grid.x = 152;
			_grid.y = 104;
			_grid.width = 329;
			_grid.height = 494;
			_grid.widthPolicy = GridBox.WIDTH_POLICY_AUTO_SIZE;
			_grid.heightPolicy = GridBox.HEIGHT_POLICY_AUTO_SIZE;
			_grid.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_grid.verticalItemsAlign = View.ALIGN_VER_TOP;
			_grid.indentBetweenRows = 0;
			_grid.indentBetweenCols= 0;
			_grid.padding = 0;
			_grid.debug = true;
			addChild(_grid);
		}
		
		public function onPaginationChange(event:Event):void {
			
		}
		
		public function set users(value:Array):void {
//			_users = value;
			var i:int = 0;
			var count:int = value.length;
			var format:TextFormat = _friendsCount.getTextFormat();
			_friendsCount.text = 'всего: ' + count;
			_friendsCount.setTextFormat(format);
			
			count = 3;
			for (i = 0; i < count; ++i) {
				var item:FriendGridItem = new FriendGridItem(_scene, value[i], i == count - 1);
				_grid.addItem(item);
			}
		}
	}
}