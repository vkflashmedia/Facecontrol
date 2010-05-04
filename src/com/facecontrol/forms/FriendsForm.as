package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.facecontrol.gui.FriendGridItem;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.Pagination;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FriendsForm extends Form
	{
		private static const MAX_PHOTO_COUNT_IN_GRID:uint = 5;
		
		private static var _instance:FriendsForm = null;
		public static function get instance():FriendsForm {
			if (!_instance) _instance = new FriendsForm(Util.scene);
			return _instance;
		}
		
		private var _friendsCount:TextField;
		private var _pagination:Pagination;
		private var _grid:GridBox;
		private var _users:Array;
		
		public function FriendsForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			visible = false;
			
			var label:TextField = Util.createLabel('Мои друзья', 150, 75);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var background:Bitmap = BitmapUtil.cloneImageNamed(Images.FRIENDS_BACKGROUND);
			background.x = 152;
			background.y = 104;
			addChild(background);
			
			_friendsCount = Util.createLabel('', 400, 84, 80, 10);
			_friendsCount.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 11, 0xff352b);
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
			_grid.x = 153;
			_grid.y = 102;
			_grid.width = 326;
			_grid.height = 492;
			_grid.widthPolicy = GridBox.WIDTH_POLICY_AUTO_SIZE;
			_grid.heightPolicy = GridBox.HEIGHT_POLICY_AUTO_SIZE;
			_grid.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_grid.verticalItemsAlign = View.ALIGN_VER_TOP;
			_grid.indentBetweenRows = 0;
			_grid.indentBetweenCols= 0;
			_grid.padding = 0;
//			_grid.debug = true;
			addChild(_grid);
		}
		
		public function onPaginationChange(event:Event):void {
			updateGrid();
		}
		
		public function set users(value:Array):void {
			_users = value;
			var user:Object;
			
			for each (user in _users) {
				if (user.pid) {
					if (!Util.multiLoader.hasLoaded(user.pid)) {
						if (user.src_big) Util.multiLoader.load(user.src_big, user.pid, 'Bitmap');
					}
				}
				else if (user.photo_big) {
					if (!Util.multiLoader.hasLoaded(user.photo_big)) {
						if (user.photo_big) Util.multiLoader.load(user.photo_big, user.photo_big, 'Bitmap');
					}
				}
			}
			
			if (Util.multiLoader.isLoaded) updateGrid();
			else Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, loadCompleteListener);
		}
		
		public function loadCompleteListener(event:MultiLoaderEvent):void {
			if (Util.multiLoader.isLoaded) {
				Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, loadCompleteListener);
				updateGrid();
			}
		}
		
		public function updateGrid():void {
			var i:int = 0;
			var count:int = _users.length;
			var format:TextFormat = _friendsCount.getTextFormat();
			_friendsCount.text = 'всего: ' + count;
			_friendsCount.setTextFormat(format);
			_pagination.pagesCount = Math.ceil(_users.length / MAX_PHOTO_COUNT_IN_GRID);
			_pagination.visible = _pagination.pagesCount > 1;
			
			_grid.removeAllItems();
			
			if (_users.length > 0) {
				var start:int = _pagination.currentPage * MAX_PHOTO_COUNT_IN_GRID;
				var end:int = start + MAX_PHOTO_COUNT_IN_GRID < _users.length ? start + MAX_PHOTO_COUNT_IN_GRID : _users.length;
				
				var item:FriendGridItem;
				for (i = start; i < end; ++i) {
					item = new FriendGridItem(_scene, _users[i], i != count - 1);
					_grid.addItem(item);
				}
			}
		}
		
		public override function refresh():void {
			Util.vkontakte.getFriends();
		}
	}
}