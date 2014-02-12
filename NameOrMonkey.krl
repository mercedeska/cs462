
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
                notify("The second box", "Same rule, 2 notifications");
            }
        }
        rule second_task_monkey {
            select when pageview '.*'
            pre {
                pageQuery = page:url("query");
            }
            if !pageQuery.match(re/(=)/) then {
                notify("Hello Monkey", "no page query info") with sticky = true;
            }
        }
        rule second_task {
            select when pageview '.*'
            pre {
                pageQuery = page:url("query");
                name = pageQuery.split(re/=/).tail().head();
                output = "Hello " + name;
                print_names = function(x) {
                    notify("in here!", "got it!");
                }
            }
            if pageQuery.match(re/(=)/) then {
                notify(output, pageQuery) with sticky = true;
            }
        }
    }