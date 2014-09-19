CKEDITOR.plugins.add( 'comment', {
    icons: 'comment',
    init: function( editor ) {

        editor.addCommand( 'insertComment', {  // Adds command to CKEDITOR instance
            exec: function( editor ) {
                var currentInProgress = $('#annotation-in-progress');

                if (currentInProgress.length > 0) {
                    $(currentInProgress).replaceWith(currentInProgress.contents());
                }

                // TODO -> check that something is already selected, or show a popup.
                //if (selectedText.length < 1) {
                //    alert('Comments require a selected text area. <br />'
                //        + 'Please select text to comment on, then hit the Comment button.');
                //    return;
                //}

                // Grabs selected text
                function getSelectionHtml(editor) {
                    var sel = editor.getSelection();
                    var bookmarks = sel.createBookmarks(); // creates bookmarks
                    var ranges = sel.getRanges();
                    var el = new CKEDITOR.dom.element("div");
                    for (var i = 0, len = ranges.length; i < len; ++i) {
                        el.append(ranges[i].cloneContents());
                    }
                    editor.getSelection().selectBookmarks( bookmarks ); // Safely replaces selected content 
                    return el.getHtml();
                }

                //// This Breaks addcomment if called above function definition
                // includes HTML within the selection, e.g. <span> tags
                var selectedText = getSelectionHtml(editor);   

                // Enforce non-overlapping tags.
                if (selectedText.indexOf("span") >= 0) {
                    alert('Sorry, but comments cannot overlap.'
                         +'Please select nearby text to add another comment.');
                    return;
                } else {
                    // This applies a style to the current selection.
                    var style = new CKEDITOR.style({attributes: {class: "annotation", id: "annotation-in-progress"}});
                    editor.applyStyle(style);
                }
            }
        });

        // Define a button associated with the above command
        // This creates a button named 'Comment' with 3 properties
        editor.ui.addButton( 'Comment', {
            label: 'Insert Comment',
            command: 'insertComment'
            // toolbar: 'insert'           // This is a toolbar group the button is inserted into
        });
    }
});