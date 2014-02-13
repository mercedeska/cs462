
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
                no_and = pageQuery.replace(re/&/g,"=");
                a = no_and.split(re/=/);
                get_name = function(x) {
                    find_name = a.index("name");
                    ret = (find_name < 0) => "Monkey" |
                        a.slice(find_name+1, find_name+1).head();
                    ret
                };
                name = get_name(a);
                output = "Hello: " + name                
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
                a = pageQuery.split(re/=/);
                clear_location = a.index("clear");
                output = "clear at: " + clear_location + "done"
            }
            if clear_location >= 0 then
                notify(output, no_and)
            fired {
                clear ent:counter;
            }
        }
    }