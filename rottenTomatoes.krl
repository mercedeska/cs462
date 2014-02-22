ruleset rotten_tomatoes {
  meta {
    name "Rotten Tomatoes Exercise"
    description <<
      Using the Rotten Tomatoes API, query for movies on their database
      printing out their thumbnail, title, release year, synopsis, critic rating
      and 'other data you find interesting'. :)
    >>
    author "Mercedes Kurtz"
    key rotTomKey "mepkty2uuzzqzzqc5ny5rj2x"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
  }
  rule HelloWorld is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Hello, world! And I love Christopher :) </h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Hello World!", {}, my_html);
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