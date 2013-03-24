package lab.utils 
{ 
import data.structure.Stream;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

public class StreamUtil 
{
	/**
	 * 获取Stream中指定的对象的存储索引
	 * @param	stream
	 * @param	item
	 * @return
	 */
	public static function indexOf(stream:Stream, item:*):int {
		if (stream.isEmpty()) {
			return -1;
		}
		var s:Stream = stream;
		var index:int = 0;
		while (s && !s.isEmpty()) {
			if (s.head() == item) {
				return index;
			}
			s = s.tail();
			index++;
		}
		return -1;
	}
	
	/**
	 * @see indexOf
	 * @param	stream
	 * @param	propName
	 * @param	obj
	 * @return
	 */
	public static function indexComplexOf(stream:Stream, propName:String, obj:*):int {
		if (stream.isEmpty()) {
			return -1;
		}
		var s:Stream = stream;
		var index:int = 0;
		while (s && !s.isEmpty()) {
			if (s.head()[propName] == obj) {
				return index;
			}
			s = s.tail();
			index++;
		}
		return -1;
	}
	
	/**
	 * 创建存储制定类型的Stream
	 * @param	type
	 * @return
	 */
	public static function makeTypeStream(type:Class):Stream {
		var c:Class = type;
		return new Stream(new c() , function():Stream {
			var f:Function = arguments.callee;
			if (f["s"]) {
				return f["s"];
			}
			return f["s"] = makeTypeStream(c);			
		});
	}
	
	/**
	 * 将存储指定类型的Stream对象转换为Vector实例
	 * @param	stream
	 * @return
	 */
	public static function toVector(stream:Stream):*{
		if (stream.isEmpty()) {
			return null;
		}
		var d:* = stream.head();
		var clsStr:String = getQualifiedClassName(d);
		var v:* = getDefinitionByName("__AS3__.vec::Vector." + "<" + clsStr + ">") as Class;
		var content:* = new v();
		stream.walk(function(item:*):void {
			content.push(item);
		});
		return content;
	}
	
}
	
}