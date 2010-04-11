package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameScene;
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
			_mainPhoto.border = 1;
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
		}
		
		public function set photos(value:Array):void {
			if (value) {
				_photos = new Array(value.length);
				var i:uint;
				
				for (i = 0; i < value.length; ++i) {
					_photos[i] = value[i].photo;
					
					if (_photos[i].main == 1) {
						_main = _photos[i];
						
						if (!Util.multiLoader.hasLoaded(_photos[i].pid)) {
							Util.multiLoader.load(_photos[i].src_big, _photos[i].pid, "Bitmap");
							Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
						}
						break;
					}
				}
			}
		}
		
		public function multiLoaderCompliteListener(event:MultiLoaderEvent):void {
			Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompliteListener);
			_mainPhoto.photo = Util.multiLoader.get(_main.pid);
			update();
		}
	}
}