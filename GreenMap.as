package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

 
	public class GreenMap extends VGMap{
		[Embed(source="Data/GreenMapmap001.txm",		mimeType="application/octet-stream")] protected var RedMap_Data:Class;
		
		override protected function initGame():void{
			Stage = 2;
			//Musics
			FlxG.playMusic(IntroMusic);
		
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			TileGroup 		= new FlxGroup();
			PlayerGroup 	= new FlxGroup();
			EnemyGroup		= new FlxGroup();
			ItemGroup		= new FlxGroup();
			ObjectGroup		= new FlxGroup();
			LifeGroup		= new FlxGroup();
			
			//Load Map
			LevelTileMap	= new FlxTilemap();
			LevelTileMap.loadMap(new RedMap_Data, RedMap_Tiles, 16, 16, 0, 0, 1, 5);
			
			FlxG.worldBounds = LevelTileMap.getBounds();
			
			//Create Player
			Player = new QTPi(24, 24);
			Player.Unlock();
			PlayerMaxLife = Player.getMaxLife();
			
			//create background
			for(var i:uint = 0; i < (320/16); i++){
				for (var j:uint = 0; j < (240/16); j++){
					var ax:uint	= i*16;
					var ay:uint	= j*16;
					var a:FlxSprite = new FlxSprite(ax, ay);
					a.loadGraphic(ImgRedBG, true, true, 16, 16);
					a.addAnimation("Loopme", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 10, true);
					a.play("Loopme");
					a.scrollFactor = new FlxPoint(0, 0);
					a.blend = "screen";
					BackgroundGroup.add(a);
				}
			}
			for(i = 0; i < (320/16); i++){
				for (j = 0; j < (240/16); j++){
					var bx:uint	= i*16;
					var by:uint	= j*16;
					var b:FlxSprite = new FlxSprite(bx, by);
					b.loadGraphic(ImgRedBG, true, true, 16, 16);
					b.addAnimation("Loopme2", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 5, true);
					b.play("Loopme2");
					b.blend = "screen";
					b.scrollFactor = new FlxPoint(0, 0);
					BackgroundGroup.add(b);
				}
			}
			
			//Add Groups
			TileGroup.add(LevelTileMap);
			PlayerGroup.add(Player);
			ItemGroup.add(new OrbOfGoal(424, 48));
			ItemGroup.add(new Blink(96, 720));
			
			EnemyGroup.add(new Frog(128, 64));
			EnemyGroup.add(new Frog(288, 48));
			EnemyGroup.add(new Frog(352, 32));
			EnemyGroup.add(new Frog(96, 192));
			EnemyGroup.add(new Frog(336, 272));
			EnemyGroup.add(new Frog(192, 288));
			EnemyGroup.add(new Frog(96, 400));
			EnemyGroup.add(new Frog(400, 464));
			EnemyGroup.add(new Frog(576, 416));
			EnemyGroup.add(new Frog(224, 688));
			EnemyGroup.add(new Frog(352, 688));
			EnemyGroup.add(new Frog(480, 688));
			EnemyGroup.add(new Frog(608, 688));
			EnemyGroup.add(new Frog(736, 688));
			EnemyGroup.add(new Frog(704, 608));
			EnemyGroup.add(new Frog(672, 384));
			EnemyGroup.add(new Frog(576, 320));
			EnemyGroup.add(new Frog(720, 144));
			EnemyGroup.add(new Frog(672, 48));
			ItemGroup.members[0].frame = 1;
			
			//Life Display
			for(var asdf:uint = 0; asdf < PlayerMaxLife; asdf++){
				var LifeSprite:FlxSprite = new FlxSprite();
				LifeSprite.loadGraphic(ImgLife, true, true, 8, 8);
				LifeSprite.x	= 9 * (asdf+1);
				LifeSprite.y	= 8;
				LifeSprite.scrollFactor = new FlxPoint(0, 0);
				LifeGroup.add(LifeSprite);
			}
			
			//Object Group - all objects need to be on this
			ObjectGroup.add(EnemyGroup);
			ObjectGroup.add(PlayerGroup);
			
			add(BackgroundGroup);
			add(TileGroup);
			add(ItemGroup);
			add(EnemyGroup);
			add(PlayerGroup);
			add(LifeGroup);
			
			//Camera
//			FlxG.camera = new FlxCamera(0, 0, 640, 480);
			FlxG.camera.follow(Player, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.bounds = LevelTileMap.getBounds();
			ShowIcons();
		}
	}
}
