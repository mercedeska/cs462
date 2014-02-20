ruleset WebRuleExersices
 {
    meta {
        name "notify example"
        author "Mercedes Kurtz"
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule show_form {
        select when pageview ".*"
        // Display notification that will not fade.
        pre {
            main_paragraph = <<
            <div id="main">
                Look at my awesome website that I am making! Woo :)
            </div> >>;

        }
        {
            //notify("Hello World", q.length()) with sticky = true;
            replace_html("#lab_3", main_paragraph);
        }
    }
}