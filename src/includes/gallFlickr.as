// ActionScript file
import com.adobe.webapis.flickr.*;
import com.adobe.webapis.flickr.events.*;
	
	public var flickr:FlickrService;
	public var api_key:String = "e8abcd29180875248965d62c92c95631";
	public var maxResult:Number = 50;
	public var service:FlickrService = new FlickrService( api_key );
	
	Security.allowDomain(["api.flickr.com", "flickr.com", "*"]);
	Security.allowInsecureDomain(["api.flickr.com", "flickr.com", "*"]);

	import mx.collections.ArrayCollection;
	[Bindable] public var photos:ArrayCollection;
				
	private function getImages():void {
	    var service:FlickrService = new FlickrService( api_key );
	    service.addEventListener( FlickrResultEvent.PHOTOS_SEARCH, onPhotosSearch );
	    service.photos.search(userSearch.text, tagSearch.text, "any", textSearch.text, null, null, null, null, -1, "", maxResult,1 );
	}
	
	private function onPhotosSearch( event:FlickrResultEvent ):void {
	    var photoList:PagedPhotoList = event.data.photos;
	    photoList.perPage = maxResult;
	    photos = new ArrayCollection( photoList.photos ); 
	}
	
	//enlarge photo
	import mx.managers.PopUpManager;
	import mx.containers.TitleWindow;
	import bigPic;
	import mx.events.FlexMouseEvent;
	import mx.core.Application;
	
	public var fullWindow:bigPic;
	
	public function showBigPic(id:String):void {
	    fullWindow = bigPic(PopUpManager.createPopUp(this, bigPic, true));
	    fullWindow.selectedPhoto = id;
	    fullWindow.selectedPhotoNum = picsList.selectedIndex;
	}