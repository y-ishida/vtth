/**
 * Vtth - Vala tiny testing helper
 * version:0.1
 *
 * http://
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Yusuke Ishida
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
 */

public abstract class Vtth.AbstractTestCaseBase {
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

	protected abstract void fail();
	protected abstract void abort();

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

	public AbstractTestCaseBase() {
		if(!Test.quiet() && !Test.verbose())
			stdout.putc('\n');
	}

	~AbstractTestCaseBase() {
		if(!Test.quiet()) {
			stdout.printf(attr_bold("[REPORT] OK:%d, NG:%d, Total:%d\n"),
					ok_count, ng_count, ok_count + ng_count);
		}
	}
}

public abstract class Vtth.AbstractTestCase : AbstractTestCaseBase {
	protected override void fail() {
		Test.fail();
	}

	protected override void abort() {
		Process.abort();
	}
}

public abstract class Vtth.AbstractNonStopTestCase : AbstractTestCaseBase {
	protected override void fail() {
	}

	protected override void abort() {
	}
}


