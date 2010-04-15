package {
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.ApiEvent;
	import com.facecontrol.forms.Back;
	import com.facecontrol.forms.MainForm;
	import com.facecontrol.forms.MyPhotoForm;
	import com.facecontrol.gui.MainMenuEvent;
	import com.facecontrol.util.Images;
	import com.facecontrol.util.Util;
	import com.flashmedia.basics.GameLayer;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.basics.View;
	import com.flashmedia.gui.ComboBox;
	import com.flashmedia.gui.Form;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.GridBoxEvent;
	import com.flashmedia.gui.Label;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.Pagination;
	import com.flashmedia.gui.RatingBar;
	import com.flashmedia.gui.ScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class Facecontrol extends GameScene {
		
		private static var _images:Images;
		private static var _multiLoader: MultiLoader;
		
		private var textField: TextField = new TextField();
		private var p:Pagination;
		private var linkButton:LinkButton;
		private var gb: GridBox;
		private var cb: ComboBox;
		private var scroll: ScrollBar;
		private var rateBar: RatingBar;
		private var form: Form;
		
		private var _back:Back;
		private var _mainForm:MainForm;
		private var _myPhotoForm:MyPhotoForm;
		
		public function Facecontrol() {
//			aliFunction();
//			artemFunction();
			//testComponents();

//			_images = new Images();
//			
////			MultiLoader.testing = true;
//			Util.multiLoader = new MultiLoader();
//			Util.multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
//			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
//			
//			Util.api.addEventListener(ApiEvent.COMPLETED, onRequestComplited);
//			
//			load();
			
			_images = new Images();
			
//			MultiLoader.testing = true;
			Util.multiLoader = new MultiLoader();
			load();
			Util.multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
			Util.multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
			
			Util.api.addEventListener(ApiEvent.COMPLETED, onRequestComplited);
			Util.api.addEventListener(ApiEvent.ERROR, onRequestError);
			
		}
		
		private function load():void {
			Util.multiLoader.load(Images.HEAD_BUTTON1_PATH, Images.HEAD_BUTTON1, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON2_PATH, Images.HEAD_BUTTON2, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON3_PATH, Images.HEAD_BUTTON3, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON4_PATH, Images.HEAD_BUTTON4, 'Bitmap');
			Util.multiLoader.load(Images.HEAD_BUTTON5_PATH, Images.HEAD_BUTTON5, 'Bitmap');
			
			Util.multiLoader.load(Images.BACKGROUND_PATH, Images.BACKGROUND, 'Bitmap');
			
			Util.multiLoader.load(Images.SUPER_ICON_PATH, Images.SUPER_ICON, 'Bitmap');
			Util.multiLoader.load(Images.JUNK_ICON_PATH, Images.JUNK_ICON, 'Bitmap');

			Util.multiLoader.load(Images.BIG_MASK_PATH, Images.BIG_MASK, 'Bitmap');
			Util.multiLoader.load(Images.SMALL_MASK_PATH, Images.SMALL_MASK, 'Bitmap');
			Util.multiLoader.load(Images.BIG_STAR_PATH, Images.BIG_STAR, 'Bitmap');
			Util.multiLoader.load(Images.LINE_PATH, Images.LINE, 'Bitmap');
			Util.multiLoader.load(Images.FILTER_BACKGROUND_PATH, Images.FILTER_BACKGROUND, 'Bitmap');
			Util.multiLoader.load(Images.CHOOSE_BUTTON_PATH, Images.CHOOSE_BUTTON, 'Bitmap');
			Util.multiLoader.load(Images.RATING_BACKGROUND_PATH, Images.RATING_BACKGROUND, 'Bitmap');
			Util.multiLoader.load(Images.RATING_OFF_PATH, Images.RATING_OFF, 'Bitmap');
			Util.multiLoader.load(Images.RATING_ON_PATH, Images.RATING_ON, 'Bitmap');
					
			Util.multiLoader.load(Images.ADVERTISING_FORM_PATH, Images.ADVERTISING_FORM, 'Bitmap');
			Util.multiLoader.load(Images.MY_PHOTO_BACKGROUND_PATH, Images.MY_PHOTO_BACKGROUND, 'Bitmap');
			Util.multiLoader.load(Images.MY_PHOTO_BUTTON_RED_PATH, Images.MY_PHOTO_BUTTON_RED, 'Bitmap');
			Util.multiLoader.load(Images.MY_PHOTO_BUTTON_ORANGE_PATH, Images.MY_PHOTO_BUTTON_ORANGE, 'Bitmap');
			Util.multiLoader.load(Images.MY_PHOTO_BUTTON_GRAY_PATH, Images.MY_PHOTO_BUTTON_GRAY, 'Bitmap');
			Util.multiLoader.load(Images.MY_PHOTO_SMILE_ICO_PATH, Images.MY_PHOTO_SMILE_ICO, 'Bitmap');
			
			Util.multiLoader.load(Images.ARROW_LEFT_PATH, Images.ARROW_LEFT, 'Bitmap');
			Util.multiLoader.load(Images.ARROW_RIGHT_PATH, Images.ARROW_RIGHT, 'Bitmap');
			Util.multiLoader.load(Images.V_PATH, Images.V, 'Bitmap');
		}
		
		private function multiLoaderProgressListener(event:MultiLoaderEvent):void {
			
		}
		
		private function multiLoaderCompleteListener(event:MultiLoaderEvent):void {
			if (Util.multiLoader.isLoaded) {
				Util.multiLoader.removeEventListener(MultiLoaderEvent.PROGRESS, multiLoaderProgressListener);
				Util.multiLoader.removeEventListener(MultiLoaderEvent.COMPLETE, multiLoaderCompleteListener);
				
				_back = new Back(this);
				_back.menu.addEventListener(MainMenuEvent.FIRST_BUTTON_CLICK, onFirstMenuButtonClick);
				_back.menu.addEventListener(MainMenuEvent.SECOND_BUTTON_CLICK, onSecondMenuButtonClick);
				addChild(_back);
				
				_mainForm = new MainForm(this);
				addChild(_mainForm);
				_mainForm.visible = false;
				
				_myPhotoForm = new MyPhotoForm(this);
				addChild(_myPhotoForm);
				_myPhotoForm.visible = false;
				
				Util.api.loadSettings(Util.userId);
			}
		}
		
		private function onFirstMenuButtonClick(event:MainMenuEvent):void {
			_mainForm.visible = true;
			_myPhotoForm.visible = false;
		}
		
		private function onSecondMenuButtonClick(event:MainMenuEvent):void {
			Util.api.getPhotos(Util.userId);
		}
		
		private function onRequestError(event:ApiEvent):void {
			try {
				switch (event.errorCode) {
					case 10:
						_mainForm.updateFilter();
					break;
					default:
						trace('error - ' + event.errorMessage);
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
		}
		
		private function onRequestComplited(event:ApiEvent):void {
			var response:Object = event.response;
			try {
				switch (response.method) {
					case "load_settings":
						_mainForm.filter = response;
						_mainForm.visible = true;
					break;
					case "next_photo":
						_mainForm.nextPhoto(response);
					break;
					
					case "vote":
						_mainForm.vote(response);
					break;
					
					case "get_photos":
						_myPhotoForm.photos = response.photos;
						_myPhotoForm.visible = true;
						_mainForm.visible = false;
					break;
					
					case 'del_photo':
					case 'set_main':
						Util.api.getPhotos(Util.userId);
					break;
				}
			}
			catch (e:Error) {
				trace(e.message);
			}
			
			switch (response["err_code"]) {
				case 10:
					_mainForm.updateFilter();
				break;
			}
		}
		
		/*
		private function onLoad(event: MultiLoaderEvent): void {
			switch (event.entry) {
				case 'Button1':
					menu.buttonAtIndex(0).setBackgroundImageForState(_multiLoader.get("Button1"), Button.STATE_NORMAL);
				break;
				case 'Button2':
					menu.buttonAtIndex(1).setBackgroundImageForState(_multiLoader.get("Button2"), Button.STATE_NORMAL);
				break;
				case 'Button3':
					menu.buttonAtIndex(2).setBackgroundImageForState(_multiLoader.get("Button3"), Button.STATE_NORMAL);
				break;
				case 'Button4':
					menu.buttonAtIndex(3).setBackgroundImageForState(_multiLoader.get("Button4"), Button.STATE_NORMAL);
				break;
				case 'Button5':
					menu.buttonAtIndex(4).setBackgroundImageForState(_multiLoader.get("Button5"), Button.STATE_NORMAL);
				break;
				case 'scroll_up':
				case 'scroll_body':
				case 'scroll_down':
					if (_multiLoader.hasLoaded('scroll_up') &&
						_multiLoader.hasLoaded('scroll_body') &&
						_multiLoader.hasLoaded('scroll_down')) {
						var image:Bitmap = BitmapUtil.createImage(
							_multiLoader.get('scroll_up'),
							_multiLoader.get('scroll_body'),
							_multiLoader.get('scroll_down'),
							100);
						addChild(image);
					}
				break;
			}
		}
		
		private function aliFunction():void {
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, onLoad);
			/*
			var format:TextFormat = new TextFormat();
			format.font = MenuFont.fontName;
			format.size = 18;
			
//			b = new Button(this, 0, 50);
//			b.setTitleForState("Main меню", Button.STATE_NORMAL);
//			b.setTextFormatForState(format, Button.STATE_NORMAL);
//			b.textField.embedFonts = true;
//			b.setTextPosition(100, 50);
//			b.setBackgroundImageForState(_multiLoader.get("Button"), Button.STATE_NORMAL);
//			addChild(b);
//			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClicked);

			var b1:Button = new Button(this, 0, 0);
			b1.setTitleForState("main", Button.STATE_NORMAL);
			b1.setTextFormatForState(format, Button.STATE_NORMAL);
			b1.textField.embedFonts = true;
			b1.setTextPosition(50, 10);
			
			var b2:Button = new Button(this, 149, 0);
			b2.setTitleForState("my photos", Button.STATE_NORMAL);
			b2.setTextFormatForState(format, Button.STATE_NORMAL);
			b2.textField.embedFonts = true;
			b2.setTextPosition(35, 10);
			
			var b3:Button = new Button(this, 257, 0);
			b3.setTitleForState("top100", Button.STATE_NORMAL);
			b3.setTextFormatForState(format, Button.STATE_NORMAL);
			b3.textField.embedFonts = true;
			b3.setTextPosition(30, 10);
			
			var b4:Button = new Button(this, 364, 0);
			b4.setTitleForState("bottom100", Button.STATE_NORMAL);
			b4.setTextFormatForState(format, Button.STATE_NORMAL);
			b4.textField.embedFonts = true;
			b4.setTextPosition(30, 10);
			
			var b5:Button = new Button(this, 483, 0);
			b5.setTitleForState("friends", Button.STATE_NORMAL);
			b5.setTextFormatForState(format, Button.STATE_NORMAL);
			b5.textField.embedFonts = true;
			b5.setTextPosition(30, 10);
			
			var buttons:Array = new Array(b1, b2, b3, b4, b5);
			menu = new MainMenu(this);
			menu.buttons = buttons;
			addChild(menu);
			
			_multiLoader.load("images\\head\\01.png", "Button1", "Bitmap");
			_multiLoader.load("images\\head\\02.png", "Button2", "Bitmap");
			_multiLoader.load("images\\head\\03.png", "Button3", "Bitmap");
			_multiLoader.load("images\\head\\04.png", "Button4", "Bitmap");
			_multiLoader.load("images\\head\\05.png", "Button5", "Bitmap");
			
			_multiLoader.load("images\\scroll_up.png", "scroll_up", "Bitmap");
			_multiLoader.load("images\\scroll_body.png", "scroll_body", "Bitmap");
			_multiLoader.load("images\\scroll_down.png", "scroll_down", "Bitmap");
		}
		*/
		private function testComponents(): void {
			_multiLoader = new MultiLoader();
			//multiLoader.load("http://cs1256.vkontakte.ru/u7776141/17008570/x_b07e69c3.jpg", "Photo1", "Bitmap");
			_multiLoader.load("c:\\img\\choose_button.png", "dropIcon", "Bitmap");
			_multiLoader.load("c:\\img\\rating_bgr.png", "ratingBack", "Bitmap");
			_multiLoader.load("c:\\img\\rating_star_active.png", "ratingIconOn", "Bitmap");
			_multiLoader.load("c:\\img\\rating_star_off.png", "ratingIconOff", "Bitmap");
			_multiLoader.load("c:\\img\\topIcon.png", "topIcon", "Bitmap");
			_multiLoader.load("c:\\img\\bottomIcon.png", "bottomIcon", "Bitmap");
			_multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, function (event: MultiLoaderEvent): void {
			
			});
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, function (event: MultiLoaderEvent): void {
				switch (event.entry) {
					case 'dropIcon':
						cb.dropIcon = _multiLoader.get("dropIcon");
						//gb.addItem(_multiLoader.get("dropIcon"));
						//gb.addItem(cb);
					break;
					case 'ratingBack':
						rateBar.bitmap = _multiLoader.get("ratingBack");
						//gb.addItem(rateBar);
					break;
					case 'ratingIconOff':
						rateBar.rateIconOff = _multiLoader.get("ratingIconOff");
						//gb.addItem(_multiLoader.get("ratingIconOff"));
					break;
					case 'ratingIconOn':
						rateBar.rateIconOn = _multiLoader.get("ratingIconOn");
						label.icon = _multiLoader.get("ratingIconOn");
					break;
					case 'topIcon':
						form.verticalScrollBar.topIcon = _multiLoader.get("topIcon");
					break;
					case 'bottomIcon':
						form.verticalScrollBar.bottomIcon = _multiLoader.get("bottomIcon");
					break;
				}
			});
			
			rateBar = new RatingBar(this, 10);
			rateBar.x = 550;
			rateBar.y = 300;
			rateBar.setLayout(5, 13, 26, 21);
			addChild(rateBar);

			var spr: Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(0, 0, 100, 15, 12);
			spr.graphics.endFill();
			var bd: BitmapData = new BitmapData(100, 15, true, undefined);
			bd.draw(spr);
			var cbBack: Bitmap = new Bitmap(bd);
			cb = new ComboBox(this);
			cb.textFormat = new TextFormat('Arial', 16, 0x00dede);
			cb.horizontalAlign = View.ALIGN_HOR_RIGHT;
			cb.bitmap = cbBack;
			cb.x = 400;
			cb.y = 400;
			cb.height = 15;
			cb.addItem('Item1');
			cb.addItem('Item2');
			cb.addItem('Item3');
			cb.addItem('Item4');
			cb.addItem('Item5');
			cb.addItem('Item6');
			cb.addItem('Item7');
			cb.addItem('Item8');
			cb.addItem('Item9');
			cb.addItem('Item10');
			cb.selectedItem = 'Item1';
			//выделение уходит за scrollBar !!!
			addChild(cb);
			
			var label: Label = new Label(this, 'TestLabel');
			label.x = 300;
			label.y = 250;
			label.fillBackground(0xffffff, 1.0);
			label.setSelect(true);
			label.setHover(true);
			label.setFocus(true, true, new Bitmap(new BitmapData(100, 40, false, 0x00ff00)), View.ALIGN_HOR_CENTER | View.ALIGN_VER_CENTER);
			label.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
				gb.removeAllItems();
			});
			addChild(label);
			
			gb = new GridBox(this, 4);
			gb.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, function (event: GridBoxEvent) : void {
				trace((event.item as String) + ' ' + event.columnIndex + ' ' + event.rowIndex);
			});
			gb.debug = true;
			gb.x = 50;
			gb.y = 3;
			gb.width = 550;
			gb.height = 106;
			gb.widthPolicy = GridBox.WIDTH_POLICY_ABSOLUTE;
			//gb.heightPolicy = GridBox.HEIGHT_POLICY_ABSOLUTE;
			//TODO autoSize - часть компонента скрывается за полосой прокрутки
