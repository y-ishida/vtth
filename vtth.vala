/**
 * Vtth - Vala tiny testing helper
 *
 * ver.0.1
 *
 * = Introduction =
 *
 * vtth is tiny testing helper for vala.
 *
 * In vala, you can use GLib.Test as testing framework
 * even if you add no extra library.
 * But GLib.Test is too simple to enjoy the testing!
 * The output has no color, just put 'OK' or abort the program, it is really boring.
 * So, I improved it a little bit.
 * It means that vtth can absolutely use on GLib.Test,
 * namely it is not new testing framework.
 *
 * vtth can the follows:
 *
 *  - Outputs coloring OK or NG at each assertion.
 *  - Select abort or continue the program when assertion failed.
 *  - Outputs total checked assertion count each test case.
 *  - Packs methods and parameters which related a test case, as one class.
 *
 *
 * = How to use =
 *
 * The following sample codes which used in this description are available
 * as a git repository at:
 *
 *
 * == Writing the test case ==
 *
 * {{{
 *
 * }}}
 *
 * Each test case is inherited from AbstractUnitTest
 * and test code is written in it.
 *
 *
 * == Adding the test case into the testing framework ==
 *
 * Test case is added by GLib.Test.add_func, that is ordinary way.
 * The add_func's argument which should be passed a delegate for testing
 * is just doing that new instance of the test case class.
 *
 *
 * == Compiling and running the test ==
 *
 * vtth is not library (package), so copy this file into your project
 * and compile with your code to use.
 *
 *
 * = License and copyright =
 *
 * vtth is licensed as follows:
 *
 * The MIT License (MIT)
 *
 * Copyright (c) Yusuke Ishida
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

public abstract class Vtth.AbstractTestCase {
	private int ok_count;
	private int ng_count;

	private virtual bool abort_assertion_failed {
		get { return true; }
	}

	private virtual bool fail_assertion_failed {
		get { return true; }
	}

	[CCode(cheader_filename = "unistd.h", cname = "isatty")]
	private static extern bool isatty(int fd);

	private bool is_redirected {
		get {
			return !isatty(stdout.fileno());
		}
	}

	private string attr_bold_green(string str) {
		if(is_redirected)
			return str;
		else
			return "\033[32;1m" + str + "\033[0m";
	}

	private string attr_bold_red(string str) {
		if(is_redirected)
			return str;
		else
			return "\033[31;1m" + str + "\033[0m";
	}

	private string attr_bold(string str) {
		if(is_redirected)
			return str;
		else
			return "\033[1m" + str + "\033[0m";
	}

	private virtual void fail() {
		Test.fail();
	}

	private virtual void abort() {
		Process.abort();
	}

	[Diagnostics]
	[PrintFormat]
	protected void assert(bool expr, string format = "", ...) {
		if(!Test.quiet()) {
			if(format == "")
				format = "(non message assertion)";

			stdout.vprintf(format, va_list());

			if(expr)
				stdout.puts(attr_bold_green(" OK"));
			else
				stdout.puts(attr_bold_red(" NG"));

			stdout.putc('\n');
		}

		if(!expr) {
			ng_count++;
			fail();
			abort();
		} else
			ok_count++;
	}

	[Diagnostics]
	[PrintFormat]
	protected void message(string format, ...) {
		if(!Test.quiet()) {
			stdout.vprintf(format, va_list());
			stdout.putc('\n');
		}
	}

	public AbstractTestCase() {
		if(!Test.quiet() && !Test.verbose())
			stdout.putc('\n');
	}

	~AbstractTestCase() {
		if(!Test.quiet()) {
			stdout.printf(attr_bold("[REPORT] OK:%d, NG:%d, Total:%d\n"),
					ok_count, ng_count, ok_count + ng_count);
		}
	}
}

public abstract class AbstractNonStopTestCase {
	private virtual void fail() {
	}

	private virtual void abort() {
	}
}


