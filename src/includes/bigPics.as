// ActionScript file
import com.adobe.webapis.flickr.*;
import com.adobe.webapis.flickr.events.*;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.core.Application;
import mx.managers.PopUpManager;

		[Bindable] private var photos:ArrayCollection;
		[Bindable] private var photoUrl:String;
		[Bindable] private var photoFlickrUrl:String;
		[Bindable] public var selectedPhotoNum:Number;
		[Bindable] public var selectedPhoto:String;
		[Bindable] public var photo:Photo;
		private var action:Boolean = false;
		private var coords:Array;		
		public var flickr:FlickrService;


		public function init():void
		{
			img.visible = false;
			img.addEventListener(MouseEvent.MOUSE_WHEEL, mouseScrollZoom);
			img.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			img.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			img.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			this.width = stage.width;
			this.height = stage.height;
			getPhotoSize();
		}
		
		public function mouseScrollZoom(event:MouseEvent):void {
			var step:Number;
			if(event.delta>0) {
				step = 0.05;
			}
			else {
				step = -0.05 ;
			}
			Zoom(step);
		}
		
		//zoom in or zoom out
		public function zoomIsReversed(zoomDelta:Number, step:Number):Boolean {
			if ((zoomDelta<0 && step>0) || (zoomDelta>0 && step<0)) {
				return true;
			}
			return false;
		}

 	    public function Zoom(step:Number):void {
			zoom.target = daPic;
			        
			var reverseZoom:Number;
			var reversed:Boolean = false;
			var zoomDelta:Number;
			zoomDelta = zoom.zoomWidthTo - zoom.zoomWidthFrom;
			reversed = zoomIsReversed(zoomDelta, step);
			if(reversed) {
				//if zoomout reverse zoom from and zoom to
				reverseZoom = zoom.zoomWidthFrom;
				zoom.zoomWidthFrom = zoom.zoomWidthTo ;
				zoom.zoomWidthTo = reverseZoom ;

				reverseZoom = zoom.zoomHeightFrom;
				zoom.zoomHeightFrom = zoom.zoomHeightTo ;
				zoom.zoomHeightTo = reverseZoom;
			}
			//check zoom min and max boundaries
			if ((zoom.zoomWidthFrom>=1.4 && step>0) || (zoom.zoomWidthFrom<0.5 && step<0)) {
				step=0;
			}
			else {
				//increase by step
				zoom.zoomWidthFrom = zoom.zoomWidthFrom+step;
				zoom.zoomHeightFrom = zoom.zoomHeightFrom+step;
				zoom.zoomWidthTo = zoom.zoomWidthTo+step;
				zoom.zoomHeightTo = zoom.zoomHeightTo+step;
				
				zoom.play();        
			}

        }

		public function mouseDown(event:MouseEvent):void {
	  		action = true;
	  		picContainer.alpha=0.5;
	  		coords = [event.stageX, event.stageY];
	  	}

	  	public function mouseUp(event:MouseEvent):void {
	  		action = false;
	  		picContainer.alpha=1;
	  	}

	  	public function mouseMove(event:MouseEvent):void {
	  		if(action) {
		  		var To:Array = [event.stageX, event.stageY];
		  		var newX:Number = To[0] - coords[0];
		  		var newY:Number = To[1] - coords[1];

			    myMove.end();
		        myMove.xTo = picContainer.x + newX; 
		        myMove.yTo = picContainer.y + newY;
		        myMove.play();
		        coords = To;
		   }
	  	}

        private function removeMe():void {
            PopUpManager.removePopUp(this);
        }
        
        private function getPhotoSize():void {
        	info.text = Application.application.photos[selectedPhotoNum].title
        	preload.visible = true;
			img.visible = false;
		    var service:FlickrService = new FlickrService( Application.application.api_key );
		   	service.addEventListener( FlickrResultEvent.PHOTOS_GET_SIZES, onPhotoSizeSearch );
		   	service.photos.getSizes( Application.application.photos[selectedPhotoNum].id );
		}

		private function onPhotoSizeSearch( event:FlickrResultEvent ):void {
		    var photoSize:PhotoSize = event.data["photoSizes"] as PhotoSize;
		    imgTitle.text = Application.application.photos[selectedPhotoNum].title
		    var result:Array = event.data.photoSize;
			photoUrl = event.data["photoSizes"][(event.data["photoSizes"].length-2)].source;
		} 
		
		public function changePic(operation:String):void {
			if(operation == "next"){
				if(selectedPhotoNum < Application.application.photos.length-1){
					selectedPhotoNum++; 
				}
				else {
					selectedPhotoNum = 0; 
				}
			}
			else {
				if(selectedPhotoNum > 0){
					selectedPhotoNum--; 
				}
				else{
					selectedPhotoNum = Application.application.photos.length-1; 
				}
			}
			getPhotoSize();
		}