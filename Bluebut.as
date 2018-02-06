package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class Bluebut extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/BlueBot.png")] protected var ImgQTPi:Class;
		
		
		//Walk Control
		private var WalkTimer:Number			= 0;
		private var PauseTimer:Number			= 0;
		private var Jumping:Boolean				= false;
		
		//state vars
		private var IDLE:uint					= 0;
		private var WALKING_LEFT:uint			= 1;
		private var WALKING_RIGHT:uint			= 2;
		private var FALLING:Boolean				= false;
		private var CurrentState:uint			= 0;
				
		//constructor
		public function Bluebut(X:Number, Y:Number){
			super(X,Y);
			x = X;
			y = Y;
			loadGraphic(ImgQTPi,true,true,16, 16);
			
			height 	= 10;
			width  	= 15;
			
			offset = new FlxPoint(1, 6);
			
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			
			drag.x = 500;
			drag.y = 1000;
			
			//create animations
			addAnimation("Idle",		[0],			5,	false);
			addAnimation("Walkin", 	[0,1,2,3], 			5, 	true);
		}
		
		private function WalkLeft():void{
			//left
			CurrentState = WALKING_LEFT;
			WalkTimer = FlxG.random();
			PauseTimer = 0;		
		}
		
		private function WalkRight():void{
			//left
			CurrentState = WALKING_RIGHT;
			WalkTimer = FlxG.random();
			PauseTimer = 0;		
		}
		
		private function JumpLeft():void{
			Jumping = true;
			acceleration.x 	= 0;
			acceleration.y 	= 0;
			velocity.x		= 0;
			velocity.y 		= -256;
			//Jump Left
			velocity.x = -256;
			play("Walkin");
			CurrentState = WALKING_LEFT;
			WalkTimer		= .25;
			PauseTimer		= .5;
		}
		
		private function JumpRight():void{
			Jumping = true;
			acceleration.x 	= 0;
			acceleration.y 	= 0;
			velocity.x		= 0;
			velocity.y 		= -256;
			//Jump Right
			velocity.x = 256;
			play("Walkin");
			CurrentState = WALKING_RIGHT;
			WalkTimer		= .25;
			PauseTimer		= .5;
		}
		
		public function KillMe():void{
			x = -50;
		}
		
		//update
		public override function update():void{
			if(onScreen()){
				acceleration.x = 0;
				acceleration.y = drag.y;
			
				//do not leave the tilemap
				if(!isTouching(FLOOR) && Jumping == false){
					//FUUUUUUUUUUUUUU
					if(CurrentState == WALKING_LEFT){
						//jump right!
						JumpRight();
					}else if(CurrentState == WALKING_RIGHT){
						//jump left!
						JumpLeft();
					}
				}
				
				if(isTouching(FLOOR)){
					Jumping = false;
				}
			
				//animation
				switch(CurrentState){
					default:
						play("Idle");
						break;
					case WALKING_LEFT:
						play("Walkin");
						break;
					case WALKING_RIGHT:
						play("Walkin");
						break;
				}
			
				//maybe walk
				if(CurrentState == IDLE && PauseTimer <= 0){
					if(FlxG.random() < 0.025){
						//ok. pick a direction
						var Ran:Number = FlxG.random();
						if(Ran < 0.25){
							WalkLeft();
						}else if(Ran < 0.5){
							JumpRight();
						}else if(Ran < .75){
							JumpLeft();
						}else{
							//right
							WalkRight();
						}
					}
				}
			
				if(WalkTimer > 0){
					WalkTimer -= FlxG.elapsed;
					if(CurrentState == WALKING_LEFT){
						//walk left
						acceleration.x = -150;
					}else{
						//walk right
						acceleration.x = 150;
					}
					if(WalkTimer <= 0){
						CurrentState = IDLE;
					}
				}else if(PauseTimer > 0){
					PauseTimer -= FlxG.elapsed;
				}
			
				//Dont fall down: just turn around
				if(velocity.y > 0){
					FALLING = true;
				}
			
			
				super.update();
			}
		}
	}
}
