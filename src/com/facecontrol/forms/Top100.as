package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.dialog.MessageDialog;
	import com.facecontrol.gui.UserGridItem;
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

	public class Top100 extends Form
	{
		private static const MAX_PHOTO_COUNT_IN_GRID:uint = 5;
		
		private static var _instance:Top100 = null;
		
		public static function get instance(): Top100 {
			if (!_instance) _instance = new Top100(Util.scene);
			return _instance;
		}
		
		private var _pagination:Pagination;
		private var _grid:GridBox;
		private var _users:Array;
		
		private var _facecontrolApi:Api;
		private var _multiLoader:MultiLoader;
		
		public function Top100(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			
			_facecontrolApi = new Api();
			_facecontrolApi.addEventListener(ApiEvent.COMPLETED, function(event:ApiEvent): void {
				var response:Object = event.response;
				try {
					switch (response.method) {
						case 'getTop':
							PreloaderSplash.instance.resetModal();
							Top100.instance.users = response.users;
							show();
						break;
					}
				}
				catch (e:Error) {
					if (Util.DEBUG) trace(e.message);
				}
			});
			_facecontrolApi.addEventListener(ApiEvent.ERROR, function(event:ApiEvent): void {
				Util.showError(event.errorCode, event.errorMessage);
			});
			
			_multiLoader = new MultiLoader();
			visible = false;
			
			var background:Bitmap = BitmapUtil.cloneImageNamed(Images.TOP_BACKGROUND);
			background.x = 152;
			background.y = 104;
			addChild(background);
			
			var top100:Bitmap = BitmapUtil.cloneImageNamed(Images.TOP_100);
			top100.x = 34;
			top100.y = 129;
			addChild(top100);
			
			var smile:Bitmap = BitmapUtil.cloneImageNamed(Images.TOP_SMILE);
			smile.x = 113;
			smile.y = 92;
			addChild(smile);
			
			var label:TextField = new TextField();
			label.x = 31;
			label.y = 145;
			label.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xff352b);
			label.text = '100 самых горячих';
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			_pagination = new Pagination(_scene, 383, 600);
			_pagination.width = 83;
			_pagination.textFormatForDefaultButton = new TextFormat(Util.tahoma.fontName, 9, 0xbcbcbc);
			_pagination.textFormatForSelectedButton = new TextFormat(Util.tahomaBold.fontName, 9, 0x00ccff);
			_pagination.addEventListener(Event.CHANGE, onPaginationChange);
			_pagination.pagesCount = 20;
			addChild(_pagination);
			
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
			_grid.setPaddings(0,0,0,0);
//			_grid.debug = true;
			addChild(_grid);
		}
		
		public function initRequest(): void {
			_pagination.currentPage = 0;
			request();
		}
		
		private function request(): void {
			_facecontrolApi.getTop(_pagination.currentPage * MAX_PHOTO_COUNT_IN_GRID, MAX_PHOTO_COUNT_IN_GRID);;
		}
		
		public function set users(value:Array):void {
			_users = value;
			_multiLoader.addEventListener(ErrorEvent.ERROR, loadError);
			for each (var user:Object in _users) {
				if (user.pid) {
					if (!_multiLoader.hasLoaded(user.pid)) {
						if (user.src_big) _multiLoader.load(user.src_big, user.pid, 'Bitmap');
					}
				}
				else if (user.photo_big) {
					if (!_multiLoader.hasLoaded(user.photo_big)) {
						if (user.photo_big) _multiLoader.load(user.photo_big, user.photo_big, 'Bitmap');
					}
				}
			}
			
			if (_multiLoader.isLoaded) updateGrid();
			else {
				_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, loadComplete);
				if (!PreloaderSplash.instance.isModal) {
					Util.scene.showModal(PreloaderSplash.instance);
				}
			}
		}
		
		public function loadError(event:ErrorEvent):void {
			
		}
		
		public function loadComplete(event:MultiLoaderEvent):void {
			if (_multiLoader.isLoaded) {
				_multiLoader.removeEventListener(ErrorEvent.ERROR, loadError);
				_multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, loadComplete);
				updateGrid();
				PreloaderSplash.instance.resetModal();
			}
		}
		
		public function onPaginationChange(event:Event):void {
//			updateGrid();
			PreloaderSplash.instance.showModal();
			request();
		}
		
		public function updateGrid():void {
			_grid.removeAllItems();
			var usersCount:int = _users.length;
			for (var i: uint = 0; i < usersCount; ++i) {
				var item: UserGridItem = new UserGridItem(_scene, _users[i], _multiLoader.get(_users[i].pid), i < usersCount - 1, true, this);
				_grid.addItem(item);
			}
		}
		
		public override function refresh():void {
			initRequest();
		}
		
		public override function show():void {
			if (_scene) {
				for (var i:int = 0; i < _scene.numChildren; ++i) {
					if (_scene.getChildAt(i) is Form) {
						var form:Form = _scene.getChildAt(i) as Form;
						form.visible = (form is Top100);
					} 
				}
			}
		}
	}
}