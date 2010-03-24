package ru.facecontrol.forms
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import ru.facecontrol.FaceControl;
	import ru.flashmedia.basics.GameLayer;
	import ru.flashmedia.basics.GameObject;
	import ru.flashmedia.basics.GameScene;

	public class StartPreloadForm extends GameLayer
	{
		private var _preloader: GameObject;
		private var _minLoadTimer: Timer;
		private var _percentTextField: TextField;
		
		public function StartPreloadForm(value:GameScene)
		{
			super(value);
			
			width = FaceControl.APP_WIDTH;
			height = FaceControl.APP_HEIGHT;
			fillBackground(0xfdfdfd, 1.0);
			
			var tf: TextField = new TextField();
			tf.text = 'Загрузка. Пожалуйста подождите...';
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.setTextFormat(new TextFormat('Arial', 14));
			tf.x = (width - tf.textWidth) / 2;
			tf.y = 200;
			addChild(tf);
			
			_percentTextField = new TextField();
			_percentTextField.text = '0 %';
			_percentTextField.autoSize = TextFieldAutoSize.CENTER;
			_percentTextField.setTextFormat(new TextFormat('Arial', 14));
			_percentTextField.x = (width - _percentTextField.textWidth) / 2;
			_percentTextField.y = 220;
			addChild(_percentTextField);
			
			_preloader = new GameObject(scene);
			_preloader.bitmap = new Bitmap(new BitmapData(100, 100, false, 0xff2222), PixelSnapping.ALWAYS, true);
			_preloader.width = 100;
			_preloader.height = 100;
			_preloader.x = (width - _preloader.width) / 2;
			_preloader.y = 250;
			addChild(_preloader);
		}
		
		public function set progressPercent(value: uint): void {
			_percentTextField.text = value.toString() + ' %';
		}
	}
}