# Ember-QUnit Testing With Vim

Quickly run your Ember tests in a browser.

![Screencast](https://raw.githubusercontent.com/hjdivad/hjdivad.github.io/master/screencasts/ember-cli-vim.gif)

It is slow and tedious to go from a test in your editor to running that
test in the browser.  This plugin speeds up the testing process significantly.  

## Usage

When you're set up, you'll be able to run an individual test by:

1. Put your cursor inside a test body
2. Hit `<leader>M`.
3. Switch to Chrome
4. Type `Command + l` to quickly get to the address bar.
4. Paste your clipboard and hit enter.

If you switch apps quickly (via ⌘ - tab or alfred or something), this can be a
pretty quick process.

You can run tests for an entire module with `<leader>m`.

## Installation

1. Create `/usr/local/bin/qunit-test-hash` with content from the below `qunit-test-hash` script.
2. Run `chmod +x /usr/local/bin/qunit-test-hash`.
3. Add `Plug 'plicjo/ember-qunit-testing.vim'` to ~/.vimrc.
4. Run `:PlugInstall`.

### The qunit-test-hash script

```js
#!/usr/bin/env node

var argv = process.argv;

function generateHash( module, testName ) {
	var hex,
		i = 0,
		hash = 0,
		str = module + "\x1C" + testName,
		len = str.length;

	for ( ; i < len; i++ ) {
		hash  = ( ( hash << 5 ) - hash ) + str.charCodeAt( i );
		hash |= 0;
	}

	// Convert the possibly negative integer hash code into an 8 character hex string, which isn't
	// strictly necessary but increases user understanding that the id is a SHA-like hash
	hex = ( 0x100000000 + hash ).toString( 16 );
	if ( hex.length < 8 ) {
		hex = "0000000" + hex;
	}

	return hex.slice( -8 );
}


if (argv.length !== 4) {
  console.error("usage: qunit-test-hash MODULE TEST");
  process.exit(1);
} else {
  console.log(generateHash(argv[2], argv[3]));
}
```

## Credit
This idea was originally concocted by @hjdivad here: https://gist.github.com/hjdivad/ea726b2caac4a8385788
