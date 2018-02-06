package{
	import org.flixel.*;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

 
	public class RGBMap extends VGMap{
		
		//Maps
		[Embed(source="Data/RGBMapmap001.txm",		mimeType="application/octet-stream")] protected var RedMap_Data:Class;
		
		override protected function initGame():void{
			Stage = 4;
			//Musics
			FlxG.playMusic(IntroMusic);
		
			//Group Initialization
			BackgroundGroup	= new FlxGroup();
			TileGroup 		= new FlxGroup();
			PlayerGroup 	= new FlxGroup();
			EnemyGroup		= new FlxGroup();
			ItemGroup		= new FlxGroup();
			ObjectGroup		= new FlxGroup();
			
			//Load Map
			RedTileMap	= new FlxTilemap();
			RedTileMap.loadMap(new RedMap_Data, RedMap_Tiles, 16, 16, 0, 0, 1, 5);
			
			FlxG.worldBounds = RedTileMap.getBounds();
			
			//Create Player
			Player = new QTPi(24, 24);
			Player.Unlock();
			
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
					BackgroundGroup.add(a);
				}
			}
			
			//Add Groups
			TileGroup.add(RedTileMap);
			PlayerGroup.add(Player);
			ItemGroup.add(new OrbOfGoal(1423-8, 31));
			ItemGroup.members[0].frame = 3;
			ItemGroup.add(new OrbOfGoal(-50, -50));
			
			//Enemies
			EnemyGroup.add(new Frog(512, 128));
			EnemyGroup.add(new Frog(416, 560));
			EnemyGroup.add(new Frog(720, 256));
			EnemyGroup.add(new Frog(1376, 448));
			EnemyGroup.add(new Frog(1376, 32));
			EnemyGroup.add(new RedRobot(304, 336));
			EnemyGroup.add(new RedRobot(96, 432));
			EnemyGroup.add(new RedRobot(112, 608));
			EnemyGroup.add(new RedRobot(464, 672));
			EnemyGroup.add(new RedRobot(848, 608));
			EnemyGroup.add(new RedRobot(1280, 640));
			EnemyGroup.add(new RedRobot(1136, 160));
			EnemyGroup.add(new Bluebut(640, 256));
			EnemyGroup.add(new Bluebut(48, 144));
			EnemyGroup.add(new Bluebut(896, 112));
			EnemyGroup.add(new Bluebut(480, 336));
			EnemyGroup.add(new Bluebut(512, 608));
			EnemyGroup.add(new Bluebut(624, 512));
			EnemyGroup.add(new Bluebut(1392, 592));
			EnemyGroup.add(new Bluebut(1424, 144));
			
			
			//Object Group - all objects need to be on this
			ObjectGroup.add(EnemyGroup);
			ObjectGroup.add(PlayerGroup);
			
			add(BackgroundGroup);
			add(TileGroup);
			add(ItemGroup);
			add(EnemyGroup);
			add(PlayerGroup);
			
			//Camera
//			FlxG.camera = new FlxCamera(0, 0, 640, 480);
			FlxG.camera.follow(Player, FlxCamera.STYLE_PLATFORMER);
			FlxG.camera.bounds = RedTileMap.getBounds();
			ShowIcons();
		}
	}
}
