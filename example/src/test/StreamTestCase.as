package test 
{
import asunit.framework.Test;
import asunit.framework.TestCase;
import data.structure.Stream;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Shader;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;

public class StreamTestCase extends TestCase
{
	public function StreamTestCase(testMethodName:String) 
	{
		super(testMethodName);
	}
	
	private var _mainStream:Stream;
	private var sp:Sprite = new Sprite();
	private var mc:MovieClip = new MovieClip();
	private var shp:Shape = new Shape();
	private var sbtn:SimpleButton = new SimpleButton();
	private var st:TextField = new TextField();
	
	protected override function setUp():void {
		_mainStream = Stream.make(sp, mc, shp, sbtn, st);
	}
	
	protected override function tearDown():void {
		_mainStream = null;
	}
	
	public function testCheckStreamLength():void {
		var len:int = _mainStream.length;
		assertEquals("Expected: 5, Received: " + len, 5, len);
	}
	
	public function testHeadisSprite():void {
		var head:Sprite = _mainStream.head() as Sprite;
		assertTrue("the first head data type is Sprite", head is Sprite);
	}
	
	public function testSecondDataIsMovieClip():void {
		assertTrue("the second data is MovieClip", _mainStream.isMember(mc) == true);
	}
	
	public function testContainDisplayContainer():void {
		var c:Stream = _mainStream.filter(function(data:*):Boolean {
			return data is DisplayObjectContainer;
		});
		c.walk(function(data:*):void {
			assertTrue("this Stream 's contain's type is DisplayObjectContainer", data is DisplayObjectContainer);
		});
	}
	
	public function testRemoveAllData():void {
		var c:Stream = _mainStream.drop(_mainStream.length);
		assertTrue("this stream's length is zero", c.length == 0);
	}
	
}

}