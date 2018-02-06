package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class WaveBridge extends FlxGroup{
	
		//media
		//graphics
		[Embed(source="Visual/8byblock.png")] protected var ImgBlock:Class;
		
		
		//Jump Control
				
		//constructor
		public function WaveBridge(X:Number = 0, Y:Number = 0, width:uint = 8, Player:QTPi = null){
			//Create the Bridge Pieces
			for(var i:uint = 0; i < width; i++){
				add(new BridgePiece(X+(i*8), Y, Player));
			}
			//Set partners for them
			for(i = 0; i < width; i++){
				members[i].SetPartners(members[i-1], members[i+1]);
			}
			//Finalize the objects
			for(i = 0; i < width; i++){
				members[i].Finalize();
			}	
		}
		
		//update
		public override function update():void{
			super.update();
		}
	}
}
