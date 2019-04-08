package com.skplanet.sascm.util;

public class ClassUtil {

	private static final boolean flag;

	static {
		flag = true;
	}

	///////////////////////////////////////////////////////////////////////////

	public static String getClassInfo() {
		final StackTraceElement e = Thread.currentThread().getStackTrace()[2];

		StringBuffer sb = new StringBuffer();

		if (flag) sb.append(e.getClassName()).append('.').append(e.getMethodName()).append("()");
		if (flag) sb.append(" - ");
		if (flag) sb.append(e.getFileName()).append('(').append(e.getLineNumber()).append(')');

		return sb.toString();
	}

	public static String getClassName() {
		final StackTraceElement e = Thread.currentThread().getStackTrace()[2];

		StringBuffer sb = new StringBuffer();
		if (flag) sb.append("class: ").append(e.getClassName());
		return sb.toString();
	}

	public static String getMethodName() {
		final StackTraceElement e = Thread.currentThread().getStackTrace()[2];

		StringBuffer sb = new StringBuffer();

		if (flag) sb.append("method: ").append(e.getMethodName()).append("()");

		return sb.toString();
	}

	public static String getFileName() {
		final StackTraceElement e = Thread.currentThread().getStackTrace()[2];

		StringBuffer sb = new StringBuffer();
		if (flag) sb.append("file: ").append(e.getFileName());
		return sb.toString();
	}

	public static String getLineNumber() {
		final StackTraceElement e = Thread.currentThread().getStackTrace()[2];

		StringBuffer sb = new StringBuffer();
		if (flag) sb.append("lineNo: ").append(e.getLineNumber());
		return sb.toString();
	}
	
	public static String getFileLine() {
		final StackTraceElement e = Thread.currentThread().getStackTrace()[2];

		return String.format("%s(%d)", e.getFileName(), e.getLineNumber());
	}

	///////////////////////////////////////////////////////////////////////////
}
