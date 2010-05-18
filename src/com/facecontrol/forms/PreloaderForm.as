package com.facecontrol.forms
{
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.intervalactions.Animation;
	import com.flashmedia.gui.Form;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PreloaderForm extends Form
	{
		private static var _instance: PreloaderForm;
		public static function get instance(): PreloaderForm {
			if (!_instance) _instance = new PreloaderForm(Util.scene);
			return _instance;
		}
		
		private var _preloader: GameObject;
		
		public function PreloaderForm(value:GameScene)
		{
			super(value, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			
			bitmap = Util.multiLoader.get(Images.SPLASH);
			
			var label: TextField = Util.createLabel('Загрузка', 0, 520);
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.x = (Constants.APP_WIDTH - label.width) / 2 - 5;
			label.setTextFormat(new TextFormat(Util.tahoma.fontName, 16, 0xcac4c8));
			addChild(label);
			
			_preloader = new GameObject(scene);
			_preloader.x = (Constants.APP_WIDTH - Util.multiLoader.get(Images.PRELOADER_ANIM1).width) / 2;
			_preloader.y = 550;
			addChild(_preloader);
						
			var anm: Animation = new Animation(_scene, 'round', _preloader);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM1), 100);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM2), 100);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM3), 100);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM4), 100);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM5), 100);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM6), 100);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM7), 100);
			anm.addFrame(Util.multiLoader.get(Images.PRELOADER_ANIM8), 100);
			_preloader.addAnimation(anm);
			_preloader.startAnimation('round', -1, 0, anm.framesCount - 1);
			
		}
		
	}
}