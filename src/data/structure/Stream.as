package data.structure
{
/*
*  @see Stream.js (http://streamjs.org/)
*  
*  虽然在Streamjs.org中介绍的都是将Stream作为存储并操作数值的一种数据结构,好比
*  as3中的Vector.<int>, Vector.<uint>, Vector.<Number>这种叫做Vector类型的数
*  据结构, 实际上有Stream中的一些方法可以存储任何as3中的对象类型。
*  
*  Stream的结构类似于另一个开源的事件管理的框架Signal, 其中管理signal节点的不是
*  数组而是一个类似于单链表的结构, 每个节点自身维护一个next属性指向可能存在的
*  signal节点, 而Stream指向的是一个function对象, 根据是否stream为空来判读是否执
*  行这个function方法从而获取下一个stream对象。
*/
public class Stream
{
	private var _head:*;
	private var _tailPromise:Function;
	private static const _empty:Stream = new Stream(null, null);
	
	/**
	 * 
	 * @param	head          希望存储的任何数据类型对象
	 * @param	tailPromise   function对象, 通过是否执行该对象来获取下一个stream对象, 
	 *                        从而像单链表那样存储数据
	 */
	public function Stream(head:* = null, tailPromise:Function = null):void {
		if (head != null) {
			this._head = head;
		}
		if (tailPromise == null) {
			if (head != null) {
				tailPromise = function():Stream {
					//return new Stream();
					return _empty;
				}
			}
		}
		this._tailPromise = tailPromise;
	}
	
	/**
	 * 判定该Stream对象是否为空
	 * @return
	 */
	public function isEmpty():Boolean {
		return this._head == null;
	}
	
	/**
	 * 获取该Stream中存储的数据对象
	 * @return
	 */
	public function head():*{
		return this._head;
	}
	
	/**
	 * 判断是否已到达Stream的末端
	 * @return
	 */
	public function tail():Stream {
		if (isEmpty()) {
			return null;
		}
		return this._tailPromise();
	}
	
	/**
	 * 获取指定index位置存储的数据对象，类似于访问数组的对象使用数值访问符[]
	 * @param	index
	 * @return
	 */
	public function item(index:uint):*{
		if (this.isEmpty()) {
			return null;
		}
		var n:int = index;
		var s:Stream = this;
		while (index-- > 0 && s) {
			s = s.tail();
		}
		if (s.isEmpty()) {
			return null;
		}
		return s.head();
	}
	
	/**
	 * 获取当前Stream的长度
	 */
	public function get length():int {
		var len:int = 0;
		if (this.isEmpty()) {
			return len;
		}
		var s:Stream = this;
		while (s && !s.isEmpty()) {
			s = s.tail();
			len ++;
		}
		return len;
	}
	
	/**
	 * 指定的data对象是否存在于当前的Stream中
	 * @param	data
	 * @return
	 */
	public function isMember(data:*):Boolean {
		if (this.isEmpty()) {
			return false;
		}
		var s:Stream = this;
		while (!s.isEmpty() && s) {
			if (s.head() == data) {
				return true;
			}
			s = s.tail();
		}
		return false;
	}
	
	/**
	 * 期望扔掉的当前存储的Stream对象的位数, 类似数组方法splice
	 * @param	count
	 * @return
	 */
	public function drop(count:uint):Stream {
		if (this.isEmpty()) {
			return new Stream();
		}
		var s:Stream = this;
		while (count-- > 0 && s) {
			s = s.tail();
		}
		if (!s || s.isEmpty()) {
			return new Stream();
		}
		return new Stream(s.head(), s._tailPromise);
	}
	
	/**
	 * 获取指定存储位数的Stream对象, 指定位数之外的则排除掉
	 * @param	count
	 * @return
	 */
	public function take(count:uint):Stream {
		if (this.isEmpty()) {
			return this;
		}
		if (count == 0) {
			return new Stream();
		}
		var s:Stream = this;
		return new Stream(s._head, function():Stream {
			return s.tail().take(count - 1);
		});
	}
	
	/**
	 * 对当前的Stream对象映射指定方法，具体对内部数据的操作可写在
	 * 传入的function对象中
	 * @param	func
	 * @return
	 */
	public function map(func:Function):Stream {
		if (this.isEmpty()) {
			return this;
		}
		var st:Stream = this;
		return new Stream(func(st.head()), function():Stream {	
			return st.tail().map(func);
		});
	}
	
	/**
	 * 将当前Stream对象中所存储的数据依次放大指定的参数倍数
	 * (该方法只能使用与保存的对象为数值对象)
	 * @param	factor
	 * @return
	 */
	public function scale(factor:uint):Stream {
		return this.map(function(data:*):* {
			return data * factor;
		});
	}
	
	/**
	 * 遍历当前的Stream对象
	 */
	public function force():void {
		var s:Stream = this;
		while (!s.isEmpty()) {
			s = s.tail();
		}
	}
	
	/**
	 * 将当前的Stream对象执行指定的操作后遍历，具体操作在传入的function对象中,
	 * 存储的对象并不改变
	 * @param	func
	 * @see print method
	 */
	public function walk(func:Function):void {
		return this.map(function(data:*):*{
			func(data);
			return data;
		}).force();
	}
	
	/**
	 * 根据传入的方法来对当前Stream对象所存储的数据执行过滤
	 * @param	func
	 * @return
	 */
	public function filter(func:Function):Stream {
		if (this.isEmpty()) {
			return this;
		}
		var s:* = this.head();
		var tail:Stream = this.tail();
		if (func(s)) {
			return new Stream(s, function():Stream {
				return tail.filter(func);
			});
		}
		return tail.filter(func);
	}
	
	/**
	 * @see filter
	 * @param	func
	 * @return
	 */
	public function filterNot(func:Function):Stream {
		if (this.isEmpty()) {
			return this;
		}
		var s:* = this.head();
		var tail:Stream = this.tail();
		if (!func(s)) {
			return new Stream(s, function():Stream {
				return tail.filterNot(func);
			});
		}
		return tail.filterNot(func);
	}
	
	
	
	/**
	 * 打印当前Stream对象中存储的指定项的位数
	 * @param	count
	 */
	public function print(count:int = -1):void {
		var s:Stream = count == -1 ? this : this.take(count);
		s.walk(function(data:*):void {
			trace(data);
		});
	}
	
	/**
	 * 根据指定的参数other和func来生成新的Stream对象，具体逻辑的执行是在传入
	 * 的func中
	 * @param	func
	 * @param	other
	 * @see     add
	 * @return
	 */
	public function zip(func:Function, other:Stream):Stream {
		if (this.isEmpty()) {
			return other;
		}
		if (other.isEmpty()) {
			return this;
		}
		var s:Stream = this;
		return new Stream(func(s.head(), other.head()), function():Stream {
			return s.tail().zip(func, other.tail());
		})
	}
	
	/**
	 * 将当前的Stream对象和指定的Stream合并(只针对2者当前存储的对象为数值对象)
	 * @param	other
	 * @return
	 */
	public function add(other:Stream):Stream {
		return this.zip(function(dataA:*, dataB:*):* {
			return dataA + dataB;
		}, other);
	}
	
	/**
	 * 
	 * @param	aggregator
	 * @param	initValue
	 * @see sum
	 * @return
	 */
	public function reduce(aggregator:Function, initValue:*):* {
		if (this.isEmpty()) {
			return initValue;
		}
		return this.tail().reduce(aggregator, aggregator(this.head(), initValue));
	}
	
	/**
	 * @see reduce
	 * @return
	 */
	public function sum():*{
		return reduce(function(dataA:*, dataB:*):* {
			return dataA + dataB;
		}, 0);
	}
	
	/**
	 * 该方法的执行需要注意Stream是通过递归进行遍历的,所以执行该方法的
	 * Stream对象不能无限执行,必须要有终止节点
	 * 
	 * @return
	 * @see tail
	 */
	public function toString():String {
		return "Stream --> " + "head: " + this.head() + ", tail: " + this.tail();
	}
	
	/**
	 * 生成存储任意数据类型，任意数量的Stream对象
	 * @param	...args
	 * @return
	 */
	public static function make(...args):Stream {
		if (args.length == 0) {
			return new Stream();
		}
		var head:* = args[0];
		if (args.length == 1) {
			return new Stream(head);
		}
		var other:Array = args.slice(1);
		return new Stream(head, function():Stream {
			return make.apply(null, other);
		});
	}
	
	/**
	 * 仅仅返回类似（1,1,1,..)的Stream对象
	 * @return
	 */
	public static function makeOnes():Stream {
		return new Stream(1, makeOnes);
	}
	
	/**
	 * 返回指定区间的Stream对象, 该Stream中可保存的只能为数值对象
	 * 
	 * @param	lower
	 * @param	hightest
	 * @return
	 */
	public static function range(lower:uint, hightest:uint):Stream {
		if (lower == hightest) {
			return new Stream(lower);
		}
		if (lower > hightest) {
			return new Stream(lower, function():Stream {
				return range(lower - 1, hightest);
			});
		}
		else {
			return new Stream(lower, function():Stream {
				return range(lower + 1, hightest);
			});
		}
	}
	
	/**
	 * 生成包含自然数的Stream对象 （e.g 1,2,3,4,5...), 为可"无限"执行
	 * 的Stream对象, 不能调用上述的toString()方法
	 * @return
	 */
	public static function makeNaturalNumbers():Stream {
		return new Stream(1, function():Stream {
			return makeNaturalNumbers().add(makeOnes());
		});
	}
	
	/**
	 * 将该stream中所保存的元素放入数组
	 * @return
	 */
	public function toArray():Array {
		var k:Array = [];
		this.walk(function(item:*):void {
			k.push(item);
		});
		return k;
	}
	
}
}