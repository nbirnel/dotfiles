hints.addMode('C', "Generate curl command for a form", function(elem) {
    if (elem.form)
        var { url, postData, elements } = DOM(elem).formData;
    else
        var url = elem.getAttribute("href");

    if (!url || /^javascript:/.test(url))
        return;

    url = services.io.newURI(url, null, util.newURI(elem.ownerDocument.URL)).spec;

    let escape = util.closure.shellEscape;

    dactyl.clipboardWrite(["curl"].concat(
        [].concat(
            [["--form-string", escape(datum)] for ([n, datum] in Iterator(elements || []))],
            postData != null && !elements.length ? [["-d", escape("")]] : [],
            [["-H", escape("Cookie: " + elem.ownerDocument.cookie)],
             ["-A", escape(navigator.userAgent)],
             [escape(url)]]
        ).map(function(e) e.join(" ")).join(" \\\n\t")).join(" "), true);
});

/* vim:se sts=4 sw=4 et: */
