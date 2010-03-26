package {
	import com.efnx.events.MultiLoaderEvent;
	import com.efnx.net.MultiLoader;
	import com.facecontrol.api.Api;
	import com.facecontrol.api.ApiEvent;
	import com.flashmedia.basics.GameObject;
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.ComboBox;
	import com.flashmedia.gui.GridBox;
	import com.flashmedia.gui.GridBoxEvent;
	import com.flashmedia.gui.Label;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.MessageBox;
	import com.flashmedia.gui.Pagination;
	
	import flash.events.Event;
	import flash.text.TextField;

	public class Facecontrol extends GameScene {
		private var textField: TextField = new TextField();
		private var p:Pagination;
		private var linkButton:LinkButton;
		private var cb: ComboBox;
		private static var _multiLoader: MultiLoader;
		
		public function Facecontrol() {
			_multiLoader = new MultiLoader();
			testComponents();
			/*
			linkButton = new LinkButton(this, "My link button", 0, 0, 50);
			addChild(linkButton);
			linkButton.wordWrap = true;
			linkButton.label = "This is my first label";
			
			p = new Pagination(this, 100, 0, 10, 1);
			addChild(p);
			
			p.addEventListener(Event.CHANGE, changeListener);
			
//			var ldr:Loader = new Loader();
////			ldr.mask = rect;
//			var url:String = "02.png";
//			var urlReq:URLRequest = new URLRequest(url);
//			ldr.load(urlReq);
//			var bitmap:Bitmap = Bitmap(ldr.content);

			var myBitmapDataObject:BitmapData = new BitmapData(150, 150, false, 0x80FF3300); 
			var bitmap:Bitmap = new Bitmap(myBitmapDataObject); 
//			addChild(bitmap);
			
			var b:Button = new Button(this, 50, 50);
			b.setTitleForState("Button", Button.STATE_NORMAL);
			addChild(b);
			b.setBackgroundImageForState(bitmap, Button.STATE_NORMAL);
			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClicked);
			*/
		}
		
		private function testComponents(): void {
			//multiLoader.load("http://cs1256.vkontakte.ru/u7776141/17008570/x_b07e69c3.jpg", "Photo1", "Bitmap");
			_multiLoader.load("c:\\choose_button.png", "dropIcon", "Bitmap");
			_multiLoader.addEventListener(MultiLoaderEvent.PROGRESS, function (event: MultiLoaderEvent): void {
			
			});
			_multiLoader.addEventListener(MultiLoaderEvent.COMPLETE, function (event: MultiLoaderEvent): void {
				cb.dropIcon = _multiLoader.get("dropIcon");
			});
			
			cb = new ComboBox(this);
			cb.x = 400;
			cb.y = 400;
			cb.height = 15;
			cb.addItem('Item1');
			cb.addItem('Item2');
			cb.addItem('Item3');
			cb.addItem('Item4');
			cb.addItem('Item5');
			addChild(cb);
			
			var label: Label = new Label(this, 'TestLabel');
			label.x = 300;
			label.y = 200;
			//label.debug = true;
			label.fillBackground(0xffffff, 1.0);
			label.selectable = true;
			label.canHover = true;
			label.canFocus = true;
			addChild(label);
			
			var gb: GridBox = new GridBox(this, 4);
			gb.addEventListener(GridBoxEvent.TYPE_ITEM_SELECTED, function (event: GridBoxEvent) : void {
				trace((event.item as String) + ' ' + event.columnIndex + ' ' + event.rowIndex);
			});
			gb.x = 50;
			gb.y = 10;
			gb.width = 400;
			gb.height = 300;
			gb.widthPolicy = GridBox.WIDTH_POLICY_STRETCH_BY_WIDTH;
			gb.heightPolicy = GridBox.HEIGHT_POLICY_STRETCH_BY_HEIGHT;
//			gb.columnWidthPolicy = GridBox.COLUMN_WIDTH_POLICY_ALL_SAME;
//			gb.rowHeightPolicy = GridBox.ROW_HEIGHT_POLICY_ALL_SAME;
			gb.horizontalItemsAlign = GameObject.HORIZONTAL_ALIGN_LEFT;
			gb.verticalItemsAlign = GameObject.VERTICAL_ALIGN_CENTER;
			gb.fillBackground(0xffffff, 1.0);
			gb.indentBetweenItems = 0;
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
			addChild(gb);
		}
		
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
//			linkButton.label = "change";
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
	}
}
