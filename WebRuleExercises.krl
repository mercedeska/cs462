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
            num = get_num(a)
        }
        if num == 1 then {
            //notify(output, no_and)
            noop()
        } fired {
            clear ent:firstname;
            clear ent:lastname;
        }
    }

    rule initialize {
        select when pageview '.*'
        pre {
            blank_div = << <div id="my_div"></div> >>;
        }
        notify("Hello Example", blank_div) with sticky = true;
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
        if (not ent:username) then {
            append("#my_div", a_form);
            watch("#my_form", "submit");
        }
        //{
            //notify("Hello World", q.length()) with sticky = true;
          //  replace_html("#`main", main_paragraph);
       //L }
    }

    rule respond_submit {
        select when web submit "#my_form"
        pre {
            firstname = event:attr("first");
            lastname = event:attr("last");
            username = event:attr("first")+" "+event:attr("last");
        }
        replace_inner("#my_div", "Hello #{username}");
        fired {
            set ent:firstname firstname;
            set ent:lastname lastname;
        }
    }

    rule replace_with_name {
        select when web pageview ".*"
        pre {
            firstname = current ent:firstname;
            lastname = current ent:lastname;
        }
        replace_inner("#my_div", "Hello #{firstname} #{lastname}");
    }
}