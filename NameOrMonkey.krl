
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
                plus_one = ent:counter + 1;
                output = "Counter: " + plus_one;
            }
            if plus_one <= 5 then
                notify(output, "");
            always {
                ent:counter +=1 from 1;
            }
        }
        rule clear_task {
            select when pageview '.*'
            pre {
                pageQuery = page:url("query");
                no_and = pageQuery.replace(re/&/g,"=");
                clear_location = no_and.index("clear");
            }
            if clear_location >= 0 then
                notify("cleared", no_and)
        }
    }