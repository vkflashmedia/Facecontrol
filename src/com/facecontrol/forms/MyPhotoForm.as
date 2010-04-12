package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.facecontrol.gui.MyPhotoGridItem;
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class MyPhotoForm extends GameLayer
	{
		private static const opiumBold:Font = new EmbeddedFonts_OpiumBold();
		private static const tahoma:Font = new EmbeddedFonts_TahomaEmbed();
		
		private var _photos:Array;
		private var _mainPhoto:Photo;
//		private var _main:PhotoObject;
		private var _main:Object;
		
		protected var _ratingAverageField:TextField;
		protected var _votesCountField:TextField;
		
		private var _grid:GridBox;
		
		public function MyPhotoForm(value:GameScene)
		{
			super(value);
			
			var labelFormat:TextFormat = new TextFormat(opiumBold.fontName, 18, 0xceb0ff);
			
			var label:TextField = createLabel("Мои фото", 62, 92);
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
			
			label = createLabel("Главное фото", border.x + 4, 118);
			label.setTextFormat(new TextFormat(opiumBold.fontName, 14, 0xffa200));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			label = createLabel("Выбери самое лучшее фото твоей жизни", 38, 146, 125);
			label.setTextFormat(new TextFormat(tahoma.fontName, 12, 0xd3d96c));
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
			
			label = createLabel("Твои фото в приложении", border.x + 4, 118);
			label.setTextFormat(new TextFormat(opiumBold.fontName, 14, 0xffa200));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			label = createLabel("Выбери главное фото, которое будет учавствовать в голосовании", 273, 146, 240);
			label.setTextFormat(new TextFormat(tahoma.fontName, 12, 0xd3d96c));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.NONE;
			label.multiline = true;
			label.wordWrap = true;
			addChild(label);
			
			_mainPhoto = new Photo(_scene, null, 38, 189, 192, 177);
			_mainPhoto.photoBorder = 1;
			addChild(_mainPhoto);
			
			var bigStar:Bitmap = BitmapUtil.clone(Util.multiLoader.get(Images.BIG_STAR));
			bigStar.x = 38;
			bigStar.y = 376;
			addChild(bigStar);
			
			_ratingAverageField = createLabel("9,5", 77, 371);
			_ratingAverageField.setTextFormat(new TextFormat(tahoma.fontName, 30, 0xffffff));
			_ratingAverageField.embedFonts = true;
			_ratingAverageField.antiAliasType = AntiAliasType.ADVANCED;
			_ratingAverageField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_ratingAverageField);
			
			_votesCountField = createLabel("10345 голосов", 140, 386);
			_votesCountField.setTextFormat(new TextFormat(tahoma.fontName, 12, 0xb0dee6));
			_votesCountField.embedFonts = true;
			_votesCountField.antiAliasType = AntiAliasType.ADVANCED;
			_votesCountField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_votesCountField);
			
			label = createLabel("Комментарий к фото:", 38, 430);
			label.setTextFormat(new TextFormat(tahoma.fontName, 12, 0xd3d96c));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			var photoListBck:Bitmap = Util.multiLoader.get(Images.MY_PHOTO_BACKGROUND);
			photoListBck.y = 189;
			photoListBck.x = 274;
			addChild(photoListBck);
			
			var preview:LinkButton = new LinkButton(_scene, "предпросмотр", 278, 459);
			preview.setTextFormatForState(new TextFormat(tahoma.fontName, 11, 0xffb44a, null, null, true), LinkButton.STATE_NORMAL);
			preview.textField.embedFonts = true;
			preview.textField.antiAliasType = AntiAliasType.ADVANCED;
			addChild(preview);
			
			var markAsMain:Button = new Button(_scene, 264, 488);
			markAsMain.setTitleForState("Сделать главной", Button.STATE_NORMAL);
			markAsMain.setBackgroundImageForState(Util.multiLoader.get(Images.MY_PHOTO_BUTTON_RED), Button.STATE_NORMAL);
			markAsMain.setTextFormatForState(new TextFormat(tahoma.fontName, 10, 0xffffff), Button.STATE_NORMAL);
			markAsMain.textField.embedFonts = true;
			markAsMain.textField.antiAliasType = AntiAliasType.ADVANCED;
			markAsMain.setTextPosition(19, 17);
			addChild(markAsMain);
			
			var addPhoto:Button = new Button(_scene, 377, 488);
			addPhoto.setTitleForState("Добавить фото", Button.STATE_NORMAL);
			addPhoto.setBackgroundImageForState(Util.multiLoader.get(Images.MY_PHOTO_BUTTON_ORANGE), Button.STATE_NORMAL);
			addPhoto.setTextFormatForState(new TextFormat(tahoma.fontName, 10, 0xffffff), Button.STATE_NORMAL);
			addPhoto.textField.embedFonts = true;
			addPhoto.textField.antiAliasType = AntiAliasType.ADVANCED;
			addPhoto.setTextPosition(19, 17);
			addChild(addPhoto);
			
			var deletePhoto:Button = new Button(_scene, 486, 488);
			deletePhoto.setTitleForState("Удалить фото", Button.STATE_NORMAL);
			deletePhoto.setBackgroundImageForState(Util.multiLoader.get(Images.MY_PHOTO_BUTTON_GRAY), Button.STATE_NORMAL);
			deletePhoto.setTextFormatForState(new TextFormat(tahoma.fontName, 10, 0xffffff), Button.STATE_NORMAL);
			deletePhoto.textField.embedFonts = true;
			deletePhoto.textField.antiAliasType = AntiAliasType.ADVANCED;
			deletePhoto.setTextPosition(19, 17);
			addChild(deletePhoto);
			
			_grid = new GridBox(_scene, 2, 3);
			_grid.x = 288;
			_grid.y = 209;
			_grid.width = 290;
			_grid.height = 225;
			_grid.widthPolicy = GridBox.WIDTH_POLICY_AUTO_SIZE;
			_grid.heightPolicy = GridBox.HEIGHT_POLICY_AUTO_SIZE;
