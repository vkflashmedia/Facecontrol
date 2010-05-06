package com.facecontrol.forms
{
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.actions.intervalactions.Animation;
	import com.flashmedia.gui.Form;

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
			
			_preloader = new GameObject(scene);
			_preloader.x = (Constants.APP_WIDTH - Util.multiLoader.get(Images.PRELOADER_ANIM1).width) / 2;
			_preloader.y = (Constants.APP_HEIGHT - Util.multiLoader.get(Images.PRELOADER_ANIM1).height) / 2;
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