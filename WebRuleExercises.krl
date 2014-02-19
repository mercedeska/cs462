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
            q = q_html.query("div#main");

        }
        {
            notify("Hello World", q.length()) with sticky = true;
        }
    }
}