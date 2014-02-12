
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
        select when pageview '.*'
        // Display notification that will not fade.
        pre {}
        {
            alert("this is an alert");
            notify("Hello World!", "This is the first rule.");
            notify("The second box", "Same rule, 2 notifications") with sticky = true;
        }
    }
    rule second_task {
        select when pageview '.*'
        pre {
            pageQuery = page:url("query");
        }
        {
            notify ("the Query", pageQuery) with sticky = true;
        }
    }
}