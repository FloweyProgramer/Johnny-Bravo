package;

import hscript.Checker.CAbstract;
#if sys
import smTools.SMFile;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;

#if desktop
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];
	var curWacky2:Array<String> = [];
	var curWacky3:Array<String> = [];
	var curWacky4:Array<String> = [];
	var curWacky5:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{
		

		// #if polymod
		// polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		// #end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			
		}
		
		#if !cpp

		FlxG.save.bind('JohnnyBravo', 'Flowerbear');

		PlayerSettings.init();

		KadeEngineData.initSave();
		
		#end


				
		Highscore.load();


		curWacky = FlxG.random.getObject(getIntroTextShit());
		curWacky2 = FlxG.random.getObject(getIntroTextShit());
		curWacky3 = FlxG.random.getObject(getIntroTextShit());
		curWacky4 = FlxG.random.getObject(getIntroTextShit());
		curWacky5 = FlxG.random.getObject(getIntroTextShit());

		

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		
		#end

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		clean();
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		clean();
		#else
		#if !cpp
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#else
		startIntro();
		#end
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(75, 143, 204));
		// bg.antialiasing = FlxG.save.data.antialiasing;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		
		
		logoBl = new FlxSprite(-150, -150);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		
		logoBl.antialiasing = FlxG.save.data.antialiasing;
		logoBl.animation.addByPrefix('bump', 'bumping idle', 24, false);
		logoBl.updateHitbox();
		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.14);
		gfDance.y -= 250;
		gfDance.frames = Paths.getSparrowAtlas('theMonkey');
		gfDance.animation.addByPrefix('idle', 'jb idle');
		gfDance.antialiasing = FlxG.save.data.antialiasing;
		gfDance.setGraphicSize(Std.int(gfDance.width * 0.7));
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = FlxG.save.data.antialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = FlxG.save.data.antialiasing;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(75, 143, 204));
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = FlxG.save.data.antialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else {
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			Conductor.changeBPM(130);
			initialized = true;
		}

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('data/introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			MainMenuState.firstStart = true;
			MainMenuState.finishedFunnyMove = false;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// Get current version of Kade Engine
				
				var http = new haxe.Http("untill i make a proper updatelog lmao");
				var returnedData:Array<String> = [];
				
				http.onData = function (data:String)
				{
					returnedData[0] = data.substring(0, data.indexOf(';'));
					returnedData[1] = data.substring(data.indexOf('-'), data.length);
				  	if (!MainMenuState.kadeEngineVer.contains(returnedData[0].trim()) && !OutdatedSubState.leftState)
					{
						
						OutdatedSubState.needVer = returnedData[0];
						OutdatedSubState.currChanges = returnedData[1];
						FlxG.switchState(new OutdatedSubState());
						clean();
					}
					else
					{
						FlxG.switchState(new MainMenuState());
						clean();
					}
				}
				
				http.onError = function (error) {
				  
				  FlxG.switchState(new MainMenuState()); // fail but we go anyway
				  clean();
				}
				
				http.request();
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?beatorder:Bool=false)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
			if (beatorder)
				var timer = new FlxTimer().start(Conductor.crochet, function(tmr:FlxTimer)
				{
					
				});
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();
		if (curBeat % 2 == 0)
			logoBl.animation.play('bump', true);
		
		danceLeft = !danceLeft;

		gfDance.animation.play('idle');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 0:
				deleteCoolText();
			case 1:
				createCoolText(['ItsYeshalot', 'ASpacedOutFlower', 'Flowerbear', 'Karma', 'Pot', 'ToK']);
			// credTextShit.visible = true;
			case 3:
				deleteCoolText();
				createCoolText(['JackyBob', 'Curiosity Man', 'Dreigh', 'Thevious', 'Sirj455', 'LadyJadeShade']);
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				addMoreText('With special thanks to');
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 6:
				deleteCoolText();
				addMoreText('Ticket winners');
				
				// createCoolText(['Newgrounds logo', 'because']);
			case 7:
				deleteCoolText();
				createCoolText(['Ticket winners', 'phlox', 'sugarratio', 'artcarrot', 'samthesly']);
				// addMoreText('im lazy');
				// ngSpr.visible = true;
				
			// crdTextShit.text += '\nNewgrounds';
			case 9:
				deleteCoolText();
				createCoolText(['Ticket winners', 'Rebecca', 'Celeste', 'kolsan', 'Clowfoe']);
				// ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			// case 9:
			// 	createCoolText([curWacky[0]]);
			case 11:
				deleteCoolText();
				createCoolText(['Ticket Winners', 'Cyrix']);
			// credTextShit.visible = true;
			// case 11:
			// 	addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 13:
				deleteCoolText();
				createCoolText(['Tricky Mod Developers', 'Banbuds', 'Rozebud', 'Cval', 'YingYang48']);
			case 15:
				deleteCoolText();
				createCoolText(['Tricky Mod Developers', 'JADS', 'Moro', 'Thanks for letting us', 'use the clown']);
			case 17:
				deleteCoolText();
				createCoolText(['Minus mod', 'IagoAnims', 'AshGray', 'pyroblujay', 'ness', 'DevilHare']);
			case 19:
				deleteCoolText();
				createCoolText(['Minus mod', 'Smokey', 'bbpanzu', 'rozebud', 'cval', 'hayasgpt', 'ArtemiyKopych']);
			case 21:
				deleteCoolText();
				addMoreText(curWacky[0]);
			case 23:
				addMoreText(curWacky[1]);
			case 25:
				deleteCoolText();
				addMoreText(curWacky2[0]);
			case 27:
				addMoreText(curWacky2[1]);
			case 29:
				deleteCoolText();
				addMoreText(curWacky3[0]);
			case 31:
				addMoreText(curWacky3[1]);
			case 33:
				deleteCoolText();
				addMoreText(curWacky4[0]);
			case 35:
				addMoreText(curWacky4[1]);
			case 37:
				deleteCoolText();
				addMoreText(curWacky5[0]);
			case 39:
				addMoreText(curWacky5[1]);
			case 41:
				deleteCoolText();
				addMoreText('totally secret screen');
			case 43:
				addMoreText('very cool');
			case 45:
				deleteCoolText();
				addMoreText('the devs are');
				addMoreText('happy to present');
			case 47:
				addMoreText('The mod months');
				addMoreText('in the making');
			case 49:
				deleteCoolText();
				addMoreText('The Friday night funkin mod');
			case 51:
				deleteCoolText();
				addMoreText('Vs');
			case 53:
				addMoreText('Johnny');
			case 54:
				addMoreText('Bravo');
			
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			// case 13:
			// 	addMoreText('FNF');
			// // credTextShit.visible = true;
			// case 14:
			// 	addMoreText('Johnny');
			// // credTextShit.text += '\nNight';
			// case 15:
			// 	addMoreText('Bravo'); // credTextShit.text += '\nFunkin';

		

			case 60:
				deleteCoolText();
				addMoreText('Wanna do the');
			case 61:
				addMoreText('monkey with me?');
			case 63:
				addMoreText('Come on');
			case 64:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);

			FlxTween.tween(logoBl,{y: -100}, 1.4, {ease: FlxEase.expoInOut});

			logoBl.angle = -4;

			new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					if(logoBl.angle == -4) 
						FlxTween.angle(logoBl, logoBl.angle, 4, 4, {ease: FlxEase.quartInOut});
					if (logoBl.angle == 4) 
						FlxTween.angle(logoBl, logoBl.angle, -4, 4, {ease: FlxEase.quartInOut});
				}, 0);

			skippedIntro = true;
		}
	}
}
