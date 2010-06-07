package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.dialog.MessageDialog;
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
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FavoritesForm extends Form
	{
		private static const MAX_PHOTO_COUNT_IN_GRID:uint = 5;
		
		private static var _instance:FavoritesForm;
		public static function get instance():FavoritesForm {
			if (!_instance) _instance = new FavoritesForm(Util.scene);
			return _instance;
		}
		
		private var _favoritesCount:TextField;
		private var _pagination:Pagination;
		private var _grid:GridBox;
		private var _users:Array;
		
		private var _multiLoader:MultiLoader;
		
		public function FavoritesForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			
			_multiLoader = new MultiLoader();
			visible = false;
			
			var label:TextField = Util.createLabel('Избранные', 150, 75);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var background:Bitmap = BitmapUtil.cloneImageNamed(Images.FRIENDS_BACKGROUND);
			background.x = 152;
			background.y = 104;
			addChild(background);
			
			_favoritesCount = Util.createLabel('', 400, 84, 80, 10);
			_favoritesCount.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 11, 0xff352b);
			_favoritesCount.embedFonts = true;
			_favoritesCount.antiAliasType = AntiAliasType.ADVANCED;
			_favoritesCount.autoSize = TextFieldAutoSize.RIGHT;
			addChild(_favoritesCount);
			
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
			_grid.setPaddings(0, 0, 0, 0);
			addChild(_grid);
		}
		
		public override function set visible(value:Boolean):void {
			super.visible = value;
			if (value && _users && _users.length == 0) {
				MessageDialog.dialog('Сообщение:', 'У вас нет избранных пользователей. ' + 
						'Добавить новых избранных пользователей вы можете на главной форме или в разделе Топ100.');
			}
		}
		
		public function set users(value:Array):void {
			_users = value;
			
			_multiLoader.addEventListener(ErrorEvent.ERROR, multiloaderError);
			var user:Object;
			for each (user in _users) {
				if (user.pid) {
//					if (!Util.multiLoader.hasLoaded(user.pid)) {
//						if (user.src_big) Util.multiLoader.load(user.src_big, user.pid, 'Bitmap');
//					}
					if (!_multiLoader.hasLoaded(user.pid)) {
						if (user.src_big) _multiLoader.load(user.src_big, user.pid, 'Bitmap');
					}
				}
			}
			
//			if (Util.multiLoader.isLoaded) updateGrid();
//			else Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, loadCompleteListener);
			if (_multiLoader.isLoaded) updateGrid();
			else _multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiloaderComplete);
		}
		
		public function onPaginationChange(event:Event):void {
			updateGrid();
		}
		
		public function updateGrid():void {
			var i:int = 0;
			var j:int = 0;
			var count:int = _users.length;
			var format:TextFormat = _favoritesCount.getTextFormat();
			_favoritesCount.text = 'всего: ' + count;
			_favoritesCount.setTextFormat(format);
			_pagination.pagesCount = Math.ceil(_users.length / MAX_PHOTO_COUNT_IN_GRID);
			_pagination.visible = _pagination.pagesCount > 1;
			
			_grid.removeAllItems();
			
			if (_users.length > 0) {
				var start:int = _pagination.currentPage * MAX_PHOTO_COUNT_IN_GRID;
				var end:int = start + MAX_PHOTO_COUNT_IN_GRID < _users.length ? start + MAX_PHOTO_COUNT_IN_GRID : _users.length;
				
				var item:FriendGridItem;
				for (i = start, j = 1; i < end; ++i, ++j) {
					item = new FriendGridItem(_scene, _users[i], _multiLoader.get(_users[i].pid), j < MAX_PHOTO_COUNT_IN_GRID, true, this);
					_grid.addItem(item);
				}
			}
		}
		
		public function multiloaderError(event:ErrorEvent):void {
			
		}
		
		public function multiloaderComplete(event:MultiLoaderEvent):void {
//			if (Util.multiLoader.isLoaded) {
//				Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, loadCompleteListener);
//				updateGrid();
//			}
			if (_multiLoader.isLoaded) {
				_multiLoader.removeEventListener(ErrorEvent.ERROR, multiloaderError);
				_multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiloaderComplete);
				updateGrid();
			}
		}
		
		public override function refresh():void {
			Util.api.favorites(Util.viewer_id);
		}
		
		public override function show():void {
			if (_scene) {
				for (var i:int = 0; i < _scene.numChildren; ++i) {
					if (_scene.getChildAt(i) is Form) {
						var form:Form = _scene.getChildAt(i) as Form;
						form.visible = (form is FavoritesForm);
					} 
				}
			}
		}
	}
}