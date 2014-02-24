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
  rule HelloWorld {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Trying to add the form </h5>
        <div id="main">
          This code will all be replaced.
        </div> >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Rotten Tomatoes movie deets right at your fingertips!", {}, my_html);
    }
  }
  

  rule send_form {
        select when pageview ".*"
        // Display notification that will not fade.
        pre {
            a_form = <<
                <form id="my_form" onsubmit="return false">
                    <input type="text" name="first"/>
                    <input type="text" name="last"/>
                    <input type="submit" value="Submit" />
                </form> >>;
        }
        {
            replace_inner("#main", a_form);
            watch("#my_form", "submit");
        }
        //{
            //notify("Hello World", q.length()) with sticky = true;
          //  replace_html("#`main", main_paragraph);
       //L }
    }


  
}