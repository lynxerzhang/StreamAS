package 
{
import flash.automation.MouseAutomationAction;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import data.structure.Stream;
import flash.net.LocalConnection;
import flash.utils.setTimeout;
import test.StreamTestRunner;

public class Main extends Sprite 
{	
	public function Main():void 
	{
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event = null):void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		// entry point
		
		//simpleUse();
		
		setTimeout(function():void {
			asunitTestStream(); //need asunit framework
		}, 3000);
	}
	
	private function asunitTestStream():void {
		new StreamTestRunner();
	}
	
	private function simpleUse():void {
		var sp:Sprite = new Sprite();
		var mc:MovieClip = new MovieClip();
		var ary:Array = [1, 2, 3];
		
		mainStream = Stream.make(sp, mc, ary);
		mainStream.print(); //output: [object Sprite] [object MovieClip] 1,2,3
		
		trace(mainStream.isEmpty()); //false
		trace(mainStream.head()); //[object Sprite]
		
		var tail:Stream = mainStream.tail();
		trace(tail); 
		//Stream --> head: [object MovieClip], tail: Stream --> head: 1,2,3, tail: Stream --> head: undefined, tail: null
		//最后项head为undefined, tail为null表面该Stream的遍历以达到末端
		
		trace(mainStream.item(1)); //[object MovieClip]
		trace(mainStream.length); //3
		trace(mainStream.isMember(ary));//true
	
		mainStream.drop(1).print(); //[object MovieClip], 1,2,3
		mainStream.take(1).print();//[object Sprite]
		
		mainStream.map(function(data:*):* {
			trace(data);
			return data;
		}).force(); //[object Sprite] [object MovieClip] 1,2,3		
		
		mainStream.filter(function(data:*):Boolean {
			return data is DisplayObject;
		}).print(); //[object Sprite] [object MovieClip
		
		//setTimeout(function():void {
			//mainStream = null; //this will remove all saved object
			//mainStream = mainStream.drop(1); //remove sprite object
		//	gc();
		//}, 5000);
	}
	
	private function gc():void {
		try {
			new LocalConnection().connect("__donotUseInReleaseVersion");
			new LocalConnection().connect("__donotUseInReleaseVersion");
		}
		catch (e:Error) {
			trace("trigger gc");
		}
	}
	
	private var mainStream:Stream;
}	
}