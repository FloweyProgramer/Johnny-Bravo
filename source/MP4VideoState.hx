package;

import haxe.xml.Fast;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class MP4VideoState extends FlxState {
	var target:FlxState;
	var vid:String;
	public function new(vid:String = 'final', target:FlxState = null) {
		this.vid = vid;
		
		if (target == null)
			target = new TitleState();
		this.target = target;
		
		super();
	}

	override public function create():Void {

		var video:MP4Handler = new MP4Handler();
		video.playMP4(Paths.video(vid));
		video.finishCallback = function() {
			LoadingState.loadAndSwitchState(target);
		}

		super.create();
		
	}
	
}
