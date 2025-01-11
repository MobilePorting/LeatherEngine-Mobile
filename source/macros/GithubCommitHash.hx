package macros;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.Process;

/**
 * Macro class for getting the current git commit hash.
 * @see https://code.haxe.org/category/macros/add-git-commit-hash-in-build.html
 */
class GithubCommitHash {
	public static macro function getGitCommitHash():ExprOf<String> {
		#if !display
		var process:Process = new Process('git', ['rev-parse', 'HEAD']);
		if (process.exitCode() != 0) {
			var message:String = process.stderr.readAll().toString();
			var pos:Position = Context.currentPos();
			Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
		}

		// read the output of the process
		var commitHash:String = process.stdout.readLine();

		// Generates a string expression
		return macro $v{commitHash};
		#else
		// `#if display` is used for code completion. In this case returning an
		// empty string is good enough; We don't want to call git on every hint.
		var commitHash:String = "";
		return macro $v{commitHash};
		#end
	}
}
