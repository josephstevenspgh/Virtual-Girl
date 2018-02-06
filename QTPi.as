package{

	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class QTPi extends FlxSprite{
	
		//media
		//graphics
		[Embed(source="Visual/QT-Pi.png")] 				private var ImgQTPi:Class;
		[Embed(source="Visual/BoostPack.png")] 			private var ImgBoost:Class;
		[Embed(source="Visual/ChargeOrb.png")] 			private var ImgCharge:Class;
		[Embed(source="Visual/Shots.png")]				private var ImgNormalShot:Class;
		
		//sound
		[Embed(source="Audio/Jump.wav.mp3")]			private var SfxJump:Class;
		
		//Map
		private var TileMap:FlxTilemap;
		
		public var PauseGame:Boolean = false;
		
		//Mother Fuckin Weapon- Aw Yeeee
		private var WeaponType:uint				= 0;
		private var Charge:Number				= 0;
		private var ChargeOrb1:FlxSprite;
		private var ChargeOrb2:FlxSprite;
		private var ChargeOrb3:FlxSprite;
		private var ChargeAngle:Number			= 0;
		private var BulletGroup:FlxGroup;
		private var JustShot:Number				= 0;
		
		//Weapon Types
		private var NORMALSHOT:uint				= 0;

		//orbs
		public var Orb1Got:Boolean				= false;
		public var Orb2Got:Boolean				= false;
		public var Orb3Got:Boolean				= false;
		public var Orb4Got:Boolean				= false;
		
		//Movement and Animation
		private var Acceleration:Number			= 0;
		private var Moving:Boolean				= false;
		private var MovingRight:Boolean			= false;
		
		//Ladders!
		public var isOverLadder:Boolean			= false;
		private var OnLadder:Boolean			= false;
		
		//Jump Control
		private var CanBoost:Boolean			= false;
		private var JumpControl:Number			= 0;
		private var Jumping:Boolean				= false;
		private var CanJump:Boolean				= true;
		private var DoubleJumpReady:Boolean		= false;
		private var BlinkReady:Boolean			= false;
		private var BoostPack:FlxSprite;
		
		//Life!
		private var Life:uint					= 3;
		private var MaxLife:uint				= 3;
		private var DamageTimer:Number			= 0;
		private var HeartContainers:Array;
		
		//Lock character
		public var Unlocked:Boolean			= false;
		
		//special abilities!
		private static var save:FlxSave 		= new FlxSave();
		public var CanDoubleJump:Boolean		= false;
		public var CanBlink:Boolean				= false;
		public var LiquidProof:Boolean			= false;
		
		//constructor
		public function QTPi(X:Number = 0, Y:Number = 0){
			super(X,Y);
			GenerateSprites();
			GenerateBullets();
			loadGraphic(ImgQTPi,true,true,16, 16);
			
			height 	= 16;
			width  	= 6;
			
			offset = new FlxPoint(5, -1);
			
			maxVelocity.x = 200;
			maxVelocity.y = 500;
			
			drag.x = 2000;
			drag.y = 1500;
			
			//Tilemap = TM;
			
			//create animations
			addAnimation("Idle", 	[0], 			5, 	false);
			addAnimation("Walking", [1, 2, 3, 4, 5, 6, 7, 8],	10, 	true);
			addAnimation("Climbing",[9, 10, 11, 12, 13, 12, 11, 10], 10, true);
			addAnimation("Shooting",[14, 15, 16], 30, false);
			
			//check for abilities
			if(save.bind("VirtuaGirl")){
				CanDoubleJump 	= save.data.CanDoubleJump;
				LiquidProof		= save.data.LiquidProof;
				CanBlink		= save.data.CanBlink;
				Orb1Got			= save.data.Orb1;
				Orb2Got			= save.data.Orb2;
				Orb3Got			= save.data.Orb3;
				Orb4Got			= save.data.Orb4;
				HeartContainers = save.data.HeartContainers;
				if(HeartContainers == null){
					HeartContainers = new Array("false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false", "false");
					save.data.HeartContainers = HeartContainers;
					save.flush();
				}
				//Count up total heart containers
				FlxG.log(HeartContainers);
				var HC_Count:uint = 0;
				FlxG.log(HeartContainers.length);
				for(var i:uint = 0; i < HeartContainers.length; i++){
					var TmpString:String = HeartContainers[i];
					if(TmpString == "true"){
						FlxG.log("Found Heart Container: "+i);
						HC_Count++;
					}
				}
				HC_Count = HC_Count/2;
				FlxG.log(HC_Count);
				MaxLife += HC_Count;
			}
			if(LiquidProof){
				FlxG.mouse.show();
			}
		}
		
		private function GenerateSprites():void{
			BoostPack = new FlxSprite();
			BoostPack.loadGraphic(ImgBoost, true, true, 3, 31);
			BoostPack.addAnimation("Boost!", [1, 2, 3, 4, 5, 6, 0], 20, false);
			
			ChargeOrb1 = new FlxSprite(-20, -20);
			ChargeOrb1.loadGraphic(ImgCharge, true, true, 8, 8);
			ChargeOrb1.addAnimation("Orby1", [6, 7, 8], 15, true);
			ChargeOrb1.addAnimation("Orby2", [0, 1, 2], 15, true);
			ChargeOrb1.addAnimation("Orby3", [3, 4, 5], 15, true);
			
			ChargeOrb2 = new FlxSprite(-20, -20);
			ChargeOrb2.loadGraphic(ImgCharge, true, true, 8, 8);
			ChargeOrb2.addAnimation("Orby1", [6, 7, 8], 15, true);
			ChargeOrb2.addAnimation("Orby2", [0, 1, 2], 15, true);
			ChargeOrb2.addAnimation("Orby3", [3, 4, 5], 15, true);
			
			ChargeOrb3 = new FlxSprite(-20, -20);
			ChargeOrb3.loadGraphic(ImgCharge, true, true, 8, 8);
			ChargeOrb3.addAnimation("Orby1", [6, 7, 8], 15, true);
			ChargeOrb3.addAnimation("Orby2", [0, 1, 2], 15, true);
			ChargeOrb3.addAnimation("Orby3", [3, 4, 5], 15, true);
			
			//fancy!
			ChargeOrb1.blend = "hardlight";
			ChargeOrb2.blend = "hardlight";
			ChargeOrb3.blend = "hardlight";
						
		}
		
		private function GenerateBullets():void{
			BulletGroup = new FlxGroup();
			switch(WeaponType){
				case NORMALSHOT:
					for(var i:uint=0; i < 3; i++){
						var Shot:FlxSprite = new FlxSprite(-20, -20);
						Shot.loadGraphic(ImgNormalShot, true, true, 16, 16);
						Shot.kill();
						Shot.blend = "hardlight";
						BulletGroup.add(Shot);
					}
					break;
			}
		}
		
		public function GroupSprites():FlxGroup{
			var FGroup:FlxGroup = new FlxGroup();
			FGroup.add(BoostPack);
			FGroup.add(ChargeOrb1);
			FGroup.add(ChargeOrb2);
			FGroup.add(ChargeOrb3);
			return FGroup;
		}
		
		public function GroupBullets():FlxGroup{
			return BulletGroup;
		}
		
		private function BulletCheck():void{
			for(var i:uint = 0; i < BulletGroup.members.length;i++){
				if(BulletGroup.members[i] != null){
					if(!BulletGroup.members[i].onScreen){
						FlxG.log("Bullet is off screen! Kill it! - key: "+FlxG.elapsed);
						BulletGroup.members[i].kill();
					}
					if(BulletGroup.members[i].isTouching(LEFT) || BulletGroup.members[i].isTouching(RIGHT) || !BulletGroup.members[i].onScreen){
//				if(BulletGroup.members[i].acceleration.x == 0){
					BulletGroup.members[i].kill();
					}
				}
			}
		}
		
		//update
		public override function update():void{
			BulletCheck();
			if(PauseGame){
				acceleration.x = 0;
				acceleration.y = 0;
				super.update();
				return;
			}
			if(DamageTimer < 0){
				if(angle != 0){
					angle = 0;
				}
				acceleration.x = 0;
				if(!OnLadder){
					acceleration.y = drag.y;
				}else{
					acceleration.y = 0;
				}
				if(OnLadder){
				}else if(!Moving){
					frame = 0;
				}
				
				if(Unlocked){
					Movement();
				}else{
					frame = 0;
					angle += 10;
				}
			}else if(!Unlocked){
				frame = 0;
				angle += 10;
			}else{
				frame = 0;
				angle += 10;
				DamageTimer -= FlxG.elapsed;
			}
			if(!Unlocked){
				angle += 10;
			}
			if(JustShot > 0){
				JustShot -= FlxG.elapsed*5;
				if(Moving){
					frame = 15;
				}else{
					frame = 14;
				}
				if(JustShot < 0.5){
					frame = 14;
				}
			}
			super.update();
		}
		
		public function KnockBack(damage:uint):void{
			//Damage player- Knock them back
			if(DamageTimer <= 0){
				Life -= damage;
				if(MovingRight){
					//knock back left
					velocity.x 	= -512;
				}else{
					//knock back right
					velocity.x 	= 512;
				}
				velocity.y	= -128;
				if(Life <= 0){
					GotKilled();
				}
				DamageTimer = damage;
			}
		}
		
		public function AlignBoost():void{
			if(CanDoubleJump){
				if(frame > 0){
					if((frame == 3) || (frame == 4) || (frame == 7) || (frame == 8)){
						if(facing==LEFT){
							BoostPack.x = x+1;
						}else{
							BoostPack.x = x+6;
						}
						BoostPack.y = y+10;					
					}else if((frame == 1) || (frame == 2) || (frame == 5) || (frame == 6)){
						if(facing==LEFT){
							BoostPack.x = x+1;
						}else{
							BoostPack.x = x+6;
						}
						BoostPack.y = y+9;
					}else{
						//just hide it
						BoostPack.y = -100;
					}
				}else{
					BoostPack.y = -100;
				}
				if(OnLadder){
					BoostPack.y = -100;
				}
			}		
		}
		
		private function ShootGun():void{
			var CurBul:FlxSprite = BulletGroup.getFirstDead() as FlxSprite;
			if(CurBul != null){
				CurBul.revive();
				if(Charge >= 3){
					CurBul.frame 	= 2;
					//box size
					CurBul.offset 	= new FlxPoint(3, 4);
					CurBul.width  	= 12;
					CurBul.height 	= 9;				
					CurBul.x		= x + 3;
					CurBul.y		= y + 5;
				}else if(Charge >= 1){
					CurBul.frame 	= 1;
					//box size
					CurBul.offset 	= new FlxPoint(5, 6);
					CurBul.width  	= 7;
					CurBul.height 	= 5;			
					CurBul.x		= x + 5;
					CurBul.y		= y + 7;
				}else{
					CurBul.frame 	= 0;
					//box size
					CurBul.offset 	= new FlxPoint(5, 8);
					CurBul.width  	= 5;
					CurBul.height 	= 2;			
					CurBul.x		= x + 5;
					CurBul.y		= y + 9;
				}
				Charge = 0;
				ChargeOrb1.x = -8;
				ChargeOrb2.x = -8;
				ChargeOrb3.x = -8;
				//fire
				if(facing == LEFT){
					CurBul.velocity.x = 200;
					CurBul.facing = LEFT;
				}else{
					CurBul.velocity.x = -200;				
					CurBul.facing = RIGHT;
				}		
			}
			JustShot = 1;
			if(Moving){
				frame = 15;
			}else{
				frame = 14;
			}
		}
		
		public function getLife():uint{
			return Life;
		}
		
		public function getMaxLife():uint{
			return MaxLife;
		}
		
		private function Movement():void{
			if(FlxG.keys.UP || FlxG.keys.DOWN){
				if(isOverLadder){
					//Align X to tile
					x = (Math.round(x/16) * 16) + 3;
					OnLadder = true;
				}
			}
			if(OnLadder){
				//Can move up/down on a ladder
				if(FlxG.keys.UP){
					if(isOverLadder){
						velocity.y = -100;
					}else{
						velocity.y = -250;
						OnLadder = false;
					}
				}else if(FlxG.keys.DOWN){
					if(isOverLadder){
						velocity.y = 100;
					}
				}else if(FlxG.keys.X){
					OnLadder = false;
				}
			}
			//Weapons 'n shit yo
			if(FlxG.keys.C){
				//charge
				ChargeOrb1.x = (x+4) + (Math.cos(ChargeAngle) * 16);
				ChargeOrb1.y = (y+4) + (Math.sin(ChargeAngle) * 16);
				if(Charge < 3 && Charge >= 1){
					ChargeOrb2.x = (x+4) + (Math.cos(ChargeAngle+3.12) * 16);
					ChargeOrb2.y = (y+4) + (Math.sin(ChargeAngle+3.12) * 16);
				}else if(Charge >= 3){
					ChargeOrb2.x = (x+4) + (Math.cos(ChargeAngle+2.1) * 16);
					ChargeOrb2.y = (y+4) + (Math.sin(ChargeAngle+2.1) * 16);
					ChargeOrb3.x = (x+4) + (Math.cos(ChargeAngle+4.2) * 16);
					ChargeOrb3.y = (y+4) + (Math.sin(ChargeAngle+4.2) * 16);
				}				
				
				Charge += FlxG.elapsed;
				ChargeAngle += .1;
//				if(ChargeAngle > 360){ ChargeAngle = 0; }
				if(Charge > 3){Charge = 3;}
				if(Charge < 1){ 
					ChargeOrb1.play("Orby1");
					ChargeOrb2.play("Orby1");
					ChargeOrb3.play("Orby1");
				}else if(Charge < 3){
					ChargeOrb1.play("Orby2");
					ChargeOrb2.play("Orby2");
					ChargeOrb3.play("Orby2");
				}else{
					ChargeOrb1.play("Orby3");
					ChargeOrb2.play("Orby3");
					ChargeOrb3.play("Orby3");
				}
			}
			if((FlxG.keys.justReleased("C") && Charge >= 1) || FlxG.keys.justPressed("C")){
				ShootGun();
			}else if(FlxG.keys.justReleased("C")){
				//clear artifacts
				Charge = 0;
				ChargeOrb1.x = -8;
				ChargeOrb2.x = -8;
				ChargeOrb3.x = -8;
			}
			
			//Allow Control
			if((FlxG.keys.LEFT) && (FlxG.keys.RIGHT)){
				//Do nothing at all :D
				Moving = false;
			}else if(FlxG.keys.LEFT){
				x -= 2;
//				x -= 1 + Acceleration;
				facing = RIGHT;
				BoostPack.facing = RIGHT;
				play("Walking");
				Moving = true;
				MovingRight	= false;
				if(!FlxG.keys.UP){
					OnLadder = false;
				}
			}else if(FlxG.keys.RIGHT){
				x += 2;
//				x += 1 + Acceleration;
				facing = LEFT;
				BoostPack.facing = LEFT;
				play("Walking");
				Moving = true;
				MovingRight	= true;
				if(!FlxG.keys.UP){
					OnLadder = false;
				}
			}else{
				Moving = false;
			}
			
			if(Moving){
				if(Acceleration < 2){
					Acceleration += .15;
				}else{
					Acceleration = 2;
				}
			}else{
				Acceleration = 0;
			}
			
			Jump();
			
			//Jumping Stuff
			//dont do it if on ladder
			if(!OnLadder){
				if(velocity.y < 0){
					if(!MovingRight){
						frame = 1;
					}else{
						frame = 5;
					}
				}else if(velocity.y > 0){
					if(!MovingRight){
						frame = 4;
					}else{
						frame = 8;
					}
				}
			}else{
				if(FlxG.keys.UP || FlxG.keys.DOWN){
					play("Climbing");
				}else{
					frame = frame;
				}			
			}
			
			if(isTouching(FLOOR)){
				CanJump = true;
				Jumping = false;
				JumpControl = 0;
				CanBoost = true;
			}else{
				CanJump	= false;
			}		
		}
		
		public function OHGODNOPLEASEDONT():void{
				CanDoubleJump 	= save.data.CanDoubleJump	= false;
				LiquidProof		= save.data.LiquidProof		= false;
				CanBlink		= save.data.CanBlink		= false;
				Orb1Got			= save.data.Orb1			= false;
				Orb2Got			= save.data.Orb2			= false;
				Orb3Got			= save.data.Orb3			= false;
				Orb4Got			= save.data.Orb4			= false;
				save.flush();
		}
		
		public function GiveItem(TreasureID:uint):void{
			if(TreasureID <= 100){
				//Heart Container
				GiveHeartContainer(TreasureID);
			}else if (TreasureID == 101){
				//Double Jump
				UnlockDoubleJump();		
			}else if (TreasureID == 102){
				//Liquid Proofing
				UnlockLiquidProofing();
			}else if (TreasureID == 103){
				//Blink -- Maybe change this?
				UnlockBlink();
			}else if (TreasureID == 201){
				//CATS
			}else if (TreasureID == 301){
				//Keys
			}
		}
		
		public function GiveHeartContainer(TreasureID:uint):void{
			HeartContainers[TreasureID] = true;
			save.data.HeartContainers = HeartContainers;
			save.flush();
		}
		
		public function UnlockDoubleJump():void{
			save.data.CanDoubleJump = true;
			CanDoubleJump = true;
			save.flush();
		}
		
		public function UnlockLiquidProofing():void{
			save.data.LiquidProof = true;
			LiquidProof = true;
			save.flush();
		}
		
		public function UnlockBlink():void{
			save.data.CanBlink = true;
			CanBlink = true;
			save.flush();
		}
		
		public function UnlockOrb(orbnum:uint):void{
			switch(orbnum){
				case 1:
					save.data.Orb1	= true;
					Orb1Got			= true;
					break;
				case 2:
					save.data.Orb2	= true;
					Orb2Got			= true;
					break;
				case 3:
					save.data.Orb3	= true;
					Orb3Got			= true;
					break;
				case 4:
					save.data.Orb4	= true;
					Orb4Got			= true;
					break;
			}
			save.flush();
		}
		
		public function Lock():void{
			Unlocked = false;
		}
		
		public function Unlock():void{
			Unlocked = true;
		}
		public function onGround():Boolean{
			return isTouching(FLOOR);
		}
		
		public function GotKilled():void{
			Lock();
		}
	
		public function KillMe():void{
			GotKilled();
		}
		
		private function Jump():void{			
			if((JumpControl >= 0) && (FlxG.keys.X)){
				JumpControl += FlxG.elapsed;
				if(JumpControl > 0.25){
					//Jumping Limit
					JumpControl = -1;
				}
			}else{
				JumpControl = -1;
			}
			
			if(JumpControl > 0){
				if(JumpControl < 0.05){
					velocity.y = -250;
				}else if(JumpControl < 0.1){
					velocity.y = -200;
				}else if(JumpControl < 0.175){
					velocity.y = -150;
				}else{
					acceleration.y = 25;
				}
			}
			if(velocity.y > 0 && CanBoost){
				if(FlxG.keys.justPressed("X")){
					velocity.y = -500;
					BoostPack.play("Boost!");
					CanBoost = false;
				}
			}
		}
	}
}
