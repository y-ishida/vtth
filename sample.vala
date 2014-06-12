
using Vtth;

class SampleTestCase1 : AbstractTestCase {
	private void sub_test() {
		assert(true, "this is sub test");
	}

	public SampleTestCase1() {
		assert(true);
		assert(true, "vtth can print comment!");
		assert(true, "UTF-8なので日本語も大丈夫");

		uint x = 1 << 15;
		assert(x == 32768, "2 ^ 15 = %u", x);

		sub_test();
	}
}

class SampleTestCase2 : AbstractTestCase, INotAbort, INotFail {
	public SampleTestCase2() {
		assert(true);
		assert(false);
		assert(true);
		assert(false);
	}
}

static int main(string[] args) {
	Test.init(ref args);

	Test.add_func("/case1", () => { new SampleTestCase1(); });
	Test.add_func("/case2", () => { new SampleTestCase2(); });
	Test.add_func("/case3", () => { assert(true); });

	return Test.run();
}

