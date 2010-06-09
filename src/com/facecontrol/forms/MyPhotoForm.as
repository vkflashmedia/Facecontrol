package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.dialog.MessageDialog;
	import com.facecontrol.dialog.PhotoPreviewDialog;
	import com.facecontrol.gui.MyPhotoGridItem;
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.Pagination;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class MyPhotoForm extends Form
	{
		private static const MAX_PHOTO_COUNT_IN_GRID:uint = 6;
		
		private static var _instance:MyPhotoForm;
		public static function get instance():MyPhotoForm {
			if (!_instance) _instance = new MyPhotoForm(Util.scene);
			return _instance;
		}
		
		private var _photos:Array;
		private var _mainPhoto:Photo;
		private var _main:Object;
		
		private var _commentPlaceholder:TextField;
		private var _ratingAverageField:TextField;
		private var _votesCountField:TextField;
		private var _noVotesField:TextField;
		private var _bigStar:Bitmap;
		
		private var _grid:GridBox;
		private var _pagination:Pagination;
		private var _commentInput:TextField;
		private var _commentLabel:TextField;
		private var _commentForm:Bitmap;
		
		private var _multiloader:MultiLoader;
		
		public function MyPhotoForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			
			_multiloader = new MultiLoader();
			visible = false;

			var smileIco:Bitmap = new Bitmap(Util.multiLoader.get(Images.MY_PHOTO_SMILE_ICO).bitmapData);
			smileIco.x = 38;
			smileIco.y = 97;
			addChild(smileIco);
			
			var labelFormat:TextFormat = new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff);
			var label:TextField = Util.createLabel('Мои фото', 62, 92);
			label.setTextFormat(labelFormat);
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var border:Sprite = new Sprite();
			border.x = 41;
			border.y = 125;
			border.graphics.beginFill(0xf5dc8c, 1);
			border.graphics.drawRect(0, 0, 1, 11);
			addChild(border);
			
			label = Util.createLabel('Главное фото', border.x + 4, 118);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 14, 0xffa200));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			label = Util.createLabel('Выбери самое лучшее фото твоей жизни', 38, 146, 125, 50);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.NONE;
			label.multiline = true;
			label.wordWrap = true;
			addChild(label);
			
			border = new Sprite();
			border.x = 276;
			border.y = 125;
			border.graphics.beginFill(0xf5dc8c, 1);
			border.graphics.drawRect(0, 0, 1, 11);
			addChild(border);
			
			label = Util.createLabel('Твои фото в приложении', border.x + 4, 118);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 14, 0xffa200));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			label = Util.createLabel('Выбери главное фото, которое будет учавствовать в голосовании', 273, 146, 240, 50);
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.NONE;
			label.multiline = true;
			label.wordWrap = true;
			addChild(label);
			
			_mainPhoto = new Photo(_scene, null, 38, 189, 192, 177);
			_mainPhoto.photoBorder = 1;
			_mainPhoto.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
			addChild(_mainPhoto);
			
			_bigStar = BitmapUtil.cloneImageNamed(Images.BIG_STAR);
			_bigStar.x = 38;
			_bigStar.y = _mainPhoto.y + _mainPhoto.photoHeight + 8;
			addChild(_bigStar);
			
			_ratingAverageField = Util.createLabel('9,5', 77, _mainPhoto.y + _mainPhoto.photoHeight + 3);
			_ratingAverageField.setTextFormat(new TextFormat(Util.tahoma.fontName, 30, 0xffffff));
			_ratingAverageField.embedFonts = true;
			_ratingAverageField.antiAliasType = AntiAliasType.ADVANCED;
			_ratingAverageField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_ratingAverageField);
			
			_votesCountField = Util.createLabel(Util.votesCount(0), 140, _mainPhoto.y + _mainPhoto.photoHeight + 18);
			_votesCountField.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6));
			_votesCountField.embedFonts = true;
			_votesCountField.antiAliasType = AntiAliasType.ADVANCED;
			_votesCountField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_votesCountField);
			
			_noVotesField = Util.createLabel('нет голосов', 38, _votesCountField.y);
			_noVotesField.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6));
			_noVotesField.embedFonts = true;
			_noVotesField.antiAliasType = AntiAliasType.ADVANCED;
			_noVotesField.autoSize = TextFieldAutoSize.LEFT;
			_noVotesField.visible = false;
			addChild(_noVotesField);
			
			_commentLabel = Util.createLabel('Комментарий к фото:', 38, _mainPhoto.y + _mainPhoto.photoHeight + 62);
			_commentLabel.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			_commentLabel.embedFonts = true;
			_commentLabel.antiAliasType = AntiAliasType.ADVANCED;
			_commentLabel.autoSize = TextFieldAutoSize.LEFT;
			addChild(_commentLabel);
			
			_commentForm = Util.multiLoader.get(Images.MY_PHOTO_COMMENT_FORM);
			_commentForm.x = 37;
			_commentForm.y = _mainPhoto.y + _mainPhoto.photoHeight + 85;
			addChild(_commentForm);
			
			_commentPlaceholder = new TextField();
			_commentPlaceholder.x = 46;
			_commentPlaceholder.y = _mainPhoto.y + _mainPhoto.photoHeight + 103;
			_commentPlaceholder.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xcac4c8);
			_commentPlaceholder.text = 'Введите комментарий';
			_commentPlaceholder.embedFonts = true;
			_commentPlaceholder.selectable = false;
			_commentPlaceholder.antiAliasType = AntiAliasType.ADVANCED;
			_commentPlaceholder.autoSize = TextFieldAutoSize.LEFT;
			addChild(_commentPlaceholder);
			
			_commentInput = new TextField();
			_commentInput.selectable = true;
			_commentInput.x = 46;
			_commentInput.y = _commentPlaceholder.y;
			_commentInput.width = 176;
			_commentInput.height = 121;
			_commentInput.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xcac4c8);
			_commentInput.maxChars = 127;
			_commentInput.embedFonts = true;
			_commentInput.antiAliasType = AntiAliasType.ADVANCED;
			_commentInput.type = TextFieldType.INPUT;
			_commentInput.wordWrap = true;
			_commentInput.addEventListener(FocusEvent.FOCUS_OUT, onMouseOut);
			_commentInput.addEventListener(FocusEvent.FOCUS_IN, onMouseIn);
			addChild(_commentInput);
			
			var photoListBck:Bitmap = Util.multiLoader.get(Images.MY_PHOTO_BACKGROUND);
			photoListBck.y = 189;
			photoListBck.x = 274;
			addChild(photoListBck);
			
			var preview:LinkButton = new LinkButton(_scene, 'предпросмотр', 278, 459);
			preview.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 11, 0xffb44a, null, null, true), CONTROL_STATE_NORMAL);
			preview.textField.embedFonts = true;
			preview.textField.antiAliasType = AntiAliasType.ADVANCED;
			preview.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onPreviewClick);
			addChild(preview);
			
			var markAsMain:Button = new Button(_scene, 264, 488);
			markAsMain.setTitleForState('Сделать главной', CONTROL_STATE_NORMAL);
			markAsMain.setBackgroundImageForState(Util.multiLoader.get(Images.MY_PHOTO_BUTTON_RED), CONTROL_STATE_NORMAL);
			markAsMain.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			markAsMain.textField.embedFonts = true;
			markAsMain.textField.antiAliasType = AntiAliasType.ADVANCED;
			markAsMain.setTextPosition(19, 17);
			markAsMain.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onMarkAsMainClick);
			addChild(markAsMain);
			
			var addPhoto:Button = new Button(_scene, 377, 488);
			addPhoto.setTitleForState('Добавить фото', CONTROL_STATE_NORMAL);
			addPhoto.setBackgroundImageForState(Util.multiLoader.get(Images.MY_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
			addPhoto.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			addPhoto.textField.embedFonts = true;
			addPhoto.textField.antiAliasType = AntiAliasType.ADVANCED;
			addPhoto.setTextPosition(19, 17);
			addPhoto.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onAddPhotoClick);
			addChild(addPhoto);
			
			var deletePhoto:Button = new Button(_scene, 486, 488);
			deletePhoto.setTitleForState('Удалить фото', CONTROL_STATE_NORMAL);
			deletePhoto.setBackgroundImageForState(Util.multiLoader.get(Images.MY_PHOTO_BUTTON_GRAY), CONTROL_STATE_NORMAL);
			deletePhoto.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			deletePhoto.textField.embedFonts = true;
			deletePhoto.textField.antiAliasType = AntiAliasType.ADVANCED;
			deletePhoto.setTextPosition(19, 17);
			deletePhoto.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onDeletePhotoClick);
			addChild(deletePhoto);
			
			_grid = new GridBox(_scene, 2, 3);
			_grid.x = 281;
			_grid.y = 203;
			_grid.width = 290;
			_grid.height = 225;
			_grid.widthPolicy = GridBox.WIDTH_POLICY_ABSOLUTE;
			_grid.heightPolicy = GridBox.HEIGHT_POLICY_ABSOLUTE;
			_grid.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_grid.verticalItemsAlign = View.ALIGN_VER_TOP;
			_grid.indentBetweenRows = 0;
			_grid.indentBetweenCols = 0;
			_grid.setPaddings(3,3,3,3);
			addChild(_grid);
			
			_pagination = new Pagination(_scene, 500, 462);
			_pagination.width = 83;
			_pagination.textFormatForDefaultButton = new TextFormat(Util.tahoma.fontName, 9, 0xbcbcbc);
			_pagination.textFormatForSelectedButton = new TextFormat(Util.tahomaBold.fontName, 9, 0x00ccff);
			_pagination.addEventListener(Event.CHANGE, onPaginationChange);
			addChild(_pagination);
		}
		
		public function onPaginationChange(event:Event):void {
			updateGrid();
		}
		
		public function updateGrid():void {
			_grid.removeAllItems();
			
			var start:int = _pagination.currentPage * MAX_PHOTO_COUNT_IN_GRID;
			var end:int = start + MAX_PHOTO_COUNT_IN_GRID < _photos.length ? start + MAX_PHOTO_COUNT_IN_GRID : _photos.length;
			var p:MyPhotoGridItem;
			
			for (var i:uint = start; i < end; ++i) {
				p = new MyPhotoGridItem(_scene, _photos[i], _multiloader.get(_photos[i].pid), 140, 64);
				p.setFocus(true, true, BitmapUtil.cloneImageNamed(Images.MY_PHOTO_SELECTION));
				_grid.addItem(p);
			}
		}
		
		private function update():void {
			if (_main) {
				_bigStar.y = _mainPhoto.y + _mainPhoto.photoHeight + 8;
				_ratingAverageField.y = _mainPhoto.y + _mainPhoto.photoHeight + 3;
				_votesCountField.y = _mainPhoto.y + _mainPhoto.photoHeight + 18;
				_noVotesField.y = _votesCountField.y;
				_commentLabel.y = _mainPhoto.y + _mainPhoto.photoHeight + 62;
				_commentForm.y = _mainPhoto.y + _mainPhoto.photoHeight + 85;
				_commentPlaceholder.y = _mainPhoto.y + _mainPhoto.photoHeight + 103;
				_commentInput.y = _commentPlaceholder.y;
				
				_noVotesField.visible = (_main.votes_count == 0);
				
				_ratingAverageField.defaultTextFormat = _ratingAverageField.getTextFormat();
				_ratingAverageField.text = (_main.rating_average) ? _main.rating_average : '';
				_ratingAverageField.visible = !_noVotesField.visible;
				
				
				_votesCountField.defaultTextFormat = _votesCountField.getTextFormat();
				_votesCountField.text = Util.votesCount(_main.votes_count);
				_votesCountField.visible = _bigStar.visible = !_noVotesField.visible;
			}
			
			_pagination.pagesCount = Math.ceil(_photos.length / MAX_PHOTO_COUNT_IN_GRID);
			_pagination.visible = _pagination.pagesCount > 1;
			updateGrid();
		}
		
		public function get photos(): Array {
			return _photos;
		}
		
		public function set photos(value:Array):void {
			if (value) {
				_photos = value;
				var photo:Object;
				
				_multiloader.addEventListener(ErrorEvent.ERROR, multiLoaderError);
				for each (photo in _photos) {
//					if (!Util.multiLoader.hasLoaded(photo.pid)) {
//						Util.multiLoader.load(photo.src_big, photo.pid, 'Bitmap');
//					}
					if (!_multiloader.hasLoaded(photo.pid)) {
						_multiloader.load(photo.src_big, photo.pid, 'Bitmap');
					}
					if (photo.main == 1) {
						_main = photo;
						_commentInput.defaultTextFormat = _commentInput.getTextFormat();
						_commentInput.text = (_main.comment) ? _main.comment : '';
						_commentPlaceholder.visible = (_commentInput.text == '');
					}
				}
				
				if (_multiloader.isLoaded) {
					_mainPhoto.photo = _multiloader.get(_main.pid);
					
					update();
				}
				else {
					if (!PreloaderSplash.instance.isModal) {
						Util.scene.showModal(PreloaderSplash.instance);
					}
					
					_multiloader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderComplite);
				}
			}
		}
		
		public function multiLoaderError(event:ErrorEvent):void {
			PreloaderSplash.instance.resetModal();
			MessageDialog.dialog('Ошибка:', 'Не удалось загрузить фотографию.');
		}
		
		public function multiLoaderComplite(event:MultiLoaderEvent):void {
			if (_multiloader.isLoaded) {
				_multiloader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderComplite);
				if (_main) {
					_mainPhoto.photo = _multiloader.get(_main.pid);
				}
				update();
				PreloaderSplash.instance.resetModal();
			}
		}
		
		public function onMarkAsMainClick(event:GameObjectEvent):void {
			var gridItem:MyPhotoGridItem = _grid.selectedItem;
			if (gridItem) Util.api.setMain(gridItem.photoData.pid);
			else MessageDialog.dialog('Сообщение:', 'Необходимо выбрать фотографию');
		}
		
		public function onAddPhotoClick(event:GameObjectEvent):void {
			PhotoAlbumForm.instance.setAddedPhotos(MyPhotoForm.instance.photos);
			_scene.showModal(PhotoAlbumForm.instance);
		}
		
		public function onDeletePhotoClick(event:GameObjectEvent):void {
			var gridItem:MyPhotoGridItem = _grid.selectedItem;
			if (gridItem) {
				PreloaderSplash.instance.showModal();
				Util.api.deletePhoto(gridItem.photoData.pid);
			}
			else {
				MessageDialog.dialog('Сообщение:', 'Необходимо выбрать фотографию');
			}
		}
		
		public function onCommentChange(event:Event):void {
			var text:String = _commentInput.text;
		}
		
		public function onMouseIn(event:FocusEvent):void {
			_commentPlaceholder.visible = false;
		}
		
		public function onMouseOut(event:FocusEvent):void {
			_commentPlaceholder.visible = (_commentInput.text == '');
			if (_main.comment != _commentInput.text) {
				Util.api.setComment(_main.pid, _commentInput.text);
			}
		}
		
		public function onPreviewClick(event:GameObjectEvent):void {
			var gridItem:MyPhotoGridItem = _grid.selectedItem;
			if (gridItem) {
				_scene.showModal(new PhotoPreviewDialog(_scene, _multiloader.get(gridItem.photoData.pid)));
			} else {
				MessageDialog.dialog('Сообщение:', 'Необходимо выбрать фотографию');
			}
		}
		
		public override function show():void {
			if (_scene) {
				for (var i:int = 0; i < _scene.numChildren; ++i) {
					if (_scene.getChildAt(i) is Form) {
						var form:Form = _scene.getChildAt(i) as Form;
						form.visible = (form is MyPhotoForm);
					} 
				}
			}
		}
	}
}