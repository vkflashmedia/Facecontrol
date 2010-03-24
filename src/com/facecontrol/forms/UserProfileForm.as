package ru.facecontrol.forms
{
		import ru.facecontrol.FaceControl;
		
		import flash.display.Bitmap;
		import flash.display.BitmapData;
		import flash.display.PixelSnapping;
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
		
		import ru.flashmedia.basics.GameLayer;
		import ru.flashmedia.basics.GameObject;
		import ru.flashmedia.basics.GameObjectEvent;
		import ru.flashmedia.basics.GameScene;

	public class UserProfileForm extends GameLayer
	{
		public var _backBtn: GameObject;
		public var _mainPhoto: GameObject;
		
		public function UserProfileForm(value:GameScene)
		{
			super(value);
			
			width = FaceControl.APP_WIDTH;
			height = FaceControl.APP_HEIGHT;
			fillBackground(0xfdfddd, 1.0);
			
			var tf: TextField = new TextField();
			tf.text = 'Выбери свое самое лучшее фото.';
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.setTextFormat(new TextFormat('Arial', 14));
			tf.x = (width - tf.textWidth) / 2;
			tf.y = 100;
			addChild(tf);
			
			_mainPhoto = new GameObject(scene);
			_mainPhoto.bitmap = FaceControl.multiLoader.get("Photo2");
			_mainPhoto.x = (width - _mainPhoto.width) / 2;
			_mainPhoto.y = 150;
			addChild(_mainPhoto);
			
			_backBtn = new GameObject(scene);
			_backBtn.bitmap = new Bitmap(new BitmapData(100, 40, false, 0xff2222), PixelSnapping.ALWAYS, true);
			_backBtn.width = 100;
			_backBtn.height = 40;
			_backBtn.x = 10;
			_backBtn.y = 10;
			_backBtn.selectable = true;
			_backBtn.canFocus = true;
			_backBtn.canHover = true;
			_backBtn.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, backBtnClick);
			addChild(_backBtn);
		}
		
		public function backBtnClick(event: GameObjectEvent): void {
			FaceControl.gameLayerManager.showLayer(FaceControl.FORM_MAIN);
		}
		
	}
}