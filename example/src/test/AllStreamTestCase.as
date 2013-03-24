package test 
{
import asunit.framework.TestSuite;
import asunit.framework.TestCase;
public class AllStreamTestCase extends TestSuite
{
	public function AllStreamTestCase() 
	{
		super();
		addTest(new StreamTestCase("testCheckStreamLength"));
		addTest(new StreamTestCase("testHeadisSprite"));
		addTest(new StreamTestCase("testSecondDataIsMovieClip"));
		addTest(new StreamTestCase("testContainDisplayContainer"));
		addTest(new StreamTestCase("testRemoveAllData"));
		//...
	}
}
}