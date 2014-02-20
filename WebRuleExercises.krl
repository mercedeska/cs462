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

    rule on_page {
        select when pageview ".*"
        pre {
            init_div = << <div id="main">This is my paragraph</div> >>;
        }
        replace_inner('#main','Please enter your first and last name and click submit');
    }    

    rule send_form {
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
        if (not ent:firstname) then {
            append("#main", a_form);
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
        }
        replace_inner("#main", "Hello #{firstname} #{lastname}");
        fired {
            set ent:firstname firstname;
            set ent:lastname lastname;
        }
    }

    rule replace_with_name {
        select when web pageview ".*"
        pre {
            firstname = ent:firstname;
            lastname = ent:lastname;
            output = "Hello " + firstname + " " + lastname;
        }
        if ent:firstname then {
            replace_inner("#main", output);
        }
    }
}