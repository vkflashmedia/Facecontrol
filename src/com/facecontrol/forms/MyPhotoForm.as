package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.dialog.MessageDialog;
	import com.facecontrol.dialog.PhotoAlbumDialog;
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
		private static const INDENT_BETWEEN_MAIN_PHOTO_AND_COMMENT_AREA:uint = 62;
		private static const COMMENT_TEXT_X:uint = 46;
		private static const COMMENT_TEXT_Y:uint = 41;
		
		private static var _instance:MyPhotoForm;
		public static function get instance():MyPhotoForm {
			if (!_instance) _instance = new MyPhotoForm(Util.scene);
			return _instance;
		}
		
		private var _photos:Array;
		
		private var _main:Object;
		private var _mainPhoto:Photo;
		private var _mainPhotoRatingAverage:TextField;
		private var _mainPhotoVotesCount:TextField;
		private var _mainPhotoNoVotes:TextField
		private var _mainPhotoArea:Sprite;
		private var _mainPhotoNoVotesArea:Sprite;
		
		private var _photoCommentArea:Sprite;
		private var _photoCommentPlaceholder:TextField;
		private var _photoComment:TextField;
		
		private var _photoGrid:GridBox;
		private var _pagination:Pagination;
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
			
			var label:TextField = Util.createLabel('Мои фото', 62, 92);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var verticalBorder:Sprite = new Sprite();
			verticalBorder.x = 41;
			verticalBorder.y = 125;
			verticalBorder.graphics.beginFill(0xf5dc8c, 1);
			verticalBorder.graphics.drawRect(0, 0, 1, 11);
			addChild(verticalBorder);
			
			label = Util.createLabel('Главное фото', verticalBorder.x + 4, 118);
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
			
			verticalBorder = new Sprite();
			verticalBorder.x = 276;
			verticalBorder.y = 125;
			verticalBorder.graphics.beginFill(0xf5dc8c, 1);
			verticalBorder.graphics.drawRect(0, 0, 1, 11);
			addChild(verticalBorder);
			
			label = Util.createLabel('Твои фото в приложении', verticalBorder.x + 4, 118);
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
			
			_mainPhotoNoVotesArea = new Sprite();
			_mainPhotoNoVotesArea.y = _mainPhoto.y + _mainPhoto.photoHeight;
			_mainPhotoNoVotesArea.visible = false;
			addChild(_mainPhotoNoVotesArea);
			
			_mainPhotoArea = new Sprite();
			_mainPhotoArea.y = _mainPhoto.y + _mainPhoto.photoHeight;
			_mainPhotoArea.visible = false;
			addChild(_mainPhotoArea);
			
			var mainPhotoMetaStarIcon:Bitmap = BitmapUtil.cloneImageNamed(Images.BIG_STAR);
			mainPhotoMetaStarIcon.x = 38;
			mainPhotoMetaStarIcon.y = 8;
			_mainPhotoArea.addChild(mainPhotoMetaStarIcon);
			
			_mainPhotoRatingAverage = Util.createLabel('9,5', 77, 3);
			_mainPhotoRatingAverage.setTextFormat(new TextFormat(Util.tahoma.fontName, 30, 0xffffff));
			_mainPhotoRatingAverage.embedFonts = true;
			_mainPhotoRatingAverage.antiAliasType = AntiAliasType.ADVANCED;
			_mainPhotoRatingAverage.autoSize = TextFieldAutoSize.LEFT;
			_mainPhotoArea.addChild(_mainPhotoRatingAverage);
			
			_mainPhotoVotesCount = Util.createLabel(Util.votesCount(0), 140, 18);
			_mainPhotoVotesCount.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6));
			_mainPhotoVotesCount.embedFonts = true;
			_mainPhotoVotesCount.antiAliasType = AntiAliasType.ADVANCED;
			_mainPhotoVotesCount.autoSize = TextFieldAutoSize.LEFT;
			_mainPhotoArea.addChild(_mainPhotoVotesCount);
			
			_mainPhotoNoVotes = Util.createLabel('Нет голосов', 38, _mainPhotoVotesCount.y);
			_mainPhotoNoVotes.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xb0dee6));
			_mainPhotoNoVotes.embedFonts = true;
			_mainPhotoNoVotes.antiAliasType = AntiAliasType.ADVANCED;
			_mainPhotoNoVotes.autoSize = TextFieldAutoSize.LEFT;
			_mainPhotoNoVotesArea.addChild(_mainPhotoNoVotes);
			
			_photoCommentArea = new Sprite();
			_photoCommentArea.y = _mainPhoto.y + _mainPhoto.photoHeight + INDENT_BETWEEN_MAIN_PHOTO_AND_COMMENT_AREA;
			_photoCommentArea.visible = false;
			addChild(_photoCommentArea);
			
			var commentLabel:TextField = Util.createLabel('Комментарий к фото:', 38, 0);
			commentLabel.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			commentLabel.embedFonts = true;
			commentLabel.antiAliasType = AntiAliasType.ADVANCED;
			commentLabel.autoSize = TextFieldAutoSize.LEFT;
			_photoCommentArea.addChild(commentLabel);
			
			var commentForm:Bitmap = BitmapUtil.cloneImageNamed(Images.MY_PHOTO_COMMENT_FORM);
			commentForm.x = 37;
			commentForm.y = 23;
			_photoCommentArea.addChild(commentForm);
			
			_photoCommentPlaceholder = new TextField();
			_photoCommentPlaceholder.x = COMMENT_TEXT_X;
			_photoCommentPlaceholder.y = COMMENT_TEXT_Y;
			_photoCommentPlaceholder.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xcac4c8);
			_photoCommentPlaceholder.text = 'Введите комментарий';
			_photoCommentPlaceholder.embedFonts = true;
			_photoCommentPlaceholder.selectable = false;
			_photoCommentPlaceholder.antiAliasType = AntiAliasType.ADVANCED;
			_photoCommentPlaceholder.autoSize = TextFieldAutoSize.LEFT;
			_photoCommentArea.addChild(_photoCommentPlaceholder);
			
			_photoComment = new TextField();
			_photoComment.selectable = true;
			_photoComment.x = COMMENT_TEXT_X;
			_photoComment.y = COMMENT_TEXT_Y;
			_photoComment.width = 176;
			_photoComment.height = 121;
			_photoComment.defaultTextFormat = new TextFormat(Util.tahoma.fontName, 12, 0xcac4c8);
			_photoComment.maxChars = 127;
			_photoComment.embedFonts = true;
			_photoComment.antiAliasType = AntiAliasType.ADVANCED;
			_photoComment.type = TextFieldType.INPUT;
			_photoComment.wordWrap = true;
			_photoComment.addEventListener(FocusEvent.FOCUS_OUT, onMouseOut);
			_photoComment.addEventListener(FocusEvent.FOCUS_IN, onMouseIn);
			_photoCommentArea.addChild(_photoComment);
			
			var photoGridBackground:Bitmap = BitmapUtil.cloneImageNamed(Images.MY_PHOTO_BACKGROUND);
			photoGridBackground.y = 189;
			photoGridBackground.x = 274;
			addChild(photoGridBackground);
			
			var previewButton:LinkButton = new LinkButton(_scene, 'предпросмотр', 278, 459);
			previewButton.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 11, 0xffb44a, null, null, true), CONTROL_STATE_NORMAL);
			previewButton.textField.embedFonts = true;
			previewButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			previewButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onPreviewClick);
			addChild(previewButton);
			
			var markAsMain:Button = new Button(_scene, 264, 488);
			markAsMain.setTitleForState('Сделать главной', CONTROL_STATE_NORMAL);
			markAsMain.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.MY_PHOTO_BUTTON_RED), CONTROL_STATE_NORMAL);
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
			
			_photoGrid = new GridBox(_scene, 2, 3);
			_photoGrid.x = 281;
			_photoGrid.y = 203;
			_photoGrid.width = 290;
			_photoGrid.height = 225;
			_photoGrid.widthPolicy = GridBox.WIDTH_POLICY_ABSOLUTE;
			_photoGrid.heightPolicy = GridBox.HEIGHT_POLICY_ABSOLUTE;
			_photoGrid.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_photoGrid.verticalItemsAlign = View.ALIGN_VER_TOP;
			_photoGrid.indentBetweenRows = 0;
			_photoGrid.indentBetweenCols = 0;
			_photoGrid.setPaddings(3,3,3,3);
			addChild(_photoGrid);
			
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
			_photoGrid.removeAllItems();
			
			var start:int = _pagination.currentPage * MAX_PHOTO_COUNT_IN_GRID;
			var end:int = start + MAX_PHOTO_COUNT_IN_GRID < _photos.length ? start + MAX_PHOTO_COUNT_IN_GRID : _photos.length;
			var p:MyPhotoGridItem;
			
			for (var i:uint = start; i < end; ++i) {
				p = new MyPhotoGridItem(_scene, _photos[i], _multiloader.get(_photos[i].pid), 140, 64);
				p.setFocus(true, true, BitmapUtil.cloneImageNamed(Images.MY_PHOTO_SELECTION));
				_photoGrid.addItem(p);
			}
		}
		
		private function update():void {
			if (_main) {
				_mainPhotoNoVotesArea.y = _mainPhotoArea.y = _mainPhoto.y + _mainPhoto.photoHeight;
				_photoCommentArea.y = _mainPhoto.y + _mainPhoto.photoHeight + INDENT_BETWEEN_MAIN_PHOTO_AND_COMMENT_AREA;
				_photoCommentArea.visible = true;
				
				_mainPhotoNoVotesArea.visible = (_main.votes_count == 0);
				_mainPhotoArea.visible = !_mainPhotoNoVotesArea.visible;
				
				_mainPhotoVotesCount.defaultTextFormat = _mainPhotoVotesCount.getTextFormat();
				_mainPhotoVotesCount.text = Util.votesCount(_main.votes_count);
				
				_mainPhotoRatingAverage.defaultTextFormat = _mainPhotoRatingAverage.getTextFormat();
				_mainPhotoRatingAverage.text = (_main.rating_average) ? _main.rating_average : '';
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
				
				_multiloader.addEventListener(ErrorEvent.ERROR, multiLoaderError);
				for each (var photo:Object in _photos) {
					if (!_multiloader.hasLoaded(photo.pid)) {
						_multiloader.load(photo.src_big, photo.pid, 'Bitmap');
					}
					if (photo.main == 1) {
						_main = photo;
						_photoComment.defaultTextFormat = _photoComment.getTextFormat();
						_photoComment.text = (_main.comment) ? _main.comment : '';
						_photoCommentPlaceholder.visible = (_photoComment.text == '');
					}
				}
				
				_mainPhoto.frameIndex = _main.frame;
				
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
			var gridItem:MyPhotoGridItem = _photoGrid.selectedItem;
			if (gridItem) Util.api.setMain(gridItem.photoData.pid);
			else MessageDialog.dialog('Сообщение:', 'Необходимо выбрать фотографию');
		}
		
		public function onAddPhotoClick(event:GameObjectEvent):void {
			PhotoAlbumDialog.instance.setAddedPhotos(MyPhotoForm.instance.photos);
			_scene.showModal(PhotoAlbumDialog.instance);
		}
		
		public function onDeletePhotoClick(event:GameObjectEvent):void {
			var gridItem:MyPhotoGridItem = _photoGrid.selectedItem;
			if (gridItem) {
				PreloaderSplash.instance.showModal();
				Util.api.deletePhoto(gridItem.photoData.pid);
			}
			else {
				MessageDialog.dialog('Сообщение:', 'Необходимо выбрать фотографию');
			}
		}
		
		public function onMouseIn(event:FocusEvent):void {
			_photoCommentPlaceholder.visible = false;
		}
		
		public function onMouseOut(event:FocusEvent):void {
			_photoCommentPlaceholder.visible = (_photoComment.text == '');
			if (_main.comment != _photoComment.text) {
				Util.api.setComment(_main.pid, _photoComment.text);
			}
		}
		
		public function onPreviewClick(event:GameObjectEvent):void {
			var gridItem:MyPhotoGridItem = _photoGrid.selectedItem;
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