//			_grid.columnWidthPolicy = GridBox.COLUMN_WIDTH_POLICY_ALL_SAME;
//			_grid.rowHeightPolicy = GridBox.ROW_HEIGHT_POLICY_ALL_SAME;
			_grid.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			_grid.verticalItemsAlign = View.ALIGN_VER_TOP;
			_grid.indentBetweenItems = 27;
			_grid.padding = 0;
			addChild(_grid);
		}
		
		private function createLabel(text:String, x:int, y:int, width:int=0):TextField {
			var label:TextField = new TextField();
			label.text = (text) ? text : "";
			label.x = x;
			label.y = y;
			label.width = width;
			label.selectable = false;
			
			return label;
		}
		
		private function update():void {
			if (_main) {
				var format:TextFormat = _ratingAverageField.getTextFormat();
				_ratingAverageField.text = _main.rating_average;
				_ratingAverageField.setTextFormat(format);
				
				format = _votesCountField.getTextFormat();
				_votesCountField.text = _main.votes_count + " голосов";
				_votesCountField.setTextFormat(format);
			}
			
			var p:MyPhotoGridItem;
			for (var i:uint = 0; i < 6; ++i) {
				p = new MyPhotoGridItem(_scene, _photos[i], 141, 57);
				_grid.addItem(p);
			}
		}
		
		public function set photos(value:Array):void {
			if (value) {
				_photos = new Array(value.length);
				var i:uint;
				
				for (i = 0; i < value.length; ++i) {
					_photos[i] = value[i].photo;
					
					if (!Util.multiLoader.hasLoaded(_photos[i].pid)) {
						Util.multiLoader.load(_photos[i].src_big, _photos[i].pid, "Bitmap");
					}
					
					if (_photos[i].main == 1) {
						_main = _photos[i];
					}
				}
				Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
			}
		}
		
		public function multiLoaderCompliteListener(event:MultiLoaderEvent):void {
			if (Util.multiLoader.isLoaded) {
				Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
				_mainPhoto.photo = Util.multiLoader.get(_main.pid);
				update();
			}
		}
	}
}