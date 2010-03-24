package ru.facecontrol.forms
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import ru.facecontrol.FaceControl;
	import ru.flashmedia.basics.GameLayer;
	import ru.flashmedia.basics.GameObject;
	import ru.flashmedia.basics.GameObjectEvent;
	import ru.flashmedia.basics.GameScene;

	public class MainForm extends GameLayer
	{
		public var _userProfileBtn: GameObject;
		public var _mainPhoto: GameObject;
		
		public function MainForm(value:GameScene)
		{
			super(value);
			
			width = FaceControl.APP_WIDTH;
			height = FaceControl.APP_HEIGHT;
			fillBackground(0xfdfdfd, 1.0);
			
			var tf: TextField = new TextField();
			tf.text = 'Оцените фотографию.';
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.setTextFormat(new TextFormat('Arial', 14));
			tf.x = (width - tf.textWidth) / 2;
			tf.y = 100;
			addChild(tf);
			
			_mainPhoto = new GameObject(scene);
			//_mainPhoto.bitmap = new Bitmap(new BitmapData(200, 300, false, 0x22ff22), PixelSnapping.ALWAYS, true);
			var b: Bitmap = FaceControl.multiLoader.get("Photo1");
			b.width = 200;
			_mainPhoto.bitmap = b;
			_mainPhoto.x = (width - _mainPhoto.width) / 2;
			_mainPhoto.y = 150;
			addChild(_mainPhoto);
			
			_userProfileBtn = new GameObject(scene);
			_userProfileBtn.bitmap = new Bitmap(new BitmapData(100, 40, false, 0xff2222), PixelSnapping.ALWAYS, true);
			_userProfileBtn.width = 100;
			_userProfileBtn.height = 40;
			_userProfileBtn.x = 10;
			_userProfileBtn.y = 10;
			_userProfileBtn.selectable = true;
			_userProfileBtn.canFocus = true;
			_userProfileBtn.canHover = true;
			_userProfileBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, userProfileBtnClick);
			addChild(_userProfileBtn);
		}
		
		public function userProfileBtnClick(event: GameObjectEvent): void {
			if (!FaceControl.gameLayerManager.goNext()) {
				FaceControl.gameLayerManager.showLayer(FaceControl.FORM_USER_PROFILE);
			}
		}
	}
}