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
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Rotten Tomatoes movie deets right at your fingertips!", "bodyL", my_html);
    }
  }
  rule watch_me {
  select when pageview
    pre {
      myForm = <<
        <form id="formFood">
          <input type="text" name="myName">
          <button type="submit">Save</submit>
        </form>
      >>;
    }
    {
      append("body", myForm);
      CloudRain:skyWatchSubmit("#formFood", meta:eci());
    }
  }
  rule catch_submit {
    select when web submit "#formFood"
    pre {
      myName = event:attr("myName");
    }
    {
      notify("My Name is ...", myName);
    }
  }

  
}