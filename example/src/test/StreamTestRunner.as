package test 
{
import asunit.textui.TestRunner;
public class StreamTestRunner extends TestRunner
{
	public function StreamTestRunner() 
	{
		this.start(AllStreamTestCase, null, TestRunner.SHOW_TRACE);
	}
}
}