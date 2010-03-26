package {
	import com.flashmedia.basics.GameObjectEvent;
	import com.flashmedia.basics.GameScene;
	import com.flashmedia.gui.Button;
	import com.flashmedia.gui.LinkButton;
	import com.flashmedia.gui.MessageBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	public class Facecontrol extends GameScene {
		private var textField: TextField = new TextField();
//		private var p:Pagination;
		private var linkButton:LinkButton;
		
		public function Facecontrol() {
//			p = new Pagination(this, 100, 0, 10, 1);
//			addChild(p);
//			p.addEventListener(Event.CHANGE, changeListener);
			
			var myBitmapDataObject:BitmapData = new BitmapData(50, 20, false, 0x80FF3300); 
			var bitmap:Bitmap = new Bitmap(myBitmapDataObject); 
			
			var loader:URLLoader = new URLLoader();
//			var loader:Loader = new Loader();
			configureListeners(loader);
			var request:URLRequest = new URLRequest("02.png");
			try {
                loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
			
			var b:Button = new Button(this, 50, 20);
			b.setTitleForState("Button", Button.STATE_NORMAL);
			addChild(b);
			b.setBackgroundImageForState(bitmap, Button.STATE_NORMAL);
			b.addEventListener(GameObjectEvent.TYPE_MOUSE_CLICK, onButtonClicked);
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			trace("completeHandler: " + loader.data);
//			var image:Bitmap = Bitmap(event.target.content);
//			addChild(image);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("ioErrorHandler: " + event);
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
		/*
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
	}
}
