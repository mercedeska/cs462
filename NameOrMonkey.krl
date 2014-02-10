
ruleset NameOrMonkey {
    meta {
        name "Lab 2 cs462"
        author "Mercedes Kurtz"
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule first_task {
        select when pageview ".*" setting ()
        // Display notification that will not fade.
        notify("Hello World", "This is a sample rule.") with sticky = true;
    }
}