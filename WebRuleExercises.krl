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

    rule clear_name {
            select when pageview '.*'
            pre {
                pageQuery = page:url("query");
                no_and = pageQuery.replace(re/&/g,"=");
                a = pageQuery.split(re/=/);
                clear_location = a.index("clear");
                output = "clear at: " + clear_location;
                get_num = function(x) {
                    ret = (clear_location < 0) => -1 |
                        a.slice(clear_location+1, clear_location+1).head();
                    ret
                };
                num = get_num(a);
            }
            if num == 1 then
                notify(output, no_and)
                //noop()
            fired {
                clear ent:username;
            }
        }

    rule show_form {
        select when pageview ".*"
        // Display notification that will not fade.
        pre {
            main_paragraph = <<
                <div id="main">
                    Look at my awesome website that I am making! Woo :)
                </div> >>;
            a_form = <<
                <form id="my_form" onsubmit="return false">
                    <input type="text" name="first"/>
                    <input type="text" name="last"/>
                    <input type="submit" value="Submit" />
                </form> >>;
        }
        {
            //notify("Hello World", q.length()) with sticky = true;
            replace_html("#`main", main_paragraph);
        }
    }
}