//			gb.columnWidthPolicy = GridBox.COLUMN_WIDTH_POLICY_ALL_SAME;
//			gb.rowHeightPolicy = GridBox.ROW_HEIGHT_POLICY_ALL_SAME;
			gb.horizontalItemsAlign = View.ALIGN_HOR_LEFT;
			gb.verticalItemsAlign = View.ALIGN_VER_TOP;
			gb.fillBackground(0xffffff, 1.0);
			gb.indentBetweenRows = 0;
			gb.indentBetweenCols = 0;
			gb.padding = 0;
			gb.addItem('VeryVeryVeryLongItem\nNew line text');
			for (var i: uint = 0; i < 20; i++) {
				var str: String = 'Item' + i.toString();
				if (i == 2) {
					str = 'Long long Item 10';
				}
				if (i == 7) {
					str = 'Line1\nLine2\nLine3';
				}
				gb.addItem(str);
			}
			//gb.setItemFocus(new Bitmap(new BitmapData(100, 40, false, 0x00ff00)), 0);
			addChild(gb);
			
			scroll = new ScrollBar(this, 200, 300, 150, 20, ScrollBar.TYPE_HORIZONTAL);
			addChild(scroll);
			
			var tf1: TextField = new TextField();
			tf1.autoSize = TextFieldAutoSize.LEFT;
			tf1.selectable = false;
			tf1.text = 'sd d4r3 4r q4rw';
			var tf2: TextField = new TextField();
			tf2.y = 250;
			tf2.autoSize = TextFieldAutoSize.LEFT;
			tf2.selectable = false;
			tf2.text = 'Maidfrfrf rfsr nText';
			var tf3: TextField = new TextField();
			tf3.y = 170;
			tf3.autoSize = TextFieldAutoSize.LEFT;
			tf3.selectable = false;
			tf3.text = 'gggggggggggyyyyyyyyy 3';
			var tf4: TextField = new TextField();
			tf4.y = 140;
			tf4.autoSize = TextFieldAutoSize.LEFT;
			tf4.selectable = false;
			tf4.text = 'dsfzfdzgdf 3';
			var tf5: TextField = new TextField();
			tf5.x = 30;
			tf5.y = 70;
			tf5.autoSize = TextFieldAutoSize.LEFT;
			tf5.selectable = false;
			tf5.text = 'gggggggggggyyyyyyyyy 3354626563573';
			
			var gl: GameLayer = new GameLayer(this);
			gl.x = 650;
			gl.y = 100;
			gl.debug = true;
			gl.sizeMode = GameLayer.SIZE_MODE_WIDTH_BY_CONTENT | GameLayer.SIZE_MODE_HEIGHT_BY_CONTENT;
			gl.addChild(tf4);
			gl.addChild(tf5);
			addChild(gl);
			gl.removeChild(tf5);
			
			form = new Form(this, 20, 300, 90, 220);
			//form.verticalScrollBar.active = false;
			form.addComponent(tf1);
			form.addComponent(tf2);
			form.addComponent(tf3);
			
			form.verticalScrollBar.width = 15;
			form.verticalScrollBar.viewImagesPolicy = ScrollBar.VIEW_ALL;
			form.verticalScrollBar.setBackStyle(0x3a2e31, 0.8, 5);
			form.verticalScrollBar.setScrollStyle(0x81787b, 1.0, 10, 8);

			form.horizontalScrollBar.setBackStyle(0x3a2e31, 0.8, 5);
			form.horizontalScrollBar.setScrollStyle(0x81787b, 1.0, 10, 8);
			form.horizontalScrollBar.scrollStep = 0.4;			
			form.horizontalScrollBar.viewImagesPolicy = ScrollBar.VIEW_ALL;
			form.horizontalScrollBar.height = 15;
			
			addChild(form);
			
			var textInput: TextField = new TextField();
			textInput.autoSize = TextFieldAutoSize.LEFT;
			textInput.selectable = true;
			textInput.x = 700;
			textInput.y = 400;
			textInput.text = 'Введите свой комментарий...';
			textInput.width = 100;
			textInput.type = TextFieldType.INPUT;
			textInput.wordWrap = true;
			addChild(textInput);
		}
		/*
		private function onButtonClicked(e: GameObjectEvent): void {
			var cancelButton:Button = new Button(this);
			cancelButton.x = 40;
			cancelButton.y = 50;
			cancelButton.width = 50;
			cancelButton.setTitleForState("Ok", Button.STATE_NORMAL);
			
			var otherButton:Button = new Button(this);
			otherButton.x = 110;
			otherButton.y = 50;
			otherButton.width = 50;
			otherButton.setTitleForState("Other", Button.STATE_NORMAL);
			var msg: MessageBox = new MessageBox(this, "Message", cancelButton, otherButton);
			msg.show();
		}
		
		private function changeListener(e:Event):void {
			p.clear();
			p.update();
		}
		
		private function request():void {
			this.addChild(textField);
			var api:Api = new Api(textField);
			api.addEventListener(ApiEvent.ERROR, onError);
			api.addEventListener(ApiEvent.COMPLETED, onCompleted);
			
			api.registerUser(1, "test1", "test3", null, 0, null, 1);
		}
		
		public function onError(e:ApiEvent):void {
			textField.text = "error";
		}
		
		public function onCompleted(e:ApiEvent):void {
			var response:Object = e.response;
			try {
				textField.text = response["method"];
			}
			catch (e:Error) {
				textField.text = e.message;
			}
		}
		*/
		
		public function artemFunction(): void {
			var go: GameObject = new GameObject(this);
			go.debug = true;
			go.x = 120;
			go.y = 80;
			go.width = 150;
			go.setFocus(true);
			
			go.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, function (event: GameObjectEvent): void {
				trace('click');
			});
			var selectMask: Sprite = new Sprite();
			selectMask.graphics.beginFill(0xffffff, 1);
			selectMask.graphics.drawCircle(go.width / 2, go.width/ 2, 50); 
			selectMask.graphics.endFill();
			go.setSelect(true, false, selectMask, new Rectangle(-20,-20,100,100));
			//go.setSelect(false);
			
			var backMask: Sprite = new Sprite();
			backMask.graphics.beginFill(0xffffff, 1);
			backMask.graphics.drawRoundRect(0, 0, go.width, go.height, 20, 20); 
			backMask.graphics.endFill();
			go.bitmapMask = backMask;
			
			var back: Bitmap = new Bitmap(new BitmapData(go.width, go.height, true, 0x50fafff2), PixelSnapping.ALWAYS, true);
			go.bitmap = back;
			var tf: TextField = new TextField();
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			tf.text = 'MainText';
			go.setTextField(tf, View.ALIGN_HOR_CENTER | View.ALIGN_VER_BOTTOM);
			
			var spr: Sprite = new Sprite();
			spr.name = 'Sprite1';
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRoundRect(0, 0, 100, 15, 12);
			spr.graphics.endFill();
			spr.addEventListener(MouseEvent.CLICK, function (event: MouseEvent): void {
				trace('sprite click');
			});
			
			var b: Bitmap = new Bitmap(new BitmapData(50, 50, false, 0x00ff22), PixelSnapping.ALWAYS, true);
			b.name = 'Bitmap1';
			
			//TODO проблема с выравниванием
			go.view.addDisplayObject(b, 'Bitmap1', 1, View.ALIGN_HOR_CENTER | View.ALIGN_VER_CENTER);
			go.view.addDisplayObject(spr, 'Spritik', GameObject.VISUAL_SELECT_MASK_Z_ORDER + 1, View.ALIGN_HOR_CENTER);
			go.view.removeDisplayObject('');
			
			addChild(go);
			
			var go2: GameObject = new GameObject(this);
			go2.x = 300;
			go2.y = 20;
			go2.debug = true;
			go2.setSelect(true);
			go2.setFocus(true);
			addChild(go2);
		}
	}
}

