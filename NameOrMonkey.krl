
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
                print_test = function(x) {
                    x
                };
                print_names = function(x) {
                    x.split(re/=/).tail().head();
                };
                a = print_names_test(pageQuery);
                //output = "Hello " + a;
                x = ent:test + 1;
                output = "Hello " + name + " " + x;
            }
            if pageQuery.match(re/(=)/) then {
                notify(output, pageQuery) with sticky = true;
            }
        }
        rule counter_task {
            select when pageview '.*'
            pre {
                x = ent:counter + 1;
                output = "amount: " + x;
            }
            if ent:counter > 6 then
                notify("Counter:", output);
        }
    }