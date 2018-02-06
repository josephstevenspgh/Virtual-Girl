package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class PunchCard extends FlxSprite{
	
		//graphics
		[Embed(source="Visual/PunchCardBG.png")] 			private var ImgPunchCard:Class;
		[Embed(source="Visual/PunchCardIcons.png")] 		private var ImgPunchCardIcons:Class;
		
		//sound
//		[Embed(source="Audio/Jump.wav.mp3")]			private var SfxJump:Class;
		
		//Pause
		private var Paused:Boolean = true;
		private var PID:uint;
		
		//constructor
		public function PunchCard(PunchCardID:uint = 0){
			super(X,Y);
			PID = PunchCardID;
			loadGraphic(ImgLittleJoe,true,true,48, 80);
			var NewHeight:uint = FindHeight();
			makeGraphic(5*16, NewHeight*16);
			x = FlxG.width/2 - width/2;
			y = FlxG.height - height - 8;
		}
		
		private function FindHeight():void{
			switch(PID){
				default:
					return 20;
			}
		}
		
		
		//update
		public override function update():void{
			if(ActionTimer > 0){
				ActionTimer -= FlxG.elapsed;
				if(ActionTimer <= 0){
					play("Idle");
				}
			}else{
				PlayerControls();
			}
			super.update();
		}
		
		private function PlayerControls():void{
		
			//Punching
			if(FlxG.keys.justPressed("Z")){
				if(FlxG.keys.UP){
					//Left Hook
					FlxG.log("Left Hook");
					play("LeftHook");
					ActionTimer = .5;
				}else{
					//Left Jab
					FlxG.log("Left Jab");
					play("LeftPunch");
					ActionTimer = .5;
				}
			}else if(FlxG.keys.justPressed("X")){
				if(FlxG.keys.UP){
					//Right Hook
					FlxG.log("Right Hook");
					play("RightHook");
					ActionTimer = .5;
				}else{
					//Right Jab
					FlxG.log("Right Jab");
					play("RightPunch");
					ActionTimer = .5;
				}
			}
			
			//Dodging
			if(FlxG.keys.justPressed("LEFT")){
				//Duck Left
				FlxG.log("Duck Left");
			}else if(FlxG.keys.justPressed("RIGHT")){
				//Duck Right
				FlxG.log("Duck Right");
			}else if(FlxG.keys.justPressed("DOWN")){
				//Block
				FlxG.log("Block");
			}
		}
	}
}
