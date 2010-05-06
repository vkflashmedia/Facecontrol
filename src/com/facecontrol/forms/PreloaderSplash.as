package com.facecontrol.forms
{
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.intervalactions.Animation;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PreloaderSplash extends GameLayer
	{
		private static var _instance: PreloaderSplash;
		public static function get instance(): PreloaderSplash {
			if (!_instance) _instance = new PreloaderSplash(Util.scene);
			return _instance;
		}
		
		private var _preloader: GameObject;
		
		public function PreloaderSplash(value:GameScene)
		{
			super(value);
			
			this.graphics.beginFill(0x00, 0.5);
			this.graphics.drawRect(0, 0, _scene.width, _scene.height);
			
			bitmap = Util.multiLoader.get(Images.PRELOADER_BACK);
			bitmap.x = 231;
			bitmap.y = 214;
			
			var label: TextField = Util.createLabel('Загрузка', 284, 227);
			label.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0x24b5ff));
			label.embedFonts = true;
			label.antiAliasType = AntiAliasType.ADVANCED;
			label.autoSize = TextFieldAutoSize.LEFT;
			addChild(label);
			
			_preloader = new GameObject(scene);
			_preloader.x = 282;
			_preloader.y = 270;
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
		
		//todo run anim onShowModal event
		//todo stop anim onHideModal event
		
	}
}