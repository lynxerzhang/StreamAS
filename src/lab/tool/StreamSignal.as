package lab.tool 
{
import data.structure.Stream;
import lab.utils.StreamUtil;

/**
 * 利用Stream数据结构创建Signal通信框架
 */
public class StreamSignal 
{
	private var signalStream:Stream;
	private var iteraPointer:Stream;
	private var count:int = 0;
	
	public function StreamSignal():void {
		iteraPointer = signalStream = StreamUtil.makeTypeStream(SlotNode);
	}

	/**
	 * add a new slot to the stream
	 * @param	fun
	 */
	public function addSlot(fun:Function):void {
		if (hasSlot(fun)) {
			return;
		}
		iteraPointer.head().node = fun;
		iteraPointer = iteraPointer.tail();
		count++;
	}
	
	/**
	 * dispatch args to all observer
	 * @param	...args
	 */
	public function dispatch(...args):void {
		if (count == 0) {
			return;
		}
		var s:Stream = signalStream.take(count);
		s.walk(function(slot:SlotNode):void {
			slot.node.apply(null, args);
		});
	}
	
	/**
	 * TODO
	 * get specfied slot's index
	 * @param	fun
	 * @return
	 */
	public function getSlotIndex(fun:Function):int {
		if (count == 0) {
			return -1;
		}
		var s:Stream = signalStream.take(count);
		return StreamUtil.indexComplexOf(s, "node", fun);
	}
	
	/**
	 * get slots num
	 * @return
	 */
	public function slotsNum():int {
		return count;
	}
	
	/**
	 * has specfied slot
	 * @param	fun
	 * @return
	 */
	public function hasSlot(fun:Function):Boolean {
		if (count == 0) {
			return false;
		}
		return getSlotIndex(fun) != -1;
	}
	
	/**
	 * remove specifed slot, if success, the slot nums minus one
	 * @param	fun
	 */
	public function removeSlot(fun:Function):void {
		if (hasSlot(fun)) {
			signalStream = signalStream.filterNot(function(slot:SlotNode):Boolean {
				return slot.node == fun;
			});
			count--;
		}
	}
	
	/**
	 * remove all slot
	 */
	public function removeAllSlot():void {
		count = 0;
		iteraPointer = signalStream = StreamUtil.makeTypeStream(SlotNode);
	}
}
}