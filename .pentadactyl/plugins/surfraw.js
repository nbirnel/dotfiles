
"use strict";

XML.ignoreWhitespace = false;
XML.prettyPrinting   = false;

var INFO =
    <plugin name="surfraw" version="0.1"
            href="http://dactyl.sourceforge.net/pentadactyl/"
            summary="Open a URI constructed by surfraw."
            xmlns={NS}>
        <author email="smblott@gmail.com">Stephen Blott</author>
        <license href="http://opensource.org/licenses/mit-license.php">MIT</license>
        <project name="Pentadactyl" min-version="1.0"/>
        <p>
            The unix utility <o>surfraw</o> "... provides a fast unix command line interface to a
            variety of popular WWW search engines and other artifacts of
            power".  It includes an integrated, text-based bookmark facility with keyword lookup.
        </p>
        <p>
            This plugin makes surfraw callable from the Firefox/Pentadactyl
            command line.
        </p>
        <item>
            <tags>:sr :surfraw</tags>
            <spec>:surfraw <a>surfraw-arguments</a> </spec>
            <description>
                <p>
                    Pass <a>surfraw-arguments</a> to <o>surfraw -print</o> and
                    open the resulting URI.  If surfraw fails to suggest a URI, then instead
                    just pass <a>surfraw-arguments</a> to the built-in <ex>:open</ex> command.
                </p>
            <example><ex>:surfraw wikipedia firefox</ex><k name="CR"/>
            </example>
            <p>
             Look up <ex>firefox</ex> on Wikipedia, <ex>wikipedia</ex> being
             one of standard surfraw elvi (of which there are many; try
             <o>surfraw -elvi</o> to see a list of those available on your
             system).
            </p>
            <example><ex>:surfraw surfraw-bookmark</ex><k name="CR"/>
            </example>
            <p>
             Open a surfraw bookmark with keyword <a>surfraw-bookmark</a>.
            </p>
            <example><ex>:surfraw some search terms</ex><k name="CR"/>
            </example>
            <p>
             In general, surfraw will not know what to do with <ex>some search
             terms</ex>, so they are passed to <ex>:open</ex> (which in turn
             will likely pass them on to your favourite search engine).
            </p>
            <example><ex>map o :surfraw</ex><k name="CR"/>
            </example>
            <p>
             Use <ex>:surfraw</ex> instead of <ex>:open</ex> (after all, it'll
                     just call <ex>:open</ex> if it can't figure out what to
                     do anyway).
            </p>
            </description>
        </item>
        <item>
            <tags>:tsr :tsurfraw</tags>
            <spec>:tsurfraw <a>surfraw-arguments</a> </spec>
            <description>
                <p>
                    As above, except that the URI is opened in a new tab (or
                    <a>surfraw-arguments</a> are passed to the built-in
                    <ex>:tabopen</ex> command).
                </p>
            </description>
        </item>
    </plugin>;

/* *******************************************************************************
 * first, some code borrowed from elsewhere ...
 */

    // parseUri 1.2.2
    // (c) Steven Levithan <stevenlevithan.com>
    // MIT License

    function parseUri (str) {
            var     o   = parseUri.options,
                    m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
                    uri = {},
                    i   = 14;

            while (i--) uri[o.key[i]] = m[i] || "";

            uri[o.q.name] = {};
            uri[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
                    if ($1) uri[o.q.name][$1] = $2;
            });

            return uri;
    };

    parseUri.options = {
            strictMode: false,
            key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
            q:   {
                    name:   "queryKey",
                    parser: /(?:^|&)([^&=]*)=?([^&]*)/g
            },
            parser: {
                    strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
                    loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
            }
    };

/*
 * ... end of code borrowed from elsewhere
 * *******************************************************************************/

title = [       "ELVI",              "DESCRIPTION" ];
keys  = { text: "elvi", description: "desc"        };

brck  = /\s+--\s+/;                                                         // pattern matching separator in elvi list
elvi  = io.system("surfraw -elvi").split("\n");                             // get list of elvi and descriptions
elvi  = elvi.filter( function(line) { return line.match(brck) != null; } ); // keep only those that actually look like elvi/descriptions
elvi  = elvi.map   ( function(line) {                                       // parse each line, building associative array
                        parse = line.split(brck);
                        return { elvi: parse[0], desc: parse[1] }; } );
elvi = elvi.filter( function (e) { return e["elvi"] != 'W'; } );            // filter out the "Activiate Browser" elvi (W)
    
elvi_completer = 
    function (context)
    {
        context.title       = title;
        context.keys        = keys;
        count               = context.value.split(/\s+/).length;
        context.completions = count < 3 ? elvi : [];
        return context;
    };

surfraw =
    function ( where, args )
    {
        if ( ! isArray(args) )
            args = args.split(/\s+/);

        orig = args.join(" ");
        args.unshift("surfraw", "-print");

        result = io.system(args).split("\n");

        /* good; that was easy
         *
         * unfortunately, two things now conspire against use:
         *
         *   1. surfraw outputs error messages not to stderr as it should,
         *   but to stdout instead; so we need a way to tell the difference
         *   between an error message and valid output
         *
         *   2. pentadactyl's io.system() interface does not expose the exit code
         *   of the command, so that can't help us tell these cases apart
         *
         *  the following is a hack:
         *
         *      assume surfraw is successful only if it produces exactly one
         *      line of output
         *
         *      also, try to parse that line as a URI; if we can parse it, then
         *      it probably is a URI; otherwise, it probably isn't
         *
         *  a further problem:
         *
         *      if surfraw is not installed, then we get exactly one line of
         *      output with a message such as:
         *
         *          surfraw: command not found
         *
         *      (yes, even that shows up on standard output)
         *
         *  yuck; this is a mess
         *
         */

        if ( result.length != 1 )
            // surfraw definitely did not find a URI; bail out ...
            return dactyl.open(orig, { where: where } );

        result = result[0];
        uri    = parseUri(result);

        if ( uri.host )
            // it looks like surfraw did find a URI; open it ...
            return dactyl.open(result, { where: where } );

        // surfraw probably did not find a URI after all; bail out ...
        return dactyl.open(orig, { where: where } );
    };

commands.addUserCommand(
    [ "surfraw", "sr"],                                             // command names
    "Open a URI suggested by surfraw.",                             // description
    function (args) { return surfraw(dactyl.CURRENT_TAB, args); },  // the function (operation, command, whatever ...)
    { argCount: "+", completer: elvi_completer, },                  // extra stuff
    true                                                            // replace current implementation
    );

commands.addUserCommand(
    [ "tsurfraw", "tsr"],                                           // command names
    "Open a URI suggested by surfraw (in a new tab).",              // description
    function (args) { return surfraw(dactyl.NEW_TAB, args); },      // the function (operation, command, whatever ...)
    { argCount: "+", completer: elvi_completer, },                  // extra stuff
    true                                                            // replace current implementation
    );

/* vim:se sts=4 sw=4 et: */

