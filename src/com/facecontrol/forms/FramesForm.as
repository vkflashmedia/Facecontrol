package com.facecontrol.forms
{
	import com.efnx.events.MultiLoaderEvent;
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.dialog.MessageDialog;
	import com.facecontrol.dialog.MessageDialogEvent;
	import com.facecontrol.dialog.PaymentDialog;
	import com.facecontrol.gui.Photo;
	import com.facecontrol.util.Constants;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.Form;
	import com.flashmedia.util.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FramesForm extends Form
	{
		private const THUMB_X: int				= 12;
		private const THUMB_WIDTH: int			= 60;
		private const THUMB_HEIGHT: int			= 60;
		private const THUMB_BETWEEN_INDENT: int	= 14;
		private const THUMB_VISIBLE_COUNT: int	= 5;
		
		private static const FRAMES_NAMES:Array = new Array(
			'Дракон',
			'Цветы',
			'Графити',
			'Сердца',
			'Музыка',
			'Розовая',
			'Аквариум',
			'Стразы'
		);
		
		private static const FRAMES_PRICES:Array = new Array(
			'(10 монет)',
			'(10 монет)',
			'(10 монет)',
			'(10 монет)',
			'(10 монет)',
			'(10 монет)',
			'(10 монет)',
			'(10 монет)'
		);
		
		private static const PRICES:Array = new Array(
			10,
			10,
			10,
			10,
			10,
			10,
			10,
			10
		);
		
		private static var _instance:FramesForm = null;
		public static function get instance():FramesForm {
			if (!_instance) _instance = new FramesForm(Util.scene, 0, 0, Constants.APP_WIDTH, Constants.APP_HEIGHT);
			return _instance;
		}
		
		private var _framePrice:TextField;
		private var _api:Api;
		
		private var _main:Object;
		private var _mainPhoto:Photo;
		
		private var _currentFrameIndex:int;
		private var _frames:Array;
		private var _framesLayer: GameLayer;
		
		private var _frameName:TextField;
		
		public function FramesForm(value:GameScene, x:int, y:int, width:int, height:int)
		{
			super(value, x, y, width, height);
			
			visible = false;
			
			_api = new Api();
			_api.addEventListener(ApiEvent.COMPLETED, function(event:ApiEvent):void {
				var response:Object = event.response;
				switch (response.method) {
					case 'next_photo':
						_main = response;
						update();
						show();
					break;
					
					case 'set_frame':
						Util.user.frame = response.frame;
						Util.api.getPhotos(Util.viewer_id);
					break;
				}
			});
			
			_frames = new Array(8);
			
			var smileIco:Bitmap = BitmapUtil.cloneImageNamed(Images.MY_PHOTO_SMILE_ICO);
			smileIco.x = 114;
			smileIco.y = 93;
			addChild(smileIco);
			
			_frameName = Util.createLabel('Стразы ', 136, 88);
			_frameName.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xceb0ff));
			_frameName.embedFonts = true;
			_frameName.antiAliasType = AntiAliasType.ADVANCED;
			_frameName.autoSize = TextFieldAutoSize.LEFT;
			addChild(_frameName);
			
			_framePrice = Util.createLabel('(10 монет)', _frameName.x + _frameName.width, 88);
			_framePrice.setTextFormat(new TextFormat(Util.opiumBold.fontName, 18, 0xf7ebff));
			_framePrice.embedFonts = true;
			_framePrice.antiAliasType = AntiAliasType.ADVANCED;
			_framePrice.autoSize = TextFieldAutoSize.LEFT;
			addChild(_framePrice);
			
			var labelDesc: TextField = Util.createLabel('Здесь ты можешь приобрести рамку для главной фотографии', 145, 119);
			labelDesc.setTextFormat(new TextFormat(Util.tahoma.fontName, 12, 0xd3d96c));
			labelDesc.embedFonts = true;
			labelDesc.antiAliasType = AntiAliasType.ADVANCED;
			labelDesc.autoSize = TextFieldAutoSize.LEFT;
			addChild(labelDesc);
			
			var background:Bitmap = BitmapUtil.cloneImageNamed(Images.ALL_USER_PHOTO_BACK);
			background.x = 73;
			background.y = 144;
			addChild(background);
			
			_mainPhoto = new Photo(_scene, null, 85, 155, 470, 315, Photo.BORDER_TYPE_ROUND_RECT);
			_mainPhoto.align = Photo.ALIGN_CENTER;
			_mainPhoto.verticalAlign = Photo.VERTICAL_ALIGN_TOP;
			_mainPhoto.horizontalAlign = Photo.HORIZONTAL_ALIGN_CENTER;
			_mainPhoto.photoBorderColor = 0x3a2426;
			addChild(_mainPhoto);
			
			background = BitmapUtil.cloneImageNamed(Images.ALL_USER_PHOTO_BACK2);
			background.x = 73;
			background.y = 486;
			addChild(background);
			
			_framesLayer = new GameLayer(scene);
			_framesLayer.smoothScroll = 0.7;
			_framesLayer.x = 99;
			_framesLayer.y = 498;
			_framesLayer.width = 432;
			_framesLayer.height = THUMB_HEIGHT;
			_framesLayer.scrollRect = new Rectangle(0, 0, _framesLayer.width, THUMB_HEIGHT);
			addChild(_framesLayer);
			
			var lastFrameX:int = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_DRAGON), 1, 0);
			lastFrameX = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_FLOWERS), 2, lastFrameX);
			lastFrameX = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_GRAFFITI), 3, lastFrameX);
			lastFrameX = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_HEARTS2), 4, lastFrameX);
			lastFrameX = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_MUSIC), 5, lastFrameX);
			lastFrameX = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_PINK2), 6, lastFrameX);
			lastFrameX = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_SOM2), 7, lastFrameX);
			lastFrameX = initFramesLayer(BitmapUtil.cloneImageNamed(Images.FRAME_STR2), 8, lastFrameX);
			
			var leftButton:Button = new Button(_scene, 32, 488);
			leftButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ALL_USER_PHOTO_LEFT_BTN), CONTROL_STATE_NORMAL);
			leftButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ALL_USER_PHOTO_LEFT_ACT_BTN), CONTROL_STATE_HIGHLIGHTED);
			leftButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				scrollToIndex(_currentFrameIndex - 1);
			});
			addChild(leftButton);
			
			var rightButton:Button = new Button(_scene, 568, 488);
			rightButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ALL_USER_PHOTO_RIGHT_BTN), CONTROL_STATE_NORMAL);
			rightButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ALL_USER_PHOTO_RIGHT_ACT_BTN), CONTROL_STATE_HIGHLIGHTED);
			rightButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				scrollToIndex(_currentFrameIndex + 1);
			});
			addChild(rightButton);
			
			var buyButton:Button = new Button(_scene, 251, 572);
			buyButton.setBackgroundImageForState(BitmapUtil.cloneImageNamed(Images.ADD_PHOTO_BUTTON_ORANGE), CONTROL_STATE_NORMAL);
			buyButton.setTitleForState('Купить', CONTROL_STATE_NORMAL);
			buyButton.setTextFormatForState(new TextFormat(Util.tahoma.fontName, 10, 0xffffff), CONTROL_STATE_NORMAL);
			buyButton.textField.embedFonts = true;
			buyButton.textField.antiAliasType = AntiAliasType.ADVANCED;
			buyButton.setTextPosition(49, 11);
			buyButton.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				if (Util.user.account >= PRICES[_currentFrameIndex]) {
					Util.api.writeOff(PRICES[_currentFrameIndex]);
					Util.user.account -= PRICES[_currentFrameIndex];
					Background.instance.updateAccount();
					_api.setFrame(_currentFrameIndex + 1);
					PreloaderSplash.instance.showModal();
				}
				else {
					var message:MessageDialog = new MessageDialog(Util.scene, 'Сообщение', 'На вашем счету недостаточно' + 
							' монет. Пополнить счет?', 'Да', 'Нет');
					message.addEventListener(MessageDialogEvent.CANCEL_BUTTON_CLICKED, function(event:MessageDialogEvent):void {
						PaymentDialog.showPayment();
					});
					Util.scene.showModal(message);
				}
			});
			addChild(buyButton);
		}
		
		public override function show():void {
			if (_scene) {
				for (var i:int = 0; i < _scene.numChildren; ++i) {
					if (_scene.getChildAt(i) is Form) {
						var form:Form = _scene.getChildAt(i) as Form;
						form.visible = (form is FramesForm);
					}
				}
			}
		}
		
		public function getMainPhoto():void {
			_api.mainPhoto(Util.viewer_id);
		}
		
		public function update():void {
			if (_main) {
				if (Util.multiLoader.hasLoaded(_main.pid)) {
					_mainPhoto.photo = BitmapUtil.cloneImageNamed(_main.pid);
					_mainPhoto.frameIndex = _main.frame;
					scrollToIndex(_main.frame - 1);
					PreloaderSplash.instance.resetModal();
				}
				else {
					Util.multiLoader.load(_main.src_big, _main.pid, 'Bitmap');
					Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, function(event:MultiLoaderEvent):void {
						if (Util.multiLoader.hasLoaded(_main.pid)) {
							update();
						}
					});
				}
			}
		}
		
		private function initFramesLayer(frameBitmap:Bitmap, frameIndex:int, lastPhotoX:int):int {
			var frame: Photo = new Photo(scene, frameBitmap, 0, 0, THUMB_WIDTH, THUMB_HEIGHT, Photo.BORDER_TYPE_RECT);
			frame.index = frameIndex;
			frame.photoBorder = 1;
			frame.photoBorderColor = 0x563645;
			frame.horizontalScale = Photo.HORIZONTAL_SCALE_ALWAYS;
			frame.verticalScale = Photo.VERTICAL_SCALE_ALWAYS;
			if (lastPhotoX == 0) {
				frame.x = 189;
				lastPhotoX = frame.x + THUMB_BETWEEN_INDENT + THUMB_WIDTH;
				if (PreloaderSplash.instance.isModal) {
					scene.resetModal(PreloaderSplash.instance);
				}
			}
			else {
				frame.x = lastPhotoX;
				_framesLayer.width += THUMB_BETWEEN_INDENT + THUMB_WIDTH;
				lastPhotoX += THUMB_BETWEEN_INDENT + THUMB_WIDTH;
			}
			frame.buttonMode = true;
			frame.useHandCursor = true;
			frame.setSelect(true);
			frame.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function(event:GameObjectEvent):void {
				scrollToIndex(event.target.index - 1);
			});
			_framesLayer.addChild(frame);
			
			_frames[frameIndex - 1] = frame;
			return lastPhotoX;
		}
		
		private function scrollToIndex(index:int):void {
			if (index < 0) index = 0;
			if (index > _frames.length - 1) index = _frames.length - 1;
			
			_frameName.defaultTextFormat = _frameName.getTextFormat();
			_frameName.text = FRAMES_NAMES[index];
			
			_framePrice.defaultTextFormat = _framePrice.getTextFormat();
			_framePrice.text = FRAMES_PRICES[index];
			_framePrice.x = _frameName.x + _frameName.width + 10;
			
			var frame:Photo = _frames[index];
			_framesLayer.scroll(frame.x - 189 - _framesLayer.scrollRect.x, 0);
			_mainPhoto.frameIndex = frame.index;
			_currentFrameIndex = index;
		}
	}
}